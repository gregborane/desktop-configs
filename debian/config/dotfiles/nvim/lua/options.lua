vim.o.termguicolors = true
vim.opt.nu = true -- enable line numbers
vim.opt.relativenumber = true -- relative line numbers

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local groups =
			{ "Normal", 
			  "NormalNC", 
			  "NormalFloat", 
			  "SignColumn", 
			  "LineNr", 
			  "VertSplit",  
			  "StatusLine", 
			  "StatusLineNC" }
		for _, group in ipairs(groups) do
			vim.api.nvim_set_hl(0, group, { bg = "none" })
		end
	end,
})

vim.api.nvim_create_autocmd({ "VimResized", "WinNew", "WinClosed" }, {
  callback = function()
    vim.cmd("wincmd =")
  end,
})

