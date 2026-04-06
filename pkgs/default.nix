{ ... }@inputs:
{
    bun = import ./bun.nix inputs;
    cage-xtmapper = { version ? "0.2.0"; }: import ./cage-xtmapper-${version}.nix inputs;
    catppuccin-obs = import ./catppuccin-obs.nix inputs;
    cursors = { name ? "aemeath", size ? 48; }: import ./cursors.nix { inherit name size inputs; };
}