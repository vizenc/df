function fcut
  ffmpeg -i $argv[1] -ss $argv[2] -to $argv[3] -c copy $argv[4]
end
