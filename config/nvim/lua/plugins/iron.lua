vim.pack.add({
  { src = "https://github.com/gregborane/iron.nvim" },
})

vim.opt.termguicolors = true
local iron = require("iron.core")
local view = require("iron.view")
local common = require("iron.fts.common")

iron.setup({
  config = {
    scratch_repl = true,
    close_window_on_exit = false,
    repl_definition = {
      sh = {
        command = { "sh" },
      },
      python = {
        command = { "jupyter-console" },
        format = common.bracketed_paste,
        image = {
          protocol = "sixel",
          cell_width = 8,
          cell_height = 16,
        },
        block_dividers = { "# %%", "#%%" },
        env = { PYTHON_BASIC_REPL = "1" },
      },
    },
    repl_filetype = function(bufnr, ft)
      return ft
    end,
    dap_integration = true,
    repl_open_cmd = view.split.vertical.rightbelow("%40"),
  },
  keymaps = {
    -- implemented local function to have
    -- good looking name for which keys
    -- plugins
  },
  highlight = {
    italic = true,
  },
})

vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
vim.keymap.set("n", "<space>ro", "<cmd>IronRepl<cr>")
vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
vim.keymap.set("n", "<space>rq", "<cmd>IronQuit<cr>")
vim.keymap.set("n", "<space>rc", "<cmd>IronClear<cr>")
vim.keymap.set("n", "<space>x", "<cmd>IronExecCell<cr>")
vim.keymap.set("n", "<space>rx", "<cmd>IronInterupt<cr>")
