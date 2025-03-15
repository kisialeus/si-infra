resource "aws_acm_certificate" "argocd_cert" {
  domain_name       = "argocd.${var.domain_name}"
  validation_method = "DNS"

  subject_alternative_names = [
    "www.argocd.${var.domain_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "argocd_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.argocd_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.domain.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "argocd_cert_validation" {
  certificate_arn         = aws_acm_certificate.argocd_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.argocd_cert_validation : record.fqdn]
}
