#!/usr/bin/env bash
# Narrate an explain-diff-html page with clipboard-tts and embed player.html
# under its first </h1>. Re-running replaces the previous player.
# Exit 2 means a dependency is missing and the page was left unchanged.
set -euo pipefail

page=${1:?usage: narrate.sh PAGE.html}
tts=$HOME/clipboard-tts
here=$(cd "$(dirname "$0")" && pwd)

if [[ ! -x $tts/.venv/bin/python ]] || ! command -v ffmpeg >/dev/null; then
  echo "narrate: clipboard-tts or ffmpeg not installed; skipped" >&2
  exit 2
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# The player has no visible text, so narrating a page that already has one
# produces the same audio.
"$tts/.venv/bin/python" "$tts/speak_clipboard.py" "$page" -o "$tmp/audio.wav" >/dev/null
ffmpeg -loglevel error -y -i "$tmp/audio.wav" -c:a libopus -b:a 32k -ac 1 "$tmp/audio.webm"

python3 - "$page" "$here/player.html" "$tmp/audio.webm" <<'EOF'
import base64, re, sys
page_path, player_path, audio_path = sys.argv[1:]
page = open(page_path, encoding="utf-8").read()
player = open(player_path, encoding="utf-8").read()
audio = base64.b64encode(open(audio_path, "rb").read()).decode()
page = re.sub(r"\n?<!-- narration -->.*?<!-- /narration -->\n?", "\n", page, flags=re.S)
if "</h1>" not in page:
    sys.exit("narrate: no </h1> to place the player under")
page = page.replace("</h1>", "</h1>\n" + player.replace("__AUDIO_BASE64__", audio), 1)
open(page_path, "w", encoding="utf-8").write(page)
EOF

seconds=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$tmp/audio.webm")
printf 'narrate: %dm%02ds of audio embedded in %s\n' \
  "$((${seconds%.*} / 60))" "$((${seconds%.*} % 60))" "$page"
