return {
  -- NOTE: Gruber Darker (Tsoding)
  {
    'blazkowolf/gruber-darker.nvim',
    opts = {
      bold = false,
    },
  },

  --NOTE: Black-Metal
  {
    'metalelf0/black-metal-theme-neovim',
    name = 'black-metal',
    lazy = false,
    priority = 1000,
    config = function()
      require('black-metal').setup({
        -- optional configuration here
      })
      require('black-metal').load()
    end,
  },

  --NOTE: ashen
  {
    'ficcdaf/ashen.nvim',
    -- optional but recommended,
    -- pin to the latest stable release:
    lazy = false,
    priority = 1000,
    -- configuration is optional!
    opts = {
      -- your settings here
    },
  },

  --NOTE: zenbones
  {
    'zenbones-theme/zenbones.nvim',
    dependencies = 'rktjmp/lush.nvim',
    lazy = false,
    priority = 1000,
    italic = false,
  },

  -- NOTE: gruvbox
  {
    'sainnhe/gruvbox-material',
    config = function()
      vim.g.gruvbox_material_background = 'hard'
    end,
  },

  -- NOTE: some more themes
  { 'slugbyte/lackluster.nvim' },
  { 'oahlen/iceberg.nvim' },
  { 'EdenEast/nightfox.nvim' },
  { 'jnurmine/Zenburn' },
  -- { 'RRethy/base16-nvim' },
  { 'vim-scripts/zenesque.vim' },  -- burns your eyes away
  { 'jaredgorski/fogbell.vim' },
  { 'CosecSecCot/cosec-twilight.nvim' },



  --NOTE: Makurai
  {
    'Skardyy/makurai-nvim',
    lazy = false,  -- Make sure it loads so the autocmd is registered
    priority = 1000,
    config = function()
      -- 1. Create an Autocmd that waits for the colorscheme to load
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = 'makurai*',  -- Matches makurai, makurai_autumn, makurai_dark, etc.
        callback = function()
          -- Force the highlight groups for underlines
          -- We set 'undercurl' and the special color ('sp') for the squiggly line
          local set_hl = vim.api.nvim_set_hl
          set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = '#FF5555' })
          set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = '#FFB86C' })
          set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = '#8BE9FD' })
          set_hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = '#50FA7B' })

          set_hl(0, 'DapStoppedLine', { bg = '#3d4451', bold = true, italic = true })
          set_hl(0, 'DapStopped', { fg = '#50FA7B', bold = true })
          set_hl(0, 'DapBreakpoint', { fg = '#F527A6' })
          set_hl(0, 'DapBreakpointRejected', { fg = '#BD93F9' })
          set_hl(0, 'DapLogPoint', { fg = '#8BE9FD' })
        end,
      })

      -- 2. Ensure diagnostic underlines are globally enabled
      vim.diagnostic.config({
        underline = true,
        virtual_text = true,
      })
    end,
  },

  --NOTE: vague
  {
    'vague2k/vague.nvim',
    config = function()
      require('vague').setup({
        -- optional configuration here
        -- transparent = true,
        style = {
          -- "none" is the same thing as default. But "italic" and "bold" are also valid options
          boolean = 'none',
          number = 'none',
          float = 'none',
          error = 'none',
          comments = 'none',
          conditionals = 'none',
          functions = 'none',
          headings = 'bold',
          operators = 'none',
          strings = 'none',
          variables = 'none',

          -- keywords
          keywords = 'none',
          keyword_return = 'none',
          keywords_loop = 'none',
          keywords_label = 'none',
          keywords_exception = 'none',

          -- builtin
          builtin_constants = 'none',
          builtin_functions = 'none',
          builtin_types = 'none',
          builtin_variables = 'none',
        },
        colors = {
          func = '#bc96b0',
          keyword = '#787bab',
          -- string = "#d4bd98",
          string = '#8a739a',
          -- string = "#f2e6ff",
          -- number = "#f2e6ff",
          -- string = "#d8d5b1",
          number = '#8f729e',
          -- type = "#dcaed7",
        },
      })
    end,
  },

  -- NOTE: Kanagwa
  {
    'rebelot/kanagawa.nvim',
    config = function()
      require('kanagawa').setup({
        compile = false,   -- enable compiling the colorscheme
        undercurl = true,  -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = false },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true,     -- do not set background color
        dimInactive = false,    -- dim inactive window `:h hl-NormalNC`
        terminalColors = true,  -- define vim.g.terminal_color_{0,17}
        colors = {              -- add/modify theme and palette colors
          palette = {},
          theme = {
            wave = {},
            dragon = {},
            all = {
              ui = {
                bg_gutter = 'none',
                border = 'rounded',
              },
            },
          },
        },
        overrides = function(colors)  -- add/modify highlights
          local theme = colors.theme
          return {
            NormalFloat = { bg = 'none' },
            FloatBorder = { bg = 'none' },
            FloatTitle = { bg = 'none' },
            Pmenu = { fg = theme.ui.shade0, bg = 'NONE', blend = vim.o.pumblend },  -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptBorder = { fg = theme.ui.special },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim },
            TelescopeResultsBorder = { fg = theme.ui.special },
            TelescopePreviewBorder = { fg = theme.ui.special },
          }
        end,
        theme = 'wave',   -- Load "wave" theme when 'background' option is not set
        background = {    -- map the value of 'background' option to a theme
          dark = 'wave',  -- try "dragon" !
        },
      })
    end,
  },
}
