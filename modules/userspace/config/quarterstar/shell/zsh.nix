# Modified version of: https://tesar.tech/blog/2024-10-21_nix_os_zsh_autocomplete

{ config, profile, pkgs, ... }:

{
  home.packages = with pkgs; [
    oh-my-posh
    git
  ];

  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "zsh-autocomplete"; # completes history, commands, etc.
        src = pkgs.fetchFromGitHub {
          owner = "marlonrichert";
          repo = "zsh-autocomplete";
          rev = "762afacbf227ecd173e899d10a28a478b4c84a3f";
          sha256 = "1357hygrjwj5vd4cjdvxzrx967f1d2dbqm2rskbz5z1q6jri1hm3";
        }; # e.g., nix-prefetch-url --unpack https://github.com/marlonrichert/zsh-autocomplete/archive/762afacbf227ecd173e899d10a28a478b4c84a3f.tar.gz
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "z" ];
      extraConfig = ''
        # Required for autocomplete with box: https://unix.stackexchange.com/a/778868
        zstyle ':completion:*' completer _expand _complete _ignored _approximate _expand_alias
        zstyle ':autocomplete:*' default-context curcontext 
        zstyle ':autocomplete:*' min-input 0

        setopt HIST_FIND_NO_DUPS

        autoload -Uz compinit
        compinit

        setopt autocd  # cd without writing 'cd'
        setopt globdots # show dotfiles in autocomplete list
      '';
    };

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
    };

    # Extra configurations for Zsh
    initExtra = ''
      # Oh-My-Posh initialization for Zsh
      eval "$(oh-my-posh init zsh --config /etc/nixos/config/quarterstar/shell/zsh/posh/shell.omp.json)"

      # zsh-autocomplete
      bindkey -M menuselect '^M' .accept-line # run code when selected completion
        '';
  };
}
