{...}: {
  users.groups = {
    gitea-runner = {};
    public = {
      members = ["nextcloud"];
    };
    forgejo = {};
    host = {
      members = ["asakiyuki"];
    };
    mc-bedrock = {
      members = ["asakiyuki"];
    };
  };
}
