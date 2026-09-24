{ ... }: {
  programs.chromium = {
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=UseOzonePlatform,UseHDRTransferFunction,WaylandWindowDecorations,Vulkan"
    ];
  };
}
