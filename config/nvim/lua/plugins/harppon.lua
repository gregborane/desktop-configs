-- 1. Load the plugin and its dependency
-- NOTE: Since manual setups don't always manage git branches automatically,
-- ensure you have actually checked out the `harpoon2` branch in your plugins folder!
vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  {
    src = "https://github.com/ThePrimeagen/harpoon",
    version = "harpoon2",
  },
})

-- 2. Define the helper function for Telescope
-- We put the telescope requires inside the function so it doesn't
-- accidentally crash Neovim if Harpoon loads before Telescope.
local function toggle_telescope(harpoon_files)
  local conf = require("telescope.config").values
  local themes = require("telescope.themes")

  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  local opts = themes.get_ivy({
    prompt_title = "Working List", -- Fixed typo from original (promt_title -> prompt_title)
  })

  require("telescope.pickers")
    .new(opts, {
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      previewer = conf.file_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

-- 3. Initialize Harpoon (Harpoon 2 requires setup to be called)
local harpoon = require("harpoon")
harpoon:setup()

-- 4. Set the Keymaps
local map = vim.keymap.set

map("n", "<leader>a", function()
  harpoon:list():add()
end, { desc = "Harpoon Add" })
map("n", "<C-e>", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Menu" })
map("n", "<leader>fl", function()
  toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })
map("n", "<C-p>", function()
  harpoon:list():prev()
end, { desc = "Harpoon Prev" })
map("n", "<C-n>", function()
  harpoon:list():next()
end, { desc = "Harpoon Next" })
