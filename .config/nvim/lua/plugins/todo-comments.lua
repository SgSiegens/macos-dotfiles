return {
  'folke/todo-comments.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local todo_comments = require('todo-comments')

    todo_comments.setup({
      signs = true,    -- show icons in the signs column
      sign_priority = 8,  -- sign priority

      keywords = {
        FIX = {
          icon = ' ',
          color = 'error',
          alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' },
        },
        TODO = { icon = ' ', color = 'info', alt = { 'Personal' } },
        HACK = { icon = ' ', color = 'warning', alt = { 'DON SKIP' } },
        WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
        PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = { icon = ' ', color = 'hint', alt = { 'INFO', 'READ', 'COLORS', 'Custom' } },
        TEST = { icon = '⏲ ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
        -- Your custom keyword
        FORGETNOT = { icon = ' ', color = 'hint' },
      },

      gui_style = {
        fg = 'NONE',  -- The gui style to use for the fg highlight group.
        bg = 'BOLD',  -- The gui style to use for the bg highlight group.
      },

      colors = {
        error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
        warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
        info = { 'DiagnosticInfo', '#2563EB' },
        hint = { 'DiagnosticHint', '#10B981' },
        default = { 'Identifier', '#7C3AED' },
        test = { 'Identifier', '#FF00FF' },
      },

      highlight = {
        multiline = true,
        multiline_pattern = '^.',
        multiline_context = 10,
        before = '',
        keyword = 'wide',
        after = 'fg',
        pattern = {
          [[.*<(KEYWORDS)\s*:]],  -- default pattern
          [[]],              -- HTML comments with colon
          [[]],              -- HTML comments without colon
        },
        comments_only = false,
        max_line_len = 400,
      },

      search = {
        command = 'rg',
        args = {
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
        },
        pattern = [[\b(KEYWORDS)\b]],
      },
    })

    -- Keymaps
    vim.keymap.set('n', ']t', function()
      todo_comments.jump_next()
    end, { desc = 'Next todo comment' })

    vim.keymap.set('n', '[t', function()
      todo_comments.jump_prev()
    end, { desc = 'Previous todo comment' })

    vim.keymap.set('n', '<leader>tl', '<cmd>TodoLocList<CR>', { desc = 'Show TODOs in location list' })
  end,
}
