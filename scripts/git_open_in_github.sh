#! /bin/sh

alias urlencode='node -e "console.log(encodeURIComponent(process.argv[1]))"'
open $(git remote -v | grep origin | awk '{print $2}' | sed -E 's#(git@|git://)#https://#' | sed 's#github.com:#github.com/#' | sed 's#\.git#/#' | head -n1)compare/$(urlencode $(git symbolic-ref --short HEAD))
