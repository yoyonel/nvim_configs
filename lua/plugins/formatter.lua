-- ========================================================================== --
--                  PLUGIN : CONFORM (Formatage Automatique)                  --
-- ========================================================================== --
-- S'occupe de rendre le code propre au moment de la sauvegarde (Format on Save).
-- Supporte : clang-format (C), ruff (Python), stylua (Lua)...

return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- Python utilise Ruff (ultra rapide)
					python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
					-- C/C++ utilise clang-format
					c = { "clang-format" },
					cpp = { "clang-format" },
					-- Markdown / Json / Web
					javascript = { "prettierd", "prettier", stop_after_first = true },
					json = { "jq" },
					markdown = { "prettierd", "prettier", stop_after_first = true },
				},
				-- AUTO-FORMAT DÉSACTIVÉ (Contrôle total CPU exigé par l'utilisateur)
				format_on_save = nil,
			})

			-- Raccourci manuel (Space+f+f) pour forcer le formatage
			vim.keymap.set("n", "<leader>ff", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { desc = "Formatage manuel (tout le fichier)" })
		end,
	},
}
