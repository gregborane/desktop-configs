-- 1. Add the main plugin and its dependencies
vim.pack.add({
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/saghen/blink.lib",
  "https://github.com/saghen/blink.cmp",
})

local cmp = require("blink.cmp")
cmp.build():pwait()

cmp.setup({
  keymap = {
    preset = "default",
  },

  completion = {
    keyword = { range = "full" },
    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },
    menu = {
      draw = { treesitter = { "lsp" } },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    ghost_text = { enabled = true },
  },

  cmdline = {
    keymap = {
      preset = "cmdline",
      ["<Right>"] = false,
      ["<Left>"] = false,
      -- Avoid the cmdline preset's insertion-on-Tab behavior.
      ["<Tab>"] = { "show", "select_next", "fallback" },
      ["<S-Tab>"] = { "show", "select_prev", "fallback" },
    },
    completion = {
      list = {
        selection = { preselect = false, auto_insert = false },
      },
      menu = {
        auto_show = function()
          return vim.fn.getcmdtype() == ":"
        end,
      },
      ghost_text = { enabled = false },
    },
  },
})
