function sf
  set file (fd -H -t f -E '.git' | fzf)
  if test -n "$file"
    nvim "$file"
  end
end
