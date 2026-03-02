# Implementation Plan: AI Agent Access to Service Operations

**Branch**: `001-mcp-service-endpoints` | **Date**: 2025-02-18 | **Spec**: [spec.md](spec.md)  
**Input**: Feature specification from `/specs/001-mcp-service-endpoints/spec.md`

## Summary

Expose existing `/service` (or `service`) endpoints on opis-ips, opis-cds-agent, and opis-ui-service through the Model Context Protocol (MCP) so AI clients can discover and invoke operations. Each service will add an opt-in MCP server (Spring AI MCP Server WebMVC), conditionally load MCP tool beans that delegate to existing service logic, and provide tool names, descriptions, and optional prompts/completions aligned with opis-atom-cloud-self-service.

## Technical Context

**Language/Version**: Java 17  
**Primary Dependencies**: Spring Boot 3.5.10, Spring AI MCP Server WebMVC (spring-ai-starter-mcp-server-webmvc, BOM 1.1.x), existing Spring Web / security stacks per service  
**Storage**: N/A for MCP layer; each service keeps existing persistence (PostgreSQL for opis-ips, opis-cds-agent; as needed for opis-ui-service)  
**Testing**: JUnit 5, MockMvc / Mockito; existing `@Tag("offline")` unit tests; integration tests for MCP tools invoking real service methods where applicable  
**Target Platform**: Linux (Kubernetes); same as current OPIS services  
**Project Type**: Multi-module monorepo (opis-ips, opis-cds-agent, opis-ui-service as separate Gradle projects)  
**Performance Goals**: MCP endpoint same security and load profile as existing service endpoints; no new heavy endpoints  
**Constraints**: MCP opt-in via feature flag per service; no new privileges; protocol layer must delegate to existing controllers/services  
**Scale/Scope**: One MCP tools class (or small set) per service; tens of tools total across three services

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The repository constitution (`.specify/memory/constitution.md`) is a template and not customized for this project. No formal gates are defined. For this feature we apply:

- **No new security bypass**: MCP must use the same authorization as existing `/service` endpoints (Keycloak/Spring Security as configured per service).
- **Testability**: New MCP tools must be unit-testable (offline) by mocking the underlying services; at least one integration path (list tools + call one tool) per service is recommended.
- **Simplicity**: No new persistence or new APIs; adapters only.

**Post–Phase 1**: Design uses thin MCP tool classes that delegate to existing services; no new storage or contracts beyond MCP protocol. Constitution check remains satisfied.

## Project Structure

### Documentation (this feature)

```text
specs/001-mcp-service-endpoints/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (MCP endpoint + tool naming)
├── checklists/
│   └── requirements.md
└── tasks.md             # Phase 2 output (/speckit.tasks – not created by /speckit.plan)
```

### Source Code (repository root)

```text
opis-ips/
├── src/main/java/.../controller/ServiceController.java    # existing
├── src/main/java/.../mcp/                                  # NEW: MCP tools for /service
│   └── ServiceMcpTools.java
├── src/main/java/.../config/                               # NEW: MCP enable condition + config
│   └── McpEnabledCondition.java (or equivalent)
└── src/main/resources/application.yml                     # NEW: mcp.enabled, spring.ai.mcp.server.*

opis-cds-agent/
├── src/main/java/.../controller/ServiceController.java     # existing
├── src/main/java/.../mcp/
│   └── ServiceMcpTools.java
├── src/main/java/.../config/
│   └── McpEnabledCondition.java
└── src/main/resources/application.yml

opis-ui-service/
├── src/main/java/.../controller/ServiceController.java     # existing
├── src/main/java/.../mcp/
│   └── ServiceMcpTools.java
├── src/main/java/.../config/
│   └── McpEnabledCondition.java
└── src/main/resources/application.yml
```

**Structure Decision**: Three existing Spring Boot applications; each gets a new `mcp` package and optional `config` for MCP enable condition. No new Gradle modules. Reference: `opis-atom-cloud-self-service` (mcp package, McpEnabledCondition, application.yml mcp + spring.ai.mcp sections).

**Configuration (MCP opt-in)**: Per-service property, default `false`. Use the same names in each service’s `application.yml` and `McpEnabledCondition`:

- opis-ips: `com.intapp.opis.ips.mcp.enabled`
- opis-cds-agent: `com.intapp.opis.cds-agent.mcp.enabled`
- opis-ui-service: `com.intapp.opis.ui-service.mcp.enabled`

Spring AI MCP server: `spring.ai.mcp.server.enabled`, `spring.ai.mcp.server.annotation-scanner.enabled`, `spring.ai.mcp.server.streamable-http.mcp-endpoint` (default `/mcp`).

## Complexity Tracking

No constitution violations. Complexity table left empty.
