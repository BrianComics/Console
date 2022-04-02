local Console = {}
Console.__index = Console

function Console.character (glyph, color, flipX, flipY)
	local character = {}
	character.glyph = glyph
	character.color = color or {1, 1, 1, 1}
	character.flipX = flipX or false
	character.flipY = flipY or false
	return character
end

function Console.layer (width, height, margin, fontSize)
	local layer = {
		buffer = {},
		width = width,
		height = height,
		margin = margin,
		fontHeight = fontSize,
		fontWidth = math.floor(fontSize * (5 / 6)),
		draw = function (self)
			for index, character in pairs(self.buffer) do
				y = math.floor(index / self.width)
				x = index - (self.width * y)
				flipX = 1
				flipY = 1
				offsetX = 0
				offsetY = 0
				if character.flipX then
					flipX = -1
					offsetX = self.fontWidth / 2
				end
				if character.flipY then
					flipY = -1
					offsetY = self.fontHeight
				end
				love.graphics.setColor(character.color)
				love.graphics.print(character.glyph, (x * (self.fontWidth + self.margin)) + (self.fontWidth / 4), y * (self.fontHeight + self.margin), 0, flipX, flipY, offsetX, offsetY)
			end
		end,
		clear = function (self)
			for i = 0, (self.width * self.height) - 1 do
				self.buffer[i] = console.character(" ")
			end
		end,
		setCharacter = function (self, character, x, y)
			self.buffer[(y * self.width) + x] = character
		end
	}
	layer:clear()
	return layer
end

return Console
