variable "role_name" {
  description = "Name Of The Role To Create"
  type        = string
  default     = "GithubActionsRole"
}

variable "github_url" {
  description = "The URL Of The Token Endpoint For Github"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "github_org" {
  description = "Github Trusted Organisation"
  type        = string
}

variable "github_repos" {
  description = "Github Trusted Repositories"
  type        = list(string)
  default     = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
