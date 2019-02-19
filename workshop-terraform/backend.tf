terraform {
  backend "remote" {
    organization = "erikcorp"

    workspaces {
      name = "workshop"
    }
  }
}