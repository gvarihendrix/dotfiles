local api = require('nvim-tree.api')


local function open_nvim_tree()
    -- open nvim tree
    api.tree.open()
end


vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
