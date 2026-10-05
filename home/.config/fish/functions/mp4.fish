function mp4
  yt-dlp -S "vcodec:h264,res:1080" --remux mp4 --merge mp4 \
  --embed-metadata --embed-thumbnail \
  -o "%(channel)s - %(title)s.%(ext)s" $argv[1]
end
