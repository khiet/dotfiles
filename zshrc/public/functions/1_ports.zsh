function port { lsof -n -P -i :"$1" }
function ports { lsof -n -P -i | grep "$1" }

# pk PORT [-f]: kill whatever is listening on PORT.
#
# Only listeners are matched (-sTCP:LISTEN), so a client that happens to be
# connected to the port is left alone. TERM goes first and KILL follows only
# if the listener is still there after two seconds; -f sends KILL at once.
# Returns 0 once the port is free, 1 when nothing listened or it would not
# die, 2 on a bad argument.
function pk {
  local force=0 port arg pids
  for arg in "$@"; do
    case $arg in
      -f|--force) force=1 ;;
      *) port=$arg ;;
    esac
  done
  if [[ -z "$port" || "$port" != <-> ]]; then
    echo "usage: pk PORT [-f]" >&2
    return 2
  fi

  pids=$(lsof -tiTCP:"$port" -sTCP:LISTEN)
  if [[ -z "$pids" ]]; then
    echo "Nothing is listening on port $port"
    return 1
  fi

  # Show what is about to die, one line per process.
  lsof -n -P -iTCP:"$port" -sTCP:LISTEN | awk 'NR == 1 || !seen[$2]++'

  # ${(f)pids} splits on newlines; zsh would otherwise hand kill one
  # newline-joined word and fail with two or more pids.
  if (( force )); then
    kill -9 ${(f)pids}
  else
    kill ${(f)pids}
    local i
    for i in {1..20}; do
      sleep 0.1
      pids=$(lsof -tiTCP:"$port" -sTCP:LISTEN)
      [[ -z "$pids" ]] && break
    done
    if [[ -n "$pids" ]]; then
      echo "Still listening after TERM, sending KILL to ${(f)pids}"
      kill -9 ${(f)pids}
      sleep 0.2
    fi
  fi

  if [[ -n "$(lsof -tiTCP:"$port" -sTCP:LISTEN)" ]]; then
    echo "Port $port is still in use" >&2
    return 1
  fi
  echo "Port $port is free"
}

# kpf PORT: pk with KILL straight away.
function kpf { pk "$1" -f }
