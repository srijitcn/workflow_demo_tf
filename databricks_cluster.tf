/*
resource "databricks_cluster" "interactive" {
  cluster_name            = "${var.resource_prefix}_demo_cluster"
  #policy_id               = "60640816D0005FF1"
  node_type_id            = data.databricks_node_type.smallest.id
  spark_version           = data.databricks_spark_version.latest_lts.id
  autotermination_minutes = 120
  data_security_mode      = "USER_ISOLATION"
  autoscale {
    min_workers = 2
    max_workers = 4
  }
}

output "cluster_url" {
  value = databricks_cluster.interactive.url
}

*/
