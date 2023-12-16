output "ingress_nginx_elb_hostname" {
  description = "The hostname of the ingress nginx ELB"
  value       = data.kubernetes_service.ingress_nginx.status[0].load_balancer[0].ingress[0].hostname
}

output "app_name" {
  description = "The name of the app"
  value       = var.app_name
}

output "app_url" {
  description = "The URL of the app"
  value       = "https://${var.app_name}.${var.hosted_zone_name}"
}
