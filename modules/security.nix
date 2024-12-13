{ config, pkgs, ... }:

{
  # Security Configuration

  environment = {
    variables.LD_PRELOAD = "/nix/store/xas37drcjyxklrkw533abp5a6ld6b59v-graphene-hardened-malloc-2024040900/lib/libhardened_malloc.so";
    memoryAllocator.provider = "graphene-hardened";
  };

  security = {
    apparmor = {
      enableCache = true;
      enable = true; # Enable AppArmor for mandatory access control
    };

    chromiumSuidSandbox.enable = true; # Enable sandboxing for Chromium
    rtkit.enable = true; # Enable real-time policy and watchdog

    protectKernelImage = true; # Protect the kernel image from being modified
    lockKernelModules = false; # Set to true to lock kernel modules (requires specifying all modules)
    allowUserNamespaces = true; # Allow user namespaces for unprivileged containers
    forcePageTableIsolation = true; # Mitigate Spectre variant 2 vulnerabilities
    polkit.enable = true;

    sudo.enable = false; # Disable sudo
    doas.enable = true; # Use doas instead of sudo
    doas.extraRules = [{
      users = [ "gaymer" ]; # Allow doas for specified users
      keepEnv = true; # Preserve environment variables
      persist = true; # Keep authentication for a session
    }];
    auditd = {
      enable = true;
    };
  };

  # Hardware Configuration
  hardware.cpu.amd.updateMicrocode = true; # Update AMD CPU microcode for security fixes

  # Nix Configuration
  nix = {
    extraOptions = ''
      allowed-users = root @wheel       # Restrict Nix access to root and wheel group
    '';
    settings.trusted-users = [ "root" "@wheel" ];
  };
  # Systemd Configuration
  systemd = {
    coredump.enable = false; # Disable coredump handling
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  environment.shellInit = ''
    umask 0077                        # Restrict default file permissions to rwx------
  '';

  # Services Configuration
  services = {
    clamav = {
      daemon.enable = true; # Enable ClamAV antivirus daemon
      updater.enable = true; # Enable ClamAV automatic updates
    };
    opensnitch.enable = true; # Enable OpenSnitch application firewall
    syslogd = {
      enable = true; # Enable syslog daemon for logging
      extraConfig = ''
        *.*  -/var/log/syslog         # Log all events to /var/log/syslog
      '';
    };
    journald.forwardToSyslog = true; # Forward journal logs to syslog
    openssh.enable = false; # Disable OpenSSH server for remote access
    dbus.apparmor = "enabled"; # Enable AppArmor for D-Bus
  };

  virtualisation.libvirtd.enable = true;

  networking.firewall = {
    enable = true;
    filterForward = false;
    rejectPackets = true;
    logRefusedPackets = true;
    allowPing = false;

    allowedTCPPorts = [
      #22 # SSH
      80 # HTTP
      443 # HTTPS
      25565 # Minecraft
      3478 # Easy Anti-Cheat UDP ports (STUN/TURN)
      3479 # Easy Anti-Cheat UDP ports (STUN/TURN)
      3658 # Easy Anti-Cheat voice and game traffic
    ];

    allowedUDPPorts = [
      1194 # OpenVPN
      51820 # WireGuard
      80 # Easy Anti-Cheat HTTP
      123 # NTP for EAC
      3478 # Easy Anti-Cheat UDP ports (STUN/TURN)
      3479 # Easy Anti-Cheat UDP ports (STUN/TURN)
      3658 # Easy Anti-Cheat voice and game traffic
      5060 # Easy Anti-Cheat voice traffic
      5062 # Easy Anti-Cheat voice traffic
    ];

    allowedTCPPortRanges = [
      { from = 27015; to = 27030; } # Steam gaming ports
      { from = 27036; to = 27037; } # Steam client
    ];

    allowedUDPPortRanges = [
      { from = 4380; to = 4380; } # Steam P2P
      { from = 27000; to = 27031; } # Steam gaming and voice
      { from = 6000; to = 6060; } # VNC/Easy Anti-Cheat traffic
    ];

    # Define rules for specific interfaces if needed (e.g., VPN or LAN)
    interfaces = {
      "eth0" = {
        allowedTCPPorts = [ 22 443 ]; # Example for eth0 interface
        allowedUDPPorts = [ 1194 ]; # Example for eth0 interface
      };
    };

    # Extra rules for better control
    extraInputRules = ''
      # Allow loopback interface
      iptables -A INPUT -i lo -j ACCEPT

      # Allow related and established connections
      iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

      # Drop invalid packets
      iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

      # Allow traffic for libvirt virtual machines (e.g., QEMU/KVM)
      iptables -A INPUT -p tcp --dport 16509 -j ACCEPT
      iptables -A INPUT -p tcp --dport 5900:6000 -j ACCEPT # VNC access for virtual machines
    '';

    # Additional security options
    autoLoadConntrackHelpers = false; # Disable automatic loading of conntrack helpers for extra security
  };


}
