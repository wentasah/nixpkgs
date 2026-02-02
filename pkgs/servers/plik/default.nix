{
  lib,
  fetchurl,
  makeWrapper,
  runCommand,
  callPackage,
}:

let
  version = "1.3.7";

  plikd-unwrapped = callPackage ./plikd.nix { };
  plik = callPackage ./plik.nix { plikd = plikd-unwrapped; };

  webapp = fetchurl {
    url = "https://github.com/root-gg/plik/releases/download/${version}/plik-${version}-linux-amd64.tar.gz";
    hash = "sha256-Uj3I/ohgMr/Ud5xAZiBjsIW8bSdUeXXv9NYKLu8Aym8=";
  };

in
{

  inherit plik plikd-unwrapped;

  plikd =
    runCommand "plikd-${version}"
      {
        nativeBuildInputs = [ makeWrapper ];
        inherit (plikd-unwrapped) passthru;
      }
      ''
        mkdir -p $out/libexec/plikd/{bin,webapp} $out/bin
        tar xf ${webapp} plik-${version}-linux-amd64/webapp/dist/
        mv plik-*/webapp/dist $out/libexec/plikd/webapp
        cp ${plikd-unwrapped}/bin/plikd $out/libexec/plikd/bin/plikd
        makeWrapper $out/libexec/plikd/bin/plikd $out/bin/plikd \
          --chdir "$out/libexec/plikd/bin"
      '';
}
