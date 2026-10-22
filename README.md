# k8s-terraform-cicd-aws

## Overview

Kubernetes runs containers with permissive defaults: no resource limits, no health checks beyond "the process is running," and an API token mounted into every pod. A container can be running and still not be configured correctly. This project replaces those defaults with explicit configuration and proves each change with a cluster-introspection app.

## Architecture

```
Docker       — multi-stage build, minimal runtime image, non-root user
GitLab CI/CD — mirrors to GitHub (build, push, deploy, verify)
Kubernetes   — orchestration and workload configuration
Terraform    — AWS reproducible provisioning as Infrastructure as Code
```

**App:** a cluster-introspection service. It reports what the running container can see about its own environment, so the cluster's wiring is visible and verifiable. The app is not the product; the configuration around it is.

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

## Getting Started

clone → set CI/CD variables → terraform init → terraform apply →
configure kubectl → pipeline builds, pushes, deploys → verify endpoint

```bash
docker build -t k8s-app .
docker run -p 8080:8080 k8s-app
curl localhost:8080
curl localhost:8080/healthz
```

## Evidence

**Command output (local run):**

```
$ curl localhost:8080
{"config_value":"unset","namespace":"unknown","node":"unknown","pod_name":"unknown","version":"0.1.0"}

$ curl localhost:8080/healthz
{"status":"healthy"}
```

Outside Kubernetes, the app reports its defaults. Once deployed with explicit configuration, `pod_name`, `namespace`, `node` and `config_value` report real values.
