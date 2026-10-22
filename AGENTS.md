# AGENTS.md

## Purpose
Portfolio project: harden Kubernetes workload configuration on AWS. Kubernetes defaults are permissive (no resource limits, process-only health checks, an API token mounted into every pod). This project replaces those defaults with explicit configuration. The app is a cluster-introspection tool that makes the configuration visible and verifiable. The app is not the product; the configuration is.

## Project Structure
```
project-repo/
├── .github/workflows/             # mirror checks
├── app/                           # application code
│   ├── main.py                    # introspection service (GET /, GET /healthz)
│   └── requirements.txt           # pinned Python dependencies
├── artifacts/                     # screenshots used in README
├── k8s/                           # Kubernetes manifests (Deployment, Service, ConfigMap)
├── terraform/                     # AWS infrastructure
├── .gitlab-ci.yml                 # CI/CD pipeline
├── AGENTS.md                      # operating rules for AI agents
├── CLAUDE.md                      # loads AGENTS.md for Claude
├── Dockerfile                     # multi-stage build, minimal runtime, non-root user
└── README.md
    ├── Overview                   # problem + what it proves (2–3 lines)
    ├── Architecture               # diagram + documentation
    ├── Getting Started            # instructions on how to run it
    ├── Evidence
    │   ├── Embedded screenshots   # 2–3 key images shown inline
    │   ├── Artifact links         # remaining screenshots in artifacts/
    │   ├── GitHub links           # Actions workflow page, fix commits
    │   └── Command output         # apply / destroy, curl health checks
    ├── Incident                   # documentation about what broke, root cause, fix
    └── Runbook                    # documentation about how to operate it
```

## Commands
- Local:    `docker build -t k8s-app .` → `docker run -p 8080:8080 k8s-app`
              → `curl localhost:8080` and `curl localhost:8080/healthz`
- Infra:    `terraform init` → `terraform plan` → `terraform apply`
- Access:   (set once the cluster type is confirmed)
- Cluster:  `kubectl get nodes` → `kubectl get pods -A`
- Deploy:   `kubectl apply -f k8s/`
- Verify:   `kubectl get pods,svc` → `kubectl port-forward svc/k8s-app 8080:80`
            → `curl localhost:8080/` and `curl localhost:8080/healthz`
- Remove:   `kubectl delete -f k8s/` → `terraform destroy`

## Conventions
- Deployment and Service are named `k8s-app`.
- Service port 80 → container port 8080.

## Kubernetes configuration rules
- Every container sets CPU and memory requests and limits.
- Liveness and readiness probes use `GET /healthz`.
- `automountServiceAccountToken: false` unless a workload needs the API.
- Containers run as non-root.
- `POD_NAME`, `POD_NAMESPACE`, `NODE_NAME` come from the Downward API.
- `CONFIG_VALUE` comes from a ConfigMap; `APP_VERSION` matches the image tag.

## Rules
- Plan first: describe the change and wait for approval before editing files.
- Do not modify `app/` unless explicitly asked; change configuration, not code.
- Never commit secrets, IP addresses, AWS account IDs, or host details.
- Always show `terraform plan` output before any `terraform apply`.
- Every `terraform apply` must end with a `terraform destroy` to control cost.
- Pin versions for images, dependencies, providers, and Kubernetes.
- Explain every change: what changed, why, and how to verify it.

## Definition of done
- `GET /` returns real values: `pod_name`, `namespace`, `node` are not `unknown`,
  and `config_value` is not `unset`.
- `GET /healthz` returns 200 and the probes pass.
- Pods run with limits set and no service account token mounted.
- Pipeline passes on GitLab.
- `terraform destroy` completes with no resources left.
- README updated if behavior or commands changed.
