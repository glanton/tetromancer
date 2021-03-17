--[[
	Tetromancer

	Alex Friberg

	Created:		11.29.20
	Last Updated:	12.10.20
]]

Player = Class{__includes = Entity}

function Player:init()
	self.currentTile = {}
	self.lastFourTiles = {}

	self.invulnerable = false
	self.blinking = false

	Entity.init(self, ENTITY_DATA["player"])
end


function Player:getTile()
	local xCenter = self.x + (self.width / 2)
	local yCenter = self.y + PLAYER_CENTER_Y_OFFSET

	return self.level:getTileByPixelPos(xCenter, yCenter)
end


function Player:updateLastFourTiles(newTile)
	-- update and activate the current tile
	self.currentTile = newTile
	newTile.altActive = true

	-- update the ordered list of the last four tiles
	table.insert(self.lastFourTiles, newTile)
	if #self.lastFourTiles > 4 then
		-- if the tile is already on the list then remove the earlier instance
		for i = (#self.lastFourTiles - 1), 1, -1 do
			if self.lastFourTiles[i] == newTile then
				table.remove(self.lastFourTiles, i)
				return
			end
		end

		-- otherwise just deactivate and remove the oldest tile on the list
		self.lastFourTiles[1].altActive = false
		table.remove(self.lastFourTiles, 1)
	end
end


--[[
	Returns a 4 x 4 tetromino grid where each element is set to 0.
]]
function Player:createTetrominoGrid()
	local grid = {}
	for i = 1, 4 do
		table.insert(grid, {0, 0, 0, 0})
	end

	return grid
end


--[[
	Normalizes the tetromino formed by the last four tiles onto a 4 x 4 grid
	and compares it against a master list of possible tetrominos to return its
	identity.
]]
function Player:identifyTetromino()
	if #self.lastFourTiles ~= 4 then
		return "error: cannot identify tetromino: invalid list size"
	else
		-- find tile with smallest x and y
		local xSmallest = self.lastFourTiles[1].xTile
		local ySmallest = self.lastFourTiles[1].yTile
		for i, tile in ipairs(self.lastFourTiles) do
			if tile.xTile < xSmallest then
				xSmallest = tile.xTile
			end

			if tile.yTile < ySmallest then
				ySmallest = tile.yTile
			end
		end

		-- calculate the x and y shift needed to move the smallest tiles to 1
		local xShift = xSmallest - 1
		local yShift = ySmallest - 1

		-- ouput shifted tile positions onto 4 x 4 tetromino grid
		local grid = self:createTetrominoGrid()
		for i, tile in ipairs(self.lastFourTiles) do
			grid[tile.yTile - yShift][tile.xTile - xShift] = 1
		end

		-- check against the list of tetrominos
		for k, tetromino in pairs(TETROMINOS) do
			for y = 1, 4 do
				for x = 1, 4 do
					if grid[y][x] ~= tetromino.pattern[y][x] then
						goto continue
					end
				end
			end

			-- if everything matches then return tetromino name
			do return tetromino.name end

			::continue::
		end	

		return "error: no matching tetromino found"
	end
end


--[[
	Reset the tetromino ability cooldown, deactivating the last four squares.
]]
function Player:resetTetrominos()
	self:resetTimer("tetro-cooldown")

	-- turn off tiles
	for i, tile in ipairs(self.lastFourTiles) do
		tile.altActive = false
	end 

	-- clear tiles from player memory
	self.lastFourTiles = {}
end


--[[
	Activate an ability based on the tetromino formed by the player's last four
	tiles. The five abilities are:
		1) straight: dash (implemented)
		2) square: invulnerability (implemented)
		3) T: teleport
		4) L/J: beam
		5) S/Z: area attack
]]
function Player:activateTetromino()
	-- check that it is not too soon after a recent tetromino ability
	if self:isTimerComplete("tetro-cooldown") then

		-- identify and activate tetromino ability
		local tetromino = self:identifyTetromino()
		-- activate invulnerability
		if tetromino == "square" then
			gSounds["tetro_invulnerable"]:play()
			self:goInvulnerable("tetro-invuln")
			self:resetTetrominos()
		-- activate dash
		elseif tetromino == "straight-H" or tetromino == "straight-V" then
			gSounds["dash"]:play()
			self:dash()
			self:resetTetrominos()
		end
	end
end


--[[
	Makes the player immune to damage until the indicated timer completes.
]]
function Player:goInvulnerable(timer)
	self:resetTimer(timer)
	self.invulnerable = true
end


--[[
	Makes the player dash forward, both immune to damage and doing damage during
	the dash.
]]
function Player:dash()
	self:changeState("dash", "dash")
end


--[[
	Returns true if the player is currently dashing.
]]
function Player:isDashing()
	return self.stateMachine.name == "dash"
end


--[[
	In addition to taking normal game object damage, the player becomes briefly
	invulnerable when taking damage. Resets the score multiplier.
]]
function Player:damage(damage)
	-- only take damage if not already invulnerable
	if not self.invulnerable then
		GameObject.damage(self, damage)

		self.level.game:resetMultiplier()

		self:goInvulnerable("damage-invuln")

		gSounds["player_damage"]:play()
	end
end


function Player:update(dt)
	-- deactivate invulnerability when timer finishes if not dashing
	local notDamageInvuln = self:isTimerComplete("damage-invuln")
	local notTetroInvuln = self:isTimerComplete("tetro-invuln")
	if self.invulnerable and notDamageInvuln and notTetroInvuln and not self:isDashing() then
		self.invulnerable = false
		self.blinking = false
	end

	Entity.update(self, dt)

	-- if the player steps onto new tile then update the last four tiles list
	if self:isTimerComplete("tetro-cooldown") then
		local tileCheck = self:getTile()
		if self.currentTile ~= tileCheck then
			self:updateLastFourTiles(tileCheck)

			-- identify current tetromino if debug on
			if DEBUG then
				print(self:identifyTetromino())
			end
		end
	end
end


function Player:render()
	-- if invulnerable use timer to blink in and out of sight unless dashing
	if self.invulnerable and not self:isDashing() then
		if self:isTimerComplete("blink") then
			self:resetTimer("blink")
			self.blinking = not self.blinking
		end
	end

	-- render unless blinking
	if not self.blinking then
		GameObject.render(self)
	end

	-----------------------------------------
	-- debug child hitbox rendering
	self.stateMachine.current:render()
end