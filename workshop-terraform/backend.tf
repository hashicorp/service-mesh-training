terraform {
  backend "gcs" {
    bucket = "qcon-ldn19-tf-admin"
    prefix = "terraform/state"
    project = "qcon-ldn19-tf-admin"
  }
}
