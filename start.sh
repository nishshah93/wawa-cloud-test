#!/bin/sh
# Create a bucket and dynamo table for state files storage and safe executions
aws s3api create-bucket --bucket nish-cloud-testing --region us-east-1
aws dynamodb create-table \
    --table-name nish-cloud-testing-terraform-state \
    --attribute-definitions AttributeName=LockID,AttributeType=S  \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=3,WriteCapacityUnits=3

# run terraform commands 
terraform init
terraform plan -out=plan.terraform
terraform apply plan.terraform