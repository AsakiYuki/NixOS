{ pkgs, ... }:
let
    EXTRA_PLUGINS = [
        ./extra/neocord.nix
        ./extra/mini-icons.nix
    ];

    LUA = [
        ./lua/neocord.lua
    ];
in
{
    programs.nixvim = {
        extraPlugins = map (path: import path { plugins = pkgs.vimPlugins; }) EXTRA_PLUGINS;
        extraConfigLua = builtins.concatStringsSep "\n" (map builtins.readFile LUA);
    };
}