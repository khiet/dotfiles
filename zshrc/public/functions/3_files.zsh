function mv2 { mkdir -p "$(dirname "$2")"; mv "$1" "$2" }
function cp2 { mkdir -p "$(dirname "$2")"; cp "$1" "$2" }
