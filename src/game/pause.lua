pause = {}

function pause:draw()
    love.graphics.draw(backgroundPause)
    love.graphics.printf('PAUSE', 0, h / 2, w, 'center')
end

function pause:update(dt)
    -- pauseTimer starts ticking
    pauseTimer = pauseTimer + dt
end

function pause:keypressed(key)
    -- wait a moment before checking agian if 'p' is pressedA
    if key == 'p' and pauseTimer > 0.3 then
        -- reset timer
        pauseTimer = 0
        -- remove pause gamestate from the stack
        love.mouse.setCursor(cursorGame)
        return gamestate.pop()
    end
end
