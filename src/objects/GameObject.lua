--[[
	Tetromancer

	Alex Friberg

	Created:		12.09.20
	Last Updated:	12.10.20
]]

GameObject = Class{}

function GameObject:init(def)
	self.width = def.width or 0
	self.height = def.height or 0

	self.direction = "down"

	self.animations = self:createAnimations(def.animations)
	self.xRenderOffset = 0
	self.yRenderOffset = 0

	self.name = def.name
	self.type = def.type

	self.health = def.health or 0

	self.baseSpeed = def.speed or 0
	self.speed = self.baseSpeed

	-- when true the game object will be treated as if deleted
	self.expired = false

	timers = def.timers or {}
	self.timers = self:buildTimers(timers)
end


--[[
	Build a table of all timers listed in the game objects's definition, starting
	each at 0 and recording the duration at which they are considered complete.
]]
function GameObject:buildTimers(timersDef)
	local timers = {}
	for timerName, duration in pairs(timersDef) do
		timers[timerName] = {time = 0, duration = duration}
	end

	return timers
end


--[[
	Update all timers based on elapsed delta time.
]]
function GameObject:updateTimers(dt)
	for k, timer in pairs(self.timers) do
		if not self:isTimerComplete(k) then
			timer.time = timer.time + dt
		end
	end
end


--[[
	Get the current time of the specified timer.
]]
function GameObject:getTimer(timer)
	return self.timers[timer].time
end


--[[
	Set the specified timer to the specified time.
]]
function GameObject:setTimer(timer, time)
	self.timers[timer].time = time
end


--[[
	Reset the specified timer to zero.
]]
function GameObject:resetTimer(timer)
	self.timers[timer].time = 0
end


--[[
	Returns true if the time has reached or passed its specified duration.
]]
function GameObject:isTimerComplete(timer)
	return self.timers[timer].time >= self.timers[timer].duration
end


--[[
	Establish a relationship to the level enabling the game object to look up
	other game objects in the level.
]]
function GameObject:setLevel(level)
	self.level = level
end


--[[
	Set game object position to the specified x and y coordinates.
]]
function GameObject:setPosition(x, y)
	self.x = x
	self.y = y
end


--[[
	Reset game object position to its last recorded previous position.
]]
function GameObject:resetPosition()
	self.x = self.xPrevious
	self.y = self.yPrevious
end


--[[
	Move a game object based on its current direction and elapsed delta time.
]]
function GameObject:move(dt)
	-- store the start position before moving
	self.xPrevious = self.x
	self.yPrevious = self.y

	if self.direction == "left" then
		self.x = self.x - (self.speed * dt)
	elseif self.direction == "right" then
		self.x = self.x + (self.speed * dt)
	elseif self.direction == "up" then
		self.y = self.y - (self.speed * dt)
	elseif self.direction == "down" then
		self.y = self.y + (self.speed * dt)
	end
end


--[[
	Author: Colton Ogden (Legend of Zelnda -- Entity.lua)
	Takes game object animation definition data and returns a table of Animations.
]]
function GameObject:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture,
            frames = animationDef.frames,
            interval = animationDef.interval,
            nonlooping = animationDef.nonlooping or false
        }
    end

    return animationsReturned
end


--[[
	Author: Colton Ogden (Legend of Zelnda -- Entity.lua)
]]
function GameObject:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end


--[[
	Returns true if any of the game objects's corners overlap with collidable tiles.
	For the purposes of wall collision the top corners are lowered to the game
	objects's halfway point, allowing for a more natural-looking overlap when
	approaching walls above them.
]]
function GameObject:isTileColliding()
	local left = self.x
	local right = self.x + self.width 
	local top = self.y + (self.height / 2)
	local bottom = self.y + self.height

	return	self.level:getTileByPixelPos(left, top).collidable	or
			self.level:getTileByPixelPos(right, top).collidable or
			self.level:getTileByPixelPos(right, bottom).collidable or
			self.level:getTileByPixelPos(left, bottom).collidable
end


--[[
	Author: Colton Ogden (Legend of Zelnda -- Entity.lua)
    AABB with some slight shrinkage of the box on the top side for perspective.
]]
function GameObject:isColliding(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end


--[[
	Returns true if any of the game objects's corners overlap with any entity in
	in the level.
]]
function GameObject:isEntityColliding()
	-- if any collision return true
	for i, entity in ipairs(self.level.entities) do
		-- make sure not to check against self and that entity is not expired
		if entity ~= self and not entity:isExpired() and self:isColliding(entity) then
			return true
		end
	end

	-- otherwise return false
	return false
end


--[[
	Used by the child hitbox to notify a game object that it has hit a target.
	Does nothing by default; currently only used by certain types of game objects.
]]
function GameObject:notifyOfHit()
	-- see Projectile class for example of usage
end


--[[
	Damage the game object for the specified amount. Game objects expire by
	default when taking fatal damage.
]]
function GameObject:damage(damage)
	self.health = self.health - damage
	if self.health <= 0 then
		self:expire()
	end
end


--[[
	Set the game object to be treated as though deleted.
]]
function GameObject:expire()
	self.expired = true
end


--[[
	Returns true if the game object is expired.
]]
function GameObject:isExpired()
	return self.expired
end


function GameObject:update(dt)
	self:updateTimers(dt)

	if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end


function GameObject:render()
	local texture = self.currentAnimation.texture
	local frame = self.currentAnimation:getCurrentFrame()

	--[[
		calculate render offsets, taking into consideration the size of the game
		object vs the standard size of game object frames, and also any additional
		sub-class-specific adjustment.
	]]
	local xOffset = ((ENTITY_SIZE - self.width) / 2) + self.xRenderOffset
	local yOffset = ENTITY_SIZE - self.height + self.yRenderOffset

	love.graphics.draw(
		gTextures[texture], gFrames[texture][frame],
		math.floor(self.x) - xOffset, math.floor(self.y) - yOffset
	)

	-----------------------------------------
	-- debug collision box rendering
	renderDebugBox(self, COLORS["debug-green"])
end