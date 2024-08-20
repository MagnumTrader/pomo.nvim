-- here i store my stuff
local plenary = require("plenary.reload")
vim.keymap.set("n", "<leader><leader>p", function()
    vim.cmd(":w")
    plenary.reload_module("pomo")
    return require("pomo")
end)
