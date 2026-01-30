return {
  -- mason
{

  "mason-org/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  opts_extend = { "ensure_installed" },
  opts = {
    ensure_installed = {
      "stylua",
    },
  },
  ---@param opts MasonSettings | {ensure_installed: string[]}
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        -- trigger FileType event to possibly load this newly installed LSP server
        require("lazy.core.handler.event").trigger({
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        })
      end, 100)
    end)

    mr.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end)
  end,
},

-- autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = { { name = "nvim_lsp" } },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(), -- manual popup
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
        }),
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- or vim.snippet.expand if using your own
          end,
        },
        completion = {
          autocomplete = false, -- disables aggressive auto popup
        },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = function()
      local icons = {
        Error = "",
        Warn  = "",
        Hint  = "",
        Info  = "",
      }

      local ret = {
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = icons.Error,
              [vim.diagnostic.severity.WARN]  = icons.Warn,
              [vim.diagnostic.severity.HINT]  = icons.Hint,
              [vim.diagnostic.severity.INFO]  = icons.Info,
            },
          },
        },
        inlay_hints = { enabled = true, exclude = { "vue" } },
        codelens = { enabled = false },
        folds = { enabled = true },
        format = { formatting_options = nil, timeout_ms = nil },
        servers = {
          ["*"] = {
            capabilities = {
              workspace = { fileOperations = { didRename = true, willRename = true } },
            },
            keys = {
              { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
              { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
              { "gi", vim.lsp.buf.implementation, desc = "Goto Implementation" },
              { "gr", vim.lsp.buf.references, desc = "References" },
              { "K", vim.lsp.buf.hover, desc = "Hover" },
              { "gs", vim.lsp.buf.signature_help, desc = "Signature Help" },
              { "<F2>", vim.lsp.buf.rename, desc = "Rename" },
              { "<F3>", function() vim.lsp.buf.format({ async = true }) end, desc = "Format" },
              { "<F4>", vim.lsp.buf.code_action, desc = "Code Action" },
            },
          },
          lua_ls = {
            settings = {
              Lua = {
                workspace = { checkThirdParty = false },
                codeLens = { enable = true },
                completion = { callSnippet = "Replace" },
                doc = { privateName = { "^_" } },
                hint = { enable = true, setType = false, paramType = true, paramName = "Disable", semicolon = "Disable", arrayIndex = "Disable" },
              },
            },
          },
          stylua = { enabled = false },
        },
      }

      return ret
    end,
    config = function(_, opts)
      -- diagnostics
      vim.diagnostic.config(opts.diagnostics)

      -- setup LSP servers via mason-lspconfig
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")

      mason_lspconfig.setup({ automatic_installation = true })

      for server, server_opts in pairs(opts.servers) do
        if server_opts ~= false then
          local lsp_opts = server_opts.settings and { settings = server_opts.settings } or {}
          if server_opts.capabilities then
            lsp_opts.capabilities = server_opts.capabilities
          else
            lsp_opts.capabilities = vim.lsp.protocol.make_client_capabilities()
          end
          lspconfig[server].setup(lsp_opts)
        end
      end

      -- setup keymaps when LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          local keymaps = opts.servers["*"].keys
          for _, map in ipairs(keymaps) do
            vim.keymap.set(map.mode or "n", map[1], map[2], { buffer = buf, desc = map.desc })
          end
        end,
      })

      -- inlay hints
      if opts.inlay_hints.enabled and vim.lsp.inlay_hint then
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local buf = args.buf
            if not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buf].filetype) then
              vim.lsp.inlay_hint(buf, true)
            end
          end,
        })
      end

      -- folds
      if opts.folds.enabled then
        vim.o.foldmethod = "expr"
        vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
      end

      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
          callback = vim.lsp.codelens.refresh,
        })
      end
    end,
  },
}

