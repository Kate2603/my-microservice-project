terraform {
  backend "s3" {
    bucket         = "kate2603-final-tf-state"
    key            = "final-project/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "kate2603-final-tf-locks"
    encrypt        = true
  }
}
