local opt = vim.opt

-- You have to turn this one on :)
opt.inccommand = "split"

-- Best search settings :)
opt.smartcase = true
opt.ignorecase = true

----- Personal Preferences -----
opt.number = true
opt.relativenumber = false

opt.splitbelow = true
opt.splitright = true

opt.signcolumn = "yes"
opt.shada = { "'10", "<0", "s10", "h" }

opt.swapfile = false

-- Don't have `o` add a comment
opt.formatoptions:remove "o"

opt.tabstop = 4
opt.shiftwidth = 4

opt.more = false

opt.title = true
opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (n'

opt.undofile = true
opt.clipboard = "unnamedplus"

opt.incsearch = true                                -- make search act like search in modern browsers
opt.backup = false                                  -- creates a backup file
opt.cmdheight = 1                                   -- more space in the neovim command line for displaying messages
opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
opt.conceallevel = 0                                -- so that `` is visible in markdown files
vim.cmd("set encoding=utf-8")                       -- the encoding written to a file
opt.hlsearch = true                                 -- highlight all matches on previous search pattern
opt.mouse = "a"                                     -- allow the mouse to be used in neovim
opt.pumheight = 10                                  -- pop up menu height
opt.showmode = false                                -- we don't need to see things like -- INSERT -- anymore
opt.showtabline = 0                                 -- always show tabs
opt.smartindent = true                              -- make indenting smarter again
opt.termguicolors = true                            -- set term gui colors (most terminals support this)
opt.timeoutlen = 1000                               -- time to wait for a mapped sequence to complete (in milliseconds)
opt.updatetime = 100                                -- faster completion (4000ms default)
opt.writebackup = false                             -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
opt.expandtab = true                                -- convert tabs to spaces
opt.shiftwidth = 2                                  -- the number of spaces inserted for each indentation
opt.cursorline = false                              -- highlight the current line

opt.breakindent = true                              -- wrap lines with indent
opt.numberwidth = 4                                 -- set number column width to 2 {default 4}
opt.wrap = false                                    -- display lines as one long line
opt.showcmd = false                                 -- Don't show the command in the last line
opt.ruler = true                                    -- Don't show the ruler
