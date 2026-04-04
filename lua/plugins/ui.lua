-- ========================================================================== --
--                        PLUGINS UI / THÈME VISUEL                           --
-- ========================================================================== --
-- Contient : colorscheme (Catppuccin) + statusline (Lualine)

return {

	-- ======================================================================
	-- 1. COLORSCHEME : Catppuccin
	-- Un thème sombre moderne, très populaire dans l'écosystème Neovim/VSCode.
	-- Flavours disponibles : latte (clair), frappe, macchiato, mocha (le plus sombre)
	-- ======================================================================
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Charger avant tous les autres plugins
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				background = { dark = "mocha", light = "latte" },
				transparent_background = false,
				term_colors = true,
				integrations = {
					lazy = true,
					lualine = true,
					treesitter = true,
					native_lsp = {
						enabled = true,
					},
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	-- ======================================================================
	-- 2. STATUSLINE : Lualine
	-- La barre du bas style VSCode : mode, branche git, fichier, diagnostics...
	-- Nécessite une Nerd Font pour les icônes (ex: JetBrainsMono Nerd Font)
	-- ======================================================================
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
		config = function()
			-- Statusline globale (une seule barre pour tous les splits)
			vim.opt.laststatus = 3

			require("lualine").setup({
				options = {
					theme = "catppuccin",
					-- Séparateurs en demi-cercle (style powerline)
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					globalstatus = true,
				},
				sections = {
					-- Gauche
					lualine_a = { "mode" },
					lualine_b = {
						{ "branch", icon = "" },
						{ "diff" },
						{ "diagnostics", sources = { "nvim_lsp" } },
					},
					lualine_c = {
						{ "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[Sans nom]" } },
					},
					-- Droite
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "location" },
				},
			})
		end,
	},
}
