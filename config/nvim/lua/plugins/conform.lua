-- 1. Load the plugin and its dependency
vim.pack.add({
  { src = "https://github.com/williamboman/mason.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
})

-- 2. Define keymaps (previously in the `keys` table)
vim.keymap.set({ "n", "x" }, "<leader>fm", function()
  require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
end, { desc = "Format Injected Langs" })

-- Standard format keymap fallback (if you aren't using LazyVim's auto-formatter)
vim.keymap.set({ "n", "x" }, "<leader>cf", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "Format buffer" })

-- 3. Define the options
local opts = {
  default_format_opts = {
    timeout_ms = 3000,
    async = false,
    quiet = false,
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    latex = { "tex-fmt" },
    tex = { "tex-fmt" },
    bib = { "tex-fmt" },
    -- Note: Neovim's default filetype for Python is `python`, not `py`.
    -- Changed here to ensure it actually triggers for Python files.
    python = { "ruff" },
  },
  formatters = {
    injected = { options = { ignore_errors = true } },
    latexindent = {
      prepend_args = { "-m" },
    },
  },
  format_on_save = {
  timeout_ms = 3000,
  lsp_format = "fallback",
},
}

-- 4. Execute setup
require("conform").format({ lsp_format = "fallback" })

-- 5. LazyVim format registration (previously in `init`)
-- We wrap this to ensure it only runs if the LazyVim global actually exists.
if _G.LazyVim then
  -- Replicate LazyVim.on_very_lazy since we are bypassing lazy.nvim
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      LazyVim.format.register({
        name = "conform.nvim",
        priority = 100,
        primary = true,
        format = function(buf)
          require("conform").format({ bufnr = buf })
        end,
        sources = function(buf)
          local ret = require("conform").list_formatters(buf)
          ---@param v conform.FormatterInfo
          return vim.tbl_map(function(v)
            return v.name
          end, ret)
        end,
      })
    end,
  })
else
  -- If you are NOT using LazyVim anymore and want format-on-save,
  -- uncomment the following autocmd:
  --[[
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
      require("conform").format({ bufnr = args.buf })
    end,
  })
  --]]
end
