{ config, pkgs, lib, ... }:

{
  nixpkgs.config = {
    # Override stdenv to use Musl
    stdenv = pkgs.stdenvAdapters.overrideCC (pkgs.gcc.override { libc = pkgs.musl; });

    # Set Musl as the libc
    libc = pkgs.musl;
  };

  # Ensure the system stays compatible with key packages
  nixpkgs.overlays = [
    (self: super: {
      glibcDependentPackage = super.glibcDependentPackage.override {
        stdenv = super.stdenv; # Use default stdenv with glibc
      };
    })
  ];

}

