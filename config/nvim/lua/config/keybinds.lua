-- set mod key for neovim
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)

-- copy to clipboard
vim.keymap.set("n", "<leader>y", '"+yy', { noremap = true, silent = true })
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, silent = true })

-- set ù to go at the start of a line
vim.keymap.set("n", "ù", "^", { noremap = true, silent = true })
vim.keymap.set("v", "ù", "^", { noremap = true, silent = true })

local function write_and_close_all()
  -- 1. Write the current Python file if it has modifications
  if vim.bo.modified then
    local success, err = pcall(vim.cmd, "w")
    if not success then
      vim.notify("Write failed: " .. tostring(err), vim.log.levels.ERROR)
      return
    end
  end

  -- 2. Explicitly close the pyrepl session
  local has_pyrepl, pyrepl = pcall(require, "pyrepl")
  if has_pyrepl and type(pyrepl.close_repl) == "function" then
    pcall(pyrepl.close_repl)
  end

  -- 3. Quit all windows and exit Neovim
  vim.cmd("qa")
end

-- Create a custom user command :WQP
vim.api.nvim_create_user_command("Wqp", write_and_close_all, {})

-- Abbreviate lowercase entries so typing :wqp triggers the function
vim.cmd("cabbrev wqp Wqp")
