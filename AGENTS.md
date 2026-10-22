# AGENTS.md

## Purpose
Portfolio project: a containerized Flask app delivered to Kubernetes
through GitLab CI/CD, with infrastructure provisioned by Terraform on AWS.

## Layout
- `app/main.py`        Flask app (introspection endpoints)
- `requirements.txt`   pinned Python dependencies
- `Dockerfile`         container image (non-root user, gunicorn)
- `k8s/`               Kubernetes manifests (Deployment, Service)
- `terraform/`         AWS infrastructure
- `.gitlab-ci.yml`     pipeline (GitLab primary, GitHub mirror)
- `artifacts/`         screenshots used in README

## Commands
- Build:    `docker build -t k8s-app .`
- Run:      `docker run -p 8080:8080 k8s-app`
- Verify:   `curl localhost:8080`
- Infra:    `terraform init` → `terraform plan` → `terraform apply`
- Deploy:   `kubectl apply -f k8s/`
- Check:    `kubectl get pods,svc`
- Remove:   `kubectl delete -f k8s/` → `terraform destroy`

## Rules
- Plan first: describe the change and wait for approval before editing files.
- Never commit secrets, IP addresses, AWS account IDs, or host details.
- Always show `terraform plan` output before any `terraform apply`.
- Every `terraform apply` must end with a `terraform destroy` to control cost.
- Pin versions for images, dependencies, and providers.
- Explain every change: what changed, why, and how to verify it.

## Definition of done
- Image builds and the app responds to `curl`.
- Pods are running and the Service responds in the cluster.
- Pipeline passes on GitLab.
- `terraform destroy` completes with no resources left.
- README updated if behavior or commands changed.
