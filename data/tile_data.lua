--[[
	Tetromancer

	Alex Friberg
	
	Created:		12.01.20
	Last Updated:	12.10.20
]]

-- reminder: these Lua ids are shifted +1 compared with their Pyxel Edit ids
TILE_DATA = {
	{
		pyxelId = 0,
		type = "corner",
		collidable = true
	},
	{
		pyxelId = 1,
		type = "topper",
		collidable = true
	},
	{
		pyxelId = 2,
		type = "corner",
		collidable = true
	},
	{
		pyxelId = 3,
		type = "wall",
		collidable = true
	},
	{
		pyxelId = 4,
		type = "alt base",
		collidable = false
	},
	{
		pyxelId = 5,
		type = "hole",
		collidable = true
	},
	{
		pyxelId = 6,
		type = "column",
		collidable = true
	},
	{
		pyxelId = 7,
		type = "wall",
		collidable = true
	},
	{
		pyxelId = 8,
		type = "topper",
		collidable = true
	},
	{
		pyxelId = 9,
		type = "hole",
		collidable = true,
		hole = true
	},
	{
		pyxelId = 10,
		type = "topper",
		collidable = true
	},
	{
		pyxelId = 11,
		type = "base",
		collidable = false,
		pyxelAltId = 4
	},
	{
		pyxelId = 12,
		type = "corner",
		collidable = true
	},
	{
		pyxelId = 13,
		type = "wall",
		collidable = true
	},
	{
		pyxelId = 14,
		type = "wall",
		collidable = true
	},
	{
		pyxelId = 15,
		type = "base",
		collidable = false
	},
	{
		pyxelId = 16,
		type = "corner",
		collidable = true
	},
	{
		pyxelId = 17,
		type = "topper",
		collidable = true
	},
	{
		pyxelId = 18,
		type = "corner",
		collidable = true
	},
	{
		pyxelId = 19,
		type = "hole",
		collidable = true,
		hole = true
	},
	{
		pyxelId = 20,
		type = "hole",
		collidable = true,
		hole = true
	},
	{
		pyxelId = 21,
		type = "corner",
		collidable = true
	},
	{
		pyxelId = 22,
		type = "corner",
		collidable = true
	},
	{
		pyxelId = 23,
		type = "corner",
		collidable = true
	},
}