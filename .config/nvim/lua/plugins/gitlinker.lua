return {
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      {
        "<leader>gb",
        function()
          require("gitlinker").get_buf_range_url("n", {
            action_callback = require("gitlinker.actions").open_in_browser,
          })
        end,
        mode = "n",
        desc = "Open git permalink in browser (normal mode)",
      },
      {
        "<leader>gb",
        function()
          require("gitlinker").get_buf_range_url("v", {
            action_callback = require("gitlinker.actions").open_in_browser,
          })
        end,
        mode = "v",
        desc = "Open git permalink in browser (visual mode)",
      },
    },
  },
}
