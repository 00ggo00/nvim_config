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
