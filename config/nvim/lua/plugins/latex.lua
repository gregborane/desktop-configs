-- 1. Define all Vimtex configurations
-- (These must be defined as globals since Vimtex does not use a setup() function)

-- Viewer settings
vim.g.vimtex_view_method = "zathura"
-- vim.g.vimtex_context_pdf_viewer = "okular" -- External PDF viewer for the Vimtex menu

-- Formatting settings
-- vim.g.vimtex_format_enabled = true              -- Enable formatting with latexindent
-- vim.g.vimtex_format_program = 'latexindent'

-- Indentation settings
vim.g.vimtex_indent_enabled = false -- Disable auto-indent from Vimtex
vim.g.tex_indent_items = false -- Disable indent for enumerate
vim.g.tex_indent_brace = false -- Disable brace indent

-- Compiler settings
vim.g.vimtex_compiler_method = "latexmk" -- Explicit compiler backend selection
vim.g.vimtex_compiler_latexmk = { -- latexmk configuration
  build_dir = "build", -- Build artifacts directory
  out_dir = "", -- Output directory for PDF and aux files
  aux_dir = "build", -- Auxiliary files directory
  options = {
    "-interaction=nonstopmode", -- Don't stop on errors
    "-file-line-error", -- Better error messages
    "-synctex=1", -- Enable SyncTeX
    "-outdir=build",
  },
}

vim.g.vimtex_quickfix_ignore_filters = { -- Filter out common noise
  "warning",
  "Underfull",
  "Overfull",
  "specifier changed to",
  "Token not allowed in a PDF string",
  "Package hyperref Warning",
}

vim.g.vimtex_log_ignore = { -- Suppress specific log messages
  "Underfull",
  "Overfull",
  "specifier changed to",
  "Token not allowed in a PDF string",
}

-- Other settings
vim.g.vimtex_mappings_enabled = true -- Enable default mappings (note: your comment originally said "Disable", but `true` enables them)
vim.g.tex_flavor = "latex" -- Set file type for TeX files

-- 2. Load the plugin
vim.pack.add({
  "https://github.com/lervag/vimtex",
})
