-- 1. Load the plugin and its dependencies
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nosduco/remote-sshfs.nvim",
})

-- 2. Execute the setup
require("remote-sshfs").setup({
  connections = {
    ssh_configs = { -- which ssh configs to parse for hosts list
      vim.fn.expand("$HOME") .. "/.ssh/config",
      "/etc/ssh/ssh_config",
      -- "/path/to/custom/ssh_config"
    },
    ssh_known_hosts = vim.fn.expand("$HOME") .. "/.ssh/known_hosts",
    -- NOTE: Can define ssh_configs similarly to include all configs in a folder
    -- ssh_configs = vim.split(vim.fn.globpath(vim.fn.expand "$HOME" .. "/.ssh/configs", "*"), "\n")
    sshfs_args = { -- arguments to pass to the sshfs command
      "-o reconnect",
      "-o ConnectTimeout=5",
    },
  },
  mounts = {
    base_dir = vim.fn.expand("$HOME") .. "/.sshfs/", -- base directory for mount points
    unmount_on_exit = true, -- run sshfs as foreground, will unmount on vim exit
  },
  handlers = {
    on_connect = {
      change_dir = true, -- when connected change vim working directory to mount point
    },
    on_disconnect = {
      clean_mount_folders = false, -- remove mount point folder on disconnect/unmount
    },
    on_edit = {}, -- not yet implemented
  },
  ui = {
    select_prompts = false, -- not yet implemented
    confirm = {
      connect = true, -- prompt y/n when host is selected to connect to
      change_dir = false, -- prompt y/n to change working directory on connection
    },
  },
  log = {
    enabled = false, -- enable logging
    truncate = false, -- truncate logs
    types = { -- enabled log types
      all = false,
      util = false,
      handler = false,
      sshfs = false,
    },
  },
})

-- 3. Load the Telescope extension (safely)
-- This allows you to use `:Telescope remote-sshfs connect`
pcall(function()
  require("telescope").load_extension("remote-sshfs")
end)
