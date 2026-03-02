# MCP Endpoint and Tool Contract

**Feature**: 001-mcp-service-endpoints  
**Date**: 2025-02-18

The Model Context Protocol (MCP) is not REST. AI clients discover and invoke operations via the MCP protocol (e.g. list tools, call tool). This document describes the endpoint, security, and tool naming contract for opis-ips, opis-cds-agent, and opis-ui-service.

## Endpoint

| Service        | MCP endpoint (when enabled) | Base URL (example) |
|----------------|------------------------------|--------------------|
| opis-ips       | `POST /mcp` (streamable HTTP) | `https://<host>/mcp` |
| opis-cds-agent | `POST /mcp`                  | `https://<host>/mcp` |
| opis-ui-service| `POST /mcp`                  | `https://<host>/mcp` |

Exact path is configurable via `spring.ai.mcp.server.streamable-http.mcp-endpoint` (default `/mcp`). Clients use the MCP protocol over this endpoint to list tools and invoke them with arguments.

## Security

- The `/mcp` endpoint MUST be protected by the same security rules as `/service` (or `service`) in each application.
- Only authenticated users (or service accounts) that are allowed to call service endpoints may call the MCP endpoint.
- No additional roles or authorities are introduced for MCP.

## Tool naming convention

- **Prefix**: Each tool name is prefixed by service to avoid collisions when a client talks to multiple services:
  - **ips_** – opis-ips (Integration Processing Service)
  - **cds_** – opis-cds-agent (CDS Agent)
  - **ui_**  – opis-ui-service (UI Service)
- **Suffix**: Snake_case operation name derived from the underlying endpoint (e.g. `tenant_details`, `unlock_tenant`, `cache_invalidate_all`).
- **Examples**: `ips_tenant_details`, `ips_tenant_sync_sso`, `cds_unlock_tenant`, `cds_tenant_auth_cleanup`, `ui_cache_invalidate_all`, `ui_service_info`.

## Tool list (target subset for v1)

Implementations may expose more tools over time. Minimum for success criteria:

| Service        | Tool name (example)       | Description (example)              | Key parameters   |
|----------------|---------------------------|------------------------------------|------------------|
| opis-ips       | ips_tenant_details        | Get extended tenant info by name   | tenantName       |
| opis-cds-agent | cds_unlock_tenant         | Unlock tenant by ID                | tenantId         |
| opis-cds-agent | cds_tenant_auth_cleanup   | Clean up tenant auth info          | (none)           |
| opis-ui-service| ui_cache_invalidate_all   | Invalidate all caches              | (none)           |
| opis-ui-service| ui_service_info           | Service info / heartbeat          | (none)           |

Full tool set will mirror the service controllers; see data-model.md and the respective ServiceController classes for the complete operation list.

## Prompts

Each tool has a matching prompt with the same name (e.g. `ips_tenant_details`) so clients can offer natural-language shortcuts. Prompt arguments match tool parameters.

## Protocol

Clients use the MCP protocol (e.g. Streamable HTTP transport) to:

1. Connect to `https://<host>/mcp`.
2. List tools (and optionally prompts).
3. Call a tool by name with a JSON object of argument names and values.

Responses and errors are as defined by the MCP specification and the Spring AI MCP Server implementation. Behavior and error handling for each tool MUST match the underlying service endpoint.
