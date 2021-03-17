--[[
	Tetromancer

	Alex Friberg

	Created:		12.06.20
	Last Updated:	12.10.20

	Note: Hitbox briefly masquerades as a GameObject in its collision damage 
	functions by providing itself to the GameObject isColliding function. This
	is a simple function that only needs self.x, self.y, self.width, and
	self.height, all of which Hitbox has. This keeps the code more DRY, and also
	preserves the overall abstraction of Hitbox from the alternative of making it
	inherit GameObject. Hitbox is not really a GameObject--it only exists as a
	child of a GameObject and is only updated based on the specific needs of its
	parent.
]]

Hitbox = Class{}

function Hitbox:init(parent, def)
	self.parent = parent

	-- build the hitbox, centering it along its parent's edge in its current direction
	if parent.direction == "left" then
		self.width = def.depth
		self.height = def.breadth
		self.x = parent.x - self.width - def.depthOffset
		self.y = parent.y - ((self.height - parent.height) / 2)
	elseif parent.direction == "right" then
		self.width = def.depth
		self.height = def.breadth
		self.x = parent.x + parent.width + def.depthOffset
		self.y = parent.y - ((self.height - parent.height) / 2)
	elseif parent.direction == "up" then
		self.width = def.breadth
		self.height = def.depth
		self.x = parent.x - ((self.width - parent.width) / 2)
		self.y = parent.y - self.height - def.depthOffset
	elseif parent.direction == "down" then
		self.width = def.breadth
		self.height = def.depth
		self.x = parent.x - ((self.width - parent.width) / 2)
		self.y = parent.y + parent.height + def.depthOffset
	end

	self.damage = def.damage
	self.target = def.target

	self.active = true
end


--[[
	Changes the hitbox's parent to the specified parent. Useful for scenarios
	where the hitbox should be generated relative to a caster enity, but then
	track with a projectile.
]]
function Hitbox:reparent(parent)
	self.parent = parent
end


--[[
	Can be used for hitboxes that move with an entity or projectile.
]]
function Hitbox:updatePosition(x, y)
	self.x = self.x + x
	self.y = self.y + y
end

--[[
	Update the position of the hitbox relative to its parent's last move.
]]
function Hitbox:moveWithParent()
	self:updatePosition(
		self.parent.x - self.parent.xPrevious,
		self.parent.y - self.parent.yPrevious
	)
end


--[[
	Check collision against all non-parent entities and for each collision
	damage those enemies for the hitbox's damage value.
]]
function Hitbox:damageAllCollidingEntities()
	for i, entity in ipairs(self.parent.level.entities) do
		-- make sure not to check against self and that entity is not expired
		if entity ~= self.parent and not entity:isExpired() and GameObject.isColliding(self, entity) then
			entity:damage(self.damage)
		end
	end
end


--[[
	Check collision against all non-parent entities and for the first collision
	damage that enemy for the hitbox's damage value. On collision deactivate the
	hitbox so that it won't register additional hits in the future. Notifies the
	hitbox's parent so that it can take additional action as needed.
]]
function Hitbox:damageFirstCollidingEntity()
	for i, entity in ipairs(self.parent.level.entities) do
		-- make sure not to check against self and that entity is not expired
		if entity ~= self.parent and not entity:isExpired() and GameObject.isColliding(self, entity) then
			entity:damage(self.damage)
			self.active = false

			-- notify the hitbox's parent that it hit a target
			self.parent:notifyOfHit()

			return
		end
	end
end


--[[
	Check collision against the player. No need to deactivate on collision
	because the player receives invulnerability for a short duration when
	damaged. Checks if player was expired so that in the transition to the game
	over state projectiles do not despawn against an invisible expired player.
	Notifies the hitbox's parent so that it can take additional action as needed.
]]
function Hitbox:damageCollidingPlayer()
	if GameObject.isColliding(self, self.parent.level.player) and not self.parent.level.player:isExpired() then
		self.parent.level.player:damage(self.damage)

		-- notify the hitbox's parent that it hit a target
		self.parent:notifyOfHit()
	end
end


function Hitbox:update()
	if self.active then
		if self.target == "player" then
			self:damageCollidingPlayer()
		elseif self.target == "all" then
			self:damageAllCollidingEntities()
		else
			self:damageFirstCollidingEntity()
		end
	end
end


--[[
	Only render hitboxes if debug mode is on.
]]
function Hitbox:render()
	renderDebugBox(self, COLORS["debug-red"])
end