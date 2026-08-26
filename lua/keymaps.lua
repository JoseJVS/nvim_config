-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear highlight" })
vim.keymap.set("n", "<C-c>", "<Esc>", { desc = "Additional escape" })
vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<cr>", { desc = "Additional escape" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", "<cmd>echo 'Use h to move!!'<cr>")
vim.keymap.set("n", "<right>", "<cmd>echo 'Use l to move!!'<cr>")
vim.keymap.set("n", "<up>", "<cmd>echo 'Use k to move!!'<cr>")
vim.keymap.set("n", "<down>", "<cmd>echo 'Use j to move!!'<cr>")

-- Centered navigation
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

vim.keymap.set("x", "p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Buffer manipulation
vim.keymap.set("n", "<leader>bl", "<cmd>buffers<cr>", { desc = "[B]uffers [L]ist open" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "[B]uffers [N]ext" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "[B]uffers [P]revious" })
vim.keymap.set("n", "<leader>bc", "<cmd>wq<cr>", { desc = "[B]uffers save and [C]lose" })

-- Better indentation
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- tab management
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "[T]abs [O]pen new" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "[T]abs [C]lose current" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<cr>", { desc = "[T]abs [N]ext" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<cr>", { desc = "[T]abs [P]revious" })
vim.keymap.set("n", "<leader>td", "<cmd>tabnew %<cr>", { desc = "[T]abs [D]uplicate" })

--split management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "[S]plit window [V]ertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "[S]plit window [H]orizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "[S]plits make [E]qual size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<cr>", { desc = "[S]plits [C]lose current" })

vim.keymap.set("n", "<leader><Esc>", "<cmd>qa<cr>", { desc = "Quit" })

-- Native undotree
vim.cmd.packadd("nvim.undotree")
local ut = require("undotree")
vim.keymap.set("n", "<leader>u", ut.open, { desc = "Toggle Builtin Undotree" })
