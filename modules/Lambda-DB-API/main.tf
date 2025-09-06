module "cloudfront" {
  source   = "../Cloudfront-S3"
}

#=========================================
# DynamoDB Table
#=========================================
resource "aws_dynamodb_table" "OneClickBouquet_orders" {
  name         = "OneClickBouquet_orders_${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "order_id"
  point_in_time_recovery {
    enabled = true      
  }

  attribute {
    name = "order_id"
    type = "S"
  }
}

#========================================
# IAM Role for Lambda
#========================================

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role_${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}

EOF
}
#=========================================
#Additional policy for Lambda Full access
#=========================================
resource "aws_iam_role_policy_attachment" "lambda_full_access_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}
#=========================================
#Additional policy for DynamoDB
#=========================================
resource "aws_iam_role_policy_attachment" "dynamodb_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

#=========================================
#Additional policy for Lambda S3
#=========================================
resource "aws_iam_role_policy_attachment" "lambda_s3_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonS3ObjectLambdaExecutionRolePolicy"
}
#=======================================
# IAM Policy for Lambda to access SES
#========================================
resource "aws_iam_policy" "lambda_ses_policy" {
  name = "lambda_ses_policy_${var.env}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ses:SendEmail",
            "Resource": "*"
        }
    ]
}
EOF
}

# Attach SES policy to Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_exec_role_ses" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_ses_policy.arn
}

#========================================
# Lambda Function for processing orders
#========================================
data "archive_file" "dynamodb_lambda_function" {
  type = "zip"
  source_file = "../../lambda_function.py"
  output_path = "../../process_order.zip"
}

resource "aws_lambda_function" "process_order" {
  function_name = "process_order_${var.env}"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  filename = "process_order.zip" # Prepackaged Lambda code
  role     = aws_iam_role.lambda_exec_role.arn
  timeout  = 10

  environment {
    variables = {
      DYNAMODB_TABLE   = aws_dynamodb_table.OneClickBouquet_orders.name
    }
  }
  tracing_config {
    mode = "Active"
  }
  
}

#=========================================
# API Gateway for Lambda
#=========================================
resource "aws_api_gateway_rest_api" "api" {
  name        = "OneClickBouquetAPI_${var.env}"
  description = "API for processing flower bouquet orders"
}

resource "aws_api_gateway_resource" "orders_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "orders"
}

resource "aws_api_gateway_method" "orders_post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.orders_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.orders_resource.id
  http_method             = aws_api_gateway_method.orders_post.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.process_order.invoke_arn
}

# Integration Response for POST
resource "aws_api_gateway_integration_response" "post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.orders_resource.id
  http_method = aws_api_gateway_method.orders_post.http_method
  status_code = "200"

  depends_on = [aws_api_gateway_integration.lambda_integration]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
  }
}

# Method Response for POST
resource "aws_api_gateway_method_response" "post_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.orders_resource.id
  http_method = aws_api_gateway_method.orders_post.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

# OPTIONS Method (for CORS)
resource "aws_api_gateway_method" "orders_options" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.orders_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# OPTIONS Integration (MOCK integration for CORS)
resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.orders_resource.id
  http_method             = aws_api_gateway_method.orders_options.http_method
  type                    = "MOCK"
  integration_http_method = "OPTIONS"
  
  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }
}

# Integration Response for OPTIONS (CORS headers)
resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.orders_resource.id
  http_method = aws_api_gateway_method.orders_options.http_method
  status_code = "200"

  depends_on = [aws_api_gateway_integration.options_integration]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
  }

}


# Method Response for OPTIONS (CORS headers)
resource "aws_api_gateway_method_response" "options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.orders_resource.id
  http_method = aws_api_gateway_method.orders_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}


resource "aws_api_gateway_deployment" "api_deployment" {

  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration_response.post_integration_response,
    aws_api_gateway_method_response.post_method_response,
    aws_api_gateway_integration.options_integration,
    aws_api_gateway_integration_response.options_integration_response,
    aws_api_gateway_method_response.options_method_response
  ]

lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = var.env
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  xray_tracing_enabled = true
  variables = {
    lambdaAlias = var.env
  }
   access_log_settings {
    destination_arn = module.cloudfront.central_log_group_arn
    format          = jsonencode({
      requestId = "$context.requestId"
      ip        = "$context.identity.sourceIp"
      caller    = "$context.identity.caller"
      user      = "$context.identity.user"
      requestTime = "$context.requestTime"
      httpMethod = "$context.httpMethod"
      resourcePath = "$context.resourcePath"
      status = "$context.status"
      protocol = "$context.protocol"
    })
  } 
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_order.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

