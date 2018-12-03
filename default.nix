{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghcjs", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, base, bytestring, containers
      , file-embed, filepath, ghc-prof, js-jquery, scientific, stdenv
      , template-haskell, text, unordered-containers, vector
      }:
      mkDerivation {
        pname = "profiteur";
        version = "0.4.5.0";
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

  haskellPackages = pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: {
        tasty-quickcheck = super.tasty-quickcheck.overrideAttrs (oldAttrs: rec {doCheck = false;});
        scientific = super.scientific.overrideAttrs (oldAttrs: rec {doCheck = false;});
    };
  };

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
