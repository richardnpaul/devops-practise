terraform {
  backend "s3" {
    bucket = "richardnpaul-tf"
    shared_credentials_file = "~/.aws/credentials"
    profile = "terraform"
    region = "eu-west-2"
  }
}
