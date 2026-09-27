{unstable-pkgs, ...}: {
  extensions = with unstable-pkgs.vscode-extensions; [
    # openai.chatgpt
    # openai.codex-audio
    google.google-antigravity
  ];

  userSettings = {
    "antigravity.enableTelemetry" = false;
  };
}
