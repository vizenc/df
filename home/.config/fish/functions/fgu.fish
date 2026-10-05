function fgu
  fd -H -t d -g '.git' -E '**/.*/**/.git' \
  -x echo '{//}' ';' \
  -x git -C '{//}' -c color.ui=always status -s
end
