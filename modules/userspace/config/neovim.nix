{ pkgs, ... }:

{
  home.packages = with pkgs; [ nodePackages.npm unzip nixd ];

  programs.neovim = {
    extraLuaConfig = # lua
      ''
        ----------------------
        --- PLUGIN MANAGER ---
        ----------------------

        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not vim.loop.fs_stat(lazypath) then
          vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
          })
        end
        vim.opt.rtp:prepend(lazypath)

        ---------------
        --- PLUGINS ---
        ---------------

        require("lazy").setup({
          -- Essentials
          "nvim-treesitter/nvim-treesitter", -- Syntax highlighting and code parsing
          "neovim/nvim-lspconfig",           -- Language Server Protocol configurations for IDE-like features
          "hrsh7th/nvim-cmp",                -- Autocompletion engine
          "nvim-lua/plenary.nvim",           -- Utility functions required by many plugins
          "hrsh7th/cmp-nvim-lsp",            -- The bridge between nvim-cmp and LSP capabilities
          "folke/snacks.nvim",                     -- QoL plugins

          -- Productivity Boosters
          "tpope/vim-commentary",         -- Easy commenting/uncommenting code
          {
            "windwp/nvim-autopairs",        -- Auto-close brackets, quotes, etc.
            event = "InsertEnter",
            config = true,
          },
          "akinsho/bufferline.nvim",      -- Buffer/tab line with tabs and close buttons
          "iamcco/markdown-preview.nvim", -- Markdown previewer
          "othree/eregex.vim",            -- PCRE-like regex

          -- Git & Version Control
          "tpope/vim-fugitive",      -- Git integration
          "lewis6991/gitsigns.nvim", -- Git change indicators in sign column

          -- UI & Appearance
          --"folke/tokyonight.nvim",                -- Tokyo Night color scheme
          {
            "nvim-tree/nvim-tree.lua",     -- File explorer sidebar
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
              local api = require "nvim-tree.api"

              local function my_on_attach(bufnr)
                local function opts(desc)
                  return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                -- default mappings
                api.config.mappings.default_on_attach(bufnr)

                -- custom mappings
                --vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
                vim.keymap.set('n', '?',     api.tree.toggle_help, opts('Help'))
              end

              require("nvim-tree").setup {
                on_attach = my_on_attach,
                -- other options
                view = { width = 30, side = "left" },
                renderer = { icons = { show = { git = true, folder = true, file = true } } },
              }
            end,
          },
          {
            "akinsho/toggleterm.nvim",
            config = function()
              require("toggleterm").setup {
                size = 15,
                open_mapping = [[<C-t>]],
                direction = "horizontal", -- bottom split
                start_in_insert = true,
                persist_size = true,
                shade_terminals = false,
              }
            end
          },
          "nvim-lualine/lualine.nvim",     -- Statusline
          "Galicarnax/vim-regex-syntax",   -- PCRE syntax highlighting
          "nvim-telescope/telescope.nvim", -- Fancy interactive diagnostics windows
          {
            "catgoose/nvim-colorizer.lua",  -- Color highlighter
            event = "BufReadPre",
          },
          "goolord/alpha-nvim",            -- Greeter

          -- Debugging
          "mfussenegger/nvim-dap", -- Debug Adapter Protocol client

          -- Language-specific LSP servers and helpers
          {
            "williamboman/mason.nvim", -- Portable package manager for LSPs, DAP servers, linters, and formatters
            build = ":MasonUpdate"
          },
          "williamboman/mason-lspconfig.nvim", -- Bridges mason with nvim-lspconfig

          -- Optional: enhanced Lua support for Neovim
          {
            "folke/neodev.nvim", -- Neovim Lua development setup
            config = true,
          },

          -- Plugins with specific configuration
          --{
          --  "hrsh7th/nvim-cmp",
          --  event = "InsertEnter",                  -- lazy-load on Insert mode
          --  dependencies = { "hrsh7th/cmp-nvim-lsp" },
          --  config = function()
          --    -- Plugin-specific setup here
          --    require("cmp").setup {}
          --  end,
          --},

          -- More plugins...
        })

        -------------------------
        --- UTILITY FUNCTIONS ---
        -------------------------

        -- TODO

        ----------------------
        --- AUTOCOMPLETION ---
        ----------------------

        local cmp = require("cmp")

        cmp.setup({
          completion = {
            autocomplete = { "TextChanged", "TextChangedI" },  -- Automatically show completion on text changes
          },
          snippet = {
            expand = function(args)
              vim.fn["vsnip#expand"](args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
          }),
        })

        -----------------
        --- LSP SETUP ---
        -----------------

        local util = require('lspconfig.util')

        -- After plugins loaded
        vim.defer_fn(function()
          local mason = require("mason")
          local mason_lspconfig = require("mason-lspconfig")
          local lspconfig = require("lspconfig")

          mason.setup()
          mason_lspconfig.setup({
            ensure_installed = { "pyright", "rust_analyzer", "clangd", "lua_ls" },
          })

          local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

          local on_attach = function(client, bufnr)
            -- You can set keymaps and other buffer-local options here
            if client.supports_method("textDocument/formatting") then
              vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
              vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({ bufnr = bufnr })
                end,
              })
            end
          end

          local capabilities = require("cmp_nvim_lsp").default_capabilities()

          -- Setup Python LSP
          lspconfig.pyright.setup {
            on_attach = on_attach,
            capabilities = capabilities,
          }

          -- Setup Rust LSP
          lspconfig.rust_analyzer.setup {
            on_attach = on_attach,
            capabilities = capabilities,
          }

          -- Setup Nix LSP
          lspconfig.nixd.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = util.root_pattern('flake.nix', 'default.nix', '.git'),
          }

          -- Setup C/C++ LSP
          lspconfig.clangd.setup {
            on_attach = on_attach,
            capabilities = capabilities,
          }

          -- Setup Lua LSP (lua_ls)
          lspconfig.lua_ls.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" }, -- recognize `vim` global in Neovim config
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
                telemetry = { enable = false },
              },
            },
          }
        end, 0)

        -- Set indentation for all programming filetypes
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "*" }, -- apply to all filetypes
          callback = function()
            -- Use spaces instead of tabs
            vim.bo.expandtab = true
            -- Number of spaces per indentation level
            vim.bo.shiftwidth = 2
            -- Number of spaces to use for <Tab>
            vim.bo.tabstop = 2
            -- Number of spaces for autoindent
            vim.bo.softtabstop = 2
          end,
        })

        -------------
        --- LOOKS ---
        -------------

        -- Transparency
        vim.cmd [[
          hi Normal ctermbg=none guibg=none
          hi NormalNC ctermbg=none guibg=none
          hi VertSplit ctermbg=none guibg=none
          hi StatusLine ctermbg=none guibg=none
          hi LineNr ctermbg=none guibg=none
          hi NonText ctermbg=none guibg=none
        ]]

        -- Customize the appearance of the hover diagnostic float
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = "rounded",      -- Rounded border for the float
          focusable = false,       -- Don't let the hover float be focusable
          max_width = 80,          -- Maximum width of the hover window
          max_height = 20,         -- Maximum height of the hover window
          padding = { 1, 1 },      -- Padding inside the window
          winhighlight = "Normal:Normal,FloatBorder:DiagnosticInfo", -- Custom highlights for Normal and Border
        })

        -------------------
        --- VIM OPTIONS ---
        -------------------

        vim.g.eregex_force_case = 1 -- Force case sensitive like Perl ReGeX

        -- Enable search highlighting
        vim.opt.hlsearch = true
        vim.opt.incsearch = true

        vim.opt.wrap = true      -- Enable line wrapping
        vim.opt.linebreak = true -- Break lines at word boundaries
        vim.opt.scrolloff = 8    -- Keep 8 lines visible above and below the cursor

        -- Remember the last position of the cursor in a file
        vim.api.nvim_create_augroup("remember_cursor_position", { clear = true })
        vim.api.nvim_create_autocmd("BufReadPost", {
          group = "remember_cursor_position",
          pattern = "*",
          callback = function()
            local line = vim.fn.line("'\"")
            if line > 0 and line <= vim.fn.line("$") then
              vim.api.nvim_command("normal! g'\"")
            end
          end
        })

        ----------------
        --- KEYBINDS ---
        ----------------

        -- To find what your leader key is, run :echo mapleader
        -- If it returns nothing, your leader is backslash

        --vim.api.nvim_set_keymap('n', '<C-t>', ':split | terminal<CR>', { noremap = true, silent = true }) -- Open terminal

        -- Toggle error (LSP
        --vim.keymap.set('n', '<leader>e', function()
        --  vim.diagnostic.open_float()
        --end)
        --vim.keymap.set('n', '<leader>e', function()
        --  require('telescope.builtin').diagnostics({ bufnr = 0 })
        --end, { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })

        vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })  -- Go to previous diagnostic
        vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })  -- Go to next diagnostic
        vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true }) -- Populate location list with all diagnostics

        -- Toggle nvim-tree.lua
        vim.keymap.set("n", "<C-s>", function()
          local api = require "nvim-tree.api"

          if api.tree.is_visible() then
            api.tree.close()
          else
            api.tree.open()
          end
        end, { noremap = true, silent = true, desc = "Toggle NvimTree" })
      '';
  };
}
