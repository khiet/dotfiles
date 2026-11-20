#!/usr/bin/env bash
# Read-only code review under pi, for wrap_up.
#
# Usage: pi-review.sh [spec-file]
#
# This script only builds the review prompt; pi-consult.sh runs pi. So the
# caller sees that script's stdout (pi's report), stderr, and exit codes,
# which its header lists.
#
# The code-review skill normally starts one subagent per review axis. pi
# cannot do that here, because pi-consult.sh gives it no subagent tool.
# The prompt therefore tells pi to run both axes itself.
set -uo pipefail

spec=${1:-}

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

exec "$(dirname "$0")/pi-consult.sh" ${spec:+"$spec"} <<<"$prompt"
