{ config, pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    extraConfig = ''
      unix_sock_group = "libvirt"
      unix_sock_rw_perms = "0770"
    '';
  };

  # Ensure libvirtd service has necessary capabilities
  systemd.services.libvirtd.serviceConfig = {
    AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_RAW";
  };

}
