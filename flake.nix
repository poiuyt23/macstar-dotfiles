{
  description = "Macstar system Darwin Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";    
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
      };
   };

  outputs = inputs@{ self, nix-darwin, nixpkgs, mac-app-util, home-manager, nix-homebrew, homebrew-core, homebrew-cask, ... }:
  let
    configuration = { pkgs,config, python313Packages, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [ mkalias 
          wget
          neovim
          neofetch
	  fastfetch
          btop
          curl
          lynx
	  htop
	  fortune
	  cowsay
	  mc
	  oh-my-zsh
	  nmap
	  curl
	  thefuck
	  git
	  gdu
	  scdl
	  ffmpeg
	  git
	  metasploit
    (python3.withPackages (python-pkgs: [
      python-pkgs.tkinter
      python-pkgs.qrcode
      python-pkgs.pillow
      python-pkgs.pyqrcode
      python-pkgs.pypng
    ]))

        ];

      homebrew = {
      	enable = true;
	brews = [
		"mas"
#		"http-server"
	];
	casks = [
		"discord"
		"gimp"
		"iina"
		"iterm2"
		"jordanbaird-ice"
		"multitouch"
		"onyx"
		"pearcleaner"
		"swift-quit"
		"utm@beta"
		"wireshark-app"
		"libreoffice"
		"brave-browser"
		"steam"
		"protonvpn"
		"retroarch"
		"orion"
		"cleanupbuddy"
		"ollama"
		"firefox"
#		"metasploit"
		"kitty"
	];
      	masApps = {
      		"Windows App" = 1295203466;
		"Bitdefender Virus Scanner" = 500154009;
  		"Developer" = 640199958;
  		"GarageBand" = 682658836;
  		"iMovie" = 408981434;
  		"iStatistica Pro" = 1447778660;
  		"Keynote" = 409183694;
  		"Nitro" = 1591292532;
  		"Numbers" = 409203825;
  		"Pages" = 409201541;
  		"Proton Pass for Safari" = 6502835663;
  		"Xcode" = 497799835;
		"Brotato:Premium" = 1668755109;
		#"Ubiquiti Wifiman" = 1385561119;

      	};
	onActivation.cleanup = "zap";
      };
     
     fonts.packages = [
	pkgs.nerd-fonts.jetbrains-mono
	pkgs.nerd-fonts.open-dyslexic
	];


      # Necessary for using flakes on this system.
      nix.settings.experimental-features  = [ "nix-command" "flakes" ];

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # WHD enable primary user for homebrew
      system.primaryUser = "poiuyt"; 

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      #Needed for determinate nix WHD 250926
      nix.enable = false;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#macstar
    darwinConfigurations."macstar" = nix-darwin.lib.darwinSystem {
      modules = [ 
      configuration
      mac-app-util.darwinModules.default 
      home-manager.darwinModules.home-manager
      (
	    { pkgs, config, inputs, ... }: 
            {
	    home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
            ];
          }
	)
      nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;
            # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
            enableRosetta = true;
            # User owning the Homebrew prefix
            user = "poiuyt";
	    # Automatically migrate existing Homebrew installations
            autoMigrate = true;
            # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = false;
          };
        }
        # Optional: Align homebrew taps config with nix-homebrew
        ({config, ...}: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
      ];
    };
  };
}

