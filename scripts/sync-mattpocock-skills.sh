#!/usr/bin/env bash
set -euo pipefail

# Sync a configurable set of skills from mattpocock/skills into opencode/skills/.
#
# Skills in the source repo live under category subfolders (e.g.
# skills/engineering/...). Each entry below is the path to a skill directory
# within the cloned repo; it is copied to opencode/skills/<dirname>, keeping its
# upstream directory name.
#
# Usage: ./scripts/sync-mattpocock-skills.sh [--help]

# ---------------------------------------------------------------------------
# Config (edit these to pull different skills)
# ---------------------------------------------------------------------------
REPO_URL="https://github.com/mattpocock/skills.git"
REPO_BRANCH="main"
DEST_DIR="opencode/skills" # relative to repo root

# Source paths within the cloned repo. Destination name = the basename.
# The skills below are from the "Software Fundamentals Matter More Than Ever"
# talk: https://www.youtube.com/watch?v=v4F1gFy-hqg
SKILLS=(
  "skills/engineering/improve-codebase-architecture"
  "skills/deprecated/ubiquitous-language"
  "skills/productivity/grill-me"
  "skills/productivity/grilling"
  "skills/engineering/to-prd"
  "skills/engineering/to-issues"
  "skills/engineering/tdd"
)

# ---------------------------------------------------------------------------
# Output helpers
# ---------------------------------------------------------------------------
if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'; C_RED=$'\033[31m'; C_YELLOW=$'\033[33m'
  C_BLUE=$'\033[34m'; C_GREEN=$'\033[32m'
else
  C_RESET=""; C_RED=""; C_YELLOW=""; C_BLUE=""; C_GREEN=""
fi
info()    { echo "${C_BLUE}info:${C_RESET} $*"; }
warn()    { echo "${C_YELLOW}warn:${C_RESET} $*" >&2; }
error()   { echo "${C_RED}error:${C_RESET} $*" >&2; }
success() { echo "${C_GREEN}ok:${C_RESET} $*"; }

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  sed -n '3,12p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
fi

# ---------------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------------
if ! command -v git >/dev/null 2>&1; then
  error "git is required but not found in PATH"
  exit 1
fi

ROOT="$(git rev-parse --show-toplevel)"
DEST_ABS="$ROOT/$DEST_DIR"
mkdir -p "$DEST_ABS"

tmp="$(mktemp -d)"
# tmp is task-created scratch outside the repo; safe to rm -rf on exit.
trap 'rm -rf "$tmp"' EXIT

info "Cloning $REPO_URL ($REPO_BRANCH)"
git clone --depth 1 --branch "$REPO_BRANCH" --single-branch "$REPO_URL" "$tmp/repo" >/dev/null 2>&1

# ---------------------------------------------------------------------------
# Copy skills
# ---------------------------------------------------------------------------
copied=0
failed=0

for path in "${SKILLS[@]}"; do
  dest="$(basename "$path")"
  src="$tmp/repo/$path"
  if [[ ! -d "$src" ]]; then
    warn "$dest: source path not found ($path)"
    failed=$((failed + 1))
    continue
  fi
  rm -rf "$DEST_ABS/$dest"        # overwrite: re-sync a clean copy we fully own
  cp -R "$src" "$DEST_ABS/$dest"
  success "$dest <- $path"
  copied=$((copied + 1))
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
info "Done: $copied copied, $failed failed -> $DEST_DIR/"
[[ $failed -eq 0 ]]
