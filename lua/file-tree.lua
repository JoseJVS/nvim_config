vim.pack.add({
	"https://github.com/nvim-tree/nvim-tree.lua",
})

require("nvim-tree").setup()
local api = require("nvim-tree.api")

vim.keymap.set("n", "<leader>eo", function()
    if api.tree.is_visible() then
        -- Close is necessary as focusing on the tree
        -- changes the displayed root to HOME
        api.tree.close()
	    api.tree.open({ path = vim.fn.getcwd() })
    else
	    api.tree.open({ path = vim.fn.getcwd() })
    end
end, { desc = "[E]xplorer [O]pen" })
vim.keymap.set("n", "<leader>et", function()
	api.tree.toggle({ path = vim.fn.getcwd() })
end, { desc = "[E]xplorer [T]oggle" })
vim.keymap.set("n", "<leader>er", api.tree.reload, { desc = "[E]xplorer [R]eload" })
vim.keymap.set("n", "<leader>ec", api.tree.collapse_all, { desc = "[E]xplorer [C]ollapse" })

vim.schedule(function()
	if not api.tree.is_visible() then
		api.tree.toggle({ path = vim.fn.getcwd(), focus = false })
	end
end)
