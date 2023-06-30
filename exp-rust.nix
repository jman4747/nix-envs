# this file won't be in the git repo normally

{ pkgs ? import <nixpkgs> {}
}:

pkgs.mkShell {
    name="dev-environment";
    buildInputs = [
        pkgs.lld_16
        pkgs.llvmPackages_rocm.llvm
        pkgs.rustup
        pkgs.rust-script
        pkgs.cargo-watch
    ];

    shellHook = ''
        echo "rust experimentation environment"
    '';

}

