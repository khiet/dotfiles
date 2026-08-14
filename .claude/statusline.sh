#!/bin/sh
# Claude Code status line: "<model>[ (1M context)] · <access path>"
# Receives the statusline JSON payload on stdin. The payload has no auth
# field, so the access path is inferred from env vars (Bedrock/Vertex/API
# key) with the claude.ai subscription tier from ~/.claude.json as fallback.
input=$(cat)

model=$(printf '%s' "$input" | jq -r '.model.display_name // "Claude"')
ctx=$(printf '%s' "$input" | jq -r '.context_window.context_window_size // 0')
[ "$ctx" = "1000000" ] && model="$model (1M context)"

if [ -n "$CLAUDE_CODE_USE_BEDROCK" ]; then
  access="Amazon Bedrock"
elif [ -n "$CLAUDE_CODE_USE_VERTEX" ]; then
  access="Google Vertex AI"
elif [ -n "$ANTHROPIC_API_KEY" ]; then
  access="Claude API"
else
  case $(jq -r '.oauthAccount.organizationType // empty' "$HOME/.claude.json" 2>/dev/null) in
    claude_max) access="Claude Max" ;;
    claude_pro) access="Claude Pro" ;;
    claude_team) access="Claude Team" ;;
    claude_enterprise) access="Claude Enterprise" ;;
    *) access="" ;;
  esac
fi

if [ -n "$access" ]; then
  printf '%s · %s' "$model" "$access"
else
  printf '%s' "$model"
fi
