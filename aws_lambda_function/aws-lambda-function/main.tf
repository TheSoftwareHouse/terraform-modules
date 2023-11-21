resource "aws_lambda_function" "this" {
  filename                       = var.filename
  function_name                  = var.function_name
  description                    = var.description
  role                           = var.role
  handler                        = var.handler
  source_code_hash               = filebase64sha256(var.filename)
  runtime                        = var.runtime
  architectures                  = var.architectures
  package_type                   = var.package_type
  reserved_concurrent_executions = var.reserved_concurrent_executions
  timeout                        = var.timeout
  memory_size                    = var.memory_size

  lifecycle {
    ignore_changes = [
      last_modified,
      architectures
    ]
  }

  tags = var.tags

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }
}
