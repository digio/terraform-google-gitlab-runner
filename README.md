# GCP GitLab Runner

A Terraform module for configuring a GCP-based GitLab CI Runner.

This runner is configured to use the docker+machine executor which allows the infrastructure to be scaled up and down as demand requires.  The minimum cost (during zero activity) is the cost of an f1-micro instance.

# Setup

A minimal project for using this module will look like the following:

```
# Location of state bucket
terraform {
  backend "gcs" {
    bucket = "<terraform-state-bucket>"
    prefix = "gitlab-ci"
  }
}

# GCP provider
provider "google" {
  project = "<gcp-project>"
  region = "<gcp-region>"
}

# Install the GitLab CI Runner infrastructure
module "ci" {
  source = "./modules/gitlab-ci-runner"

  gcp-project = var.gcp-project
  gcp-zone = var.gcp-zone
  gitlab-url = var.gitlab-url
  ci-token = var.ci-token
}

# Grant all necessary privileges to the worker service account.
resource "google_project_iam_member" "worker-storage-admin" {
  role    = "roles/storage.admin"
  member = "serviceAccount:${module.ci.ci-worker-service-account.email}"
}
```
