vim.g.mapleader = " "

-- switch tab
vim.keymap.set("n", "<leader>nn", ":bn<cr>")
vim.keymap.set("n", "<leader>pp", ":bp<cr>")
vim.keymap.set("n", "<leader>tt", ":bd<cr>")

-- swtich dir 
vim.keymap.set("n", "<leader>p", ":cd ..<cr>", { noremap = true, silent = true })

