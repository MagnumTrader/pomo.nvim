local M = {}
require("pomo.dev")
local uv = vim.uv

M._connected = false

-- what is it that will be open first?
-- and when we have installed this.
--
-- we can actually have a pomo command that runs the pomo timer and connects
-- to this instance
--
--
-- Pomo timer can take a optional port number to enable connections through localhost:PORT
M.connect = function()
    M.socket = uv.new_tcp()

    if M._connected then
        print ("Already connected")
        return
    end

    M.socket:connect("127.0.0.1", 42069, function(err)
        if err then
            print("error occured when connecting, is Pomo.rs running?\n" .. err)
        else
            print("connected successfully to Pomo frontend") M._connected = true
        end
    end)
end

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

M._CONNECTIONS = 0

M.listen =  function ()
    -- listen for a connection,
    -- start sending keystrokes or words or whatever on that connection
    M.server = uv.new_tcp()
    M.server:bind("127.0.0.1", 42069)
    M.server:listen(128, function (err)
        assert(not err, err)
        local client = uv.new_tcp()
        M.server:accept(client)
        client:read_start(function (err, chunk)
            if err ~= nil then
                print("error maybe dropped? do cleanup go back to listen?")
            end
            if chunk then
                print("recieved:" .. chunk)
                client:write("hello from Neovim")
            else
                print("shutting down connection")
                client:shutdown()
                client:close()
            end
        end)
    end)
    print("waiting for connections:")
end

-- TODO: popup window for message to insert
vim.keymap.set("n", "<leader><leader>o", M.send, {})

return M
