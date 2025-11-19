-- theming
-- color
-- iron config
local iron = require("iron.core")
local view = require("iron.view")
local common = require("iron.fts.common")

iron.setup({
	config = {
		-- Whether a repl should be discarded or not
		scratch_repl = true,
		-- Your repl definitions come here
		repl_definition = {
			sh = {
				-- Can be a table or a function that
				-- returns a table (see below)
				command = { "zsh" },
			},
			python = {
				command = { "python3" }, -- or { "ipython", "--no-autoindent" }
				format = common.bracketed_paste_python,
				block_dividers = { "# %%", "#%%" },
				env = { PYTHON_BASIC_REPL = "1" }, --this is needed for python3.13 and up.
			},
		},
		-- set the file type of the newly created repl to ft
		-- bufnr is the buffer id of the REPL and ft is the filetype of the
		-- language being used for the REPL.
		repl_filetype = function(bufnr, ft)
			return ft
			-- or return a string name such as the following
			-- return "iron"
		end,
		-- Send selections to the DAP repl if an nvim-dap session is running.
		dap_integration = true,
		-- How the repl window will be displayed
		-- See below for more information
		repl_open_cmd = "rightbelow vsplit",

		-- repl_open_cmd can also be an array-style table so that multiple
		-- repl_open_commands can be given.
		-- When repl_open_cmd is given as a table, the first command given will
		-- be the command that `IronRepl` initially toggles.
		-- Moreover, when repl_open_cmd is a table, each key will automatically
		-- be available as a keymap (see `keymaps` below) with the names
		-- toggle_repl_with_cmd_1, ..., toggle_repl_with_cmd_k
		-- For example,
		--
		-- repl_open_cmd = {
		--   view.split.vertical.rightbelow("%40"), -- cmd_1: open a repl to the right
		--   view.split.rightbelow("%25")  -- cmd_2: open a repl below
		-- }
	},
	-- Iron doesn't set keymaps by default anymore.
	-- You can set them here or manually add keymaps to the functions in iron.core
	keymaps = {
		toggle_repl = "<space>rr", -- toggles the repl open and closed.
		-- If repl_open_command is a table as above, then the following keymaps are
		-- available
		-- toggle_repl_with_cmd_1 = "<space>rv",
		-- toggle_repl_with_cmd_2 = "<space>rh",
		restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
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
	-- If the highlight is on, you can change how it looks
	-- For the available options, check nvim_set_hl
	highlight = {
		italic = true,
	},
	ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
})

-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")

-- bufferline config
vim.opt.termguicolors = true
require("bufferline").setup({})

-- hydra config
local Hydra = require("hydra")
Hydra({
	name = "Side scroll",
	mode = "n",
	body = "z",
	heads = {
		{ "h", "5zh" },
		{ "l", "5zl", { desc = "←/→" } },
		{ "H", "zH" },
		{ "L", "zL", { desc = "half screen ←/→" } },
	},
})

-- 3rd image
require("image").setup({
	backend = "ueberzug", -- or "kitty", "ueberzug" or "sixel"
	processor = "magick_cli", -- or "magick_rock"
	integrations = {
		markdown = {
			enabled = true,
			clear_in_insert_mode = false,
			download_remote_images = true,
			only_render_image_at_cursor = false,
			only_render_image_at_cursor_mode = "popup", -- or "inline"
			floating_windows = false, -- if true, images will be rendered in floating markdown windows
			filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
		},
		neorg = {
			enabled = true,
			filetypes = { "norg" },
		},
		typst = {
			enabled = true,
			filetypes = { "typst" },
		},
		html = {
			enabled = false,
		},
		css = {
			enabled = false,
		},
	},
	max_width = nil,
	max_height = nil,
	max_width_window_percentage = nil,
	max_height_window_percentage = 50,
	scale_factor = 1.0,
	window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
	window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
	editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
	tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
	hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
})

require("telescope").load_extension("remote-sshfs")
require("telescope").load_extension("lazygit")

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
			change_dir = false, -- prompt y/n to change working directory on connection (only applicable if handlers.on_connect.change_dir is enabled)
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

require("lsp_lines").setup()
vim.diagnostic.config({
    virtual_lines = true,
})
