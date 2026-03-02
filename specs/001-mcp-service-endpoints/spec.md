# Feature Specification: AI Agent Access to Service Operations

**Feature Branch**: `001-mcp-service-endpoints`  
**Created**: 2025-02-18  
**Status**: Draft  
**Input**: User description: "Implement MCP tools, prompts and etc for opis-ips, opis-cds-agent, opis-ui-service for @RequestMapping("/service") or @RequestMapping("service") endpoints according to the best practices like in opis-atom-cloud-self-service"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Operators use AI assistants to perform tenant and service operations (Priority: P1)

Operators and support staff use an AI-powered assistant (e.g. in an IDE or chat interface) that can perform service operations on their behalf—such as syncing tenant SSO, unlocking a tenant, or invalidating caches—without leaving the assistant. The assistant discovers available operations and parameters and executes them when the operator confirms.

**Why this priority**: Enables the primary value of the feature: reducing context-switching and manual API calls for common operational tasks.

**Independent Test**: Can be fully tested by connecting an AI client to the Integration Processing Service (opis-ips), requesting the list of available operations, and successfully invoking one operation (e.g. get tenant details) and verifying the outcome.

**Acceptance Scenarios**:

1. **Given** the AI agent protocol is enabled for opis-ips, **When** an AI client requests available operations, **Then** the client receives a list of operations that correspond to the service’s tenant and provisioning capabilities (e.g. sync SSO, transfer status, get details, unlock).
2. **Given** the client has selected an operation with required parameters (e.g. tenant name), **When** the client invokes the operation, **Then** the system performs the same behavior as the existing service endpoint and returns a result the client can present to the operator.
3. **Given** the AI agent protocol is disabled for a service, **When** an AI client attempts to connect or list operations, **Then** the protocol endpoint is not available or does not expose operations.

---

### User Story 2 - Operators use AI assistants to run CDS Agent service operations (Priority: P2)

Operators use an AI assistant to perform CDS Agent service operations—such as unlocking a tenant by ID or triggering tenant auth cleanup—so that these actions can be requested in natural language or through the same assistant used for other OPIS services.

**Why this priority**: Aligns CDS Agent with the same interaction model as opis-ips and opis-ui-service.

**Independent Test**: Can be tested by enabling the protocol for opis-cds-agent and having an AI client list and invoke at least one service operation (e.g. unlock-tenant) and confirm the result.

**Acceptance Scenarios**:

1. **Given** the AI agent protocol is enabled for opis-cds-agent, **When** an AI client requests available operations, **Then** the client receives operations that map to the CDS Agent service capabilities (e.g. unlock tenant, tenant auth cleanup).
2. **Given** the client invokes an operation with valid parameters, **When** the operation completes, **Then** the outcome matches the behavior of the existing service endpoint (e.g. tenant unlocked or cleanup triggered).

---

### User Story 3 - Operators use AI assistants to run UI Service operations (Priority: P3)

Operators use an AI assistant to perform UI Service operations—such as cache invalidation, process statistics, tenant list, or audit log ingestion—so that these can be requested through the same assistant used for IPS and CDS Agent.

**Why this priority**: Completes parity across the three services for AI-driven operations.

**Independent Test**: Can be tested by enabling the protocol for opis-ui-service and having an AI client list operations and invoke one (e.g. cache invalidation) and verify the effect.

**Acceptance Scenarios**:

1. **Given** the AI agent protocol is enabled for opis-ui-service, **When** an AI client requests available operations, **Then** the client receives operations that map to the UI Service service capabilities (e.g. invalidate caches, process statistics, tenant list, audit log ingestion).
2. **Given** the client invokes an operation that changes system state (e.g. invalidate caches), **When** the operation completes, **Then** the system state reflects the change (e.g. caches are invalidated) consistent with the existing service endpoint.

---

### Edge Cases

- What happens when the protocol is disabled? The protocol endpoint is not exposed or does not register tools; no operations are available to AI clients.
- How does the system handle invalid or missing parameters? The same validation and error behavior as the underlying service endpoint; errors are returned to the client in a way that can be shown to the operator.
- What happens when a service operation fails (e.g. tenant not found, permission denied)? The failure is reported through the protocol so the client can present a clear message to the operator; no silent failures.
- How are authorization and access controlled? Only clients that can reach the service and satisfy the same security rules as the existing service endpoints can invoke operations; enabling the protocol does not bypass existing security.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Each of the three services (opis-ips, opis-cds-agent, opis-ui-service) MUST expose their existing service operations (those under the `/service` or `service` request mapping) through a single, consistent protocol that AI agents can use to discover and invoke operations.
- **FR-002**: The protocol MUST be opt-in per service (e.g. via configuration or feature flag); when disabled, no protocol endpoint or tool registration MUST be active for that service.
- **FR-003**: For each exposed operation, the system MUST provide a machine-readable name and description so that AI clients can present choices to users and construct valid requests.
- **FR-004**: For each exposed operation, the system MUST accept parameters that match the semantics of the underlying service endpoint (e.g. tenant name, tenant ID, request body where applicable) and MUST return results or errors consistent with that endpoint.
- **FR-005**: Protocol behavior MUST follow the same security and authorization model as the existing service endpoints; protocol access MUST not grant additional privileges.
- **FR-006**: The system MUST support optional prompt templates (or equivalent) for each operation so that AI clients can offer natural-language shortcuts (e.g. “Get tenant details for X”) that map to the same operations.
- **FR-007**: Where the reference implementation supports completion or suggestions for parameter values (e.g. tenant names), the three services SHOULD support equivalent behavior where it adds operator value; otherwise parameter input is free-form and validated by the service.

### Key Entities

- **Service operation**: A single capability exposed by a service (e.g. “sync tenant SSO”, “unlock tenant”, “invalidate caches”) that corresponds to one existing service endpoint; has a stable name, description, and parameter schema.
- **Tool (or equivalent)**: The protocol artifact that represents an invocable operation; discoverable by clients and executable with the right parameters.
- **Prompt template**: A named, parameterized text template that describes an operation in user-friendly terms and maps to a single tool/operation.

## Assumptions

- The reference service (opis-atom-cloud-self-service) defines the “best practices” for protocol endpoint placement, naming, tool/prompt structure, optional completions, and feature-flag behavior; the three services will align with that pattern where applicable.
- Each service may have different dependencies (e.g. Boomi) for enabling the protocol; the opt-in mechanism may be service-specific (e.g. different property names) while the external protocol contract remains consistent.
- Existing service endpoints remain the source of truth for behavior, validation, and security; the protocol layer is a thin adapter that discovers and invokes those endpoints.
- AI clients are assumed to be used in operator or support contexts with appropriate access to the services; no additional end-user-facing UX requirements are in scope.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: An operator can use an AI client to list and invoke at least one tenant-related operation on opis-ips (e.g. get tenant details) and receive a correct result within the same session.
- **SC-002**: An operator can use an AI client to list and invoke at least one operation on opis-cds-agent (e.g. unlock tenant or tenant auth cleanup) and observe the expected outcome.
- **SC-003**: An operator can use an AI client to list and invoke at least one operation on opis-ui-service (e.g. invalidate caches or get info) and observe the expected outcome.
- **SC-004**: When the protocol is disabled for a service, an AI client cannot discover or invoke operations for that service (no regression in security or exposure).
- **SC-005**: Behavior and error handling for operations invoked via the protocol match the behavior of the same operation invoked directly against the service endpoint (no functional divergence).
