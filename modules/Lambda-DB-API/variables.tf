variable "env" {
  type    = string
  default = ""
}

variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "ap-southeast-1"  
}

variable "log_group_name" {
  type = string
  description = "CloudWatch Log Group name from CloudFront module"
}

variable "log_group_arn" {
  type = string
  description = "CloudWatch Log Group ARN from CloudFront module"
}
