variable "name" {}
variable "retention_in_days" { default = 7 }
variable "tags" {
  type    = map(string)
  default = {}
}

variable "env" {
  type = string
}

variable "log_stream_name" {
  type    = string
  default = null
}

# Metric Filter
variable "metric_filter_name" {
  type    = string
  default = null
}

variable "metric_filter_pattern" {
  type    = string
  default = null
}

variable "metric_name" {
  type    = string
  default = null
}

variable "metric_namespace" {
  type    = string
  default = null
}

variable "metric_value" {
  type    = string
  default = "1"
}

variable "metric_unit" {
  type    = string
  default = "Count"
}

# Alarm
variable "enable_alarm" {
  type    = bool
  default = false
}

variable "alarm_name" {
  type    = string
  default = null
}

variable "alarm_threshold" {
  type    = number
  default = 1
}

variable "alarm_period" {
  type    = number
  default = 300
}

variable "alarm_actions" {
  type    = list(string)
  default = []
}
