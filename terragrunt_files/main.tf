resource "local_file" "terragrunt" {
  for_each             = local.configs
  content              = each.value["content"]
  filename             = join("", [local.accounts_path, each.value["filename"]])
  file_permission      = "0644" # do zmiennej?
  directory_permission = "0755" # do zmiennej?
}