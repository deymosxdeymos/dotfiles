vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
vim.cmd("set termguicolors")
vim.g.colors_name = "minimal_dark"

local c = {
  bg        = "#111111",
  fg        = "#dddddd",
  bg_alt    = "#141414",
  bg_sel    = "#1f1f1f",
  ui_border = "#333333",
  muted     = "#dddddd",
  subtle    = "#dddddd",
  ghost     = "#dddddd",
  green     = "#00b09b",
  green_dim = "#00b09b",
  none      = "NONE",
}

local hi = vim.api.nvim_set_hl

-- Base UI
hi(0, "Normal",        { fg = c.fg,  bg = c.bg })
hi(0, "NormalFloat",   { fg = c.fg,  bg = c.bg_alt })
hi(0, "NormalNC",      { fg = c.fg,  bg = c.bg })
hi(0, "CursorLine",    { bg = c.bg_sel })
hi(0, "CursorColumn",  { bg = c.bg_sel })
hi(0, "Visual",        { bg = c.bg_sel })
hi(0, "VisualNOS",     { bg = c.bg_sel })
hi(0, "Search",        { fg = c.fg,  bg = c.bg_sel })
hi(0, "IncSearch",     { fg = c.bg,  bg = c.fg })
hi(0, "LineNr",        { fg = c.ghost })
hi(0, "CursorLineNr",  { fg = c.muted })
hi(0, "SignColumn",    { fg = c.muted, bg = c.bg })
hi(0, "ColorColumn",   { bg = c.bg_alt })
hi(0, "VertSplit",     { fg = c.ui_border, bg = c.bg })
hi(0, "WinSeparator",  { fg = c.ui_border })
hi(0, "StatusLine",    { fg = c.fg,  bg = c.bg_alt })
hi(0, "StatusLineNC",  { fg = c.muted, bg = c.bg_alt })
hi(0, "TabLine",       { fg = c.muted, bg = c.bg_alt })
hi(0, "TabLineSel",    { fg = c.fg,  bg = c.bg })
hi(0, "TabLineFill",   { bg = c.bg_alt })
hi(0, "Pmenu",         { fg = c.fg,  bg = c.bg_alt })
hi(0, "PmenuSel",      { fg = c.bg,  bg = c.fg })
hi(0, "PmenuSbar",     { bg = c.bg_sel })
hi(0, "PmenuThumb",    { bg = c.muted })
hi(0, "WildMenu",      { fg = c.bg,  bg = c.fg })
hi(0, "Folded",        { fg = c.muted, bg = c.bg_alt })
hi(0, "FoldColumn",    { fg = c.ghost, bg = c.bg })
hi(0, "MatchParen",    { fg = c.fg,  bg = c.ui_border })
hi(0, "NonText",       { fg = c.ghost })
hi(0, "SpecialKey",    { fg = c.ghost })
hi(0, "Whitespace",    { fg = c.ghost })
hi(0, "EndOfBuffer",   { fg = c.ghost })
hi(0, "Title",         { fg = c.fg,  bold = true })
hi(0, "Directory",     { fg = c.fg,  bold = true })
hi(0, "Question",      { fg = c.fg })
hi(0, "MoreMsg",       { fg = c.fg })
hi(0, "ModeMsg",       { fg = c.fg,  bold = true })
hi(0, "ErrorMsg",      { fg = c.bg,  bg = "#cc0000" })
hi(0, "WarningMsg",    { fg = "#ccaa00" })
hi(0, "SpellBad",      { undercurl = true, sp = "#cc0000" })
hi(0, "SpellCap",      { undercurl = true, sp = c.muted })

-- Syntax
hi(0, "Comment",       { fg = c.green })
hi(0, "SpecialComment",{ fg = c.green_dim })
hi(0, "String",        { fg = c.subtle })
hi(0, "Character",     { fg = c.subtle })
hi(0, "Number",        { fg = c.fg })
hi(0, "Float",         { fg = c.fg })
hi(0, "Boolean",       { fg = c.fg })
hi(0, "Constant",      { fg = c.fg })
hi(0, "Function",      { fg = c.fg })
hi(0, "Identifier",    { fg = c.fg })
hi(0, "Keyword",       { fg = c.fg })
hi(0, "Statement",     { fg = c.fg })
hi(0, "Conditional",   { fg = c.fg })
hi(0, "Repeat",        { fg = c.fg })
hi(0, "Label",         { fg = c.fg })
hi(0, "Operator",      { fg = c.fg })
hi(0, "Exception",     { fg = c.fg })
hi(0, "PreProc",       { fg = c.green })
hi(0, "Include",       { fg = c.green })
hi(0, "Define",        { fg = c.green })
hi(0, "Macro",         { fg = c.green })
hi(0, "PreCondit",     { fg = c.green })
hi(0, "Type",          { fg = c.fg })
hi(0, "StorageClass",  { fg = c.fg })
hi(0, "Structure",     { fg = c.fg })
hi(0, "Typedef",       { fg = c.fg })
hi(0, "Special",       { fg = c.subtle })
hi(0, "SpecialChar",   { fg = c.subtle })
hi(0, "Tag",           { fg = c.fg })
hi(0, "Delimiter",     { fg = c.fg })
hi(0, "Debug",         { fg = c.muted })
hi(0, "Underlined",    { fg = c.fg, underline = true })
hi(0, "Ignore",        { fg = c.ghost })
hi(0, "Error",         { fg = c.bg, bg = "#cc0000" })
hi(0, "Todo",          { fg = c.bg, bg = c.green })

