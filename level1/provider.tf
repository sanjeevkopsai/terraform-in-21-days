terraform {
  backend "s3" {
    bucket = "terraform-remote-state-123abc123"
    key    = "level1.tfstate"
    region = "us-west-1"
    dynamodb_table = "terraform-remote-state"

  }
}

provider "aws" {
  region = "us-west-1"
}
