-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.swapfile = false
vim.opt.list = false
vim.opt.conceallevel = 0
vim.opt.scrolloff = 10
vim.opt.title = true

--vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = "wl-copy",
  copy = {
    ["+"] = "wl-copy",
    ["*"] = "wl-copy",
  },
  paste = {
    ["+"] = function()
      return vim.fn.systemlist("wl-paste | sed -e 's/\r$//'", { "" }, 1) -- '1' keeps empty lines
    end,
    ["*"] = function()
      return vim.fn.systemlist("wl-paste |sed -e 's/\r$//'", { "" }, 1)
    end,
  },
  cache_enabled = true,
}
