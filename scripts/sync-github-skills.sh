#!/usr/bin/env bash
set -euo pipefail

# Sync selected skills from GitHub into opencode/vendor/skills/ and symlink them
# into opencode/skills/, so vendored skills stay distinct from custom ones.
#
# The manifest is a tab-separated file with this shape:
# source  repo_url  ref  source_path  dest
#
# source_path may point to either a directory containing SKILL.md or a single
# markdown file that becomes opencode/vendor/skills/<dest>/SKILL.md (symlinked).
#
# Usage:
#   ./scripts/sync-github-skills.sh [--manifest PATH] [--source NAME ...]
#   ./scripts/sync-github-skills.sh --help

LINK_DIR="opencode/skills"
VENDOR_DIR="opencode/vendor/skills"
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
  sed -n '4,15p' "$0" | sed 's/^# \{0,1\}//'
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
LINK_ABS="$ROOT/$LINK_DIR"
VENDOR_ABS="$ROOT/$VENDOR_DIR"
manifest_abs="$ROOT/$manifest"

if [[ ! -f "$manifest_abs" ]]; then
  error "manifest not found: $manifest"
  exit 1
fi

mkdir -p "$VENDOR_ABS" "$LINK_ABS"

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

# Point opencode/skills/<dest> at the vendored copy via a relative symlink.
# Custom skills stay as real directories, so a symlink marks a synced skill.
link_vendored_skill() {
  local dest="$1"
  local link_abs="$LINK_ABS/$dest"

  # Replace a pre-existing real directory (pre-vendor layout) with a symlink.
  if [[ -e "$link_abs" && ! -L "$link_abs" ]]; then
    rm -rf "$link_abs"
  fi
  ln -sfn "../vendor/skills/$dest" "$link_abs"
}

sync_skill() {
  local repo_dir="$1"
  local source_path="$2"
  local dest="$3"
  local src="$repo_dir/$source_path"
  local vendor_rel="$VENDOR_DIR/$dest"
  local package_dir="$tmp/package/$dest"

  if ! ref_dest_is_safe "$dest"; then
    warn "$dest: invalid destination name"
    return 1
  fi

  if [[ ! -e "$src" ]]; then
    warn "$dest: source path not found ($source_path)"
    return 1
  fi

  if ! refuse_untracked_dest_files "$vendor_rel"; then
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

  mkdir -p "$VENDOR_ABS/$dest"
  rsync -a --delete "$package_dir/" "$VENDOR_ABS/$dest/"
  link_vendored_skill "$dest"
  success "$dest <- $source_path"
}

dest_in_manifest() {
  local needle="$1" d

  if [[ ${#manifest_dests[@]} -eq 0 ]]; then
    return 1
  fi

  for d in "${manifest_dests[@]}"; do
    if [[ "$d" == "$needle" ]]; then
      return 0
    fi
  done

  return 1
}

# Reconcile the vendored tree against the manifest: drop any vendored skill
# (and its symlink) whose dest no longer appears in the manifest, so removed
# rows self-clean. Custom skills are real directories and never symlinks into
# the vendor tree, so they are left untouched.
reconcile_vendor() {
  local pruned=0
  local entry name target

  if [[ -d "$VENDOR_ABS" ]]; then
    for entry in "$VENDOR_ABS"/*; do
      [[ -e "$entry" ]] || continue
      name="$(basename "$entry")"
      if ! dest_in_manifest "$name"; then
        rm -rf "$entry"
        rm -f "$LINK_ABS/$name"
        warn "pruned stale vendored skill: $name"
        pruned=$((pruned + 1))
      fi
    done
  fi

  if [[ -d "$LINK_ABS" ]]; then
    for entry in "$LINK_ABS"/*; do
      [[ -L "$entry" ]] || continue
      target="$(readlink "$entry")"
      case "$target" in
        ../vendor/skills/*)
          name="$(basename "$entry")"
          if ! dest_in_manifest "$name"; then
            rm -f "$entry"
            warn "pruned stale skill symlink: $name"
            pruned=$((pruned + 1))
          elif [[ ! -e "$entry" ]]; then
            rm -f "$entry"
            warn "pruned dangling skill symlink: $name"
            pruned=$((pruned + 1))
          fi
          ;;
      esac
    done
  fi

  info "Reconcile: $pruned pruned"
}

copied=0
failed=0
selected=0
manifest_dests=()
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

  # Track every well-formed dest (ignoring --source filters) so reconcile
  # prunes against the whole manifest, not just the selected subset.
  manifest_dests+=("$dest")

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

reconcile_vendor

info "Done: $copied copied, $failed failed -> $VENDOR_DIR/ (symlinked into $LINK_DIR/)"
[[ $failed -eq 0 ]]
