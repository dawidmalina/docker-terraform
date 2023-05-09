terraform {
  required_version = ">= 1.0"
}

module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "13.2"

  random_project_id       = true
  name                    = "simple-sample-project"
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  default_service_account = "deprivilege"
  activate_api_identities = [{
    api = "healthcare.googleapis.com"
    roles = [
      "roles/healthcare.serviceAgent",
      "roles/bigquery.jobUser",
    ]
  }]
}
