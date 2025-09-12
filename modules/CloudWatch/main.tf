
provider "aws" {
  region = "us-east-1"
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"
  providers = {
    aws = aws
  }
  # ...
}
