# Quickstart: MCP Service Endpoints

**Feature**: 001-mcp-service-endpoints  
**Date**: 2025-02-18

This guide describes how to enable MCP for each service and verify that an AI client can list and invoke tools. It assumes the implementation has been completed (MCP dependencies, `McpEnabledCondition`, and `ServiceMcpTools` classes per service).

## Prerequisites

- Java 17, Gradle
- One or more of opis-ips, opis-cds-agent, opis-ui-service built and runnable
- An MCP-capable client (e.g. IDE with MCP support, or a small script using an MCP SDK) for testing

## Enable MCP per service

Each service uses its own property namespace. Set the corresponding property (or environment variable) to `true` so that MCP beans and the `/mcp` endpoint are active.

### opis-ips

```properties
# application.yml or environment
com.intapp.opis.ips.mcp.enabled=true
# Or: MCP_ENABLED=true (if mapped in application.yml)
```

```yaml
# Spring AI MCP (when mcp.enabled=true)
spring.ai.mcp.server.enabled=true
spring.ai.mcp.server.annotation-scanner.enabled=true
spring.ai.mcp.server.streamable-http.mcp-endpoint=/mcp
```

### opis-cds-agent

```properties
com.intapp.opis.cds-agent.mcp.enabled=true
```

Same `spring.ai.mcp.server.*` settings as above (or equivalent in cds-agent’s application.yml).

### opis-ui-service

```properties
com.intapp.opis.ui-service.mcp.enabled=true
```

Same `spring.ai.mcp.server.*` settings as above.

## Run the service

Example for local run:

```bash
# From repo root
./gradlew :opis-ips:bootRun --args='--spring.profiles.active=local,dev'
# Or for cds-agent / ui-service, switch the project and profile as needed.
```

Ensure the service starts without errors and that the log does not show MCP-related failures. When MCP is disabled, the `/mcp` endpoint should not be registered (or should return 404/403 depending on security config).

## Verify MCP endpoint and tools

1. **Connect**: Point your MCP client at `http://localhost:<port>/mcp` (use the app’s server port, e.g. 8080). If the app uses TLS in dev, use `https://...`.
2. **List tools**: Use the client to list tools. You should see names like `ips_tenant_details`, `cds_unlock_tenant`, or `ui_cache_invalidate_all` depending on which service you started.
3. **Call a tool**: Invoke one tool with valid arguments (e.g. `ips_tenant_details` with `tenantName` set to an existing tenant). The result should match the behavior of the underlying service endpoint.
4. **Disable MCP**: Set `mcp.enabled=false` (or omit it), restart, and confirm the MCP endpoint is no longer available or does not list tools.

## Security

Use the same credentials or tokens as for the existing `/service` endpoints. The MCP endpoint must be protected by the same security matcher and authorities; no separate MCP-only auth is required.

## Troubleshooting

- **No tools listed**: Ensure `mcp.enabled=true` and `spring.ai.mcp.server.enabled=true` (and annotation-scanner enabled). Check that the MCP tools bean is conditional on the same flag and that the application profile loads the correct config.
- **403 on /mcp**: Add the MCP path to the same security rule that allows access to `/service` (or use the same request matcher).
- **Tool call fails**: Verify parameters (names and types) match the tool definition and the underlying controller. Check service logs for validation or business logic errors.
