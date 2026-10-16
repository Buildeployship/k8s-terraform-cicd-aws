# k8s-terraform-cicd-aws

## Problem

Kubernetes runs a container with permissive defaults: no resource limits, no health checks beyond "the process is running," and an API token mounted into every pod. A container can be running and still not be configured correctly.

## Tech stack

```
Docker       — multi-stage build, minimal runtime image, non-root user
GitLab CI/CD — build, push, deploy, verify; mirrors to GitHub
Kubernetes   — orchestration and workload configuration
Terraform    — reproducible provisioning as Infrastructure as Code
```

## Quick start

clone → set CI/CD variables → terraform init → terraform apply →
configure kubectl → pipeline builds, pushes, deploys → verify endpoint

```bash
docker build -t k8s-app .
docker run -p 8080:8080 k8s-app
curl localhost:8080
```

## App

A cluster-introspection service. It reports what the running container can see about its own environment, so the cluster's wiring is visible and verifiable. The app is not the product; the configuration around it is.

**Endpoints:**

```
GET /          → the container's view of its own environment (JSON):
                 version, pod_name, namespace, node, config_value
GET /healthz   → {"status": "healthy"}, 200
```

**Where the data is derived:**

```
version       → env var APP_VERSION     (default: 0.1.0)
pod_name      → env var POD_NAME        (default: unknown)
namespace     → env var POD_NAMESPACE   (default: unknown)
node          → env var NODE_NAME       (default: unknown)
config_value  → env var CONFIG_VALUE    (default: unset)
```
