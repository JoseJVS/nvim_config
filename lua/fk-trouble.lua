vim.pack.add({
	"https://github.com/folke/trouble.nvim",
})

local tbl = require("trouble")
tbl.setup({
	focus = true,
})

local config = require("fzf-lua.config")
local actions = require("trouble.sources.fzf").actions
config.defaults.actions.files["ctrl-t"] = actions.open

vim.keymap.set("n", "<leader>xd", function()
	tbl.toggle({
		mode = "diagnostics",
		filter = {
			buf = 0,
		},
	})
end, { desc = "[X]Trouble buffer [D]iagnostics" })
vim.keymap.set("n", "<leader>xD", function()
	tbl.toggle({
		mode = "diagnostics",
	})
end, { desc = "[X]Trouble workspace [D]iagnostics" })
vim.keymap.set("n", "<leader>xl", function()
	tbl.toggle({
		mode = "lsp",
		filter = {
			buf = 0,
		},
	})
end, { desc = "[X]Trouble buffer [L]SP info" })
vim.keymap.set("n", "<leader>xL", function()
	tbl.toggle({
		mode = "lsp",
	})
end, { desc = "[X]Trouble workspace [L]SP info" })
vim.keymap.set("n", "<leader>xs", function()
	tbl.toggle({
		mode = "symbols",
		filter = {
			buf = 0,
		},
	})
end, { desc = "[X]Trouble buffer [S]ymbols" })
vim.keymap.set("n", "<leader>xS", function()
	tbl.toggle({
		mode = "symbols",
	})
end, { desc = "[X]Trouble workspace [S]ymbols" })
vim.keymap.set("n", "<leader>xc", function()
	tbl.toggle({
		mode = "loclist",
		filter = {
			buf = 0,
		},
	})
end, { desc = "[X]Trouble buffer lo[C]ation list" })
vim.keymap.set("n", "<leader>xC", function()
	tbl.toggle({
		mode = "loclist",
	})
end, { desc = "[X]Trouble workspace lo[C]ation list" })
vim.keymap.set("n", "<leader>xq", function()
	tbl.toggle({
		mode = "qflist",
		filter = {
			buf = 0,
		},
	})
end, { desc = "[X]Trouble buffer [Q]uickfix list" })
vim.keymap.set("n", "<leader>xQ", function()
	tbl.toggle({
		mode = "qflist",
	})
end, { desc = "[X]Trouble workspace [Q]uickfix list" })
