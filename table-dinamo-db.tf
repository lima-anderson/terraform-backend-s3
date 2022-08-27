resource "aws_dynamodb_table" "dynamodb-backend" {
  name = "dynamodb-backend"
  hash_key = "LockID"
  read_capacity = 1
  write_capacity = 1
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags = {
    Name = "dynamodb-backend"
  }
}
