-- ========================================================================== --
--                  PLUGIN : TOOLS (CMake, Terminals, Misc)                  --
-- ========================================================================== --
-- Centralise les outils de build et de productivité.

return {
	-- ----------------------------------------------------------------------
	-- 1. CMAKE-TOOLS : Le panneau de contrôle du projet C/C++
	-- ----------------------------------------------------------------------
	{
		"CivitasV/cmake-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		config = function()
			require("cmake-tools").setup({
				cmake_command = "cmake", -- Utilise le cmake du système/distrobox
				cmake_build_directory = "build",
				cmake_generate_options = { "-DCMake_EXPORT_COMPILE_COMMANDS=1" },
				cmake_build_options = { "--parallel", "8" },
				cmake_console_size = 10,
				cmake_show_console = "always", -- On remet en 'always' pour que le focus fonctionne
				cmake_variants_message = {
					short = { "variant" },
					long = { "variant", "type" },
				},
				cmake_dap_configuration = {
					name = "cpp",
					type = "cppdbg",
					request = "launch",
					stopAtEntry = false,
					runInTerminal = true,
				},
			})

			-- Raccourcis clavier CMake avec FOCUS AUTOMATIQUE
			local key = vim.keymap.set
			key("n", "<leader>cg", "<cmd>CMakeGenerate<cr>", { desc = "CMake Generate" })
			
			-- Build + Focus
			key("n", "<leader>cb", "<cmd>CMakeBuild<cr><C-w>j", { desc = "CMake Build & Focus" })
			
			-- Run + Focus
			key("n", "<leader>cr", "<cmd>CMakeRun<cr><C-w>j",   { desc = "CMake Run & Focus" })
			
			key("n", "<leader>ct", "<cmd>CMakeSelectTarget<cr>", { desc = "CMake Select Target" })
			-- Fermer tout
			key("n", "<leader>cc", "<cmd>CMakeClose<cr><cmd>cclose<cr>", { desc = "Fermer Console & Erreurs" })
		end,
	},

	-- ----------------------------------------------------------------------
	-- 2. TOGGLETERM : Terminal flottant (comme Ctrl+` sous VSCode)
	-- ----------------------------------------------------------------------
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<C-t>]], -- Ctrl+t est beaucoup plus accessible
				shade_terminals = true,
				direction = "float",
				float_opts = {
					border = "curved",
					winblend = 3,
				},
			})

			-- Raccourcis supplémentaires
			local key = vim.keymap.set
			-- Space + t pour ouvrir/fermer (Plus naturel en mode Normal)
			key("n", "<leader>t", "<cmd>ToggleTerm<cr>", { desc = "Terminal flottant" })
		end,
	},
}
