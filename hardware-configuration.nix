# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.

# NB: I modified this file.

{ config, lib, pkgs, ... }:

{
  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot = {
    initrd = {
      luks.devices = {
        root = {
          device = "/dev/disk/by-uuid/d7fd1b5b-114e-4b0c-9a8b-7a0879bfcda6";
          preLVM = true;
          allowDiscards = true;
        };
      };
      availableKernelModules = [ "xhci_pci" "nvme" ];
      kernelModules = [ "i915" ];
    };
    # kernelParams = [ "intel_pstate=no_hwp" ];
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/77d1f9e5-752b-41b7-87f6-953428e601a7";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" "discard" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/1086-34A3";
      fsType = "vfat";
    };

  swapDevices =
    [
      {
        device = "/dev/disk/by-uuid/c952b234-9395-4e76-ae34-5e8768995d63";
      }
    ];

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    enableAllFirmware = true;
    cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  services.throttled.enable = lib.mkDefault true;

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # High-DPI console
  console.font = lib.mkDefault
    "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
