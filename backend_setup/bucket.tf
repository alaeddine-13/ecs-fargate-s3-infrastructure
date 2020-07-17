resource "aws_s3_bucket" "bucket" {
  bucket = "${var.projct_name}_terraform_backend"
  acl    = "public-read"
}
