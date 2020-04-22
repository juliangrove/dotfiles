{ config, pkgs, ... }:

let mozilla-overlay = fetchTarball {
      url = https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz;
    };
    i3lock-fancy-rapid = pkgs.callPackage ./programs/i3lock-fancy-rapid {};
in {
  imports =
    [
      ./tex.nix                 # latex
    ];

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
    ".offlineimaprc" = {
      source = programs/offlineimap/offlineimaprc;
    };
    ".offlineimap.py" = {
      source = programs/offlineimap/offlineimap.py;
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
    in with pkgs; [
      # cli tools
      nixos.dict
      feh
      gcc
      git
      gnupg
      htop
      i3lock-fancy-rapid
      mu
      neofetch
      nix-prefetch-git
      offlineimap
      pciutils
      scrot
      lm_sensors
      wget

      # editors
      (import ./emacs.nix { inherit pkgs; })
      vim   
      
      # languages
      coq
      idris
      ocaml
      python
      racket
      stack                     # haskell
      swiProlog                 # prolog

      # gui apps
      briss
      latest.firefox-nightly-bin
      google-chrome
      pinentry_qt5              # support for gpg passphrase entry
      spotify
      # skype
      unstable.haskellPackages.xmobar
      zotero
    ];

  programs.bash = {
    enable = true;
    historyIgnore = [ "ls" "cd" "exit" ];
    profileExtra = (builtins.readFile ./programs/bash/bash_profile);
    bashrcExtra = (builtins.readFile ./programs/bash/bashrc);
  };

  programs.alacritty.enable = true; # terminal emulator  

  programs.zathura.enable = true; # zathura

  # cursors
  xsession.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };

  # picom
  services.picom = {
    enable = true;
    vSync = true;               # to prevent tearing
    shadow = true;
    shadowExclude = [ "name = 'xmobar'" ];
  };
}
