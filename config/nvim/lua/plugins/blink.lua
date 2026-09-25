-- 1. Add the main plugin and its dependencies
vim.pack.add({
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/saghen/blink.compat" },
  { src = "https://github.com/saghen/blink.lib" },
  { src = "https://github.com/saghen/blink.cmp" },
})

-- 2. Define the configuration options
local opts = {
  snippets = {
    preset = "default",
  },
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = "mono",
  },
  completion = {
    accept = {
      auto_brackets = { enabled = true },
    },
    menu = {
      draw = { treesitter = { "lsp" } },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    ghost_text = {
      enabled = vim.g.ai_cmp,
    },
  },
  sources = {
    compat = {},
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {}, -- initialized to avoid nil errors in the loop below
  },
  cmdline = {
    enabled = true,
    keymap = {
      preset = "cmdline",
      ["<Right>"] = false,
      ["<Left>"] = false,
    },
    completion = {
      list = { selection = { preselect = false } },
      menu = {
        auto_show = function(ctx)
          return vim.fn.getcmdtype() == ":"
        end,
      },
      ghost_text = { enabled = false },
    },
  },
  keymap = {
    preset = "none",
    ["<C-y>"] = { "select_and_accept" },
  },
}

-- 3. Execute the setup logic (formerly inside the `config` function)
-- Note: LazyVim references are preserved. If you are no longer using the
-- LazyVim distribution, you will need to replace `LazyVim.cmp.x` with standard Neovim API calls.

-- Setup compat sources
local enabled = opts.sources.default
for _, source in ipairs(opts.sources.compat or {}) do
  opts.sources.providers[source] = vim.tbl_deep_extend(
    "force",
    { name = source, module = "blink.compat.source" },
    opts.sources.providers[source] or {}
  )

  if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
    table.insert(enabled, source)
  end
end

opts.keymap["<Tab>"] = { "snippet_forward", "fallback" }
opts.keymap["<S-Tab>"] = { "snippet_backward", "fallback" }

-- Unset custom prop to pass blink.cmp validation
opts.sources.compat = nil

-- Check if we need to override symbol kinds
for _, provider in pairs(opts.sources.providers or {}) do
  if provider.kind then
    local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
    local kind_idx = #CompletionItemKind + 1
    CompletionItemKind[kind_idx] = provider.kind
    CompletionItemKind[provider.kind] = kind_idx

    local transform_items = provider.transform_items
    provider.transform_items = function(ctx, items)
      items = transform_items and transform_items(ctx, items) or items
      for _, item in ipairs(items) do
        item.kind = kind_idx or item.kind
        if _G.LazyVim then
          item.kind_icon = LazyVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
        end
      end
      return items
    end

    -- Unset custom prop to pass blink.cmp validation
    provider.kind = nil
  end
end

-- 4. Finally, initialize the plugin
local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup(opts)
