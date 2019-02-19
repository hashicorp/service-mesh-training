resource "google_project_iam_binding" "container-developer" {
  depends_on = ["google_project_services.services"]
  
  count = "${length(var.emails)}"

  project    = "${element(google_project.project.*.project_id, count.index)}"
  role       = "roles/container.developer"

  members = [
    "user:${element(var.emails, count.index)}"
  ]
}