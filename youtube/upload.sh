#!/bin/bash

if [ ! $# -eq 2 ]; then
    echo ""
    echo -e "\033[31mERROR\033[0m parameter amount doesn't match!!"
    echo ""
    echo -e "\033[33mUsage:\033[0m"
    echo "    ./upload.sh [episode] [title]"
    echo ""
    echo -e "\033[33mExample:\033[0m"
    echo "    ./upload.sh ep1 \"EP1 你到底該不該學程式語言？\""
    echo ""
    exit 0
fi

echo -e "\n===> Checking files..."
if [[ ! -f "$HOME/podcast/youtube/cover/"$1".png" ]]; then
    echo -e "\033[31myoutube cover "$1".png doesn't exist!\033[0m\n"
    exit 0
elif [[ ! -f "$HOME/podcast/episode/"$1".mp3" ]]; then
    echo -e "\033[31mepisode "$1".mp3 doesn't exist!\033[0m\n"
    exit 0
else
    echo -e "\033[32mAll files existed\033[0m"
fi

echo -e "\n===> Transform mp3 to video"
ffmpeg -loop 1 -framerate 1 \
  -i $HOME/podcast/youtube/cover/$1.png \
  -i $HOME/podcast/episode/$1.mp3 \
  -c:v libx264 -preset veryslow -crf 0 -c:a copy -shortest \
  -hide_banner \
  -loglevel panic \
  $HOME/podcast/youtube/output.mkv
echo -e "\033[32mVideo has been generated successfully\033[0m"

# 使用 https://github.com/tokland/youtube-upload 上傳 video 到 Youtube 上
# 另外需要先上 Google Console 申請 Youtube 專用的 Oauth2 client secret
# 申請流程參考 https://medium.com/@yanweiliu/%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8python%E4%B8%8A%E5%82%B3youtube%E5%BD%B1%E7%89%87-8d90c0b5cf2c
echo -e "\n===> Upload video to Youtube"
youtube-upload \
  --title="$2" \
  --description="
如果你喜歡這支影片，歡迎到 Facebook 粉絲專頁按讚追蹤 👏🏻
Facebook 古古說：https://www.facebook.com/kukutalking/posts

也可以在 Podcast 上收聽我的節目哦 ⭐
Apple Podcast：https://podcasts.apple.com/tw/podcast/%E5%8F%A4%E5%8F%A4%E8%AA%AA/id1515003927
Spotify：https://open.spotify.com/show/6SL4YB8TOPIbJQi7zDEFqA
" \
  --client-secrets="$HOME/podcast/youtube/my_client_secret.json" \
  $HOME/podcast/youtube/output.mkv
echo -e "\033[32mUpload successfully\033[0m"

echo -e "\n===> Remove local video file"
rm $HOME/podcast/youtube/output.mkv
echo -e "\033[32mRemove successfully\033[0m"

echo -e "\n\033[33m=== Finish!! ===\033[0m\n"
exit 0
