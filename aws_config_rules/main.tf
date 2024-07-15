resource "aws_sns_topic" "config_alerts" {
  count = var.enable_alerting ? 1 : 0
  name  = var.sns_topic_name
}

resource "aws_sns_topic_policy" "config_alerts_policy" {
  count = var.enable_alerting ? 1 : 0

  arn    = aws_sns_topic.config_alerts[0].arn
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "config.amazonaws.com"
        },
        Action    = "sns:Publish",
        Resource  = aws_sns_topic.config_alerts[0].arn
      }
    ]
  })
}

resource "aws_cloudwatch_event_rule" "config_rule_compliance" {
  count = var.enable_alerting ? length(var.config_rules) : 0

  name        = "config-rule-compliance-${var.config_rules[count.index].name}"
  description = "CloudWatch event rule for AWS Config compliance changes"
  event_pattern = jsonencode({
    source = ["aws.config"]
    detail-type = ["Config Rules Compliance Change"]
    detail = {
      configRuleName = [var.config_rules[count.index].name]
    }
  })
}

resource "aws_cloudwatch_event_target" "sns_target" {
  count = var.enable_alerting ? length(var.config_rules) : 0

  rule      = aws_cloudwatch_event_rule.config_rule_compliance[count.index].name
  target_id = "sns"
  arn       = aws_sns_topic.config_alerts[0].arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count = var.enable_alerting ? length(var.config_rules) : 0

  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.config_change[count.index].arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.config_rule_compliance[count.index].arn
}

resource "aws_config_configuration_recorder" "this" {
  count                     = var.enabled ? 1 : 0
  name                      = var.recorder_name
  role_arn                  = var.role_arn

  recording_group {
    all_supported           = true
  }
}

resource "aws_config_configuration_recorder_status" "this" {
  count = var.enabled ? 1 : 0
  name  = aws_config_configuration_recorder.this[0].name
  is_enabled = true
}

resource "aws_config_config_rule" "rules" {
  count = length(var.config_rules)

  name = var.config_rules[count.index].name

  source {
    owner             = var.config_rules[count.index].source.owner
    source_identifier = var.config_rules[count.index].source.identifier

    source_detail {
      event_source               = var.config_rules[count.index].source.detail.event_source
      message_type               = var.config_rules[count.index].source.detail.message_type
      maximum_execution_frequency = var.config_rules[count.index].source.detail.maximum_execution_frequency
    }
  }

  input_parameters = var.config_rules[count.index].input_parameters
  maximum_execution_frequency = var.config_rules[count.index].maximum_execution_frequency
  scope {
    compliance_resource_id   = var.config_rules[count.index].scope.compliance_resource_id
    compliance_resource_types = var.config_rules[count.index].scope.compliance_resource_types
    tag_key                  = var.config_rules[count.index].scope.tag_key
    tag_value                = var.config_rules[count.index].scope.tag_value
  }
}
