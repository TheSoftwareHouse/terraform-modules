locals {
  bitbucket_oidc_policy = file("${path.module}/json/bitbucket_oidc_policy.json")

  repositories = { for repository in var.repositories : repository.name =>
    {
      uuid = repository.uuid
      envs = { for i, environment in repository.environment_names : environment => repository.environment_uuids[i] }
    }
  }

  repo_wildcards           = { for repo_name, repo_values in local.repositories : repo_name => ["${repo_values.uuid}:*"] }
  repo_wildcards_with_envs = { for repo_name, repo_values in local.repositories : repo_name => [for env_name, env_uuid in repo_values.envs : "${repo_values.uuid}*:${env_uuid}*"] }

  wildcards = { for repo_name, repo_values in local.repositories : repo_name => coalescelist(local.repo_wildcards_with_envs[repo_name], local.repo_wildcards[repo_name]) }

  iam_roles = { for k in var.repositories : k.name =>
    {
      iam_policy_arns = concat([module.iam_iam-policy.arn], k.iam_role_additional_policy_arns)
  } }
}