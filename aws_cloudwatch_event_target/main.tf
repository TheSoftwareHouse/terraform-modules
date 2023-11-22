resource "aws_cloudwatch_event_target" "this" {
  target_id = var.target_id
  arn       = var.arn
  rule      = var.rule
}
