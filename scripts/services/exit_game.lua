local function exit_game(key)
    -- Exit game using esc
    if key == "escape" then
        local title = "Exit the game?"
        local message = "Do you really want to exit the game?"
        local buttons = {
            "Restart",
            "No",
            "Yes",
            escapebutton = 2
        }
        local exitGame = love.window.showMessageBox(title, message, buttons)
        if exitGame == 3 then
            love.event.quit()
        elseif exitGame == 1 then
            love.event.quit("restart")
        end
    end
end

return exit_game