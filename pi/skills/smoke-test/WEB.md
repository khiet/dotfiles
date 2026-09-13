# Web driver (Playwright MCP)

Mechanics for the `playwright` driver. The workflow in [`SKILL.md`](SKILL.md) decides when each section runs and sets the caps.

## Launch

1. Probe the documented URL first: `curl -sI <url>`. Any HTTP response means the app is found running; record it and skip to readiness.
2. Otherwise run the recipe's script in the background with stdout and stderr to a log file in the scratch dir, and record the process group id so the stop step can kill the whole tree.
3. Read the local URL from the log (dev servers print it); fall back to the documented URL when the log has none within the readiness cap.
4. Readiness: poll the base URL every 2 s until it answers below 500, within the readiness cap.

## Route derivation

- File-based routers: a file under `pages/`, `app/`, `routes/`, or `src/routes/` maps to its path segment; `index` and `page` files map to the directory; bracketed segments are parameters.
- Config routers: search for `path:` entries or `<Route path=` elements that import the changed component.
- Anything else: grep for importers of the changed file and walk up until a route file is hit. A file with no route within three hops is `Not covered: needs data` with the chain noted.
- A documented login: `browser_navigate` to the login route, `browser_fill_form` with the documented credentials, and submit. This spends the interaction budget for every row that needs it.

## Drive

Per row:

1. `browser_navigate` to the route.
2. `browser_wait_for` on the observable text, or on network idle when the observable is a control or the change is style-only.
3. `browser_snapshot` to confirm the observable is present in the accessibility tree.
4. `browser_console_messages` at error level; diff against the baseline.
5. `browser_take_screenshot` with `filename` set to the smoke name under `.playwright-mcp/`.

## Stop

- `kill -- -<pgid>` on the recorded process group, then `lsof -i :<port>` to confirm the port is free.
- `docker compose down` only when this run ran `docker compose up`.
- `browser_close`.
- A found-running app is left untouched.
