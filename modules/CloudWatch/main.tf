provider "aws" {
  region = "us-east-1"  # adjust as needed
}

# Create an S3 bucket to store CloudTrail logs
resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "oneclickbouquet-cloudtrail-logs-bucket"  # change to your unique name

  # Optional: lock bucket to prevent deletion
  lifecycle {
    prevent_destroy = true
  }
}

# Create a CloudWatch Log Group for CloudTrail
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/oneclickbouquet/cloudtrail/mytrail"
  retention_in_days = 90
}

# IAM Role for CloudTrail to write logs to CloudWatch Logs
resource "aws_iam_role" "cloudtrail_role" {
  name = "cloudtrail-cloudwatch-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
    }]
  })
}

# IAM Policy for the role, allowing logs write permission
resource "aws_iam_role_policy" "cloudtrail_policy" {
  name = "cloudtrail-cloudwatch-logs-policy"
  role = aws_iam_role.cloudtrail_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:PutLogEvents",
        "logs:CreateLogStream"
      ]
      Resource = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
    }]
  })
}

# Create the CloudTrail
resource "aws_cloudtrail" "mytrail" {
  name                          = "my-s3-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  # Send CloudTrail logs to CloudWatch Logs
  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.cloudtrail.arn
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_role.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }
}

# Example S3 bucket you want to monitor
resource "aws_s3_bucket" "mybucket" {
  bucket = "prod-oneclickbouquet-static-site"  # change to your unique bucket name
}
