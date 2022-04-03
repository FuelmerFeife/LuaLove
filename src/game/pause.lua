pause = {}

function pause:draw()
    love.graphics.draw(backgroundPause)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf('PAUSE', 0, h / 2, w, 'center')
end

function pause:update(dt)
    -- pauseTimer starts ticking
    pauseTimer = pauseTimer + dt
    love.mouse.setCursor(cursor)

    -- wait a moment before checking agian if 'p' is pressedA
    if love.keyboard.isScancodeDown('p') and pauseTimer > 0.3 then
        -- reset timer
        pauseTimer = 0
        -- remove pause gamestate from the stack
        return gamestate.pop()
    end
end

