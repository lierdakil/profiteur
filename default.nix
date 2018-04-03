{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghcjsHEAD", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, base, bytestring, containers
      , file-embed, filepath, ghc-prof, js-jquery, scientific, stdenv
      , template-haskell, text, unordered-containers, vector
      }:
      mkDerivation {
        pname = "profiteur";
        version = "0.4.4.0";
        src = ./.;
        configureFlags = [ "-fembed-data-files" ];
        isLibrary = false;
        isExecutable = true;
        enableSeparateDataOutput = true;
        executableHaskellDepends = [
          aeson base bytestring containers file-embed filepath ghc-prof
          js-jquery scientific template-haskell text unordered-containers
          vector
        ];
        homepage = "http://github.com/jaspervdj/profiteur";
        description = "Treemap visualiser for GHC prof files";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
