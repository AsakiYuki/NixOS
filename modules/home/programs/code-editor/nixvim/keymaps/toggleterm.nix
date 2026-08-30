[
  {
    mode = "t";
    key = "<esc>";
    action = "<C-\\><C-n>";
  }
  {
    mode = "t";
    key = "jk";
    action = "<C-\\><C-n>";
  }
  {
    mode = "t";
    key = "<C-w>";
    action = "<C-\\><C-n><C-w>";
  }

  {
    mode = "t";
    key = "<C-l>";
    action = "<Cmd>wincmd l<CR>";
  }
  {
    mode = "t";
    key = "<C-k>";
    action = "<Cmd>wincmd k<CR>";
  }
  {
    mode = "t";
    key = "<C-j>";
    action = "<Cmd>wincmd j<CR>";
  }
  {
    mode = "t";
    key = "<C-h>";
    action = "<Cmd>wincmd h<CR>";
  }
]
++ builtins.concatLists (
  builtins.genList (i: [
    {
      mode = "n";
      key = "<leader>th${toString (i + 1)}";
      action = ":${toString (i + 1)}ToggleTerm direction=horizontal<CR>";
      options.silent = true;
      options.noremap = true;
    }
    {
      mode = "n";
      key = "<leader>tv${toString (i + 1)}";
      action = ":${toString (i + 1)}ToggleTerm direction=vertical<CR>";
      options.silent = true;
      options.noremap = true;
    }
    {
      mode = "n";
      key = "<leader>tf${toString (i + 1)}";
      action = ":${toString (i + 1)}ToggleTerm direction=float<CR>";
      options.silent = true;
      options.noremap = true;
    }
  ])
  9
)
