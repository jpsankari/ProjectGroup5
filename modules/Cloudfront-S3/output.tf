output "cloudfront_domain" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "bucket_name" {
  value = aws_s3_bucket.static_site.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.static_site.arn
}

output "s3_distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}

output "central_log_group_name" {
  value = aws_cloudwatch_log_group.central_log_group.name
}

output "central_log_group_arn" {
  value = aws_cloudwatch_log_group.central_log_group.arn
}

