-- ========================================================================== --
--                  PLUGIN : TELESCOPE (Fuzzy Finder / Quick Open)           --
-- ========================================================================== --
-- Équivalent de Ctrl+P et de la recherche globale VSCode.
-- Raccourcis : Ctrl+P (Fichiers), Space+f+g (Grep), Space+f+b (Buffers)

return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Extension native fzf pour la rapidité (conseillé)
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		keys = {
			-- Ctrl+P : Chercher des fichiers (comme VSCode)
			{ "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Chercher fichiers (Ctrl+P)" },
			-- Space+f+g : Live Grep (chercher texte dans tout le projet)
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Chercher texte (Live Grep)" },
			-- Space+f+b : Chercher dans les buffers ouverts
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Chercher buffers" },
			-- Space+f+h : Aide sur les raccourcis Neovim
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Aide Neovim" },
			-- Space+f+r : Récents (historique)
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Fichiers récents" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					-- Apparence thémée Catppuccin
					path_display = { "truncate" },
					sorting_strategy = "ascending",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = {
							mirror = false,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					mappings = {
						-- Navigation dans les résultats (comme VSCode / standard nvim)
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-p>"] = actions.close, -- Re-appuyer Ctrl+P ferme si déjà ouvert
							["<esc>"] = actions.close, -- Échap pour fermer (standard)
						},
					},
					preview = {
						timeout = 1000, -- On laisse 1sec à Telescope (au lieu de 250ms)
						filesize_limit = 1, -- Mo max pour un fichier en preview
					},
				},
				pickers = {
					find_files = {
						theme = "dropdown",
						previewer = false,
					},
					buffers = {
						theme = "dropdown",
						previewer = false,
						initial_mode = "normal",
						mappings = {
							i = { ["<c-d>"] = actions.delete_buffer },
							n = { ["d"] = actions.delete_buffer },
						},
					},
				},
			})

			-- Activer l'extension fzf
			telescope.load_extension("fzf")
		end,
	},
}
