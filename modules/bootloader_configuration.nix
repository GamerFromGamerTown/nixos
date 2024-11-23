{ config, pkgs, lib, ... }:

{
  # Bootloader Configuration
  boot.loader = {
    grub = {
      enable = true;
      backgroundColor = "#11111b";
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;
      gfxmodeBios = "auto";
      splashImage = lib.mkForce "/boot/splash-images/nixos-splash.png"; # Force setting splash image
      theme = lib.mkDefault "${pkgs.sleek-grub-theme}/share/grub/themes/sleek"; # Path to the theme directory
      useOSProber = true;
#     extraFiles = "" # Try to use this to copy stuff like password files or fonts when you have time.      
    };

    efi.canTouchEfiVariables = true; # Allow modifying UEFI variables
    systemd-boot.enable = false;
  };

  # Kernel Parameters
  boot.kernelParams = [
    "amd_pstate=passive" # Choose either active or passive; passive is recommended for laptops
    "amdgpu.dc=1" # Enables the AMDGPU display core for better display support
    "quiet" # Reduces boot-time messages
    "splash" # Enables a splash screen during boot
    "amd_iommu=on" # Enables IOMMU for better device isolation
    "iommu=pt" # Uses pass-through mode for IOMMU to reduce overhead
    "apparmor=1" # Enables AppArmor for security
    "security=apparmor" # ^
    "slub_debug=FZP" # Enables additional memory allocator debugging
    "processor.max_cstate=5" # Limits C-states to improve performance
    "tcp_fastopen=1" # Enables TCP Fast Open for faster connections
    "amdgpu.ppfeaturemask=0xffffffff" # Unlocks all AMD GPU power management features
    "rcu_nocbs=0-1" # Offloads RCU callbacks from the first two cores
    "video=1920x1080"
    "amdgpu.dpm=1" # Enables dynamic power management
    "amdgpu.runpm=1"  # Enables runtime power management" 
    "acpi_cpufreq"
    "hp-wmi"
  ];


  # Hostname Configuration
  networking.hostName = "nixywixy"; # Set the hostname for the system
  

  #fileSystems."/home/gaymer/.games" = {
  #  device = "/dev/sda2";
  #  fsType = "ext4";
  #  options = [ "noatime" "discard" "defaults" ];
  #};

  # Define a systemd service to change ownership after mounting
  #systemd.services.chownGamesDirectory = {
  #  description = "Chown /home/gaymer/.games to gaymer after mounting";
  #  after = [ "home-gaymer-.games.mount" ];
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig.ExecStart = [ "${pkgs.coreutils}/bin/chown -R gaymer:gaymer /home/gaymer/.games" ];
  #  serviceConfig.Type = "oneshot";
  #  serviceConfig.RemainAfterExit = true;
  #};

}


