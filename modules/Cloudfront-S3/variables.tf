variable "env" {
  description = "The environment (e.g., dev, prod) for the infrastructure"
  type        = string
  default     = "" # You can set the default to whatever environment you are working in
}

# Declare the `aliases` variable
variable "aliases" {
  description = "Custom domain aliases for the CloudFront distribution (optional)."
  type        = list(string)
  default     = [] # No aliases by default, set to your custom domain if needed.
}

# Declare the `web_acl_id` variable
variable "web_acl_id" {
  description = "The ID of the Web ACL associated with CloudFront (optional)."
  type        = string
  default     = "" # Leave empty if not using AWS WAF.
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN (must be in us-east-1)"
  type        = map(string)
  default = {
    dev   = "arn:aws:acm:us-east-1:255945442255:certificate/0cbd44fb-a8b2-4a63-a6ac-c5d962458da9"
    prod  = "arn:aws:acm:us-east-1:255945442255:certificate/56f8abea-c814-463b-84dc-f82255101f4b"
  }
}

# Declare the `waf_logs` variable
variable "waf_logs" {
  description = "The ID of the Web ACL associated with CloudFront (optional)."
  type        = string
  default     = "" # Leave empty if not using AWS Cloudwtch.
}

variable "existing_waf_acl_arn" {
  description = "ARN of an existing WAF ACL to associate with CloudFront. Leave empty to create a new one."
  type        = string
  default     = ""
}

