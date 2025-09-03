# modules/waf/waf.tf
resource "aws_wafv2_web_acl" "cloudfront_waf" {
  name        = var.name
  description = "Shared WAF for dev and prod"
  scope       = var.scope # "REGIONAL" for API Gateway, "CLOUDFRONT" for CDN

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.name
    sampled_requests_enabled   = true
  }

  rule {
    name     = "LimitRequests"
    priority = 1
    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "LimitRequests"
    }
  }
}

output "web_acl_arn" {
  value = aws_wafv2_web_acl.shared_acl.arn
}
