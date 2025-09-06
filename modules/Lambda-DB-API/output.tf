output "post_integration_id" {
  value = aws_api_gateway_integration.lambda_integration.id
}

output "api_endpoint" {
value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.api_stage.stage_name}"
}

output "api_invoke_url" {
  value = "https://${aws_api_gateway_rest_api.example.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_deployment.example.stage_name}"
}