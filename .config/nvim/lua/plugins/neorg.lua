return {
  "nvim-neorg/neorg",
  -- Only use if you want to layz load neorg
  -- ft = "norg",
  version = "*",
  opts = {
    load = {
      ["core.defaults"] = {},
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
      ["core.concealer"] = {},
      ["core.ui"] = {},
      ["core.queries.native"] = {},
      ["core.presenter"] = {
        config = {
          zen_mode = "zen-mode",
        },
      },
    },
  },
  init = function()
    vim.wo.foldlevel = 99
    vim.wo.conceallevel = 2
  end,
}
