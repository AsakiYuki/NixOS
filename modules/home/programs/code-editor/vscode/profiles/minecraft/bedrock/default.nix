{unstable, ...}: {
  imports = [
    ../../_lang/json
    ../../_lang/nodejs
  ];

  extensions = with unstable.vscode-extensions; [
    stevertus.mcscript
    jannisx11.snowstorm
    mojang-studios.minecraft-debugger
    zz5840.minecraft-lang-colorizer
    minecraftcommands.syntax-mcfunction
    blockceptionltd.blockceptionvscodeminecraftbedrockdevelopmentextension
  ];
}
