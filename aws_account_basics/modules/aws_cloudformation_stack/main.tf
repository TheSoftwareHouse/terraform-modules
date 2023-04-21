resource "aws_cloudformation_stack" "this" {
  name          = var.name
  template_body = var.template_body
}

