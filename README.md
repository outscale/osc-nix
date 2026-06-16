## Outscale Tools for Nix

[![Project Stage](https://docs.outscale.com/fr/userguide/_images/Project-Sandbox-yellow.svg)](https://docs.outscale.com/en/userguide/Open-Source-Projects.html) [![](https://dcbadge.limes.pink/api/server/HUVtY5gT6s?style=flat&theme=default-inverted)](https://discord.gg/HUVtY5gT6s)

---

## 🌐 Links

- Documentation: <https://docs.outscale.com/en/>
- Project website: <https://github.com/outscale/osc-nix>
- Join our community on [Discord](https://discord.gg/HUVtY5gT6s)

---

## 📄 Table of Contents

- [Overview](#-overview)
- [Available Packages](#-available-packages)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [License](#-license)
- [Contributing](#-contributing)

---

## 🧭 Overview

**Outscale Tools for Nix** is a [Nix flake](https://nixos.wiki/wiki/Flakes) that provides Outscale CLI tools and the Terraform provider as Nix packages.

Key features:
- Overlay for seamless integration into your NixOS or home-manager configuration
- Dev shell with Terraform (Outscale provider) and `octl` ready to use

---

## 📦 Available Packages

| Package | Description |
| ------- | ----------- |
| `octl` | Modern CLI for Outscale |
| `oks-cli` | Deploy and manage Kubernetes clusters on OUTSCALE |
| `terraform-provider-outscale` | Terraform provider for managing OUTSCALE resources |

---

## ✅ Requirements

- [Nix](https://nixos.org/download.html) (any recent version)
- [Flakes enabled](https://nixos.wiki/wiki/Flakes#Enable_flakes) — only needed for `nix run`, `nix shell`, `nix profile`, `nix develop`, and flake inputs
- Access to the OUTSCALE API (with appropriate credentials)

---

## ⚙ Installation

### Flake users

#### Run once (no install)

```bash
nix run github:outscale/osc-nix#octl -- iaas vm list
nix run github:outscale/osc-nix#oks-cli -- project list
```

#### Temporary shell

Drops you into a shell with the tools on `$PATH` — gone after you `exit`.

```bash
nix shell github:outscale/osc-nix#octl github:outscale/osc-nix#oks-cli
```

#### Persistent install

Adds the package to your Nix profile; survives reboots and garbage collection.

```bash
nix profile install github:outscale/osc-nix#octl
nix profile install github:outscale/osc-nix#oks-cli
```

List what you have installed:

```bash
nix profile list
```

#### Dev shell (all tools)

Terraform with Outscale provider + `octl` in a single shell.

```bash
nix develop github:outscale/osc-nix
```

#### Add to your own flake

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    outscale.url = "github:outscale/osc-nix";
  };

  outputs = { nixpkgs, outscale, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ outscale.overlays.outscale ];
    };
  in {
    # pkgs.octl, pkgs.oks-cli, pkgs.terraform-providers.outscale_outscale
  };
}
```

#### NixOS / home-manager module

```nix
{ inputs, ... }: {
  nixpkgs.overlays = [ inputs.outscale.overlays.outscale ];
  environment.systemPackages = [ pkgs.octl pkgs.oks-cli ];
}
```

### Non-flake users

This repo ships `default.nix` and `shell.nix` via [flake-compat](https://github.com/NixOS/flake-compat). No flakes required.

#### Build

```bash
nix-build
```

Built packages land in `./result`.

#### Enter a shell with all tools

```bash
nix-shell
```

This is equivalent to `nix develop` — gives you terraform (with Outscale provider) and `octl`.

#### Install with nix-env

```bash
nix-env -if . -A octl
nix-env -if . -A oks-cli
```

---

## 📜 License

**Outscale Tools for Nix** is released under the BSD 3-Clause license.

© 2025 Outscale SAS

See [LICENSE](./LICENSE) for full details.

---

## 🤝 Contributing

We welcome contributions!

Please read our [Contributing Guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) before submitting a pull request.
