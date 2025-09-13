# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, nixpkgs, nixvim, ... }:
let stateVersion = "25.05"; in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--ssh=false" ];
    extraSetFlags = [ "--ssh=false" ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  services.flatpak.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wes = {
    isNormalUser = true;
    description = "Wes";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      sidequest
      discord
      lutris
      nixd
      telegram-desktop
      jujutsu
      google-chrome
      tree
      gimp3
      prusa-slicer
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU9iEeJ7tL/zm80LlNRT7BEql3uJsWNu1SOq9G0JVdX wes@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGij7rpWcW4JyLt8cnv7XmGV8FxE69yNO371B4R5t0j wes@metaquest3"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGfeSFlm5MWtmC/tbT8w5AwQFoEJYR+KWSUifZP4XvA wes@macbook"
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "wes";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs = {
    noisetorch.enable = true;
    firefox.enable = true;
    steam = {
      enable = true;    
      # remotePlay.openFirewall = true;
      # dedicatedServer.openFirewall = true;
    };
    _1password-gui.enable = true;
    tmux.enable = true;
    neovim.enable = true;
    mosh = {
      enable = true;
      openFirewall = true;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  services.xserver.videoDrivers = ["nvidia"]; 
  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = true;
    };
  };
 
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    ghostty
    nerd-fonts.jetbrains-mono
    ripgrep
    gcc
    devenv
    gnomeExtensions.system-monitor
    qemu
  ];
   
  virtualisation.docker.enable = true;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false; 

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  
  programs.ssh.extraConfig = ''
Host *
	IdentityAgent ~/.1password/agent.sock
'';

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
    22
    24800
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';   
  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = stateVersion; # Did you read the comment?
  
  system = {
    nixos = {
      label = "no_git_metadata";
      version = "no_git_metadata";
    };
    tools.nixos-version.enable = false;
  };
  
  documentation.nixos.enable = false;

  # Home Manager
  home-manager.sharedModules = [ 
    nixvim.homeModules.nixvim
  ];

  home-manager.users.wes = homeManagerArgs: {
    home.packages = with pkgs; [
      mob
    ];

    programs = {
      
      nixvim = {
	enable = true;

	globals = {
	  mapleader = " ";
	  maplocalleader = "\\";
	};

	opts = {
	  guifont = "JetBrainsMono NF:h12";
	  clipboard = "unnamedplus";
	  shiftwidth = 4;
	  tabstop = 4;
	  expandtab = true;
	  termguicolors = true;
	  number = true;
	};

	keymaps = [
	  # Telescope
	  { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<cr>"; }
	  { mode = "n"; key = "<leader>gf"; action = "<cmd>Telescope git_files<cr>"; }
	  { mode = "n"; key = "sf"; action = "<cmd>Telescope find_files<cr>"; options.desc = "[S]earch [F]iles"; }
	  { mode = "n"; key = "sk"; action = "<cmd>Telescope keymaps<cr>"; options.desc = "[S]earch [K]eymaps"; }
	  { mode = "n"; key = "sb"; action = "<cmd>Telescope buffers<cr>"; options.desc = "[S]earch [B]uffers"; }
	  { mode = "n"; key = "sr"; action = "<cmd>Telescope resume<cr>"; options.desc = "[S]earch [R]esume"; }
	  { mode = "n"; key = "sh"; action = "<cmd>Telescope help_tags<cr>"; options.desc = "[S]earch [H]elp"; }
	  { mode = "n"; key = "sz"; action = "<cmd>Telescope live_grep<cr>"; options.desc = "[S]earch Ripgrep"; }
	  { mode = "n"; key = "s."; action = "<cmd>Telescope oldfiles<cr>"; options.desc = "[S]earch Recent Files"; }
	  { mode = "n"; key = "sc"; action = "<cmd>Telescope colorscheme<cr>"; options.desc = "[S]earch [C]olorschemes"; }

	  # LSP
	  { mode = "n"; key = "gd"; action = "<cmd>Telescope lsp_definitions<cr>"; options.desc = "[G]oto [D]efinitions"; }
	  { mode = "n"; key = "gr"; action = "<cmd>Telescope lsp_references<cr>"; options.desc = "[G]oto [R]eferences"; }
	  { mode = "n"; key = "gi"; action = "<cmd>Telescope lsp_implementations<cr>"; options.desc = "[G]oto [I]mplementations"; }
	  { mode = "n"; key = "<leader>D"; action = "<cmd>Telescope lsp_type_definitions<cr>"; options.desc = "Type [D]efinition"; }
	  { mode = "n"; key = "<leader>ds"; action = "<cmd>Telescope lsp_document_symbols<cr>"; options.desc = "[D]ocument [S]ymbols"; }
	  { mode = "n"; key = "<leader>ws"; action = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>"; options.desc = "[W]orkspace [S]ymbols"; }
	  { mode = "n"; key = "<leader>rn"; action = "<cmd>lua vim.lsp.buf.rename()<cr>"; options.desc = "LSP [R]e[n]ame"; }
	  { mode = "n"; key = "<leader>ca"; action = "<cmd>lua vim.lsp.buf.code_action()<cr>"; options.desc = "LSP [C]ode [A]ction"; }
	  { mode = "n"; key = "K"; action = "<cmd>lua vim.lsp.buf.hover()<cr>"; options.desc = "LSP Hover Documentation"; }
	  { mode = "n"; key = "gD"; action = "<cmd>lua vim.lsp.buf.declaration()<cr>"; options.desc = "LSP [G]oto [D]eclaration"; }
	  { mode = "n"; key = "]d"; action = "<cmd>lua vim.diagnostic.goto_next()<cr>"; options.desc = "Next LSP diagnostic"; }
	  { mode = "n"; key = "[d"; action = "<cmd>lua vim.diagnostic.goto_prev()<cr>"; options.desc = "Previous LSP diagnostic"; }

	  # Harpoon
	  { mode = "n"; key = "<leader>ha"; action = "<cmd>lua require('harpoon.mark').add_file()<cr>"; options.desc = "[H]arpoon [A]dd"; }
	  { mode = "n"; key = "<leader>hq"; action = "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>"; options.desc = "[H]arpoon [Q]uickmenu"; }
	  { mode = "n"; key = "<leader>hj"; action = "<cmd>lua require('harpoon.ui').nav_next()<cr>"; options.desc = "[H]arpoon Next"; }
	  { mode = "n"; key = "<leader>hk"; action = "<cmd>lua require('harpoon.ui').nav_prev()<cr>"; options.desc = "[H]arpoon Prev"; }

	  # Oil
	  { mode = "n"; key = "-"; action = "<cmd>Oil --float<cr>"; options.desc = "Oil file explorer"; }

	  # inlay hints
	  {
	    mode = "n";
	    key = "<leader>l";
	    action = ''
	      lua local inlay_hint_status = not (vim.lsp.inlay_hint.enable)
	      vim.lsp.inlay_hint.enable(inlay_hint_status)
	    '';
	  }
	];

	lsp = {
	  servers = {
	    nixd.enable = true;
	  };
	};

	plugins = {
	  oil.enable = true;
	  treesitter.enable = true;
	  treesitter-textobjects.enable = true;
	  telescope.enable = true;
	  which-key.enable = true;
	  lspconfig.enable = true;
	  sleuth.enable = true;
	  web-devicons.enable = true;
	  luasnip.enable = true;
	  cmp-nvim-lsp.enable = true;
	  cmp-buffer.enable = true;
	  cmp.enable = true;
	  rustaceanvim.enable = true;

	};
      }; # nixvim

      ghostty = {
	enable = true;
	enableBashIntegration = true;
	settings = {
	  font-family = "JetBrainsMono NF";
	  theme = "Dracula";
	  mouse-hide-while-typing = "true";
	  scrollback-limit = "1000000";
	  window-save-state = "always";

	  keybind = [
	    "ctrl+a>n=new_window"
	    "ctrl+a>t=new_tab"
	    "ctrl+h=goto_split:left"
	    "ctrl+j=goto_split:bottom"
	    "ctrl+k=goto_split:top"
	    "ctrl+l=goto_split:right"
	    "ctrl+a>h=new_split:left"
	    "ctrl+a>j=new_split:down"
	    "ctrl+a>k=new_split:up"
	    "ctrl+a>l=new_split:right"
	    "alt+enter=toggle_fullscreen"
	    "ctrl+enter=toggle_split_zoom"
	    "ctrl+tab=next_tab"
	    "ctrl+shift+tab=previous_tab"
	    "super+r=reload_config"
	  ];

	};
      };

      bash = {
	enable = true;
	initExtra = ''set -o vi'';
      };
      
      git = {
	enable = true;
	userName = "Wes Gray";
	userEmail = "wes.gray@gmail.com";
	ignores = [
	  ".direnv"
	  ".envrc"
	];
	extraConfig = {
	  url = {
	    "ssh://git@github.com" = {
	      insteadOf = "https://github.com/";
	    };
	  };
	};

	difftastic = {
	  enable = true;
	  enableAsDifftool = true;
	};
      };

      direnv = {
	enable = true;
	nix-direnv.enable = true;
      };

      starship = {
	enable = true;
	settings.custom.mob = {
	  command = "echo $MOB_TIMER_ROOM";
	  format = "[ ($output)]($style) ";
	  when = "[[ -v MOB_TIMER_ROOM ]]";
	};
      };

    };


    home.stateVersion = stateVersion;
  };
}
