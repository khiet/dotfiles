source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

precmd() {
  # set SIGINT to ctrl-e while editing a command
  stty intr \^E
}
preexec() {
  # set SIGINT to ctrl-c when a command is running
  stty intr \^C
}
ZVM_VI_INSERT_ESCAPE_BINDKEY=^C

# init tuin here to overwrite ctrl-r
function zvm_after_init() {
  eval "$(atuin init zsh --disable-up-arrow)"
}
