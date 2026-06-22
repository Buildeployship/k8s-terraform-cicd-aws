# k8s-terraform-cicd-aws

## What it is
A production Kubernetes deployment on AWS EKS, provisioned with
Terraform and delivered through GitLab CI/CD. A containerized service
runs on the cluster — configured correctly from the ground up.

## Why it exists
Most teams can get a container running on Kubernetes. Configuring 
it correctly is the problem. This project closes that gap: resource limits, health
probes, least-privilege RBAC, namespace isolation, and secrets handled
properly — the difference between "it runs" and "it runs correctly."

## Architecture
[ASCII diagram: GitLab CI/CD → Docker build → ECR → EKS;
 Terraform → VPC + IAM + EKS; Kubernetes → Deployment + Service +
 ConfigMap + RBAC + Namespace]

## Prerequisites
AWS account, AWS CLI configured, Terraform, kubectl, Docker,
a GitLab instance with a registered runner.

## Quick start
clone → set CI/CD variables → terraform init → terraform apply →
configure kubectl → pipeline builds, pushes, deploys → verify endpoint

## Project structure
[directory tree — filled when the repo is complete]

## Phases / Features
[the nine phases, each with the problem it addresses]

## Tech stack
Kubernetes   — orchestration and workload configuration
Terraform    — provisions VPC, IAM, ECR, EKS (reproducible, drift-proof)
Docker       — multi-stage build, minimal runtime image
GitLab CI/CD — build, push, deploy, verify; mirrors to GitHub
AWS          — EKS, ECR, IAM, VPC, S3 + DynamoDB (state backend)

## Decisions
See docs/adr/ for why EKS over self-managed, why remote state,
and why RBAC and namespaces from the start.
