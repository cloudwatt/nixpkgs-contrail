# This file hqs been PARTIALLY generated by https://github.com/kamilchm/go2nix v1.2.1
{ stdenv, buildGoPackage, fetchgit, libxml2, pkgconfig }:

buildGoPackage rec {
  name = "contrail-introspect-cli-${version}";
  version = "2017-11-22";
  rev = "f441fcd59725b667f1b62acd2ba1fffe873d5c5e";

  buildInputs = [ libxml2 pkgconfig ];

  goPackagePath = "github.com/nlewo/contrail-introspect-cli";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/nlewo/contrail-introspect-cli.git";
    sha256 = "0165j2413q5n2v1mzlzp61k3li75i2vb5f1q1ihanfckpw9h56hq";
  };

  goDeps = ./deps.nix;
}
