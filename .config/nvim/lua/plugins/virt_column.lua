return {
	{
		"lukas-reineke/virt-column.nvim",
		config = function()
			require("virt-column").setup({ virtcolumn = "+1,120" })
		end,
	},
}
