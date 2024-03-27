-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

vim.o.autochdir = true

-- set relative line numbers
vim.opt.relativenumber = true

-- set line wrapping
vim.opt.wrap = true

-- PLUGINS
lvim.plugins = {

  { "tpope/vim-fugitive" , lazy = false},
  { "dylanaraps/wal.vim" , lazy = false}

}
-- add `yamlls` to `skipped_servers` list
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "yamlls" })
-- remove `ansiblels` from `skipped_servers` list
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "ansiblels"
end, lvim.lsp.automatic_configuration.skipped_servers)

-- KEYMAPS
-- add keymap for spawning terminal
lvim.builtin.which_key.mappings["t"] = {
  name = "+Terminal",
  f = { "<cmd>ToggleTerm<cr>", "Floating terminal" },
  v = { "<cmd>2ToggleTerm size=30 direction=vertical<cr>", "Split vertical" },
  h = { "<cmd>2ToggleTerm size=10 direction=horizontal<cr>", "Split horizontal" },
}
