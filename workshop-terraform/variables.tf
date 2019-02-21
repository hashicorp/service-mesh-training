variable "billing_account" {
  description = "The billing account to connect the project to"
  type = "string"
}

variable "organization_id" {
  description = "The organization to create the project under"
  type = "string"
}

variable "folder_id" {
  description = "The folder to create the project under"
  type = "string"
}

variable "emails" {
  description = "List of attendee email addresses"
  type = "list"
}

variable "zone" {
  description = "The zone the GKE cluster will be created in"
  type = "string"
}

variable "node_count" {
  description = "The number of nodes the GKE cluster will have"
}

variable "node_type" {
  description = "The machine type the nodes of the GKE cluster will be"
  type = "string"
}
