vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	"https://github.com/ibhagwan/fzf-lua",
})

local fzf_group = vim.api.nvim_create_augroup("FZFGroup", { clear = true })

require("treesitter-context").setup()

local fzf = require("fzf-lua")
fzf.setup({
	{ "fzf-native", "hide" },
})

vim.keymap.set("n", "<leader>fr", fzf.resume, { desc = "[F]ZF [R]esume last query" })
vim.keymap.set("n", "<leader>fc", fzf.builtin, { desc = "[F]ZF builtin [C]ommands" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "[F]ZF search open [B]uffers" })
vim.keymap.set("n", "<leader>ft", fzf.tabs, { desc = "[F]ZF search open [T]abs" })
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "[F]ZF search [F]iles in CWD" })
vim.keymap.set("n", "<leader>fi", fzf.lgrep_curbuf, { desc = "[F]ZF l[I]ve grep current buffer (alt)" })

vim.keymap.set("n", "<leader>fhb", fzf.history, { desc = "[F]ZF [H]istory search [B]uffers/files" })
vim.keymap.set("n", "<leader>fhc", fzf.command_history, { desc = "[F]ZF [H]istory search [C]ommands" })
vim.keymap.set("n", "<leader>fhs", fzf.search_history, { desc = "[F]ZF [H]istory search [S]earches" })

vim.keymap.set("n", "<leader>fsg", fzf.global, { desc = "[F]ZF [S]earch [G]lobally" })
vim.keymap.set("n", "<leader>fsb", fzf.blines, { desc = "[F]ZF [S]earch current [B]uffer lines" })
vim.keymap.set("n", "<leader>fsB", fzf.lines, { desc = "[F]ZF [S]earch open [B]uffer lines" })
vim.keymap.set("n", "<leader>fsq", fzf.quickfix, { desc = "[F]ZF [S]earch [Q]uickfix list" })
vim.keymap.set("n", "<leader>fsQ", fzf.quickfix_stack, { desc = "[F]ZF [S]earch [Q]uickfix stack" })
vim.keymap.set("n", "<leader>fsl", fzf.loclist, { desc = "[F]ZF [S]earch [L]ocation list" })
vim.keymap.set("n", "<leader>fsL", fzf.loclist_stack, { desc = "[F]ZF [S]earch [L]ocation stack" })
vim.keymap.set("n", "<leader>fsh", fzf.helptags, { desc = "[F]ZF [S]earch nvim [H]elp tags" })
vim.keymap.set("n", "<leader>fsm", fzf.manpages, { desc = "[F]ZF [S]earch [M]an pages" })
vim.keymap.set("n", "<leader>fso", fzf.nvim_options, { desc = "[F]ZF [S]earch nvim [O]ptions" })
vim.keymap.set("n", "<leader>fsk", fzf.keymaps, { desc = "[F]ZF [S]earch [K]ey mappings" })
vim.keymap.set("n", "<leader>fsc", fzf.commands, { desc = "[F]ZF [S]earch nvim [C]ommands" })

vim.keymap.set("n", "<leader>fgb", fzf.lgrep_curbuf, { desc = "[F]ZF live [G]rep current [B]uffer" })
vim.keymap.set("n", "<leader>fgq", fzf.lgrep_quickfix, { desc = "[F]ZF live [G]rep [Q]uickfix list" })
vim.keymap.set("n", "<leader>fgc", fzf.lgrep_loclist, { desc = "[F]ZF live [G]rep lo[C]ation list" })
vim.keymap.set("n", "<leader>fgp", fzf.live_grep_native, { desc = "[F]ZF live [G]rep current [P]roject" })
vim.keymap.set("n", "<leader>fgv", fzf.grep_visual, { desc = "[F]ZF [G]rep [V]isual selection" })
vim.keymap.set("n", "<leader>fgw", fzf.grep_cword, { desc = "[F]ZF [G]rep [W]ord under cursor" })
vim.keymap.set("n", "<leader>fgW", fzf.grep_cWORD, { desc = "[F]ZF [G]rep [W]ORD under cursor" })

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Enable LSP pickers for FZF",
	group = fzf_group,
	callback = function(event)
		local buf = event.buf
		vim.keymap.set("n", "<leader>flr", fzf.lsp_references, { buffer = buf, desc = "[F]ZF [L]SP [R]eferences" })
		vim.keymap.set("n", "<leader>fld", fzf.lsp_definitions, { buffer = buf, desc = "[F]ZF [L]SP [D]efinitions" })
		vim.keymap.set("n", "<leader>flD", fzf.lsp_declarations, { buffer = buf, desc = "[F]ZF [L]SP [D]eclarations" })
		vim.keymap.set("n", "<leader>flt", fzf.lsp_typedefs, { buffer = buf, desc = "[F]ZF [L]SP [T]ypedefs" })
		vim.keymap.set(
			"n",
			"<leader>fli",
			fzf.lsp_implementations,
			{ buffer = buf, desc = "[F]ZF [L]SP [I]mplementations" }
		)
		vim.keymap.set(
			"n",
			"<leader>fls",
			fzf.lsp_document_symbols,
			{ buffer = buf, desc = "[F]ZF [L]SP document [S]ymbols" }
		)
		vim.keymap.set(
			"n",
			"<leader>flS",
			fzf.lsp_live_workspace_symbols,
			{ buffer = buf, desc = "[F]ZF [L]SP workspace [S]ymbols" }
		)
		vim.keymap.set(
			"n",
			"<leader>flc",
			fzf.lsp_incoming_calls,
			{ buffer = buf, desc = "[F]ZF [L]SP incoming [C]alls" }
		)
		vim.keymap.set(
			"n",
			"<leader>flC",
			fzf.lsp_outgoing_calls,
			{ buffer = buf, desc = "[F]ZF [L]SP outgoing [C]alls" }
		)
		vim.keymap.set("n", "<leader>fla", fzf.lsp_code_actions, { buffer = buf, desc = "[F]ZF [L]SP code [A]ctions" })
		vim.keymap.set("n", "<leader>fll", fzf.lsp_finder, { buffer = buf, desc = "[F]ZF [L]SP [L]ocations" })
		vim.keymap.set(
			"n",
			"<leader>flq",
			fzf.lsp_document_diagnostics,
			{ buffer = buf, desc = "[F]ZF [L]SP document diagnosti[Q]s" }
		)
		vim.keymap.set(
			"n",
			"<leader>flQ",
			fzf.lsp_workspace_diagnostics,
			{ buffer = buf, desc = "[F]ZF [L]SP workspace diagnosti[Q]s" }
		)
	end,
})
