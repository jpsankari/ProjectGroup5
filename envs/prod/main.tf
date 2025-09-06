locals {
  env           = "prod"
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
    log_group_arn  =  module.cloudfront-s3.central_log_group_arn
  log_group_name =  module.cloudfront-s3.central_log_group_name
}