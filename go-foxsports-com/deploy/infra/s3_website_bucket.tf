resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.environment_name}-${var.app_name}"
  tags = {
    environemnt = var.environment_name
    app_name    = var.app_name
    repo_name   = var.repo_name
    region      = var.region
    managed_by  = "terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_public_access" {
  bucket                  = aws_s3_bucket.website_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_get_access_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.public_website_restricted_policy.json
}

resource "aws_s3_bucket_website_configuration" "website_bucket_website_configuration" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

data "aws_iam_policy_document" "public_website_restricted_policy" {
  statement {
    sid = "Allow only GET requests"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.website_bucket.arn, "${aws_s3_bucket.website_bucket.arn}/*"
    ]
  }
}

output "s3_bucket_website" {
  description = "The s3 bucket website domain"
  value       = aws_s3_bucket_website_configuration.website_bucket_website_configuration.website_domain
}

output "s3_bucket_website_endpoint" {
  description = "The s3 bucket website endpoint"
  value       = aws_s3_bucket_website_configuration.website_bucket_website_configuration.website_endpoint
}
