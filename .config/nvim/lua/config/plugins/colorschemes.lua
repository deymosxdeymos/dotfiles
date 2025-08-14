return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      terminal_colors = true,
      italic = {
        terminal_colors = true,
        strings = false,
        emphasis = false,
        comments = true,
        operators = false,
        folds = true,
      },
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
    end,
  },
  {
    "kepano/flexoki-neovim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.termguicolors = true
    end,
  },
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.termguicolors = true
    end,
  },
  {
    "zaldih/themery.nvim",
    priority = 999,
    config = function()
      require("themery").setup({
        themes = {
          {
            name = "Flexoki Dark",
            colorscheme = "flexoki-dark",
          },
          {
            name = "Flexoki Light",
            colorscheme = "flexoki-light",
          },
          {
            name = "Gruvbox Dark Hard",
            colorscheme = "gruvbox",
            before = [[
              vim.o.background = "dark"
              require("gruvbox").setup({ contrast = "hard" })
            ]],
          },
          {
            name = "Gruvbox Light Hard",
            colorscheme = "gruvbox",
            before = [[
              vim.o.background = "light"
              require("gruvbox").setup({ contrast = "hard" })
            ]],
          },
          {
            name = "Solarized Light",
            colorscheme = "solarized",
            before = [[
              vim.o.background = "light"
            ]],
          },
        },
        livePreview = true,
      })
    end,
  },
}
