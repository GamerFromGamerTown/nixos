{ config, lib, pkgs, ... }:

{
  # Enable Bluetooth (KDE's Bluetooth daemon should handle this)
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false; # Do not power on Bluetooth at boot
  };

  # Service to run the Bluetooth power-saving commands
  systemd.services.bluetooth-power-save = {
    description = "Bluetooth Power Save Service";
    serviceConfig = {
      ExecStart = ''
        # Check if on battery power
        if [ "$(cat /sys/class/power_supply/AC/online)" -eq 0 ]; then
          # Set Bluetooth to low power mode
          hciconfig hci0 lp
          
          # Disable discoverability and scanning to save power
          bluetoothctl discoverable off
          bluetoothctl scan off
        fi
      '';
      Type = "oneshot"; # The service runs once and then exits
    };
  };

  # Timer to run the service every 20 minutes
  systemd.timers.bluetooth-power-save-timer = {
    description = "Bluetooth Power Save Timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*/20:00"; # Every 20 minutes
      Persistent = true; # Ensure the timer runs even if the system was off
    };
  };

}
