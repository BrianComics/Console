CONSOLE_COLUMNS = 50
CONSOLE_ROWS = 50
CONSOLE_FONT_SIZE = 16

STREAMER_COUNT = 300
STREAMER_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890\"'`$%&@#.!<>[]{}+-*/\\"
STREAMER_SPEED_MIN = 3
STREAMER_SPEED_MAX = 10
STREAMER_SPEED_DIV = 10
STREAMER_TEXT_MIN = 10
STREAMER_TEXT_MAX = 30
STREAMER_TEXT_FLIPX_CHANCE = 0.5
STREAMER_TEXT_FLIPY_CHANCE = 0.5

love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setFont(love.graphics.newFont("assets/m5x7.ttf", CONSOLE_FONT_SIZE))
love.graphics.setShader(love.graphics.newShader([[
	vec2 WINDOW_SIZE = vec2(653, 800);
	int radius = 2;
	float quality = 2.5;
	
	vec4 effect (vec4 color, Image texture, vec2 textureCoordinate, vec2 screenCoordinate) {
		vec4 originalColor = Texel(texture, textureCoordinate);
		vec2 movementVector = quality / WINDOW_SIZE;
		vec4 colorSum = vec4(0, 0, 0, 0);
		
		for (int x = -radius; x <= radius; x++) {
			for (int y = -radius; y <= radius; y++) {
				vec2 offset = vec2(x, y) * movementVector;
				colorSum += Texel(texture, textureCoordinate + offset);
			}
		}
		
		return ((colorSum / (pow((radius * 2) + 1, 2))) + originalColor) * color;
	}
]]))

console = require("./libraries/console")
consoleLayer = console.layer(CONSOLE_COLUMNS, CONSOLE_ROWS, 0, CONSOLE_FONT_SIZE)

streamers = {}

function createStreamer ()
	local streamer = {}
	streamer.column = nil
	streamer.position = nil
	streamer.speed = nil
	streamer.text = nil
	return streamer
end

function prepareStreamer (streamer)
	streamer.column = love.math.random(CONSOLE_COLUMNS)
	streamer.position = -love.math.random(CONSOLE_ROWS)
	streamer.speed = love.math.random(STREAMER_SPEED_MIN, STREAMER_SPEED_MAX) / STREAMER_SPEED_DIV
	streamer.text = generateStreamerText(love.math.random(STREAMER_TEXT_MIN, STREAMER_TEXT_MAX))
end

function generateStreamerText (length)
	output = {}
	for i = 1, length do
		letterPosition = math.floor(love.math.random(string.len(STREAMER_CHARACTERS)))
		table.insert(output, console.character(string.sub(STREAMER_CHARACTERS, letterPosition, letterPosition), {0, 0, 0, 0}, love.math.random() < STREAMER_TEXT_FLIPX_CHANCE, love.math.random() < STREAMER_TEXT_FLIPY_CHANCE))
	end
	return output
end

for i = 1, STREAMER_COUNT do
	streamer = createStreamer()
	prepareStreamer(streamer)
	table.insert(streamers, streamer)
end

function love.update (deltaTime)
	consoleLayer:clear()
	for _, streamer in pairs(streamers) do
		for i = 1, #streamer.text do
			if streamer.position - #streamer.text > CONSOLE_ROWS then
				prepareStreamer(streamer)
			end

			fade = math.max(0, 1 - ((1 / #streamer.text) * (i + 1)))

			color = {0, 0, 0}
			if i == 1 then
				color = {(200 * fade) / 255, (200 * fade) / 255, (200 * fade) / 255}
			elseif streamer.speed > 0.75 then
				color = {0, (255 * fade) / 255, (65 * fade) / 255}
			elseif streamer.speed > 0.5 then
				color = {0, (145 * fade) / 255, (20 * fade) / 255}
			else
				color = {0, (60 * fade) / 255, 0}
			end

			letter = streamer.text[((i - math.floor(streamer.position)) % #streamer.text) + 1]
			letter.color = color
			consoleLayer:setCharacter(letter, streamer.column, math.floor(streamer.position) - i)
			streamer.position = streamer.position + (streamer.speed * deltaTime)
		end
	end
end

function love.draw ()
	consoleLayer:draw()
end
