{ config, pkgs, ... }:

{
  home.username = "willy";
  home.homeDirectory = "/home/willy";

  # Idea: put all the personal files and sensitive values in a mountable volume.  So the computer can be used casually be dewfault, and if keyboard, unlocked for work.

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  #xresources.properties = {
  #  "Xcursor.size" = 16;
  #  "Xft.dpi" = 172;
  #};

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };

  # Services
  services = {
    syncthing.enable = true;
    syncthing.tray.enable = true;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    bottom  # resource monitor
    btop  # replacement of htop/nmon
    devenv
    dnsutils  # `dig` + `nslookup`
    ethtool
    fzf  # A command-line fuzzy finder
    gnutar
    iftop  # network monitoring
    iotop  # io monitoring
    iperf3  # Speed test tool
    jq  # A lightweight and flexible command-line JSON processor
    k9s
    kubectl
    ldns  # replacement of `dig`, it provide the command `drill`
    lm_sensors  # for `sensors` command
    lsof  # list open files
    ltrace  # library call monitoring
    gnomeExtensions.appindicator  # app icon system tray
    magic-wormhole
    mtr  # A network diagnostic tool
    nix-output-monitor
    nmap  # A utility for network discovery and security auditing
    opentofu
    pciutils  # lspci
    pstree
    ripgrep  # recursively searches directories for a regex pattern
    strace  # system call monitoring
    sysstat
    talosctl
    texlive.combined.scheme-medium
    tree
    unzip
    usbutils  # lsusb
    xz
    zip
    zstd
  ];

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 11;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
      terminal.shell = {
        args = ["-l" "-c" "${pkgs.tmux}/bin/tmux"];
        program = "${pkgs.fish}/bin/fish";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "William Weiskopf";
    userEmail = "william@weiskopf.me";
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shortcut = "a";
    terminal = "tmux-256color";
    historyLimit = 100000;
    extraConfig = ''
      # Bind "prefix" for summoning tmux to Ctrl-a
      set-option -g prefix C-a

      # Default shell
      set-option -g default-shell ${pkgs.fish}/bin/fish
      
      # We're 256 color ready
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      
      # Turn on mouse mode
      set -g mouse on
      
      # Start numbering windows from 1
      set -g base-index 1
      
      # Set the Window titles based on what's open in tmux
      set-option -g set-titles on
      
      # Increase scrollback history limit
      set-option -g history-limit 5000
      
      # reload config file
      bind r source-file ~/.tmux.conf
      
      # Pane navigation
      ### Consider: tmux-pain-control plugin instead
      ## pane_navigation_bindings
      bind h   select-pane -L
      bind C-h select-pane -L
      bind j   select-pane -D
      bind C-j select-pane -D
      bind k   select-pane -U
      bind C-k select-pane -U
      bind l   select-pane -R
      bind C-l select-pane -R
      
      ## window_move_bindings
      bind -r "<" swap-window -t -1
      bind -r ">" swap-window -t +1
      
      ## pane_resizing_bindings
      bind -r H resize-pane -L 2
      bind -r J resize-pane -D 2
      bind -r K resize-pane -U 2
      bind -r L resize-pane -R 2
      
      ## pane_split_bindings
      bind "|" split-window -h -c "#{pane_current_path}"
      bind "\\" split-window -fh -c "#{pane_current_path}"
      bind "-" split-window -v -c "#{pane_current_path}"
      bind "_" split-window -fv -c "#{pane_current_path}"
      bind "%" split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"
      
      ## improve_new_window_binding
      bind "c" new-window -c "#{pane_current_path}"
      
      # copy/paste
      set-window-option -g mode-keys vi
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
