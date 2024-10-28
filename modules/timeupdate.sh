{ pkgs, config, lib, ...  }:

{
  # Enable cron service
  services.cron = {
    enable = true;
    jobs = [
      {
        # Run the secure time sync script every 2 hours
        expression = "0 */2 * * *";
        command = "/etc/nixos/modules/scripts/timeupdate.sh";
        user = "root"; # Run as root to allow setting the system time
      }
    ];
  };

  # Disable insecure time sync services
  services.systemd-timesyncd.enable = false;

  # Ensure the secure time sync script is in place
  environment.etc."secure-time-sync.sh".source = /etc/nixos/modules/scripts/timeupdate.sh;

  nixpkgs.config.packageOverrides = pkgs: {
  ntp = null;
  openntpd = null;
  chrony = null;
};

}
