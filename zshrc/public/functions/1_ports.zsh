function port { lsof -n -P -i :"$1" }
function ports { lsof -n -P -i | grep "$1" }

function kp {
  local pids
  pids=$(lsof -ti tcp:"$1")

  if [[ -z "$pids" ]]; then
    echo "No process found on port $1"
    return 1
  fi

  kill $pids
}

function kpf { lsof -ti tcp:"$1" | xargs kill -9 }
