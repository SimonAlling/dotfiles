# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/793f9f05-513e-4fe2-a95d-7e8e2cd5ba02";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/EEFE-D155";
      fsType = "vfat";
    };

  fileSystems."/ztorage" =
    { device = "ztorage";
      fsType = "zfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/fe507f9f-d21c-4346-b056-9f81bd75f193"; }
    ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = "powersave";
}