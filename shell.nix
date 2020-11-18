let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  buildInputs = [
    pkgs.nodejs-14_x
    # to compile node package
    pkgs.autoconf

    pkgs.awscli
  ];
}
