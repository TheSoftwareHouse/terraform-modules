# AWS IAM Identity Provider
This module configures the identity provider for the organization.

## Requirements
* Organization must be created.
* SSO authentication must be enabled within IAM Identity Center. For details on enabling SSO authentication, see [Getting Started](https://docs.aws.amazon.com/singlesignon/latest/userguide/getting-started.html) in the AWS IAM Identity Center (successor to AWS Single Sign-On) User Guide.
* External identity provider must be set within IAM Identity Center (if you are using external provider for SSO).

## Usage
```hcl
module aws_iam_identity_provider {
  source = "git::ssh://git@bitbucket.org/thesoftwarehouse/terraform-modules-bis.git//aws_iam_identity_provider"

  # Configuration options
}
```
## Examples
### Create a 'AdministratorAccess' predefined permission set
```hcl
module aws_iam_identity_provider {
  source = "git::ssh://git@bitbucket.org/thesoftwarehouse/terraform-modules-bis.git//aws_iam_identity_provider"

  permision_sets = {
    "AdministratorAccess" = {
      session_duration          = "PT1H"
      predefined_permission_set = "AdministratorAccess"
    }
  }
}
```

### Create a custom permission set with permission to describe EC2 instances
```hcl
module aws_iam_identity_provider {
  source = "git::ssh://git@bitbucket.org/thesoftwarehouse/terraform-modules-bis.git//aws_iam_identity_provider"

  permission_sets = {
    "DescribeEC2" = {
      session_duration = "PT2H"
      relay_state      = "https://eu-central-1.console.aws.amazon.com/ec2/"
      description      = "This policy grants permissions to describe EC2 instances."

      custom_permission_set = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "ec2:Describe*",
            ]
            Effect   = "Allow"
            Resource = "*"
          },
        ]
      })
    }
  }
}
```