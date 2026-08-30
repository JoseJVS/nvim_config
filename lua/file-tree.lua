vim.pack.add({
	"https://github.com/nvim-tree/nvim-tree.lua",
})

require("nvim-tree").setup()
local api = require("nvim-tree.api")

vim.keymap.set("n", "<leader>eo", api.tree.open, { desc = "[E]xplorer [O]pen" })
vim.keymap.set("n", "<leader>et", api.tree.toggle, { desc = "[E]xplorer [T]oggle" })
vim.keymap.set("n", "<leader>er", api.tree.reload, { desc = "[E]xplorer [R]eload" })
vim.keymap.set("n", "<leader>ec", api.tree.collapse_all, { desc = "[E]xplorer [C]ollapse" })

vim.schedule(function()
	if not api.tree.is_visible() then
		api.tree.toggle({ focus = false })
	end
end)
