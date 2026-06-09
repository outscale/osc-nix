{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "oks-cli";
  version = "1.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "oks-cli";
    rev = "v${version}";
    hash = "sha256-ajT7PnaOD6X5gb9And+4+b+h0atnTOPeXMBC+3Dg39w=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonImportsCheck = [
    "oks_cli"
  ];

  pythonRelaxDeps = ["click"];

  dependencies = with python3.pkgs; [
    certifi
    charset-normalizer
    click
    colorama
    idna
    pyyaml
    requests
    urllib3
    human-readable
    prettytable
    python-dateutil
    altgraph
    pynacl
    pyopenssl
  ];

  meta = {
    description = "OKS-CLI is a command-line interface that allows you to deploy and manage Kubernetes clusters on top of OUTSCALE infrastructure";
    homepage = "https://github.com/outscale/oks-cli";
    changelog = "https://github.com/outscale/oks-cli/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [];
    mainProgram = "oks-cli";
  };
}
