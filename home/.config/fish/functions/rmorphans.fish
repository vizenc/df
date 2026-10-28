# https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#:~:text=However%2C%20without,the%20initial%20removals
function rmorphans --description 'Repeatedly remove orphaned pacman packages'
  while pacman -Qdtq > /dev/null
    pacman -Qdtq | sudo pacman -Rn -
    or break
  end
end
