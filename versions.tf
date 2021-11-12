terraform {
  required_version = "~>1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=3.60.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn     = "arn:aws:iam::558764718677:role/MissionAdministrator"
    session_name = "terraform-aws-transit-gateway"
  }
}
