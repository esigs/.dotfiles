return {
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
      {
        "<leader>ps",
        function()
          require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
        end,
        desc = "Search String",
      },
    },
  },
}
