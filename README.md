# GCP GitLab Runner

A Terraform module for configuring a GCP-based GitLab CI Runner.

This runner is configured to use the docker+machine executor which allows the infrastructure to be scaled up and down as demand requires.  The minimum cost (during zero activity) is the cost of an f1-micro instance.

The long-running runner instance runs under a `gitlab-ci-runner` service account.  This account will be granted all required permissions to spawn worker instances on demand.

The worker instances run under a `gitlab-ci-worker` service account.  This account will need to be granted any privileges required to perform build and deploy activities.  For example, the `storage.admin` role can be granted to the worker account as follows:

# Usage

To use this module you can create a main.tf file similar to the following example.  Note that you
will need to modify the roles assigned to the CI worker service account based on your specific
project needs.

```
# Configure GCP provider
provider "google" {
  version = "~> 2.13"
  project = var.gcp_project
  region  = var.gcp_region
}

# Install the GitLab CI Runner infrastructure
module "ci" {
  source      = "brettch/gitlab-runner/google"
  version     = "0.0.8"

  gcp_project = var.gcp_project
  gcp_zone    = var.gcp_zone
  gitlab_url  = var.gitlab_url
  ci_token    = var.ci_token
}

# Grant the storage.admin role to the CI workers.  Add other roles as required.
resource "google_project_iam_member" "worker_storage_admin" {
  role   = "roles/storage.admin"
  member = "serviceAccount:${module.ci.ci_worker_service_account.email}"
}

```

Then perform the following commands:

* `terraform init` to get the plugins
* `terraform plan` to see the infrastructure plan
* `terraform apply` to apply the infrastructure build
* `terraform destroy` to destroy the built infrastructure
