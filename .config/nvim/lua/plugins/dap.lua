return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mfussenegger/nvim-dap-python',
    'theHamsta/nvim-dap-virtual-text',
  },
  keys = {
    { '<leader>Dc', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<leader>Dsi', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<leader>DsO', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<leader>Dso', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<leader>Db', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
    { '<leader>DB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Conditional Breakpoint' },
    { '<leader>Dt', function() require('dapui').toggle() end, desc = 'Debug: Toggle UI' },
    { '<leader>Dl', function() require('dap').run_last() end, desc = 'Debug: Run Last Configuration' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸', play = '▶', step_into = '⏎', step_over = '⏭',
          step_out = '⏮', step_back = 'b', run_last = '▶▶', terminate = '⏹', disconnect = '⏏',
        },
      },
    }

    -- 1. DEFINE THE SIGNS TO USE YOUR HIGHLIGHT GROUPS
    -- This is what actually paints the background of the current line
    vim.fn.sign_define('DapStopped', {
      text = '→',
      texthl = 'DapStopped',
      linehl = 'DapStoppedLine',
      numhl = 'DapStoppedLine',
    })
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition',
      { text = '●', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DapLogPoint', linehl = '', numhl = '' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    require('nvim-dap-virtual-text').setup()

    -- 2. PYTHON CONFIGURATION
    require('dap-python').setup('debugpy-adapter')
    table.insert(dap.configurations.python, {
      type = 'python',
      request = 'launch',
      name = 'from workspace (External Libs)',
      program = '${file}',
      console = 'integratedTerminal',
      cwd = '${workspaceFolder}',
      justMyCode = false,  -- Allows stepping into Stable Baselines 3 etc.
    })
  end,
}
