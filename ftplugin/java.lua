local keymap = vim.api.nvim_set_keymap
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local workspace_dir = vim.fn.expand('~/.local/workspace/' .. project_name)

local bundles = {vim.fn.glob("/usr/jdtls/plugins/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1)}
vim.list_extend(bundles, vim.split(vim.fn.glob("/usr/jdtls/plugins/vscode-java-test/server/*.jar", 1), "\n"))
local extendedClientCapabilities = require'jdtls'.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
 -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀
    '/usr/jdtls/bin/jdtls', -- or '/path/to/java17_or_newer/bin/java'
            -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    -- '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    -- '-Dosgi.bundles.defaultStartLevel=4',
    -- '-Declipse.product=org.eclipse.jdt.ls.core.product',
    -- '-Dlog.protocol=true',
    -- '-Dlog.level=ALL',
    -- '-Xms1g',
    -- '--add-modules=ALL-SYSTEM',
    -- '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    -- '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    --
    -- -- 💀
    -- '-jar', '/path/to/jdtls_install_location/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar',
    --      -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    --      -- Must point to the                                                     Change this to
    --      -- eclipse.jdt.ls installation                                           the actual version
    --
    --
    -- -- 💀
    -- '-configuration', '/path/to/jdtls_install_location/config_SYSTEM',
    --                 -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    --                 -- Must point to the                      Change to one of `linux`, `win` or `mac`
    --                 -- eclipse.jdt.ls installation            Depending on your system.
    --

    -- 💀
    -- See `data directory configuration` section in the README
    '-data', workspace_dir
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    ['java.format.settings.url'] = os.getenv("HOME") .. "/.config/nvim/format_guide/eclipse-java-google-style.xml",
    ['java.format.settings.profile'] = "GoogleStyle",
    ['java.settings.url'] = os.getenv("HOME") .. "/.config/nvim/ftplugin/java.prefs",
    java = {
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = bundles;
    extendedClientCapabilities = extendedClientCapabilities
  },
}

local opts={noremap = true, silent = true}
keymap("n", "<M-o>", "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
keymap("n", "<C-v>", "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
keymap("v", "<C-v>", "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
keymap("n", "<C-c>", "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
keymap("v", "<C-c>", "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
keymap("n", "<C-m>", "<cmd>lua require('jdtls').extract_method(true)<cr>", opts)
keymap("n", "<leader>df", "<cmd>lua require('jdtls').test_class()<cr>", opts)
keymap("n", "<leader>dn", "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)
keymap("n", "<leader>dm", "<cmd>lua require('jdtls.dap').setup_dap_main_class_configs()<cr>", opts)

config.on_init = function(client, _)
  client.notify('workspace/didChangeConfiguration', { settings = config.settings })
end
config.on_attach = function(_, bufnr)
  require('jdtls').setup_dap()
  require('jdtls.setup').add_commands()
  -- lsp_keymaps(bufnr)
end
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
