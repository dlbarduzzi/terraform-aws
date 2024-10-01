terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-d3d425e29e7d1f25"
    key            = "aws-config"
    region = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-d3d425e29e7d1f25"
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Env       = terraform.workspace
      App       = var.project_name
      Owner     = var.project_owner
      ManagedBy = "terraform/config"
    }
  }
}
