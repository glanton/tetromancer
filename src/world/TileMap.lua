--[[
	Tetromancer

	Alex Friberg

	Created:		12.01.20
	Last Updated:	12.01.20
]]

TileMap = Class{}

function TileMap:init(tiles)
	self.tiles = tiles
end


function TileMap:render()
	for y, row in ipairs(self.tiles) do
		for x, tile in ipairs(row) do
			tile:render()
		end
	end
end