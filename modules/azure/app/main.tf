# Providers
terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.85.0, < 4.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.24.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~>2.12.1"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.this.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.this.kube_config[0].host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
  }
}

# Application
resource "helm_release" "app" {
  name             = var.app_name
  namespace        = var.app_name
  create_namespace = true
  chart            = abspath("${path.module}/../../../../../../../helm")
  force_update     = true
  recreate_pods    = true
  cleanup_on_fail  = true
  values = [
    templatefile("${path.module}/templates/app.tpl", {
      app_environment = var.app_environment
      app_name        = var.app_name
      host_name       = "${var.app_name}.${var.hosted_zone_name}"
    })
  ]
}
