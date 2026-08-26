vim.pack.add({
    "https://github.com/Mofiqul/dracula.nvim"
})

vim.schedule(function() vim.cmd("colorscheme dracula") end)
