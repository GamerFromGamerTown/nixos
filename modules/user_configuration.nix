{ config, pkgs, ... }:

{
  # User and Group Configuration
  users = {
    # Set default shell for all users
    defaultUserShell = pkgs.zsh;

    # Disable mutable users to prevent modifications outside Nix configuration
    mutableUsers = false;

    # Define the group "gaymer"
    groups.gaymer = {
      name = "gaymer";
      gid = 69420;
    };

    # Define the user account "gaymer"
    users.gaymer = {
      isNormalUser = true;
      description = "It's gayming time.";
      home = "/home/gaymer";
      shell = pkgs.zsh;
      #      hashedPassword = "XXXXX" # specified in /etc/nixos/modules/GaymerPasswd.nix
      linger = true; # Allow user services to continue running when logged out

      # User group memberships
      extraGroups = [
        "gaymer"
        "audio"
        "libvirt"
        "networkmanager"
        "sshd"
        "video"
        "wheel"
      ];

      # Packages available for this user
      packages = with pkgs; [
        kdePackages.kate
        sl
        zsh
      ];
    };
  };

  # Define groups
  users.groups.libvirt = { }; # Create "libvirt" group if not already defined
}
