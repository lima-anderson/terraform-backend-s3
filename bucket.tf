provider "aws" {
  region  = "us-east-1"
}

resource "aws_s3_bucket" "bucketbackend" {
  bucket = "bucketbackend"
}

resource "aws_s3_bucket_acl" "acl-bucket" {
  bucket = aws_s3_bucket.bucketbackend.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket = aws_s3_bucket.bucketbackend.id
  versioning_configuration {
    status = "Enabled"
  }
}
