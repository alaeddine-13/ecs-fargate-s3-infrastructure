terraform {
  backend "s3" {
    bucket = "${var.projct_name}_terraform_backend"
    key    = "global/s3/terraform.tfstate"
    region = var.aws_region

    dynamodb_table = "terraform-${var.project_name}-db"
    encrypt        = true
  }
}
