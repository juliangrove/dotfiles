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
      openconnect
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
      # dune_2 # ocaml
      eff
      ghc # haskell
      idris
      idris2
      ocaml
      ocamlPackages.findlib
      ocamlPackages.ocamlbuild
      ocamlPackages.ocp-indent
      ocamlPackages.merlin
      ocamlPackages.utop
      python-stuff # python + packages
      racket
      R-stuff # R + packages
      stack # haskell
      swiProlog # prolog

      # latex
      # tex

      # libraries
      cyrus_sasl

      # gui apps
      briss
      # clementineUnfree
      # discord
      dmenu
      latest.firefox-nightly-bin
      google-chrome
      # mathematica
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
        overrides = self: super: {
          mu4e-marker-icons = self.trivialBuild {
            pname = "mu4e-marker-icons";
            version = "20210124.514";
            src = pkgs.fetchurl {
              url = https://melpa.org/packages/mu4e-marker-icons-20210124.514.el;
              sha256 = "1rscac46rxhn7ci8nzpbqlif0s5hqnsgnzgwjfkhqf5b5q0lp4w1";
            };
            buildPhase = "";
            installPhase = ''
              mkdir -p $out/share/emacs/site-lisp
              cp mu4e-marker-icons-20210124.514.el $out/share/emacs/site-lisp/mu4e-marker-icons.el
            '';
          };
          # org = super.org.override {
          # elpaBuild = args: super.elpaBuild
          # (args // {
          # version = "9.4.2";
          # src = pkgs.fetchurl {
          # url = "https://elpa.gnu.org/packages/org-9.4.2.tar.lz";
          # sha256 = "17rn6y1rxhlisxsr9c4z4x60wm21pyv47i5xhyrasanc28w991nc";
          # };
          # nativeBuildInputs = [ pkgs.lzip ];
          # });
          # };
        };
      };

      # firefox = {
      # enable = true;
      # package = pkgs.latest.firefox-nightly-bin;
      # };

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
