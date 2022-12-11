locals {
  s3_origin_id                    = "${var.bucket_name}-oid"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {

}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name                   = "${aws_s3_bucket.s3_bucket.bucket_regional_domain_name}"
    origin_id                     = "${local.s3_origin_id}"
  }

  enabled                         = true
  is_ipv6_enabled                 = true

  default_root_object             = "index.html" 

  default_cache_behavior {
    # allowed_methods         = ["HEAD", "GET", "OPTIONS", "PATCH", "POST", "PUT"]
    allowed_methods               = ["HEAD", "GET"]
    cached_methods                = ["HEAD", "GET"]
    target_origin_id              = "${local.s3_origin_id}"

    forwarded_values {
      query_string                = false
      cookies {
        forward                   = "none"
      }
    }

    viewer_protocol_policy        = "redirect-to-https"
    min_ttl                       = 0
    default_ttl                   = 3600
    max_ttl                       = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type              = "none"
      }
  }

  price_class                       = "${var.cloudfront_price_class}"

  viewer_certificate {
    cloudfront_default_certificate  = true
  }
    
  tags = {
    description                     = "${var.component_prefix}-${var.cloudfront_cdn}"
    name                            = "${var.component_prefix}-${var.cloudfront_cdn}"
  }
}