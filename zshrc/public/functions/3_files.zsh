function mv2 { dirname "$2" | xargs mkdir -p; mv "$1" "$2" }
function cp2 { dirname "$2" | xargs mkdir -p; cp "$1" "$2" }
