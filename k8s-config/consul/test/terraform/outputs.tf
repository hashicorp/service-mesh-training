# Copyright IBM Corp. 2019, 2026

output "cluster_id" {
  value = "${google_container_cluster.cluster.id}"
}

output "cluster_name" {
  value = "${google_container_cluster.cluster.name}"
}
