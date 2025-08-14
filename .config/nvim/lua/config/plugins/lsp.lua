return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
      'b0o/schemastore.nvim',
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lspconfig = require("lspconfig")
      
      -- Configure diagnostics - using built-in neovim 0.11 virtual_lines
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = { 
          current_line = true 
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- Lua LSP
      lspconfig.lua_ls.setup { capabilities = capabilities }

      -- TypeScript/JavaScript with Deno (for Deno projects)
      lspconfig.denols.setup {
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
        init_options = {
          lint = true,
          unstable = true,
          suggest = {
            imports = {
              hosts = {
                ["https://deno.land"] = true,
                ["https://cdn.nest.land"] = true,
                ["https://crux.land"] = true
              }
            }
          }
        }
      }

      -- TypeScript/JavaScript with tsserver (for regular Node.js projects)
      lspconfig.ts_ls.setup {
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
        single_file_support = false,
        on_attach = function(client, bufnr)
          -- Disable tsserver formatting completely
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      }

      -- Python with basedpyright
      lspconfig.basedpyright.setup {
        capabilities = capabilities,
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            }
          }
        }
      }

      -- Ruff for Python linting/formatting
      lspconfig.ruff.setup {
        capabilities = capabilities,
        init_options = {
          settings = {
            args = {}
          }
        }
      }

      -- C/C++ with clangd
      lspconfig.clangd.setup {
        capabilities = capabilities,
        cmd = { "clangd", "--background-index" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
        init_options = {
          clangdFileStatus = true,
        },
      }

      -- LaTeX with texlab
      lspconfig.texlab.setup {
        capabilities = capabilities,
        settings = {
          texlab = {
            auxDirectory = "build",
            build = {
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              executable = "latexmk",
              forwardSearchAfter = false,
              onSave = false,
            },
            chktex = {
              onEdit = false,
              onOpenAndSave = false,
            },
            diagnosticsDelay = 300,
          },
        },
      }

       -- JSON with jsonls
       lspconfig.jsonls.setup {
         capabilities = capabilities,
         settings = {
           json = {
             schemas = require('schemastore').json.schemas(),
             validate = { enable = true },
           },
         },
       }
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then return end

          -- Format on save for different file types
          if vim.bo.filetype == "lua" then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
              end,
            })
          elseif vim.bo[args.buf].filetype == "typescript" or vim.bo[args.buf].filetype == "javascript" or vim.bo[args.buf].filetype == "typescriptreact" or vim.bo[args.buf].filetype == "javascriptreact" then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf })
              end,
            })
          elseif vim.bo.filetype == "python" then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
              end,
            })
          elseif vim.bo.filetype == "c" or vim.bo.filetype == "cpp" then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
              end,
            })
          elseif vim.bo.filetype == "json" then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
              end,
            })
          elseif vim.bo.filetype == "tex" then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
                local content = table.concat(lines, '\n')
                
                -- Format with latexindent for proper LaTeX structure
                local indent_result = vim.system({ 'latexindent', '-m' }, {
                  stdin = content,
                  text = true 
                }):wait()
                
                if indent_result.code == 0 and indent_result.stdout then
                  local new_lines = vim.split(indent_result.stdout, '\n')
                  if new_lines[#new_lines] == '' then
                    table.remove(new_lines, #new_lines)
                  end
                  vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, new_lines)
                end
              end,
            })
          end
        end,
      })
    end,
  }
}