return {
  {
    name = "keybinding-help",
    dir = vim.fn.stdpath("config"),
    config = function()
      local function show_keybindings()
        local keybindings = {
          "=== CUSTOM KEYBINDINGS ===",
          "",
          "Leader key: <Space>",
          "",
          "📁 FILE OPERATIONS:",
          "  <Ctrl-p>      - Find files",
          "  <Space>fg     - Live grep (search in files)",
          "  <Space>fb     - Find buffers",
          "  <Space>fh     - Help tags",
          "  <Space>fr     - Recent files", 
          "  <Space>fc     - Commands",
          "  <Space>e      - Toggle file tree",
          "  <Space>f      - Find current file in tree",
          "",
          "🤖 AI ASSISTANCE:",
          "  <Ctrl-j>      - Accept Copilot suggestion (insert mode)",
          "  <Space>cc     - Open Copilot Chat",
          "  <Space>ce     - Explain selected code (visual mode)",
          "  <Space>cf     - Fix selected code (visual mode)", 
          "  <Space>co     - Optimize selected code (visual mode)",
          "",
          "📋 CLIPBOARD:",
          "  <Space>z      - Copy to system clipboard (visual mode)",
          "",
          "ℹ️  HELP:",
          "  <Space>hk     - Show this keybinding help",
          "",
          "Press 'q' to close this help window.",
        }
        
        -- Create a new buffer
        local buf = vim.api.nvim_create_buf(false, true)
        
        -- Set buffer content
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, keybindings)
        
        -- Set buffer options
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
        vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
        vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
        vim.api.nvim_buf_set_option(buf, 'filetype', 'help')
        
        -- Calculate window size
        local width = math.floor(vim.o.columns * 0.8)
        local height = math.floor(vim.o.lines * 0.8)
        local row = math.floor((vim.o.lines - height) / 2)
        local col = math.floor((vim.o.columns - width) / 2)
        
        -- Create floating window
        local win = vim.api.nvim_open_win(buf, true, {
          relative = 'editor',
          width = width,
          height = height,
          row = row,
          col = col,
          style = 'minimal',
          border = 'rounded',
          title = ' Custom Keybindings ',
          title_pos = 'center',
        })
        
        -- Set window options
        vim.api.nvim_win_set_option(win, 'wrap', false)
        vim.api.nvim_win_set_option(win, 'cursorline', true)
        
        -- Close on 'q' or Escape
        vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':close<CR>', { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':close<CR>', { noremap = true, silent = true })
      end
      
      -- Create user command
      vim.api.nvim_create_user_command('Keybindings', show_keybindings, {})
      vim.api.nvim_create_user_command('Keys', show_keybindings, {})
      
      -- Add keybinding
      vim.keymap.set('n', '<leader>hk', show_keybindings, { desc = 'Show custom keybindings' })
    end,
  }
}