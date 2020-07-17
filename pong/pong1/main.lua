--Constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require "push"

--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]

function love.load()
   love.graphics.setDefaultFilter("nearest", "nearest") 
   push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
       fullscreen = false,
       vsync = true,
       resizable = false
   })
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end    
end

function love.draw()
    push:apply("start")

    love.graphics.printf(
        "Hello Pong!",              -- text to render
        0,                          -- starting X 
        VIRTUAL_HEIGHT / 2 - 6,      -- starting Y (halway down the screen)
        VIRTUAL_WIDTH,               -- number of pixels to center within (the entire screen)
        "center")                   -- alignment can be 'center', 'left' or 'right'

    push:apply("end")    
end