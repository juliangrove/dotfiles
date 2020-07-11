{ pkgs, lib, texlive, ... }:

{
  tex = (
    lib.overrideDerivation
      (
        texlive.combine {
          inherit (texlive)
            appendix
            biber
            bussproofs
            catchfile
            dejavu
            enumitem
            environ
            eso-pic
            etoolbox
            expex
            fancyvrb
            float
            forest
            framed
            fvextra
            gitinfo2
            inlinedef
            kpfonts
            libertine
            lineno
            mathtools
            minted
            mnsymbol
            multirow
            pgf
            pgfopts
            relsize
            scheme-basic
            sectsty
            stackengine
            stmaryrd
            tikz-qtree
            tipa
            titling
            tracklang
            trimspaces
            ulem
            upquote
            xcolor
            xstring
            ;
          langsci-avm.pkgs = [ (pkgs.callPackage ./latex/langsci-avm { }) ];
          libib.pkgs = [ (pkgs.callPackage ./latex/libib { }) ];
          minionpro.pkgs = [ (pkgs.callPackage ./latex/minionpro { }) ];
        }
      )
      (
        oldAttrs: {
          postBuild = ''
            # Save the udpmap.cfg because texlive.combine removes it.
            cat $out/share/texmf/web2c/updmap.cfg > $out/share/texmf/web2c/updmap.cfg.1
          '' + oldAttrs.postBuild + ''
            # Move updmap.cfg into its original place and rerun mktexlsr, so that kpsewhich finds it
            rm $out/share/texmf/web2c/updmap.cfg || true
            cat $out/share/texmf/web2c/updmap.cfg.1 > $out/share/texmf/web2c/updmap.cfg
            rm $out/share/texmf/web2c/updmap.cfg.1
            perl `type -P mktexlsr.pl` $out/share/texmf

            yes | perl `type -P updmap.pl` --sys --syncwithtrees --force || true
            perl `type -P updmap.pl` --sys --enable Map=MinionPro.map --enable Map=MyriadPro.map

            # Add minionpro/myriad
            #echo "Map MinionPro.map" >> $out/share/texmf/web2c/updmap.cfg
            #echo "Map MyriadPro.map" >> $out/share/texmf/web2c/updmap.cfg
        
            # Regenerate .map files.
            perl `type -P updmap.pl` --sys
          '';
        }
      )
  );
}
