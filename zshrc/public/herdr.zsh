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

# Nested worktree rows in the herdr sidebar show the branch in place of an
# auto-named workspace label and hide the built-in branch token. Pinning the
# checkout folder (e.g. "wy") as the label and reporting the branch as
# $worktree_branch stacks the two. The workspace's own checkout is used rather
# than the shell's cwd, so cd-ing elsewhere never relabels a space.
typeset -g _dotfiles_herdr_worktree_path _dotfiles_herdr_worktree_branch=$'\0'

_dotfiles_herdr_worktree_init() {
  emulate -L zsh
  local -a info
  info=( "${(@f)$(command herdr workspace get "$HERDR_WORKSPACE_ID" 2>/dev/null \
    | command jq -r '.result.workspace
        | select(.worktree.is_linked_worktree)
        | .worktree.checkout_path, .label')}" )
  (( ${#info} == 2 )) || return 1

  _dotfiles_herdr_worktree_path=${info[1]}
  local name=${_dotfiles_herdr_worktree_path:t}
  # Any rename marks the label as custom, which stops nested rows from
  # swapping it for the branch. The zero-width space prefix is invisible and
  # lets the sidebar config colour worktree labels with a starts_with rule.
  # A label the user already changed is kept.
  [[ ${info[2]} == "$name" ]] && command herdr workspace rename \
    "$HERDR_WORKSPACE_ID" $'​'"$name" >/dev/null 2>&1
  return 0
}

_dotfiles_herdr_worktree_sync() {
  emulate -L zsh
  if [[ -z $_dotfiles_herdr_worktree_path ]]; then
    # Not a worktree space: stop running on every prompt.
    _dotfiles_herdr_worktree_init || {
      add-zsh-hook -d precmd _dotfiles_herdr_worktree_sync
      return 0
    }
  fi

  local branch
  branch=$(command git -C "$_dotfiles_herdr_worktree_path" branch --show-current 2>/dev/null)
  [[ $branch == "$_dotfiles_herdr_worktree_branch" ]] && return 0
  _dotfiles_herdr_worktree_branch=$branch

  # A detached HEAD has no branch, so the token is cleared rather than stale.
  local -a token=( --clear-token worktree_branch )
  [[ -n $branch ]] && token=( --token "worktree_branch=$branch" )
  command herdr workspace report-metadata "$HERDR_WORKSPACE_ID" \
    --source dotfiles-worktree "${token[@]}" >/dev/null 2>&1
  return 0
}

if [[ ${HERDR_ENV:-} == 1 && -n ${HERDR_WORKSPACE_ID:-} ]] \
  && (( $+commands[herdr] && $+commands[jq] )); then
  add-zsh-hook precmd _dotfiles_herdr_worktree_sync
fi
