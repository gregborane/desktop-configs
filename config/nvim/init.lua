-- Prefer the active virtualenv or Conda environment, then PATH.
local candidates = {}

for _, name in ipairs({ "VIRTUAL_ENV", "CONDA_PREFIX" }) do
  local prefix = vim.env[name]
  if prefix and prefix ~= "" then
    table.insert(candidates, prefix .. "/bin/python")
  end
end

vim.list_extend(candidates, { "python3", "python" })

local python
for _, candidate in ipairs(candidates) do
  if vim.fn.executable(candidate) == 1 then
    python = vim.fn.exepath(candidate)
    break
  end
end

if python then
  vim.g.python3_host_prog = python
else
  vim.notify(
    "No Python interpreter found. Start Neovim inside your Python environment.",
    vim.log.levels.WARN
  )
end-- load files
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
