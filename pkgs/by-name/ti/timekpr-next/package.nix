{
  lib,
  fetchgit,
  python3Packages,
  wrapGAppsHook3, gtk3, gobject-introspection,
}:

python3Packages.buildPythonApplication rec {
  pname = "timekpr-next";
  version = "0.5.7";

  format = "other";

  src = fetchgit {
    url = "https://git.launchpad.net/timekpr-next";
    rev = "v${version}";
    hash = "sha256-JAb7l4ouQc/QSLCC0toIm5mLhT38Fda/DF9ZDK4Ee7o=";
  };

  dependencies = with python3Packages; [
    dbus-python
    psutil
    pygobject3
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
  ];

  postPatch = ''
    substituteInPlace bin/* client/timekpr[ac].py server/timekprd.py \
      --replace-fail '/usr/lib/' "$out/lib/"
    substituteInPlace common/constants/constants.py \
      --replace-fail '/usr/' "$out/"
  '';

  dontBuild = true;

  installPhase = ''
    while read src dst; do
      case $src in
        '#'*|"")
           continue;;
        *)
          install -D -t "$out/''${dst#usr/}" "$src";;
      esac
    done < debian/install
  '';

  postFixup = ''
    patchPythonScript $out/lib/python3/dist-packages/timekpr/client/timekpra.py
    patchPythonScript $out/lib/python3/dist-packages/timekpr/client/timekprc.py
    patchPythonScript $out/lib/python3/dist-packages/timekpr/server/timekprd.py
  '';

  meta = {
    description = "";
    homepage = "https://git.launchpad.net/timekpr-next";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wentasah ];
    platforms = lib.platforms.linux;
  };
}
