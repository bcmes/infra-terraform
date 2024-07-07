terraform {

  backend "s3" { #terraform init again, and terraform plan
    bucket = "devops-directive-tf-state"
    key = "tf-infra/terraform.tfstate" #path dentro do bucket
    region = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#resource "aws_instance" "example" {
#  ami           = "ami-0a3c3a20c09d6f377" # Amazon Linux 2023 AMI
#  instance_type = "t2.micro"
#}

resource "aws_s3_bucket" "terraform_state" { #resource "tipo do recurso" "de um nome ao recurso criado"
  bucket = "devops-directive-tf-state" #name do bucket na aws
  force_destroy = true
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  hash_key = "LockID"
  name     = "terraform-state-locking" #name da tabela na aws dynamodb
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}