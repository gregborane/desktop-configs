-- 1. Load the plugin
-- (Note: The official GitHub repository is williamboman/mason.nvim)
vim.pack.add({
  "https://github.com/mason-org/mason.nvim",
})

-- 2. Define keymap
vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })

-- 3. Define options
local opts = {
  -- mason.nvim itself doesn't use `ensure_installed` natively in its setup options,
  -- but we define it here so we can loop through it below (just like Lazy did).
  ensure_installed = {
    "basedpyright",
    "stylua",
    "shfmt",
    "lua-language-server",
    "tex-fmt",
    "ltex-ls-plus",
    "texlab",
  },
}

-- 4. Setup Mason
require("mason").setup()

-- 5. Registry and Auto-Install Logic
local mr = require("mason-registry")

-- Trigger FileType event to load the newly installed LSP server
mr:on("package:install:success", function()
  vim.defer_fn(function()
    -- Replaced lazy.nvim's event trigger with native Neovim API
    local buf = vim.api.nvim_get_current_buf()
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_exec_autocmds("FileType", {
        buffer = buf,
        modeline = false,
      })
    end
  end, 100)
end)

-- Auto-install missing tools defined in opts.ensure_installed
mr.refresh(function()
  for _, tool in ipairs(opts.ensure_installed) do
    local p = mr.get_package(tool)
    if not p:is_installed() then
      p:install()
    end
  end
end)
