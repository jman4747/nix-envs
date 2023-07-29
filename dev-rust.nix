{ nixpkgs ? import <nixpkgs> {}}:

let
# using the rust overlay to manage rust versions
rustOverlay = builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";

# This gets a specific version of nixpkgs and uses it for later pkgs
# and for the rustOverlay to use to build rust against.
pinnedPkgs = builtins.fetchTarball {
    name  = "nixpkgs-stable-23.05";
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/23.05.tar.gz";
    sha256 = "10wn0l08j9lgqcw8177nh2ljrnxdrpri7bp0g7nvrsn9rkawvlbf";
};

pkgs = import pinnedPkgs {
    overlays = [ (import rustOverlay) ];
};

in

pkgs.mkShell {
    name="dev-environment";
    nativeBuildInputs = with pkgs; [
        (rust-bin.stable.latest.default.override {
            # rust-src and rust-analysis included for the benafit of
            # rust-analyzer integration with editors
            extensions = [ "rust-src" "rust-analysis"];
        })
        rust-analyzer

        # lld is used for faster linking
        # for this to work, a .cargo/config.toml has to set:
        # build.rustflags or target.<triple> = ["-C", "link-arg=-fuse-ld=lld"]
        lld_16
        cargo-watch
        cargo-tarpaulin
        cargo-audit
        openssl
    ];

    RUST_BACKTRACE = 1;

    shellHook = ''
        echo "default rust dev environment"
        echo "run: cargo watch -x check -x test -x run"
    '';

}

