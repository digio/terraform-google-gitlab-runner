output "ci-worker-service-account" {
  value       = google_service_account.ci-worker
  description = <<EOF
The service account created for the worker instances.
Privileges/roles may need to be assigned to this service account depending on the activities
performed by the build.
EOF
}
