require('nvim-treesitter.configs').setup({
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = {
    "c", "lua", "vim", "vimdoc", "query",
    "typescript", "elixir", "erlang", "heex", "rust",
    "bash", "fish", "json5", "html", "toml", "yaml", "sql"
  },
  sync_install = false,
  auto_install = true,
})


