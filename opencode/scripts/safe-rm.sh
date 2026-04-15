#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"

for target in "$@"; do
  abs="$(realpath "$target")"

  case "$abs" in
    "$repo_root"/*) ;;
    *)
      echo "Refusing: outside repo root -> $target" >&2
      exit 1
      ;;
  esac

  if [ -d "$abs" ]; then
    while IFS= read -r -d '' f; do
      rel="${f#$repo_root/}"
      git -C "$repo_root" ls-files --error-unmatch "$rel" >/dev/null 2>&1 || {
        echo "Refusing: untracked file in dir: $f" >&2
        exit 1
      }
    done < <(find "$abs" -type f -print0)
    git -C "$repo_root" rm -rf -- "$abs"
  else
    rel="${abs#$repo_root/}"
    git -C "$repo_root" ls-files --error-unmatch "$rel" >/dev/null 2>&1 || {
      echo "Refusing: not git-tracked: $target" >&2
      exit 1
    }
    git -C "$repo_root" rm -f -- "$abs"
  fi
done
