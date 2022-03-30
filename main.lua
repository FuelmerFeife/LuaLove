Gamestate = require 'libraries.gamestate'
local menu = {}
local game = {}
local pause = {}

function love.load()
    Gamestate.registerEvents()
    anim8 = require 'libraries/anim8'

    love.window.setMode(800, 800, {
        resizable = false
    })
    love.window.setTitle("LuaLove")

    gamefont = love.graphics.newFont(40)

    if love.filesystem.read("data.sav") == nil then
        highscore = 0
        love.filesystem.write("data.sav", highscore)
    else
        highscore = love.filesystem.read("data.sav")
    end

    Gamestate.switch(menu)
end

function menu:draw()
    love.graphics.setFont(gamefont)
    love.graphics.print("Press Enter to continue", 170, 400)
end

function menu:keyreleased(key, code)
    if key == 'return' then
        Gamestate.switch(game)
    end
end

function game:enter()

    background = love.graphics.newImage("assets/background.png")
    targetImage = love.graphics.newImage("assets/target.png")

    shootSound = love.audio.newSource("sounds/laserShoot.wav", "stream")
    hitSound = love.audio.newSource("sounds/hit.wav", "stream")
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50

    moveX = math.random(-5, 5)
    moveY = math.random(-5, 5)
    scalFactor = 1

    score = 0
    highscore = love.filesystem.read("data.sav")
    highscore = tonumber(highscore)

    impossibility = 0.08
    maxSpeed = 10

    pauseTimer = 0

end

function game:update(dt)

    if (target.x - target.radius) < 0 and moveX < 0 then
        moveX = moveX * (-1)
    end

    if (target.x + target.radius) > 800 and moveX > 0 then
        moveX = moveX * (-1)
    end

    if (target.y - target.radius) < 0 and moveY < 0 then
        moveY = moveY * (-1)
    end

    if (target.y + target.radius) > 700 and moveY > 0 then
        moveY = moveY * (-1)
    end

    target.x = target.x + moveX
    target.y = target.y + moveY

    if score > highscore then
        highscore = score
        love.filesystem.write("data.sav", highscore)
    end

    if target.radius > 0 then
        target.radius = target.radius - impossibility
        scalFactor = target.radius / 50
    else
        love.filesystem.write("data.sav", highscore)
        Gamestate.switch(menu)
    end
end

function game:draw()
    love.graphics.draw(background)

    love.graphics.draw(targetImage, target.x - target.radius, target.y - target.radius, 0, scalFactor)
    love.graphics.circle("line", target.x, target.y, target.radius)

    love.graphics.setFont(gamefont)
    love.graphics.print(score, 0, 0)
    love.graphics.print(highscore, 60, 0)
end

function game:mousepressed(x, y, button, istouch, pressed)
    if button == 1 then
        love.audio.play(shootSound)
        local mousToTarget = distanceBetween(x, target.x, y, target.y)
        if mousToTarget < target.radius then
            love.audio.play(hitSound)
            score = score + 1

            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - (target.radius + 100))

            moveX = math.random(-(maxSpeed), maxSpeed)
            moveY = math.random(-(maxSpeed), maxSpeed)

            if (target.radius * 2) < 50 then
                target.radius = target.radius + target.radius
            else
                target.radius = 50
            end

        end

    end
end

function game:keypressed(key)
    if key == 'p' then
        Gamestate.push(pause)
    end
    if key == 'escape' then
        love.event.quit()
    end
end

function pause:enter(from)
    self.from = from -- record previous state
end

function pause:draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    self.from:draw()

    -- overlay with pause message
    love.graphics.setColor(0, 0, 0, 100)
    love.graphics.rectangle('fill', 0, 0, w, h)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf('PAUSE', 0, h / 2, w, 'center')
end

function pause:update(dt)
    -- pauseTimer starts ticking
    pauseTimer = pauseTimer + dt

    -- wait a moment before checking agian if 'p' is pressed
    if love.keyboard.isScancodeDown('p') and pauseTimer > 0.3 then
        -- reset timer
        pauseTimer = 0
        -- remove pause gamestate from the stack
        return Gamestate.pop()
    end
end

function distanceBetween(x1, x2, y1, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