-- Diagnostics
hi(0, "DiagnosticError",          { fg = "#ff4444" })
hi(0, "DiagnosticWarn",           { fg = "#ccaa00" })
hi(0, "DiagnosticInfo",           { fg = c.subtle })
hi(0, "DiagnosticHint",           { fg = c.muted })
hi(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#ff4444" })
hi(0, "DiagnosticUnderlineWarn",  { undercurl = true, sp = "#ccaa00" })

-- Diff
hi(0, "DiffAdd",    { bg = "#0d2b0d" })
hi(0, "DiffChange", { bg = "#2b2b0d" })
hi(0, "DiffDelete", { bg = "#2b0d0d", fg = c.ghost })
hi(0, "DiffText",   { bg = "#3a3a10" })

-- Treesitter
local plain  = { fg = c.fg }
local bold   = { fg = c.fg }
local italic = { fg = c.fg }
local dim    = { fg = c.subtle }
local grn    = { fg = c.green }
local grn_i  = { fg = c.green }

local ts = {
  ["@comment"]                  = grn_i,
  ["@comment.documentation"]    = grn_i,
  ["@error"]                    = plain,
  ["@none"]                     = plain,
  ["@preproc"]                  = grn,
  ["@define"]                   = grn,
  ["@include"]                  = grn,
  ["@macro"]                    = grn,
  ["@operator"]                 = plain,
  ["@punctuation.delimiter"]    = plain,
  ["@punctuation.bracket"]      = plain,
  ["@punctuation.special"]      = plain,
  ["@string"]                   = dim,
  ["@string.regex"]             = dim,
  ["@string.escape"]            = dim,
  ["@string.special"]           = dim,
  ["@character"]                = dim,
  ["@character.special"]        = dim,
  ["@boolean"]                  = bold,
  ["@number"]                   = plain,
  ["@float"]                    = plain,
  ["@function"]                 = bold,
  ["@function.call"]            = plain,
  ["@function.builtin"]         = bold,
  ["@function.macro"]           = grn,
  ["@method"]                   = bold,
  ["@method.call"]              = plain,
  ["@constructor"]              = plain,
  ["@parameter"]                = plain,
  ["@keyword"]                  = bold,
  ["@keyword.function"]         = bold,
  ["@keyword.operator"]         = bold,
  ["@keyword.return"]           = bold,
  ["@keyword.import"]           = grn,
  ["@keyword.conditional"]      = bold,
  ["@keyword.repeat"]           = bold,
  ["@keyword.exception"]        = bold,
  ["@conditional"]              = bold,
  ["@repeat"]                   = bold,
  ["@label"]                    = bold,
  ["@exception"]                = bold,
  ["@type"]                     = italic,
  ["@type.builtin"]             = italic,
  ["@type.definition"]          = italic,
  ["@type.qualifier"]           = bold,
  ["@storageclass"]             = bold,
  ["@attribute"]                = plain,
  ["@field"]                    = plain,
  ["@property"]                 = plain,
  ["@variable"]                 = plain,
  ["@variable.builtin"]         = bold,
  ["@variable.member"]          = plain,
  ["@variable.parameter"]       = plain,
  ["@constant"]                 = plain,
  ["@constant.builtin"]         = bold,
  ["@constant.macro"]           = grn,
  ["@namespace"]                = plain,
  ["@symbol"]                   = plain,
  ["@tag"]                      = plain,
  ["@tag.attribute"]            = plain,
  ["@tag.delimiter"]            = plain,
  ["@text"]                     = plain,
  ["@text.strong"]              = bold,
  ["@text.emphasis"]            = italic,
  ["@text.uri"]                 = { fg = c.fg, underline = true },
  ["@text.title"]               = bold,
  ["@text.literal"]             = dim,
  ["@text.reference"]           = plain,
  ["@todo"]                     = { fg = c.bg, bg = c.green },
}

for group, opts in pairs(ts) do
  hi(0, group, opts)
end

-- LSP semantic tokens
local lsp_plain = {
  "LspReferenceText", "LspReferenceRead", "LspReferenceWrite",
}
for _, g in ipairs(lsp_plain) do
  hi(0, g, { bg = c.bg_sel })
end

local lsp_types = {
  "namespace", "type", "class", "enum", "interface", "struct",
  "typeParameter", "parameter", "variable", "property", "enumMember",
  "event", "function", "method", "macro", "keyword", "modifier",
  "comment", "string", "number", "regexp", "operator", "decorator",
  "selfKeyword", "builtinType", "typeAlias", "unresolvedReference",
}
for _, t in ipairs(lsp_types) do
  hi(0, "@lsp.type." .. t, {})
end

hi(0, "@lsp.type.variable.lua",  {})
hi(0, "@lsp.type.property.lua",  {})
hi(0, "@lsp.type.keyword.lua",   {})
hi(0, "@lsp.typemod.variable.defaultLibrary", { fg = c.fg })
hi(0, "@lsp.typemod.function.defaultLibrary", { fg = c.fg })
