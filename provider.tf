provider "aws" {
  region = "ap-south-1"
  shared_credentials_file = "/root/.aws/credentials"
  profile                 = "default"
}

terraform {
  backend "local" {
  path = "/root/terra-demo/terraform.tfstate"
  }
}

