{ ... }@inputs: (import ./mkFuncs.nix inputs) // {
    root = path: ../. + path;
}