-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Disable swap files
vim.opt.swapfile = false

-- Update terminal title with current file
vim.opt.title = true

-- Don't wrap text by default
vim.opt.wrap = false

-- Colorscheme, apply after the colorschemes are loaded
vim.schedule(function()
  --vim.cmd.colorscheme 'sonokai'
  --vim.cmd.colorscheme 'no-clown-fiesta'
  vim.cmd.colorscheme 'minicyan'
  -- Dark background by default
  vim.opt.background = 'dark'
end)

-- Sync clipboard between OS and Neovim and use OSC 52 terminal code for
-- copying and pasting. Forced in case it isn't detected for the terminal.
--
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'

  --  You can test OSC 52 in terminal by using following in your terminal -
  --  printf $'\e]52;c;%s\a' "$(base64 <<<'hello world')"
  --  Is this function needed?
  local function paste(reg)
    return { vim.fn.split(vim.fn.getreg(reg), '\n'), vim.fn.getregtype(reg) }
  end
  local osc52 = require 'vim.ui.clipboard.osc52'
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = osc52.copy '+',
      ['*'] = osc52.copy '+',
    },
    paste = {
      ['+'] = paste '+',
      ['*'] = paste '+',
    },
  }
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
--vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- vim: ts=2 sts=2 sw=2 et
