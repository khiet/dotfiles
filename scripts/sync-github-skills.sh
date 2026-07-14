#!/usr/bin/env bash
set -euo pipefail

# Sync selected skills from GitHub repositories or gists into opencode/skills/.
#
# The manifest is a tab-separated file with this shape:
# source  repo_url  ref  source_path  dest
#
# source_path may point to either a directory containing SKILL.md or a single
# markdown file that should become opencode/skills/<dest>/SKILL.md.
#
# Usage:
#   ./scripts/sync-github-skills.sh [--manifest PATH] [--source NAME ...]
#   ./scripts/sync-github-skills.sh --help

DEST_DIR="opencode/skills"
DEFAULT_MANIFEST="scripts/github-skills.tsv"

if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'; C_RED=$'\033[31m'; C_YELLOW=$'\033[33m'
  C_BLUE=$'\033[34m'; C_GREEN=$'\033[32m'
else
  C_RESET=""; C_RED=""; C_YELLOW=""; C_BLUE=""; C_GREEN=""
fi
info()    { printf '%sinfo:%s %s\n' "$C_BLUE" "$C_RESET" "$*"; }
warn()    { printf '%swarn:%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
error()   { printf '%serror:%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; }
success() { printf '%sok:%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }

usage() {
  sed -n '3,14p' "$0" | sed 's/^# \{0,1\}//'
}

manifest="$DEFAULT_MANIFEST"
sources=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --manifest)
      if [[ $# -lt 2 ]]; then
        error "--manifest requires a path"
        exit 1
      fi
      manifest="$2"
      shift 2
      ;;
    --source)
      if [[ $# -lt 2 ]]; then
        error "--source requires a name"
        exit 1
      fi
      sources+=("$2")
      shift 2
      ;;
    *)
      error "unknown argument: $1"
      usage >&2
      exit 1
      ;;
  esac
done

if ! command -v git >/dev/null 2>&1; then
  error "git is required but not found in PATH"
  exit 1
fi

if ! command -v rsync >/dev/null 2>&1; then
  error "rsync is required but not found in PATH"
  exit 1
fi

ROOT="$(git rev-parse --show-toplevel)"
DEST_ABS="$ROOT/$DEST_DIR"
manifest_abs="$ROOT/$manifest"

if [[ ! -f "$manifest_abs" ]]; then
  error "manifest not found: $manifest"
  exit 1
fi

mkdir -p "$DEST_ABS"

tmp="$(mktemp -d)"
# tmp is task-created scratch outside the repo; safe to remove on exit.
trap 'rm -rf "$tmp"' EXIT

source_allowed() {
  local source="$1"

  if [[ ${#sources[@]} -eq 0 ]]; then
    return 0
  fi

  local allowed
  for allowed in "${sources[@]}"; do
    if [[ "$source" == "$allowed" ]]; then
      return 0
    fi
  done

  return 1
}

ref_dest_is_safe() {
  local dest="$1"

  case "$dest" in
    ""|.*|*/*|*' '*|*[^a-zA-Z0-9._-]*)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

refuse_untracked_dest_files() {
  local dest_rel="$1"

  if [[ ! -e "$ROOT/$dest_rel" ]]; then
    return 0
  fi

  if ! git -C "$ROOT" ls-files -- "$dest_rel" | grep -q .; then
    return 0
  fi

  local status
  status="$(git -C "$ROOT" status --porcelain -- "$dest_rel")"
  if printf '%s\n' "$status" | grep -q '^??'; then
    error "$dest_rel contains untracked files; refusing to overwrite"
    return 1
  fi
}

sync_skill() {
  local repo_dir="$1"
  local source_path="$2"
  local dest="$3"
  local src="$repo_dir/$source_path"
  local dest_rel="$DEST_DIR/$dest"
  local package_dir="$tmp/package/$dest"

  if ! ref_dest_is_safe "$dest"; then
    warn "$dest: invalid destination name"
    return 1
  fi

  if [[ ! -e "$src" ]]; then
    warn "$dest: source path not found ($source_path)"
    return 1
  fi

  if ! refuse_untracked_dest_files "$dest_rel"; then
    return 1
  fi

  mkdir -p "$package_dir"

  if [[ -d "$src" ]]; then
    if [[ ! -f "$src/SKILL.md" ]]; then
      warn "$dest: source directory does not contain SKILL.md ($source_path)"
      return 1
    fi
    rsync -a --delete "$src/" "$package_dir/"
  else
    cp "$src" "$package_dir/SKILL.md"
  fi

  if [[ ! -f "$package_dir/SKILL.md" ]]; then
    warn "$dest: packaged skill does not contain SKILL.md"
    return 1
  fi

  mkdir -p "$DEST_ABS/$dest"
  rsync -a --delete "$package_dir/" "$DEST_ABS/$dest/"
  success "$dest <- $source_path"
}

copied=0
failed=0
selected=0
current_repo_url=""
current_ref=""
current_repo_dir=""
clone_index=0

while IFS=$'\t' read -r source repo_url ref source_path dest rest; do
  [[ -z "${source:-}" || "${source:0:1}" == "#" ]] && continue

  if [[ -n "${rest:-}" || -z "${repo_url:-}" || -z "${ref:-}" || -z "${source_path:-}" || -z "${dest:-}" ]]; then
    warn "skipping malformed manifest row for source '$source'"
    failed=$((failed + 1))
    continue
  fi

  if ! source_allowed "$source"; then
    continue
  fi

  selected=$((selected + 1))

  if [[ "$repo_url" != "$current_repo_url" || "$ref" != "$current_ref" ]]; then
    clone_index=$((clone_index + 1))
    current_repo_dir="$tmp/repo-$clone_index"
    current_repo_url="$repo_url"
    current_ref="$ref"
    info "Cloning $repo_url ($ref)"
    git clone --depth 1 --branch "$ref" --single-branch "$repo_url" "$current_repo_dir" >/dev/null 2>&1
  fi

  if sync_skill "$current_repo_dir" "$source_path" "$dest"; then
    copied=$((copied + 1))
  else
    failed=$((failed + 1))
  fi
done < "$manifest_abs"

if [[ $selected -eq 0 ]]; then
  warn "no manifest rows matched the requested source filters"
fi

info "Done: $copied copied, $failed failed -> $DEST_DIR/"
[[ $failed -eq 0 ]]
