set -euo pipefail
exec youtube-dl -x -f bestaudio/best --audio-format wav -o "%(title)s.%(ext)s" "$1"
