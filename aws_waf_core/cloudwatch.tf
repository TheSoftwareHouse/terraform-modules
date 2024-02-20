locals {
  sns_topic_arns = {
    BlockedRequests = try(var.cloudwatch.alarms_config.sns_topic_arn_blocked, one(aws_sns_topic.sns_topic_blocked[*].arn))
    CountedRequests = try(var.cloudwatch.alarms_config.sns_topic_arn_counted, one(aws_sns_topic.sns_topic_counted[*].arn))
  }

  managed_rules = { for rule in var.aws_managed_rule_groups : rule.name => rule }

  rules_with_alarm_configuration = {
    for key, value in merge(var.ip_set_rules, var.ip_rate_based_rules, var.geo_match_rules, local.managed_rules) : key
    => {
      rule_name                = key
      rule_alarm_configuration = value.alarm_configuration

      alarm_dimension = value.action == "block" ? "BlockedRequests" : "CountedRequests"
    } if value.alarm_configuration != null
  }
}

resource "aws_cloudwatch_log_group" "waf_log_group" {
  count = var.cloudwatch.enable_logging ? 1 : 0
  name  = "aws-waf-logs-${var.name}"

  retention_in_days = 14

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_cloudwatch_dashboard" "waf_dashboard" {
  count          = var.cloudwatch.enable_logging && var.cloudwatch.enable_dashboard ? 1 : 0
  dashboard_name = var.name
  dashboard_body = templatefile("${path.module}/templates/cw_dashboard.json", {
    webacl_name           = aws_wafv2_web_acl.main.name
    webacl_log_group_name = one(aws_cloudwatch_log_group.waf_log_group[*].name)
    aws_region            = data.aws_region.current.name
  })

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_cloudwatch_metric_alarm" "cw_rule_alarms" {
  for_each = local.rules_with_alarm_configuration

  alarm_name = "${var.name}-${each.value.rule_name}-alarm"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = each.value.alarm_dimension
  namespace           = "AWS/WAFV2"

  period             = each.value.rule_alarm_configuration.observation_period
  threshold          = each.value.rule_alarm_configuration.threshold
  statistic          = "Sum"
  treat_missing_data = "notBreaching"

  dimensions = merge(
    var.scope == "REGIONAL" ? { Region = data.aws_region.current.name } : {},
    {
      Rule   = each.value.rule_name
      WebACL = aws_wafv2_web_acl.main.name
    }
  )

  alarm_actions = var.cloudwatch.enable_alarms_notifications ? [local.sns_topic_arns[each.value.alarm_dimension]] : []
  ok_actions    = var.cloudwatch.enable_alarms_notifications ? [local.sns_topic_arns[each.value.alarm_dimension]] : []

  tags = var.tags
}
