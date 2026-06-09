{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
}:
buildGo126Module rec {
  pname = "octl";
  version = "0.0.25";

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "octl";
    rev = "v${version}";
    hash = "sha256-zTuCofVAdX83e1ngbzJLaqlhn//krIajljbn/0qzgcc=";
  };

  vendorHash = "sha256-jy24WPA4dD+7uChtqebqpn5AkqSjBisHHT7i21n/86g=";
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/outscale/octl/pkg/version.Version=v${version}"
    "-X=k8s.io/component-base/version.gitVersion=v1.35.3+octl"
  ];

  nativeBuildInputs = [installShellFiles makeWrapper];

  postInstall = ''
    installShellCompletion --cmd octl \
      --bash <($out/bin/octl completion bash) \
      --fish <($out/bin/octl completion fish) \
      --zsh <($out/bin/octl completion zsh)

    wrapProgram $out/bin/octl \
        --add-flags "--no-upgrade"
  '';

  meta = {
    description = "Experimental CLI for Outscale";
    homepage = "https://github.com/outscale/octl";
    changelog = "https://github.com/outscale/octl/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [];
    mainProgram = "octl";
  };
}
