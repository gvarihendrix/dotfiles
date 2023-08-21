local api = require('nvim-tree.api')


local function open_nvim_tree(data)
    -- open nvim tree
    local is_directory = vim.fn.isdirectory(data.file) == 1

    if not is_directory then
        return
    end

    -- change to the directory
    vim.cmd.cd(data.file)
    api.tree.open()
end


vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
