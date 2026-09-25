-- Load nvim-treesitter.
--
-- Do NOT pin to "master".
-- The master branch uses the old nvim-treesitter.configs API.
-- This configuration targets the current main branch and Neovim 0.12+.
vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
})

local ts = require("nvim-treesitter")

-- Parser installation directory.
-- Calling setup() is optional when using the default, but keeping it explicit
-- makes the configuration clear.
ts.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

local parsers = {
  "bash",
  "c",
  "css",
  "diff",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "latex",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "printf",
  "python",
  "query",
  "regex",
  "scss",
  "svelte",
  "toml",
  "tsx",
  "typescript",
  "typst",
  "vim",
  "vimdoc",
  "vue",
  "xml",
  "yaml",
}

-- Install missing parsers.
--
-- This is asynchronous and is a no-op for parsers that are already installed.
ts.install(parsers)

-- Enable Tree-sitter features whenever a parser exists for the current
-- filetype.
--
-- On the current nvim-treesitter main branch, highlighting and folding are
-- provided by Neovim itself. They are no longer configured with:
--
--   require("nvim-treesitter.configs").setup(...)
--
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter.setup", { clear = true }),

  callback = function(args)
    -- Start native Tree-sitter highlighting.
    local ok = pcall(vim.treesitter.start, args.buf)

    -- No installed parser for this buffer's language.
    if not ok then
      return
    end

    -- Native Tree-sitter folding.
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldtext = ""

    -- Tree-sitter indentation provided by nvim-treesitter.
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
