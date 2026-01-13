-- OPTIONS
local set = vim.opt

--line nums
set.relativenumber = true
set.number = true

-- indentation and tabs
set.tabstop = 4
set.shiftwidth = 4
set.autoindent = true
set.expandtab = true

-- cursor line
set.cursorline = true

-- correcting ctrl-c to escape insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- keep cursor at least 20 rows from top/bot
set.scrolloff = 20

-- remove swap files
vim.opt.swapfile = false

-- options for lsp_lines plugins
vim.diagnostic.config({ virtual_text = false, virtual_lines = true })

