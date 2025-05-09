{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  quilt,
  ipv6Support ? true,
}:

stdenv.mkDerivation rec {
  pname = "ucspi-tcp";
  version = "0.88";

  src = fetchurl {
    url = "https://cr.yp.to/ucspi-tcp/ucspi-tcp-${version}.tar.gz";
    sha256 = "171yl9kfm8w7l17dfxild99mbf877a9k5zg8yysgb1j8nz51a1ja";
  };

  debian = fetchzip {
    url = "http://ftp.de.debian.org/debian/pool/main/u/ucspi-tcp/ucspi-tcp_0.88-11.debian.tar.xz";
    sha256 = "0x8h46wkm62dvyj1acsffcl4s06k5zh6139qxib3zzhk716hv5xg";
  };

  patches = lib.optional ipv6Support [
    (fetchurl {
      url = "https://salsa.debian.org/debian/ucspi-tcp/-/raw/debian/1%250.88-11/debian/ipv6-support.patch";
      sha256 = "1hp9svfb2pn7ij37z3axhw4lhx5ckvz3rgxgjz8a5bi2y0v0w3mb";
    })
  ];

  nativeBuildInputs = [
    quilt
  ];

  # Plain upstream tarball doesn't build, apply patches from Debian
  prePatch = ''
    QUILT_PATCHES=$debian/patches quilt push -a
  '';

  postPatch = ''
    # Remove setuid
    substituteInPlace hier.c --replace-fail ',02755);' ',0755);'
  '';

  # The build system is weird; 'make install' doesn't install anything, instead
  # it builds an executable called ./install (from C code) which installs
  # binaries to the directory given on line 1 in ./conf-home.
  #
  # Also, assume getgroups and setgroups work, instead of doing a build time
  # test that breaks on NixOS (I think because nixbld users lack CAP_SETGID
  # capability).
  preBuild = ''
    echo "$out" > conf-home

    echo "int main() { return 0; }" > chkshsgr.c
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/man/man1"

    # run the newly built installer
    ./install

  '' + lib.optionalString ipv6Support ''
    # Replicate Debian's man install logic (some man pages from
    # ipv6-support.patch will be overwritten below by
    # debian/ucspi-tcp-man/*.1).
    rm -rf "$out/usr/man/man5"  # don't include tcp-environ(5)
    mv -v "$out"/man/man1/*.1 "$out/share/man/man1/"

  '' + ''
    # Install Debian man pages (upstream has none)
    cp $debian/ucspi-tcp-man/*.1 "$out/share/man/man1"
  '';

  meta = with lib; {
    description = "Command-line tools for building TCP client-server applications";
    longDescription = ''
      tcpserver waits for incoming connections and, for each connection, runs a
      program of your choice. Your program receives environment variables
      showing the local and remote host names, IP addresses, and port numbers.

      tcpserver offers a concurrency limit to protect you from running out of
      processes and memory. When you are handling 40 (by default) simultaneous
      connections, tcpserver smoothly defers acceptance of new connections.

      tcpserver also provides TCP access control features, similar to
      tcp-wrappers/tcpd's hosts.allow but much faster. Its access control rules
      are compiled into a hashed format with cdb, so it can easily deal with
      thousands of different hosts.

      This package includes a recordio tool that monitors all the input and
      output of a server.

      tcpclient makes a TCP connection and runs a program of your choice. It
      sets up the same environment variables as tcpserver.

      This package includes several sample clients built on top of tcpclient:
      who@, date@, finger@, http@, tcpcat, and mconnect.

      tcpserver and tcpclient conform to UCSPI, the UNIX Client-Server Program
      Interface, using the TCP protocol. UCSPI tools are available for several
      different networks.
    '';
    homepage = "http://cr.yp.to/ucspi-tcp.html";
    license = licenses.publicDomain;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
