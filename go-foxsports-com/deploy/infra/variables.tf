variable "app_name" {
  type        = string
  default     = "go.foxsports.com"
  description = "name of the app"
}

variable "repo_name" {
  type        = string
  default     = "foxcorp/go.foxsports.com"
  description = "name of github repo, for example 'foxcorp/foo'"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region, like us-east-1"
}

variable "environment_name" {
  type        = string
  default     = "dev"
  description = "the name of environment, [dev, stage, prod]"
}
