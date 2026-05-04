-- set mod key for neovim
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)

-- copy to clipboard
vim.keymap.set("n", "<leader>y", '"+yy', { noremap = true, silent = true })
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })

-- set ù to go at the start of a line
vim.keymap.set("n", "ù", "^", { noremap = true, silent = true })
