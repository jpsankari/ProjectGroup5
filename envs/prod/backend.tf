terraform {
  backend "s3" {
    bucket = "sctp-ce10-tfstate"
    key    = "ce10-group5-project-prod.tfstate"
    region = "ap-southeast-1"
  }
}
