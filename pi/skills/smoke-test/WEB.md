# Web driver (Playwright MCP)

Mechanics for the `playwright` driver. The workflow in [`SKILL.md`](SKILL.md) decides when each section runs and sets the caps. Launch and stop are the shared [`../_shared/app-launch.md`](../_shared/app-launch.md); this file holds what is specific to smoke-testing a diff.

## Route derivation

- File-based routers: a file under `pages/`, `app/`, `routes/`, or `src/routes/` maps to its path segment; `index` and `page` files map to the directory; bracketed segments are parameters.
- Config routers: search for `path:` entries or `<Route path=` elements that import the changed component.
- Anything else: grep for importers of the changed file and walk up until a route file is hit. A file with no route within three hops is `Not covered: needs data` with the chain noted.
- A documented login, per `app-launch.md` `Recipe`, spends the interaction budget for every row that needs it.

## Drive

Per row:

1. `browser_navigate` to the route.
2. Wait by observable kind. Text: `browser_wait_for` with `text`. Control, test id, or style-only: `browser_wait_for` with `time` 2, since the tool has no network-idle mode.
3. Confirm by observable kind. Text or control: `browser_find` with the text or role. Test id: `browser_evaluate` with `() => document.querySelector('[data-testid="<id>"]') !== null`, because the accessibility snapshot carries no test ids. Style-only: `browser_snapshot` returns a tree.
4. `browser_console_messages` with `level` `error`. The default window is since the last navigation, so this is the row's own output; the startup set was read the same way after the root load.
5. `browser_take_screenshot` with `filename` set to the smoke name under `.playwright-mcp/`.
