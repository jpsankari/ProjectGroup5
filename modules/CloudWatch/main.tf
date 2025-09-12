
provider "aws" {
  region = "us-east-1"
}

module "cloudwatch" {
  source = "../../modules/CloudWatch"
  name   = "cloudwatch-log-group"
  env    = "production"
}