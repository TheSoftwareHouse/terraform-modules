# AWS Bitbucket OIDC Provider

Terraform module which creates OIDC provider and access roles for specific Bitbucket repositories.

## Usage

```hcl
module "bitbucket_oidc_provider" {
  source = "../modules/bitbucket_oidc_provider"

  # Open a Bitbucket repository and go to Repository settings -> OpenID Connect in the Pipelines section to get all the details.
  identity_provider_url = "<PROVIDER_URL>"
  audience              = "<AUDIENCE>"
  thumbprints           = ["<THUMBPRINT>"]

  repositories = [
    {
      name = "<REPOSITORY_NAME>"
      uuid = "<REPOSITORY_UUID>"

      environment_names = [
        "Staging",
        "Production"
      ]
      environment_uuids = [
        "<ENV_UUID>",
        "<ENV_UUID>"
      ]
    }
  ]
}
```