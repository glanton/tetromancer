--[[
	Tetromancer

	Alex Friberg

	Created:		12.01.20
	Last Updated:	12.10.20
]]

Level = Class{}

function Level:init(game, player, floor)
	-- display the level transition screen with the floor number
	gStateStack:push(NextLevelState(floor))

	-- relationship to the game state
	self.game = game

	-- entities and projectiles
	self.gameObjects = {}

	-- projectiles fired by the player or enemies
	self.projectiles = {}

	-- player and enemies
	self.entities = {}

	-- store the player and move them into this level
	self.player = player
	player:setLevel(self)
	player:setPosition(PLAYER_START_X, PLAYER_START_Y)
	table.insert(self.entities, player)
	table.insert(self.gameObjects, player)

	-- reset player tetromino cooldown and tiles
	player:resetTetrominos()

	-- the level's number; the game is assumed to start at 1 for tuning purposes
	self.floor = floor

	-- build the level
	self.tileMap = self:generateRandomTileMap()

	-- set the player's starting tile
	player.currentTile = player:getTile()

	-- calculate the level's difficulty based on its floor number
	self.difficulty = self:calculateDifficulty()

	-- randomly generate enemies around the level based on difficulty
	self.enemies = {}
	self:generateEnemies()

	-- used to indicate that the level is complete and advancing
	self.nextLevel = false

	-- used to set the delay between player death and the game over screen
	self.gameOver = false
end


--[[
	Choose an existing map of tiles at random from data and generate it as tiles
	into a TileMap, which is returned.
]]
function Level:generateRandomTileMap()
	-- pick a random map
	local randomMap = MAP_DATA[math.random(1, #MAP_DATA)]

	-- generate tiles based on the map
	local tiles = {}
	for y = 1, ROW_COUNT do
		local row = {}
		for x = 1, COLUMN_COUNT do
			table.insert(row, Tile(x, y, randomMap[y][x]))
		end

		table.insert(tiles, row)
	end

	return TileMap(tiles)
end


--[[
	A deprecated function that returns the base map. Originally intended to be
	expanded into a function that would dynamically generate different types of
	match features. The current direction can be seen in generateRandomTileMap,
	which ingests a hand-created map of tiles from data. This sacrifices the
	random variability of the original vision, but gains speed of deployment,
	reduced complexity, and full aesthetic control. Kept in the code base in the
	event this approach merits further exploration in the future.
]]
function Level:generateTileMap()
	local tiles = {}

	-- generate and save the top row
	local leftTile = Tile(1, 1, "corner")
	local innerTile = Tile(2, 1, "topper")
	local rightTile = Tile(COLUMN_COUNT, 1, "corner", "90 deg")
	local row = self:generateTileSandwich(leftTile, innerTile, rightTile, COLUMN_COUNT)
	table.insert(tiles, row)

	-- generate and save the second row
	leftTile = Tile(1, 2, "topper", "270 deg")
	innerTile = Tile(2, 2, "wall")
	rightTile = Tile(COLUMN_COUNT, 2, "topper", "90 deg")
	row = self:generateTileSandwich(leftTile, innerTile, rightTile, COLUMN_COUNT)
	table.insert(tiles, row)

	-- generate and save the middle rows
	for y = 3, ROW_COUNT - 1 do
		leftTile = Tile(1, y, "topper", "270 deg")
		innerTile = Tile(2, y, "base")
		rightTile = Tile(COLUMN_COUNT, y, "topper", "90 deg")
		row = self:generateTileSandwich(leftTile, innerTile, rightTile, COLUMN_COUNT)
		table.insert(tiles, row)
	end

	-- generate and save the bottom row
	leftTile = Tile(1, ROW_COUNT, "corner", "270 deg")
	innerTile = Tile(2, ROW_COUNT, "topper", "180 deg")
	rightTile = Tile(COLUMN_COUNT, ROW_COUNT, "corner", "180 deg")
	row = self:generateTileSandwich(leftTile, innerTile, rightTile, COLUMN_COUNT)
	table.insert(tiles, row)

	return TileMap(tiles)
end


--[[
	Deprecated: See generateTileMap comments for additional information.

	Generates the most basic type of row for level tiles, a sandwich. This row
	is composed of a single tile of one type on the far left, a specified number
	of inner tiles of another type, and a single tile of another type on the far
	right. Assumes that size is at least 3 and that the provided tiles are
	positioned correctly.
]]
function Level:generateTileSandwich(leftTile, innerTile, rightTile, size)
	row = {}

	table.insert(row, leftTile)

	for x = 1, size - 2 do
		local shiftX = x - 1
		local clonedTile = innerTile:clone(shiftX)
		table.insert(row, clonedTile)
	end

	table.insert(row, rightTile)

	return row
end


--[[
	Returns the tile located at the provided pixel postion, account for the y
	offset (a result of the 16:9 resolution ratio and space needed for
	information at the top of the screen).
]]
function Level:getTileByPixelPos(x, y)
	local xTile = math.ceil(x / TILE_SIZE)
	local yTile = math.ceil((y - TILE_Y_OFFSET) / TILE_SIZE)

	return self.tileMap.tiles[yTile][xTile]
end


--[[
	Calculate the current level's difficulty using a logistic function that starts
	slow, then ramps up quickly, before tapering off towards a maximum level
	difficulty. MAX_D is max difficulty, EULERS is an approximation of Euler's
	number, D_GROWTH is the growth rate of the difficulty function, and D_MIDPOINT
	is the level at which difficulty is halfway to is max (where the rate of
	difficutly increase starts slowing).
]]
function Level:calculateDifficulty()
	local difficulty =  MAX_D / (1 + (EULERS ^ (-D_GROWTH * (self.floor - D_MIDPOINT))))

	return math.ceil(difficulty)
end


function Level:calculateDistance(x1, y1, x2, y2)
	local a = x1 - x2
	local b = y1 - y2

	return math.sqrt(a ^ 2 + b ^ 2)
end


--[[
	Tries to set the location of the specified enemy to a valid spawn location
	that meets the following criteria:

		1) it does not overlap with an collidable tiles
		2) it does not overlap with the player's safe spawn radius
		3) it does not overalp with any other entities

	Returns true if successful; otherwise false.
]]
function Level:isEnemySpawnLocationSet(enemy)
	-- randomly choose an x and y within the outer tile walls
	local x = math.random(1 + TILE_SIZE, VIRTUAL_WIDTH - TILE_SIZE)
	local y = math.random(1 + TILE_SIZE, VIRTUAL_HEIGHT - TILE_SIZE)

	-- check that the location is not within the player's safe start area
	local playerDistance = self:calculateDistance(x, y, self.player.x, self.player.y)
	if playerDistance < SAFE_START_RADIUS then
		return false
	end

	-- center the enemy on the location
	enemy:setPosition(x - (TILE_SIZE / 2), y - (TILE_SIZE / 2))

	-- confirm that the location is not a collidable tile
	if enemy:isTileColliding() then
		return false
	end

	-- confirm that the location does not overlap with existing enemies
	if enemy:isEntityColliding() then
		return false
	end

	-- all checks succeeded; return true
	return true
