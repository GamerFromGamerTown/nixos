{ config, pkgs, ... }:

{
  networking = {
    hostName = "nixywixy"; # Define the hostname.

    # Configure DNS
    nameservers = [ "149.112.112.112" "1.0.0.1" ];
    enableIPv6 = true; # Enable IPv6
    stevenblack.enable = true;
    wireguard.enable = true;
    # Enable NetworkManager for managing network connections
    networkmanager = {
      enable = true;
      wifi.powersave = true;
      # Enable MAC address randomization during WiFi scanning
      wifi.scanRandMacAddress = true;
    };
  };

  # Set a custom machine ID
  environment.etc."machine-id".text = "b08dfa6083e7567a1921a715000001fb";

  # Use Unbound as a local DNS resolver for better performance and privacy
  #services.unbound = {

  #  enable = true;
  #  settings = {
  #    interface = [ "127.0.0.1" ]; # Should be a list of interfaces
  #    port = 53; # Port should be an integer
  #    access-control = [ "127.0.0.1/8 allow" "::1/128 allow" ]; # List of access controls
  #    cache-size = "100m"; # Cache size should remain a string
  #    prefetch = true;     # Boolean instead of "yes"
  #    num-threads = 2;     # Integer instead of string
  #    harden-short-bufsize = true; # Boolean instead of "yes"
  #    harden-large-queries = true; # Boolean instead of "yes"
  #  };
  #};

  # Enable and configure systemd-resolved for DNS caching and stub resolution
  services.resolved.enable = true;

  # Configure MAC address spoofing using macchanger
  #  systemd.services.macchanger = {
  #    description = "macchanger on wlp2s0";
  #    wants = [ "network-pre.target" ];
  #    before = [ "network-pre.target" ];
  #    after = [ "sys-subsystem-net-devices-wlp2s0.device" ];

  #    serviceConfig = {
  #      ExecStart = "${pkgs.macchanger}/bin/macchanger -e wlp2s0";
  #      Type = "oneshot";
  #    };

  #    wantedBy = [ "multi-user.target" ];
  #  };

}
