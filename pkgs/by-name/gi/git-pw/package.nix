{
  lib,
  git,
  python3,
  fetchFromGitHub,
  testers,
  git-pw,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "git-pw";
  version = "2.7.1";
  format = "pyproject";

  PBR_VERSION = version;

  src = fetchFromGitHub {
    owner = "getpatchwork";
    repo = "git-pw";
    tag = version;
    hash = "sha256-Ce+Nc2NZ42dIpeLg8OutD8ONxj1XRiNodGbTWlkK9qw=";
  };

  nativeBuildInputs = with python3.pkgs; [
    pbr
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pyyaml
    arrow
    click
    requests
    tabulate
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytestCheckHook
    git
  ];

  # This is needed because `git-pw` always rely on an ambient git.
  # Furthermore, this doesn't really make sense to resholve git inside this derivation.
  # As `testVersion` does not offer the right knob, we can just `overrideAttrs`-it ourselves.
  passthru.tests.version = (testers.testVersion { package = git-pw; }).overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ git ];
  });

  meta = with lib; {
    description = "Tool for integrating Git with Patchwork, the web-based patch tracking system";
    homepage = "https://github.com/getpatchwork/git-pw";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
