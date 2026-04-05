{ pkgs, ... }:
let
    EXTRA_PLUGINS = [
        ./extras/neocord.nix
        ./extras/mini-icons.nix
    ];

    LUA = [
        ./lua/neocord.lua
    ];
in
{
    extraPlugins = map (path: import path { plugins = pkgs.vimPlugins; }) EXTRA_PLUGINS;
    extraConfigLua = builtins.concatStringsSep "\n" (map builtins.readFile LUA);
}