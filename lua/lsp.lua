vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

local lsp_group = vim.api.nvim_create_augroup("LSPGroup", { clear = true })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("mini.completion").get_lsp_capabilities())
vim.lsp.config("*", { capabilities = capabilities })

vim.keymap.set("n", "<leader>lr", function()
	vim.cmd("lsp restart")
	vim.notify("LSP restarted", vim.log.levels.INFO)
end, { desc = "Restart LSP" })

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(event)
		local buf = event.buf

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method("textDocument/documentHighlight", buf) then
			local hl_group = vim.api.nvim_create_augroup("LSPHighlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = buf,
				group = hl_group,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = buf,
				group = hl_group,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("LSPHighlightClear", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "LSPHighlight", buffer = event2.buf })
				end,
			})
		end

		vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { buffer = buf, desc = "[L]SP [F]ormat" })
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, { buffer = buf, desc = "[L]SP [R]eferences" })
		vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { buffer = buf, desc = "[L]SP re[N]ame" })
		vim.keymap.set("n", "<leader>ld", vim.lsp.buf.declaration, { buffer = buf, desc = "[L]SP [D]eclaration" })
		vim.keymap.set("n", "<leader>lD", vim.lsp.buf.definition, { buffer = buf, desc = "[L]SP [D]efinitions" })
		vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { buffer = buf, desc = "[L]SP [I]mplementation" })
		vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { buffer = buf, desc = "[L]SP code [A]ction" })
		vim.keymap.set(
			"n",
			"<leader>ls",
			vim.lsp.buf.document_symbol,
			{ buffer = buf, desc = "[L]SP buffer [S]ymbols" }
		)
		vim.keymap.set(
			"n",
			"<leader>lS",
			vim.lsp.buf.workspace_symbol,
			{ buffer = buf, desc = "[L]SP workspace [S]ymbols" }
		)
		vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { buffer = buf, desc = "[L]SP [H]over" })
		vim.keymap.set("n", "<leader>lH", vim.lsp.buf.signature_help, { buffer = buf, desc = "[L]SP signature [H]elp" })
		vim.keymap.set("n", "<leader>lc", vim.lsp.codelens.run, { buffer = buf, desc = "[L]SP [C]ode lens" })
		vim.keymap.set(
			"n",
			"<leader>ll",
			vim.diagnostic.setloclist,
			{ buffer = buf, desc = "[L]SP diagnostic [L]ocation list" }
		)
		vim.keymap.set(
			"n",
			"<leader>lq",
			vim.diagnostic.setqflist,
			{ buffer = buf, desc = "[L]SP diagnostic [Q]uickfix list" }
		)
		vim.keymap.set(
			"n",
			"<leader>lo",
			vim.diagnostic.open_float,
			{ buffer = buf, desc = "[L]SP [Open] diagnostics" }
		)

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		if client and client:supports_method("textDocument/inlayHint", buf) then
			vim.keymap.set("n", "<leader>lt", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }))
			end, { buffer = buf, desc = "[L]SP toggle inlay hin[T]s" })
		end
	end,
})

require("mason").setup({
	install_root_dir = vim.fn.stdpath("data") .. "/mason",
})

require("mason-lspconfig").setup({
	automatic_enable = false,
})

local servers = {
	clangd = {},
	ruff = {},
	ty = {},
	neocmake = {},
	ltex_plus = {},
	stylua = {},
	lua_ls = {
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using (most
					-- likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Tell the language server how to find Lua modules same way as Neovim
					-- (see `:h lua-module-load`)
					path = {
						"lua/?.lua",
						"lua/?/init.lua",
					},
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						-- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
						vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
					},
					-- Or pull in all of "runtimepath".
					-- NOTE: this is a lot slower and will cause issues when working on
					-- your own configuration.
					-- See https://github.com/neovim/nvim-lspconfig/issues/3189
					-- library = vim.api.nvim_get_runtime_file("", true),
				},
			})
		end,
		settings = {
			Lua = {
				format = { enable = false }, -- Disable formatting (formatting is done by stylua)
			},
		},
	},
}

local server_names = vim.tbl_keys(servers or {})

require("mason-tool-installer").setup({
	ensure_installed = vim.list_extend(server_names, {
		-- NOTE: Additional tools
	}),
})

for name, conf in pairs(servers) do
	vim.lsp.config(name, conf)
	vim.lsp.enable(name)
end
