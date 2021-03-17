--[[
	Tetromancer

	Alex Friberg

	Created:		12.07.20
]]

CasterAttackState = Class{__includes = BaseState}

function CasterAttackState:init(entity)
	self.entity = entity

	self.entity:changeAnimation("attack-" .. self.entity.direction)
end


function CasterAttackState:update(dt)
	local caster = self.entity

	-- cast projectile when the attack animation completes
    if caster.currentAnimation.timesPlayed > 0 then
    	caster.level:launchProjectile(caster, caster.abilities["attack"])

    	-- reset the animation
        caster.currentAnimation:refresh()

        gSounds["magic_blast"]:stop()
    	gSounds["magic_blast"]:play()

        -- flee if the player is still close, otherwise return to idle
		if caster:getPlayerDistance() <= caster.abilities["flee"].range then
			caster:changeState("flee")
		else
        	caster:changeState('idle')
    	end
    end
end