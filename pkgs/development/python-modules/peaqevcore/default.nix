{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "peaqevcore";
  version = "7.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G2ujLjN8LEHY9gd0SWBpOSkV6fQAZ8pojR0+bMi6TUw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest" ""
  '';

  # Tests are not shipped and source is not tagged
  # https://github.com/elden1337/peaqev-core/issues/4
  doCheck = false;

  pythonImportsCheck = [
    "peaqevcore"
  ];

  meta = with lib; {
    description = "Library for interacting with Peaqev car charging";
    homepage = "https://github.com/elden1337/peaqev-core";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
