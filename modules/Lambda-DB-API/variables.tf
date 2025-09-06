variable "env" {
  type    = string
  default = ""
}

variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "ap-southeast-1"  
}

variable "static_site_bucket_id" {
  description = "ID of the static site S3 bucket"
  type        = string
}
