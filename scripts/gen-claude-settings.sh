#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)" # -> dotfiles/
node - "$DIR" <<'NODE'
const fs = require('fs'), path = require('path');
const root = process.argv[2];
const src  = path.join(root, 'opencode/_opencode.jsonc');
const dest = path.join(root, '.claude/settings.json');

let raw = fs.readFileSync(src, 'utf8')
  .replace(/\/\*[\s\S]*?\*\//g, '') // strip block comments
  .replace(/,(\s*[}\]])/g, '$1');   // strip trailing commas
const cfg = JSON.parse(raw);

const bash = (cfg.permission && cfg.permission.bash) || {};
const deny = Object.entries(bash)
  .filter(([k, v]) => v === 'deny' && k !== '*')
  .map(([k]) => `Bash(${k})`);

const settings = fs.existsSync(dest) ? JSON.parse(fs.readFileSync(dest, 'utf8')) : {};
settings.permissions = settings.permissions || {};
delete settings.permissions.allow;
settings.permissions.deny = deny; // generator owns ONLY deny
fs.writeFileSync(dest, JSON.stringify(settings, null, 2) + '\n');
console.log(`Wrote ${deny.length} deny rules to ${dest}`);
NODE
