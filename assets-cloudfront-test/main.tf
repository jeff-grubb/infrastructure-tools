resource "aws_s3_bucket" "images_bucket" {
  bucket = local.bucket_name
  tags = {
    environemnt = "dev"
    managed_by  = "terraform"
  }
}

#resource "aws_s3_bucket" "logging_bucket" {
#  bucket = "${local.bucket_name}_cf_logs"
#  tags = {
#    environemnt = "dev"
#    managed_by  = "terraform"
#  }
#}

resource "aws_s3_bucket_public_access_block" "imagesBucketBlock" {
  bucket = aws_s3_bucket.images_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Test object
resource "aws_s3_object" "healthcheck" {
  bucket = local.bucket_name
  key = "healthcheck"
  source = "healthcheck.txt"
  etag = filemd5("healthcheck.txt")
  content_type = "text"
}

data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    sid = "AllowPublicRead"
    actions = [ "s3:GetObject" ]
    resources = [ "${aws_s3_bucket.images_bucket.arn}/*" ]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]
    }
  }
  statement {
    sid = "AllowCloudFront"
    actions = [ "s3:GetObject" ]
    resources = [ "${aws_s3_bucket.images_bucket.arn}/*" ]
    principals {
      type = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.cf_dist.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cdn-oac-bucket-policy" {
  bucket = local.bucket_name
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

resource "aws_s3_bucket_cors_configuration" "corsConfig" {
  bucket = aws_s3_bucket.images_bucket.id

  cors_rule {
    allowed_methods = ["PUT"]
    allowed_origins = [
      "http://dev.pdp.fox",
      "http://stage.pdp.fox",
      "http://www.pdp.fox",
    ]
    allowed_headers = [
      "*"
    ]
  }
}
