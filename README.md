# Console
This is Console, a simplistic library for the Love2D game framework for creating “console layers”. These console layers are similar to the existing canvases, but instead of pixels, you use text to create use text instead of pixels, allowing you to easily create ASCII games or add monospaced text overlays. In the demo above, I recreated the Matrix Rain effect from the Matrix movies. You can have a quick look through it to get the basic idea of the library.

In case my messy demo code doesn't help you understand, though, here is a short tutorial on the library. We will start with this base Love2D project. The first two lines simply turns off antialiasing and sets the default font to a cool font I found called `m5x7`. You can find the font in the demo files above.
```lua
love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setFont(love.graphics.newFont("assets/m5x7.ttf", 16))

function love.draw ()
    -- Write code here!
end
```
To get started, import the Console library and create a console layer. Then, call the `draw` method in `love.draw`. Here, I have created a simple 50 by 50 console layer for 16 pixel fonts with less margin ( 3 pixels less to be exact ).
```lua
love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setFont(love.graphics.newFont("assets/m5x7.ttf", 16))

console = require("./libraries/console")
consoleLayer = console.layer(50, 50, -3, 16)

function love.draw ()
    consoleLayer:draw()
end
```
Now, you're ready to start using the layer! Before you do anything, you need to learn about `character`s. `character`s represent a character in the console and contain just a glyph ( just letters ), a color, and two booleans determining whether the `character` should be flipped when drawn. To create a `character`, use the method `console.character(glyph, color, flipX, flipY)`. For example, `console.character("A", {1, 0, 0, 1}, false, true)` will return a `character` representing a red upside-down A.

After you've created a `character`, you can draw it to your console layer using `consoleLayer:setCharacter`! In the example below, we will draw the red A from the last paragraph to the console, one unit from the top and one unit from the left. If you run the project now, you should see an upside-down red A! Congratulations!
```lua
love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setFont(love.graphics.newFont("assets/m5x7.ttf", 16))

console = require("./libraries/console")
consoleLayer = console.layer(50, 50, -3, 16)

consoleLayer:setCharacter(console.character("A", {1, 0, 0, 1}, false, true), 1, 1)

function love.draw ()
    consoleLayer:draw()
end
```
