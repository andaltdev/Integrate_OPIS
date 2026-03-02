# Data Model: MCP Service Endpoints (Phase 1)

**Feature**: 001-mcp-service-endpoints  
**Date**: 2025-02-18

This feature does not introduce new persistent storage. The “data model” here describes the logical entities exposed through the MCP layer and their relationship to existing service behavior.

## Entities

### Service operation

Represents a single capability exposed by a service that corresponds to one existing HTTP endpoint under `/service` (or `service`).

| Attribute    | Description |
|-------------|-------------|
| Name        | Stable machine-readable identifier (e.g. `ips_tenant_details`, `cds_unlock_tenant`). |
| Description | Human-readable summary for AI clients and operators. |
| HTTP method | GET, POST, DELETE, etc., of the underlying endpoint. |
| Path        | Path template of the underlying endpoint (e.g. `tenants/{tenantName}/details`). |
| Parameters  | Path variables, query params, and/or request body schema. |
| Response    | Success and error behavior consistent with the existing endpoint. |

**Validation**: Parameter names and types must match the underlying controller method. No new validation rules beyond what the service already enforces.

**State**: Operations are stateless; each invocation is independent. No state transitions.

---

### Tool (MCP artifact)

The protocol artifact that represents an invocable operation. One tool per service operation.

| Attribute    | Description |
|-------------|-------------|
| Tool name   | Same as the operation’s stable name (e.g. `ips_tenant_details`). |
| Description | Same as the service operation description. |
| Parameters  | Schema derived from the operation (path/query/body); each parameter has name, description, required/optional. |
| Implementation | Delegates to existing service/controller logic; no direct persistence. |

**Relationships**: Each tool maps to exactly one service operation. Tools are registered only when MCP is enabled.

---

### Prompt template

A named, parameterized text template that maps to a single tool so AI clients can offer natural-language shortcuts.

| Attribute   | Description |
|------------|-------------|
| Prompt name | Matches the tool name (e.g. `ips_tenant_details`). |
| Description | Short label for the prompt (e.g. “Get tenant details”). |
| Arguments   | Same as tool parameters (e.g. `tenantName`). |
| Template text | Human-readable phrase (e.g. “Get tenant details for {tenantName}”). |

**Relationships**: One prompt template per tool; shared name for binding in the protocol.

---

## Service-to-operations mapping (reference)

Derived from existing controllers; MCP tools will mirror this.

- **opis-ips** (ServiceController): tenant sync SSO, transfer status (completed/pending/create-wait-account/create-wait-sso/deactivate-notify), unlock, tenant details, Boomi account info, provisioning status, delete tenant, produce sync messages, setup atom clouds, SSO update/load/sync, trial activation disable/enable/force-activate, delete invalid tenant, SSO certs bulk validation/fix, fix subscription, subscription update, audit log statistics, migrate atom, and others under `/service`.
- **opis-cds-agent** (ServiceController): unlock-tenant by tenantId, tenant-auth-cleanup; DataMigrationController under `/service/migration`.
- **opis-ui-service** (ServiceController): cache invalidateAll, process-statistics, tenant-list, info, audit-logs job metadata, audit-logs ingestion, delete audit-logs.

Not every endpoint must be exposed in v1; the spec requires “at least one” operation per service for success criteria. Implementation can start with a subset and expand.
