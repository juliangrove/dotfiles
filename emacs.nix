{ pkgs }:
(
  epkgs: (
    with epkgs; [
      # ac-octave
      agda-input
      # agda2-mode
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
      dante
      dired-hide-dotfiles
      dired-sidebar
      dired-subtree
      direnv
      elpy # python
      emojify
      ess # R
      evil # used to use vim
      # evil-magit
      fill-column-indicator
      flycheck
      gruvbox-theme
      haskell-mode
      idris-mode
      magit
      markdown-mode
      merlin # ocaml
      nix-haskell-mode
      nix-mode
      nixpkgs-fmt
      nix-sandbox
      openwith
      org
      org-agenda-property
      org-gcal
      org-noter
      org-plus-contrib
      org-ref
      pdf-tools
      proof-general # coq
      racket-mode
      tuareg # ocaml
      use-package
      utop # ocaml
      yaml-mode
      xclip
    ]
  )
)
