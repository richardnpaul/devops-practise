terraform {
  backend "s3" {
    bucket                  = "richardnpaul-tf"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "terraform"
    region                  = "eu-west-2"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "aws" {
  profile = "terraform"
  region  = var.aws_region
}

provider "cloudflare" {}