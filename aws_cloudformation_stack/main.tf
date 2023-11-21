resource "aws_cloudformation_stack" "this" {
  provider      = aws.global
  name          = var.name
  template_body = var.template_body
}