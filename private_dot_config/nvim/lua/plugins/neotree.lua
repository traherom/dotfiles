return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>fs",
        "<cmd>Neotree reveal_force_cwd dir=%:p:h<CR>",
        desc = "Reveal current file in Neotree",
      },
      { "<leader>e", "<cmd>Neotree reveal_force_cwd dir=%:p:h<CR>", desc = "Reveal current file in Neotree" },
    },
    opts = {
      hijack_netrw_behavior = "open_current",
      window = {
        position = "current",
      },
      filesystem = {
        bind_to_cwd = false, -- true creates a 2-way binding between vim's cwd and neo-tree's root
        cwd_target = {
          sidebar = "global", -- sidebar is when position = left or right
          current = "global", -- current is when position = current
        },
        --   follow_current_file = {
        --     enabled = false,
        --   },
        filtered_items = {
          hide_hidden = false,
          hide_dotfiles = false,
          hide_by_name = {
            "node_modules",
          },
        },
      },
    },
  },
}
