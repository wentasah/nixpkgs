{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "plikd-unwrapped";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "root-gg";
    repo = "plik";
    rev = version;
    hash = "sha256-WCtfkzlZnyzZDwNDBrW06bUbLYTL2C704Y7aXbiVi5c=";
  };

  subPackages = [ "server" ];

  vendorHash = null;

  meta = {
    homepage = "https://plik.root.gg/";
    description = "Scalable & friendly temporary file upload system";
    maintainers = [ ];
    license = lib.licenses.mit;
  };

  postPatch = ''
    substituteInPlace server/common/version.go \
      --replace '"0.0.0"' '"${version}"'
  '';

  postFixup = ''
    mv $out/bin/server $out/bin/plikd
  '';

  passthru.tests = {
    inherit (nixosTests) plikd;
  };
}
