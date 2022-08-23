resource "aws_cloudfront_origin_access_identity" "cloudfront_oai" {
  comment = "CloudFront OAI for ${aws_s3_bucket.public_assets.bucket}"
}

resource "aws_cloudfront_distribution" "www" {
  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2"
  price_class     = var.price_class

  aliases = [var.domain_name]
  default_root_object = "index.html"

  viewer_certificate {
    acm_certificate_arn = module.www_certificate.arn
    minimum_protocol_version = "TLSv1"
    ssl_support_method = "sni-only"
  }

  custom_error_response {
    error_caching_min_ttl = var.cache_ttl
    response_page_path    = "/404.html"
    error_code    = 403
    response_code = 404
  }

  origin {
    domain_name = aws_s3_bucket.public_assets.bucket_domain_name
    origin_id   = "s3-bucket-public-assets"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-bucket-public-assets"

    compress = true
    viewer_protocol_policy = "redirect-to-https"

    default_ttl = var.cache_ttl
    min_ttl     = (var.cache_ttl / 4) < 60 ? 0 : floor(var.cache_ttl / 4)
    max_ttl     = floor(var.cache_ttl * 24)

    forwarded_values {
      query_string = true
      headers      = ["Origin"]

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

  logging_config {
    include_cookies = false

    bucket = aws_s3_bucket.logs.bucket_domain_name
    prefix = "cloudfront-www/"
  }
}

resource "aws_route53_record" "www-a_record" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                    = aws_cloudfront_distribution.www.domain_name
    zone_id                 = aws_cloudfront_distribution.www.hosted_zone_id
    evaluate_target_health  = false
  }
}