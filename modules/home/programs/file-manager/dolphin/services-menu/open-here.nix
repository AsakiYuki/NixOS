{
  lib,
  hmconfig,
  osconfig,
  ...
}: {
  services-menu.open-here = lib.mergeAttrsList (
    let
      cfg = hmconfig.programs;
    in [
      {
        "Desktop Entry" = {
          Type = "Service";
          ServiceTypes = "KonqPopupMenu/Plugin";
          MimeType = "inode/directory";
          "X-KDE-Submenu" = "Open here";
          "X-KDE-Priority" = "TopLevel";
          Actions = lib.join ";" [
            (lib.optionalString cfg.vscode.enable "RunCodeDir")
            (lib.optionalString (cfg.vscodium.enable) "RunCodeDir")
            (lib.optionalString (cfg.ghostty.enable && (!osconfig.device.de.kdePlasma.enable)) "RunGhosttyDir")
            (lib.optionalString cfg.nixvim.enable "RunNvimDir")
            (lib.optionalString cfg.antigravity.enable "RunAntigravityDir")
            (lib.optionalString (cfg.zed-editor.enable) "RunZedDir")
          ];
        };
      }

      (lib.optionalAttrs cfg.vscode.enable {
        "Desktop Action RunCodeDir" = {
          Name = "Open with Code";
          Icon = "vscode";
          Exec = "code \"%F\"";
        };
      })

      (lib.optionalAttrs cfg.vscodium.enable {
        "Desktop Action RunCodeDir" = {
          Name = "Open with VSCodium";
          Icon = "vscodium";
          Exec = "codium \"%F\"";
        };
      })

      (lib.optionalAttrs (cfg.ghostty.enable && (!osconfig.device.de.kdePlasma.enable)) {
        "Desktop Action RunGhosttyDir" = {
          Name = "Open Ghostty here";
          Icon = "com.mitchellh.ghostty";
          Exec = "ghostty +new-window --working-directory=\"%F\"";
        };
      })

      (lib.optionalAttrs (cfg.zed-editor.enable) {
        "Desktop Action RunZedDir" = {
          Name = "Open with Zed";
          Icon = "zed";
          Exec = "zeditor \"%F\"";
        };
      })

      (lib.optionalAttrs cfg.nixvim.enable {
        "Desktop Action RunNvimDir" = {
          Name = "Open with Nvim";
          Icon = "nvim";
          Exec = "ghostty +new-window --working-directory=\"~/.config\" -e nvim .";
        };
      })

      (lib.optionalAttrs cfg.antigravity.enable {
        "Desktop Action RunAntigravityDir" = {
          Name = "Open with Antigravity IDE";
          Icon = "antigravity-ide";
          Exec = "antigravity-ide \"%F\"";
        };
      })
    ]
  );
}
