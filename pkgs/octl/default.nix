{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
}:
buildGo127Module rec {
  pname = "octl";
  version = "0.0.34";

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "octl";
    rev = "v${version}";
    hash = "sha256-ecPlFsnWDBJuFUtdd7P9vdvphj8m+6mIo8mrmaMyVkU=";
  };

  vendorHash = "sha256-3jmFvRwZi2U9TUt6Cf0IRKcgbE2vyR4FS1IrUL/w1FY=";
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/outscale/octl/pkg/version.Version=v${version}"
    "-X=k8s.io/component-base/version.gitVersion=v1.36.2+octl"
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
    description = "Modern CLI for Outscale";
    homepage = "https://github.com/outscale/octl";
    changelog = "https://github.com/outscale/octl/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [];
    mainProgram = "octl";
  };
}
