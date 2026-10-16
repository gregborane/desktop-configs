-- 1. Load the plugin and its dependency
vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
})

-- 2. Define keymaps (previously in the `keys` table)
vim.keymap.set({ "n", "x" }, "<leader>fm", function()
  require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
end, { desc = "Format Injected Langs" })

-- Standard format keymap fallback (if you aren't using LazyVim's auto-formatter)
vim.keymap.set({ "n", "x" }, "<leader>cf", function()
  require("conform").format({ lsp_format = "fallback" })
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
    },
  format_on_save = {
  timeout_ms = 3000,
  lsp_format = "fallback",
},
}

-- 4. Execute setup
require("conform").setup(opts)
