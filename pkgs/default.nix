pkgs: {
  oapi-cli = pkgs.callPackage ./oapi-cli {};
  terraform-providers.outscale_outscale = pkgs.callPackage ./terraform-provider-outscale {};
  oks-cli = pkgs.callPackage ./oks-cli {};
  octl = pkgs.callPackage ./octl {};
}
