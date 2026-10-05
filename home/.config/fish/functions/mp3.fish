function mp3
  yt-dlp -f bestaudio --extract-audio --audio-quality 0 --audio-format mp3 \
  --embed-metadata --embed-thumbnail \
  --ppa "ThumbnailsConvertor+FFmpeg_o:-c:v mjpeg -vf crop=\"'min(iw,ih)':'min(iw,ih)'\"" \
  -o "%(channel)s - %(title)s.%(ext)s" $argv[1]
end
