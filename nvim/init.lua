-- Clear any existing highlighting issues
vim.cmd('highlight clear')
vim.cmd('syntax reset')

-- Basic vim settings
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Add config directory to Lua path
package.path = package.path .. ";" .. vim.fn.stdpath("config") .. "/?.lua"
require("config.lazy")
