-- Select python bin for vim
vim.g.python3_host_prog = vim.env.CONDA_PREFIX .. "/bin/python"

-- load files
require("config.keybinds")
require("config.load")
require("config.options")

if vim.fn.exists("+packlockfile") == 1 then
  vim.o.packlockfile = vim.fs.joinpath(vim.fn.stdpath("state"), "nvim-pack-lock.json")
end

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("UserPackBuild", {
    clear = true,
  }),
  callback = function(event)
    local data = event.data

    if data.spec.name ~= "telescope-fzf-native.nvim" or (data.kind ~= "install" and data.kind ~= "update") then
      return
    end

    local result = vim.system({ "make" }, { cwd = data.path, text = true }):wait()

    if result.code ~= 0 then
      error("fzf-native build failed:\n" .. (result.stderr or ""))
    end
  end,
})

-- Add this to the bottom of init.lua
local plugin_dir = vim.fn.stdpath("config") .. "/lua/plugins"
for _, file in ipairs(vim.fn.readdir(plugin_dir)) do
  if file:match("%.lua$") and file ~= "example.lua" then
    require("plugins." .. file:gsub("%.lua$", ""))
  end
end
