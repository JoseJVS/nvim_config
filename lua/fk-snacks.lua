vim.pack.add({
	"https://github.com/folke/snacks.nvim",
})

local snk = require("snacks")
snk.setup({
	lazygit = { enabled = true },
	terminal = { enabled = true },
})

vim.keymap.set("n", "<leader>go", snk.lazygit.open, { desc = "Lazy[G]it [O]pen" })
vim.keymap.set("n", "<leader>gl", snk.lazygit.log, { desc = "Lazy[G]it [L]og" })
vim.keymap.set("n", "<leader>gL", snk.lazygit.log_file, { desc = "Lazy[G]it [L]og current file" })

vim.keymap.set("n", "<leader>/", snk.terminal.toggle, { desc = "Toggle terminal" })
