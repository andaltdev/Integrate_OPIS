---
name: opis-k8s-deploy
description: Deploy and manage OPIS on Kubernetes using ArgoCD and Helm. Use when deploying services, managing Helm charts, checking pod status, or troubleshooting Kubernetes deployments. Covers GitOps workflows.
allowed-tools: Bash, Read, Glob, Grep
---

# OPIS Kubernetes & ArgoCD Deployment Skill

## ArgoCD GitOps Structure

```
integrate-opis-argo-applications/
├── apps/                    # ArgoCD Application manifests
├── appsets/                 # ApplicationSets for multi-env
├── helm/                    # Helm charts
│   ├── opis-ips/
│   ├── opis-cds-agent/
│   ├── opis-ui-service/
│   ├── opis-web/
│   ├── opis-atom-cloud-elastic/
│   └── opis-atom-cloud-logs/
└── clusters/                # Cluster-specific configs
```

## Quick Commands

### ArgoCD
```bash
# List applications
argocd app list

# Get app details
argocd app get <app-name>

# Sync application
argocd app sync <app-name>

# Force sync with prune
argocd app sync <app-name> --prune --force

# Rollback
argocd app rollback <app-name> <history-id>

# App history
argocd app history <app-name>
```

### Kubectl
```bash
# Get pods in namespace
kubectl get pods -n <namespace>

# Describe pod
kubectl describe pod <pod-name> -n <namespace>

# View logs
kubectl logs <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous  # Previous container

# Exec into pod
kubectl exec -it <pod-name> -n <namespace> -- /bin/sh

# Port forward
kubectl port-forward <pod-name> 8080:8080 -n <namespace>
```

### Helm
```bash
# Lint chart
helm lint helm/<chart-name>

# Template (dry-run)
helm template <release> helm/<chart> -f values.yaml

# Install
helm install <release> helm/<chart> -f values.yaml -n <namespace>

# Upgrade
helm upgrade <release> helm/<chart> -f values.yaml -n <namespace>

# Rollback
helm rollback <release> <revision> -n <namespace>

# List releases
helm list -n <namespace>
```

## Helm Chart Structure

```yaml
# Chart.yaml
apiVersion: v2
name: opis-service
version: 1.0.0
appVersion: "1.0.0"

# values.yaml
replicaCount: 2
image:
  repository: artifactory.play.intapp.com/opis/service
  tag: latest
  pullPolicy: IfNotPresent
resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 100m
    memory: 256Mi
```

## Environment Values

| Environment | Values File | Namespace |
|-------------|-------------|-----------|
| dev | values-dev.yaml | opis-dev |
| qa | values-qa.yaml | opis-qa |
| prod | values-prod.yaml | opis-prod |

## Common Deployments

### Deploy New Version
1. Update image tag in values file
2. Commit to git
3. ArgoCD auto-syncs or manual sync

### Scale Service
```bash
kubectl scale deployment <name> --replicas=3 -n <namespace>
```

### Check Resource Usage
```bash
kubectl top pods -n <namespace>
kubectl top nodes
```

## Troubleshooting

### Pod CrashLoopBackOff
```bash
kubectl describe pod <pod> -n <ns>
kubectl logs <pod> -n <ns> --previous
```

### ImagePullBackOff
- Check image name/tag
- Verify imagePullSecrets
- Check registry access

### Pending Pods
- Check node resources: `kubectl describe nodes`
- Check PVC status: `kubectl get pvc -n <ns>`

For detailed Helm chart customization, see [helm-customization.md](helm-customization.md).
