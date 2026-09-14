# Route derivation (web)

Shared mapping from a source file to the route that renders it, for skills that drive the web app with the Playwright MCP. The calling skill decides which files come in and how it labels a miss; this file only says how to map.

## Route

- File-based routers: a file under `pages/`, `app/`, `routes/`, or `src/routes/` maps to its path segment; `index` and `page` files map to the directory; bracketed segments are parameters.
- Config routers: search for `path:` entries or `<Route path=` elements that import the file.
- Anything else: grep for importers of the file and walk up until a route file is hit. Three hops without a route file is a route miss; record the chain walked.

## Parameters

A parameter takes the value the repo states: fixtures, seeds, README, stories. A parameter with no stated value is a parameter miss, since the router may treat it as required and answer with an error page.
