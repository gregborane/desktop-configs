-- Speed up startup by disabling unused built-in Vim plugins
local disabled_built_ins = {
  "gzip",
  "tarPlugin",
  "tohtml",
  "tutor",
  "zipPlugin",
}

for _, plugin in ipairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
