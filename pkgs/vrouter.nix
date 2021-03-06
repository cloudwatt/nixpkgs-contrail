{ pkgs
, stdenv
, deps
, contrailVersion
, contrailWorkspace
}:

with pkgs.lib;

let
  sconsCmd = "scons --optimization=production --kernel-dir=$kernelSrc vrouter/vrouter.ko";
in
kernelHeaders: stdenv.mkDerivation rec {
  name = "contrail-vrouter-${kernelHeaders.name}";
  version = contrailVersion;
  src = contrailWorkspace;
  hardeningDisable = [ "pic" ];
  USER = "contrail";
  KERNEL_VERSION = getVersion kernelHeaders;
  # We switch to gcc 4.9 because gcc 5 is not supported before kernel 3.18
  buildInputs = with pkgs; [
    scons libxml2 flex_2_5_35 bison
    libelf deps.boost
  ];
  buildPhase = ''
    # We patch the kernel Makefile ONLY to reduce the closure
    # size of the vrouter kernel module. Without this patch, the
    # kernel source are referenced by the output path. See the issue
    # https://github.com/NixOS/nixpkgs/issues/34006.
    # Note this is only used with Nix kernel headers.
    cp -r ${kernelHeaders} kernel-headers
    chmod -R a+w kernel-headers
    sed -i "s|MAKEARGS := -C /nix/store/.*-linux-${KERNEL_VERSION}-dev/lib/modules/${KERNEL_VERSION}/source|MAKEARGS := -C $PWD/kernel-headers/lib/modules/${KERNEL_VERSION}/source|" kernel-headers/lib/modules/${KERNEL_VERSION}/build/Makefile || true

    kernelSrc=$(echo $PWD/kernel-headers/lib/modules/*/build/)
    ${sconsCmd}
  '';
  installPhase = ''
    mkdir -p $out/lib/modules/$KERNEL_VERSION/extra/net/vrouter/
    cp vrouter/vrouter.ko $out/lib/modules/$KERNEL_VERSION/extra/net/vrouter/
  '';
  shellHook = ''
    kernelSrc=$(echo ${kernelHeaders}/lib/modules/*/build/)
    echo "Follow these steps to build the Vrouter module for the kernel '${kernelHeaders.name}'"
    echo ""
    echo "1. Unpack the Tungsten workspace (containing all Tungsten source trees)"
    echo ""
    echo "   $ unpackPhase"
    echo "   $ cd contrail-workspace"
    echo ""
    echo "2. Run scons to build the Vrouter module"
    echo ""
    echo '  $ ${sconsCmd}'
  '';
  meta = {
    description = "Contrail vrouter kernel module for kernel ${kernelHeaders.name}";
  };
}

