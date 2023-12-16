terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
    }
  }
}

resource "aws_acm_certificate" "this" {
  domain_name               = "${var.app_name}.${var.hosted_zone_name}"
  subject_alternative_names = ["*.${var.app_name}.${var.hosted_zone_name}"]
  validation_method         = "DNS"

  tags = var.tags
}

resource "aws_route53_record" "certificate" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.certificate : record.fqdn]
}
