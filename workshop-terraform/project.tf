resource "google_project" "project" {
  count = "${length(var.emails)}"

  name = "qcon-ldn-2019-v4-workshop-${count.index}"
  project_id = "qcon-ldn-2019-v4-workshop-${count.index}"
  #org_id     = "${var.organization_id}"
  billing_account = "${var.billing_account}"
  folder_id = "${var.folder_id}"
}

resource "google_project_services" "services" {
  count = "${length(var.emails)}"

  # How do you know the syntax for these lists?
  project  = "${element(google_project.project.*.project_id, count.index)}"
  services = [
    "admin.googleapis.com",
    "cloudapis.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "datastore.googleapis.com",
    "deploymentmanager.googleapis.com",
    "dns.googleapis.com",
    "firebase.googleapis.com",
    "iam.googleapis.com",
    "identitytoolkit.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "pubsub.googleapis.com",
    "replicapool.googleapis.com",
    "replicapoolupdater.googleapis.com",
    "resourceviews.googleapis.com",
    "securetoken.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "firebasedynamiclinks.googleapis.com",
    "firebaserules.googleapis.com",
    "testing.googleapis.com",
    "bigquery-json.googleapis.com",
    "appengine.googleapis.com",
    "googlecloudmessaging.googleapis.com",
    "clouddebugger.googleapis.com",
    "cloudapis.googleapis.com",
    "servicemanagement.googleapis.com",
    "cloudtrace.googleapis.com",
    "sqladmin.googleapis.com",
    "sql-component.googleapis.com",
    "sourcerepo.googleapis.com",
    "clouderrorreporting.googleapis.com",
    "stackdriver.googleapis.com",
    "cloudprofiler.googleapis.com",
    "oslogin.googleapis.com",
    "serviceusage.googleapis.com",
    "iap.googleapis.com",
    "iamcredentials.googleapis.com",
  ]
}
