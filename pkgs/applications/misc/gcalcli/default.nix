{ stdenv, lib, fetchFromGitHub, python3
, libnotify ? null }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "gcalcli";
  version = "4.3.0+pr599";

  src = fetchFromGitHub {
    owner  = "insanum";
    repo   = pname;
    rev    = "d8378f7ec92b160012d867e51ceb5c73af1cc4b0"; # https://github.com/insanum/gcalcli/pull/599
    sha256 = "sha256-V4oqetDg56YksjYd/yjB7wH+t+mvxSmExVSYEFUhD/0=";
  };

  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace gcalcli/argparsers.py \
      --replace "'notify-send" "'${libnotify}/bin/notify-send"
  '';

  propagatedBuildInputs = [
    python-dateutil gflags httplib2 parsedatetime six vobject
    google-api-python-client oauth2client uritemplate
    libnotify
  ];

  # There are no tests as of 4.0.0a4
  doCheck = false;

  meta = with lib; {
    description = "CLI for Google Calendar";
    homepage = "https://github.com/insanum/gcalcli";
    license = licenses.mit;
    maintainers = with maintainers; [ nocoolnametom ];
  };
}
