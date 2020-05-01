# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
 imports =
   [
     # Include the results of the hardware scan.
     ./hardware-configuration.nix
     <home-manager/nixos>
   ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = (import <nixos-unstable> {}).linuxPackages_latest;
  };
  
  networking = {
    hostName = "nixthinkpad"; # Define your hostname.
    networkmanager.enable = true;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
    
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];

    # default value
    firewall.enable = true;
  };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # for things like spotify
  nixpkgs.config.allowUnfree = true;

  # backlight
  programs.light.enable = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    let unstable = import <nixos-unstable> {};
    in with pkgs; [
      unstable.home-manager     # personal config
      nitrogen                  # wallpaper
      lxqt.pavucontrol-qt       # pulseaudio control
      xbindkeys                 # keybindings
    ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # avahi for DNS discovery
  services.avahi = {
    enable = true;
    nssmdns = true;             # local hostname resolution for apps
  };
  
  # Enable  CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };
  
  # xserver config
  services.xserver = {
    # x11
    enable = true;
    xkbOptions = "eurosign:e";
    dpi = 145;
    
    # touchpad support
    libinput = {
      enable = true;
      naturalScrolling = true;
      tapping = false;
    };

    # wm
    windowManager.default = "xmonad";
    desktopManager.default = "none";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
      config = programs/xmonad/xmonad.hs;   
    };

    # auto-login
    displayManager = {
      lightdm.autoLogin = {
        enable = true;
        user = "juliangrove";
      };
      sessionCommands = "xbindkeys";
    };
  };

  # fonts
  fonts = {
    fontconfig.dpi = 145;
    fonts = with pkgs; [                  
      font-awesome_4
      lohit-fonts.kannada
    ];
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.juliangrove = {
    description = "Julian Grove";
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "audio" "video" "cups" ]; # stuff I can do
  };

  # some extra hardware management
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    package = pkgs.bluezFull;
  };

  services.blueman.enable = true;
  
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
