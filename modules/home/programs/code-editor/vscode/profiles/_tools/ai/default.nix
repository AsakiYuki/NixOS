{
  unstable-pkgs,
  lib,
  editor,
  ...
}: {
  extensions = lib.mkIf (editor != "antigravity") (with unstable-pkgs.vscode-extensions; [
    openai.chatgpt
    openai.codex-audio
    google.google-antigravity
  ]);

  userSettings = {
    "antigravity.enableTelemetry" = false;
  };
}
