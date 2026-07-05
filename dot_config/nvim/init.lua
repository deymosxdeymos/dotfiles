vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.cmd([[hi @lsp.type.number gui=italic]])

vim.opt.winborder = "rounded"
vim.opt.updatetime = 250
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.clipboard = "unnamedplus"

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = true,
  virtual_text = false,
  virtual_lines = {
    current_line = true,
  },
  float = {
    border = "rounded",
    source = "if_many",
  },
})

vim.pack.add({
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/echasnovski/mini.nvim" },
  { src = "https://github.com/echasnovski/mini.icons" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/datsfilipe/vesper.nvim" },
  { src = "https://github.com/maxmx03/solarized.nvim" },
  { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
  { src = "https://github.com/chentoast/marks.nvim" },
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
})

require("mini.icons").setup()
require("marks").setup({
  builtin_marks = { "<", ">", "^" },
})
local harpoon = require("harpoon")
harpoon:setup()

require("mini.statusline").setup({ use_icons = true })
require("mini.tabline").setup({
  show_icons = false,
  tabpage_section = "none",
  format = function(buf_id, label)
    local listed_buffers = vim.tbl_filter(function(id)
      return vim.bo[id].buflisted
    end, vim.api.nvim_list_bufs())

    table.sort(listed_buffers)

    local ordinal = 0
    for index, id in ipairs(listed_buffers) do
      if id == buf_id then
        ordinal = index
        break
      end
    end

    return string.format(" %d:%s ", ordinal, label)
  end,
})
require("mini.pairs").setup()
require("mini.completion").setup()
vim.o.completeopt = "menuone,noselect,popup,fuzzy"
vim.opt.shortmess:append("c")
vim.lsp.config("*", {
  completion = {
    triggers = { "." },
  },
})

require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})

local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    preview = { treesitter = false },
    color_devicons = true,
    sorting_strategy = "ascending",
    borderchars = {
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
    },
    path_display = { "smart" },
    layout_config = {
      prompt_position = "top",
      preview_cutoff = 40,
      width = 0.95,
      height = 0.85,
    },
  },
  extensions = {
    ["ui-select"] = require("telescope.themes").get_dropdown({}),
  },
})
telescope.load_extension("ui-select")

require("oil").setup({
  view_options = {
    show_hidden = true,
  },
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    autosave_changes = true,
  },
  columns = {
    "icon",
  },
  float = {
    max_width = 0.3,
    max_height = 0.6,
    border = "rounded",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "vim", "markdown", "rust", "javascript", "typescript", "typescriptreact", "css", "html", "python" },
  callback = function(args)
    local max_filesize = 100 * 1024
    local path = vim.api.nvim_buf_get_name(args.buf)
    if path ~= "" then
      local ok, stats = pcall((vim.uv or vim.loop).fs_stat, path)
      if ok and stats and stats.size > max_filesize then
        return
      end
    end

    pcall(vim.treesitter.start, args.buf)
  end,
})

local function system_color_scheme()
  if vim.fn.executable("dms") == 1 then
    local ok, out = pcall(vim.fn.system, { "dms", "ipc", "theme", "getMode" })
    if ok then
      if out:match("dark") then
        return "dark"
      end
      if out:match("light") then
        return "light"
      end
    end
  end

  if vim.fn.executable("gsettings") == 1 then
    local ok, out = pcall(vim.fn.system, {
      "gsettings",
      "get",
      "org.gnome.desktop.interface",
      "color-scheme",
    })
    if ok then
      if out:match("prefer%-dark") then
        return "dark"
      end
      if out:match("prefer%-light") then
        return "light"
      end
    end
  end

  return "dark"
end

local current_system_scheme
local function apply_system_theme()
  local scheme = system_color_scheme()
  if scheme == current_system_scheme and vim.g.colors_name then
    return
  end

  current_system_scheme = scheme
  vim.o.background = scheme
  vim.cmd.colorscheme(scheme == "light" and "rose-pine-dawn" or "vesper")
end

apply_system_theme()

local theme_timer = vim.uv.new_timer()
theme_timer:start(0, 5000, vim.schedule_wrap(apply_system_theme))

vim.api.nvim_create_user_command("ThemeAuto", apply_system_theme, {})

local capabilities = vim.lsp.protocol.make_client_capabilities()

local function root_dir(bufnr)
  local root = vim.fs.root(bufnr, { "pyproject.toml", "setup.py", ".git" })
  if root then
    return root
  end
  local name = vim.api.nvim_buf_get_name(bufnr)
  return name ~= "" and vim.fs.dirname(name) or vim.loop.cwd()
end

vim.lsp.config("ty", {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_dir = root_dir,
  single_file_support = true,
  capabilities = capabilities,
})

