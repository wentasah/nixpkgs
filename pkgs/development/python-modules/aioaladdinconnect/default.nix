{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioaladdinconnect";
  version = "0.1.34";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "AIOAladdinConnect";
    inherit version;
    hash = "sha256-p5O4tm+m0ThJS/VTqhMNs2bwA2S6kJ2reQ2BoTHmLz8=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "AIOAladdinConnect"
  ];

  meta = with lib; {
    description = "Library for controlling Genie garage doors connected to Aladdin Connect devices";
    homepage = "https://github.com/mkmer/AIOAladdinConnect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
