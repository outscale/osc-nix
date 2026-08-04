{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:
buildGo126Module rec {
  pname = "terraform-provider-outscale";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "terraform-provider-outscale";
    rev = "v${version}";
    hash = "sha256-zMr+lhJRnGwwAu5NnBiiOgKypxuT0VRyOUsph9z3cdI=";
  };

  vendorHash = "sha256-tBBWxwMgYf6et0e2DAkq47386SnWDIA2OZCtSaeoKAM=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Move the provider to libexec
  postInstall = ''
    dir=$out/libexec/terraform-providers/registry.terraform.io/outscale/outscale/${version}/''${GOOS}_''${GOARCH}
    mkdir -p "$dir"
    mv $out/bin/* "$dir/terraform-provider-outscale_${version}"
    rmdir $out/bin
  '';

  doCheck = false;

  meta = {
    description = "Terraform provider for managing OUTSCALE resources";
    homepage = "https://registry.terraform.io/providers/outscale/outscale/latest/docs";
    changelog = "https://github.com/outscale/terraform-provider-outscale/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [];
    mainProgram = "terraform-provider-outscale";
  };
}
