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
#   exit 3  the repo changed during the run; no other failure uses 3
#   other   pi missing, bad input, timeout, or pi error
#
# pi gets a limited set of tools:
#   - No edit or write, because only the host changes files.
#   - No subagent, because it stalls when pi runs non-interactively (-p).
#   - No MCP servers, because some of them can change things outside the
#     repo, where this script cannot check.
#   - bash is allowed, and bash can still change files. So this script
#     compares the repo before and after the run, and exits 3 if it
#     differs. The caller must leave the repo alone during the run, or its
#     own change is blamed on pi.
set -uo pipefail

MODEL=openai/gpt-6.2-astra:high
TOOLS=read,bash,grep,find,ls
TIMEOUT=900 # seconds, hard limit

command -v pi >/dev/null || { echo "pi is not installed" >&2; exit 127; }

# wrap_up checks CLAUDECODE to tell whether its host is Claude Code. Remove
# it from pi's environment, because otherwise pi would inherit it and
# wrongly take itself for Claude Code.
cmd=(env -u CLAUDECODE pi -p --no-session --no-mcp --model "$MODEL" --tools "$TOOLS")
for attachment in "$@"; do
  if [[ ! -f $attachment || ! -r $attachment ]]; then
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

# Everything pi could change in the repo: the commit, the status lines, and
# the contents of changed and untracked files (the last two as hashes).
snapshot() {
  git rev-parse HEAD
  git status --porcelain
  git diff HEAD | git hash-object --stdin
  git ls-files -o --exclude-standard -z | xargs -0 git hash-object
} 2>/dev/null

before=$(snapshot)
# The prompt goes to pi on stdin, not as an argument, for two reasons. pi
# would read an argument that starts with - or @ as a flag or a file. And pi
# puts stdin before the attachments in its message, so a prompt that starts
# with /skill: stays at the start, which pi needs to run the skill.
#
# perl sets an alarm and then turns into pi (exec), and the alarm stays set.
# So at the time limit pi itself is stopped by SIGALRM, which shows up as
# exit 142.
answer=$(perl -e 'alarm shift; exec @ARGV' "$TIMEOUT" "${cmd[@]}" <<<"$prompt")
status=$?
after=$(snapshot)

if [[ $before != "$after" ]]; then
  echo "the repo changed during the run; before (<) and after (>):" >&2
  diff <(printf '%s\n' "$before") <(printf '%s\n' "$after") >&2
  exit 3
fi
if (( status == 142 )); then
  echo "timed out after ${TIMEOUT}s" >&2
  exit $status
fi
if (( status != 0 )); then
  echo "pi exited $status" >&2
  # 3 is reserved for the repo check above.
  (( status == 3 )) && exit 1
  exit $status
fi
if [[ -z $answer ]]; then
  echo "pi printed no answer" >&2
  exit 1
fi
printf '%s\n' "$answer"
