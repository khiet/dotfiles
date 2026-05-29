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
const allow = Object.entries(bash)
  .filter(([k, v]) => v === 'allow' && k !== '*')
  .map(([k]) => `Bash(${k})`);
if (cfg.permission && cfg.permission.webfetch === 'allow') allow.push('WebFetch');

const settings = fs.existsSync(dest) ? JSON.parse(fs.readFileSync(dest, 'utf8')) : {};
settings.permissions = settings.permissions || {};
settings.permissions.allow = allow; // generator owns ONLY allow
fs.writeFileSync(dest, JSON.stringify(settings, null, 2) + '\n');
console.log(`Wrote ${allow.length} allow rules to ${dest}`);
NODE
