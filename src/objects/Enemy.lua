--[[
	Tetromancer

	Alex Friberg

	Created:		12.05.20
	Last Updated:	12.09.20
]]

Enemy = Class{__includes = Entity}

function Enemy:init(enemy)
	self.difficulty_score = ENTITY_DATA[enemy].difficulty_score

	Entity.init(self, ENTITY_DATA[enemy])
end


--[[
	Returns a random direction.
]]
function Enemy:pickRandomDirection()
	local randomDirection = math.random(1, 4)
	if randomDirection == 1 then
		return "left"
	elseif randomDirection == 2 then
		return "right"
	elseif randomDirection == 3 then
		return "up"
	else
		return "down"
	end
end


--[[
	Returns a random perpendicular direction based on specified direction.
]]
function Enemy:pickRandomPerpendicular(direction)
	local randomPerpendicular = math.random(1, 2)
	if direction == "left" or direction == "right" then
		if randomPerpendicular == 1 then
			return "up"
		else
			return "down"
		end
	else
		if randomPerpendicular == 1 then
			return "left"
		else
			return "right"
		end
	end
end


--[[
	Get the straight line distance to the player.
]]
function Enemy:getPlayerDistance()
	local a = self.x - self.level.player.x
	local b = self.y - self.level.player.y

	return math.sqrt((a * a) + (b * b))
end


--[[
	Returns the distance to the player in the specified direction. If the player
	is in the opposite direction returns a negative value.
]]
function Enemy:getPlayerDistanceByDirection(direction)
	local player = self.level.player

	if direction == "left" then
		return self.x - player.x + player.width
	elseif direction == "right" then
		return player.x - self.x + self.width
	elseif direction == "up" then
		return self.y - player.y + player.width
	elseif direction == "down" then
		return player.y - self.y + self.width
	end
end


--[[
	Determines whether the player is a greater x or y distance from the enemy
	and then sets its direction towards the player along that axis. If given a 
	true boolean, reverses this calculation to face th enemy in the opposite
	direction.
]]
function Enemy:orientToPlayer(reversed)
	local xPlayerDistance = self.x - self.level.player.x
	local yPlayerDistance = self.y - self.level.player.y

	local xDistance = math.abs(xPlayerDistance)
	local yDistance = math.abs(yPlayerDistance)

	if reversed then
		xPlayerDistance = xPlayerDistance * -1
		yPlayerDistance = yPlayerDistance * -1
	end

	if xDistance > yDistance then
		if xPlayerDistance > 0 then
			self.direction = "left"
		else
			self.direction = "right"
		end
	else
		if yPlayerDistance > 0 then
			self.direction = "up"
		else
			self.direction = "down"
		end
	end
end


--[[
	Runs the reverse of orientToPlayer. See that function description for details.
	Used for readability.
]]
function Enemy:orientAwayFromPlayer()
	return self:orientToPlayer(true)
end


--[[
	Returns the direction towards the player if the player is aligned to the enemy
	directly along its x or y axis. Takes player and enemy width and height into
	consideration. If not aligned returns "none".
]]
function Enemy:findPlayerAlignment()
	local player = self.level.player

	if (self.x + self.width >= player.x) and (self.x <= player.x + player.width) then
		if self.y > player.y then
			return "up"
		else
			return "down"
		end
	elseif (self.y + self.height >= player.y) and (self.y <= player.y + player.height) then
		if self.x > player.x then
			return "left"
		else
			return "right"
		end
	else
		return "none"
	end
end


--[[
	Returns true if the enemy is colliding with the player.
]]
function Enemy:isPlayerColliding()
	if self:collides(self.level.player) then
		return true
	else
		return false
	end
end


--[[
	In addition to taking normal game object damage, enemies report their
	difficulty score to the game state to that points can be recorded.
]]
function Enemy:damage(damage)
	GameObject.damage(self, damage)

	self.level.game:recordPoints(self.difficulty_score)

	gSounds["enemy_damage"]:stop()
	gSounds["enemy_damage"]:play()
end