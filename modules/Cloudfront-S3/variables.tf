variable "env" {
  description = "The environment (e.g., dev, prod) for the infrastructure"
  type        = string
  default     = "" # You can set the default to whatever environment you are working in
}

# Declare the `aliases` variable
variable "aliases" {
  description = "Custom domain aliases for the CloudFront distribution (optional)."
  type        = list(string)
  default     = ["oneclickbouquet"] # No aliases by default, set to your custom domain if needed.
}

# Declare the `web_acl_id` variable
variable "web_acl_id" {
  description = "The ID of the Web ACL associated with CloudFront (optional)."
  type        = string
  default     = "" # Leave empty if not using AWS WAF.
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN (must be in us-east-1)"
  type        = string
  default = "arn:aws:acm:us-east-1:255945442255:certificate/56f8abea-c814-463b-84dc-f82255101f4b"
}
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

# Declare the `waf_logs` variable
variable "waf_logs" {
  description = "The ID of the Web ACL associated with CloudFront (optional)."
  type        = string
  default     = "" # Leave empty if not using AWS Cloudwtch.
}
