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
    let
      unstable = import <nixos-unstable> {};
    in with pkgs; [
      unstable.home-manager # personal config
      nitrogen # wallpaper
      lxqt.pavucontrol-qt # pulseaudio control
      xbindkeys # keybindings
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # systemd services
  services = {
    # avahi for DNS discovery
    avahi = {
      enable = true;
      nssmdns = true; # local hostname resolution for apps
    };

    # Enable  CUPS to print documents.
    printing.enable = true;

    # xserver config
    xserver = {
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
        sessionCommands = ''
          nitrogen --restore
          xbindkeys &
          systemctl --user restart emacs # keep having to do this for some reason
        '';
      };

      # screen-locker
      xautolock = {
        enable = true;
        locker = ''${pkgs.writeShellScript "lock-screen-i3lock-fancy-rapid" ''
          ~/.nix-profile/bin/i3lock-fancy-rapid 40 10 -n \
          --insidecolor=1d202180 \
          --ringcolor=b8bb2680 \
          --keyhlcolor=fabd2f80 \
          --bshlcolor=cc241dff \
          --linecolor=282828ff \
          --insidevercolor=83a5984d \
          --ringvercolor=45858880 \
          --insidewrongcolor=cc241d80 \
          --ringwrongcolor=fb493480
        ''}'';
        time = 3;
        extraOptions = [ "-corners" "00-0" ];
      };
    };

    blueman.enable = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };

  # fonts
  fonts = {
    fontconfig.dpi = 145;
    fonts = with pkgs; [
      emacs-all-the-icons-fonts
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

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = " 19.09 "; # Did you read the comment?
}
