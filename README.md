# k8s-terraform-cicd-aws

## Purpose
A production Kubernetes deployment on AWS EKS, provisioned with
Terraform and delivered through GitLab CI/CD. A containerized service
runs on the cluster — configured correctly from the ground up.

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
Python       — app

## Python App
A cluster-introspection service. One HTTP endpoint that returns what
the running container can see about its own environment: its version,
which pod it's in, which namespace, which node, and a value handed to
it by Kubernetes config. A second endpoint that reports health.
The app is not the product — the configuration around it is.
Its job is to make the cluster's wiring visible and verifiable by reading its own
environment and returning it. It answers "where am I and am I healthy?"

**Endpoints:**
GET /          → the pod's view of its own environment (JSON):
                 version, pod_name, namespace, node, config_value
GET /healthz   → health for liveness and readiness probes:
                 {"status": "healthy"}, 200

**Where the data is derived:**
version       → env var APP_VERSION     (set in the image/ConfigMap)
pod_name      → env var POD_NAME        (injected by k8s downward API)
namespace     → env var POD_NAMESPACE   (injected by k8s downward API)
node          → env var NODE_NAME       (injected by k8s downward API)
config_value  → env var CONFIG_VALUE    (injected from ConfigMap, Phase 7)

**What each field proves:**
version       → which image is live; confirms the pipeline deployed
                the right build (Phase 9)
pod_name      → the pod is running and identifiable
namespace     → namespace isolation is real (Phase 8)
node          → the pod scheduled onto the EKS node group (Phase 5)
config_value  → the ConfigMap injected correctly (Phase 7)

**Structure:**
app/
  main.py            → the whole app (~30 lines)
  requirements.txt   → flask==3.1.3

**Why it matters:**
Change the image, redeploy, hit the endpoint: the version changes. That
is the evidence the rollout worked. The app is the instrument the cluster
is read through — without it, "deploy succeeded" is a green checkmark;
with it, correct wiring can be demonstrated.

## ADR

### Dependencies — Python app and pinned versions
**Status** Accepted
**Context** Python is the language the app is written in and Flask is the third-party library (web framework) that handles the HTTP part. The workload only reads environment variables and returns JSON. Builds must be reproducible across local, Docker, and CI.
**Decision** Use Python (Flask). This establishes a containerized, cluster-deployed Python service as a reusable packaging-and-deploy pattern for later ML-serving work. Pin exact versions (flask==3.1.3).
**Consequences** No benefit to this project over another language; the value is trajectory-level. Carries a Python runtime in the image (mitigated by a slim base and multi-stage build). Aligns the next repo to build on this pattern. Identical environment everywhere; manual upgrades to adopt newer versions.

## Runbook

**deploy**

**verify**

**roll back**

**tear down**
