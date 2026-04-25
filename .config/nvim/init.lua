require("config.lazy")
require("current-theme")
require("utils")
vim.opt.clipboard = "unnamedplus"
vim.keymap.set("n","-","<cmd>Oil<CR>")
vim.keymap.set("n","<C-d>","<C-d>zz")
vim.keymap.set("n","<C-u>","<C-u>zz")
