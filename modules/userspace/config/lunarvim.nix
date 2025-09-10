{ config, pkgs, ... }:

{
  xdg.configFile."lvim/config.lua" = {
    text = ''
      lvim.plugins = {
          {
              "iamcco/markdown-preview.nvim",
              build = "cd app && npm install",
              ft = "markdown",
          },
      }

      vim.opt.shiftwidth = 4

      -----------------
      -- Keybindings --
      -----------------

      lvim.builtin.terminal.open_mapping = "<c-t>" -- Ctrl + T

      -----------------

      -- Enable line wrapping
      vim.opt.wrap = true      -- Enable line wrapping
      vim.opt.linebreak = true -- Break lines at word boundaries
      vim.opt.scrolloff = 8    -- Keep 8 lines visible above and below the cursor

      -- Format code on save
      lvim.format_on_save.enabled = true

      -- Helper function for tree
      local function open_nvim_tree()
          require("nvim-tree.api").tree.open()
      end

      -- File tree on startup
      vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

      -- Enable transparency
      lvim.transparent_window = true

      -- Enable verymagic mode by default
      -- vim.keymap.set('n', '/', '/\\v', { noremap = true })
    '';
  };
}
