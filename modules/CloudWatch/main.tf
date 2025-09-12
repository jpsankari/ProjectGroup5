provider "aws" {
  region = "us-east-1"
  alias  = "cloudwatch"
}

module "cloudwatch" {
  source  = "./modules/cloudwatch"

  providers = {
    aws = aws.cloudwatch
  }
}
