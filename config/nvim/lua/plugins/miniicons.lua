-- 1. Load the plugin
vim.pack.add({
  "https://github.com/nvim-mini/mini.icons",
})

-- 2. Execute the setup
require("mini.icons").setup()

-- 3. (Optional but recommended) Mock nvim-web-devicons
-- This forces other plugins that rely on web-devicons to use mini.icons instead.
require("mini.icons").mock_nvim_web_devicons()
