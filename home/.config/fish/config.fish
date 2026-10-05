#
# Env
#

fish_add_path -g "$HOME/.local/bin"

set -gx MANPAGER 'nvim +Man!'
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx FZF_DEFAULT_OPTS_FILE "$HOME/.config/fzf/rc"
set -gx RIPGREP_CONFIG_PATH "$HOME/.config/ripgrep/rc"

if status is-interactive
  # Commands to run in interactive sessions can go here

  #
  # Theme
  #

  set -g fish_color_normal white
  set -g fish_color_command magenta
  set -g fish_color_builtin magenta
  set -g fish_color_function magenta
  set -g fish_color_keyword red
  set -g fish_color_quote cyan
  set -g fish_color_redirection white
  set -g fish_color_end red
  set -g fish_color_error red
  set -g fish_color_param white
  set -g fish_color_valid_path white
  set -g fish_color_option white
  set -g fish_color_comment brblack
  set -g fish_color_selection --reverse
  set -g fish_color_operator red
  set -g fish_color_escape green
  set -g fish_color_autosuggestion brblack
  set -g fish_color_cwd white
  set -g fish_color_cwd_root yellow
  set -g fish_color_user green
  set -g fish_color_host green
  set -g fish_color_host_remote red
  set -g fish_color_status yellow
  set -g fish_color_cancel yellow
  set -g fish_color_search_match black --background=yellow
  set -g fish_color_history_current black --background=blue

  #
  # Greeter
  #

  function fish_greeting
    set_color yellow
    echo "There was a time when Einstein couldn't count to ten"
    echo "A year from now you may wish you had started today"
    set_color normal
  end

  #
  # Prompt
  #

  function fish_prompt
    set -l user_host (set_color -o green)"$USER@"(prompt_hostname)
    set -l pwd_info  (set_color -o blue)(prompt_pwd)
    set -l git_info  (set_color -o cyan)(fish_vcs_prompt)
    set -l symbol    (set_color normal)'$ '

    echo
    echo "$user_host $pwd_info$git_info"
    echo -n $symbol
  end

  #
  # Keybind
  #

  bind \cy end-of-line

  #
  # Alias
  #

  alias shis='history | fzf | wl-copy -n'
  alias rebuild='sudo nixos-rebuild switch'
  alias update='sudo nixos-rebuild switch --upgrade'
  alias vim='nvim'
  alias lazyvim='env NVIM_APPNAME=lazyvim nvim'

end
