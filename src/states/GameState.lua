--[[
	Tetromancer

	Alex Friberg

	Created:		11.29.20
	Last Updated:	12.09.20
]]

GameState = Class{__includes = BaseState}

function GameState:init()
	self.player = Player()

	self.score = 0
	self.multiplier = 1
	self.pointsToMultiplier = self:calculateMultiplier(self.multiplier)

	gSounds["play"]:setLooping(true)
	gSounds["play"]:play()
end


function GameState:enter()
	self.level = Level(self, self.player, START_LEVEL)
end


--[[
	Record points to the total score, taking the current score multiplier into
	consideration.
]]
function GameState:recordPoints(points)
	-- record points
	local multipliedPoints = points * self.multiplier
	self.score = self.score + multipliedPoints

	-- increase multiplier if applicable
	self:increaseMultiplier(multipliedPoints)
end


function GameState:increaseMultiplier(points)
	local remainingPoints = points

	-- update multiplier until all points have been accounted for
	self.pointsToMultiplier = self.pointsToMultiplier - remainingPoints
	while(self.pointsToMultiplier <= 0) do
		-- increase until max multiplier reached
		self.multiplier = math.min(self.multiplier + 1, MAX_MULTIPLIER)

		-- update remaining and points to next multiplier
		remainingPoints = -1 * self.pointsToMultiplier
		self.pointsToMultiplier = math.ceil(self:calculateMultiplier(self.multiplier + 1))

		-- account for remaining points
		self.pointsToMultiplier = self.pointsToMultiplier - remainingPoints
	end
end


--[[
	Uses an exponential function to determine the number of points required to
	reach the next multiplier based on the specified multiplier.
]]
function GameState:calculateMultiplier(multiplier)
	return math.ceil(M_BASE ^ multiplier)
end


--[[
	Reset the multiplier to one. Occures when the player takes damage.
]]
function GameState:resetMultiplier()
	self.multiplier = 1
	self.pointsToMultiplier = self:calculateMultiplier(self.multiplier)
end


--[[
	Load the next level
]]
function GameState:nextLevel(levelNumber)
	-- gSounds["next_level"]:setVolume(0)
	-- gSounds["next_level"]:play()
	self.level = Level(self, self.player, levelNumber)
end


function GameState:update(dt)
	self.level:update(dt)
end


function GameState:render()
	-- render the level and everything in it
	self.level:render()

	-- render the player's health
	for i = 0, self.player.health - 1 do
		local xHealthOffset = i * TILE_SIZE
		love.graphics.draw(
			gTextures["heart"], gFrames["heart"][1],
			HEALTH_X + xHealthOffset, HEALTH_Y
		)
	end

	-- print the level number, score, and mutliplier
	love.graphics.setColor(COLORS["light"])
	love.graphics.setFont(gFonts['interface'])

	local text = "Level " .. self.level.floor
	love.graphics.printf(text, 0, INTERFACE_TEXT_Y, VIRTUAL_WIDTH, "center")

	text = string.format("%08d", self.score)
	love.graphics.printf(text, SCORE_TEXT_X, INTERFACE_TEXT_Y, VIRTUAL_WIDTH)

	love.graphics.setColor(COLORS["dark"])
	text = "x" .. self.multiplier
	love.graphics.printf(text, MULT_TEXT_X + TILE_SIZE, INTERFACE_TEXT_Y, VIRTUAL_WIDTH)
end