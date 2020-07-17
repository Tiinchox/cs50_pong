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

   -- New font
   smallFont = love.graphics.newFont("04B_03__.ttf", 8) -- name of the font file and size of the font
   love.graphics.setFont(smallFont)

   -- Initialize our virtual resolution
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
    -- start rendering virtual resolution
    push:apply("start")

    -- change background color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) -- map the 0-255 values to 0-1 so we divide by 255

    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    love.graphics.rectangle('fill', 5, 20, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 20)

    -- text placement
    love.graphics.printf(
        "Hello Pong!",              -- text to render
        0,                          -- starting X 
        20,                         -- in pixels
        VIRTUAL_WIDTH,              -- number of pixels to center within (the entire screen)
        "center")                   -- alignment can be 'center', 'left' or 'right'

    push:apply("end")    
end