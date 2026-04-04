-- ========================================================================== --
--                  PLUGIN : LSP (Language Server Protocol) & CMP            --
-- ========================================================================== --
-- Gestion des serveurs de langage (Mason) et Autocomplétion (Cmp)
-- Supporte : Go to Definition, Rename, Diagnostics, Autocomplete...

return {

	-- ======================================================================
	-- 1. MASON : Gestionnaire de serveurs (LSP, DAP, Linter, Formatter)
	-- Installe les binaires sur l'hôte, même si pas installés sur le système.
	-- ======================================================================
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
				},
			})
		end,
	},

	-- ======================================================================
	-- 2. LSPCONFIG : Configuration des serveurs de langage
	-- ======================================================================
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			-- UI & Rename Premium
			{ 
				"smjonas/inc-rename.nvim", 
				config = function()
					require("inc_rename").setup({
						post_hook = function()
							vim.cmd("silent! wa") -- Sauvegarde TOUT après le renommage pour forcer le rafraîchissement LSP
						end
					})
				end 
			},
			{ "stevearc/dressing.nvim", opts = {} },
		},
		config = function()
			local function safe_require(module)
				local ok, m = pcall(require, module)
				if not ok then
					vim.notify("Module non trouvé : " .. module .. ". Sync nécessaire.", vim.log.levels.WARN)
					return nil
				end
				return m
			end

			local mason = safe_require("mason")
			local mason_lspconfig = safe_require("mason-lspconfig")
			local lspconfig = safe_require("lspconfig")
			local cmp_lsp = safe_require("cmp_nvim_lsp")

			if not (mason and mason_lspconfig and lspconfig and cmp_lsp) then return end

			-- Chemin Mason correct
			local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
			vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

			mason.setup({ ui = { border = "rounded" } })
			mason_lspconfig.setup({
				ensure_installed = { "lua_ls", "pyright", "clangd", "rust_analyzer" },
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = cmp_lsp.default_capabilities(capabilities)

			-- ==================================================================
			-- ÉVÈNEMENT : LSP ATTACH (Raccourcis clavier)
			-- ==================================================================
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local key = vim.keymap.set
					local bufnr = ev.buf

					-- ⌨️ RACCOURCIS LSP (Directs et robustes)
					key("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition", buffer = bufnr })
					key("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "Go to References", buffer = bufnr })
					key("n", "gi", "<cmd>Telescope lsp_implementations<cr>", { desc = "Go to Implementation", buffer = bufnr })
					key("n", "K",  vim.lsp.buf.hover, { desc = "Show Documentation", buffer = bufnr })

					-- RENAME (Sécurisé)
					key("n", "<leader>rn", function()
						local ok_inc = pcall(require, "inc_rename")
						if ok_inc then
							return ":IncRename " .. vim.fn.expand("<cword>")
						else
							vim.lsp.buf.rename()
							return ""
						end
					end, { expr = true, desc = "Rename variable", buffer = bufnr })

					key("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", buffer = bufnr })
					key("n", "[d",  vim.diagnostic.goto_prev, { desc = "Erreur précédente", buffer = bufnr })
					key("n", "]d",  vim.diagnostic.goto_next, { desc = "Erreur suivante", buffer = bufnr })
					key("n", "<leader>d", vim.diagnostic.open_float, { desc = "Afficher l'erreur", buffer = bufnr })
				end,
			})

			-- Configuration des serveurs
			local servers = { "pyright", "rust_analyzer" }
			for _, server in ipairs(servers) do
				lspconfig[server].setup({ capabilities = capabilities })
			end

			-- Configuration optimisée pour clangd
			lspconfig.clangd.setup({
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=never",
					"--completion-style=detailed",
					"--function-arg-placeholders",  -- Version simple (flag)
					"--fallback-style=llvm",
					"--all-scopes-completion",
					"--compile-commands-dir=build",
					-- UN SEUL MAPPING : Remote (Container) vers Local (Hôte)
					"--path-mappings=/home/latty=/var/home/latty",
					-- Drivers
					"--query-driver=/usr/bin/gcc,/usr/bin/g++,/usr/bin/clang,/usr/bin/clang++",
				},
				root_dir = lspconfig.util.root_pattern(".git", "compile_commands.json", "build/compile_commands.json", "CMakeLists.txt"),
			})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
					},
				},
			})

			-- Icônes
			local signs = { Error = " ", Warn = " ", Hint = "󰌵", Info = "󰋼" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
		end,
	},

	-- ======================================================================
	-- 3. NVIM-CMP : Moteur d'autocomplétion
	-- ======================================================================
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- Source LSP
			"hrsh7th/cmp-buffer",   -- Source Buffer (mots dans le fichier)
			"hrsh7th/cmp-path",     -- Source Path (chemins de fichiers)
			"L3MON4D3/LuaSnip",     -- Snippets engine
			"saadparwaiz1/cmp_luasnip", -- Pont Snippets <> Cmp
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(), -- Monter dans la liste
					["<C-j>"] = cmp.mapping.select_next_item(), -- Descendre
					["<C-Space>"] = cmp.mapping.complete(),     -- Forcer l'affichage
					["<Esc>"] = cmp.mapping.abort(),            -- Fermer
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Entrée pour valider
					-- Tabulation (standard VSCode)
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- Priorité 1 : LSP
					{ name = "luasnip" },  -- Priorité 2 : Snippets
				}, {
					{ name = "buffer" },   -- Priorité 3 : Mots du fichier
					{ name = "path" },     -- Priorité 4 : Chemins
				}),
				formatting = {
					format = function(_, vim_item)
						-- Afficher le type (Function, Variable, etc.) à droite
						vim_item.menu = ""
						return vim_item
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			})
		end,
	},
}
