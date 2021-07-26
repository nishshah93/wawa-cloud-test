terraform{
    required_version = ">= 0.12.0"

    backend "s3" {
        region = "us-east-1"
        // Ideally you wanna use a role(role_arn) that is specifically designed for terraform 
        profile = "nish-test"
        bucket = "nish-cloud-testing"
        key = "wawa_cloud"
        dynamodb_table = "nish-cloud-testing-terraform-state"
    }
}

provider "aws" {
    region = "us-east-1"
    version = "~> 3.0"
    profile = "nish-test"
}
    // you can lock down and allow only certain workspaces 
    // locals {
    //     valid_workspaces = {
    //         dev = "dev"
    //         qa  = "qa"
    //     }
    //     selected_workspace = local.valid_workspaces[terraform.workspace]
    // }
