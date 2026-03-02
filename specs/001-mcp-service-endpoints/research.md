# Research: MCP Service Endpoints (Phase 0)

**Feature**: 001-mcp-service-endpoints  
**Date**: 2025-02-18

## 1. MCP protocol and Spring AI MCP Server

**Task**: Research MCP server integration for servlet-based Spring Boot apps and align with reference (opis-atom-cloud-self-service).

**Decision**: Use **Spring AI MCP Server WebMVC** (`org.springframework.ai:spring-ai-starter-mcp-server-webmvc`) with the same BOM version as the reference (Spring AI 1.1.x). Expose the MCP endpoint at `/mcp` via `spring.ai.mcp.server.streamable-http.mcp-endpoint`. Use protocol type SYNC and STREAMABLE HTTP so AI clients can list tools and call them in a single session.

**Rationale**: opis-atom-cloud-self-service already runs this stack successfully; reusing it keeps behavior and client compatibility consistent across OPIS services.

**Alternatives considered**: Custom REST wrapper for “tools” was rejected because it would not be MCP-compliant and would require custom client support. Using a different MCP implementation (e.g. non-Spring) was rejected to stay within the existing Spring Boot and security model.

---

## 2. Opt-in and conditional loading

**Task**: How to make MCP opt-in per service and avoid loading MCP beans when disabled.

**Decision**: Per-service configuration property (e.g. `com.intapp.opis.ips.mcp.enabled`, `com.intapp.opis.cds-agent.mcp.enabled`, `com.intapp.opis.ui-service.mcp.enabled`) defaulting to `false`. Use a **@Conditional** bean condition (e.g. `McpEnabledCondition`) so that when the property is false:
- MCP tool/prompt/complete beans are not registered.
- Spring AI MCP server can be disabled via `spring.ai.mcp.server.enabled=false` and `spring.ai.mcp.server.annotation-scanner.enabled=false` so that no MCP endpoint is exposed and no annotation scanning runs.

**Rationale**: Matches opis-atom-cloud-self-service (mcp.enabled + annotation-scanner.enabled). Prevents WARN logs and unnecessary classpath scanning when MCP is off.

**Alternatives considered**: Single global MCP flag for the whole repo was rejected because each service is deployed independently and may enable MCP at different times. Loading beans but not exposing the endpoint was rejected to avoid unnecessary work and confusion.

---

## 3. Condition dependency (Boomi vs no-Boomi)

**Task**: Reference uses McpEnabledCondition that requires both mcp.enabled and boomi.enabled. Should opis-ips, opis-cds-agent, opis-ui-service require Boomi?

**Decision**: **No.** For opis-ips, opis-cds-agent, and opis-ui-service, the MCP enable condition should depend only on the service’s `mcp.enabled` (or equivalent) property. Boomi is required only in opis-atom-cloud-self-service for runtime-name completion and JMX; the three target services do not have that dependency for their `/service` operations.

**Rationale**: Keeps MCP adoption simple for ips/cds-agent/ui-service and avoids pulling in Boomi where it is not used.

**Alternatives considered**: Requiring a “feature.enabled” flag per capability was rejected for initial scope; one mcp.enabled per service is enough.

---

## 4. Tool and prompt structure

**Task**: How to map existing service endpoints to MCP tools and prompts.

**Decision**: One **@McpTool** per exposed service operation (e.g. `ips_tenant_details`, `ips_tenant_sync_sso`, `cds_unlock_tenant`, `ui_cache_invalidate`). Each tool method delegates to the existing service or controller logic (or in-process call to the same behavior). Use **@McpToolParam** for path/query/body parameters with descriptions. Provide **@McpPrompt** per tool with the same name so clients can show natural-language shortcuts (e.g. “Get tenant details for {tenantName}”). Use a consistent naming convention: service prefix + operation (e.g. `ips_*`, `cds_*`, `ui_*`) to avoid clashes when multiple services are used from one client.

**Rationale**: Matches the reference (JobExecutionMcpTools, JmxExecutionMcpTools): tools and prompts share names, parameters are described, and implementation delegates to existing services.

**Alternatives considered**: One “generic” tool that takes operation name + JSON args was rejected because it would be less discoverable and harder to describe in the protocol.

---

## 5. Completions (parameter suggestions)

**Task**: Whether and where to add @McpComplete for parameter values (e.g. tenant names).

**Decision**: **Optional, best-effort.** Where a service already has an API or in-memory list of valid values (e.g. tenant names, tenant IDs), add **@McpComplete** for that prompt/tool and parameter so the client can offer suggestions. If adding completions would require new external calls or significant complexity, omit them for the first iteration; FR-007 is SHOULD, not MUST.

**Rationale**: Improves operator experience where easy to implement; avoids scope creep where data is not readily available.

**Alternatives considered**: Mandatory completions for all tools was rejected because some operations take free-form input (e.g. subscription string, date). Completing only tenant name/ID where available is a reasonable middle ground.

---

## 6. Security and CORS

**Task**: How MCP endpoint is protected and whether CORS is needed.

**Decision**: MCP endpoint MUST be subject to the **same security matcher and authority rules** as the existing `/service` (or `service`) endpoints in each application. In practice: include the MCP path (e.g. `/mcp`) in the same requestMatcher used for service endpoints (e.g. `/service/**`) or add an explicit rule so that only authenticated users with the same authority as for `/service` can access `/mcp`. Enable CORS for the MCP endpoint only when MCP is enabled, if AI clients run in browsers and need cross-origin access; follow the same pattern as opis-atom-cloud-self-service if it configures CORS for `/mcp`.

**Rationale**: Spec FR-005 requires no additional privileges; reusing existing service security satisfies that.

**Alternatives considered**: Separate MCP-only roles were rejected to avoid expanding the permission model.
