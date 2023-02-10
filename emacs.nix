{ nixos, pkgs }:
(
  epkgs: (
    with epkgs; [
      # ac-octave
      agda-input
      agda2-mode # agda
      airline-themes
      all-the-icons
      all-the-icons-dired
      attrap # haskell
      auctex # latex
      auto-package-update
      calfw
      calfw-gcal
      calfw-ical
      calfw-org
      caml # ocaml
      citeproc # used with org-ref
      # company-stan
      coq-commenter # coq
      dante # haskell
      dired-hide-dotfiles
      dired-sidebar
      dired-subtree
      direnv
      # dumb-jump # deprecated by xref
      # eldoc-stan
      elpy # python
      emojify
      ess # R
      evil # used to use vim
      evil-collection
      fill-column-indicator
      flycheck
      # flycheck-stan
      # gnuplot
      gnuplot-mode
      nixos.emacsPackages.gruvbox-theme
      # gruvbox-theme
      haskell-mode # haskell
      idris-mode # idris
      ledger-mode
      magit
      markdown-mode # markdown
      merlin # ocaml
      mu4e-marker-icons
      nix-haskell-mode
      nix-mode # nix
      nixpkgs-fmt # nix
      nix-sandbox # nix
      ocp-indent
      openwith
      org
      org-agenda-property
      org-gcal
      org-ref
      # org-ref-prettify
      org-superstar
      # pdf-tools
      proof-general # coq
      racket-mode
      # semantic-theming
      # stan-mode
      # stan-snippets
      swiper
      tabbar
      tuareg # ocaml
      use-package
      utop # ocaml
      yaml-mode # yaml
      xclip
    ]
  )
)
