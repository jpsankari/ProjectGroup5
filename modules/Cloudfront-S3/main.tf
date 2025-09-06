#=============================================
# S3 Bucket for Static Website
#=============================================
# Define the S3 bucket
resource "aws_s3_bucket" "static_site" {
  bucket = "${var.env}-oneclickbouquet-static-site"

  # Enables website hosting on this S3 bucket
  force_destroy = true # Deletes objects in the bucket when deleting the bucket
}

# Website configuration for the S3 bucket
resource "aws_s3_bucket_website_configuration" "static_site_website" {
  bucket = aws_s3_bucket.static_site.bucket

  # Define index and error documents
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

#=====================================================
# S3 Bucket Policy to Allow CloudFront Access
#=====================================================
resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.static_site.id

  policy = data.aws_iam_policy_document.default.json
}

#=====================================================
# CloudFront Distribution
#=====================================================
resource "aws_cloudfront_distribution" "s3_distribution" {
  provider = aws.virginia
  origin {
    domain_name              = aws_s3_bucket.static_site.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "origin-${aws_s3_bucket.static_site.id}"
  }

  aliases = [
  var.env == "prod" ?
  "oneclickbouquet.sctp-sandbox.com" :
  "${var.env}-oneclickbouquet.sctp-sandbox.com"
  
  ]
  enabled             = true
  comment             = "Static Website using S3 and Cloudfront OAC in ${var.env} environment"
  default_root_object = "index.html"


  default_cache_behavior {
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "origin-${aws_s3_bucket.static_site.id}"
    #viewer_protocol_policy = "allow-all"
    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
  acm_certificate_arn            = var.acm_certificate_arn[var.env]
  ssl_support_method             = "sni-only"
  #minimum_protocol_version       = "TLSv1.2_2021"
  minimum_protocol_version = "TLSv1.2_2019"
  cloudfront_default_certificate = false
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  web_acl_id =  aws_wafv2_web_acl.oneclickbouquet_cloudfront_waf.arn
}

#==================================================
# CloudFront Origin Access Control
#==================================================
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${aws_s3_bucket.static_site.id}-oac-${var.env}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#==================================================
# Cloud Watch
#================================================
resource "aws_cloudwatch_log_group" "central_log_group" {
  provider          = aws.virginia
  name              = "/aws/oneclickbouquet/${aws_wafv2_web_acl.oneclickbouquet_cloudfront_waf.name}"
  retention_in_days = 1
}



#==================================================
# WAFv2 for CloudFront
#================================================

resource "aws_wafv2_web_acl" "oneclickbouquet_cloudfront_waf" {
  provider = aws.virginia
  name  = "oneclickbouquet_cloudfront-waf-${var.env}"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cloudfrontWAF"
    sampled_requests_enabled   = true
  }

 # Rule 1: 
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
      
    }

    override_action {
      none {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
 # Rule 2: Block Malicious IPs

 rule {
    name     = "BlockMaliciousIPs"
    priority = 2

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.malicious_ips.arn
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockMaliciousIPs"
    }
  }

}

resource "aws_wafv2_ip_set" "malicious_ips" {
  provider = aws.virginia
  name               = "malicious-ip-set-${var.env}"
  description        = "Block known malicious IPs"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"

  addresses = [
    "45.155.205.233/32",
    "185.220.101.26/32",
    "103.27.124.82/32",
    "198.98.50.163/32",
    "37.120.247.75/32",
    "89.248.165.186/32",
    "179.43.159.195/32",
    "156.146.62.55/32",
  ]

  tags = {
    Name = "malicious-ip-set"
  }
}

