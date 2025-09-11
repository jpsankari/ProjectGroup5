resource "aws_cloudwatch_log_group" "this" {
  name              = var.name
  retention_in_days = var.retention_in_days
  tags              = var.tags
}

resource "aws_cloudwatch_log_stream" "this" {
  count          = var.log_stream_name != null ? 1 : 0
  name           = var.log_stream_name
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  count          = var.metric_filter_name != null ? 1 : 0
  name           = var.metric_filter_name
  log_group_name = aws_cloudwatch_log_group.this.name
  pattern        = var.metric_filter_pattern

  metric_transformation {
    name      = var.metric_name
    namespace = var.metric_namespace
    value     = var.metric_value
    unit      = var.metric_unit
  }
}

resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  count                = var.enable_alarm ? 1 : 0
  alarm_name           = var.alarm_name
  comparison_operator  = "GreaterThanThreshold"
  evaluation_periods   = 1
  metric_name          = var.metric_name
  namespace            = var.metric_namespace
  period               = var.alarm_period
  statistic            = "Sum"
  threshold            = var.alarm_threshold
  alarm_description    = "Alarm when ${var.metric_name} exceeds ${var.alarm_threshold}"
  treat_missing_data   = "notBreaching"
  alarm_actions        = var.alarm_actions
}
