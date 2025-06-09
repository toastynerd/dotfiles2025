return {
  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { 
          "lua", "vim", "vimdoc", "query",
          "javascript", "typescript", "tsx", "json",
          "ruby", "python", "html", "css"
        },
        highlight = { enable = true },
        indent = { enable = true }
      })
    end
  }
}

