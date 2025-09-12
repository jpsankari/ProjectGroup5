
provider "aws" {
  region = "us-east-1"
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  name   = "cloudwatch-log-group"
  env    = "production"
}
