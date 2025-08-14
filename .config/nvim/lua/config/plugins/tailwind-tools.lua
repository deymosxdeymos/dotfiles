return {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = {
    server = {
      override = true,
      settings = {
        experimental = {
          classRegex = {
            "tw`([^`]*)", -- tw`...`
            "tw=\"([^\"]*)", -- <div tw="..." />
            "tw={\"([^\"}]*)", -- <div tw={"..."} />
            "tw\\.\\w+`([^`]*)", -- tw.xxx`...`
            "tw\\(.*?\\)`([^`]*)", -- tw(component)`...`
            { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            { "classnames\\(([^)]*)\\)", "'([^']*)'" },
            { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
            { "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" }
          }
        }
      }
    },
    document_color = {
      enabled = true,
      kind = "inline",
      inline_symbol = "󰝤 ",
      debounce = 200,
    },
    conceal = {
      enabled = false,
      min_length = nil,
      symbol = "󱏿",
      highlight = {
        fg = "#38BDF8",
      },
    },
    keymaps = {
      smart_increment = {
        enabled = true,
      }
    },
    cmp = {
      highlight = "foreground",
    },
    telescope = {
      utilities = {
        callback = function(name, class)
          -- Custom callback when selecting utility class
        end,
      },
    },
  }
}