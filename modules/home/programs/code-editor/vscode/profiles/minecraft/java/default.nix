{unstable, ...}: {
  imports = [
    ../../_lang/json
    ../../_lang/java
  ];

  extensions = with unstable.vscode-extensions; [
    jannisx11.snowstorm
    zz5840.minecraft-lang-colorizer
    stevertus.mcscript
    minecraftcommands.syntax-mcfunction
  ];
}
