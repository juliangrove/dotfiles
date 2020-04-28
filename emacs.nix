{ pkgs }: 

(epkgs: (with epkgs; [
  airline-themes
  auctex                        # latex
  auto-package-update
  calfw
  calfw-gcal
  calfw-ical
  calfw-org
  caml
  coq-commenter
  elpy                          # python
  evil                          # used to use vim
  flycheck
  gruvbox-theme
  haskell-mode
  idris-mode
  mu4e-conversation             # subsumes mu4e
  nix-haskell-mode
  nix-mode
  org
  org-agenda-property
  org-gcal
  org-plus-contrib
  proof-general                 # coq
  racket-mode
  use-package
  tuareg                        # ocaml
  xclip
]))
