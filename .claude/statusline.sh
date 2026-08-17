#!/bin/sh
# Status line: "<model> · <access path>". The stdin payload has no auth
# field, so access is inferred from CLAUDE_CODE_USE_BEDROCK, else the
# subscription tier in ~/.claude.json.
input=$(cat)

model=$(printf '%s' "$input" | jq -r '.model.display_name // "Claude"')

if [ -n "$CLAUDE_CODE_USE_BEDROCK" ]; then
  access="Amazon Bedrock"
else
  case $(jq -r '.oauthAccount.organizationType // empty' "$HOME/.claude.json" 2>/dev/null) in
    claude_max) access="Claude Max" ;;
    claude_pro) access="Claude Pro" ;;
    *) access="Claude Sub" ;;
  esac
fi

printf '%s · %s' "$model" "$access"
