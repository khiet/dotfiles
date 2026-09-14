# Route derivation (web)

Shared mapping from a source file to the route that renders it, for skills that drive the web app with the Playwright MCP. The calling skill decides which files come in and which `Not covered` label a miss gets; this file only says how to map.

## Route

Check in order and stop at the first hit:

1. The router's own listing, when the framework has one (`rails routes`, a build's route manifest, a CLI route dump). It is the source of truth and beats grepping.
2. The file that declares routes: a route config or a file-based router's directory, where the changed file or its owner (controller, page, component) appears. Index or default files map to their directory; dynamic segments are parameters.
3. Otherwise walk renderers and importers of the file up until a routed file is hit: imports, `render` calls, component and partial references, and controller-to-view naming. Three hops without a routed file is a route miss; record the chain walked.

## Parameters

A parameter takes a value the repo states: seeds, fixtures, README, stories. A value counts once the running app answers the route with it; a parameter with no stated value, or one the app rejects, is a parameter miss.
