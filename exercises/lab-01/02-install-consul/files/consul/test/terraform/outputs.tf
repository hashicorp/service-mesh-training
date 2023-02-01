# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MIT

output "cluster_id" {
  value = "${google_container_cluster.cluster.id}"
}

output "cluster_name" {
  value = "${google_container_cluster.cluster.name}"
}
