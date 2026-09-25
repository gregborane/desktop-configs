-- 1. Load the plugin
vim.pack.add({
  "https://github.com/dangooddd/pyrepl.nvim",
})

-- 2. Execute the setup
local pyrepl = require("pyrepl")
local vsplit = 0.3

pyrepl.setup({
  split_horizontal = false,
  split_ratio = vsplit,
  style = "default",
  -- generate jupyter-console theme from neovim theme
  style_integration = true,
  image_max_history = 10,
  image_width_ratio = vsplit,
  image_height_ratio = 0.5,
  -- built-in provider, works best for ghostty and kitty
  -- for other terminals use "image" provider
  image_provider = "placeholders",
  -- can also be a function for advanced use cases
  cell_pattern = "^# %%%%.*$",
  python_path = vim.g.python3_host_prog or "python3",
  preferred_kernel = "jupyter-console",
  -- automatically prompt to convert notebook files into python scripts
  jupytext_hook = false,
})

-- 3. Define the keymaps
local map = vim.keymap.set

-- REPL UI-related commands
map("n", "<leader>jo", pyrepl.open_repl, { desc = "Open REPL" })
map("n", "<leader>jh", pyrepl.hide_repl, { desc = "Hide REPL" })
map("n", "<leader>jc", pyrepl.close_repl, { desc = "Close REPL" })
map("n", "<leader>jt", pyrepl.toggle_repl, { desc = "Toggle REPL" })
map("n", "<leader>i", pyrepl.open_image_history, { desc = "Open Image History" })
map({ "n", "t" }, "<C-j>", pyrepl.toggle_repl_focus, { desc = "Toggle REPL Focus" })

-- Send commands
map("n", "<leader>jb", pyrepl.send_buffer, { desc = "Send Buffer" })
map("n", "<leader>js", pyrepl.send_cell, { desc = "Send Cell" })
map("v", "<leader>jv", pyrepl.send_visual, { desc = "Send Visual" })

-- QoL commands
map("n", "<leader>jp", pyrepl.step_cell_backward, { desc = "Step Cell Backward" })
map("n", "<leader>jn", pyrepl.step_cell_forward, { desc = "Step Cell Forward" })
map("n", "<leader>je", pyrepl.export_to_notebook, { desc = "Export to Notebook" })

-- Changed from `<leader>js` to avoid conflict with `send_cell`,
-- and wrapped in <cmd>...<CR> to execute without needing to press Enter.
map("n", "<leader>jI", "<cmd>PyreplInstall<CR>", { desc = "Install Pyrepl" })
