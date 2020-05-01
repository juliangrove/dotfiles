{ config, pkgs, ... }:

let mozilla-overlay = fetchTarball {
      url = https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz;
    };
    i3lock-fancy-rapid = pkgs.callPackage ./programs/i3lock-fancy-rapid {};
in {
  # dotfiles
  home.file = {
    ".config/alacritty/alacritty.yml" = {
      source = programs/alacritty/alacritty.yml;
    };
    ".config/neofetch/config.conf" = {
      source = programs/neofetch/config.conf;
    };
    ".emacs" = {
      source = programs/emacs/emacs;
    };
    ".mbsyncrc" = {
      source = programs/isync/mbsyncrc;
    };
    ".xbindkeysrc" = {
      source = programs/xbindkeys/xbindkeysrc;
    };
    ".xmobar/volume.sh" = {
      source = programs/xmobar/volume.sh;
    };
    ".xmobar/xmobarrc" = {
      source = programs/xmobar/xmobarrc;
    };
  };

  nixpkgs = {
    # for things like spotify
    config.allowUnfree = true;
    # overlays
    overlays = [
      (import "${mozilla-overlay}")
    ];
  };
    
  home.packages =
    let nixos = import <nixos> {};
        unstable = import <nixos-unstable> {};
        python-packages = py-pkgs: with py-pkgs; [
          pandas
          scikitlearn
        ];
        python-stuff = pkgs.python38.withPackages python-packages;
        R-stuff = pkgs.rWrapper.override {
          packages = with pkgs.rPackages; [ ggplot2 ];
        };
        tex = (pkgs.callPackage ./tex.nix {}).tex;
    in with pkgs; [
      # cli tools
      nixos.dict
      feh
      gcc
      gnupg
      htop
      i3lock-fancy-rapid
      isync
      killall
      lshw
      mu
      neofetch
      nix-prefetch-git
      pandoc
      pciutils
      pdftk
      prettyping
      scrot
      unzip
      lm_sensors
      wget
      xorg.xdpyinfo

      # editors
      vim   
      
      # languages
      coq
      idris
      ocaml
      python-stuff              # python + packages
      racket
      R-stuff                   # R + packages
      stack                     # haskell
      swiProlog                 # prolog

      # latex
      tex
      
      # gui apps
      briss
      latest.firefox-nightly-bin
      google-chrome
      pinentry_qt5              # support for gpg passphrase entry
      spotify
      skype
      unstable.haskellPackages.xmobar
      zoom-us
      zotero
    ];

  programs = {
    alacritty.enable = true; # terminal emulator
    
    bash = {
      enable = true;
      historyIgnore = [ "ls" "cd" "exit" "pwd" ]; 
      bashrcExtra = ''
        PS1=$'\[\033[32m\e[2m\]\u03bb\[\033[00m\] '
        neofetch
'';
    };

    emacs = {
      enable = true;
      package = pkgs.emacs;
      extraPackages = import ./emacs.nix { inherit pkgs; };
    };

    git = {
      enable = true;
      userEmail = "julian.grove@gmail.com";
      userName = "juliangrove";
    };
    
    zathura.enable = true;  # zathura
  };
  
  # cursors
  xsession.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };

  # systemd user services
  services = {
     emacs.enable = true;
    
    picom = {
      enable = true;
      vSync = true;             # to prevent tearing
      shadow = true;
      shadowExclude = [ "name = 'xmobar'" ];
    };
    
    mbsync = {
      enable = true;
      frequency = "*:0/1";
      postExec = ''${pkgs.mu}/bin/mu index --maildir=~/.mail'';
    };
  };
}
