terraform {
  backend "s3" {
    bucket         = "kateryna-velychko-lesson-5-terraform-state-usw2"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
