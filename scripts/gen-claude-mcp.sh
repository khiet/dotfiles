#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)" # -> dotfiles/
node - "$DIR" <<'NODE'
const { execFileSync } = require('child_process');
const fs = require('fs'), path = require('path');
const root = process.argv[2];
const src = path.join(root, 'pi/mcp.json');
const mcp = JSON.parse(fs.readFileSync(src, 'utf8')).mcpServers || {};

const claude = (args) => execFileSync('claude', args, { stdio: ['ignore', 'ignore', 'ignore'] });

let added = 0;
const parked = []; // disabled in pi, but Claude has no off-state
for (const [name, entry] of Object.entries(mcp)) {
  // Claude has no per-server disabled state, so disabled servers are
  // registered too (active, not off). The flag itself is not Claude config.
  const { disabled, ...s } = entry;
  if (disabled === true) parked.push(name);
  if (!s.type) s.type = s.url ? 'http' : 'stdio';

  // Re-run is idempotent: drop any prior user-scope copy first, then re-add.
  try { claude(['mcp', 'remove', '--scope', 'user', name]); } catch {}
  // ${VAR} references pass through untouched; Claude expands them at runtime,
  // so secrets never get baked into ~/.claude.json.
  claude(['mcp', 'add-json', '--scope', 'user', name, JSON.stringify(s)]);
  console.log(`  + ${name} (${s.type})${disabled === true ? '  [disabled in pi]' : ''}`);
  added++;
}
console.log(`Registered ${added} MCP server(s) at user scope.`);
if (parked.length) {
  console.log(`Note: ${parked.join(', ')} are disabled in pi; Claude has no off-state, so they are active here and may show as failed in /mcp until configured.`);
}
NODE
