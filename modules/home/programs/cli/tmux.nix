{
  pkgs,
  osconfig,
  ...
}: let
  cfg = osconfig.device.theme.catppuccin;

  TOP_PANEL = ''
    set -g pane-border-status top
    set -g pane-border-lines single
    set -g pane-border-indicators colour

    set -g pane-border-format "#{E:@module-icon} #{pane_index} #{E:@module-text} #{pane_current_command}:#{pane_current_path} #[default]"
  '';

  OPTIONS = ''
    set-option -g destroy-unattached on
    set -g allow-passthrough on
  '';

  BINDS = ''
    unbind r
    bind r source-file ~/.config/tmux/tmux.conf;
  '';

  EXTRA_CONFIG = ''
    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi V send-keys -X select-line
    bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
    bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
  '';
in {
  programs.tmux = {
    keyMode = "vi";
    disableConfirmationPrompt = true;
    prefix = "c-s";

    extraConfig = TOP_PANEL + OPTIONS + BINDS + EXTRA_CONFIG;

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = yank;
        extraConfig = ''
          set -g @yank_selection 'primary'
          set -g @yank_selection_mouse 'primary'
        '';
      }
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor '${cfg.flavor}'
          set -ogq @module-icon "#[bg=#{E:@thm_${cfg.accent}},fg=#{E:@thm_surface_0}]"
          set -ogq @module-text "#[bg=#{E:@thm_surface_0},fg=#{E:@thm_fg}]"
        '';
      }
      {
        plugin = cpu;
        extraConfig = ''
          set -g status-justify "centre"

          set -g window-status-format "#{E:@module-icon} #I #{E:@module-text} #W "
          set -g window-status-current-format "#{E:@module-icon} #I #{E:@module-text} #W "

          set -gg status-left "#{E:@module-text} %A %d/%m/%Y #[default] "
          set -ag status-left "#{E:@module-text} %I:%M %p #[default] "
          set -g status-left-length 100

          set -g status-right "#{E:@module-icon}  #{E:@module-text} #S #[default] "
          set -ag status-right "#{E:@module-icon} CPU #{E:@module-text} #{cpu_percentage} #[default] "
          set -ag status-right "#{E:@module-icon} RAM #{E:@module-text} #{ram_percentage} "
          set -g status-right-length 100

          setw -g automatic-rename off
        '';
      }
      {
        plugin = tmux-sessionx;
        extraConfig = ''
          set -g @sessionx-bind 'Tab'
          set -g @sessionx-filter-current 'false'
          set -g @sessionx-zoxide-mode 'on'
        '';
      }
    ];
  };
}
