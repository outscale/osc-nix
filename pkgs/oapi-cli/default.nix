{
  lib,
  stdenv,
  fetchFromGitHub,
  json_c,
  curl,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "oapi-cli";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "outscale";
    repo = "oapi-cli";
    rev = "v${version}";
    hash = "sha256-5AJT6QqHxkBkyDlTcPXSCC8szRml7//PNiJ0ZBBqKF0=";
  };

  buildInputs = [json_c curl];
  nativeBuildInputs = [pkg-config];

  buildPhase = ''
    cc -O1 -std=gnu11 -Wall -Wextra \
        -Wno-unused-function -Wno-unused-parameter \
        main.c osc_sdk.c -lm \
        `pkg-config --cflags --libs libcurl` \
        `pkg-config --cflags --libs json-c` \
        -o oapi-cli -DWITH_DESCRIPTION=1
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv oapi-cli $out/bin
  '';

  meta = {
    description = "OUTSCALE API CLI";
    homepage = "https://docs.outscale.com/fr/userguide/Installer-et-configurer-oapi-cli.html";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [];
    mainProgram = "oapi-cli";
    platforms = lib.platforms.all;
  };
}
