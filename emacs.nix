{ pkgs }:
(
  epkgs: (
    with epkgs; [
      # ac-octave
      agda-input
      agda2-mode # agda
      airline-themes
      all-the-icons
      all-the-icons-dired
      auctex # latex
      auto-package-update
      calfw
      calfw-gcal
      calfw-ical
      calfw-org
      caml # ocaml
      coq-commenter # coq
      dante # haskell
      dired-hide-dotfiles
      dired-sidebar
      dired-subtree
      direnv
      elpy # python
      emojify
      ess # R
      evil # used to use vim
      evil-collection
      fill-column-indicator
      flycheck
      gruvbox-theme
      haskell-mode # haskell
      idris-mode # idris
      magit
      markdown-mode # markdown
      merlin # ocaml
      nix-haskell-mode
      nix-mode # nix
      nixpkgs-fmt # nix
      nix-sandbox # nix
      ocp-indent
      openwith
      org
      org-agenda-property
      org-bullets
      org-gcal
      org-noter
      org-plus-contrib
      org-ref
      pdf-tools
      proof-general # coq
      racket-mode
      tabbar
      tuareg # ocaml
      use-package
      utop # ocaml
      yaml-mode # yaml
      xclip
    ]
  )
)
