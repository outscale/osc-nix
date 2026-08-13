{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:
buildGo126Module rec {
  pname = "terraform-provider-outscale";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "terraform-provider-outscale";
    rev = "v${version}";
    hash = "sha256-3ug2hOYSBpxwGY2cRaDmwOKrtcqgvx5+hxTaqJJmvbg";
  };

  vendorHash = "sha256-RNSo5NIKdqIjsqe9U/TD+OD/GYixhhdXLPc5Z3z2JWQ";

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
