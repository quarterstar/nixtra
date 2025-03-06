-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-------------
-- Plugins --
-------------

lvim.plugins ={
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
