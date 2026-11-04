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
    preset = "none",

    -- Keep Ctrl-based navigation
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<C-y>"] = { "select_and_accept", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
    ["<C-n>"] = { "select_next", "fallback_to_mappings" },

    -- Documentation
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },

    -- Snippets
    ["<Tab>"] = { "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },

    ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
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
      preset = "none",

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
