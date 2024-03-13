data "aws_caller_identity" "current" {}

locals {
  bucket_name = "jgtest-fs-dev-sps-assets"
  account_id  = data.aws_caller_identity.current.account_id
  region      = "us-east-1"
}
