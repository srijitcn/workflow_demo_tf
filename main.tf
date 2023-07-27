terraform {
  required_providers {

    databricks = {
      source  = "databricks/databricks"
      version = ">=1.14"
    }

  }
}

provider "databricks" {
  profile = "srijit_gilead_terraform_demo"
}
