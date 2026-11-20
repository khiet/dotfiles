#!/usr/bin/env bash
# Runs pi once, read-only, with a fixed model. The host (the agent that
# calls this script) asks a question and pi answers. pi must not change
# files; only the host does.
#
# Usage: pi-consult.sh [attachment...] < prompt
#
#   stdin   the prompt
#   stdout  pi's answer
#   stderr  failure reason
#   exit 0  answer printed
#   exit 3  pi changed files in the working tree
#   other   pi missing, bad input, timeout, or pi error
#
# pi gets a limited set of tools:
#   - No edit or write, because only the host changes files.
#   - No subagent, because it stalls when pi runs non-interactively (-p).
#   - bash is allowed, and bash can still change files. So this script
#     compares the working tree before and after the run, and exits 3 if
#     it differs.
set -uo pipefail

MODEL=openai/gpt-6.2-astra:high
TOOLS=read,bash,grep,find,ls
TIMEOUT=900 # seconds, hard limit

command -v pi >/dev/null || { echo "pi is not installed" >&2; exit 127; }

# wrap_up checks CLAUDECODE to tell whether its host is Claude Code. Remove
# it from pi's environment, because otherwise pi would inherit it and
# wrongly take itself for Claude Code.
cmd=(env -u CLAUDECODE pi -p --no-session --model "$MODEL" --tools "$TOOLS")
for attachment in "$@"; do
  if [[ ! -r $attachment ]]; then
    echo "attachment is not readable: $attachment" >&2
    exit 2
  fi
  cmd+=("@$attachment")
done

prompt=$(cat)
if [[ -z $prompt ]]; then
  echo "no prompt on stdin" >&2
  exit 2
fi
cmd+=("$prompt")

before=$(git status --porcelain 2>/dev/null)
# perl sets an alarm and then turns into pi (exec), and the alarm stays set.
# So at the time limit pi itself is stopped by SIGALRM, which shows up as
# exit 142. This script has already read stdin, so pi gets /dev/null;
# otherwise pi could wait for input from a terminal.
answer=$(perl -e 'alarm shift; exec @ARGV' "$TIMEOUT" "${cmd[@]}" </dev/null)
status=$?
after=$(git status --porcelain 2>/dev/null)

if [[ $before != "$after" ]]; then
  echo "pi changed files; working tree after the run:" >&2
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
if [[ -z $answer ]]; then
  echo "pi printed no answer" >&2
  exit 1
fi
printf '%s\n' "$answer"
