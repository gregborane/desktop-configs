-- 1. Load the plugin (and its typical web-devicons dependency)
vim.pack.add({
    { src = "https://github.com/akinsho/bufferline.nvim"},
    { src = "https://github.com/nvim-tree/nvim-web-devicons"},
}) -- usually required for bufferline icons

-- 2. Define keymaps (previously handled by Lazy's `keys` table)
local map = vim.keymap.set
local km_opts = { silent = true }

map("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle Pin", silent = true })
map("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete Non-Pinned Buffers", silent = true })
map("n", "<leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete Buffers to the Right", silent = true })
map("n", "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete Buffers to the Left", silent = true })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer", silent = true })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer", silent = true })
map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer", silent = true })
map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer", silent = true })
map("n", "[B", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer prev", silent = true })
map("n", "]B", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer next", silent = true })
map("n", "<leader>bj", "<cmd>BufferLinePick<cr>", { desc = "Pick Buffer", silent = true })

-- 3. Define the options
local opts = {
  options = {
    -- Fallback to standard bufdelete if Snacks is not installed
    close_command = function(n)
      if _G.Snacks then
        Snacks.bufdelete(n)
      else
        vim.api.nvim_buf_delete(n, {})
      end
    end,
    right_mouse_command = function(n)
      if _G.Snacks then
        Snacks.bufdelete(n)
      else
        vim.api.nvim_buf_delete(n, {})
      end
    end,
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
    diagnostics_indicator = function(_, _, diag)
      -- Fallback icons if LazyVim is not present
      local icons = _G.LazyVim and LazyVim.config.icons.diagnostics or { Error = " ", Warn = " " }
      local ret = (diag.error and icons.Error .. diag.error .. " " or "")
        .. (diag.warning and icons.Warn .. diag.warning or "")
      return vim.trim(ret)
    end,
    offsets = {
      {
        filetype = "neo-tree",
        text = "Neo-tree",
        highlight = "Directory",
        text_align = "left",
      },
      {
        filetype = "snacks_layout_box",
      },
    },
    ---@param element bufferline.IconFetcherOpts
    get_element_icon = function(element)
      if _G.LazyVim then
        return LazyVim.config.icons.ft[element.filetype]
      end
      -- Return nil to let bufferline fallback to standard web-devicons
      return nil
    end,
  },
}

-- 4. Execute the setup
require("bufferline").setup(opts)

-- Fix bufferline when restoring a session
vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
  callback = function()
    vim.schedule(function()
      pcall(nvim_bufferline)
    end)
  end,
})
