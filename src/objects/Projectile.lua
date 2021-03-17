--[[
	Tetromancer

	Alex Friberg
	
	Created:		12.08.20
	Last Updated:	12.10.20
]]

Projectile = Class{__includes = GameObject}

function Projectile:init(parent, def)
	self.parent = parent

	GameObject.init(self, def)

	-- create the hitbox first since it handles proper sizing and position
	self.hitbox = Hitbox(parent, def)

	self.x = self.hitbox.x
	self.y = self.hitbox.y
	self.width = self.hitbox.width
	self.height = self.hitbox.height

	-- the hitbox now only needs a relationship with the projectile itself
	self.hitbox:reparent(self)

	self.direction = parent.direction

	-- alignment for projectile sprites related to lowering the collision box
	self.yRenderOffset = -PROJECTILE_Y_OFFSET

	self:changeAnimation(self.direction)
end


--[[
	Used by the child hitbox to notify a projectile that it has hit a target.
	Currently only used by single-target enemy and player abilities and should
	trigger the projectile to expire.
]]
function Projectile:notifyOfHit()
	self:expire()
end


--[[
	Projectile tile collision differs from most game objects in that they can
	pass over holes, which are collidable to other game objects.
]]
function Projectile:isTileColliding()
	local left = self.x
	local right = self.x + self.width 
	local top = self.y + (self.height / 2)
	local bottom = self.y + self.height

	local topLeft = self.level:getTileByPixelPos(left, top)
	local topRight = self.level:getTileByPixelPos(right, top)
	local botRight = self.level:getTileByPixelPos(right, bottom)
	local botLeft = self.level:getTileByPixelPos(left, bottom)

	return	(topLeft.collidable and not topLeft.hole) or
			(topRight.collidable and not topRight.hole) or
			(botRight.collidable and not botRight.hole) or
			(botLeft.collidable and not botLeft.hole)
end


function Projectile:update(dt)
	GameObject.update(self, dt)

	-- move projectile based on speed and direction
	self:move(dt)

	-- update the hitbox to track with the projectile after it has moved
	self.hitbox:moveWithParent()

	-- process hits
	self.hitbox:update()

	-- if colliding with tile then expire
	if self:isTileColliding() then
		self:expire()
	end
end


function Projectile:render()
	GameObject.render(self)

	-----------------------------------------
	-- render hitbox in debug mode
	self.hitbox:render()
end