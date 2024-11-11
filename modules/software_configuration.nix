{ config, pkgs, lib, ... }:

{
  # Program Configuration
  programs = {
    # Enable Firefox
    firefox.enable = true;

    # Enable Hyprland window manager and related programs
    hyprland = {
      enable = true;
      xwayland.enable = true; # Enable XWayland for compatibility with X11 applications
    };
    hyprlock.enable = true; # Enable Hyprlock

    # Enable Steam with external testing
    steam = {
      enable = true;
      extest.enable = true;
    };

    # Zsh Configuration
    zsh = {
      enable = true;
      histSize = 2500; # Set history size
      shellInit = ''
        # Custom commands and aliases
        fastfetch
        export EDITOR=nano
        alias ls="ls -Ahs --color=auto"
        alias ll="ls -lah"
        alias du="du -h"
        alias sudo="doas"
        whomstami="echo thou art $(whoami)"
        alias sudoedit="doas $EDITOR"
        alias ne="/etc/nixos/modules/scripts/ne.sh"
        alias he="nano ~/.config/hypr/hyprland.conf"
	alias rb="sudo nixos-rebuild switch && git -C /etc/nixos add --all && git -C /etc/nixos commit -m "Update NixOS configuration" && git -C /etc/nixos push origin main"
	alias np="eval "$(ssh-agent -s)" && git add . && ssh-add ~/.ssh/github_nixos && git commit -m "Update configuration" && git push origin main"
      '';
      syntaxHighlighting.enable = true; # Enable syntax highlighting
      autosuggestions.enable = true; # Enable autosuggestions
      ohMyZsh = {
        enable = true;
        plugins = [ "git" ]; # Use git plugin
        theme = "kolo"; # Set theme to "kolo"
      };
    };
  };

  # Environment Configuration
  environment = {
    defaultPackages = lib.mkForce [ ];
    systemPackages = with pkgs; [

      # System Utilities and Tools
      amdctl
      amdgpu_top
      auto-cpufreq
      bubblewrap
      busybox
      cura
      doas
      fastfetch
      fzf
      graphene-hardened-malloc
      grub2
      lact
      logrotate
      lm_sensors
      oh-my-zsh
      timer
      wget
      zsh

# System Services and Daemons
      apparmor-profiles
      bluez
      clamav
      libvirt
      networkmanager
      networkmanager-openvpn
      #polkit
      #polkit_gnome
      qemu
      virt-manager

# Development Tools
      brave
      git
      home-manager
      python3
      #qbittorrent

# Multimedia and Graphics
      gimp
      libglvnd
      libreoffice-fresh
      libnotify
      libva
      libvdpau-va-gl
      mesa
      mesa.drivers
      mpv
      openal
      pavucontrol
      pipewire
      webcamoid

# Wayland and Compositing
      eww
      foot
      swaybg
      vesktop
      waybar
      wayland
      wayland-utils
      waypaper
      wofi
      xwayland

# Text Editors and IDEs
      vscodium

# Gaming and Launchers
      prismlauncher
      steam
      tor-browser

# Monitoring and Information
      btop
      cmatrix
      htop

# Essential tooling (needed with environment.defaultPackages = lib.mkForce [];) 
      bashInteractive
      coreutils-full
      curl
      less
      mkpasswd
      nano
      ncurses
      netcat
      su
      time
      util-linux
      which
      xz
# Fonts 
      eb-garamond
      fira-code
      iosevka-bin
      jetbrains-mono
      lato
      nerdfonts
      noto-fonts-emoji
      overpass
      ubuntu_font_family
    ];
  };
		# try installing the linux runtime kernel guard (linuxKernel.packages.linux_6_6.lkrg or linuxKernel.packages.linux_6_6_hardened.lkrg)

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    oxygen
  ];

  # Virtualization Configuration
  virtualisation.libvirtd = {
    enable = true;
    extraConfig = ''
      unix_sock_group = "libvirt"
      unix_sock_ro_perms = "0777"
      unix_sock_rw_perms = "0770"
      auth_unix_ro = "none"
      auth_unix_rw = "none"
      log_filters = "3:remote 4:event 3:json 3:jrpc 4:util.json 1:util.libvirt"
      log_outputs = "1:file:/var/log/libvirt/libvirtd.log"
    '';
  };
}
