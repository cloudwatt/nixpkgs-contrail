# DO NOT EDIT
# This file has been generated by
# $ /home/eon/vcs/nixpkgs-tungsten/tools/sources.sh /home/eon/vcs/nixpkgs-tungsten/tools/sources-R4.1.lst

{pkgs}:
{
  # Head of branch R4.1 of repository github.com/Juniper/contrail-build at 2019-08-02 11:01:55
  build = pkgs.fetchFromGitHub {
    name = "build";
    owner = "Juniper";
    repo = "contrail-build";
    rev = "b3e213e479619978b033b2006bb1be55e268e216";
    sha256 = "0cr3wc8s1yf2827nwmlc8jw4wdi4hw0nchq43rnpgpkmw04j9abh";
  };
  # Head of branch R4.1 of repository github.com/Juniper/contrail-controller at 2019-08-02 11:01:56
  controller = pkgs.fetchFromGitHub {
    name = "controller";
    owner = "Juniper";
    repo = "contrail-controller";
    rev = "4ab9a1729e6f084e06407331969300c51eefe6fb";
    sha256 = "1831yhrzz0gby7z9wpl8g0zj1bdv7gsyfv9pkl4ilgphdziwrdjw";
  };
  # Head of branch R4.1 of repository github.com/Juniper/contrail-generateds at 2019-08-02 11:02:43
  generateds = pkgs.fetchFromGitHub {
    name = "generateds";
    owner = "Juniper";
    repo = "contrail-generateds";
    rev = "558f075c5057c7130290267dd274118fe6224b81";
    sha256 = "0g0z242r1a3agqkxbarz9gr284ik4jxxy0zyb0wyyviddv5nffhs";
  };
  # Head of branch R4.1 of repository github.com/Juniper/contrail-neutron-plugin at 2019-08-02 11:02:44
  neutronPlugin = pkgs.fetchFromGitHub {
    name = "neutronPlugin";
    owner = "Juniper";
    repo = "contrail-neutron-plugin";
    rev = "40ad78c635a28f24ef0fcf1a89f5817a59507ded";
    sha256 = "1f8hi1z860b95jcdjj2ylnn41sd76cz44v7bhjwh2nfmi09kqryf";
  };
  # Head of branch R4.1 of repository github.com/Juniper/contrail-sandesh at 2019-08-02 11:02:46
  sandesh = pkgs.fetchFromGitHub {
    name = "sandesh";
    owner = "Juniper";
    repo = "contrail-sandesh";
    rev = "ac8dfdcd26abbcd2886833331f6eebf37d35f04a";
    sha256 = "0j8frk5094sgvnivwhs5zx1vv96vir66sz17am70r3gq5h7hmjvv";
  };
  # Head of branch R4.1 of repository github.com/Juniper/contrail-third-party at 2019-08-02 11:02:47
  thirdParty = pkgs.fetchFromGitHub {
    name = "thirdParty";
    owner = "Juniper";
    repo = "contrail-third-party";
    rev = "ddc576e9c037e1ccc0e297a64ce92e4bedf95d63";
    sha256 = "07vq2gcqj3l450jj8fvz5zzslj8dxqpiyb3fs4ncqb2ayjaqxzlc";
  };
  # Head of branch R4.1 of repository github.com/Juniper/contrail-vrouter at 2019-08-02 11:02:48
  vrouter = pkgs.fetchFromGitHub {
    name = "vrouter";
    owner = "Juniper";
    repo = "contrail-vrouter";
    rev = "ca21f51600a04d6f7a16981a7a8b280aa539b9c7";
    sha256 = "1kjnv1fdc1g08wrmd9lh7jx0yp8g96dghcwcjsan3im2ybnxbi3x";
  };
}
