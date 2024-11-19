{
  description = "Full-stack Flutter + Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
          config = {
            allowUnfree = true;
          };
        };
        
        # Rust toolchain
        rustToolchain = pkgs.rust-bin.stable.latest.default;

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Flutter dependencies
            flutter
            dart
            cmake
            ninja
            pkg-config
            gtk3
            pcre
            google-chrome  # For web development

            # Rust dependencies
            rustToolchain
            cargo
            rustc
            rust-analyzer
            pkg-config
            openssl.dev

            # Development tools
            git
            gh # GitHub CLI
          ];

          shellHook = ''
            echo "🚀 Welcome to the Flutter + Rust development environment!"
            echo "📱 Flutter $(flutter --version | head -n 1)"
            echo "⚙️  Rust $(rustc --version)"
          '';

          # Environment variables
          RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
        };
      });
} 