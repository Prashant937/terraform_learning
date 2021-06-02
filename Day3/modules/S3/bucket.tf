resource "aws_s3_bucket" "prashantss-bucket" {
  bucket = "yokohama123-bucket"
  acl    = "private"

  tags = {
    Name        = "prashant"
    Environment = "Dev"
  }
}