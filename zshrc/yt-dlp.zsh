function dl {
  if [[ $1 && $2 ]]; then
    yt-dlp -f 'bestvideo+bestaudio/best' --merge-output-format mp4 -o "$HOME/Desktop/$2.%(ext)s" "$1"
  elif [[ $1 ]]; then
    yt-dlp -f 'bestvideo+bestaudio/best' --merge-output-format mp4 -o '$HOME/Desktop/%(title)s.%(ext)s' "$1"
  fi
}
