_dotfiles_herdr_agent_tab() {
  emulate -L zsh
  [[ ${HERDR_ENV:-} == 1 && -n ${HERDR_TAB_ID:-} ]] || return 0
  (( $+commands[herdr] )) || return 0

  local -a words
  words=( ${(z)${2:-$1}} )
  local executable=${(Q)words[1]} label
  case ${executable:t} in
    pi) label=pi ;;
    claude) label=cl ;;
    *) return 0 ;;
  esac

  command herdr tab rename "$HERDR_TAB_ID" "$label" >/dev/null 2>&1 || true
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _dotfiles_herdr_agent_tab
