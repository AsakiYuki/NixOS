{ pkgs, ... }:
let
    top_panel = ''
        set -g pane-border-status top
        set -g pane-border-lines single
        set -g pane-border-indicators colour

        set -g pane-border-format "#{e:@asa-module-icon} #{pane_index} #{e:@asa-module-text} #{pane_current_path} #[default]"
    '';

    options = ''
        set-option -g destroy-unattached on
        set -g allow-passthrough on
    '';

    binds = ''
        unbind r
        bind r source-file ~/.config/tmux/tmux.conf;
    '';

    bottom_panel = ''
        set -g status-justify "centre"
         
        set -g window-status-format "#{e:@asa-module-icon} #i #{e:@asa-module-text} #w "
        set -g window-status-current-format "#{e:@asa-module-icon} #i #{e:@asa-module-text} #w "

        set -gg status-left "#{e:@asa-module-text} %a %d/%m/%y #[default] "
        set -ag status-left "#{e:@asa-module-text} %i:%m %p #[default] "
        set -g status-left-length 100

        set -g status-right "#{e:@asa-module-icon}  #{e:@asa-module-text} #s #[default] "
        set -ag status-right "#{e:@asa-module-icon} cpu #{e:@asa-module-text} #{cpu_percentage} #[default] "
        set -ag status-right "#{e:@asa-module-icon} ram #{e:@asa-module-text} #{ram_percentage} "
        set -g status-right-length 100

        setw -g automatic-rename off
    '';

    catppuccinConfig = ''
        set -g @catppuccin_flavor 'mocha'
        set -ogq @asa-module-icon "#[bg=#{e:@thm_sapphire},fg=#{e:@thm_surface_0}]"
        set -ogq @asa-module-text "#[bg=#{e:@thm_surface_0},fg=#{e:@thm_fg}]"
    '';

    yankConfig = ''
        set -g @yank_selection 'primary'
        set -g @yank_selection_mouse 'primary'
    '';

    extraConfig = ''
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi V send-keys -X select-line
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
in
{
    programs.tmux = {
        enable = true;
        keyMode = "vi";
        disableConfirmationPrompt = true;
        prefix = "c-a";

        extraConfig = top_panel + options + binds + extraConfig; 

        plugins = with pkgs.tmuxPlugins; [
            {
                plugin = yank;
                extraConfig = yankConfig;
            }
            {
                plugin = catppuccin;
                extraConfig = catppuccinConfig;
            }
            {
                plugin = cpu;
                extraConfig = bottom_panel;
            }
        ];
    };
}
