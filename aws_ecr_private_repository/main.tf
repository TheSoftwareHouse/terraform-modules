resource "aws_ecr_repository" "this" {
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability

  encryption_configuration {
    encryption_type = "KMS"
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}


resource "aws_ecr_lifecycle_policy" "ecr_lifecyle_policy" {
  repository = aws_ecr_repository.this.name
  policy     = templatefile("aws_ecr_policy.json", { ecr_max_image_count = tonumber(var.ecr_max_image_count), ecr_lifecyle_policy_tag = var.ecr_lifecyle_policy_tag })
}
