terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
    }
  }
}

data "aws_elb_hosted_zone_id" "this" {}

data "aws_lb" "app" {
  name = var.app_name
}

# DNS record for application
resource "aws_route53_record" "app" {
  zone_id = var.hosted_zone_id
  name    = var.app_name
  type    = "A"

  alias {
    name                   = data.aws_lb.app.dns_name
    zone_id                = data.aws_elb_hosted_zone_id.this.id
    evaluate_target_health = true
  }
}
