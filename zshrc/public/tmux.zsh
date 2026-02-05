alias ta='tmux attach -t'
t() { tmux new -s "${PWD##*/}" }
alias tn='tmux new -s'
alias tls='tmux ls'
alias td='tmux kill-session -t'
