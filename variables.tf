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

# Global options
variable "ci_token" {
  type        = string
  description = "The runner registration token obtained from GitLab."
}
variable "gcp_project" {
  type        = string
  description = "The GCP project to deploy the runner into."
}
variable "gcp_zone" {
  type        = string
  description = "The GCP zone to deploy the runner into."
}
variable "gitlab_url" {
  type        = string
  description = "The URL of the GitLab server hosting the projects to be built."
}
variable "gcp_resource_prefix" {
  type    = string
  default = "gitlab-ci"
  description = "The prefix to apply to all GCP resource names (e.g. <prefix>-runner, <prefix>-worker-1)."
}

# Runner options
variable "ci_runner_disk_size" {
  type        = string
  default     = "20"
  description = "The size of the persistent disk in GB."
}
variable "ci_runner_gitlab_name" {
  type        = string
  default     = ""
  description = "Register the runner in GitLab using this name.  If empty the value \"gcp-$${var.gcp_project}\" will be used."
}
variable "ci_runner_gitlab_tags" {
    type        = string
    default     = ""
    description = "Register the runner to execute GitLab jobs with these tags."
}
variable "ci_runner_gitlab_untagged" {
    type        = string
    default     = "true"
    description = "Register the runner to also execute GitLab jobs that are untagged."
}
variable "ci_runner_instance_type" {
  type        = string
  default     = "f1-micro"
  description = <<EOF
The instance type used for the runner. This shouldn't need to be changed because the builds
themselves run on separate worker instances.
EOF
}

# Worker options
variable "ci_concurrency" {
  type        = number
  default     = 1
  description = "The maximum number of worker instances to create."
}
variable "ci_worker_disk_size" {
  type        = string
  default     = "10"
  description = "The size of the persistent disk in GB."
}
variable "ci_worker_idle_time" {
  type        = number
  default     = 300
  description = "The maximum idle time for workers before they are shutdown."
}
variable "ci_worker_instance_tags" {
  type        = string
  default     = "gitlab-ci-worker"
  description = "The GCP instance networking tags to apply."
}
variable "ci_worker_instance_type" {
  type        = string
  default     = "n1-standard-1"
  description = "The GCP instance type.  This can be adjusted to meet the demands of builds jobs."
}
variable "docker_privileged" {
  type        = string
  default     = "false"
  description = "Give extended privileges to container."
}

# Pre/post hook scripts
variable "pre_clone_script" {
  type        = string
  default     = ""
  description = <<EOF
Commands to be executed on the runner before cloning the Git repository.
NOTE: this script runs within the gitlab-runner helper image.
EOF
}

variable "post_clone_script" {
  type        = string
  default     = ""
  description = <<EOF
Commands to be executed on the runner after cloning the Git repository.
NOTE: this script runs within the gitlab-runner helper image.
EOF
}

variable "pre_build_script" {
  type        = string
  default     = ""
  description = <<EOF
Commands to be executed on the runner before executing the build.
NOTE: this script runs within the build image specified by .gitlab-ci.yml.
EOF
}

variable "post_build_script" {
  type        = string
  default     = ""
  description = <<EOF
Commands to be executed on the runner after executing the build.
NOTE: this script runs within the build image specified by .gitlab-ci.yml.
EOF
}
