resource "aws_account_alternate_contact" "this" {
  for_each = var.contacts

  alternate_contact_type = each.key
  name                   = each.value["name"]
  title                  = each.value["title"]
  email_address          = each.value["email_address"]
  phone_number           = each.value["phone_number"]
}
