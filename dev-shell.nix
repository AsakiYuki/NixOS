{...}: {
  devShells.x86_64-linux.default = {
    shellHook = ''
      echo "Welcome to the devShell!"
    '';
  };
}
