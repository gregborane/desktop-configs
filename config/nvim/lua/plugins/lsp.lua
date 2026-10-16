-- 1. Load the plugins
vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
})

-- Runs Mason setup and your tool installation configuration first.
require("plugins.mason")

-- 2. Define the configuration options (formerly `opts`)
local opts = {
  diagnostics = {
    underline = false,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = _G.LazyVim and LazyVim.config.icons.diagnostics.Error or " ",
        [vim.diagnostic.severity.WARN] = _G.LazyVim and LazyVim.config.icons.diagnostics.Warn or " ",
        [vim.diagnostic.severity.HINT] = _G.LazyVim and LazyVim.config.icons.diagnostics.Hint or " ",
        [vim.diagnostic.severity.INFO] = _G.LazyVim and LazyVim.config.icons.diagnostics.Info or " ",
      },
    },
  },
  inlay_hints = { enabled = false, exclude = { "vue" } },
  codelens = { enabled = false },
  folds = { enabled = true },

  -- Server specific settings
  servers = {
    stylua = { enabled = false },
    lua_ls = {
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          codeLens = { enable = true },
          completion = { callSnippet = "Replace" },
          doc = { privateName = { "^_" } },
          hint = {
            enable = true,
            setType = false,
            paramType = true,
            paramName = "Disable",
            semicolon = "Disable",
            arrayIndex = "Disable",
          },
        },
      },
    },
  },
  setup = {
    -- custom setup functions for specific servers can go here
  },
}

-- 3. Apply Diagnostic configuration globally
vim.diagnostic.config(opts.diagnostics)

-- 4. Set up LspAttach Autocommand (replaces LazyVim's custom event hooks)
-- This runs every time an LSP server attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local buffer = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = buffer, desc = "LSP: " .. desc })
    end

    -- Keymaps (converted from your servers["*"].keys table)
    map("<leader>cl", "<cmd>LspInfo<cr>", "Lsp Info")
    map("gd", vim.lsp.buf.definition, "Goto Definition")
    map("gr", vim.lsp.buf.references, "References")
    map("gI", vim.lsp.buf.implementation, "Goto Implementation")
    map("gy", vim.lsp.buf.type_definition, "Goto T[y]pe Definition")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("K", vim.lsp.buf.hover, "Hover")
    map("gK", vim.lsp.buf.signature_help, "Signature Help")
    map("<c-k>", vim.lsp.buf.signature_help, "Signature Help", "i")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
    map("<leader>cc", vim.lsp.codelens.run, "Run Codelens", { "n", "x" })
    map("<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens")
    map("<leader>cr", vim.lsp.buf.rename, "Rename")

    -- Inlay Hints
    if opts.inlay_hints.enabled and client and client.server_capabilities.inlayHintProvider then
      local ft = vim.bo[buffer].filetype
      if not vim.tbl_contains(opts.inlay_hints.exclude, ft) then
        vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
      end
    end

    -- Folds
    if opts.folds.enabled and client and client.server_capabilities.foldingRangeProvider then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    -- CodeLens Refresh
    if opts.codelens.enabled and client and client.server_capabilities.codeLensProvider then
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = buffer,
        callback = vim.lsp.codelens.refresh,
      })
    end
  end,
})

-- 5. Initialize Mason and Mason-LspConfig
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.workspace.fileOperations = {
  didRename = true,
  willRename = true,
}

-- Include Blink's completion capabilities.
local ok, blink = pcall(require, "blink.cmp")
if ok then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

vim.lsp.config("*", {
  capabilities = capabilities,
})

-- Preserve the language servers listed in your Mason configuration.
opts.servers.basedpyright = opts.servers.basedpyright or {}
opts.servers.texlab = opts.servers.texlab or {}
opts.servers.ltex_plus = opts.servers.ltex_plus or {}

local install = {}
local enable = {}

for name, settings in pairs(opts.servers) do
  if settings ~= false then
    local config = type(settings) == "table"
      and vim.deepcopy(settings) or {}

    local enabled = config.enabled ~= false
    local use_mason = config.mason ~= false

    -- These are configuration controls, not LSP settings.
    config.enabled = nil
    config.mason = nil

    if enabled then
      vim.lsp.config(name, config)

      if use_mason then
        table.insert(install, name)
        table.insert(enable, name)
      else
        vim.lsp.enable(name)
      end
    end
  end
end

require("mason-lspconfig").setup({
  ensure_installed = install,
  automatic_enable = enable,
})
