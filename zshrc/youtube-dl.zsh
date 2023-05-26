function dl {
  if [[ $1 && $2 ]]; then
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best' -o "~/youtube/$2.%(ext)s" $1
  elif [[ $1 ]]; then
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best' -o '~/youtube/%(title)s-%(id)s.%(ext)s' $1
  fi
}
