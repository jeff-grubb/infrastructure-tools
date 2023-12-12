resource "aws_cloudfront_distribution" "cf_dist" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket_website_configuration.website_bucket_website_configuration.website_endpoint
    origin_id   = aws_s3_bucket_website_configuration.website_bucket_website_configuration.id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = aws_s3_bucket_website_configuration.website_bucket_website_configuration.id
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
