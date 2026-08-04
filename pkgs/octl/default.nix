{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
}:
buildGo126Module rec {
  pname = "octl";
  version = "0.0.30";

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "octl";
    rev = "v${version}";
    hash = "sha256-YSdn0wULGwv6jdThUa9q7uSLC59R8AAfZzB2QHNbA9U=";
  };

  vendorHash = "sha256-3U4zYxTF3UamE5pWR0cBkymIYX+r7HzxOnhx5dwcS1U=";
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