local fmt_server = {
  javascript = "oxfmt",
  javascriptreact = "oxfmt",
  typescript = "oxfmt",
  typescriptreact = "oxfmt",
  json = "oxfmt",
  jsonc = "oxfmt",
  html = "oxfmt",
  css = "oxfmt",
  scss = "oxfmt",
  less = "oxfmt",
  rust = "rust_analyzer",
  python = "ruff",
  lua = "lua_ls",
}

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local preferred = fmt_server[vim.bo[args.buf].filetype]
    if not preferred then
      return
    end

    vim.lsp.buf.format({
      bufnr = args.buf,
      timeout_ms = 1000,
      filter = function(client)
        return client.name == preferred and client:supports_method("textDocument/formatting")
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      local chars = {}
      for i = 32, 126 do
        table.insert(chars, string.char(i))
      end
      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
    end

    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gr", vim.lsp.buf.references, "References")
    map("gi", vim.lsp.buf.implementation, "Go to implementation")
    map("gy", vim.lsp.buf.type_definition, "Go to type definition")
    map("K", vim.lsp.buf.hover, "Hover docs")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>d", vim.diagnostic.open_float, "Diagnostic float")
    map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
    map("]d", vim.diagnostic.goto_next, "Next diagnostic")
  end,
})

vim.lsp.config("lua_ls", { capabilities = capabilities })
vim.lsp.enable("lua_ls")

vim.lsp.config("oxfmt", {
  capabilities = capabilities,
  workspace_required = false,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local marker = vim.fs.find({
      ".oxfmtrc.json",
      ".oxfmtrc.jsonc",
      "package.json",
      ".git",
    }, { path = fname, upward = true })[1]
    on_dir(marker and vim.fs.dirname(marker) or vim.fs.dirname(fname))
  end,
})
vim.lsp.enable("oxfmt")

vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
})
vim.lsp.enable("ts_ls")

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { features = "all" },
      check = { command = "clippy" },
      completion = { callable = { snippets = "add_parentheses" } },
      diagnostics = { disabled = { "inactive-code", "unlinked-file" } },
    },
  },
})
vim.lsp.enable("rust_analyzer")

vim.lsp.config("cssls", {
  capabilities = capabilities,
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
})
vim.lsp.enable("cssls")

vim.lsp.config("tailwindcss", {
  capabilities = capabilities,
})
vim.lsp.enable("tailwindcss")

vim.lsp.enable("ty")

vim.lsp.config("ruff", {
  capabilities = capabilities,
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
})
vim.lsp.enable("ruff")

local function pack_clean()
  local active_plugins = {}
  local unused_plugins = {}

  for _, plugin in ipairs(vim.pack.get()) do
    active_plugins[plugin.spec.name] = plugin.active
  end

  for _, plugin in ipairs(vim.pack.get()) do
    if not active_plugins[plugin.spec.name] then
      table.insert(unused_plugins, plugin.spec.name)
    end
  end

  if #unused_plugins == 0 then
    print("No unused plugins.")
    return
  end

  local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.pack.del(unused_plugins)
  end
end

local map = vim.keymap.set
local indent_opts = { noremap = true, silent = true }

map({ "n", "x" }, "<leader>y", '"+y')
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank" })
map({ "i", "s" }, "<C-e>", function()
  if vim.snippet and vim.snippet.active({ direction = 1 }) then
    vim.snippet.jump(1)
  end
end, { silent = true })
map({ "i", "s" }, "<C-J>", function()
  if vim.snippet and vim.snippet.active({ direction = 1 }) then
    vim.snippet.jump(1)
  end
end, { silent = true })
map({ "i", "s" }, "<C-K>", function()
  if vim.snippet and vim.snippet.active({ direction = -1 }) then
    vim.snippet.jump(-1)
  end
end, { silent = true })
map({ "n", "t" }, "<leader>t", "<Cmd>split<CR><Cmd>term<CR>i", { desc = "Split terminal" })
map({ "n", "t" }, "<leader>x", "<Cmd>tabclose<CR>", { desc = "Close tab" })
map({ "n" }, "<leader>pc", pack_clean, { desc = "Clean unused packages" })

vim.cmd([[
  nnoremap g= g+|
  nnoremap gK @='ddkPJ'<cr>|
  xnoremap gK <esc><cmd>keeppatterns '<,'>-global/$/normal! ddpkJ<cr>
  noremap! <c-r><c-d> <c-r>=strftime('%F')<cr>
  noremap! <c-r><c-t> <c-r>=strftime('%T')<cr>
  noremap! <c-r><c-f> <c-r>=expand('%:t')<cr>
  noremap! <c-r><c-p> <c-r>=expand('%:p')<cr>
  xnoremap <expr> . "<esc><cmd>'<,'>normal! ".v:count1.'.<cr>'
]])

