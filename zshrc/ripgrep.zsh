alias g="rg --sort-files --hidden"
alias G="rg --sort-files --no-ignore --hidden"
alias gw="rg --sort-files -w --hidden"

function gf { rg --files --sort path | rg --regexp $1 }
function gF { rg --files --no-ignore --sort path | rg --regexp $1 }
