vim.pack.add({
	"https://github.com/rafamadriz/friendly-snippets",
	"https://github.com/nvim-mini/mini.nvim",
})

local mini_group = vim.api.nvim_create_augroup("MiniGroup", { clear = true })

-------------------------------------
--
-- General pluggings
--
-------------------------------------

local basics = require("mini.basics")
basics.setup({
	options = {
		extra_ui = true,
	},
	mappings = {
		windows = true,
		move_with_alt = true,
	},
	autocommands = {
		relnum_in_visual_mode = true,
	},
})

-- Bracketed movement i.e. [ or ] and motion pairs to move around
require("mini.bracketed").setup()

-- Buffer manipulation
local bufr = require("mini.bufremove")
bufr.setup()

vim.keymap.set("n", "<leader>bd", bufr.delete, { desc = "[B]uffers [D]elete current" })
vim.keymap.set("n", "<leader>bw", bufr.wipeout, { desc = "[B]uffers [W]ipeout current" })
vim.keymap.set("n", "<leader>bu", bufr.unshow, { desc = "[B]uffers [U]nshow current" })

-- Better commandline input
require("mini.cmdline").setup()

-- Diff block manipulation
require("mini.diff").setup()

-- Extra features for other Mini pluggins
local extra = require("mini.extra")
extra.setup()

-- Mini git command integration
require("mini.git").setup()

-- Better ftFT jumping
require("mini.jump").setup()

-- Interactive jump across visible text
require("mini.jump2d").setup()

-------------------------------------
--
-- Text manipulation pluggings
--
-------------------------------------

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require("mini.ai").setup({
	-- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
	mappings = {
		around_next = "aa",
		inside_next = "ii",
	},
	custom_textobjects = {
		B = extra.gen_ai_spec.buffer(),
		D = extra.gen_ai_spec.diagnostic(),
		I = extra.gen_ai_spec.indent(),
		L = extra.gen_ai_spec.line(),
		N = extra.gen_ai_spec.number(),
	},
})

-- Interactive text alignment
require("mini.align").setup()

-- Easy code commenting
require("mini.comment").setup()

-- Simple completion engine
require("mini.completion").setup({
	lsp_completion = { source_func = "omnifunc", auto_setup = false },
})

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Enable MiniCompletion on LSP attatch",
	group = mini_group,
	callback = function(args)
		vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
	end,
})

-- Special keymaps
local km = require("mini.keymap")
km.setup()
local map_multistep = km.map_multistep
local map_combo = km.map_combo

map_multistep("i", "<Tab>", { "pmenu_next" })
map_multistep("i", "<S-Tab>", { "pmenu_prev" })
map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
map_multistep("i", "<BS>", { "minipairs_bs" })

-- Support most common modes. This can also contain "t", but would
-- only mean to press `<Esc>` inside terminal.
local mode = { "i", "c", "x", "s" }
map_combo(mode, "jk", "<BS><BS><Esc>")

-- To not have to worry about the order of keys, also map "kj"
map_combo(mode, "kj", "<BS><BS><Esc>")

-- Escape into Normal mode from Terminal mode
map_combo("t", "jk", "<BS><BS><C-\\><C-n>")
map_combo("t", "kj", "<BS><BS><C-\\><C-n>")

local notify_many_keys = function(key)
	local lhs = string.rep(key, 5)
	local action = function()
		vim.notify("Too many " .. key)
	end
	map_combo({ "n", "x" }, lhs, action)
end

notify_many_keys("h")
notify_many_keys("j")
notify_many_keys("k")
notify_many_keys("l")

-- Moving code blocks in all directions with ALT-hjkl
require("mini.move").setup()

-- Text operators
require("mini.operators").setup()

-- Automatically pair "pairing" characters e.g. {["'(
require("mini.pairs").setup()

-- Code snippets for completion
local snips = require("mini.snippets")
snips.setup({
	snippets = {
		-- Load snippets based on current language by reading files from
		-- "snippets/" subdirectories from "runtimepath" directories.
		-- including friendly-snippets
		snips.gen_loader.from_lang(),
	},
})

vim.schedule(function()
	snips.start_lsp_server({ match = false })
end)

-- Split or join text blocks delimited by "pairing" charactes
require("mini.splitjoin").setup()

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require("mini.surround").setup()

-------------------------------------
--
-- Visual pluggings
--
-------------------------------------

-- Underline word under cursor
require("mini.cursorword").setup()

-- Special word highlighting
local hip = require("mini.hipatterns")
hip.setup({
	highlighters = {
		fixme = extra.gen_highlighter.words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
		hack = extra.gen_highlighter.words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
		todo = extra.gen_highlighter.words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
		note = extra.gen_highlighter.words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),

		-- Highlight hex color strings (`#rrggbb`) using that color
		hex_color = hip.gen_highlighter.hex_color(),
	},
})

-- If a nerd font is available, load the icons module for pretty icons in various plugins.
if vim.g.have_nerd_font then
	local icons = require("mini.icons")
	icons.setup()
	-- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
	icons.mock_nvim_web_devicons()
	-- For LSP completition icons
	icons.tweak_lsp_kind()
end

-- Visual indentation scope
-- no mappings needed thanks to motion pluggings
require("mini.indentscope").setup({
	mappings = {
		object_scope = "",
		object_scope_with_border = "",
		goto_top = "",
		goto_bottom = "",
	},
})

-- Buffer overview map
-- With search, MiniDiff, and diagnostics integrations
local mm = require("mini.map")
mm.setup({
	integrations = {
		mm.gen_integration.builtin_search(),
		mm.gen_integration.diff(),
		mm.gen_integration.diagnostic(),
	},
})

vim.keymap.set("n", "<leader>mt", mm.toggle, { desc = "[M]iniMap [T]oggle" })
vim.keymap.set("n", "<leader>ms", mm.toggle_side, { desc = "[M]iniMap toggle [S]ide" })
vim.keymap.set("n", "<leader>mr", mm.refresh, { desc = "[M]iniMap [R]efresh" })
-- vim.schedule(function() mm.toggle() end)

-- Better notifications
require("mini.notify").setup()

-- Better statusline
require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })

-- Better tabline
require("mini.tabline").setup({ use_icons = vim.g.have_nerd_font })

-- Trailspace highlighting and cleaning
local trailspace = require("mini.trailspace")
trailspace.setup()

vim.keymap.set("n", "<leader>ct", trailspace.trim, { desc = "[C]leaning trim [T]railing whitespace" })
vim.keymap.set("n", "<leader>cl", trailspace.trim_last_lines, { desc = "[C]leaning trim last blank [L]ines" })
