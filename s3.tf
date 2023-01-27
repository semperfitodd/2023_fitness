data "aws_iam_policy_document" "fitness_site" {
  statement {
    effect = "Allow"
    principals {
      identifiers = module.cdn.cloudfront_origin_access_identity_iam_arns
      type        = "AWS"
    }
    actions   = ["s3:GetObject"]
    resources = ["${module.fitness_site.s3_bucket_arn}/*"]
  }
}

locals {
  fitness_site_domain = "fitness.${var.domain}"
}

module "fitness_site" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.fitness_site_domain

  attach_public_policy = true
  attach_policy        = true
  policy               = data.aws_iam_policy_document.fitness_site.json

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  expected_bucket_owner = data.aws_caller_identity.current.account_id

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = var.tags
}