-- Sepia Automaton-inspired Neovim theme for LazyVim (blur-adapted, transparent backgrounds)
-- Save as: lua/themes/sepia_automaton.lua

local M = {}

local colors = {
	bg = "#181818", -- transparent for compositor blur
	fg = "#cbb9a0",
	black = "#181818",
	red = "#F43841",
	green = "#4a8625",
	yellow = "#FFDD33",
	blue = "#96A6C8",
	magenta = "#9E95C7",
	cyan = "#95A99F",
	white = "#E4E4E4",
	sepia = "#b99c80",
	br_black = "#52494E",
	br_red = "#FF4F58",
	br_green = "#73D936",
	br_yellow = "#FFDD33",
	br_blue = "#96A6C8",
	br_magenta = "#AFAFD7",
	br_cyan = "#95A99F",
	br_white = "#F5F5F5",
	br_sepia = "#f3e0bb"
}

function M.colors()
	return colors
end

function M.setup()
	vim.cmd("highlight clear")
	vim.o.background = "dark"
	vim.g.colors_name = "sepia_automaton"

	local set = function(group, opts)
		vim.api.nvim_set_hl(0, group, opts)
	end

	-- Transparent base UI
	local transparent_groups = {
		"Normal",
		"NormalNC",
		"NormalFloat",
		"SignColumn",
		"LineNr",
		"VertSplit",
		"StatusLine",
		"StatusLineNC",
	}

	for _, group in ipairs(transparent_groups) do
		set(group, { bg = "none", fg = colors.fg })
	end

	-- UI Elements
	set("CursorLine", { bg = colors.black })
	set("CursorLineNr", { fg = colors.br_yellow })
	set("Visual", { bg = colors.br_black })
	set("Pmenu", { fg = colors.fg, bg = colors.black })
	set("PmenuSel", { fg = colors.bg, bg = colors.yellow })
	set("Search", { fg = colors.black, bg = colors.yellow })
	set("IncSearch", { fg = colors.black, bg = colors.red })
	set("FloatBorder", { fg = colors.br_black, bg = "none" })
	set("WinSeparator", { fg = colors.br_black, bg = "none" })

	-- Syntax
	set("Comment", { fg = colors.green, italic = true })
	set("Constant", { fg = colors.yellow })
	set("String", { fg = colors.sepia })
	set("Number", { fg = colors.white })
	set("Boolean", { fg = colors.red })
	set("Identifier", { fg = colors.cyan })
	set("Function", { fg = colors.br_red })
	set("Statement", { fg = colors.accent or colors.br_magenta })
	set("Conditional", { fg = colors.magenta })
	set("Repeat", { fg = colors.magenta })
	set("Operator", { fg = colors.fg })
	set("Keyword", { fg = colors.br_magenta })
	set("Type", { fg = colors.red })
	set("Special", { fg = colors.br_sepia })
	set("Underlined", { fg = colors.cyan, underline = true })
	set("Error", { fg = colors.bg, bg = colors.red })
	set("Todo", { fg = colors.black, bg = colors.yellow })

	-- Statusline / Tabline / Winbar
	set("StatusLineTerm", { fg = colors.fg, bg = "none" })
	set("StatusLineTermNC", { fg = colors.br_black, bg = "none" })
	set("WinBar", { fg = colors.br_yellow, bg = "none" })
	set("WinBarNC", { fg = colors.br_black, bg = "none" })
	set("TabLine", { fg = colors.white, bg = colors.black })
	set("TabLineSel", { fg = colors.black, bg = colors.yellow })
	set("TabLineFill", { fg = colors.br_black, bg = "none" })

	-- Lualine sections
	set("lualine_a_normal", { fg = colors.black, bg = colors.yellow })
	set("lualine_b_normal", { fg = colors.fg, bg = colors.br_black })
	set("lualine_c_normal", { fg = colors.br_yellow, bg = "none" })
	set("lualine_a_insert", { fg = colors.black, bg = colors.br_green })
	set("lualine_a_visual", { fg = colors.black, bg = colors.br_magenta })
	set("lualine_a_command", { fg = colors.black, bg = colors.br_blue })
	set("lualine_a_replace", { fg = colors.black, bg = colors.br_red })
end

return M
