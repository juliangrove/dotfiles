{ config, pkgs, ... }:
let
  emacs-overlay = fetchTarball {
    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  };
  mozilla-overlay = fetchTarball {
    url = https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz;
  };
in
{
  # dotfiles
  home.file = {
    ".agda/defaults" = {
      source = programs/agda/defaults;
    };
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
    config.allowUnfree = true; # for things like spotify
    # overlays
    overlays = [
      # (import ./overlays/python-pygments.nix)
      (import "${emacs-overlay}")
      (import "${mozilla-overlay}")
    ];
  };

  home.packages =
    let
      agda-stuff = (pkgs.agda.withPackages (with pkgs; [
        agdaPackages.standard-library
        agdaPackages.cubical
      ]));
      i3lock-fancy-rapid = pkgs.callPackage ./programs/i3lock-fancy-rapid { };
      nixos = import <nixos> { };
      python-packages = py-pkgs: with py-pkgs; [
        matplotlib
        numpy
        pandas
        pygments
        scikitlearn
        # tensorflowWithoutCuda
      ];
      python-stuff = pkgs.python38.withPackages python-packages;
      R-stuff = pkgs.rWrapper.override {
        packages = with pkgs.rPackages; [
          ggplot2
          lme4
        ];
      };
      tex = (pkgs.callPackage ./tex.nix { }).tex;
    in
    with pkgs; [
      # cli tools
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      bibtool
      bibtex2html
      croc
      direnv
      dict
      escrotum
      feh
      gcc
      gnupg
      htop
      i3lock-fancy-rapid
      isync
      killall
      lm_sensors
      lshw
      mu
      neofetch
      nixpkgs-fmt
      nix-prefetch-git
      openvpn
      pandoc
      pciutils
      pdftk
      prettyping
      unzip
      wget
      xorg.xdpyinfo
      zip

      # editors
      vim

      # languages
      agda-stuff # agda + packages
      cabal-install # haskell
      coq
      eff
      ghc # haskell
      idris
      idris2
      ocaml
      ocamlPackages.findlib
      ocamlPackages.ocamlbuild
      ocamlPackages.merlin
      # octave
      python-stuff # python + packages
      racket
      R-stuff # R + packages
      stack # haskell
      swiProlog # prolog

      # latex
      tex

      # libraries
      cyrus_sasl

      # gui apps
      briss
      # clementineUnfree
      latest.firefox-nightly-bin
      google-chrome
      pinentry_qt5 # support for gpg passphrase entry
      skype
      spotify
      zoom-us
      zotero
    ];

  programs =
    {
      alacritty.enable = true; # terminal emulator

      bash = {
        enable = true;
        historyControl = [ "ignoredups" ];
        historyIgnore = [ "ls*" "cd*" "exit" "pwd" ];
        bashrcExtra = ''
          PS1=$'\[\033[32m\e[2m\]\u03bb\[\033[00m\] '
          neofetch --ascii_distro nixos_old
        '';
      };

      emacs = {
        enable = true;
        package = pkgs.emacs;
        extraPackages = import ./emacs.nix { inherit pkgs; };
        #   overrides = self: super: {
        #     auctex = super.auctex.override {
        #       elpaBuild = args: super.elpaBuild
        #         (args // {
        #           version = "13.0.6";
        #           src = pkgs.fetchurl {
        #             url = "https://elpa.gnu.org/packages/auctex-13.0.6.tar";
        #             sha256 = "00wp388rh2nnk8fam53kilykg90jylps31qxv9ijy1lsp1hqdjys";
        #           };
        #         });
        #     };
        #   };
      };
      git = {
        enable = true;
        userEmail = "julian.grove@gmail.com";
        userName = "juliangrove";
      };

      ssh.enable = true;

      zathura.enable = true; # zathura
    };

  # cursors
  xsession.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };

  # systemd user services
  services = {
    emacs.enable = true;

    mbsync = {
      enable = true;
      frequency = "*:0/1";
      postExec = "${pkgs.mu}/bin/mu index";
    };

    redshift = {
      enable = true;
      provider = "geoclue2";
    };
  };
}
