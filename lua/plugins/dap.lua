return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {'nvim-neotest/nvim-nio'},
    config = function()
      local dap = require 'dap'
      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = 'codelldb',
          args = { '--port', '${port}' },
        },
      }
      dap.configurations.c = {
        {
          name = 'Launch - codelldb',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input({
              prompt = 'Path to executable: ',
              default = vim.fn.getcwd() .. '/',
              completion = 'file'
            })
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        }
      }
      dap.configurations.cpp = dap.configurations.c
      dap.configurations.rust = dap.configurations.c
      dap.configurations.zig = dap.configurations.c

      dap.adapters.coreclr = {
        type = 'executable',
        command = 'netcoredbg',
        args = { '--interpreter=vscode' },
      }
      dap.configurations.cs = {
        {
          type = 'coreclr',
          name = 'Launch - netcoredbg',
          request = 'launch',
          program = function()
            return vim.fn.input({
              prompt = 'Path to dll: ',
              default = vim.fn.getcwd(),
              completion = 'file',
            })
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        }
      }

      -- dap ui
      local dapui = require 'dapui'
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.after.event_initialized.dapui_config = function()
        dapui.open {}
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close {}
      end

      -- keymaps
      local dnmap = function(k, f, d)
        require('helpers').nmap(k, f, 'DAP: ' .. d)
      end
      dnmap('<F5>', dap.continue, 'Start/Continue')
      dnmap('<F6>', dap.step_over, 'Step over')
      dnmap('<F7>', dap.step_into, 'Step into')
      dnmap('<F8>', dap.step_out, 'Step out')
      dnmap('<F9>', dapui.toggle, 'Toggle DAP UI')
      dnmap('<F10>', dap.terminate, 'Stop')
      dnmap('<leader>bt', dap.toggle_breakpoint, 'Toggle breakpoint')
      dnmap('<leader>bc', function()
        dap.set_breakpoint(vim.fn.input('Condition: '))
      end, 'Set conditional breakpoint')
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      require('dapui').setup {
        controls = {
          icons = {
            pause = '',
            play = '',
            step_into = '',
            step_over = '',
            step_out = '',
            step_back = '',
            run_last = '',
            terminate = '',
          },
        },
      }
    end,
  },
}
