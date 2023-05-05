variable "role_name" {
  description = "Name of the role to create"
  type        = string
  default     = "GithubActionsRole"
}

variable "github_url" {
  description = "The URL of the token endpoint for Github"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "github_org" {
  description = "Github Org to trust"
  type        = string
}

variable "github_repos" {
  description = "Github repos to trust"
  type        = list(string)
  default     = []
}

variable "tags" {
  type = map(string)
}
