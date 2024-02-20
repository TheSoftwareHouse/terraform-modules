resource "aws_sns_topic" "sns_topic_blocked" {
  count = var.cloudwatch.enable_alarms_notifications && try(var.cloudwatch.alarms_config.sns_topic_arn_blocked, null) == null ? 1 : 0
  name  = "${var.name}-blocked"
}

resource "aws_sns_topic" "sns_topic_counted" {
  count = var.cloudwatch.enable_alarms_notifications && try(var.cloudwatch.alarms_config.sns_topic_arn_counted, null) == null ? 1 : 0
  name  = "${var.name}-counted"
}
