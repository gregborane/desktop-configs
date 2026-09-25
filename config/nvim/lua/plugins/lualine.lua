-- 1. Initial setup (formerly in `init`)
vim.g.lualine_laststatus = vim.o.laststatus
if vim.fn.argc(-1) > 0 then
  -- set an empty statusline till lualine loads
  vim.o.statusline = " "
else
  -- hide the statusline on the starter page
  vim.o.laststatus = 0
end

-- 2. Load the plugin and its standard web-devicons dependency
vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
})
-- 3. Define Fallbacks and Options (formerly `opts`)

-- Fallback for icons if LazyVim is not present
local icons = _G.LazyVim and LazyVim.config.icons
  or {
    diagnostics = { Error = " ", Warn = " ", Info = " ", Hint = " " },
    git = { added = " ", modified = " ", removed = " " },
  }

-- Helper function to safely fetch colors if Snacks is not present
local function get_color(hl_group)
  if _G.Snacks then
    return { fg = Snacks.util.color(hl_group) }
  end
  return nil
end

vim.o.laststatus = vim.g.lualine_laststatus

local opts = {
  options = {
    theme = "auto",
    globalstatus = vim.o.laststatus == 3,
    disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },

    lualine_c = {
      -- Use LazyVim root dir if available, else standard filename
      _G.LazyVim and LazyVim.lualine.root_dir() or "",
      {
        "diagnostics",
        symbols = {
          error = icons.diagnostics.Error,
          warn = icons.diagnostics.Warn,
          info = icons.diagnostics.Info,
          hint = icons.diagnostics.Hint,
        },
      },
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      -- Use LazyVim pretty path if available, else standard relative path
      _G.LazyVim and { LazyVim.lualine.pretty_path() } or { "filename", path = 1 },
    },
    lualine_x = {
      -- stylua: ignore
      {
        function() return require("noice").api.status.command.get() end,
        cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
        color = get_color("Statement"),
      },
      -- stylua: ignore
      {
        function() return require("noice").api.status.mode.get() end,
        cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
        color = get_color("Constant"),
      },
      -- stylua: ignore
      {
        function() return "  " .. require("dap").status() end,
        cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
        color = get_color("Debug"),
      },
      -- lazy.nvim updates (Checks if lazy is still installed since you are migrating away)
      {
        function()
          return package.loaded["lazy"] and require("lazy.status").updates() or ""
        end,
        cond = function()
          return package.loaded["lazy"] and require("lazy.status").has_updates()
        end,
        color = get_color("Special"),
      },
      {
        "diff",
        symbols = {
          added = icons.git.added,
          modified = icons.git.modified,
          removed = icons.git.removed,
        },
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed,
            }
          end
        end,
      },
    },
    lualine_y = {
      { "progress", separator = " ", padding = { left = 1, right = 0 } },
      { "location", padding = { left = 0, right = 1 } },
    },
    lualine_z = {
      function()
        return " " .. os.date("%R")
      end,
    },
  },
  extensions = { "neo-tree", "lazy", "fzf" },
}

-- Insert Snacks profiler if available
if _G.Snacks and Snacks.profiler then
  table.insert(opts.sections.lualine_x, 1, Snacks.profiler.status())
end

-- Do not add trouble symbols if aerial is enabled
-- And allow it to be overriden for some buffer types (see autocmds)
local has_trouble = _G.LazyVim and LazyVim.has("trouble.nvim") or pcall(require, "trouble")
if vim.g.trouble_lualine and has_trouble then
  local trouble = require("trouble")
  local symbols = trouble.statusline({
    mode = "symbols",
    groups = {},
    title = false,
    filter = { range = true },
    format = "{kind_icon}{symbol.name:Normal}",
    hl_group = "lualine_c_normal",
  })
  table.insert(opts.sections.lualine_c, {
    symbols and symbols.get,
    cond = function()
      return vim.b.trouble_lualine ~= false and symbols.has()
    end,
  })
end

-- 4. Execute the setup
-- (Note: To simulate `event = "VeryLazy"`, you could wrap this in a
-- `vim.api.nvim_create_autocmd("VimEnter", {...})`, but Lualine is generally
-- safe to initialize synchronously).
require("lualine").setup(opts)
