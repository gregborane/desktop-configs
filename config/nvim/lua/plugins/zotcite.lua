-- 1. Load the plugin and its dependencies
vim.pack.add({
  "https://github.com/jalvesaq/zotcite",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-telescope/telescope.nvim",
})

-- 2. Execute the setup
require("zotcite").setup({})
