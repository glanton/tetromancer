--[[
	Tetromancer

	Alex Friberg

	Created:		12.01.20
	Last Updated:	12.10.20
]]

Tile = Class{}

function Tile:init(xTile, yTile, id)
	-- Pyxel Edit tile maps start at 0
	self.id = id + 1

	-- the tile positions of the tile (starts at 1)
	self.xTile = xTile
	self.yTile = yTile

	-- the virtual pixel positions of the tile (starts at 1)
	self.x = (xTile * TILE_SIZE) - TILE_SIZE + 0
	self.y = (yTile * TILE_SIZE) - TILE_SIZE + 0 + TILE_Y_OFFSET

	
	self.type = TILE_DATA[self.id].type

	-- most game objects cannot travel through collidable tiles
	self.collidable = TILE_DATA[self.id].collidable

	-- projectiles can travel across holes
	self.hole = TILE_DATA[self.id].hole or false

	-- alternate quad id, used dynamic tiles, shift Pyxel Edit id by 1 for Lua
	local pyxelAltId = TILE_DATA[self.id].pyxelAltId
	if pyxelAltId then
		self.altId = pyxelAltId + 1
	end
	
	self.altActive = false
end


--[[
	Returns a clone of the Tile, with options to shift its x and y tile positions.
]]
function Tile:clone(shiftX, shiftY)
	local xTile = self.xTile + (shiftX or 0)
	local yTile = self.yTile + (shiftY or 0)

	return Tile(xTile, yTile, self.name, self.orientation)
end


function Tile:render()
	-- check whether to use the normal quad or alternate quad
	local id = self.id
	if self.altActive then
		id = self.altId
	end

	love.graphics.draw(gTextures["tiles"], gFrames["tiles"][id], self.x, self.y)
end