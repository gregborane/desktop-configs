vim.pack.add({
  "https://github.com/lervag/vimtex",
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/micangl/cmp-vimtex",
})

local cmp = require("cmp")

cmp.setup({
  sources = {
    { name = "vimtex" },
    { name = "buffer" },
    { name = "path" },
  },
})
