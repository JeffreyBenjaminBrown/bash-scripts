nix-shell -p terminus_font --run 'setfont -d $(nix-build "<nixpkgs>" -A terminus_font --no-out-link)/share/consolefonts/ter-v32b.psf.gz'
