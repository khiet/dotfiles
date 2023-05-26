if which fzf &>/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden'
  export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --no-info --border=rounded'

  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi
