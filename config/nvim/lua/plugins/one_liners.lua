-- 1. Load the plugins
vim.pack.add({
  -- This helps with php/html for indentation
    "https://github.com/captbaritone/better-indent-support-for-php-with-html" ,

  -- This helps with ssh tunneling and copying to clipboard
    "https://github.com/ojroques/vim-oscyank",

  -- This generates docblocks
  -- NOTE: Run `:call doge#install()` manually after the initial download!
    "https://github.com/kkoomen/vim-doge",

  -- Git plugin
    "https://github.com/tpope/vim-fugitive",

  -- Common Lua utility library (used as a dependency for many plugins)
    "https://github.com/nvim-lua/plenary.nvim",

  -- Show historical versions of the file locally
    "https://github.com/mbbill/undotree",

  -- Show CSS Colors
    "https://github.com/brenoprata10/nvim-highlight-colors",
})

-- 2. Execute setups for plugins that require it
require("nvim-highlight-colors").setup({})
