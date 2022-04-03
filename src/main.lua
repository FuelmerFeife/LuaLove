require('game.menu')
require('game.pause')
require('game.game')

function love.load()
    anim8 = require 'libraries/anim8'
    gamestate = require('libraries.gamestate')
    curser, cursorGame = love.mouse.getSystemCursor("arrow"), love.mouse.newCursor("/media/img/curser.png", 0, 0)
    gamefont, gamefont2 = love.graphics.newFont(40), love.graphics.newFont(30)
    backgroundPause = love.graphics.newImage("/media/img/backgroundSW.png")
    w, h = love.graphics.getWidth(), love.graphics.getHeight()

    love.graphics.setDefaultFilter("nearest", "nearest")
    gamestate.registerEvents()

    love.window.setTitle("LuaLove")
    love.window.setMode(800, 800, {
        resizable = false
    })

    if love.filesystem.read("data.sav") == nil then
        highscore = 0
        love.filesystem.write("data.sav", highscore)
    else
        highscore = love.filesystem.read("data.sav")
    end

    gamestate.switch(menu)
end
