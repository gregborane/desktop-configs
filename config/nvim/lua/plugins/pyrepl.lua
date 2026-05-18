return {
  {
    "dangooddd/pyrepl.nvim",
    config = function()
      local pyrepl = require("pyrepl")

      local vsplit = 0.3
      -- default config
      pyrepl.setup({
        split_horizontal = false,
        split_ratio = vsplit,
        style = "default",
        -- generate jupyter-console theme from neovim theme
        style_integration = true,
        image_max_history = 10,
        image_width_ratio = vsplit,
        image_height_ratio = 0.5,
        -- built-in provider, works best for ghostty and kitty
        -- for other terminals use "image" provider
        image_provider = "placeholders",
        -- can also be a function for advanced use cases
        cell_pattern = "^# %%%%.*$",
        python_path = "python",
        preferred_kernel = "jupyter-console",
        -- automatically prompt to convert notebook files into python scripts
        jupytext_hook = true,
      })

      -- repl ui-related commands
      vim.keymap.set("n", "<leader>jo", pyrepl.open_repl)
      vim.keymap.set("n", "<leader>jh", pyrepl.hide_repl)
      vim.keymap.set("n", "<leader>jc", pyrepl.close_repl)
      vim.keymap.set("n", "<leader>jt", pyrepl.toggle_repl)
      vim.keymap.set("n", "<leader>i", pyrepl.open_image_history)
      vim.keymap.set({ "n", "t" }, "<C-j>", pyrepl.toggle_repl_focus)

      -- send commands
      vim.keymap.set("n", "<leader>jb", pyrepl.send_buffer)
      vim.keymap.set("n", "<leader>js", pyrepl.send_cell)
      vim.keymap.set("v", "<leader>jv", pyrepl.send_visual)

      -- QoL commands
      vim.keymap.set("n", "<leader>jp", pyrepl.step_cell_backward)
      vim.keymap.set("n", "<leader>jn", pyrepl.step_cell_forward)
      vim.keymap.set("n", "<leader>je", pyrepl.export_to_notebook)
      vim.keymap.set("n", "<leader>js", ":PyreplInstall")
    end,
  },
}
