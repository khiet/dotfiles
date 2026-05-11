function gR  { rg -0 -l "$1" | AGR_FROM="$1" AGR_TO="$2" xargs -0 perl -pi -e 's/$ENV{AGR_FROM}/$ENV{AGR_TO}/g' }
function gfR { rg --files | rg --regexp "$1" | AGR_FROM="$1" AGR_TO="$2" perl -p -e 'print $_; s/$ENV{AGR_FROM}/$ENV{AGR_TO}/' | xargs -n2 mv }
function gfD { rg --files | rg --regexp "$1" | xargs rm }
