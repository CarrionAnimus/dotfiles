return {
  {
		"nvim-neo-tree/neo-tree.nvim",
		tag = "3.27",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			--"3rd/image.nvim",
		},
		config = function()
			vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle<CR>", { desc = "NeoTree" })
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			load = {
				["lualine"] = {},
			},
			options = {
				theme = "nord",
			},
		},
	},
}
