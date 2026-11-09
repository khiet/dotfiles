#! /bin/sh

repo_url=$(git remote get-url origin | sed -E -e 's#^(ssh://git@|git@|git://)#https://#' -e 's#github.com:#github.com/#' -e 's#\.git$##')
open "$repo_url/queue"
