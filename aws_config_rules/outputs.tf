output "config_rule_ids" {
  description = "The IDs of the AWS Config rules"
  value       = [for r in aws_config_config_rule.rules : r.id]
}

output "sns_topic_arn" {
  description = "The ARN of the SNS topic for alerts"
  value       = aws_sns_topic.config_alerts[0].arn
}