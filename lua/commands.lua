local commands_group = vim.api.nvim_create_augroup("CommandsGroup", { clear = true })

-- Auto return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Restore last cursor position",
	group = commands_group,
	callback = function()
		if vim.o.diff then -- except in diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- wrap, line-break and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
	desc = "Enable text wrapping, line breaking and spell check on text files",
	group = commands_group,
	pattern = { "tex", "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})
