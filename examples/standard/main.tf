/**
 * Copyright 2021 Mantel Group Pty Ltd
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

# Specify location of state bucket
terraform {
  backend "gcs" {
    bucket = "gitlab-runner-terraform-state"
    prefix = "gitlab-ci"
  }

  required_providers {
    google = {
      version = "~> 3.58"
      source = "hashicorp/google"
    }
  }
}

# Install the GitLab CI Runner infrastructure
module "ci" {
  source  = "../../"

  gcp_project         = var.gcp_project
  gcp_zone            = var.gcp_zone
  gitlab_url          = var.gitlab_url
  ci_token            = var.ci_token
  ci_concurrency      = var.ci_concurrency
  ci_worker_idle_time = var.ci_worker_idle_time
}

# Grant deployments privileges to the CI workers.
# This module must be modified to reflect the permissions required for CI jobs.
module "ci-privileges" {
  source = "./modules/gitlab-ci-privileges"

  gcp_project = var.gcp_project
  ci_worker_service_account = module.ci.ci_worker_service_account.email
}
