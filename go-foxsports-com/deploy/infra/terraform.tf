terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Team         = "fscom"
      GithubRepo   = "go.foxsports.com"
      GithubOrg    = "foxcorp"
      Environment  = var.environment_name
      BusinessUnit = "foxsports"
      EndOfLife    = "n/a"
    }
  }
}
