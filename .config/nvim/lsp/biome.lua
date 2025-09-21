return {
  cmd = { "biome", "lsp-proxy" },
  root_markers = {
    "biome.json",
    "biome.jsonc",
    "package.json",
    ".git"
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "astro",
    "svelte",
    "vue",
    "css"
  },
  single_file_support = false,
  settings = {}
}