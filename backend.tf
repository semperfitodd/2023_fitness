terraform {
  backend "s3" {
    bucket = "bernson.terraform"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}