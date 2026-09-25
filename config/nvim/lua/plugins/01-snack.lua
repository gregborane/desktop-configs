-- Snacks: loaded early so its picker is available to other plugins.
vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
    version = "master",
  },
  {
    src = "https://github.com/folke/snacks.nvim",
  },
})

---@type snacks.Config
require("snacks").setup({
  bigfile = {
    enabled = true,
  },

  explorer = {
    enabled = true,
  },

  indent = {
    enabled = true,
  },

  input = {
    enabled = true,
  },

  notifier = {
    enabled = true,
  },

  quickfile = {
    enabled = true,
  },

  scope = {
    enabled = true,
  },

  scroll = {
    enabled = true,
  },

  statuscolumn = {
    enabled = true,
  },

  words = {
    enabled = true,
  },

  image = {
    enabled = true,
  },

  zen = {
    enabled = true,
  },

  picker = {
    enabled = true,

    sources = {
      projects = {
        projects = {
          "~/nixos-dotfiles/desktop-configs/config/nvim",
          "~/Work",
        },

        recent = true,
      },
    },
  },

  dashboard = {
    enabled = true,

    preset = {
      header = [[
██   ██╗██╗██╗
╚██ ██╔╝██║██║
 ╚███═╝ ██║██║
 ██╔██╗ ██║██║
██╔╝ ██╗██║██║
╚═╝  ╚═╝╚═╝╚═╝]],

      -- stylua: ignore
      ---@type snacks.dashboard.Item[]
      keys = {
        {
          icon = " ",
          key = "f",
          desc = "Find File",
          action = ":lua Snacks.dashboard.pick('files')",
        },
        {
          icon = " ",
          key = "n",
          desc = "New File",
          action = ":ene | startinsert",
        },
        {
          icon = " ",
          key = "g",
          desc = "Find Text",
          action = ":lua Snacks.dashboard.pick('live_grep')",
        },
        {
          icon = " ",
          key = "r",
          desc = "Recent Files",
          action = ":lua Snacks.dashboard.pick('oldfiles')",
        },
        {
          icon = " ",
          key = "c",
          desc = "Config",
          action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })",
        },
        {
          icon = " ",
          key = "p",
          desc = "Projects",
          action = ":lua Snacks.picker.projects()",
        },
        {
          icon = " ",
          key = "h",
          desc = "Health",
          action = ":checkhealth",
        },
        {
          icon = " ",
          key = "q",
          desc = "Quit",
          action = ":qa",
        },
      },
    },

    -- Explicitly replace the defaults.
    -- Do NOT add { section = "startup" } here.
    -- That section calls lazy.stats and requires lazy.nvim.
    sections = {
      {
        section = "header",
      },
      {
        section = "keys",
        gap = 1,
        padding = 1,
      },
    },
  },
})

local map = vim.keymap.set

-- Search help
map("n", "<leader>sh", function()
  Snacks.picker.help()
end, {
  desc = "[S]earch [H]elp",
})

-- Search keymaps
map("n", "<leader>sk", function()
  Snacks.picker.keymaps()
end, {
  desc = "[S]earch [K]eymaps",
})

-- Search commands
map("n", "<leader>sc", function()
  Snacks.picker.commands()
end, {
  desc = "[S]earch [C]ommands",
})

-- Search Snacks builtins
map("n", "<leader>sb", function()
  Snacks.picker.builtin()
end, {
  desc = "[S]earch [B]uiltins",
})

-- Find files
map("n", "<leader>sf", function()
  Snacks.picker.files()
end, {
  desc = "[S]earch [F]iles",
})

-- File explorer
map("n", "<leader>fe", function()
  Snacks.explorer.open()
end, {
  desc = "[F]iles [E]xplorer",
})

-- Smart file picker
map("n", "<leader>ff", function()
  Snacks.picker.smart()
end, {
  desc = "[F]ind [F]iles",
})

-- Select Snacks picker
map("n", "<leader>ss", function()
  Snacks.picker.pickers()
end, {
  desc = "[S]earch [S]elect Snacks",
})

-- Search current word / visual selection
map({ "n", "x" }, "<leader>sw", function()
  Snacks.picker.grep_word()
end, {
  desc = "[S]earch current [W]ord",
})

-- Grep files
map("n", "<leader>fg", function()
  Snacks.picker.grep()
end, {
  desc = "[F]ind by [G]rep",
})

-- Projects
map("n", "<leader>fp", function()
  Snacks.picker.projects()
end, {
  desc = "[F]ind [P]rojects",
})

-- Diagnostics
map("n", "<leader>sd", function()
  Snacks.picker.diagnostics()
end, {
  desc = "[S]earch [D]iagnostics",
})

-- Resume last picker
map("n", "<leader>sr", function()
  Snacks.picker.resume()
end, {
  desc = "[S]earch [R]esume",
})

-- Recent files
map("n", "<leader>s.", function()
  Snacks.picker.recent()
end, {
  desc = "[S]earch Recent Files",
})

-- Existing buffers
map("n", "<leader><leader>", function()
  Snacks.picker.buffers()
end, {
  desc = "Find existing buffers",
})

-- Search current buffer
map("n", "<leader>/", function()
  Snacks.picker.lines()
end, {
  desc = "Fuzzily search current buffer",
})

-- Search open buffers
map("n", "<leader>s/", function()
  Snacks.picker.grep_buffers()
end, {
  desc = "[S]earch in Open Files",
})

-- Search Neovim config
map("n", "<leader>sn", function()
  Snacks.picker.files({
    cwd = vim.fn.stdpath("config"),
  })
end, {
  desc = "[S]earch [N]eovim files",
})

-- Zen mode
map("n", "<C-\\>", function()
  Snacks.zen()
end, {
  desc = "Toggle Zen mode",
})
