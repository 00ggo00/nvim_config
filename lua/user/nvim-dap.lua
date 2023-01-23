local dap, dapui = require("dap"), require("dapui")
vim.api.nvim_set_hl(0, 'DapBreakpoint', {fg='#ff4000', })
vim.api.nvim_set_hl(0, 'DapBreakpointCondition', {fg='#f4c430', })
vim.api.nvim_set_hl(0, 'DapLogPoint', {fg='#348796', })
vim.api.nvim_set_hl(0, 'DapBreakpointRejected', {fg='#ff4000', })
vim.api.nvim_set_hl(0, 'DapStopped', {fg='#00cc00', })
vim.fn.sign_define('DapBreakpoint', {text='', texthl='DapBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='', texthl='DapBreakpointCondition', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='', texthl='DapLogPoint', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='DapBreakpointRejected', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='DapStopped', linehl='', numhl=''})

local keymap = vim.api.nvim_set_keymap
local opt = {noremap = true, silent = true}
keymap("n", "<F5>", "<cmd>lua require('dap').continue()<cr>", opt)
keymap("n", "<F10>", "<cmd>lua require('dap').step_over()<cr>", opt)
keymap("n", "<F11>", "<cmd>lua require('dap').step_into()<cr>", opt)
keymap("n", "<F12>", "<cmd>lua require('dap').step_out()<cr>", opt)


dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.disconnect["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
-- dap.listeners.before.event_stopped["dapui_config"] = function()
--   dapui.close()
-- end
-- dap.listeners.after.startDebugging= function(session, body)
  -- print(vim.inspect(session), vim.inspect(body))
-- end


dap.set_log_level("TRACE")
dap.adapters["pwa-node"]= {
  -- type = "executable",
  -- command = "/root/.local/share/nvim/mason/packages/js-debug-adapter/js-debug-adapter",
  -- arg = {"45635"}
  type = "server",
  host = "127.0.0.1",
  port = 53236,
  executable = {
    command = os.getenv("HOME").."/.local/share/nvim/mason/packages/js-debug-adapter/js-debug-adapter",
    -- args = {"53236"},
    -- cwd = "${workspaceFolder}"
  }
}
dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch Program",
    program = "hello.js",
    cwd = "${workspaceFolder}",
    port = 53236,
    remoteRoot = "${workspaceFolder}"
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "attach Program",
    processId = require("dap.utils").pick_process
  }
}
