{ nixos, pkgs }:
(
  epkgs: (
    with epkgs; [
      # ac-octave
      # agda-input
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
      # cargo
      citeproc # used with org-ref
      company-stan
      coq-commenter # coq
      dante # haskell
      dired-hide-dotfiles
      dired-sidebar
      dired-subtree
      direnv
      # dumb-jump # deprecated by xref
      eglot
      eldoc-stan
      elpy # python
      emojify
      ess # R
      evil # used to use vim
      evil-collection
      fill-column-indicator
      flycheck
      flycheck-stan
      # gnuplot
      gnuplot-mode
      # nixos.emacsPackages.gruvbox-theme
      gruvbox-theme
      haskell-mode # haskell
      idris-mode # idris
      ledger-mode
      ligature
      lsp-mode
      # lsp-ui
      magit
      markdown-mode # markdown
      merlin # ocaml
      # mu4e
      mu4e-column-faces
      mu4e-marker-icons
      # nerd-icons
      nix-haskell-mode
      nix-mode # nix
      nixpkgs-fmt # nix
      nix-sandbox # nix
      ocp-indent
      ocamlformat
      openwith
      org
      org-agenda-property
      org-gcal
      org-ref
      # org-ref-prettify
      org-superstar
      # pdf-tools
      proof-general # coq
      quarto-mode # quarto
      racket-mode
      # rustic # rust
      rust-mode # rust
      # semantic-theming
      stan-mode
      stan-snippets
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
