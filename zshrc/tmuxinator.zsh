if which tmuxinator &>/dev/null; then
  alias mux=tmuxinator
  export TMUXINATOR_CONFIG=$DEVS_HOME/tmuxinator
fi
