########### 

resource "databricks_job" "ingestion_job" {
  name                = "${var.resource_prefix}_ingestion_job"
  max_concurrent_runs = 1

  # notifications at job level
  email_notifications {
    on_success = var.job_success_email_notifier
    on_failure = var.job_error_email_notifier
  }

  job_cluster {
    job_cluster_key = "job_cluster_1"
    new_cluster {
      node_type_id        = data.databricks_node_type.smallest.id
      driver_node_type_id = data.databricks_node_type.smallest.id
      spark_version       = data.databricks_spark_version.latest_lts.id
      data_security_mode  = "USER_ISOLATION"
      autoscale {
        min_workers = 2
        max_workers = 4
      }
    }
  }

  git_source {
    url = var.git_url
    provider = "gitHub"
    branch = var.git_branch
  }

  task {
    task_key = "1_initialize"

    notebook_task {
      source = "GIT"
      notebook_path = "${var.repo_root_path}/init"
      base_parameters = {
        catalog_name = var.target_catalog_name
        schema_name  = var.target_schema_name
      }
    }

    job_cluster_key = "job_cluster_1"

    # timeout and retries
    timeout_seconds           = 1000
    min_retry_interval_millis = 10000
    max_retries               = 1
  }

  dynamic "task" {
    for_each = var.file_master_ids
    content {
      task_key = "pre_landing_${task.value}"
      depends_on {
        task_key = "1_initialize"
      }
      notebook_task {
        source = "GIT"
        notebook_path = "${var.repo_root_path}/pre_landing"
        base_parameters = {
          src_data_location = "${var.s3_root_location}/${var.src_data_location}"
          file_master_id = task.value
        }
      }
      job_cluster_key = "job_cluster_1"
      # timeout and retries
      timeout_seconds           = 10000
      min_retry_interval_millis = 10000
      max_retries               = 1
    }
  }

  dynamic "task" {
    for_each = var.file_master_ids
    content {
      task_key = "landing_${task.value}"
      depends_on {
        task_key = "pre_landing_${task.value}"
      }
      notebook_task {
        source = "GIT"
        notebook_path = "${var.repo_root_path}/landing"
        base_parameters = {
          src_data_location = "${var.s3_root_location}/${var.src_data_location}"
          dest_data_location = "${var.s3_root_location}/${var.landing_data_location}"
          file_master_id = task.value
        }
      }
      job_cluster_key = "job_cluster_1"
      # timeout and retries
      timeout_seconds           = 10000
      min_retry_interval_millis = 10000
      max_retries               = 1
    }
  }

  dynamic "task" {
    for_each = var.file_master_ids
    content {
      task_key = "ingest_${task.value}"
      depends_on {
        task_key = "landing_${task.value}"
      }
      notebook_task {
        source = "GIT"
        notebook_path = "${var.repo_root_path}/ingest"
        base_parameters = {
          landing_location = "${var.s3_root_location}/${var.landing_data_location}"
          file_master_id = task.value
          catalog_name = var.target_catalog_name
          schema_name = var.target_schema_name
          table_name = "demo_${task.value}"
        }
      }
      job_cluster_key = "job_cluster_1"
      # timeout and retries
      timeout_seconds           = 10000
      min_retry_interval_millis = 10000
      max_retries               = 1
    }
  }

  tags = var.common_tags
}
