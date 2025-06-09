return {
  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Example: setup lua_ls for Lua
      require("lspconfig").lua_ls.setup({
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
      })
    end
  },
  -- nvim-autopairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end
  },
  -- copilot.vim
  {
    "github/copilot.vim",
    -- For copilot.lua, use: "zbirenbaum/copilot.lua"
  }
}

