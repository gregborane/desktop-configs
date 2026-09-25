-- vim-jukit configuration.
-- These globals must be defined before vim-jukit is loaded.
-- The plugin explicitly requires that configuration variables are set first.

vim.g.jukit_shell_cmd = "ipython3"

-- Use Neovim's built-in terminal.
-- Change to "kitty" only if you specifically want jukit's Kitty integration.
vim.g.jukit_terminal = "kitty"

-- Save IPython cell output.
vim.g.jukit_save_output = 1

-- Automatically show saved output for the current cell.
vim.g.jukit_auto_output_hist = 1

-- Default jukit mappings.
vim.g.jukit_mappings = 1

-- Layout:
--
-- ┌─────────────────────┬─────────────────┐
-- │                     │     output      │
-- │      Python         │    / IPython    │
-- │       file          ├─────────────────┤
-- │                     │ output_history  │
-- │                     │                 │
-- └─────────────────────┴─────────────────┘
--
vim.g.jukit_layout = {
  split = "horizontal",
  p1 = 0.65,
  val = {
    "file_content",
    {
      split = "vertical",
      p1 = 0.6,
      val = {
        "output",
        "output_history",
      },
    },
  },
}

-- Install vim-jukit with Neovim's native vim.pack.
vim.pack.add({
  "https://github.com/luk400/vim-jukit",
})
