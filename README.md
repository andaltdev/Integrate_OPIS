# Integrate_OPIS

Polyrepo root for the OPIS (Operational Process Integration System) platform. This repository tracks shared configuration, documentation, scripts, and AI tooling. Each microservice lives in its own repository on Azure DevOps (or GitHub).

## Repositories

| Repository | Platform | Description |
|------------|----------|-------------|
| [integrate-opis-argo-applications](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/integrate-opis-argo-applications) | ADO | Helm charts and ArgoCD configs |
| [opis-atom-cloud](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-atom-cloud) | ADO | Atom Cloud runtime |
| [opis-atom-cloud-self-service](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-atom-cloud-self-service) | ADO | Atom Cloud self-service portal |
| [opis-availability-tests](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-availability-tests) | ADO | Service monitoring |
| [opis-boomi-api](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-boomi-api) | ADO | Boomi platform integration |
| [opis-boomi-mcp](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-boomi-mcp) | ADO | Boomi MCP integration |
| [opis-cds-agent](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-cds-agent) | ADO | Cloud Data Service Agent |
| [opis-cds-agent-dto](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-cds-agent-dto) | ADO | CDS Agent data transfer objects |
| [opis-connector-all](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-connector-all) | ADO | Multi-project connectors |
| [opis-db-provisioner](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-db-provisioner) | ADO | Database provisioning |
| [opis-ips](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-ips) | ADO | Integration Processing Service (core) |
| [opis-notification-service](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-notification-service) | ADO | Notification service |
| [opis-notification-service-next](https://github.com/andaltdev/opis-notification-service-next) | GitHub | Notification service (next gen) |
| [opis-observability](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-observability) | ADO | Grafana dashboards and metrics |
| [opis-process-reporting-widget](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-process-reporting-widget) | ADO | Reporting dashboard (React/TypeScript) |
| [opis-shared-library](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-shared-library) | ADO | Shared Java library |
| [opis-ui-service](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-ui-service) | ADO | UI Backend REST APIs |
| [opis-vault-migration-tool](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-vault-migration-tool) | ADO | Vault migration tool |
| [opis-web](https://dev.azure.com/intappdevops/Integrate_OPIS/_git/opis-web) | ADO | Main web app (JavaScript/Webpack) |

## Getting Started

### Prerequisites

- Git with SSH access to Azure DevOps (`intappdevops` org)
- Java 11, Node.js 18+
- Docker (for local Kubernetes)

### Clone All Repos

```bash
# 1. Clone this root repo
git clone https://github.com/andaltdev/Integrate_OPIS.git
cd Integrate_OPIS

# 2. Clone all microservice repos
./scripts/clone-all.sh
```

### Optional: PostgreSQL MCP

```bash
cp .env.postgres.example .env.postgres
chmod 600 .env.postgres
# Edit .env.postgres with your connection string
```

## What This Repo Tracks

- `CLAUDE.md` / `README.md` - Project documentation
- `.claude/` - Claude Code settings (shared)
- `.mcp.json` - MCP server configuration
- `.specify/` - Specification files
- `specs/` - Technical specifications
- `scripts/` - Developer tooling scripts
