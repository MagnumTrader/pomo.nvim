local M = {}
require("pomo.dev")
local uv = vim.uv


-- i want to calculate when i start going into insert mode.
-- and then record the inputs
-- and the stop time?
--
-- i will parse it in rust

M._connected = false

-- what is it that will be open first?
-- and when we have installed this.
--
-- we can actually have a pomo command that runs the pomo timer and connects
-- to this instance
--
--
-- Pomo timer can take a optional port number to enable connections through localhost:PORT
-- TODO: we can actually have a connect and start the application here
--
--
--

M.connect = function()
    M.socket = uv.new_tcp()

    --TODO: this doesnt account for if the server shutdown
    local port = 42069
    M.socket:connect("127.0.0.1", port, function(err)
        if err then
            print("Error occured when trying to connect, is Pomo.rs running and have port " .. port .. " available? " .. err)
        else
            print("connected successfully to Pomo frontend")
            M._connected = true
        end
    end)
end

--M.socket:read_start(function (err, data)
--    if err ~= nil then
--        print("some error occured: " .. err)
--    end
--
--    print(data)
--end)

M.send = function(message)

    if not M._connected then
        print("Not connected to front end!")
        return
    end

    if message == nil then
        print "You need to provide a message"
        return
    end

    if message == "exit" then
        uv.close(M.socket, function()
            M.socket = nil
        end)
        return
    end

    uv.write(M.socket, message, function(err)
        if err then
            print("error occured when writing\n" .. err)
        end
    end)
end

vim.keymap.set("n", "<leader><leader>o", function ()
    vim.ui.input({prompt = "write the message"}, function (input)
        require("pomo").send(input)
    end)
end)

return M
