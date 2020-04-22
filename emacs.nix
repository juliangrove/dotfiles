/*
This is a nix expression to build Emacs and some Emacs packages I like
from source on any distribution where Nix is installed. This will install
all the dependencies from the nixpkgs repository and build the binary files
without interfering with the host distribution.

To build the project, type the following from the current directory:

$ nix-build emacs.nix

To run the newly compiled executable:

$ ./result/bin/emacs
*/
{ pkgs ? import <nixpkgs> {} }: 

let
  myEmacs = pkgs.emacs; 
  emacsWithPackages = (pkgs.emacsPackagesGen myEmacs).emacsWithPackages;
in
  emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
  ]) ++ (with epkgs.melpaPackages; [
    airline-themes
    auto-package-update
    calfw
    calfw-ical
    calfw-gcal
    calfw-org
    caml
    coq-commenter
  # elpy
    evil
    gruvbox-theme
    haskell-mode
    idris-mode
  # mu4e
    mu4e-conversation
 #   org
    org-agenda-property
    org-gcal
 #  org-plus-contrib
    proof-general
    tuareg
 #   xclip
  ]) ++ (with epkgs.elpaPackages; [ 
    auctex         # ; LaTeX mode
    org
    xclip
  ]) ++ [
    pkgs.mu      # From main packages set 
  ])
