-- 1. Load the plugin
vim.pack.add({
    "https://github.com/folke/snacks.nvim",
})

-- 2. Define the configuration options
local opts = {
  bigfile = { enabled = true },
  explorer = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  picker = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  image = { enabled = true },
  dashboard = {
    preset = {
      -- Replaced LazyVim's custom picker wrapper with native Snacks picker
      pick = function(cmd, picker_opts)
        return Snacks.picker[cmd](picker_opts)
      end,
      header = [[
██   ██╗██╗██╗
╚██ ██╔╝██║██║
 ╚███═╝ ██║██║
 ██╔██╗ ██║██║
██╔╝ ██╗██║██║
╚═╝  ╚═╝╚═╝╚═╝]],
      ---@type snacks.dashboard.Item[]
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
        {
          icon = " ",
          key = "c",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
        },
        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
        -- The Lazy button is commented out since you are using a manual package manager
        -- { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        { icon = " ", key = "h", desc = "Health", action = ":checkhealth" },
      },
    },
  },
}

-- 3. Execute the setup
require("snacks").setup(opts)
