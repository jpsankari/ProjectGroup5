locals {
  env           = "dev"
  domain_prefix = "OneClickBouquet"
  zone_name     = "sctp-sandbox.com"
}


module "cloudfront-s3" {
  source = "../../modules/Cloudfront-S3"
  env    = local.env
}


module "lambda-db-api" {
  source = "../../modules/Lambda-DB-API"  
  env    = local.env
}

module "cloudwatch" {
 source = "../../modules/CloudWatch"

  providers = {
    aws = aws.cloudwatch
  }
}
