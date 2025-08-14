return {
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Configure mini.statusline
      local statusline = require 'mini.statusline'
      statusline.setup {
        use_icons = true,
      }

      -- Configure mini.pairs
      local pairs = require 'mini.pairs'
      pairs.setup {
        options = {
          modes = { insert = true, command = false, terminal = false },
        }
      }

      local indent = require 'mini.indentscope'
      indent.setup {
        options = {
        }
      }
    end,
  },
}
