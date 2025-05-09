local opts = {
  styles = {
    type = { bold = true },
    lsp = { underline = false },
    match_paren = { underline = true },
  },
}

local function config()
  local plugin = require 'no-clown-fiesta'
  plugin.setup(opts)
  return plugin.load()
end

return {
  'aktersnurra/no-clown-fiesta.nvim',
  priority = 1000,
  config = config,
  lazy = false,
}
