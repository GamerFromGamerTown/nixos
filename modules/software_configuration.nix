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

    #foot = { 
    #theme = "catppuccin-mocha";
    # enableFishIntegration = false;
    #enable = true;
    #};

    # Zsh Configuration
    zsh = {
      enable = true;
      ohMyZsh.enable = false;
      histSize = 2500; # Set history size
      autosuggestions.enable = true;
      setOptions = [ "AUTO_CD" "CHASE_LINKS" "AUTO_LIST" "PATH_DIRS" ];
      shellAliases = {
        ls = "ls -Ahs --color=auto";
        ll = "ls -lah";
        du = "du -h";
        sudo = "doas";
        whomstami = "echo thou art $(whoami)";
        sudoedit = "doas $EDITOR";
        ne = "/etc/nixos/modules/scripts/ne.sh";
        he = "/etc/nixos/modules/scripts/he.sh";
        rb = "sudo nixos-rebuild switch && git -C /etc/nixos add --all && git -C /etc/nixos commit -m 'Update NixOS configuration' && git -C /etc/nixos push origin main";
        np = "eval \$(ssh-agent -s) && git add . && ssh-add ~/.ssh/github_nixos && git commit -m 'Update configuration' && git push origin main";
      };
      syntaxHighlighting = {
        enable = true;
        #patterns = { "rm -rf " = "fg=white,bold,bg=red";};      
      };

      shellInit = ''
        # History Settings
        export HISTFILE=~/.zsh_history
        export SAVEHIST=2500

        # Prompt Configuration
        autoload -Uz colors && colors
        PROMPT='%{$fg[magenta]%}~%{$reset_color%} %# '

        # Fastfetch (optional)
        fastfetch 
      '';

      # Automatically install zsh-syntax-highlighting and zsh-autosuggestions
      #  package = pkgs.zsh;
      #  additionalPackages = [
      #    pkgs.zsh-syntax-highlighting
      #    pkgs.zsh-autosuggestions
      #    ];
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
      brightnessctl
      busybox
      cura
      doas
      fastfetch
      fzf
      graphene-hardened-malloc
      glibcLocales
      grub2
      lact
      logrotate
      lm_sensors
      mako
      musl
      oh-my-zsh
      redshift
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
      polkit
      polkit_gnome
      qemu
      virt-manager

      # Development Tools
      brave
      git
      #home-manager
      python3
      #qbittorrent

      # Multimedia and Graphics
      gimp
      krita
      libglvnd
      libreoffice-still
      libnotify
      libva
      libvdpau-va-gl
      mesa
      mesa.drivers
      mpv
      obs-studio
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
      the-powder-toy
      tor-browser

      # Monitoring and Information
      btop
      cmatrix
      htop

      # Essential tooling (needed with environment.defaultPackages = lib.mkForce [])
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
  ] ++ (with pkgs.kdePackages; [
    polkit-kde-agent-1
  ]) ++ (with pkgs.xfce; [
    thunar
  ]);
  };

  # Exclude specific Plasma 6 packages
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

  environment.variables = { EDITOR = "nano"; };

}
