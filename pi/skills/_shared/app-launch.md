# App launch (web)

Shared mechanics for skills that boot the project's web app and drive it with the Playwright MCP. The calling skill decides when each section runs and what a miss means; this file only says how. Every fact here comes from the repo, its documents, or the running process, never from the user.

## Availability

The Playwright MCP tools must be listed in this session; `browser_navigate` is the probe. Missing means the driver is unavailable.

## Web signal

Any of: a `package.json` with a `dev`, `start`, `serve`, or `preview` script; a framework config file (`next.config.*`, `vite.config.*`, `nuxt.config.*`, `svelte.config.*`, `astro.config.*`, `angular.json`, `remix.config.*`); an `index.html` at the root or under `public/`, `src/`, or `app/`; a `docker compose` service that publishes a port.

## Recipe

Check in order and stop at the first hit:

1. An app already answering at the documented URL: `curl -sI <url>`. Any HTTP response means found running.
2. A dev command or URL in `CLAUDE.md`, `AGENTS.md`, or `README`.
3. The project manifest: `package.json` scripts `dev`, `start`, `serve`, or `preview`.
4. `docker compose` with a published port.
5. A `Makefile`, `Procfile`, or `justfile` target named `dev`, `start`, or `run`.

Credentials come only from those same documents. A documented login is `browser_navigate` to the login route, `browser_fill_form` with the documented credentials, and submit; the calling skill counts it against its interaction cap.

Record the recipe as start command, readiness probe, stop command, and a found-running flag.

## Launch

1. When `.gitignore` does not cover it, add `.playwright-mcp/` to `.git/info/exclude`. That file is per clone and never committed, so the tree stays clean for the caller's commits without adding a project file.
2. A found-running app is used as is; skip to readiness.
3. Otherwise run the recipe's start command in the background with job control on (`set -m`), stdout and stderr to a log file in the scratch dir, and record its pid. Job control gives the command its own process group, so the pid names every process it spawns, including the grandchildren a package manager forks.
4. Read the local URL from the log (dev servers print it); fall back to the documented URL when the log has none within the readiness cap.
5. Readiness: poll the base URL every 2 s until it answers below 500, within 120 s.
6. `docker compose up`: record the service names it started that `docker compose ps` did not already list as running.

## Stop

The calling skill runs this on every exit after Launch has run, including a skip.

- `kill -- -<pid>` on the recorded process group; done when `pgrep -g <pid>` returns nothing and `lsof -i :<port>` shows the port free.
- `docker compose stop <services>` for the services this run started, so services already running stay up.
- `browser_close`.
- A found-running app is left untouched.
