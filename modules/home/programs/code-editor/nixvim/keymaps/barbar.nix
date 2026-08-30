[
  {
    mode = "n";
    key = "<A-,>";
    action = "<cmd>BufferPrevious<CR>";
    options.silent = true;
  }
  {
    mode = "n";
    key = "<A-.>";
    action = "<cmd>BufferNext<CR>";
    options.silent = true;
  }
  {
    mode = "n";
    key = "<A-<>";
    action = "<cmd>BufferMovePrevious<CR>";
    options.silent = true;
  }
  {
    mode = "n";
    key = "<A->>";
    action = "<cmd>BufferMoveNext<CR>";
    options.silent = true;
  }
  {
    mode = "n";
    key = "<A-c>";
    action = "<Cmd>BufferClose<CR>";
    options.silent = true;
  }
]
++ (builtins.genList (i: {
  mode = "n";
  key = "<A-${toString (i + 1)}>";
  action = "<cmd>BufferGoto ${toString (i + 1)}<CR>";
  options.silent = true;
}) 9)
