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
    kernel.sysctl = {
      "vm.dirty_writeback_centisecs" = 1500;
      "kernel.nmi_watchdog" = 0;
    };
    kernelParams = [
      "resume=UUID=33dad16f-250c-4993-b84b-05f69e978bb2"
      "mem_sleep_default=deep" # Force deep sleep (suspend-to-ram)
    ];
    resumeDevice = "/dev/disk/by-uuid/33dad16f-250c-4993-b84b-05f69e978bb2";
    
    # kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_0.override {
    #   argsOverride = rec {
    #     src = pkgs.fetchurl {
    #       url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    #       sha256 = "17awx4c5fz7f656ig5bydccci052jsai0lczrn2bdk5cihw2cg51";
    #     };
    #     version = "6.0.2";
    #     modDirVersion = "6.0.2";
    #   };
    # });
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
      # enp0s31f6.useDHCP = true;
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
  time.timeZone = "America/New_York";
  # time.timeZone = "America/Denver";
  # time.timeZone = "Europe/Zurich";
  # time.timeZone = "Europe/Stockholm";
  # time.timeZone = "Europe/London";

  # for things like spotify
  nixpkgs.config = {
    allowUnfree = true;
    input-fonts.acceptLicense = true;
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };

    # backlight
    light.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages =
      let
        unstable = import <nixos-unstable> { };
      in
      with pkgs; [
        hack-font
        home-manager # personal config
        nitrogen # wallpaper
        lxqt.pavucontrol-qt # pulseaudio control
        xbindkeys # keybindings
        xdotool
        xorg.xhost
        xorg.xset
        xssproxy
        haskellPackages.xmobar # status bar

        xterm
        alacritty
      ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # systemd services
  services = {
    # avahi for DNS discovery
    avahi = {
      enable = true;
      nssmdns4 = true; # local hostname resolution for apps
    };

    blueman.enable = true;

    # auto-login
    displayManager = {
      autoLogin = {
        enable = true;
        user = "juliangrove";
      };

      defaultSession = "none+xmonad";
    };

    # flatpak.enable = true;

    # touchpad support
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = false;
      };
    };

    geoclue2 = {
      enable = true;
      enableWifi = true;
    };

    pcscd.enable = true;

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
      # xkb.options = "eurosign:e";
      dpi = 243;

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

      displayManager.sessionCommands = ''
        nitrogen --restore
        xbindkeys &
        systemctl --user restart emacs # keep having to do this for some reason
      '';

      # use screen-locker to suspend
      xautolock = {
        enable = true;
        locker = ''${pkgs.writeShellScript "suspendScript" ''
          #!${pkgs.bash}/bin/bash
          systemctl suspend-then-hibernate
        ''}'';
        # locker = ''${pkgs.writeShellScript "lock-screen-i3lock-fancy-rapid" ''
        # ~/.nix-profile/bin/i3lock-fancy-rapid 40 10 -n \
        # --inside-color=1d202180 \
        # --ring-color=b8bb2680 \
        # --keyhl-color=fabd2f80 \
        # --bshl-color=cc241dff \
        # --line-color=282828ff \
        # --insidever-color=83a5984d \
        # --ringver-color=45858880 \
        # --insidewrong-color=cc241d80 \
        # --ringwrong-color=fb493480
        # ''}'';
        time = 10;
        extraOptions = [ "-corners" "----" ];
      };
    };

    picom = {
      enable = true;
      backend = "glx";
      vSync = true; # to prevent tearing
      shadow = true;
      shadowExclude = [ "name = 'xmobar'" ];
    };

    pipewire = {
      alsa.enable = true;
      enable = true;
      extraConfig = {
        pipewire."99-silent-bell.conf" = {
          "context.properties" = {
            "module.x11.bell" = false;
          };
        };
      };
      pulse.enable = true;
      wireplumber.enable = true;
    };

    tlp = {
      enable = true;
      settings = {
        # CPU energy policy
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";

        # Intel platform profile (if supported by your firmware)
        PLATFORM_PROFILE_ON_BAT = "low-power";
        PLATFORM_PROFILE_ON_AC = "balanced";
        START_CHARGE_THRESH_BAT0 = 40; # Don't charge until below 40%
        STOP_CHARGE_THRESH_BAT0 = 80; # Stop charging at 80%

        # Enable PCIe Runtime Power Management - THIS IS THE KEY ADDITION
        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";

        # USB autosuspend
        USB_AUTOSUSPEND = "1"; # Changed from "Y" to "1" (more reliable)

        # Wi-Fi power saving
        WIFI_PWR_ON_BAT = "on";

        # Disable Wake-on-LAN
        WOL_DISABLE = "Y";

        # Optional: Remove xhci_hcd from denylist to allow USB controller power management
        RUNTIME_PM_DRIVER_DENYLIST = "mei_me nouveau radeon";
      };
    };
  };

  systemd.services.systemd-suspend-then-hibernate.wantedBy = [ "suspend.target" ];

  # Hibernate after being suspended for 60 minutes.
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=60min
  '';

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
      powerOnBoot = false;
      settings.General.ControllerMode = "bredr";
    };

    firmware = with pkgs; [
      sof-firmware
    ];

    #   pulseaudio = {
    #     enable = false;
    #     # extraConfig = ''
    #     # load-module module-alsa-sink   device=hw:0,0 channels=4
    #     # load-module module-alsa-source device=hw:0,6 channels=4
    #     # '';
    #     package = pkgs.pulseaudioFull;
    #     support32Bit = true;
    #     systemWide = false;
    #   };
  };

  # fonts
  fonts = {
    packages = with pkgs; [
      aegyptus
      akkadian
      alegreya
      corefonts
      emacs-all-the-icons-fonts
      etBook
      font-awesome
      iosevka
      iosevka-comfy.comfy
      input-fonts
      ipafont
      jetbrains-mono
      kochi-substitute
      liberation_ttf
      libertinus
      lmmath
      lohit-fonts.kannada
      material-icons
      mplus-outline-fonts.githubRelease
      # nerdfonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      open-sans
      powerline-fonts
      source-han-sans
    ];
  };

  # Optionally, enable XDG portals for better integration
  xdg.portal =
    {
      config.common.default = "*";
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.juliangrove = {
    description = "Julian Grove";
    isNormalUser = true;
    createHome = true;
    extraGroups = [ "wheel" "audio" "networkmanager" "video" "cups" ]; # stuff I can do
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
  system.stateVersion = "25.11"; # Did you read the comment?

}
