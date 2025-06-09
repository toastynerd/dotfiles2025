-- Clear any existing highlighting issues
vim.cmd('highlight clear')
vim.cmd('syntax reset')

-- Basic vim settings
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

require("config.lazy")
