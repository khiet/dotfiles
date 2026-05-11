function kebab { echo "$1" | sed 's/ /-/g' | sed -r 's/([a-z0-9])([A-Z])/\1-\2/g' | tr "[:upper:]" "[:lower:]" | sed -r "s/[,:'‘’()#\"]/-/g" | sed "s|[][-]|-|g" }
