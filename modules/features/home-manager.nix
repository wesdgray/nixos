{nixvim, pkgs, stateVersion, ...}:
{
  flake.homeModules.desktop3950x = {
      # Home Manager
      home-manager.sharedModules = [ 
	nixvim.homeModules.nixvim
      ];

      home-manager.users.wes = homeManagerArgs: {
	home.packages = with pkgs; [
	  mob
	];
	
	services = {
	  easyeffects.enable = true;
	};

	programs = {
	  
	  obs-studio.enable	= true;
	  vesktop.enable = true; 

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
		action = "<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>";
	      }
	      # Context
	      {
		mode = "n";
		key = "<leader>c";
		action = "<CMD>TSContext toggle<CR>";
	      }
	    ];

	    lsp = {
	      servers = {
		nixd.enable = true;
		gopls.enable = true;
	      };
	    };

	    plugins = {
	      oil.enable = true;
	      treesitter.enable = true;
	      treesitter-textobjects.enable = true;
	      treesitter-context.enable = true;
	      telescope.enable = true;
	      which-key.enable = true;
	      lspconfig.enable = true;
	      sleuth.enable = true;
	      web-devicons.enable = true;
	      rustaceanvim.enable = true;
	      cmp = {
		enable = true;
		settings = {
		  sources = [
		    { name = "nvim_lsp"; }
		    { name = "luasnip"; }
		    { name = "path"; }
		    { name = "buffer"; }
		  ];
		  mapping = {
		    "<C-Space>" = "cmp.mapping.complete()";
		    "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
		    "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
		  };
		}; # settings
	      }; # cmp
	    }; # plugins
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
	    }; # settings
	  }; # ghostty

	  bash = {
	    enable = true;
	    initExtra = ''
	      set -o vi
	      export EDITOR=nvim
	    '';
	  };
	  
	  difftastic = {
	    enable = true;
	    git.diffToolMode = true;
	  };

	  git = {
	    enable = true;
	    settings = {
	      user.name = "Wes Gray";
	      user.email = "wes.gray@gmail.com";
	      url = {
		"ssh://git@github.com" = {
		  insteadOf = "https://github.com/";
		};
	      };
	    };
	    ignores = [
	      ".direnv"
	      ".envrc"
	    ];
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

	}; # programs

	home.stateVersion = stateVersion;
      }; # home-manager
    }; # top level 
}
