{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "cimg";
  version = "2.9.4";

  src = fetchFromGitHub {
    owner = "dtschump";
    repo = "CImg";
    rev = "v.${version}";
    sha256 = "1sb0z5ryh34y80ghlr2agsl64gayjmxpl96l9fjaylf5k2m3fg2b";
  };

  installPhase = ''
    install -dm 755 $out/include/CImg/plugins $doc/share/doc/cimg/examples

    install -m 644 CImg.h $out/include/
    cp -dr --no-preserve=ownership examples/* $doc/share/doc/cimg/examples/
    cp -dr --no-preserve=ownership plugins/* $out/include/CImg/plugins/
    cp README.txt $doc/share/doc/cimg/
  '';

  outputs = [ "out" "doc" ];

  meta = with lib; {
    description = "A small, open source, C++ toolkit for image processing";
    longDescription = ''
      CImg stands for Cool Image. It is easy to use, efficient and is intended
      to be a very pleasant toolbox to design image processing algorithms in
      C++. Due to its generic conception, it can cover a wide range of image
      processing applications.
    '';
    homepage = "http://cimg.eu/";
    license = licenses.cecill-c;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
