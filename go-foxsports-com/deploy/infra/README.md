Export AWS Credentials:
export AWS_PROFILE=[dev-]foxsports

Terraform Init:
terraform init -backend-config tfconfigs/[dev|stage|prod].us-east-1.tfbackend

Plan:
terraform plan -var-file tfconfigs/[dev|stage|prod].us-east-1.tfvars

Apply:
terraform apply -var-file tfconfigs/[dev|stage|prod].us-east-1.tfvars

*Note: remove .terraform / .terraform.lock.hcl between environments