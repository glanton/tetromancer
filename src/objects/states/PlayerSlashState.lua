--[[
	Tetromancer

	Alex Friberg

	Created:		12.06.20
	Last Updated:	12.10.20
]]

PlayerSlashState = Class{__includes = PlayerAttackState}

function PlayerSlashState:init(entity)
	PlayerAttackState.init(self, entity)

	gSounds["slash"]:stop()
	gSounds["slash"]:play()
end


function PlayerSlashState:update(dt)
	PlayerAttackState.update(self, dt)

	local player = self.entity

	-- only run the state for the duration of the animation
    if player.currentAnimation.timesPlayed > 0 then
    	-- reset the animation and the render offset
        player.currentAnimation:refresh()
        player.xRenderOffset = 0
		player.yRenderOffset = 0

		player.speed = player.baseSpeed

        player:changeState('idle')
    end
end