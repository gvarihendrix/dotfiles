local lsp = require('lsp-zero')
print('Running lsp file')
require('mason').setup({})

require('mason-lspconfig').setup({
    ensure_installed ={
        'tsserver',
        'rust_analyzer',
        'lua_ls',
        'erlangls',
        'elixirls',
        'csharp_ls',
        'cssls',
        'tailwindcss',
    },
    handlers = {
        lsp.default_setup,
        rust_analyzer = function()
            local rt = require("rust-tools")
            rt.setup()

            rt.setup({
              server = {
                on_attach = function(_, bufnr)
                  -- Hover actions
                  -- vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                  -- Code action groups
                  vim.keymap.set("n", "<leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
                end,
              },
            })
        end,
        elixirls = function()
            local elixir = require('elixir')
            elixir.setup()
        end,
    }
})

local cmp = require('cmp')
-- local cmp_select = {behavior = cmp.SelectBehavior.Select}
-- local cmp_mappings = cmp.mapping.preset.insert({
--     ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
--     ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
--     ['<CR>'] = cmp.mapping.confirm({select = true}),
--     ['<C-Space>'] = cmp.mapping.complete(),
-- })

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  mapping = {
    ['<C-y>'] = cmp.mapping.confirm({select = false}),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
    ['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
    ['<C-p>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
    ['<C-n>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil
--
-- cmp.setup({
--     mapping = cmp_mappings,
--     formatting = lsp.cmp_format()
-- })

lsp.on_attach(function(_client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

vim.diagnostic.config({
    virtual_text = true
})
