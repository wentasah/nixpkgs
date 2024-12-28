{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "tftp-hpa";
  version = "5.2+2024-06-10";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/network/tftp/tftp-hpa.git";
    rev = "2c86ff58dcc003107b47f2d35aa0fdc4a3fd95e1";
    sha256 = "1mnylx58mz8kjswyzl26c3c1zxhxq7rkh8s5ix5rfwdzhdsjacwm";
  };
  nativeBuildInputs = [ autoreconfHook ];
  autoreconfPhase = "/autogen.sh";

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: main.o:/build/tftp-hpa-5.2/tftp/main.c:98: multiple definition of
  #     `toplevel'; tftp.o:/build/tftp-hpa-5.2/tftp/tftp.c:51: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  meta = with lib; {
    description = "TFTP tools - a lot of fixes on top of BSD TFTP";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.bsd3;
    homepage = "https://www.kernel.org/pub/software/network/tftp/";
  };

  passthru = {
    updateInfo = {
      downloadPage = "https://www.kernel.org/pub/software/network/tftp/";
    };
  };
}
