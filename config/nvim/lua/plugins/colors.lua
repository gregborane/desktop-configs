vim.pack.add({
  { src = "https://github.com/gregborane/matteblack.nvim" },
})

vim.pack.add({
  {
    src = "https://github.com/catppuccin/nvim",
    name = "catppuccin",
  },
})

require("catppuccin").setup({
  flavour = "mocha",
  no_italic = true,
  auto_integrations = true,
})

vim.opt.termguicolors = true
vim.cmd.colorscheme("catppuccin-mocha")
