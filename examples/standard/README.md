# Standard Example

This directory is a standalone Terraform project for installing a GitLab runner into a Google Cloud project.

## Usage

Create a new GCP project and configure CLI access.

```
`gcloud init`
```

Enable the compute API.

```
gcloud services enable compute.googleapis.com
```

Create a bucket for terraform state.  Modify the region and bucket name as required.
```
gsutil mb -b off -l australia-southeast1 gs://gitlab-runner-terraform-state
```

Modify the `terraform.backend.bucket` variable in `main.tf` to match the bucket name just created.

Configure GCP application credentials for Terraform to use and pick the same user account.  By default, the quota project will be set to the same project configured during `gcloud init` above.

```
gcloud auth application-default login
```

Initialise Terraform and obtain plugins.

```
terraform init
```

From a GitLab project, obtain the URL and token required to register a new runner.  These can be found under the project Settings -> CI/CD page.

The following variables may be set in `terraform.tfvars` or entered on the command later on when prompted by Terraform:

* `gcp_project` - Set to the name of the GCP project where the GitLab CI runner is to be deployed.
* `gitlab_url` - Set to the URL obtained from the GitLab CI settings page.
* `ci_token` - Set to the runner registration token obtained from the GitLab CI settings page.

View the pending Terraform actions.  This will prompt interactively for a number of dynamic fields.

```
terraform plan
```

Deploy the GitLab runner.  This will prompt interactively for the same fields as plan above.

```
terraform apply
```

If the infrastructure is no longer required, tear it down.

```
terraform destroy
```
