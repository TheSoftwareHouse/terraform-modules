# AWS Bitbucket OIDC Provider

Terraform module which creates OIDC provider and access roles for specific Bitbucket repositories.

## Usage

```hcl
module "aws-bitbucket-oidc-provider" {
  source = "git::ssh://git@bitbucket.org/thesoftwarehouse/terraform-modules.git//aws_bitbucket_oidc_provider?ref=main"

  # Open a Bitbucket repository and go to Repository settings -> OpenID Connect in the Pipelines section to get all the details.
  identity_provider_url = "<PROVIDER_URL>"
  audience              = "<AUDIENCE>"

  thumbprints = ["<THUMBPRINT>"]

  roles = {
    "<ROLE_NAME>" = {
      create           = true
      repository_uuids = ["{<REPOSITORY_UUID>}"]
    }
  }
}
```