#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)" # -> dotfiles/
node - "$DIR" <<'NODE'
const { execFileSync } = require('child_process');
const fs = require('fs'), path = require('path');
const root = process.argv[2];
const src = path.join(root, 'opencode/_opencode.jsonc');

let raw = fs.readFileSync(src, 'utf8')
  .replace(/\/\*[\s\S]*?\*\//g, '') // strip block comments
  .replace(/,(\s*[}\]])/g, '$1');   // strip trailing commas
const cfg = JSON.parse(raw);
const mcp = cfg.mcp || {};

// opencode {env:VAR} -> Claude ${VAR} (Claude expands at runtime, so secrets
// never get baked into ~/.claude.json).
const envRef = (s) => s.replace(/\{env:([^}]+)\}/g, '$${$1}');

const claude = (args) => execFileSync('claude', args, { stdio: ['ignore', 'ignore', 'ignore'] });

let added = 0;
const parked = []; // enabled:false in opencode, but Claude has no off-state
for (const [name, s] of Object.entries(mcp)) {
  // Re-run is idempotent: drop any prior user-scope copy first, then re-add.
  try { claude(['mcp', 'remove', '--scope', 'user', name]); } catch {}

  // Import every defined server. Claude has no per-server disabled state, so
  // opencode's enabled:false servers are registered here too (active, not off).
  if (s.enabled === false) parked.push(name);

  if (s.type === 'remote') {
    // name + url must precede the variadic -H flags, else they get consumed.
    const args = ['mcp', 'add', '--transport', 'http', '--scope', 'user', name, s.url];
    for (const [k, v] of Object.entries(s.headers || {})) args.push('-H', `${k}: ${envRef(v)}`);
    claude(args);
  } else if (s.type === 'local') {
    // name first, then variadic -e, then -- terminates env and begins command.
    const args = ['mcp', 'add', '--scope', 'user', name];
    for (const [k, v] of Object.entries(s.environment || {})) args.push('-e', `${k}=${envRef(String(v))}`);
    args.push('--', ...s.command);
    claude(args);
  } else {
    console.warn(`Skipping ${name}: unknown type ${s.type}`);
    continue;
  }
  console.log(`  + ${name} (${s.type})${s.enabled === false ? '  [enabled:false in opencode]' : ''}`);
  added++;
}
console.log(`Registered ${added} MCP server(s) at user scope.`);
if (parked.length) {
  console.log(`Note: ${parked.join(', ')} are enabled:false in opencode; Claude has no off-state, so they are active here and may show as failed in /mcp until configured.`);
}
NODE
