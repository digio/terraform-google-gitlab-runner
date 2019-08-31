/**
 * Copyright 2018 Mantel Group Pty Ltd
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

# Service account for the Gitlab CI runner.  It doesn't run builds but it spawns other instances that do.
resource "google_service_account" "ci-runner" {
  project_id   = var.gcp-project
  account_id   = "gitlab-ci-runner"
  display_name = "GitLab CI Runner"
}
resource "google_project_iam_member" "instanceadmin-ci-runner" {
  project_id = var.gcp-project
  role       = "roles/compute.instanceAdmin.v1"
  member     = "serviceAccount:${google_service_account.ci-runner.email}"
}
resource "google_project_iam_member" "networkadmin-ci-runner" {
  project_id = var.gcp-project
  role       = "roles/compute.networkAdmin"
  member     = "serviceAccount:${google_service_account.ci-runner.email}"
}
resource "google_project_iam_member" "securityadmin-ci-runner" {
  project_id = var.gcp-project
  role       = "roles/compute.securityAdmin"
  member     = "serviceAccount:${google_service_account.ci-runner.email}"
}

# Service account for Gitlab CI build instances that are dynamically spawned by the runner.
resource "google_service_account" "ci-worker" {
  project_id   = var.gcp-project
  account_id   = "gitlab-ci-worker"
  display_name = "GitLab CI Worker"
}

# Allow GitLab CI runner to use the worker service account.
resource "google_service_account_iam_member" "ci-worker-ci-runner" {
  project_id         = var.gcp-project
  service_account_id = google_service_account.ci-worker.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.ci-runner.email}"
}

# Create the Gitlab CI Runner instance.
resource "google_compute_instance" "ci-runner" {
  project_id   = var.gcp-project
  name         = "gitlab-ci-runner"
  machine_type = var.ci-runner-instance-type
  zone         = var.gcp-zone

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "10"
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<SCRIPT
echo "Installing GitLab CI Runner"
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
sudo yum install -y gitlab-runner

echo "Installing a version of docker machine with support for specifying GCP service accounts."
gsutil cp gs://gcp-docker-machine/docker-machine /tmp/docker-machine
sudo install /tmp/docker-machine /usr/local/bin/docker-machine

echo "Verifying docker-machine and generating SSH keys ahead of time."
docker-machine create --driver google \
    --google-project ${var.gcp-project} \
    --google-machine-type f1-micro \
    --google-zone ${var.gcp-zone} \
    --google-service-account ${google_service_account.ci-worker.email} \
    --google-scopes https://www.googleapis.com/auth/cloud-platform \
    test-docker-machine

docker-machine rm -y test-docker-machine

echo "Setting GitLab concurrency"
sed -i "s/concurrent = .*/concurrent = ${var.ci-concurrency}/" /etc/gitlab-runner/config.toml

echo "Registering GitLab CI runner with GitLab instance."
sudo gitlab-runner register -n \
    --name "gcp-${var.gcp-project}" \
    --url ${var.gitlab-url} \
    --registration-token ${var.ci-token} \
    --executor "docker+machine" \
    --docker-image "alpine:latest" \
    --machine-idle-time ${var.ci-worker-idle-time} \
    --machine-machine-driver google \
    --machine-machine-name "gitlab-ci-worker-%s" \
    --machine-machine-options "google-project=${var.gcp-project}" \
    --machine-machine-options "google-machine-type=${var.ci-worker-instance-type}" \
    --machine-machine-options "google-zone=${var.gcp-zone}" \
    --machine-machine-options "google-service-account=${google_service_account.ci-worker.email}" \
    --machine-machine-options "google-scopes=https://www.googleapis.com/auth/cloud-platform"

echo "GitLab CI Runner installation complete"
SCRIPT

  service_account {
    email  = google_service_account.ci-runner.email
    scopes = ["cloud-platform"]
  }
}
