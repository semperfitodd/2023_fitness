resource "aws_route53_record" "fitness_site" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.fitness_site_domain
  type    = "A"

  alias {
    name                   = module.cdn.cloudfront_distribution_domain_name
    zone_id                = module.cdn.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = true
  }
}