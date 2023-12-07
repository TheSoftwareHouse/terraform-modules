resource "aws_ecrpublic_repository" "this" {
  repository_name = var.repository_name

  catalog_data {
    about_text        = var.about_text
    architectures     = var.architectures
    description       = var.description
    operating_systems = var.operating_systems
    usage_text        = var.usage_text
  }
}
