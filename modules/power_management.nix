{ pkgs, config, lib }:

{
  services = {
    # Power management services
    auto-cpufreq = {
      enable = true;
      settings.battery = {
        scaling_max_freq = 1600000; # Max frequency for battery mode (1.6GHz)
        turbo = "auto";
        start_threshold = 70; # Start scaling when battery is below 70%
      };
    };

    # Disable power profiles daemon
    power-profiles-daemon.enable = false;

    thermald.enable = true; # Enable thermal management

  };

}
