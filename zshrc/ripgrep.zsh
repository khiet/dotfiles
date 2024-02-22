alias g="rg --sort path --hidden"
alias G="rg --sort path --no-ignore --hidden"
alias gw="rg --sort path -w --hidden"

function gf { rg --files --sort path --hidden | rg --regexp $1 }
function gF { rg --files --sort path --no-ignore --hidden | rg --regexp $1 }
