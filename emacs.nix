{ pkgs }:
(
  epkgs: (
    with epkgs; [
      airline-themes
      all-the-icons
      all-the-icons-dired
      auctex # latex
      auto-package-update
      calfw
      calfw-gcal
      calfw-ical
      calfw-org
      caml
      coq-commenter
      dired-hide-dotfiles
      dired-sidebar
      dired-subtree
      elpy # python
      emojify
      ess # R
      evil # used to use vim
      fill-column-indicator
      flycheck
      gruvbox-theme
      haskell-mode
      idris-mode
      markdown-mode
      merlin # ocaml
      nix-haskell-mode
      nix-mode
      nixpkgs-fmt
      openwith
      org
      org-agenda-property
      org-gcal
      org-plus-contrib
      org-ref
      pdf-tools
      proof-general # coq
      racket-mode
      tuareg # ocaml
      use-package
      yaml-mode
      xclip
    ]
  )
)
