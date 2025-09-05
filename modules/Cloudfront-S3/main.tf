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

  web_acl_id = local.waf_arn 
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
  name              = "/aws/oneclickbouquet/${aws_wafv2_web_acl.oneclickbouquet_cloudfront_waf[0].name}"
  retention_in_days = 1

  lifecycle {
    prevent_destroy = true
  }
}



#==================================================
# WAFv2 for CloudFront
#================================================

resource "aws_wafv2_web_acl" "oneclickbouquet_cloudfront_waf" {
  count    = var.existing_waf_acl_arn == "" ? 1 : 0
  provider = aws.virginia
  name  = "oneclickbouquet_cloudfront-waf"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cloudfrontWAF"
    sampled_requests_enabled   = true
  }

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
    lifecycle {
    prevent_destroy = true
  }
}

locals {
  waf_arn = var.existing_waf_acl_arn != "" ? var.existing_waf_acl_arn : (
    length(aws_wafv2_web_acl.oneclickbouquet_cloudfront_waf) > 0 ?
    aws_wafv2_web_acl.oneclickbouquet_cloudfront_waf[0].arn :
    null
  )
}


#==================================================
# WAFv2 for Cloudwatch Logs
#================================================

resource "aws_wafv2_web_acl_logging_configuration" "waf_logsample" {
count = var.existing_waf_acl_arn == "" ? 1 : 0
provider = aws.virginia
resource_arn = aws_wafv2_web_acl.oneclickbouquet_cloudfront_waf[0].arn
  

  log_destination_configs = [
    aws_kinesis_firehose_delivery_stream.waf_logs.arn
  ]
}

resource "aws_kinesis_firehose_delivery_stream" "waf_logs" {
  name        = "onceclick-waf-logs-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    bucket_arn         = aws_s3_bucket.waf_log_bucket.arn
    buffering_interval = 300
    buffering_size     = 5
  }
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_delivery_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "firehose.amazonaws.com"
      }
    }]
  })
}

resource "aws_s3_bucket" "waf_log_bucket" {
  bucket = "oneclickflower-waf-logs-bucket"
}
