
variable "resource_prefix" {
  description = "The prefix to use when naming the notebook and job"
  type        = string
  default     = "gilead"
}

variable "job_run_principal" {
  description = "The principal as the job runs"
  type        = string
}

variable "job_success_email_notifier" {
  description = "The email address to send job status on success"
  type        = list(string)
  default     = ["srijit.nair@databricks.com"]
}

variable "job_error_email_notifier" {
  description = "The email address to send job status on failure"
  type        = list(string)
  default     = ["srijit.nair@databricks.com"]
}

variable "common_tags" {
  type        = map(any)
  description = "Map of Default Tags"
  default = {
    "owner" = "srijit.nair@databricks.com"
  }
}

variable "repo_root_path" {
  description = "The root path to the Repo folder from where the source is taken for jobs"
  type        = string
}

variable "target_catalog_name" {
  description = "The catalog where all the data is stored"
  type        = string
}

variable "target_schema_name" {
  description = "The schema where all tables are created"
  type        = string
}

variable "git_url" {
  description = "Git location of notebooks"
  type = string
}

variable "git_branch" {
  description = "Git branch for notebooks"
  type = string
}

variable "file_master_ids" {
  description = "File master ids"
  type        = list(string)
}

variable "s3_root_location" {
  description = "Prelaanding location for source data"
  type = string
}

variable "src_data_location" {
  description = "Root s3 location"
  type = string
}

variable "landing_data_location" {
  description = "Landing location for source data"
  type = string
}