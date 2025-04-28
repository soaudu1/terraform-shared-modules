terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  #backend "s3" {
  # Uncomment and configure when you're ready to use remote state
  # bucket         = "your-tfstate-bucket"
  # key            = "sandbox/terraform.tfstate"
  # region         = "us-east-1"
  # dynamodb_table = "your-lock-table"
  # encrypt        = true
  #}
}

provider "aws" {
  region = var.aws_region
}
