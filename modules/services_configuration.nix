{ config, pkgs, lib, ... }:

{

  # Services Configuration
  services = {
    # Enable the X11 windowing system
    xserver = {
      enable = false;
      videoDrivers = [ "amdgpu" ];
      xkb = {
        layout = "us"; # Configure keyboard layout
        variant = "";
      };
    };

    # Enable the KDE Plasma Desktop Environment
    displayManager.sddm = {
      enable = true;
      wayland.enable = true; # Enable Wayland support
      enableHidpi = false;
      autoNumlock = true;
    };
    desktopManager.plasma6.enable = true;

    # Enable printing with CUPS
    printing = {
      enable = true;
      startWhenNeeded = true;
    };
    # Enable PipeWire for audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    # Security-related services
    dbus.enable = true;

    # Disable power profiles daemon
    power-profiles-daemon.enable = false;
  };

  # Systemd Configuration
  systemd = {
    packages = with pkgs; [ lact ];
    services.lactd.wantedBy = ["multi-user.target"];
    sockets = {
      libvirtd.enable = true;
      libvirtd_ro.enable = true;
      libvirtd_admin.enable = true;
    };
  };
  
  #environment.etc."xdg/autostart/polkit-gnome-authentication-agent-1.desktop".text = ''
  #  [Desktop Entry]
  #  Type=Application
  #  Exec=${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
  #  Name=Polkit GNOME Authentication Agent
  #'';

  # Virtualisation Configuration
  virtualisation = {
    vmware.host.enable = true;
    libvirtd = {
      enable = true;
      extraConfig = ''
        unix_sock_group = "libvirt"
        unix_sock_rw_perms = "0770"
        auth_unix_ro = "none"
        auth_unix_rw = "none"
        log_level = 1          # Debugging; adjust as needed
        log_filters = "1:libvirt 1:qemu 1:util 1:rpc 1:conf 1:json 1:event"
      '';
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };
  };

  # Hardware Configuration
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  hardware.pulseaudio.enable = false; # Use PipeWire instead

  # Nix Configuration
  nix.settings = {
    substituters = [ "https://cache.nixos.org/" ];
    trusted-public-keys = [
      "cache.nixos.org-1:lw5SkKfVYFX5W6PvH1HDpW1S12pRj7fjfjRz9Vm7xhM="
    ];
  };

  # Environment Configuration
  environment.etc."preload.conf".text = ''
    ${pkgs.zsh}/bin/zsh
    ${pkgs.glibc}/lib/libc.so.6
    ${pkgs.ncurses}/lib/libncurses.so.6
    ${pkgs.pcre}/lib/libpcre.so.1
  '';
  environment.shellInit = ''
    umask 0077                      # Set restrictive file permissions by default 
 '';


  # Theme Configuration
  catppuccin = {
    flavor = "mocha";
    enable = true;
  };

  # Programs Configuration
  programs = {
    virt-manager.enable = true; 
    dconf.enable = true; 
      git = {
      enable = true;
      config = {
        user = {
          name = "Your Name";  # Replace with your GitHub display name
          email = "100511215+GamerFromGamerTown@users.noreply.github.com";  # Replace with your GitHub noreply email
        };
      };
    };
  };

}

