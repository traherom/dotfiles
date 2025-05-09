return {
  'sainnhe/everforest',
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.everforest_enable_italic = true
    vim.g.everforest_background = 'hard'
    vim.g.everforest_ui_contrast = 'high' -- low
    --vim.g.everforest_diagnostic_virtual_text = 'grey'
    vim.cmd.colorscheme 'everforest'
  end,
}
