return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				python = { "ruff", "black" },
				lua = { "stylua" },
				bash = { "shfmt" },
			},
		})
		vim.keymap.set("n", "<leader>fm", function()
			local bufnr = vim.api.nvim_get_current_buf()
			require("conform").format({ bufnr = bufnr })
		end, { desc = "Format buffer with Conform" })
	end,
}
