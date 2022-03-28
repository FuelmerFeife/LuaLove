function love.load()

    love.window.setMode(800, 800, {
        resizable = false
    })
    love.window.setTitle("Kuhlmanns LuaLove")

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
    highscore = 0

    impossibility = 0.08
    maxSpeed = 10

    gamefont = love.graphics.newFont(40)

end

function love.update(dt)

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
    end

    if target.radius > 0 then
        target.radius = target.radius - impossibility
        scalFactor = target.radius / 50
    else
        love.graphics.setFont(love.graphics.newFont(400))
        love.graphics.print(score, 200, 200)
        love.event.wait()

        score = 0
        target.radius = 50
    end
end

function love.draw()

    love.graphics.draw(background)

    love.graphics.draw(targetImage, target.x - target.radius, target.y - target.radius, 0, scalFactor)
    love.graphics.circle("line", target.x, target.y, target.radius)

    love.graphics.setFont(gamefont)
    love.graphics.print(score, 0, 0)

    love.graphics.setFont(gamefont)
    love.graphics.print(highscore, 60, 0)

end

function love.mousepressed(x, y, button, istouch, pressed)
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

function distanceBetween(x1, x2, y1, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

