{ config, pkgs, lib, ... }:

{
  # User Configuration for Services
  users.groups = {
    sshd = { };
    syslog = { };
    thermald = { };
    virtlockd = { };
    virtlogd = { };
    virtlxcd = { };
  };

  users.users = {
    sshd = {
      isSystemUser = true;
      group = "sshd";
      uid = 1001;
      shell = "/run/current-system/sw/bin/nologin";
    };
    syslog = {
      isSystemUser = true;
      description = "User for Syslog Service";
      group = "syslog";
      uid = 1002;
      shell = "/run/current-system/sw/bin/nologin";
    };
    thermald = {
      isSystemUser = true;
      description = "User for Thermald Service";
      group = "thermald";
      uid = 1003;
      shell = "/run/current-system/sw/bin/nologin";
    };
    virtlockd = {
      isSystemUser = true;
      description = "User for Virtlockd Service";
      group = "virtlockd";
      uid = 1004;
      shell = "/run/current-system/sw/bin/nologin";
    };
    virtlogd = {
      isSystemUser = true;
      description = "User for Virtlogd Service";
      group = "virtlogd";
      uid = 1005;
      shell = "/run/current-system/sw/bin/nologin";
    };
    virtlxcd = {
      isSystemUser = true;
      description = "User for Virtlxcd Service";
      group = "virtlxcd";
      uid = 1006;
      shell = "/run/current-system/sw/bin/nologin";
    };
  };
}
