output "post_integration_id" {
  value = aws_api_gateway_integration.lambda_integration.id
}

output "api_endpoint" {
value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.api_stage.stage_name}"
}
output "central_log_group_name" {
  value = aws_cloudwatch_log_group.central_log_group.name
}

output "central_log_group_arn" {
  value = aws_cloudwatch_log_group.central_log_group.arn
}
