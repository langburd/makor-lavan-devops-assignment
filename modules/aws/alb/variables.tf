variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  type        = string
}

variable "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  type        = string
}
