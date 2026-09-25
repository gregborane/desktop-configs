-- 1. Load the plugins
vim.pack.add({"https://github.com/nvim-lua/plenary.nvim",
              "https://github.com/nvim-telescope/telescope.nvim",
              "https://github.com/nvim-telescope/telescope-fzf-native.nvim"})

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- 2. Define custom helper actions
local open_with_trouble = function(...)
  local ok, trouble = pcall(require, "trouble.sources.telescope")
  if ok then
    trouble.open(...)
  else
    -- Fallback to standard open if trouble is not installed
    actions.select_default(...)
  end
end

local find_files_no_ignore = function(prompt_bufnr)
  local line = action_state.get_current_line()
  actions.close(prompt_bufnr)
  builtin.find_files({ no_ignore = true, default_text = line })
end

local find_files_with_hidden = function(prompt_bufnr)
  local line = action_state.get_current_line()
  actions.close(prompt_bufnr)
  builtin.find_files({ hidden = true, default_text = line })
end

local function find_command()
  if 1 == vim.fn.executable("rg") then
    return { "rg", "--files", "--color", "never", "-g", "!.git" }
  elseif 1 == vim.fn.executable("fd") then
    return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
  elseif 1 == vim.fn.executable("fdfind") then
    return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
  elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
    return { "find", ".", "-type", "f" }
  elseif 1 == vim.fn.executable("where") then
    return { "where", "/r", ".", "*" }
  end
end

-- 3. Execute Setup
require("telescope").setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    -- open files in the first window that is an actual file.
    -- use the current window if no other window is available.
    get_selection_window = function()
      local wins = vim.api.nvim_list_wins()
      table.insert(wins, 1, vim.api.nvim_get_current_win())
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "" then
          return win
        end
      end
      return 0
    end,
    mappings = {
      i = {
        ["<c-t>"] = open_with_trouble,
        ["<a-t>"] = open_with_trouble,
        ["<a-i>"] = find_files_no_ignore,
        ["<a-h>"] = find_files_with_hidden,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<C-b>"] = actions.preview_scrolling_up,
      },
      n = {
        ["q"] = actions.close,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = find_command,
      hidden = true,
    },
  },
})

-- 4. Load Extensions safely
local ok, err = pcall(require("telescope").load_extension, "fzf")
if not ok then
  vim.notify(
    "Telescope: Failed to load fzf-native. Did you run `make` inside its directory?\n" .. err,
    vim.log.levels.WARN
  )
end

-- 5. Define Keymaps (Replaced LazyVim.pick with standard Telescope builtins)
local map = vim.keymap.set

-- Base
map("n", "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", { desc = "Switch Buffer" })
map("n", "<leader>/", builtin.live_grep, { desc = "Grep (Root Dir)" })
map("n", "<leader>:", builtin.command_history, { desc = "Command History" })
map("n", "<leader><space>", builtin.find_files, { desc = "Find Files (Root Dir)" })

-- Find
map(
  "n",
  "<leader>fb",
  "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
  { desc = "Buffers" }
)
map("n", "<leader>fB", builtin.buffers, { desc = "Buffers (all)" })
map("n", "<leader>fc", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
map("n", "<leader>ff", builtin.find_files, { desc = "Find Files (Root Dir)" })
map("n", "<leader>fF", function()
  builtin.find_files({ cwd = vim.uv.cwd() })
end, { desc = "Find Files (cwd)" })
map("n", "<leader>fg", builtin.git_files, { desc = "Find Files (git-files)" })
map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent" })
map("n", "<leader>fR", function()
  builtin.oldfiles({ cwd = vim.uv.cwd() })
end, { desc = "Recent (cwd)" })

-- Git
map("n", "<leader>gc", builtin.git_commits, { desc = "Commits" })
map("n", "<leader>gl", builtin.git_commits, { desc = "Commits" })
map("n", "<leader>gs", builtin.git_status, { desc = "Status" })
map("n", "<leader>gS", builtin.git_stash, { desc = "Git Stash" })

-- Search
map("n", '<leader>s"', builtin.registers, { desc = "Registers" })
map("n", "<leader>s/", builtin.search_history, { desc = "Search History" })
map("n", "<leader>sa", builtin.autocommands, { desc = "Auto Commands" })
map("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Buffer Lines" })
map("n", "<leader>sc", builtin.command_history, { desc = "Command History" })
map("n", "<leader>sC", builtin.commands, { desc = "Commands" })
map("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
map("n", "<leader>sD", function()
  builtin.diagnostics({ bufnr = 0 })
end, { desc = "Buffer Diagnostics" })
map("n", "<leader>sg", builtin.live_grep, { desc = "Grep (Root Dir)" })
map("n", "<leader>sG", function()
  builtin.live_grep({ cwd = vim.uv.cwd() })
end, { desc = "Grep (cwd)" })
map("n", "<leader>sh", builtin.help_tags, { desc = "Help Pages" })
map("n", "<leader>sH", builtin.highlights, { desc = "Search Highlight Groups" })
map("n", "<leader>sj", builtin.jumplist, { desc = "Jumplist" })
map("n", "<leader>sk", builtin.keymaps, { desc = "Key Maps" })
map("n", "<leader>sl", builtin.loclist, { desc = "Location List" })
map("n", "<leader>sM", builtin.man_pages, { desc = "Man Pages" })
map("n", "<leader>sm", builtin.marks, { desc = "Jump to Mark" })
map("n", "<leader>so", builtin.vim_options, { desc = "Options" })
map("n", "<leader>sR", builtin.resume, { desc = "Resume" })
map("n", "<leader>sq", builtin.quickfix, { desc = "Quickfix List" })

-- Grep String / Visual Selection
map("n", "<leader>sw", function()
  builtin.grep_string({ word_match = "-w" })
end, { desc = "Word (Root Dir)" })
map("n", "<leader>sW", function()
  builtin.grep_string({ cwd = vim.uv.cwd(), word_match = "-w" })
end, { desc = "Word (cwd)" })
map("x", "<leader>sw", builtin.grep_string, { desc = "Selection (Root Dir)" })
map("x", "<leader>sW", function()
  builtin.grep_string({ cwd = vim.uv.cwd() })
end, { desc = "Selection (cwd)" })

-- LSP & Misc
map("n", "<leader>uC", function()
  builtin.colorscheme({ enable_preview = true })
end, { desc = "Colorscheme with Preview" })
map("n", "<leader>ss", builtin.lsp_document_symbols, { desc = "Goto Symbol" })
map("n", "<leader>sS", builtin.lsp_dynamic_workspace_symbols, { desc = "Goto Symbol (Workspace)" })
