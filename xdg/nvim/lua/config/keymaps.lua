-- Add your custom LSP keymaps from lsp-config.lua
vim.keymap.set("n", "G", vim.lsp.buf.definition, { silent = true, desc = "Go to definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true, desc = "Hover documentation" })
vim.keymap.set("n", "I", vim.lsp.buf.implementation, { silent = true, desc = "Go to implementation" })
vim.keymap.set("n", "R", vim.lsp.buf.rename, { silent = true, desc = "Rename symbol" })
vim.keymap.set("n", "C", vim.lsp.buf.code_action, { silent = true, desc = "Code action" })

-- Half page jump with centering
vim.keymap.set("n", "<C-j>", "<C-d>zz", { silent = true, desc = "Move half page down and center" })
vim.keymap.set("n", "<C-k>", "<C-u>zz", { silent = true, desc = "Move half page up and center" })
