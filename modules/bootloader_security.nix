{ config, pkgs, ... }:
{

# TODO
# 1) Make boot readonly [easy]
# 2) Try to use linux-hardened if it boots [easy]
# 3) Better AuditD rules [medium]
# 4) Block known-malicious IPs via the firewall. [easy i'd assume]
# 5) Actually use bubblewrap. [hard]
# 6) *Maybe* set security.seccomp.enable = true, figure out what it does [easy]
# 7) Try the LKRG [Linux Kernel Runtime Guard] [easy once package works]
# 8) Try to do full disc encryption via the TPM, so in conjunction with classical it will be (functionally) impossible to modify /boot. [hard]
# 9) Apparmor [very hard]
# 10) Why is net.ipv4.conf.all.forwarding on despite it being shut off?

  boot = {
    # Kernel Modules and Filesystems
    kernelModules = [
      "acct"
      "apparmor"
      "btrfs"
      "bridge"
      "coretemp"
      "e100e"
      "ehci_pci"
      "exfat"
      "ext4"
      "f2fs"
      "hid_generic"
      "iwlwifi"
      "kvm"
      "kvm-amd"
      "ntfs"
      "usbhid"
      "vfat"
      "xhci_pci"
    ];
    supportedFilesystems = [ "ntfs" ];
    # kernelPackages = pkgs.linuxPackages_hardened; # Bricks boot
    # extraModulePackages = [ pkgs.linuxKernel.packages.linux_6_6.lkrg ]; # Broken Package
    
    # Kernel Parameters
    kernelParams = [
      "slab_nomerge"
      "init_on_alloc=1"
      "init_on_free=1"
      "page_alloc.shuffle=1"
      "pti=on"
      "vsyscall=none"
      "debugfs=off"
      "oops=panic"
      "module.sig_enforce=1"
      "lockdown=off"
      "mce=0"
      "quiet"
      "loglevel=2"
      "ipv6.disable=0"
      "spectre_v2=on"
      "spec_store_bypass_disable=on"
      # "l1tf=full,force" "tsx=off" "tsx_async_abort=full,nosmt" # Optional settings
      "kvm.nx_huge_pages=force" # May increase memory usage, especially with hypervisors
      "amdgpu.aspm=1" 
      "pcie_aspm=force"
    
    ];

    # Systemd Boot Hardening
    # Uncomment these options if needed for systemd-boot hardening
  };

  # File Systems Configuration
  fileSystems."/proc" = {
    fsType = "proc";
    device = "proc";
    options = [ "nosuid" "nodev" "noexec" "hidepid=2" ];
    neededForBoot = true;
  };

  # Restrict Access to Process Lists
  users.groups.proc = { };
  systemd.services.systemd-logind.serviceConfig.SupplementaryGroups = [ "proc" ];

  # Blacklist Kernel Modules
  boot.blacklistedKernelModules = [
    "dccp"
    "sctp"
    "rds"
    "tipc"
    "n-hdlc"
    "ax25"
    "netrom"
    "x25"
    "rose"
    "decnet"
    "econet"
    "af_802154"
    "ipx"
    "appletalk"
    "psnap"
    "p8023"
    "p8022"
    "can"
    "atm"
    "cramfs"
    "freevxfs"
    "jffs2"
    "hfs"
    "hfsplus"
    "udf"
    "vivid"
    "thunderbolt"
    "firewire-core"
  ];

  # Sysctl Configuration
  boot.kernel.sysctl = {
    # Network Settings
    "net.ipv4.icmp_ratelimit" = "500";  # Control ICMP rate limit
    "net.ipv4.tcp_timestamps" = "0";
    "net.core.netdev_max_backlog" = "250000";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.ip_forward" = "1";
    "net.ipv4.tcp_syncookies" = "1";
    "net.ipv4.conf.default.send_redirects" = "0";
    "net.ipv4.conf.all.send_redirects" = "0";
    "net.ipv4.conf.default.accept_source_route" = "0";
    "net.ipv4.conf.all.accept_source_route" = "0";
    "net.ipv4.conf.default.rp_filter" = "1";
    "net.ipv4.conf.all.rp_filter" = "1";
    "net.ipv4.conf.default.log_martians" = "1";
    "net.ipv4.conf.all.log_martians" = "1";
    "net.ipv4.conf.default.accept_redirects" = "0";
    "net.ipv4.conf.all.accept_redirects" = "0";
    "net.ipv4.conf.default.shared_media" = "0";
    "net.ipv4.conf.all.shared_media" = "0";
    "net.ipv4.conf.default.arp_announce" = "2";
    "net.ipv4.conf.all.arp_announce" = "2";
    "net.ipv4.conf.default.arp_ignore" = "1";
    "net.ipv4.conf.all.arp_ignore" = "1";
    "net.ipv4.conf.default.drop_gratuitous_arp" = "1";
    "net.ipv4.conf.all.drop_gratuitous_arp" = "1";
    "net.ipv4.icmp_echo_ignore_broadcasts" = "1";
    "net.ipv4.icmp_ignore_bogus_error_responses" = "1";
    "net.ipv4.tcp_rfc1337" = "1";
    "net.ipv4.ip_local_port_range" = "1024 65535";
    "net.ipv4.tcp_sack" = "0";
    "net.ipv4.tcp_dsack" = "0";
    "net.ipv4.tcp_fack" = "0";
    "net.ipv4.tcp_adv_win_scale" = "1";
    "net.ipv4.tcp_mtu_probing" = "1";
    "net.ipv4.tcp_base_mss" = "1024";
    "net.ipv4.tcp_rmem" = "4096 87380 8388608";
    "net.ipv4.tcp_wmem" = "4096 87380 8388608";
    "net.ipv4.conf.all.forwarding" = "0";

    # IPv6 Settings
    "net.ipv6.conf.default.forwarding" = "0";
    "net.ipv6.conf.all.forwarding" = "0";
    "net.ipv6.conf.default.router_solicitations" = "0";
    "net.ipv6.conf.all.router_solicitations" = "0";
    "net.ipv6.conf.default.accept_ra_rtr_pref" = "0";
    "net.ipv6.conf.all.accept_ra_rtr_pref" = "0";
    "net.ipv6.conf.default.accept_ra_pinfo" = "0";
    "net.ipv6.conf.all.accept_ra_pinfo" = "0";
    "net.ipv6.conf.default.accept_ra_defrtr" = "0";
    "net.ipv6.conf.all.accept_ra_defrtr" = "0";
    "net.ipv6.conf.default.autoconf" = "0";
    "net.ipv6.conf.all.autoconf" = "0";
    "net.ipv6.conf.default.dad_transmits" = "0";
    "net.ipv6.conf.all.dad_transmits" = "0";
    "net.ipv6.conf.default.max_addresses" = "1";
    "net.ipv6.conf.all.max_addresses" = "1";
    "net.ipv6.conf.all.use_tempaddr" = "2";
    "net.ipv6.conf.default.accept_redirects" = "0";
    "net.ipv6.conf.all.accept_redirects" = "0";
    "net.ipv6.conf.default.accept_source_route" = "0";
    "net.ipv6.conf.all.accept_source_route" = "0";
    "net.ipv6.icmp.echo_ignore_all" = "1";
    "net.ipv6.icmp.echo_ignore_anycast" = "1";
    "net.ipv6.icmp.echo_ignore_multicast" = "1";
    "net.ipv6.conf.all.disable_ipv6" = "1";
    "net.ipv6.conf.default.disable_ipv6" = "1";
    "net.ipv6.conf.lo.disable_ipv6" = "1";

    # Kernel Settings
    "kernel.randomize_va_space" = "2";
    "kernel.sysrq" = "0";
    "kernel.core_uses_pid" = "1";
    "kernel.kptr_restrict" = "2";
    "kernel.yama.ptrace_scope" = "1"; # CHANGE TO 2 OR 3 ONCE DONE DEBUGGING, DANGEROUS TO HAVE @ 1 FOR SANDBOXING
    "kernel.dmesg_restrict" = "1";
    "kernel.printk" = "3 3 3 3";
    "kernel.unprivileged_bpf_disabled" = "1";
    "kernel.kexec_load_disabled" = "1";
    "kernel.unprivileged_userns_clone" = "1";
    "kernel.pid_max" = "32768";
    "kernel.panic" = "20";
    "kernel.perf_event_paranoid" = "3";
    "kernel.perf_cpu_time_max_percent" = "1";
    "kernel.perf_event_max_sample_rate" = "1";
    # "kernel.modules_disabled" = "1";
    "kernel.core_pattern" = "|/bin/false";

    # File System Settings
    "fs.suid_dumpable" = "0";
    "fs.protected_hardlinks" = "1";
    "fs.protected_symlinks" = "1";
    "fs.protected_fifos" = "2";
    "fs.protected_regular" = "2";
    "fs.file-max" = "9223372036854775807";
    "fs.inotify.max_user_watches" = "524288";

    # Virtualization Settings
    "vm.mmap_min_addr" = "65536";
    "vm.mmap_rnd_bits" = "32";
    "vm.mmap_rnd_compat_bits" = "16";
    "vm.unprivileged_userfaultfd" = "0";

    # Miscellaneous Settings
    "dev.tty.ldisc_autoload" = "0";
  };

  # Modprobe Configuration
  boot.extraModprobeConfig = ''
    options msr allow_writes=1
  '';
}
