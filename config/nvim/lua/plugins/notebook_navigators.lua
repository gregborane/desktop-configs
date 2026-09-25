-- 1. Load the plugin and its dependencies
vim.pack.add({
  "https://github.com/echasnovski/mini.comment",
  "https://github.com/dangooddd/pyrepl.nvim",
  "https://github.com/anuvyklack/hydra.nvim",
  "https://github.com/gregborane/NotebookNavigator.nvim",
})

-- 2. Define the Keymaps
local map = vim.keymap.set

map("n", "]h", function()
  require("notebook-navigator").move_cell("d")
end, { desc = "Move cell down" })

map("n", "[h", function()
  require("notebook-navigator").move_cell("u")
end, { desc = "Move cell up" })

map("n", "<leader>X", function()
  require("notebook-navigator").run_cell()
end, { desc = "Run cell" })

map("n", "<leader>x", function()
  require("notebook-navigator").run_and_move()
end, { desc = "Run cell and move" })

-- 3. Execute the setup
-- A VimEnter autocommand with vim.schedule perfectly mimics lazy.nvim's `event = "VeryLazy"`
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.schedule(function()
      require("notebook-navigator").setup({
        activate_hydra_keys = "<leader>h",
      })
    end)
  end,
})
