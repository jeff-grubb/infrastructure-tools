terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  shared_config_files      = ["/Users/jeff.grubb/.aws/conf"]
  profile                  = "dev-sps-foxsports"

  default_tags {
    tags = {
      Team         = "infra"
      GithubRepo   = "platform-assets"
      GithubOrg    = "foxcorp"
      Environment  = "dev"
      BusinessUnit = "sps"
      EndOfLife    = "n/a"
    }
  }
}
