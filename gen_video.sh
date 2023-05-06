#!/bin/bash

if [ ! $# -eq 2 ]; then
    echo ""
    echo -e "\033[31mERROR\033[0m parameter amount doesn't match!!"
    echo ""
    echo -e "\033[33mUsage:\033[0m"
    echo "    ./gen_video.sh [episode] [title]"
    echo ""
    echo -e "\033[33mExample:\033[0m"
    echo "    ./gen_video.sh ep1 \"EP1 你到底該不該學程式語言？\""
    echo ""
    exit 0
fi

echo -e "\n===> Checking files..."
if [[ ! -f "$HOME/podcast/episode/"$1".mp3" ]]; then
    echo -e "\033[31mepisode "$1".mp3 doesn't exist!\033[0m\n"
    exit 0
elif [[ ! -f "$HOME/podcast/episode-cover/"$1".png" ]]; then
    echo -e "\033[31mepisode cover "$1".png doesn't exist!\033[0m\n"
    exit 0
else
    echo -e "\033[32mAll files existed\033[0m"
fi

echo -e "\n===> Transform mp3 to video"
ffmpeg -loop 1 -framerate 1 \
  -i $HOME/podcast/episode-cover/$1.png \
  -i $HOME/podcast/episode/$1.mp3 \
  -c:v libx264 -preset veryslow -crf 0 -c:a copy -shortest \
  -hide_banner \
  -loglevel panic \
  $HOME/podcast/output.mkv
echo -e "\033[32mVideo has been generated successfully\033[0m"

echo -e "\n\033[33m=== Finish!! ===\033[0m\n"
exit 0
