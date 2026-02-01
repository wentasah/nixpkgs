{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cyclonedx-gomod";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-gomod";
    tag = "v${version}";
    hash = "sha256-x0/Sei1uY8dDTYCFOgI2e6pe/5BjXLgt8YKKvSMBG4I=";
  };

  vendorHash = "sha256-x2aP+tGG5cn7ePeIbo+3XuPdWTScdY4dYvEKSJjxoSo=";

  ldflags = [
    "-w"
    "-s"
  ];

  # Tests require network access and cyclonedx executable
  doCheck = false;

  meta = {
    description = "Tool to create CycloneDX Software Bill of Materials (SBOM) from Go modules";
    homepage = "https://github.com/CycloneDX/cyclonedx-gomod";
    changelog = "https://github.com/CycloneDX/cyclonedx-gomod/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cyclonedx-gomod";
  };
}
