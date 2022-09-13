terraform {
  backend "s3" {
    region  = "eu-west-2"
    profile = "default"
    key     = "tf-key"
    bucket  = "tf-state3424"
  }
}