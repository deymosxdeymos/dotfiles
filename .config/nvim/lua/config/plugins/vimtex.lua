return {
  "lervag/vimtex",
  lazy = false, -- don't want to lazy load VimTeX
  init = function()
    -- VimTeX configuration
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      build_dir = "build",
      options = {
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }

    -- vim.g.vimtex_fold_enabled = 1
  end,
}
