{
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

  nix.enable = false;

  system.stateVersion = 6;
  system.primaryUser = me.username;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  users.users.${me.username}.home = "/Users/${me.username}";

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs hostName me; };
    users.${me.username} = import ./home.nix;
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = false;
    user = me.username;
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
      cleanup = "none";
    };

    brews = [
      "mas"
      "cocoapods"
      "watchman"
      "felixkratz/formulae/sketchybar"
    ];

    casks = [
      "alt-tab"
      "autoraiseapp"
      "hiddenbar"
      "karabiner-elements"
      "raycast"
      "rectangle"

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

    masApps = {
      "DaVinci Resolve" = 571213070;
      "Xcode" = 497799835;
      "TestFlight" = 899247664;
    };
  };

  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
    };

    spaces.spans-displays = false;

    dock = {
      mru-spaces = false;
    };

    CustomUserPreferences = {
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

      "com.sbmpost.AutoRaise" = {
        enableOnLaunch = true;
        autoRaiseDelay = 20;
        pollMillis = 20;
        mouseDelta = 5.0;
      };

      "com.lwouis.alt-tab-macos" = {
        screensToShow = "1";
      };

      "com.dwarvesv.minimalbar" = {
        isShowPreferences = false;
      };
    };
  };
}
