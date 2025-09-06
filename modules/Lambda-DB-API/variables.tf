variable "env" {
  type    = string
  default = ""
}

variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "ap-southeast-1"  
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

variable "cloudwatch_log_group_name" {
  type = string
}

variable "cloudwatch_log_group_arn" {
  type = string
}
