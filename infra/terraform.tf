terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.17.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 1.2.0"

  cloud {
    organization = "dsl-2022"

    workspaces {
      name = "gh-multi-channel-message"
    }
  }
}