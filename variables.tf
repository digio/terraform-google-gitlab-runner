variable "gcp-project" { type = string }
variable "gcp-zone" { type = string }
variable "gitlab-url" { type = string }
variable "ci-token" { type = string }
variable "ci-runner-instance-type" {
  type = string
  default = "f1-micro"
}
variable "ci-concurrency" {
  type = number
  default = 1
}
variable "ci-worker-idle-time" {
  type = number
  default = 300
}
variable "ci-worker-instance-type" {
  type = string
  default = "n1-standard-1"
}
