# AWS Organizational Units

Zmiana wartości argumentu `parent_id` w `aws_organizations_organizational_unit` wymusza usunięcie jednostki organizacyjnej i utworzenie nowej.

## Usage

```hcl
module "aws-bitbucket-oidc-provider" {
  source = "git::ssh://git@bitbucket.org/thesoftwarehouse/terraform-modules.git//aws_organizational_units?ref=main"

  organizational_units = [
    {
      name = "<OU_NAME>" # level 1
      childs = [
        {
          name = "<OU_NAME>" # level 2
          childs = [
            { name = "<OU_NAME>" } # level 3
          ]
        },
        { name = "<OU_NAME>" } # level 2
      ]
    },
    {
      name = "<OU_NAME>" # level 1
    }
  ]
```