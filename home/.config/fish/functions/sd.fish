function sd
  set dir (fd -H -t d -E '.git' | fzf)
  if test -n "$dir"
    cd "$dir"
  end
end
