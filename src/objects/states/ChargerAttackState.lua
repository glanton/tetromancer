--[[
	Tetromancer

	Alex Friberg

	Created:		12.07.20
	Laste Updated:	12.10.20
]]

ChargerAttackState = Class{__includes = BaseState}

function ChargerAttackState:init(entity)
	self.entity = entity

	self.hitbox = Hitbox(self.entity, self.entity.abilities["attack"])

	self.entity.speed = self.entity.abilities["attack"].speed

	self.entity.xRenderOffset = ABILITY_X_OFFSET
	self.entity.yRenderOffset = ABILITY_Y_OFFSET
	self.entity:changeAnimation("attack-" .. self.entity.direction)

	gSounds[self.entity.abilities["attack"].sound]:stop()
	gSounds[self.entity.abilities["attack"].sound]:play()
end


--[[
	Return to idle state, resetting speed and animation.
]]
function ChargerAttackState:goIdle()
	local charger = self.entity

	charger.currentAnimation:refresh()
    charger.xRenderOffset = 0
	charger.yRenderOffset = 0

    charger.speed = charger.baseSpeed
    charger:changeState("idle")
end


function ChargerAttackState:update(dt)
	local charger = self.entity

	-- move charger based on speed and direction
	charger:move(dt)

	-- if colliding with tile or entity reset to the origin position and exit state
	if charger:isTileColliding() or charger:isEntityColliding() then
		charger:resetPosition()
		self:goIdle()
		return
	end

	-- update the hitbox to track with the charger as it charges
	self.hitbox:moveWithParent()

	-- process hits
	self.hitbox:update()

	-- only run the state for the duration of the animation
    if charger.currentAnimation.timesPlayed > 0 then
    	self:goIdle()
    end
end


function ChargerAttackState:render()
	self.hitbox:render()
end