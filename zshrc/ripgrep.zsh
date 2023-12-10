alias g="rg --sort path --hidden"
alias G="rg --sort path --no-ignore --hidden"
alias gw="rg --sort path -w --hidden"

function gf { rg --files --sort path | rg --regexp $1 }
function gF { rg --files --no-ignore --sort path | rg --regexp $1 }
