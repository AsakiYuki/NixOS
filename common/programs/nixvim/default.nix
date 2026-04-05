{ ... }: {
    enable = true;
    vimdiffAlias = true;
    colorschemes.catppuccin.enable = true;

    opts = {
        number = true;
        relativenumber = true;
	    
	    tabstop = 4;
	    shiftwidth = 4;
	    softtabstop = 4;
        smartindent = true;
	    expandtab = true;

        clipboard = "unnamedplus";
    };
}