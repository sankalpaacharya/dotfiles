# System-level configuration (nix-darwin). User-level config lives in home.nix.
{
  pkgs,
  config,
  inputs,
  hostName,
  me,
  ...
}:

{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  ## Core --------------------------------------------------------------------

  # Determinate Nix owns the Nix install and daemon; nix-darwin must not.
  nix.enable = false;

  system.stateVersion = 6;
  system.primaryUser = me.username;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  users.users.${me.username}.home = "/Users/${me.username}";

  # sudo via Touch ID (`just switch` needs sudo).
  security.pam.services.sudo_local.touchIdAuth = true;

  programs.zsh.enable = true;

  ## Home Manager ------------------------------------------------------------

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Existing files in the way (e.g. ~/.zshrc) are renamed, not overwritten.
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs hostName me; };
    users.${me.username} = import ./home.nix;
  };

  ## Homebrew ----------------------------------------------------------------
  # GUI apps stay Homebrew casks: they self-update and live in /Applications.
  # CLI tools come from nixpkgs (home.nix).

  nix-homebrew = {
    enable = true;
    enableRosetta = false;
    user = me.username;
    # Adopt the existing /opt/homebrew on first switch.
    autoMigrate = true;
    mutableTaps = true;
    taps = { };
  };

  homebrew = {
    enable = true;
    taps = [
      "dimentium/autoraise"
      "felixkratz/formulae"
    ];

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # "none" while the app list settles. Switch to "uninstall" once it's
      # complete: anything not listed here then gets removed on switch.
      cleanup = "none";
    };

    brews = [
      "mas" # brew bundle uses it for masApps
      "cocoapods"
      "watchman"
      "felixkratz/formulae/sketchybar"
    ];

    casks = [
      # Window management + keyboard (see CustomUserPreferences below)
      "alt-tab"
      "autoraiseapp"
      "hiddenbar"
      "karabiner-elements"
      "raycast"
      "rectangle"

      # Everyday apps
      "arc"
      "aside"
      "bb"
      "bitwarden"
      "claude"
      "claude-code"
      "codex"
      "codex-app"
      "discord"
      "docker-desktop"
      "ghostty"
      "stats"
      "t3-code"
      "visual-studio-code"
      "vlc"
      "whatsapp"
      "zed"

      "font-jetbrains-mono-nerd-font"
    ];

    # Needs an App Store sign-in; skipped otherwise.
    masApps = {
      "DaVinci Resolve" = 571213070;
      "Xcode" = 497799835;
      "TestFlight" = 899247664;
    };
  };

  ## macOS defaults -----------------------------------------------------------
  # Some of these only fully apply after a logout/login.

  system.defaults = {
    NSGlobalDomain = {
      # Holding a key repeats it instead of showing the accent picker.
      ApplePressAndHoldEnabled = false;
    };

    # "Displays have separate Spaces": each monitor keeps its own windows.
    spaces.spans-displays = false;

    dock = {
      # Don't reorder Spaces by most recent use.
      mru-spaces = false;
    };

    CustomUserPreferences = {
      # Rectangle: Ctrl+Opt+H/L for halves, Ctrl+Opt+Cmd+H/L to move between
      # displays (letters instead of arrows: 60% keyboard). Repeating a
      # half-command does nothing rather than throwing the window to the
      # next display. modifierFlags: ctrl+opt = 786432, +cmd = 1835008.
      "com.knollsoft.Rectangle" = {
        alternateDefaultShortcuts = true;
        subsequentExecutionMode = 2;
        leftHalf = {
          keyCode = 4;
          modifierFlags = 786432;
        };
        rightHalf = {
          keyCode = 37;
          modifierFlags = 786432;
        };
        previousDisplay = {
          keyCode = 4;
          modifierFlags = 1835008;
        };
        nextDisplay = {
          keyCode = 37;
          modifierFlags = 1835008;
        };
      };

      # AutoRaise: focus follows mouse. autoRaiseDelay is in ms and divided
      # by pollMillis, so 20/20 gives the engine `-delay 1` (no delay); 0
      # would disable raising. mouseDelta ignores small accidental moves.
      "com.sbmpost.AutoRaise" = {
        enableOnLaunch = true;
        autoRaiseDelay = 20;
        pollMillis = 20;
        mouseDelta = 5.0;
      };

      # AltTab: only list windows on the screen AltTab is shown on.
      "com.lwouis.alt-tab-macos" = {
        screensToShow = "1";
      };

      # Hidden Bar: don't open its settings window at login.
      "com.dwarvesv.minimalbar" = {
        isShowPreferences = false;
      };
    };
  };
}
