{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodomex,
  pyopenssl,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dsinternals";
  version = "1.2.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "pydsinternals";
    rev = version;
    hash = "sha256-ZbYHO7It7R/Zh2dykTa4Ha4m2eyt9zkCzPyc/j79v6A=";
  };

  propagatedBuildInputs = [
    pyopenssl
    pycryptodomex
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dsinternals" ];

  enabledTestPaths = [ "tests/*.py" ];

  meta = {
    description = "Module to interact with Windows Active Directory";
    homepage = "https://github.com/p0dalirius/pydsinternals";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
