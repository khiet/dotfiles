#! /bin/sh

open $(git remote -v | awk '{print $2}' | sed -E 's#(git@|git://)#https://#' | sed 's#github.com:#github.com/#' | sed 's#\.git#/#' | head -n1)/compare/$(git symbolic-ref --short HEAD)
