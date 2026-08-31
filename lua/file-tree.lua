vim.pack.add({
	"https://github.com/nvim-tree/nvim-tree.lua",
})

require("nvim-tree").setup()
local api = require("nvim-tree.api")

local toggle_unfocused_tree = function()
	if not api.tree.is_visible() then
		api.tree.toggle({ path = vim.fn.getcwd(), focus = false })
	end
end

local visible_close = function()
    if api.tree.is_visible() then
	    api.tree.close()
    end
end

vim.keymap.set("n", "<leader>eo", function()
    -- Close is necessary as focusing on the tree
    -- changes the displayed root to HOME
    visible_close()
    api.tree.open({ path = vim.fn.getcwd() })
end, { desc = "[E]xplorer [O]pen" })
vim.keymap.set("n", "<leader>et", function()
	api.tree.toggle({ path = vim.fn.getcwd() })
end, { desc = "[E]xplorer [T]oggle" })
vim.keymap.set("n", "<leader>er", api.tree.reload, { desc = "[E]xplorer [R]eload" })
vim.keymap.set("n", "<leader>ec", api.tree.collapse_all, { desc = "[E]xplorer [C]ollapse" })

vim.schedule(toggle_unfocused_tree)

local sesh = require("mini.sessions")
sesh.config.hooks.pre["write"] = visible_close
sesh.config.hooks.post["write"] = toggle_unfocused_tree
sesh.config.hooks.pre["read"] = visible_close
sesh.config.hooks.post["read"] = toggle_unfocused_tree
