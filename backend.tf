terraform {
  backend "gcs" {
    bucket  = "mentoria-tfstate-staging"
    prefix  = "terraform/state"
  }
}