resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
  name                              = "${local.bucket_name} Cloudfront S3 OAC"
  description                       = "${local.bucket_name} Cloudfront S3 OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cf_dist" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    origin_id   = "${local.bucket_name}-origin"
    domain_name = "${local.bucket_name}.s3.${local.region}.amazonaws.com"
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "${local.bucket_name}-origin"
    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 0

    forwarded_values {
      headers      = []
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    managed_by = "terraform"
  }
}

output "cf_hostname" {
  description = "Cloudfront Hostname:"
  value       = aws_cloudfront_distribution.cf_dist.domain_name
}