-- Clear any existing highlighting issues
vim.cmd('highlight clear')
vim.cmd('syntax reset')

-- Basic vim settings
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamed"

-- Default indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- TSX/JSX specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"typescriptreact", "javascriptreact"},
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

-- Add config directory to Lua path
package.path = package.path .. ";" .. vim.fn.stdpath("config") .. "/?.lua"


require("config.lazy")
