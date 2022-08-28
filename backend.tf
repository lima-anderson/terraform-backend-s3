terraform {
  backend "s3" {
    bucket = "bucketbackend"
    region = "us-east-1"
    encrypt = true
    key    = "projectCloudGuru/terraform.tfstate"
    dynamodb_table = "dynamodb-backend"
  }
}
