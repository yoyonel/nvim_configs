-- ========================================================================== --
--                  PLUGIN : TREESITTER (Analyse Syntaxique)                  --
-- ========================================================================== --
-- Coloration syntaxique intelligente, indentation et sélection par bloc.

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate", -- Mettre à jour les parsers automatiquement
		config = function()
			require("nvim-treesitter.configs").setup({
				-- Liste des langages à installer automatiquement (très complet)
				ensure_installed = {
					"lua", "vim", "vimdoc", "query",       -- Neovim interne
					"python", "bash", "markdown", "markdown_inline",
					"c", "cpp", "rust", "go",             -- Systems
					"javascript", "typescript", "tsx",    -- Web
					"html", "css", "json", "yaml"          -- Config & Web
				},

				-- Installation automatique des parsers manquants à l'ouverture
				auto_install = true,

				-- Coloration syntaxique basée sur l'arbre syntaxique (AST)
				highlight = {
					enable = true, -- Activer la coloration intelligente
					additional_vim_regex_highlighting = false,
				},

				-- Indentation intelligente
				indent = {
					enable = true,
				},

				-- Sélection intelligente (Expand Selection style VSCode)
				-- Appuyer sur Ctrl+Espacé pour étendre la sélection logiquement
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>", -- Ctrl+Espace : démarrer
						node_incremental = "<C-space>", -- Étendre à l'élément parent
						scope_incremental = false,
						node_decremental = "<bs>", -- Backspace : réduire la sélection
					},
				},
			})
		end,
	},
}
