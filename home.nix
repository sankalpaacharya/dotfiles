{
  config,
  pkgs,
  me,
  ...
}:

let
  repo = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/${path}";
in
{
  home.username = me.username;
  home.homeDirectory = "/Users/${me.username}";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    just
    nodejs
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv zsh)"
    '';
  };

  programs.starship.enable = true;

  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [ "--group-directories-first" ];
  };
  home.shellAliases.tree = "eza --tree --icons=auto";

  programs.git = {
    enable = true;
    settings.user = {
      name = me.fullName;
      email = me.email;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "https";
      aliases.co = "pr checkout";
    };
  };

  xdg.configFile."karabiner".source = link "config/karabiner";
}