for i = 1, 8 do
  map({ "n", "t" }, "<leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end

map("n", "gh", "0", { desc = "Jump: start of line" })
map("n", "gl", "$", { desc = "Jump: end of line" })
map("n", "H", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "L", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "yag", ":%y<CR>", { noremap = true, silent = true })
map("n", "vag", "ggVG", { noremap = true, silent = true })
map("v", "<", "<gv", indent_opts)
map("v", ">", ">gv", indent_opts)
map("n", "<ESC>", ":nohlsearch<CR>", { noremap = true, silent = true })
map({ "n", "v", "x" }, "<CR>", ":", { desc = "Command-line shortcut" })
map({ "n", "v", "x" }, "<leader>r", ":edit!<CR>", { desc = "Reload current file" })
map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit init.lua" })
map("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.wo.linebreak = vim.wo.wrap
end, { desc = "Toggle soft wrap" })
map({ "n", "v", "x" }, "<leader>n", ":norm ", { desc = "Enter normal command" })
map({ "n", "v", "x" }, "<leader>o", "<Cmd>source %<CR>", { desc = "Source current file" })
map({ "n", "v", "x" }, "<leader>O", "<Cmd>restart<CR>", { desc = "Restart Neovim" })
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Start substitute" })
map({ "n", "v", "x" }, "<leader>i", "<Cmd>tabedit .gitignore<CR>", { desc = "Edit .gitignore" })
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "n" }, "<leader>e", "<cmd>Oil<CR>", { desc = "Open file explorer" })
map({ "n" }, "<leader>c", "1z=", { desc = "Spelling suggestions" })
map({ "n" }, "<C-q>", ":copen<CR>", { silent = true, desc = "Quickfix open" })
map({ "n" }, "<leader>w", "<Cmd>update<CR>", { desc = "Write current buffer" })
map({ "n" }, "<leader>q", "<Cmd>quit<CR>", { desc = "Quit current buffer" })
map({ "n" }, "<leader>Q", "<Cmd>wqa<CR>", { desc = "Write and quit all" })
map({ "n" }, "<leader>a", ":edit #<CR>", { desc = "Alternate file" })
map({ "t" }, "<Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })

local function git_files()
  builtin.find_files({ hidden = true, no_ignore = true })
end

map({ "n" }, "<leader>sg", git_files, { desc = "Find files incl. ignored" })
map({ "n" }, "<leader>sb", builtin.buffers, { desc = "Buffers" })
map({ "n" }, "<leader>si", builtin.grep_string, { desc = "Grep string" })
map({ "n" }, "<leader>so", builtin.oldfiles, { desc = "Old files" })
map({ "n" }, "<leader>sh", builtin.help_tags, { desc = "Help tags" })
map({ "n" }, "<leader>sm", builtin.man_pages, { desc = "Man pages" })
map({ "n" }, "<leader>sr", builtin.lsp_references, { desc = "LSP references" })
map({ "n" }, "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
map({ "n" }, "<leader>sT", builtin.lsp_type_definitions, { desc = "Type definitions" })
map({ "n" }, "<leader>ss", builtin.current_buffer_fuzzy_find, { desc = "Buffer fuzzy find" })
map({ "n" }, "<leader>st", builtin.builtin, { desc = "Telescope pickers" })
map({ "n" }, "<leader>sk", builtin.keymaps, { desc = "Keymaps" })

map("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: add file" })
map("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: menu" })
map("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon: file 1" })
map("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon: file 2" })
map("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon: file 3" })
map("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon: file 4" })

map({ "n" }, "<space>fd", builtin.find_files, { desc = "Find files" })
map({ "n" }, "<space>fD", function()
  builtin.find_files({ hidden = true })
end, { desc = "Find files incl. hidden" })
map({ "n" }, "<space>fg", builtin.live_grep, { desc = "Live grep" })
map({ "n" }, "<space>fw", builtin.grep_string, { desc = "Grep word under cursor" })
map({ "n" }, "<space>en", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find in nvim config" })
map({ "n" }, "<space>ep", function()
  builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt") })
end, { desc = "Find in packages" })
map({ "n" }, "<space>th", function()
  builtin.colorscheme({ enable_preview = true })
end, { desc = "Theme switcher" })

map({ "n" }, "<M-n>", "<cmd>resize +2<CR>")
map({ "n" }, "<M-e>", "<cmd>resize -2<CR>")
map({ "n" }, "<M-i>", "<cmd>vertical resize +5<CR>")
map({ "n" }, "<M-m>", "<cmd>vertical resize -5<CR>")
map("n", "<M-j>", "<cmd>cnext<CR>")
map("n", "<M-k>", "<cmd>cprev<CR>")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "-", "<cmd>Oil<CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.hl_op()
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = { "*.tsx" },
  group = vim.api.nvim_create_augroup("tsx-filetype-detect", { clear = true }),
  callback = function()
    vim.bo.filetype = "typescriptreact"
  end,
})

local job_id = 0
local current_command = ""

map("n", "<space>to", function()
  vim.cmd.Floaterminal()
  job_id = vim.b.terminal_job_id or vim.bo.channel
end, { desc = "Open floating terminal" })

map("n", "<space>te", function()
  current_command = vim.fn.input("Command: ")
end, { desc = "Set terminal command" })

map("n", "<space>tr", function()
  if current_command == "" then
    current_command = vim.fn.input("Command: ")
  end

  if job_id ~= 0 then
    vim.fn.chansend(job_id, { current_command .. "\r\n" })
  end
end, { desc = "Run terminal command" })
