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
