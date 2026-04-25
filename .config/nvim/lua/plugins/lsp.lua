return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'folke/lazydev.nvim',
        ft = 'lua',  -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
    },
    config = function()
      vim.opt.updatetime = 250
      -- ════════════════════════════════════════════════════════════════════
      -- LSP Keymaps Setup
      -- ════════════════════════════════════════════════════════════════════
      local function setup_keymaps(bufnr)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
        end

        -- Hover & Signature
        map('n', 'K', function()
          vim.lsp.buf.hover({ border = 'rounded', max_height = 25, max_width = 120 })
        end, 'Hover')
        map({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, 'Signature Help')

        -- gd, gD, gr, gi, gy handled by Snacks picker (snacks.lua)

        map('n', '<leader>fm', vim.lsp.buf.format, 'Format Code')

        -- Diagnostics navigation
        map('n', 'pd', function() vim.diagnostic.jump({ count = -1 }) end, 'Prev Diagnostic')
        map('n', 'nd', function() vim.diagnostic.jump({ count = 1 }) end, 'Next Diagnostic')

        -- <leader>c = Code
        map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('n', '<leader>cd', vim.diagnostic.open_float, 'Line Diagnostic')
        map('n', '<leader>cv', '<cmd>vsplit | lua vim.lsp.buf.definition()<cr>', 'Definition in Vsplit')

        -- <leader>l = LSP
        map('n', '<leader>li', '<cmd>LspInfo<cr>', 'LSP Info')
        map('n', '<leader>lr', '<cmd>LspRestart<cr>', 'LSP Restart')
        map('n', '<leader>lh', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
        end, 'Toggle Inlay Hints')
      end
      -- ════════════════════════════════════════════════════════════════════
      -- LSP Attach Handler
      -- ════════════════════════════════════════════════════════════════════
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          setup_keymaps(bufnr)
          vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Inlay hints disabled by default (toggle with <leader>lh)

          -- Document highlight on cursor hold
          if client.server_capabilities.documentHighlightProvider then
            local group = vim.api.nvim_create_augroup('LspDocumentHighlight_' .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = bufnr,
              group = group,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = bufnr,
              group = group,
              callback = vim.lsp.buf.clear_references,
            })
          end

          vim.api.nvim_create_autocmd('CursorHold', {
            buffer = bufnr,
            callback = function()
              local opts = {
                focusable = false,
                close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
                border = 'rounded',
                source = 'always',
                prefix = ' ',
                scope = 'cursor',
              }
              vim.diagnostic.open_float(nil, opts)
            end,
          })
        end,
      })


      -- ════════════════════════════════════════════════════════════════════
      -- Diagnostic Configuration
      -- ════════════════════════════════════════════════════════════════════
      vim.diagnostic.config({
        --virtual_lines = true,
        virtual_text = false,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = true,
          header = '',
          prefix = '',
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
            [vim.diagnostic.severity.WARN] = 'WarningMsg',
          },
        },
      })

      vim.lsp.enable({
        'lua_ls',
        --"basedpyright",
        'pyrefly',
        'dockerls',
        'ruff',
        'bashls',
      })
    end,
  },
}
