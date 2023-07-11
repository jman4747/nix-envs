# this file won't be in the git repo normally

{ pkgs ? import <nixpkgs> {}
}:

pkgs.mkShell {
    name="dev-environment";
    nativeBuildInputs = [
        pkgs.lld_16
        pkgs.cargo
        pkgs.rustc
        pkgs.cargo-watch
        pkgs.cargo-tarpaulin
        pkgs.cargo-audit
        pkgs.clippy
        pkgs.llvmPackages_rocm.bintools
        pkgs.llvmPackages_rocm.clang
        pkgs.libclang
        # Optional:
        # pkgs.openssl # some web related things (e.g. reqwest) need openssl
    ];

    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    LIBCLANG_PATH = pkgs.lib.makeLibraryPath [ pkgs.llvmPackages_latest.libclang.lib ];

    shellHook = ''
        echo "default rust dev environment"
        echo "run: cargo watch -x check -x test -x run"
    '';

}

