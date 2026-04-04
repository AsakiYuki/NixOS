[
    {
        mode = "n";
        key = "<C-b>";
        action = "<cmd>NvimTreeToggle<CR>";
        options.silent = true;
    }

    {
        mode = "n";
        key = "<leader>tf";
        action = ":ToggleTerm direction=float<CR>";
        options.silent = true;
        options.noremap = true;
    }
    {
        mode = "n";
        key = "<leader>th";
        action = ":ToggleTerm direction=horizontal<CR>";
        options.silent = true;
        options.noremap = true;
    }
    {
        mode = "n";
        key = "<leader>tv";
        action = ":ToggleTerm direction=vertical<CR>";
        options.silent = true;
        options.noremap = true;
    }
    {
 	mode = "t";
	key = "<esc>";
        action = "<C-\\><C-n>";
    }
]
