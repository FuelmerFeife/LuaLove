menu = {}

function menu:draw()
    love.mouse.setCursor(cursor)
    love.graphics.draw(backgroundPause)
    love.graphics.setFont(gamefont)
    love.graphics.printf("Press enter if you like fun!", 0, (h / 2) + 25, w, 'center')
    love.graphics.setFont(gamefont2)
    love.graphics.printf("Current highscore is " .. tostring(highscore), 0, (h / 2) + 75, w, 'center')
end

function menu:keyreleased(key, code)
    if key == 'return' then
        gamestate.switch(game)
    end
end

function menu:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end
