return {
  -- GitHub Copilot
  {
    "github/copilot.vim",
    lazy = false, -- Load immediately instead of on InsertEnter
    config = function()
      vim.g.copilot_filetypes = {
        ["*"] = true,
      }
      
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.g.copilot_no_tab_map = true
    end,
  },

  -- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("CopilotChat").setup({
        debug = false,
        window = {
          layout = 'vertical',
          width = 0.4,
        },
      })
      
      -- Keybindings
      vim.keymap.set('n', '<leader>cc', ':CopilotChat<CR>', { desc = 'Open Copilot Chat' })
      vim.keymap.set('v', '<leader>ce', ':CopilotChatExplain<CR>', { desc = 'Explain selected code' })
      vim.keymap.set('v', '<leader>cf', ':CopilotChatFix<CR>', { desc = 'Fix selected code' })
      vim.keymap.set('v', '<leader>co', ':CopilotChatOptimize<CR>', { desc = 'Optimize selected code' })
    end,
  },

  -- Cross-platform clipboard
  {
    "ojroques/nvim-osc52",
    config = function()
      require('osc52').setup {
        max_length = 0,      -- Maximum length of selection (0 for no limit)
        silent = false,      -- Disable message on successful copy
        trim = false,        -- Trim surrounding whitespaces before copy
      }
      
      -- Copy to system clipboard
      vim.keymap.set('v', '<leader>z', require('osc52').copy_visual, { desc = 'Copy to system clipboard' })
    end,
  },
  
  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  }
}

