variable "env" {
  description = "The environment (e.g., dev, prod) for the infrastructure"
  type        = string
  default     = "" # You can set the default to whatever environment you are working in
}

variable "name" {
  description = "Name of the CloudWatch Log Group"
  type        = string
}

variable "retention_in_days" {
  description = "Number of days to retain the logs"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags to apply to the Log Group"
  type        = map(string)
  default     = {}
}
variable "log_stream_name" {
  description = "Name of the CloudWatch Log Stream"
  type        = string
  default     = "default-log-stream"
}

variable "metric_filter_name" {
  description = "Name of the CloudWatch Metric Filter"
  type        = string
  default     = "ExampleMetricFilter"
}

variable "metric_filter_pattern" {
  description = "Pattern for the metric filter"
  type        = string
  default     = ""
}

variable "metric_name" {
  description = "Name of the metric to emit"
  type        = string
  default     = "ExampleMetric"
}

variable "metric_namespace" {
  description = "Namespace for the metric"
  type        = string
  default     = "MyAppNamespace"
}

variable "metric_value" {
  description = "Value to emit when the filter matches"
  type        = string
  default     = "1"
}

variable "metric_unit" {
  description = "Unit for the metric"
  type        = string
  default     = "Count"
}