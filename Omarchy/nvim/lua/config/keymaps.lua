-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local nn = require("notebook-navigator")
vim.keymap.set("n", "]h", function()
  nn.move_cell("d")
end)
vim.keymap.set("n", "[h", function()
  nn.move_cell("u")
end)
vim.keymap.set("n", "M", function()
  nn.run_cell()
end)
vim.keymap.set("n", "<leader>m", function()
  nn.run_and_move()
end)
