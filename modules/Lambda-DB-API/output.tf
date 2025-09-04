output "post_integration_id" {
  value = aws_api_gateway_integration.lambda_integration.id
}

output "api_endpoint" {
value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.ap-southeast-1.amazonaws.com/${aws_api_gateway_stage.api_stage.stage_name}"
 
}