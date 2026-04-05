{
  config = {
    init = {
      defaultBranch = "main";
    };
    alias = { };
    safe = {
      directory = "/etc/nixos";
    };
    user = {
      email = "vantrong2007vn@gmail.com";
      name = "Asaki Yuki";
    };
    url = {
      "git@github.com:" = {
        insteadOf = [
          "gh:"
          "github:"
        ];
      };
    };
  };
}

