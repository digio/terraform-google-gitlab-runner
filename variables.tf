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

variable "gcp-project" {
  type        = string
  description = "The GCP project to deploy the runner into."
}
variable "gcp-zone" {
  type        = string
  description = "The GCP zone to deploy the runner into."
}
variable "gitlab-url" {
  type        = string
  description = "The URL of the GitLab server hosting the projects to be built."
}
variable "ci-token" {
  type        = string
  description = "The runner registration token obtained from GitLab."
}
variable "ci-runner-instance-type" {
  type        = string
  default     = "f1-micro"
  description = <<EOF
The instance type used for the runner. This shouldn't need to be changed because the builds
themselves run on separate worker instances.
EOF
}
variable "ci-concurrency" {
  type        = number
  default     = 1
  description = "The maximum number of worker instances to create."
}
variable "ci-worker-idle-time" {
  type        = number
  default     = 300
  description = "The maximum idle time for workers before they are shutdown."
}
variable "ci-worker-instance-type" {
  type        = string
  default     = "n1-standard-1"
  description = "The worker instance size.  This can be adjusted to meet the demands of builds jobs."
}
