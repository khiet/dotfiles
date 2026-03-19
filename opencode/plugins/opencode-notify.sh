#!/bin/bash
# only show visual notification for permission events
if [ "$1" = "permission" ]; then
  terminal-notifier -title "OpenCode" -message "$2"
fi
