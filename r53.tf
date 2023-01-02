resource "aws_route53_record" "fitness_site" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.fitness_site_domain
  type    = "A"

  alias {
    name                   = module.fitness_site.s3_bucket_website_domain
    zone_id                = module.fitness_site.s3_bucket_hosted_zone_id
    evaluate_target_health = true
  }
}