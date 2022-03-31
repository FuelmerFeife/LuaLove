Gamestate = require('libraries.gamestate')
require('game.menu')
require('game.pause')
require('game.game')

function love.load()
    Gamestate.registerEvents()
    anim8 = require 'libraries/anim8'
    cursor = love.mouse.newCursor("/media/img/curser.png", 0, 0)
    love.mouse.setCursor(cursor)
    gamefont = love.graphics.newFont(40)

    love.window.setMode(800, 800, {
        resizable = false
    })
    love.window.setTitle("LuaLove")

    if love.filesystem.read("data.sav") == nil then
        highscore = 0
        love.filesystem.write("data.sav", highscore)
    else
        highscore = love.filesystem.read("data.sav")
    end

    Gamestate.switch(menu)
end
