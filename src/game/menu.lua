menu = {}

function menu:draw()
    love.graphics.setFont(gamefont)
    love.graphics.print("Press Enter to continue", 170, 400)
end

function menu:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(game)
    end
end
