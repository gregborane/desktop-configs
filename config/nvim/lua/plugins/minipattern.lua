-- 1. Load the plugin and its dependency
vim.pack.add({
  "https://github.com/GCBallesteros/NotebookNavigator.nvim",
  "https://github.com/echasnovski/mini.hipatterns",
})

-- 2. Execute the setup
-- We simulate `event = "VeryLazy"` by deferring the setup until after startup
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.schedule(function()
      local nn = require("notebook-navigator")

      local opts = {
        highlighters = {
          cells = nn.minihipatterns_spec,
        },
      }

      require("mini.hipatterns").setup(opts)
    end)
  end,
})
