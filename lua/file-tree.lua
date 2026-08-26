vim.pack.add({
	"https://github.com/nvim-tree/nvim-tree.lua",
})

local api = require("nvim-tree.api")

local function my_on_attach(bufnr)
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.map.on_attach.default(bufnr)

	-- custom mappings
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
	vim.keymap.set("n", "<C-[>", api.tree.change_root_to_parent, opts("Up"))
end

-- pass to setup along with your other config
require("nvim-tree").setup({
	---
	on_attach = my_on_attach,
	---
})

vim.keymap.set("n", "<leader>eo", api.tree.open, { desc = "[E]xplorer [O]pen" })
vim.keymap.set("n", "<leader>et", api.tree.toggle, { desc = "[E]xplorer [T]oggle" })
vim.keymap.set("n", "<leader>er", api.tree.reload, { desc = "[E]xplorer [R]eload" })
vim.keymap.set("n", "<leader>ec", api.tree.collapse_all, { desc = "[E]xplorer [C]ollapse" })

vim.schedule(function()
	if not api.tree.is_visible() then
		api.tree.toggle({ focus = false })
	end
end)
