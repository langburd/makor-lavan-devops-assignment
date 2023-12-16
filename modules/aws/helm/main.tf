# Providers
terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
  }
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  debug = true

  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

# Nginx Ingress Controller
resource "helm_release" "ingress_nginx" {
  name          = "ingress-nginx"
  repository    = "https://kubernetes.github.io/ingress-nginx"
  namespace     = "kube-system"
  chart         = "ingress-nginx"
  version       = "4.8.3"
  recreate_pods = true
  values = [
    templatefile("${path.module}/templates/ingress-nginx.tpl", {
      certificate_arn = var.certificate_arn
    })
  ]
}

data "kubernetes_service" "ingress_nginx" {
  metadata {
    namespace = helm_release.ingress_nginx.namespace
    name      = "${helm_release.ingress_nginx.name}-controller"
  }
  depends_on = [helm_release.ingress_nginx]
}

# Application
resource "kubernetes_namespace" "app" {
  metadata {
    name = var.app_name
  }
}

resource "helm_release" "app" {
  name      = var.app_name
  namespace = kubernetes_namespace.app.metadata[0].name
  chart     = abspath("${path.module}/../../../../../../../helm")
  values = [
    templatefile("${path.module}/templates/app.tpl", {
      app_environment = var.app_environment
      app_name        = var.app_name
      host_name       = "${var.app_name}.${var.hosted_zone_name}"
    })
  ]
  depends_on = [kubernetes_namespace.app]
}
