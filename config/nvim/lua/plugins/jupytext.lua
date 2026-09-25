-- 1. Load the plugin
vim.pack.add({
  { src = "https://github.com/GCBallesteros/jupytext.nvim" },
})

-- 2. Execute the setup (this is the equivalent of `config = true`)
require("jupytext").setup()
