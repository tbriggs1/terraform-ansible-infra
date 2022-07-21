resource "aws_acm_certificate" "cert" {
  domain_name = "cropmanagementdev.com"
  validation_method = "DNS"
  depends_on = [
    module.alb
  ]

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "cert" {
  name         = "cropmanagementdev.com"
  private_zone = false
}


resource "aws_route53_record" "cert-record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.cert.zone_id
}

resource "aws_acm_certificate_validation" "cert-val" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert-record : record.fqdn]
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.cert.zone_id
  name = "cropmanagementdev.com"
  type = "A"

  alias {
    name = module.alb.lb_dns_name
    zone_id = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}