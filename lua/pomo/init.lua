local M = {}
require("pomo.dev")
local uv = vim.uv


-- TODO: add connect, write and disconnect function
--
-- TODO: reconnection doesnt work
M.connect_to_frontend = function ()
    M.socket = uv.new_tcp()
    M.socket:connect("127.0.0.1", 42069, function(err)
        if err then
            print("error occured when connecting, is Pomo.rs running?\n" .. err)
        else
            print("connected successfully to Pomo frontend")
        end
    end)
end

M.send = function(message)

    local message_to_send = "no message provided"

    if message ~= nil then
        message_to_send = message
    end

    if message == "exit" then
        uv.close(M.socket, function ()
            M.socket = nil
        end)
        return
    end

    uv.write(M.socket, message_to_send, function(err)
        if err then
            print("error occured when writing\n" .. err)
        end
    end)
end

-- TODO: popup window for message to insert
vim.keymap.set("n", "<leader><leader>o", M.send, {})

return M
