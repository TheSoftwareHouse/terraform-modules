# AWS Get Organization Details

## Requirements
- A provider must assume a role in the AWS Organization's management account.

## Usage
### The default provider has assumed a role in the AWS Organization's management account
```hcl
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::<MANAGEMENT_ACCOUNT_ID>:role/<ROLE_TO_ASSUME>"
  }
}

module aws_get_organizational_units {
  source = ".../aws_organization/modules//aws_get_organizational_units"
}
```

### Multiple providers. The default one did not assume the role in the AWS Organization's management account
```hcl
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_TO_ASSUME>"
  }
}

provider "aws" {
  alias = "management"
  assume_role {
    role_arn = "arn:aws:iam::<MANAGEMENT_ACCOUNT_ID>:role/<ROLE_TO_ASSUME>"
  }
}

module aws_get_organizational_units {
  source = ".../aws_organization/modules//aws_get_organizational_units"
  providers = {
    aws = aws.management
  }
}
```