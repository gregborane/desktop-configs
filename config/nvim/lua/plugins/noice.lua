-- 1. Load the plugin and its strict UI dependency
vim.pack.add({
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/folke/noice.nvim",
})

-- 2. Define the Keymaps
local map = vim.keymap.set

map("c", "<S-Enter>", function()
  require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })
map("n", "<leader>snl", function()
  require("noice").cmd("last")
end, { desc = "Noice Last Message" })
map("n", "<leader>snh", function()
  require("noice").cmd("history")
end, { desc = "Noice History" })
map("n", "<leader>sna", function()
  require("noice").cmd("all")
end, { desc = "Noice All" })
map("n", "<leader>snd", function()
  require("noice").cmd("dismiss")
end, { desc = "Dismiss All" })
map("n", "<leader>snt", function()
  require("noice").cmd("pick")
end, { desc = "Noice Picker (Telescope/FzfLua)" })

map({ "i", "n", "s" }, "<c-f>", function()
  if not require("noice.lsp").scroll(4) then
    return "<c-f>"
  end
end, { silent = true, expr = true, desc = "Scroll Forward" })

map({ "i", "n", "s" }, "<c-b>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<c-b>"
  end
end, { silent = true, expr = true, desc = "Scroll Backward" })

-- 3. Execute the setup
-- We use a VimEnter autocommand with vim.schedule to mimic `event = "VeryLazy"`
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.schedule(function()
      -- Define the configuration options
      local opts = {
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        routes = {
          -- Skip LTeX / LTeX+ progress popups ("Checking document...")
          {
            filter = {
              event = "lsp",
              kind = "progress",
              cond = function(message)
                local client = message.opts and message.opts.progress and message.opts.progress.client
                return client == "ltex" or client == "ltex_plus" or client == "ltex-ls"
              end,
            },
            opts = { skip = true },
          },
          {
            filter = {
              event = "msg_show",
              any = {
                { find = "%d+L, %d+B" },
                { find = "; after #%d+" },
                { find = "; before #%d+" },
              },
            },
            view = "mini",
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
        },
      }

      require("noice").setup(opts)
    end)
  end,
})
