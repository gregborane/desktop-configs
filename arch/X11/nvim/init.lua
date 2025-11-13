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
require("keymaps")
require("options")
require("plugins.lazy")
require("plugins.keymaps")
require("plugins.options")
require("themes.tool")
