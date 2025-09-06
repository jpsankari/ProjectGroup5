output "log_group_name" {
  description = "Name of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.this.name
}
output "log_stream_name" {
  description = "Name of the CloudWatch Log Stream"
  value       = aws_cloudwatch_log_stream.this.name
}

output "metric_filter_name" {
  description = "Name of the CloudWatch Metric Filter"
  value       = aws_cloudwatch_metric_filter.this.name
}