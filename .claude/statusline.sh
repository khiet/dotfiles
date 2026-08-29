#!/bin/sh
# Status line: "<model> · <access path> · <context used>%/<window>".
# The stdin payload has no auth field, so access is inferred from
# CLAUDE_CODE_USE_BEDROCK, else the subscription tier in ~/.claude.json.
input=$(cat)

model=$(printf '%s' "$input" | jq -r '.model.display_name // "Claude"')
context=$(printf '%s' "$input" | jq -r '
  def compact_tokens:
    if . >= 1000000 then
      (((. / 1000000 * 10) | round) / 10 | tostring) + "M"
    elif . >= 1000 then
      (((. / 1000 * 10) | round) / 10 | tostring) + "K"
    else
      tostring
    end;

  if .context_window.context_window_size != null then
    "\(.context_window.used_percentage // "0.0")%/\(.context_window.context_window_size | compact_tokens)"
  else
    empty
  end
')

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
if [ -n "$context" ]; then
  printf ' · %s' "$context"
fi
