{
  rustPlatform,
  src,
  name,
  vulkan-loader,
  vulkan-headers,
  libxkbcommon,
  xkeyboard_config,

  pkg-config,
  makeWrapper,

  openxr-loader,
  wayland,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  inherit src name;
  cargoLock = {
    lockFile = (src + "/Cargo.lock");
    allowBuiltinFetchGit = true;
  };

  postFixup = ''
    patchelf $out/bin/stardust-xr-server --add-rpath ${vulkan-loader}/lib
    patchelf $out/bin/stardust-xr-server --add-rpath ${openxr-loader}/lib
    patchelf $out/bin/stardust-xr-server --add-rpath ${libxkbcommon}/lib

    wrapPrograrm $out/bin/stardust-xr-server \
      --set XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb"
  '';

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    vulkan-loader
    vulkan-headers
    openxr-loader
    wayland
    alsa-lib
  ];
}
