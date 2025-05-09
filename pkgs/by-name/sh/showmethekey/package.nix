{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  libevdev,
  json-glib,
  libinput,
  gtk4,
  libadwaita,
  wrapGAppsHook4,
  libxkbcommon,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "showmethekey";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "AlynxZhou";
    repo = "showmethekey";
    tag = "v${version}";
    hash = "sha256-/pfXAn6dWFIHsP1VBj+Cf989RuVzv4IbSClbJEvGstI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    json-glib
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libevdev
    libinput
    libxkbcommon
  ];

  meta = with lib; {
    description = "Show keys you typed on screen";
    homepage = "https://showmethekey.alynx.one/";
    changelog = "https://github.com/AlynxZhou/showmethekey/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ocfox ];
  };
}
