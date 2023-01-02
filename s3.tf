data "aws_iam_policy_document" "fitness_site" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["*"]
      type        = "*"
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

  website = {
    index_document = "index.html"
  }

  tags = var.tags
}

resource "aws_s3_object" "index" {
  bucket = module.fitness_site.s3_bucket_id
  key    = "index.html"
  source = "${path.module}/index.html"

  etag = filemd5("${path.module}/index.html")
}