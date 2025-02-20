-- stylua: ignore
if true then return {} end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
        "go",
        "gomod",
        "gowork",
        "gosum",
      })

      opts.incremental_selection = {
        enable = true,
        keymaps = {
          node_incremental = "v",
          node_decremental = "V",
        },
      }
    end,
  },
}
