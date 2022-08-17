{ config, pkgs, lib, ... }:

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
    kernelPackages = pkgs.linuxPackages_latest;
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

  # nix = {
  # package = pkgs.nixUnstable;
  # extraOptions = ''
  # experimental-features = nix-command flakes
  # '';
  # };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "America/New_York";
  time.timeZone = "Europe/Stockholm";
  # time.timeZone = "Europe/London";

  # for things like spotify
  nixpkgs.config.allowUnfree = true;

  # backlight
  programs.light.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    let
      unstable = import <nixos-unstable> { };
    in
    with pkgs; [
      unstable.home-manager # personal config
      nitrogen # wallpaper
      lxqt.pavucontrol-qt # pulseaudio control
      xbindkeys # keybindings
      haskellPackages.xmobar # status bar
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

    geoclue2 = {
      enable = true;
      enableWifi = true;
    };

    # Enable  CUPS to print documents.
    printing = {
      enable = true;
      drivers = with pkgs; [
        brlaser
      ];
    };

    # xserver config
    xserver = {
      # x11
      enable = true;
      xkbOptions = "eurosign:e";
      dpi = 145;

      # touchpad support
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
          tapping = false;
        };
      };

      # wm
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
        autoLogin = {
          enable = true;
          user = "juliangrove";
        };

        defaultSession = "none+xmonad";

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
          --inside-color=1d202180 \
          --ring-color=b8bb2680 \
          --keyhl-color=fabd2f80 \
          --bshl-color=cc241dff \
          --line-color=282828ff \
          --insidever-color=83a5984d \
          --ringver-color=45858880 \
          --insidewrong-color=cc241d80 \
          --ringwrong-color=fb493480
        ''}'';
        time = 3;
        extraOptions = [ "-corners" "00-0" ];
      };
    };

    picom = {
      enable = true;
      backend = "glx";
      vSync = true; # to prevent tearing
      shadow = true;
      shadowExclude = [ "name = 'xmobar'" ];
    };

    blueman.enable = true;
  };

  # Enable sound.
  sound.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
      powerOnBoot = false;
      settings.General.ControllerMode = "bredr";
    };

    pulseaudio = {
      enable = true;
      extraConfig = ''
        load-module module-alsa-sink   device=hw:0,0 channels=4
        load-module module-alsa-source device=hw:0,6 channels=4
      '';
      package = pkgs.pulseaudioFull;
      support32Bit = true;
      systemWide = false;
    };
  };

  # fonts
  fonts = {
    fonts = with pkgs; [
      aegyptus
      akkadian
      corefonts
      emacs-all-the-icons-fonts
      font-awesome
      ipafont
      kochi-substitute
      lohit-fonts.kannada
      powerline-fonts
      source-han-sans-korean
      source-han-sans-simplified-chinese
      source-han-sans-traditional-chinese
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.juliangrove = {
    description = "Julian Grove";
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "audio" "pulse" "networkmanager" "video" "cups" ]; # stuff I can do
  };

  # some extra hardware management
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = " 22.05 "; # Did you read the comment?

}
