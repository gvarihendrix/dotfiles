return {
  "nvim-neorg/neorg",
  ft = "norg",
  version = "*",
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        -- ["core.keybinds"] = {
        --   default_keybinds = false
        -- }
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            },
            default_workspace = "notes",
          },
        },
        -- ["core.intergrations.treesitter"] = {},
        -- ["core.autocommands"] = {},
        -- ["core.esupports.indent"] = {},
        -- ["core.completion"] = {},
        -- ["core.intergrations.nvim-cmp"] = {},
        ["core.ui"] = {},
        ["core.queries.native"] = {},
        ["core.presenter"] = {
          config = {
            zen_mode = "zen-mode",
          },
        },
      },
    })

    vim.wo.foldlevel = 99
    vim.wo.conceallevel = 2
  end,
  build = ":Neorg sync-parsers",
}
