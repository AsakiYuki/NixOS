{...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      init = {
        defaultBranch = "main";
      };

      alias = {
        ac = "!git add-commit ";
        acp = "!git add-commit-push ";
        fp = "!git fetch-pull";
        add-commit = "!git add . && git commit -m ";
        add-commit-push = "!fn() { git add-commit \"$1\"; git push origin HEAD; }; fn";
        fetch-pull = "!git fetch && git pull origin HEAD --rebase";
      };

      # pull = {
      #     rebase = "";
      # };
    };
  };
}
