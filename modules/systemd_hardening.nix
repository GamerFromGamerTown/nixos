{ config, pkgs, lib, ... }:

{
  # Systemd Services Configuration
  systemd.services = {
    # OpenSSH service with security-hardening options
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = "no";
        ChallengeResponseAuthentication = "no";
        UsePAM = "yes";
        AllowAgentForwarding = "no";
        AllowTcpForwarding = "no";
        X11Forwarding = "no";
        PrintMotd = "no";
        MaxAuthTries = "3";
        PermitEmptyPasswords = "no";
        LogLevel = "VERBOSE";
        Ciphers = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com";
        MACs = "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com";
      };
      serviceConfig = {
        User = "sshd";
        CapabilityBoundingSet = "-CAP_SYS_ADMIN -CAP_SYS_PTRACE -CAP_SYS_MODULE -CAP_NET_ADMIN -CAP_SYS_TIME";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectClock = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = "~AF_INET ~AF_INET6";
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateNetwork = true;
        PrivateUsers = true;
        LockPersonality = true;
        SystemCallFilter = "@default @privileged @reboot @module @swap @obsolete";
        SystemCallArchitectures = "native";
        UMask = "0077";
        ReadOnlyPaths = [ "/etc" ];
        ReadWritePaths = [ "/var" ];
        ProtectProc = "invisible";
        ProcSubset = "pid";
      };
    };

    # Syslog service with hardening
    syslog = {
      serviceConfig = {
        User = "syslog";
        PrivateNetwork = true;
        CapabilityBoundingSet = [ "CAP_DAC_READ_SEARCH" "CAP_SYSLOG" "CAP_NET_BIND_SERVICE" ];
        NoNewPrivileges = true;
        PrivateDevices = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        PrivateMounts = true;
        SystemCallArchitectures = "native";
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        ProtectKernelTunables = true;
        RestrictRealtime = true;
        PrivateUsers = true;
        PrivateTmp = true;
        UMask = "0077";
        ProtectHome = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "full";
      };
    };

    # Systemd journald hardening
    systemd-journald = {
      serviceConfig = {
        UMask = "0077";
        PrivateNetwork = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
      };
    };

    # CPU Frequency Manager Service
    auto-cpufreq = {
      serviceConfig = {
        CapabilityBoundingSet = "";
        ProtectSystem = "full";
        ProtectHome = true;
        PrivateNetwork = true;
        IPAddressDeny = "any";
        NoNewPrivileges = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectClock = true;
        MemoryDenyWriteExecute = true;
        RestrictNamespaces = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectProc = true;
        ReadOnlyPaths = [ "/" ];
        InaccessiblePaths = [ "/home" "/root" "/proc" ];
        SystemCallFilter = [ "@system-service" ];
        SystemCallArchitectures = "native";
        UMask = "0077";
      };
    };

    # Thermald Service Configuration
    thermald = {
      serviceConfig = {
        User = "thermald";
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        PrivateTmp = true;
        PrivateUsers = true;
        PrivateDevices = true;
        PrivateIPC = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        CapabilityBoundingSet = "";
        RestrictNamespaces = true;
        SystemCallFilter = [ "@system-service" ];
        SystemCallArchitectures = "native";
        UMask = "0077";
        IPAddressDeny = "any";
        DeviceAllow = [ ];
        RestrictAddressFamilies = [ ];
      };
    };

    # Display Manager Service
    display-manager = {
      serviceConfig = {
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        UMask = "0077";
      };
    };

    # Emergency Service Configuration
    emergency = {
      serviceConfig = {
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        PrivateTmp = true;
        PrivateUsers = true;
        PrivateDevices = true;
        PrivateIPC = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
        SystemCallFilter = [ "write" "read" "openat" "close" "brk" "fstat" "lseek" "mmap" "mprotect" "munmap" "rt_sigaction" "rt_sigprocmask" "ioctl" "nanosleep" "select" "access" "execve" "getuid" "arch_prctl" "set_tid_address" "set_robust_list" "prlimit64" "pread64" "getrandom" ];
        SystemCallArchitectures = "native";
        UMask = "0077";
        IPAddressDeny = "any";
      };
    };

    # Nixos Rebuild Switch Configuration
    "nixos-rebuild-switch-to-configuration" = {
      serviceConfig = {
        ProtectHome = true;
        NoNewPrivileges = true;
        UMask = "0077";
      };
    };

    # Systemd Ask Password Console
    "systemd-ask-password-console" = {
      serviceConfig = {
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        PrivateTmp = true;
        PrivateUsers = true;
        PrivateDevices = true;
        PrivateIPC = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
        SystemCallFilter = [ "@system-service" ];
        SystemCallArchitectures = "native";
        UMask = "0077";
        IPAddressDeny = "any";
      };
    };

    # Virtlockd and Virtlogd Configuration
    virtlockd = {
      serviceConfig = {
        User = "virtlockd";
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        PrivateTmp = true;
        PrivateUsers = true;
        PrivateDevices = true;
        PrivateIPC = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
        SystemCallFilter = [ "@system-service" ];
        SystemCallArchitectures = "native";
        UMask = "0077";
        IPAddressDeny = "any";
      };
    };

    virtlogd = {
      serviceConfig = inherit (systemd.services.virtlockd.serviceConfig) {
        User = "virtlogd";
      };
    };

    virtlxcd = {
      serviceConfig = {
        User = "virtlxcd";
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        PrivateTmp = true;
        PrivateUsers = true;
        PrivateDevices = true;
        PrivateIPC = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = "AF_INET AF_INET6";
        RestrictNamespaces = true;
        SystemCallFilter = [ "@system-service" ];
        SystemCallArchitectures = "native";
        UMask = "0077";
        IPAddressDeny = "any";
      };
    };
  };
}
