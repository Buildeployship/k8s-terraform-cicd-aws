# Runbook — k8s-terraform-cicd-aws

## Service overview
What the service is, what it runs on, who owns it.

## Prerequisites
Access, tools, and permissions needed to operate it.

## Deploy
Step-by-step: terraform apply → configure kubectl →
trigger pipeline → confirm rollout.

## Verify
How to confirm success: kubectl get pods, hit the endpoint,
check version / pod name / namespace in the response.

## Roll back
How to revert a bad deploy: kubectl rollout undo, or redeploy
a prior image tag.

## Tear down
terraform destroy — order, what to confirm gone (nodes, NAT gateway,
load balancer, EBS volumes), how to avoid orphaned AWS charges.

## Escalation
Where to look when a step fails (pipeline logs, pod events,
terraform state).
