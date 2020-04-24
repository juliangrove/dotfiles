{ pkgs }: 

(epkgs: (with epkgs; [
  airline-themes
  auctex                        # latex
  auto-package-update
  calfw
  calfw-ical
  calfw-gcal
  calfw-org
  caml
  coq-commenter
  elpy                          # python
  evil                          # used to use vim
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
  tuareg                        # ocaml
  xclip
]))
