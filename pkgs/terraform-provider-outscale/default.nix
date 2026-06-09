{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "terraform-provider-outscale";
  version = "1.3.0-alpha.2";

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "terraform-provider-outscale";
    rev = "v${version}";
    hash = "sha256-gsi2iJ1H/MyT1+Gq0DKa8WzOdFL+sJdsdFQDfMg600k=";
  };

  vendorHash = "sha256-7IhN7A4GRnJXi5nlYtGIMk2Qnq86y6PDX6PasZPnDT4=";

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
