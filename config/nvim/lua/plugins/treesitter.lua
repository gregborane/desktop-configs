-- 1. Load the plugin
vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
  },
})

-- 2. Define the configuration options
local parsers = {
    "bash",
    "c",
    "css",
    "diff",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "latex",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "norg",
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

-- 3. Execute setup
-- Note: The `main` branch uses `require("nvim-treesitter").setup`,
-- while stable releases still use `require("nvim-treesitter.configs").setup`.
-- This pcall ensures it works safely regardless of which version you end up pulling.
local status_ok, ts = pcall(require, "nvim-treesitter")
if status_ok and ts.setup then
  ts.setup(opts)
else
  -- Fallback for standard/stable nvim-treesitter API
  require("nvim-treesitter.configs").setup(opts)
end

-- 4. Enable Native Treesitter Folding (Neovim 0.10+)
-- LazyVim used a complex FileType autocommand for this, but in modern Neovim
-- you can safely enable it globally. It will gracefully fall back to standard
-- folding if a treesitter parser isn't available for the current file.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = "" -- Optional: Modern clean foldtext in Neovim 0.10+
