{ pkgs, ... }:
let
    TOP_PANEL = ''
        set -g pane-border-status top
        set -g pane-border-lines single
        set -g pane-border-indicators colour

        set -g pane-border-format "#{E:@asa-module-icon} #{pane_index} #{E:@asa-module-text} #{pane_current_path} #[default]"
    '';

    OPTIONS = ''
        set-option -g destroy-unattached on
    '';

    BINDS = ''
        unbind r
        bind r source-file ~/.config/tmux/tmux.conf;
    '';

    BOTTOM_PANEL = ''
        set -g status-justify "centre"
         
        set -g window-status-format "#{E:@asa-module-icon} #I #{E:@asa-module-text} #W "
        set -g window-status-current-format "#{E:@asa-module-icon} #I #{E:@asa-module-text} #W "

        set -gg status-left "#{E:@asa-module-text} %A %d/%m/%Y #[default] "
        set -ag status-left "#{E:@asa-module-text} %I:%M %p #[default] "
        set -g status-left-length 100

        set -g status-right "#{E:@asa-module-icon}  #{E:@asa-module-text} #S #[default] "
        set -ag status-right "#{E:@asa-module-icon} CPU #{E:@asa-module-text} #{cpu_percentage} #[default] "
        set -ag status-right "#{E:@asa-module-icon} RAM #{E:@asa-module-text} #{ram_percentage} "
        set -g status-right-length 100

        setw -g automatic-rename off
    '';

    CATPPUCCIN = ''
        set -g @catppuccin_flavor 'mocha'
        set -ogq @asa-module-icon "#[bg=#{E:@thm_sapphire},fg=#{E:@thm_surface_0}]"
        set -ogq @asa-module-text "#[bg=#{E:@thm_surface_0},fg=#{E:@thm_fg}]"
    '';
in
{
    programs.tmux = {
        enable = true;
        keyMode = "vi";
        disableConfirmationPrompt = true;

        extraConfig = TOP_PANEL + OPTIONS + BINDS; 

        plugins = with pkgs.tmuxPlugins; [
            {
                plugin = catppuccin;
                extraConfig = CATPPUCCIN;
            }
            {
                plugin = cpu;
                extraConfig = BOTTOM_PANEL;
            }
        ];
    };
}