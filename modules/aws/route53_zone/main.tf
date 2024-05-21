terraform {
  required_version = ">= 1.5.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
    }
  }
}

# Main DNS zone
resource "aws_route53_zone" "this" {
  name = var.hosted_zone_name
  tags = var.tags
}
