# User-level configuration (home-manager): CLI tools, shell, git, app configs.
{
  config,
  pkgs,
  me,
  ...
}:

let
  # Link straight into this repo (not the read-only Nix store), so apps that
  # write their own config — Karabiner's settings window — save into the repo.
  repo = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/${path}";
in
{
  home.username = me.username;
  home.homeDirectory = "/Users/${me.username}";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    nodejs
  ];

  ## Shell -------------------------------------------------------------------

  programs.zsh = {
    enable = true;
    # Grey suggestions from history (press → to accept).
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    # Homebrew's PATH, MANPATH and completions (was the old ~/.zprofile).
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

  ## Git ---------------------------------------------------------------------

  programs.git = {
    enable = true;
    settings.user = {
      name = me.fullName;
      email = me.email;
    };
  };

  # gh also acts as git's credential helper for github.com.
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "https";
      aliases.co = "pr checkout";
    };
  };

  ## App configs -------------------------------------------------------------

  # Caps Lock layer: WASD arrows, letter = jump to app, H/J/K/L window halves.
  # The whole directory is linked, as Karabiner recommends.
  xdg.configFile."karabiner".source = link "config/karabiner";
}
