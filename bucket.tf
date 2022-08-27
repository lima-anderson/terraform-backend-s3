provider "aws" {
  region  = "us-east-1"
}

resource "aws_s3_bucket" "bucket-backend" {
  bucket = "bucket-backend"
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.bucket-backend.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket = aws_s3_bucket.bucket-backend.id
  versioning_configuration {
    status = "Enabled"
  }
}
