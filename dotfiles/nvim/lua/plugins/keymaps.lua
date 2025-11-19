-- telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fp", ":Telescope git_files<cr>")
vim.keymap.set("n", "<leader>fz", ":Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles<cr>")

-- tree
vim.keymap.set("n", "<leader>ee", ":Neotree toggle<cr>")
vim.keymap.set("n", "<leader>fr", ":Neotree focus<cr>")
vim.keymap.set("n", "<leader>oo", ":Neotree focus<cr>")

-- copy to clipboard
vim.keymap.set("n", "<leader>y", '"+yy', { noremap = true, silent = true })
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })

-- formating
vim.keymap.set("n", "<leader>fm", function()
	local bufnr = vim.api.nvim_get_current_buf()
	require("conform").format({ bufnr = bufnr })
end, { desc = "Format buffer with Conform" })
