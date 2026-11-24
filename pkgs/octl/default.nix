{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
}:
buildGo127Module rec {
  pname = "octl";
  version = "0.0.36";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "octl";
    rev = "v${version}";
    hash = "sha256-hx5ZVx/6w7Vs6yO/F0PIxeNo+96APxbsYpKpwJWTMsQ=";
  };

  vendorHash = "sha256-sPexXQp0iDXVHuFEYNRQCJl75+8ZppVWDXmGhe55F9M=";

  checkFlags = let
    # Tests that either network connection and/or OUTSCALE credentials
    skipedTests = [
      "TestIAASAPI"
      "TestIAASAliases"
      "TestIAASCRUD"
      "TestBase64File"
      "TestPolicyFile"
      "TestPolicyString"
      "TestIAASPipe"
      "TestWaitFor"
      "TestReadCatalog"
      "TestReadConsumption"
      "TestReadConsumptionAggregate"
      "TestFilterNullValues"
      "TestReverse"
      "TestVolumeByDeviceName"
      "TestSecurityGroupRules"
      "TestKube"
      "TestMetadata"
      "TestProfilePriority"
      "TestStorageCRUD"
      "TestObjectDownload"
      "TestBucketVersioning"
      "TestBucketEncryption"
      "TestBucketCORS"
      "TestBucketPolicy"
      "TestBucketWebsite"
      "TestBucketLifecycle"
      "TestBucketACL"
      "TestObjectACL"
      "TestObjectTagging"
      "TestPresign"
      "TestUpdateRealReleaseMutation"
    ];
  in ["-skip=^${builtins.concatStringsSep "$|^" skipedTests}$"];

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
