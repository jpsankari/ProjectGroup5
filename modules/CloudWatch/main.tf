
provider "aws" {
  region = "us-east-1"
}
module "cloudwatch" {
  source = "./modules/cloudwatch"
  env    = "production"
  name   = "cloudwatch-log-group"
}
