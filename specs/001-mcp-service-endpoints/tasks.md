# Tasks: AI Agent Access to Service Operations

**Input**: Design documents from `/specs/001-mcp-service-endpoints/`  
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Not explicitly requested in the feature specification; no test tasks included. Manual validation via quickstart.md and AI client is the independent test per user story. The plan’s “unit-testable” and “at least one integration path per service” are satisfied by this manual validation; optional unit or integration test tasks may be added later.

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently (opis-ips → US1, opis-cds-agent → US2, opis-ui-service → US3).

## Format: `[ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files/projects, no dependencies)
- **[Story]**: User story (US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **opis-ips**: `opis-ips/src/main/java/com/intapp/opis/ips/`, `opis-ips/src/main/resources/`
- **opis-cds-agent**: `opis-cds-agent/src/main/java/com/intapp/opis/cdsagent/`, `opis-cds-agent/src/main/resources/`
- **opis-ui-service**: `opis-ui-service/src/main/java/com/intapp/opis/uiservice/`, `opis-ui-service/src/main/resources/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Add MCP dependency and config skeleton to each service so the MCP server can be enabled later.

- [X] T001 [P] Add Spring AI BOM and spring-ai-starter-mcp-server-webmvc to opis-ips in `opis-ips/build.gradle` and add `mcp.enabled` and `spring.ai.mcp.server` placeholders in `opis-ips/src/main/resources/application.yml`
- [X] T002 [P] Add Spring AI BOM and spring-ai-starter-mcp-server-webmvc to opis-cds-agent in `opis-cds-agent/build.gradle` and add `mcp.enabled` and `spring.ai.mcp.server` placeholders in `opis-cds-agent/src/main/resources/application.yml`
- [X] T003 [P] Add Spring AI BOM and spring-ai-starter-mcp-server-webmvc to opis-ui-service in `opis-ui-service/build.gradle` and add `mcp.enabled` and `spring.ai.mcp.server` placeholders in `opis-ui-service/src/main/resources/application.yml`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: MCP opt-in and conditional bean loading so that when MCP is disabled no endpoint or tools are registered. MUST be complete before any user story implementation.

- [X] T004 [P] Add McpEnabledCondition in `opis-ips/src/main/java/com/intapp/opis/ips/config/McpEnabledCondition.java` and wire `com.intapp.opis.ips.mcp.enabled` plus `spring.ai.mcp.server.enabled` / `annotation-scanner.enabled` in `opis-ips/src/main/resources/application.yml`
- [X] T005 [P] Add McpEnabledCondition in `opis-cds-agent/src/main/java/com/intapp/opis/cdsagent/config/McpEnabledCondition.java` and wire `com.intapp.opis.cds-agent.mcp.enabled` plus `spring.ai.mcp.server.enabled` / `annotation-scanner.enabled` in `opis-cds-agent/src/main/resources/application.yml`
- [X] T006 [P] Add McpEnabledCondition in `opis-ui-service/src/main/java/com/intapp/opis/uiservice/config/McpEnabledCondition.java` and wire `com.intapp.opis.ui-service.mcp.enabled` plus `spring.ai.mcp.server.enabled` / `annotation-scanner.enabled` in `opis-ui-service/src/main/resources/application.yml`

**Checkpoint**: Foundation ready; user story implementation can begin (US1, US2, US3 can proceed in parallel or in order).

---

## Phase 3: User Story 1 – Operators use AI assistants for opis-ips (Priority: P1) – MVP

**Goal**: Expose opis-ips service operations (e.g. tenant details, sync SSO, unlock) via MCP so an AI client can list and invoke them.

**Independent Test**: Enable MCP for opis-ips, connect an AI client to `/mcp`, list tools (e.g. ips_tenant_details), invoke ips_tenant_details with a valid tenantName, and verify the result matches the existing service endpoint.

### Implementation for User Story 1

- [X] T007 [US1] Create ServiceMcpTools in `opis-ips/src/main/java/com/intapp/opis/ips/mcp/ServiceMcpTools.java` with @McpTool ips_tenant_details delegating to tenant details (TenantInfoService.getExtendedInfo or equivalent)
- [X] T008 [US1] Add @McpPrompt for ips_tenant_details in `opis-ips/src/main/java/com/intapp/opis/ips/mcp/ServiceMcpTools.java`
- [X] T009 [US1] Secure /mcp in opis-ips by adding /mcp to the same requestMatcher/authority as /service in `opis-ips/src/main/java/com/intapp/opis/ips/config/keycloak/KeycloakSecurityConfiguration.java`
- [X] T010 [US1] Add additional ips_ tools in `opis-ips/src/main/java/com/intapp/opis/ips/mcp/ServiceMcpTools.java` (e.g. ips_tenant_sync_sso, ips_force_unlock) with matching @McpPrompt per contracts/README.md and data-model.md
- [ ] T010a (Optional) [US1] Add @McpComplete for tenantName for ips_tenant_details in `opis-ips/src/main/java/com/intapp/opis/ips/mcp/ServiceMcpTools.java` where a tenant list is available (FR-007); otherwise defer.

**Checkpoint**: User Story 1 complete; an AI client can list and invoke opis-ips tools when MCP is enabled.

---

## Phase 4: User Story 2 – Operators use AI assistants for opis-cds-agent (Priority: P2)

**Goal**: Expose CDS Agent service operations (unlock tenant, tenant auth cleanup) via MCP so an AI client can list and invoke them.

**Independent Test**: Enable MCP for opis-cds-agent, connect an AI client to `/mcp`, list tools (cds_unlock_tenant, cds_tenant_auth_cleanup), invoke one with valid parameters, and verify outcome matches the existing service endpoint.

### Implementation for User Story 2

- [X] T011 [US2] Create ServiceMcpTools in `opis-cds-agent/src/main/java/com/intapp/opis/cdsagent/mcp/ServiceMcpTools.java` with @McpTool cds_unlock_tenant and cds_tenant_auth_cleanup delegating to TenantFixService and TenantAuthService
- [X] T012 [US2] Add @McpPrompt for cds_unlock_tenant and cds_tenant_auth_cleanup in `opis-cds-agent/src/main/java/com/intapp/opis/cdsagent/mcp/ServiceMcpTools.java`
- [X] T013 [US2] Secure /mcp in opis-cds-agent by adding /mcp to the same requestMatcher/authority as /service in `opis-cds-agent/src/main/java/com/intapp/opis/cdsagent/config/keycloak/KeycloakSecurityConfiguration.java`

**Checkpoint**: User Stories 1 and 2 are independently testable.

---

## Phase 5: User Story 3 – Operators use AI assistants for opis-ui-service (Priority: P3)

**Goal**: Expose UI Service operations (cache invalidation, service info, etc.) via MCP so an AI client can list and invoke them.

**Independent Test**: Enable MCP for opis-ui-service, connect an AI client to `/mcp`, list tools (e.g. ui_cache_invalidate_all, ui_service_info), invoke one, and verify outcome matches the existing service endpoint.

### Implementation for User Story 3

- [X] T014 [US3] Create ServiceMcpTools in `opis-ui-service/src/main/java/com/intapp/opis/uiservice/mcp/ServiceMcpTools.java` with @McpTool ui_cache_invalidate_all and ui_service_info delegating to CacheManager and existing service info behavior
- [X] T015 [US3] Add @McpPrompt for ui_cache_invalidate_all and ui_service_info in `opis-ui-service/src/main/java/com/intapp/opis/uiservice/mcp/ServiceMcpTools.java`
- [X] T016 [US3] Secure /mcp in opis-ui-service by adding /mcp to the same securityMatcher/authority as /service in `opis-ui-service/src/main/java/com/intapp/opis/uiservice/config/security/SecurityConfiguration.java`

**Checkpoint**: All three user stories are independently functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Validation and documentation.

- [ ] T017 Run quickstart.md validation: enable MCP for one service, list tools, call one tool per service, then disable MCP and confirm endpoint/tools unavailable; confirm one error path (e.g. invalid tenant) returns same behavior as the REST endpoint (SC-005)
- [X] T018 [P] Update project docs (e.g. CLAUDE.md or service READMEs) with MCP enable instructions and property names per `specs/001-mcp-service-endpoints/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies; can start immediately.
- **Phase 2 (Foundational)**: Depends on Phase 1; blocks all user stories.
- **Phase 3 (US1)**: Depends on Phase 2 only.
- **Phase 4 (US2)**: Depends on Phase 2 only (independent of US1).
- **Phase 5 (US3)**: Depends on Phase 2 only (independent of US1/US2).
- **Phase 6 (Polish)**: Depends on at least one user story being complete (recommend all three).

### User Story Dependencies

- **US1 (opis-ips)**: After Phase 2; no dependency on US2 or US3.
- **US2 (opis-cds-agent)**: After Phase 2; no dependency on US1 or US3.
- **US3 (opis-ui-service)**: After Phase 2; no dependency on US1 or US2.

### Within Each User Story

- Create ServiceMcpTools class with tools before adding prompts.
- Wire security for /mcp in the same phase as the tools for that service.

### Parallel Opportunities

- T001, T002, T003 can run in parallel (different projects).
- T004, T005, T006 can run in parallel (different projects).
- After Phase 2, Phase 3 (US1), Phase 4 (US2), and Phase 5 (US3) can be implemented in parallel by different developers.
- T018 can run in parallel with T017.

---

## Parallel Example: After Phase 2

```text
Developer A: Phase 3 (US1) – opis-ips ServiceMcpTools + security
Developer B: Phase 4 (US2) – opis-cds-agent ServiceMcpTools + security
Developer C: Phase 5 (US3) – opis-ui-service ServiceMcpTools + security
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001–T003).
2. Complete Phase 2: Foundational (T004–T006).
3. Complete Phase 3: User Story 1 (T007–T010).
4. **STOP and VALIDATE**: Enable MCP for opis-ips, list tools, invoke ips_tenant_details.
5. Deploy/demo opis-ips with MCP if ready.

### Incremental Delivery

1. Setup + Foundational → MCP plumbing ready in all three services.
2. Add US1 (opis-ips) → Validate with AI client → MVP.
3. Add US2 (opis-cds-agent) → Validate independently.
4. Add US3 (opis-ui-service) → Validate independently.
5. Polish (quickstart validation, docs).

### Parallel Team Strategy

1. Team completes Phase 1 and Phase 2 together.
2. After Phase 2: assign US1 to one developer, US2 to another, US3 to another; stories do not block each other.
3. Merge and run Phase 6 when desired stories are done.

---

## Notes

- [P] tasks use different files or projects and have no ordering requirement within the phase.
- [USn] labels map tasks to user stories for traceability.
- Each user story is independently testable via quickstart.md (enable MCP, list tools, call one tool).
- Reference implementation: `opis-atom-cloud-self-service` (mcp package, McpEnabledCondition, application.yml mcp + spring.ai.mcp).
- FR-007 (parameter completions): Addressed by optional task T010a or deferred; no other tasks required for initial delivery.
- Commit after each task or logical group; validate at each checkpoint.
