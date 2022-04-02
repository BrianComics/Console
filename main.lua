love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setFont(love.graphics.newFont("assets/m5x7.ttf", 16))

console = require("./libraries/console")
consoleLayer = console.layer(50, 50, -3, 16)

COLUMNS = 50
ROWS = 50

streamers = {}
streamerCount = 300

function createStreamer ()
	local streamer = {}
	streamer.column = nil
	streamer.position = nil
	streamer.speed = nil
	streamer.text = nil
	return streamer
end

function prepareStreamer (streamer)
	streamer.column = love.math.random(COLUMNS)
	streamer.position = -love.math.random(ROWS)
	streamer.speed = love.math.random(3, 10) / 10
	streamer.text = generateStreamerText(love.math.random(10, 30))
end

function generateStreamerText (length)
	output = {}
	possibleCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"
	for i = 1, length do
		letterPosition = math.floor(love.math.random(string.len(possibleCharacters)))
		table.insert(output, console.character(string.sub(possibleCharacters, letterPosition, letterPosition), {0, 0, 0, 0}, love.math.random() < 0.5, love.math.random() < 0.5))
	end
	return output
end

for i = 1, streamerCount do
	streamer = createStreamer()
	prepareStreamer(streamer)
	table.insert(streamers, streamer)
end

function love.update (deltaTime)
	consoleLayer:clear()
	for _, streamer in pairs(streamers) do
		for i = 1, #streamer.text do
			if streamer.position - #streamer.text > ROWS then
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
