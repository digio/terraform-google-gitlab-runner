# GCP GitLab Runner

A Terraform module for configuring a GCP-based GitLab CI Runner.

This runner is configured to use the docker+machine executor which allows the infrastructure to be scaled up and down as demand requires.  The minimum cost (during zero activity) is the cost of an f1-micro instance.

The long-running runner instance runs under a `gitlab-ci-runner` service account.  This account will be granted all required permissions to spawn worker instances on demand.

The worker instances run under a `gitlab-ci-worker` service account.  This account will need to be granted any privileges required to perform build and deploy activities.  For example, the `storage.admin` role can be granted to the worker account as follows:

```
resource "google_project_iam_member" "worker-storage-admin" {
  role    = "roles/storage.admin"
  member = "serviceAccount:${module.ci.ci-worker-service-account.email}"
}
```
