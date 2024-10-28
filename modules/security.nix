{ config, pkgs, ... }:

{
  # Security Configuration

  environment.variables.LD_PRELOAD = "/nix/store/xas37drcjyxklrkw533abp5a6ld6b59v-graphene-hardened-malloc-2024040900/lib/libhardened_malloc.so";

  security = {
    apparmor.enable = true; # Enable AppArmor for mandatory access control
    chromiumSuidSandbox.enable = true; # Enable sandboxing for Chromium
    rtkit.enable = true; # Enable real-time policy and watchdog
    polkit.enable = true; # Enable Polkit for privilege management

    protectKernelImage = true; # Protect the kernel image from being modified
    lockKernelModules = false; # Set to true to lock kernel modules (requires specifying all modules)
    allowUserNamespaces = true; # Allow user namespaces for unprivileged containers
    forcePageTableIsolation = true; # Mitigate Spectre variant 2 vulnerabilities

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
  systemd.coredump.enable = false; # Disable coredump handling
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
    openssh.enable = true; # Enable OpenSSH server for remote access
    dbus.apparmor = "enabled"; # Enable AppArmor for D-Bus
  };

  # Virtualization Configuration
  virtualisation.libvirtd.enable = true; # Enable libvirt for virtualization management

  networking.firewall = {
    enable = true; # Enable the firewall
    filterForward = false; # Block forwarding packets unless explicitly allowed
    rejectPackets = true; # Reject all incoming packets by default
    logRefusedPackets = true; # Log refused packets for visibility
    allowPing = false; # Deny ICMP/ping requests by default (can be set to true if you want to allow ping)

    # Define trusted interfaces if there are any (e.g., VPN interfaces)
    trustedInterfaces = [ ];

    # Defining allowed TCP and UDP ports for specific services and applications
    allowedTCPPorts = [
      22      # SSH - allow remote administration if needed (consider restricting to specific IPs)
      80      # HTTP - for web browsing
      443     # HTTPS - for secure web browsing
      25565   # Minecraft server default port
    ];

    allowedUDPPorts = [
      1194    # OpenVPN for VPN connectivity
      51820   # WireGuard for VPN connectivity
    ];

    # Specific allowed port ranges if necessary (e.g., for virtual machines or Steam)
    allowedTCPPortRanges = [
      { from = 27015; to = 27030; } # Steam gaming ports
      { from = 27036; to = 27037; } # Steam client
    ];

    allowedUDPPortRanges = [
      { from = 4380; to = 4380; }    # Steam P2P
      { from = 27000; to = 27031; }  # Steam gaming and voice
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
