---
name: api-boundary-and-serialization
description: Design clean, resilient REST API boundaries between Rails backends and React Native frontends with disciplined serialization, error handling, and offline-aware patterns.
compatibility: opencode
metadata:
  audience: full-stack-rails-and-react-native-engineers
  focus: api-contract-and-data-flow
  additive: "true"
---

## Scope

The seam between Rails API and React Native client: endpoint design, serialization, request/response contracts, error handling, loading states, and network resilience. This is where most cross-team and cross-layer bugs live.

## API Design Principles

- **Endpoints serve client screens, not database tables.** A mobile screen that needs data from 3 models should ideally hit 1 endpoint, not 3. Avoid forcing the client to orchestrate joins.
- **Consistent response envelope.** Every endpoint returns the same top-level shape. Predictability eliminates an entire class of client-side bugs.
- **Lean payloads.** Mobile clients pay for every byte over cellular. Serialize only what the screen needs. If an endpoint serves both web and mobile, consider sparse fieldsets or a `fields` param before duplicating endpoints.
- **Stable contracts.** Don't rename fields, change nesting, or remove keys without versioning. Additive changes (new optional fields) are safe; destructive changes are not.

## Response Envelope Convention

Use a consistent shape across all endpoints:

```json
// Success
{ "data": { ... }, "meta": { "page": 1, "total_pages": 5 } }

// Error
{ "error": { "code": "validation_failed", "message": "Human-readable summary", "details": { "email": ["is already taken"] } } }
```

Rules:
- `data` is always the primary payload (object or array).
- `meta` is optional, used for pagination, timestamps, etc.
- `error` replaces `data` on failure. Never return both.
- `error.code` is a machine-readable string the client can switch on. `error.message` is human-readable.
- `error.details` carries per-field validation errors keyed by field name (matches Rails model errors shape).

## Rails Serialization

### Serializer Discipline
- **One serializer per use case**, not one per model. `OrderListSerializer` and `OrderDetailSerializer` serve different screens with different data needs. Resist the urge to make one `OrderSerializer` with conditional includes.
- Never expose `id` as database integer to the client if you use UUIDs, slugs, or external IDs. Pick one identifier scheme and be consistent.
- Never expose internal associations the client doesn't need. Every included association is a potential N+1 and a payload bloat source.
- Keep serializer files free of business logic. They translate data shape; they don't compute it.

### Pagination
- Always paginate collections. No exceptions, even if "there are only a few." Data grows.
- Return pagination info in `meta`: `{ page, per_page, total_pages, total_count }`.
- Use cursor-based pagination for infinite scroll / real-time feeds. Offset-based for traditional page navigation.

### Timestamps and Formatting
- All timestamps in ISO 8601 / UTC. The client formats for display and timezone.
- Money as integer cents + currency code, never floating point.
- Enums as lowercase snake_case strings, not integers.

## Client-Side Data Flow

### API Client Layer
- Centralize all API calls behind a single client module (e.g., `api/client.ts`). Components never call `fetch` directly.
- The client handles: base URL, auth headers, token refresh, request/response logging, timeout, and retry.
- Parse and validate responses at the boundary. If the server sends unexpected shape, fail loudly at the API layer, not deep in a component.

### Response Handling Pattern
Every API call site should handle exactly 3 states — no shortcuts:

```
1. Loading  → show skeleton/spinner, disable actions
2. Success  → render data, clear errors
3. Error    → show user-facing message, preserve prior data when possible
```

- **Never silently swallow errors.** An empty screen with no error message is worse than an error banner.
- Distinguish network errors (offline, timeout) from server errors (4xx, 5xx) from validation errors (422). Each needs different UI treatment.

### Optimistic Updates
- Apply state change immediately in Zustand store, then fire the API call.
- On success: optionally reconcile with server response (server may add timestamps, computed fields).
- On failure: revert the optimistic change AND show an error. The user must know their action didn't stick.
- Best suited for: toggles, likes, simple field edits, cart quantity changes.
- Avoid for: payments, destructive deletes, multi-step flows.

### Offline and Network Resilience
- Assume the network is unreliable. The app should never crash or show a blank screen because of a failed request.
- Cache critical read data locally (Zustand persist, MMKV, AsyncStorage) so the app is usable on launch before the first fetch completes.
- Queue failed write operations for retry when appropriate (e.g., draft saves, analytics events). Don't queue operations where stale data is dangerous (e.g., payments).
- Show clear offline indicators. Don't let the user think they're online when they're not.

## Error Mapping (Server -> Client)

| HTTP Status | Client Interpretation | UI Pattern |
|-------------|----------------------|------------|
| 200-204 | Success | Render data / confirm action |
| 401 | Auth expired | Redirect to login, clear tokens |
| 403 | Not permitted | Show "no access" message |
| 404 | Resource gone | Show empty state or navigate back |
| 422 | Validation failed | Show per-field errors from `error.details` |
| 429 | Rate limited | Retry with backoff, show "try again" |
| 500+ | Server error | Show generic error, log for debugging |

## Authentication Flow

- Store tokens in secure storage (`expo-secure-store`), never AsyncStorage.
- Access token in memory (Zustand); refresh token in secure storage only.
- Implement transparent token refresh in the API client interceptor. Components should never know about token expiry.
- On 401: attempt refresh once. If refresh fails, clear auth state and redirect to login.
- Never include tokens in URL params or logs.

## Anti-Patterns

- Letting components parse raw API responses — all shaping happens in the API layer or serializer.
- Returning 200 with `{ success: false }` — use proper HTTP status codes.
- Nested includes 3+ levels deep (`order.line_items.product.category.parent`) — flatten or split into separate endpoints.
- Paginating with offset on datasets that change frequently (items shift between pages). Use cursors.
- Caching stale auth state — token refresh must be atomic and synchronized (prevent parallel refresh race).
- Different error shapes from different endpoints — enforce the envelope in a Rails base controller concern.

## Quality Bar

Before finishing, confirm:
- Response shape follows the consistent envelope convention.
- Serializers are use-case-specific and include only needed fields/associations.
- Client handles loading, success, and error states explicitly — no silent failures.
- Auth tokens are stored securely and refreshed transparently.
- Collections are paginated with pagination metadata.
- The client can render a useful screen even when offline or on slow network.
