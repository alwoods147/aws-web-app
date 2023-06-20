provider "aws" {
  region  = "us-east-1"
  version = "~> 2.63"
}


terraform {
  backend "s3" {
    bucket = "awdemobucket"
    key    = "state/terraform.tfstate"
    region = "eu-west-2"
  }
}