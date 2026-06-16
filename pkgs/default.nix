pkgs: {
  terraform-providers.outscale_outscale = pkgs.callPackage ./terraform-provider-outscale {};
  oks-cli = pkgs.callPackage ./oks-cli {};
  octl = pkgs.callPackage ./octl {};
}
