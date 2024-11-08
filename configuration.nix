{ config, pkgs, ... }:

# Simplfy to only imports.

let
  # Define local variables using let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
    sha256 = "sha256:00wp0s9b5nm5rsbwpc1wzfrkyxxmqjwsc1kcibjdbfkh69arcpsn";
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      dates = "weekly";
    };
  };
  
in
{
  imports = [
    ./hardware-configuration.nix
    ./modules/bootloader_configuration.nix
    ./modules/bootloader_security.nix
    ./modules/localisation_configuration.nix
    ./modules/network_configuration.nix
    ./modules/security.nix
    ./modules/services_configuration.nix
    ./modules/software_configuration.nix
    ./modules/user_configuration.nix
    ./modules/libvirt.nix
    ./modules/fonts.nix
    ./modules/secrets/GaymerPasswd.nix
    ./modules/secrets/vpnconfig.nix
    ./modules/aa-profiles/aa-profiles.nix
    # ./modules/systemd_hardening.nix
    ./modules/system_users.nix
    "${home-manager}/nixos" # Correct reference to home-manager fetched tarball
    <catppuccin/modules/nixos>
  ];

  time.timeZone = "US/Alaska";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "unstable";
}
