self: super: {
  python = super.python38.override {
    packageOverrides = python-self: python-super: {
      pygments = python-super.pygments.overrideAttrs (oldAttrs: rec {
        gruvbox = super.fetchFromGithub {
          owner = "daveyarwood";
          repo = "gruvbox-pygments";
          rev = "36ed771df54a3ce3d0a318b0d51dd2817dce2508";
          sha256 = "1yyah3k2968gvaj0y1m3m63cbvn4xijmgp2dn29ca369crr8gbbk";
        };

        postBuild = ''
          cd $gruvbox
          ls
          cp $gruvbox/gruvbox/style.py $out/styles/gruvbox.py
        '';
      });
    };
  };
}
