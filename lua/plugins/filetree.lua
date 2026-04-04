-- ========================================================================== --
--                    PLUGIN : FILE TREE (Neo-tree)                            --
-- ========================================================================== --
-- Equivalent de la barre latérale de fichiers VSCode
-- Toggle : Ctrl+B (comme VSCode)

return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",          -- Utilitaires Lua (requis)
			"nvim-tree/nvim-web-devicons",    -- Icônes (requis, déjà installé par Lualine)
			"MunifTanjim/nui.nvim",           -- Composants UI (requis)
		},
		keys = {
			-- Ctrl+B : toggle le panneau (comme VSCode)
			{ "<C-b>", "<cmd>Neotree toggle<cr>", desc = "Toggle File Tree" },
			-- Space+e : ouvrir et positionner sur le fichier courant
			{ "<leader>e", "<cmd>Neotree reveal<cr>", desc = "Révéler fichier dans File Tree" },
		},
		config = function()
			-- Désactiver netrw (l'explorateur natif de Vim, remplacé par neo-tree)
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			require("neo-tree").setup({
				close_if_last_window = true, -- Fermer nvim si neo-tree est la dernière fenêtre
				popup_border_style = "rounded",
				
				-- CONFIGURATION DU RENDU (Alignement à droite comme VSCode)
				renderers = {
					file = {
						{ "indent" },
						{ "icon" },
						{ "name", use_git_status_colors = true },
						{ "modified", zindex = 20, align = "right" },
						{ "git_status", zindex = 20, align = "right" },
					},
					directory = {
						{ "indent" },
						{ "icon" },
						{ "name", use_git_status_colors = true },
						{ "git_status", zindex = 20, align = "right" },
					},
				},

				-- Apparence générale
				default_component_configs = {
					indent = {
						indent_size = 2,
						padding = 1,
						with_markers = true,
						indent_marker = "│",
						last_indent_marker = "└",
						highlight = "NeoTreeIndentMarker",
					},
					name = {
						use_git_status_colors = true, -- Colorie le nom selon l'état Git
						highlight_opened_files = true, -- Surligne le fichier qu'on est en train d'éditer
					},
					modified = {
						symbol = "●",
						highlight = "NeoTreeModified",
					},
					-- Indicateurs Git TRÈS VISIBLES (comme VSCode)
					git_status = {
						symbols = {
							-- On utilise des lettres pour le style IDE classique
							added     = "A",
							modified  = "M",
							deleted   = "D",
							renamed   = "R",
							untracked = "U",
							ignored   = "◌",
							unstaged  = "U",
							staged    = "S",
							conflict  = "✘",
						},
					},
				},

				-- Options de coloration et rendu
				enable_git_status = true,
				enable_diagnostics = true,


				-- Configuration de la fenêtre latérale
				window = {
					position = "left",
					width = 35,
					mapping_options = { noremap = true, nowait = true },
					mappings = {
						-- Navigation intuitive (+ touches classiques Vim)
						["<space>"] = "toggle_node",
						["<cr>"]    = "open",
						["o"]       = "open",
						["l"]       = "open",           -- Vim-style : ouvrir
						["h"]       = "close_node",     -- Vim-style : fermer
						["v"]       = "open_vsplit",
						["s"]       = "open_split",
						["t"]       = "open_tabnew",
						["C"]       = "close_all_nodes",
						["z"]       = "close_all_nodes",
						["R"]       = "refresh",
						["a"]       = "add",            -- Nouveau fichier
						["A"]       = "add_directory",  -- Nouveau dossier
						["d"]       = "delete",
						["r"]       = "rename",
						["y"]       = "copy_to_clipboard",
						["x"]       = "cut_to_clipboard",
						["p"]       = "paste_from_clipboard",
						["c"]       = "copy",
						["m"]       = "move",
						["q"]       = "close_window",
						["<C-b>"]   = "close_window",
						["?"]       = "show_help",
					},
				},

				-- Source : système de fichiers
				filesystem = {
					filtered_items = {
						visible = false,        -- Cacher les fichiers ignorés par défaut
						hide_dotfiles = false,  -- Afficher les dotfiles (ex: .gitignore)
						hide_gitignored = true, -- Masquer ce qui est dans .gitignore
						hide_hidden = true,
					},
					follow_current_file = {
						enabled = true,  -- Suivre le fichier ouvert dans l'éditeur
					},
					group_empty_dirs = true,    -- Grouper les dossiers vides (ex: a/b/c/)
					hijack_netrw_behavior = "open_current", -- Remplacer netrw
					use_libuv_file_watcher = true, -- Rafraîchissement automatique
				},
			})
		end,
	},
}
