--[[
	Tetromancer

	Alex Friberg
	
	Created:		12.10.20
	Last Updated:	12.10.20
]]

PlayerDashState = Class{__includes = PlayerAttackState}

function PlayerDashState:init(entity)
	PlayerAttackState.init(self, entity)

	self.entity.invulnerable = true
end


function PlayerDashState:update(dt)
	PlayerAttackState.update(self, dt)

	local player = self.entity

	-- only run the state for the duration of the animation
    if player.currentAnimation.timesPlayed > 0 then
    	-- reset the animation and the render offset
        player.currentAnimation:refresh()
        player.xRenderOffset = 0
		player.yRenderOffset = 0

        player.speed = player.baseSpeed
        player.invulnerable = false

        player:changeState("idle")
    end
end