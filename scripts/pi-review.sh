#!/usr/bin/env bash
# Read-only code review under pi with a pinned model, for wrap_up.
#
# Usage: pi-review.sh [spec-file]
#
#   stdout  pi's report
#   stderr  failure reason
#   exit 0  report printed
#   exit 3  pi changed files in the working tree
#   other   pi missing, timeout, or pi error
#
# The allowlist leaves out edit and write (only the host applies fixes) and
# subagent (it stalls under -p, so the prompt has pi run both axes itself).
# bash stays in, so the working tree is compared before and after.
set -uo pipefail

MODEL=openai-codex/gpt-6-astra:high
TOOLS=read,bash,grep,find,ls
TIMEOUT=900 # seconds, hard limit

spec=${1:-}

command -v pi >/dev/null || { echo "pi is not installed" >&2; exit 127; }
if [[ -n $spec && ! -r $spec ]]; then
  echo "spec file is not readable: $spec" >&2
  exit 2
fi

prompt="/skill:code-review Review with main as the fixed point. "
if [[ -n $spec ]]; then
  prompt+="The attached file is the spec. "
else
  prompt+="There is no spec; report the Spec axis as unavailable. "
fi
prompt+="Run both review axes yourself, one after the other. Report findings in the skill's normal report format."

cmd=(pi -p --no-session --model "$MODEL" --tools "$TOOLS")
[[ -n $spec ]] && cmd+=("@$spec")
cmd+=("$prompt")

before=$(git status --porcelain 2>/dev/null)
# alarm survives exec, so pi itself receives SIGALRM at the limit (exit 142).
report=$(perl -e 'alarm shift; exec @ARGV' "$TIMEOUT" "${cmd[@]}")
status=$?
after=$(git status --porcelain 2>/dev/null)

if [[ $before != "$after" ]]; then
  echo "pi changed files; working tree after the review:" >&2
  echo "$after" >&2
  exit 3
fi
if (( status == 142 )); then
  echo "timed out after ${TIMEOUT}s" >&2
  exit $status
fi
if (( status != 0 )); then
  echo "pi exited $status" >&2
  exit $status
fi
if [[ -z $report ]]; then
  echo "pi printed no report" >&2
  exit 1
fi
printf '%s\n' "$report"
