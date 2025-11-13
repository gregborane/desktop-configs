return {

  -- Jupytext for .ipynb and .py syncing
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false,
    config = true,
  },

  {
    "GCBallesteros/NotebookNavigator.nvim",
    dependencies = {
      "nvim-mini/mini.comment",
      "hkupty/iron.nvim",
      "akinsho/toggleterm.nvim",
      "benlubas/molten-nvim",
      "anuvyklack/hydra.nvim",
    },
    event = "VeryLazy",
    config = function()
      local nn = require("notebook-navigator")
      nn.setup({})
    end,
  },

  -- Iron.nvim setup
  {
    "Vigemus/iron.nvim",
    config = function()
      local iron = require("iron.core")
      local common = require("iron.fts.common")
      local view = require("iron.view")

      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = { command = { "zsh" } },
            python = {
              command = { "python3" },
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
              env = { PYTHON_BASIC_REPL = "1" },
            },
          },
          repl_filetype = function(_, ft)
            return ft
          end,
          dap_integration = true,
          -- vertical split with 80/20 ratio
          repl_open_cmd = view.split.vertical.rightbelow("35%"),
        },
        keymaps = {
          toggle_repl = "<space>rr",
          restart_repl = "<space>rR",
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_paragraph = "<space>sp",
          send_until_cursor = "<space>su",
          send_mark = "<space>sm",
          send_code_block = "<space>sb",
          send_code_block_and_move = "<space>sn",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      })

      vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
      vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
    end,
  },

  -- ghostty.nvim base config
  {
    "isak102/ghostty.nvim",
    config = function()
      require("ghostty").setup({
        ghostty_cmd = "ghostty",
        check_timeout = 1000,
      })
    end,
  },

  -- Molten and image rendering for outputs
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
    end,
  },
  {
    "3rd/image.nvim",
    config = function()
      require("image").setup({
        backend = "kitty",
        processor = "magick_cli",
        integrations = { markdown = { enabled = true } },
      })
    end,
  },

  -- Optional: toggleterm for alternative REPLs
  { "akinsho/toggleterm.nvim", version = "*", config = true },

  -- Optional: hydra for notebook keymaps
  { "anuvyklack/hydra.nvim" },

  {
    "nvim-mini/snacks.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
}
