return {
  -- gruvbox.nvim
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("gruvbox")
    end
  },
  -- lualine.nvim
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup()
    end
  }
}

