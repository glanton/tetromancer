--[[
	constants

	Alex Friberg

	Created:		11.28.20
	Last Updated:	12.10.20
]]

-- set to true to activate debug settings, like rendering hitboxes
DEBUG = false

MIN_FPS = 1/30

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1152
WINDOW_HEIGHT = 648

TILE_SIZE = 16
TILE_Y_OFFSET = 8

ROW_COUNT = (VIRTUAL_HEIGHT - TILE_Y_OFFSET) / TILE_SIZE
COLUMN_COUNT = VIRTUAL_WIDTH / TILE_SIZE

-- where to begin drawing the player's health
HEALTH_X = 20
HEALTH_Y = 2

-- where to print the interface text
INTERFACE_TEXT_Y = 6
SCORE_TEXT_X = 280
MULT_TEXT_X = 340

ENTITY_SIZE = 16

-- offset so that tiles light based on the position of the player's feet
PLAYER_CENTER_Y_OFFSET = 5

-- offset to all entities to center their collision lower on their body
ENTITY_Y_OFFSET = 2

-- offset to all projectiles to center to where hitboxes created from body
PROJECTILE_Y_OFFSET = 5

-- offset for abilities that use larger 48 x 48 frames
ABILITY_X_OFFSET = 16
ABILITY_Y_OFFSET = 16

-- the game's color palette
COLORS = {
	["darkest"] 	= {  0/255,		 43/255,	 89/255},
	["dark"] 		= {  0/255,  	 95/255,	140/255},
	["light"] 		= {  0/255, 	185/255,	190/255},
	["lightest"] 	= {159/255, 	244/255,	229/255},
	["reset-white"]	= {255/255,		255/255,	255/255},
	["debug-red"]	= {255/255,		  0/255,	  0/255},
	["debug-green"]	= {  0/255,		255/255,	  0/255}
}

START_LEVEL = 1

PLAYER_START_X = math.floor(VIRTUAL_WIDTH / 2)
PLAYER_START_Y = math.floor(TILE_Y_OFFSET + ((VIRTUAL_HEIGHT - TILE_Y_OFFSET) / 2))

-- a restricted area around the player where enemies are not allowed to spawn
SAFE_START_RADIUS = 4 * TILE_SIZE

-- rotation orientation in radians
ORIENTATION = {
	["0 deg"] = 0,
	["90 deg"] = math.pi * 1/2,
	["180 deg"] = math.pi,
	["270 deg"] = math.pi * 3/2
}

-- approximation of Euler's number
EULERS = 2.7182818284

-- maximum difficulty score of a level (controls how many of which enemies)
MAX_D = 50

-- growth rate for the logistic difficulty function
D_GROWTH = 0.15

-- the level at which the difficulty is halfway to the maximum
D_MIDPOINT = 20

-- the maximum score multiplier
MAX_MULTIPLIER = 8

-- exponential base used in determining the score needed to increase multiplier
M_BASE = 2

-- index any enemies from the entity data table by key
ENEMY_LIST = {}
for i, entity in pairs(ENTITY_DATA) do
	if entity.type == "enemy" then
		table.insert(ENEMY_LIST, entity.name)
	end
end

NEXT_LEVEL_DELAY = 2
GAME_OVER_DELAY = 5