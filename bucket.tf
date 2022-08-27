provider "aws" {
  profile    = "terraform_ci_test"
  region     = "sa-east-1"
}
resource "aws_s3_bucket" "bucket-backend" {
    bucket = "bucket-backend-s3"
    versioning {
      enabled = true
    }
    lifecycle {
      prevent_destroy = true
    }
    tags = {
      Name = "backend-S3"
    }      
}
