#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: safe-mv <source...> <destination>" >&2
  exit 1
fi

repo_root="$(git rev-parse --show-toplevel)"

# Last argument is the destination
args=("$@")
dest="${args[-1]}"
sources=("${args[@]:0:$#-1}")

# Resolve destination — it may not exist yet (new filename), so resolve its parent
if [ -e "$dest" ]; then
  abs_dest="$(realpath "$dest")"
else
  abs_dest="$(realpath "$(dirname "$dest")")/$(basename "$dest")"
fi

case "$abs_dest" in
  "$repo_root"/*) ;;
  *)
    echo "Refusing: destination outside repo root -> $dest" >&2
    exit 1
    ;;
esac

# Validate each source
for src in "${sources[@]}"; do
  abs="$(realpath "$src")"

  case "$abs" in
    "$repo_root"/*) ;;
    *)
      echo "Refusing: source outside repo root -> $src" >&2
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
  else
    rel="${abs#$repo_root/}"
    git -C "$repo_root" ls-files --error-unmatch "$rel" >/dev/null 2>&1 || {
      echo "Refusing: not git-tracked: $src" >&2
      exit 1
    }
  fi
done

# All checks passed — use git mv
git -C "$repo_root" mv "${sources[@]}" "$dest"
