# CLAUDE.md

Project instructions for Claude Code. See individual project READMEs for detailed setup.

## Project Overview

OPIS (Operational Process Integration System) - A microservices platform for managing data integration processes between enterprise systems.

## Repository Structure

This is a **polyrepo root** hosted on [GitHub](https://github.com/andaltdev/Integrate_OPIS). It tracks shared configuration, documentation, and tooling only. The 19 microservice repositories live on Azure DevOps (and 1 on GitHub) and are cloned as sibling directories.

**What the root repo tracks:**
- `CLAUDE.md`, `README.md` - Project documentation
- `.claude/settings.json` - Shared Claude Code settings
- `.mcp.json` - MCP server configuration
- `.specify/`, `specs/` - Specifications
- `scripts/` - Developer tooling (clone-all, MCP wrappers)

**Clone all repos:** `./scripts/clone-all.sh`

## Architecture

### Core Services (Java/Spring Boot)
- `opis-ips` - Integration Processing Service (core workflows)
- `opis-cds-agent` - Cloud Data Service Agent (sync & tenant management)
- `opis-ui-service` - UI Backend (REST APIs)
- `opis-availability-tests` - Service monitoring
- `opis-boomi-api` - Boomi platform integration

### Frontend Applications
- `opis-web` - Main web app (JavaScript/Webpack)
- `opis-process-reporting-widget` - Reporting dashboard (React/TypeScript/Vite)

### Connectors
- `opis-connector-all` - Multi-project with connectors for 3E, Aderant, Boomi, DocuSign, iManage, Intapp, Microsoft Graph, NetDocuments, etc.

### Infrastructure
- `integrate-opis-argo-applications` - Helm charts and ArgoCD configs
- `opis-argo-applications` - ArgoCD application manifests
- `opis-db-provisioner` - Database provisioning

## Tech Stack

| Layer | Technologies |
|-------|-------------|
| Backend | Java 11, Spring Boot 2.6-2.7, Gradle, PostgreSQL |
| Frontend | React 18, TypeScript, Vite, Ant Design (widget); ES6, Webpack (web) |
| Security | Keycloak, Spring Security |
| Messaging | Apache Kafka |
| Infra | Kubernetes, ArgoCD, Helm, Docker |
| CI/CD | Jenkins, Azure DevOps, Artifactory |

## Development Commands

### Java/Gradle Projects
```bash
./gradlew clean build      # Build
./gradlew test             # Run offline tests only
./gradlew allTests         # Run all tests (incl. integration)
./gradlew jacocoTestReport # Coverage report
```

### opis-web (JavaScript)
```bash
npm install && npm run build  # Install & build
npm test                      # Run tests
npm run dev                   # Dev server
```

### opis-process-reporting-widget (React/TypeScript)
```bash
npm install && npm run build  # Install & build
npm test                      # Run tests
npm run dev                   # Dev server
npm run lint                  # Lint code
npm run check-types           # Type check
```

### Connectors
```bash
./gradlew :opis-connector-<name>:build  # Build specific connector
./gradlew artifactoryPublish            # Publish artifacts
```

## Code Conventions

- **Java**: Follow existing Spring Boot patterns; code style enforced by SonarQube
- **TypeScript/React**: ESLint and TypeScript compiler enforce style; run `npm run lint` before committing
- **JavaScript**: Follow existing patterns in opis-web

## Testing

### Java Projects
- Default `./gradlew test` runs offline tests only

### Frontend Projects
- Unit tests: Vitest (widget), Mocha/Chai (web)
- Browser tests: Playwright (widget)

## Repository Etiquette

- Run tests before pushing: `./gradlew test` or `npm test`
- Run linting for frontend changes: `npm run lint`
- Follow existing commit message patterns in the repo
- Never commit credentials or secrets - use Vault in production

### Feature Branch Naming

Each feature branch must be linked to a JIRA ticket:

- **Pattern**: `{JIRA-ID}-{description}`
- **JIRA URL**: https://intapp.atlassian.net/browse/{JIRA-ID}
- **Example**: `IAAS-3954-update-atom-cloud-runtime-1.2.0`

Rules:
1. Every feature branch must start with a valid JIRA ticket ID (e.g., `IAAS-XXXX`)
2. Use lowercase and hyphens for the description

## Key Files

| File | Purpose |
|------|---------|
| `build.gradle` | Java build config and dependencies |
| `application.yml` | Spring Boot config |
| `application-{env}.yml` | Environment-specific config |
| `package.json` | Node.js dependencies and scripts |
| `vite.config.ts` | Vite build config (widget) |
| `webpack.config.js` | Webpack config (web) |

## Environment Setup

- **Database**: PostgreSQL for opis-ips and opis-cds-agent
- **Profiles**: Use `dev,local` for local development
- **External deps**: Keycloak, Kafka, Vault, Boomi

## Deployment

- GitOps via ArgoCD
- Helm charts in `integrate-opis-argo-applications/helm/`
- Pipelines: `Jenkinsfile` or `azure-pipelines.yml`

## MCP (Model Context Protocol)

Selected OPIS services expose operations to AI clients via the Model Context Protocol (MCP) on a `/mcp` endpoint when enabled. Full quickstart: `specs/001-mcp-service-endpoints/quickstart.md`.

### Enable MCP per service

Set the corresponding property to `true` (or use `MCP_ENABLED=true` where mapped in application config):

| Service         | Property |
|-----------------|----------|
| opis-ips        | `com.intapp.opis.ips.mcp.enabled=true` |
| opis-cds-agent  | `com.intapp.opis.cdsagent.mcp.enabled=true` (relaxed: `com.intapp.opis.cds-agent.mcp.enabled`) |
| opis-ui-service | `com.intapp.opis.ui-service.mcp.enabled=true` |

When enabled, Spring AI MCP server and annotation scanner are turned on; the same config drives `spring.ai.mcp.server.enabled` and `annotation-scanner.enabled`. The MCP endpoint is protected by the same security rules as `/service` (e.g. IPS_USER, CDS_AGENT_USER, UI_SERVICE_USER).

### Tool naming

- **ips_** – opis-ips (e.g. `ips_tenant_details`, `ips_tenant_sync_sso`, `ips_force_unlock`)
- **cds_** – opis-cds-agent (e.g. `cds_unlock_tenant`, `cds_tenant_auth_cleanup`)
- **ui_** – opis-ui-service (e.g. `ui_cache_invalidate_all`, `ui_service_info`)

## Observability

### Grafana Dashboards

Grafana dashboards are managed in the `opis-observability` repository:
- **Repository**: `opis-observability/`
- **Location**: `grafana/dev/` (organized by service)
- **Documentation**: See `opis-observability/README.md` and `opis-observability/METRICS.md`

Dashboard categories:
- `opis-ips/` - Integration Processing Service dashboards
- `opis-ui-service/` - UI Service dashboards
- `opis-atom-cloud/` - Atom Cloud dashboards
- `opis-atom-cloud-self-service/` - Self-service dashboards
- `general/` - Cross-cutting dashboards (Health, Kafka, Logs, Volumes)

### Metrics Configuration

OPIS services expose Prometheus-compatible metrics via Spring Boot Actuator + Micrometer.

#### opis-ips Metrics

- **Endpoint**: `https://<pod-ip>:8083/prometheus`
- **Port**: 8083 (configured in Helm `values.yaml`)
- **Service**: `opis-ips-headless` (headless ClusterIP service)
- **Service Definition**: `integrate-opis-argo-applications/helm/opis-ips/templates/service-headless.yaml`

**Prometheus Service Discovery:**
Pods are annotated for automatic discovery:
```yaml
prometheus.io/scrape: "true"
prometheus.io/port: "8083"
prometheus.io/path: /prometheus
prometheus.io/scheme: https
```

**Available Metrics:**
- Custom metrics prefix: `ips_metrics_`
- Tenant metrics: counts, subscriptions, deployed processes, licenses
- Atom metrics: deployed processes, CPU/RAM/heap, versions
- Process execution metrics: status, execution time
- Standard Spring Boot metrics: JVM, health, startup time

See `opis-observability/METRICS.md` for complete metrics documentation.

#### Other Services

- **opis-ui-service**: Port 8083, endpoint `/prometheus`
- **opis-cds-agent**: Port 8092, endpoint `/prometheus`
- **opis-atom-cloud-self-service**: Port 8083, prefix `opis_atom_cloud_self_service`

### Metrics Architecture

```
OPIS Services → Spring Boot Actuator → Prometheus Endpoint → Prometheus → Grafana
```

- Metrics exposed via `/prometheus` endpoint on dedicated metrics port
- Prometheus scrapes using pod annotations (service discovery)
- Headless services enable direct pod-to-pod metrics scraping
- Grafana queries Prometheus for visualization

### Key Configuration Files

| File | Purpose |
|------|---------|
| `opis-observability/METRICS.md` | Complete metrics documentation |
| `integrate-opis-argo-applications/helm/opis-ips/templates/service-headless.yaml` | Headless service for metrics |
| `integrate-opis-argo-applications/helm/opis-ips/values.yaml` | Metrics port configuration (`metrics.port: 8083`) |
| `opis-ips/src/main/resources/application.yml` | Spring Boot Actuator configuration |
| `opis-ips/src/main/java/com/intapp/opis/ips/config/MetricsNames.java` | Metric name constants |
