# GCP GitLab Runner GitLab CI Terraform

A Terraform module for configuring a GCP-based GitLab CI Runner.

Features of this module include:

* When no jobs are active, the only cost is a small instance monitoring for new jobs.
* The docker+machine executor is used to support auto-scaling.  This allows the solution to scale up and down as demand requires, with the minimum cost (during zero activity) being the cost of a tiny instance.