end


--[[
	Picks a random enemy definition from the entity data table.
]]
function Level:pickRandomEnemy()
	local enemyName = ENEMY_LIST[math.random(1, #ENEMY_LIST)]

	return ENTITY_DATA[enemyName]
end


--[[
	Fill the level with enemies until the level's difficulty score is matched.
	Assumes that at least one enemy type has a score of 1 so that the function
	does not get caught in an infinite loop.
]]
function Level:generateEnemies()
	local remainingDifficulty = self.difficulty

	-- place enemies until the level's difficulty score is met
	repeat
		local randomEnemy = self:pickRandomEnemy()

		-- confirm there is enough remaining difficulty for this enemy type
		if randomEnemy.difficulty_score <= remainingDifficulty then
			-- create the enemy and associate it to the level and vice versa
			local enemy = Enemy(randomEnemy.name)
			enemy:setLevel(self)
			table.insert(self.enemies, enemy)
			table.insert(self.entities, enemy)
			table.insert(self.gameObjects, enemy)
			
			-- try spawn locations until a valid one is found
			repeat until(self:isEnemySpawnLocationSet(enemy))

			-- update remaining difficulty score
			remainingDifficulty = remainingDifficulty - randomEnemy.difficulty_score
		end
	until(remainingDifficulty <= 0)
end


--[[
	Create a new projectile, launching it based on the direction and location of
	the casting entity and the provided ability definition.
]]
function Level:launchProjectile(parent, def)
	-- create the projectile and associate it to the level and vice versa
	local projectile = Projectile(parent, def)
	projectile:setLevel(self)
	table.insert(self.projectiles, projectile)
	table.insert(self.gameObjects, projectile)
end


function Level:update(dt)
	local expiredEnemies = 0

	-- update all game objects
	for i, gameObject in ipairs(self.gameObjects) do
		-- only update game objects that are not expired
		if not gameObject:isExpired() then
			gameObject:update(dt)
		else
			-- count how many enemies have died
			if gameObject.type == "enemy" then
				expiredEnemies = expiredEnemies + 1
			end
		end
	end

	-- if player dies return the title screen
	if self.player:isExpired() and not self.gameOver then
		self.gameOver = true

		Timer.after(GAME_OVER_DELAY, function()
			gStateStack:push(GameOverState())
		end)
	end

	-- if all enemies die continue to next level
	if expiredEnemies >= #self.enemies and self.nextLevel == false then
		self.nextLevel = true
		Timer.after(NEXT_LEVEL_DELAY, function()
			self.game:nextLevel(self.floor + 1)
		end)	
	end
end


function Level:render()
	-- reset color
	love.graphics.setColor(COLORS["reset-white"])

	self.tileMap:render()

	-- render game objects sorted by y position ascending for proper overlap
	local orderByY = function(t, a, b) return t[a].y < t[b].y end
	for k, gameObject in spairs(self.gameObjects, orderByY) do
		-- only render game objects that are not expired
		if not gameObject:isExpired() then
			gameObject:render()
		end
	end
end