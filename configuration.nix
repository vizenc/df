# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.optimise = {
    automatic = true;
    dates = [ "15:00" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.timeout = 0;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "quiet" ];
  boot.blacklistedKernelModules = [ "iTCO_wdt" ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
    priority = 100;
  };

  networking.hostName = "com1";

  networking.networkmanager.enable = true;
  # From https://wiki.nixos.org/wiki/Systemd/resolved#Configuration_Example:_Enforce_secure_DNS
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "true";
      Domains = [ "~." ];
      DNSOverTLS = "true";
      FallbackDNS = [
        "1.1.1.1"
        "1.0.0.1"
      ];
    };
  };

  time.timeZone = "Asia/Jakarta";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  hardware.enableAllFirmware = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
    ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
  };

  #
  # Packages
  #

  # DE
  services.power-profiles-daemon.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.polkit.enable = true;
  programs.niri.enable = true;

  # GUI
  programs.chromium.enable = true; # Policies for Brave Origin
  programs.obs-studio.enable = true;
  services.gvfs.enable = true; # pcmanfm-qt deps
  services.flatpak.enable = true; # for rare programs without native nixpkg

  # CLI
  programs.foot.enable = true;
  programs.fish.enable = true;
  programs.git.enable = true;
  programs.neovim.enable = true;
  programs.lazygit.enable = true;

  # Packages that does not have `.enable` option
  environment.systemPackages = with pkgs; [
    # Theme
    nwg-look
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
    papirus-icon-theme
    bibata-cursors

    # DE
    quickshell
    btop
    bluetui
    wiremix
    cliphist
    wl-clipboard
    wlsunset
    xwayland-satellite
    lxqt.pcmanfm-qt
    lxqt.lximage-qt
    lxqt.lxqt-archiver
    unzip # lxqt-archiver deps

    # GUI
    brave-origin
    mpv
    vscode

    # CLI
    cmatrix
    microfetch
    tree-sitter # arborist.nvim deps
    gcc # arborist.nvim deps
    nodejs # arborist.nvim deps
    ripgrep # mini.pick deps
    fzf
    fd
    dua
    imagemagick
    yt-dlp
    ffmpeg-full
    delta
    github-cli
    dotter

    # Tooling
    nil # nix
    nixfmt-rs # nix
    lua-language-server # neovim
    stylua # neovim
    kdePackages.qtdeclarative # quickshell
    pnpm # web
    typescript # web
    oxfmt # web
    oxlint # web
  ];

  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      inter
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      source-serif
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      stix-two
    ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Inter" ];
      monospace = [ "JetBrainsMonoNL Nerd Font Propo" ];
      serif = [ "Source Serif 4" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  users.users."vizen" = {
    isNormalUser = true;
    description = "vizen";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  services.getty = {
    loginOptions = "-- vizen";
    extraArgs = [ "--skip-login" ];
  };
  programs.bash.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec niri-session -l
    fi
  '';

  system.stateVersion = "26.05";
}
