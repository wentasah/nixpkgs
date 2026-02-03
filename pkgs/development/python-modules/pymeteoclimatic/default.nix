{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymeteoclimatic";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adrianmo";
    repo = "pymeteoclimatic";
    tag = version;
    hash = "sha256-Yln+uUwnb5mlPS3uRRzpAH6kSc9hU2jEnhk/3ifiwWI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    beautifulsoup4
    lxml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "meteoclimatic" ];

  meta = {
    description = "Python wrapper around the Meteoclimatic service";
    homepage = "https://github.com/adrianmo/pymeteoclimatic";
    changelog = "https://github.com/adrianmo/pymeteoclimatic/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
