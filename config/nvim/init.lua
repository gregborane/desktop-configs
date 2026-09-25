-- load python env accordingly
local conda_env = os.getenv("CONDA_DEFAULT_ENV")

if not conda_env then
  local python = "/usr/bin/python"
  vim.g.python3_host_prog = python
elseif conda_env ~= "base" then
  local python = "/home/greg/anaconda3/envs/" .. conda_env .. "/bin/python"
  vim.g.python3_host_prog = python
elseif conda_env then
  local python = "/home/greg/anaconda3/bin/python"
  vim.g.python3_host_prog = python
end

-- load files
require("config.keybinds")
require("config.load")
require("config.options")

vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("UserPackBuild", {
    clear = true,
  }),
  callback = function(event)
    local data = event.data

    if data.spec.name ~= "telescope-fzf-native.nvim"
      or (data.kind ~= "install" and data.kind ~= "update")
    then
      return
    end

    local result = vim.system(
      { "make" },
      { cwd = data.path, text = true }
    ):wait()

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
