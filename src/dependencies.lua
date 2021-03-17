--[[
	dependencies

	Alex Friberg

	Created:		11.28.20
	Last Updated:	12.10.20
]]

Class = require "lib/class"
push = require "lib/push"
Timer = require 'lib/knife.timer'

require "src/util"

require "data/entity_data"
require "data/tetromino_data"
require "data/tile_data"
require "data/map_data"

require "src/constants"
require "src/Animation"
require "src/Hitbox"

require "src/states/BaseState"
require "src/states/StateMachine"
require "src/states/StateStack"
require "src/states/TitleState"
require "src/states/NextLevelState"
require "src/states/GameState"
require "src/states/GameOverState"

require "src/objects/GameObject"
require "src/objects/Entity"
require "src/objects/Player"
require "src/objects/Enemy"
require "src/objects/Projectile"

require "src/objects/states/EntityIdleState"
require "src/objects/states/EntityWalkState"

require "src/objects/states/PlayerIdleState"
require "src/objects/states/PlayerWalkState"
require "src/objects/states/PlayerAttackState"
require "src/objects/states/PlayerSlashState"
require "src/objects/states/PlayerDashState"

require "src/objects/states/EnemyWalkState"
require "src/objects/states/SwarmerIdleState"
require "src/objects/states/SwarmerWalkState"
require "src/objects/states/PatrollerIdleState"
require "src/objects/states/PatrollerWalkState"
require "src/objects/states/ChargerAttackState"
require "src/objects/states/CasterWalkState"
require "src/objects/states/CasterFleeState"
require "src/objects/states/CasterAttackState"

require "src/world/Level"
require "src/world/Tile"
require "src/world/TileMap"

gFonts = {
	["title"] = love.graphics.newFont("fonts/kongtext.ttf", 24),
	["interface"] = love.graphics.newFont("fonts/kongtext.ttf", 8)
}

gTextures = {
	["title"] = love.graphics.newImage("graphics/title.png"),
	["player-walk"] = love.graphics.newImage("graphics/player-walk.png"),
	["player-slash"] = love.graphics.newImage("graphics/player-slash.png"),
	["player-dash"] = love.graphics.newImage("graphics/player-dash.png"),
	["mino-walk"] = love.graphics.newImage("graphics/mino-walk.png"),
	["spearman-walk"] = love.graphics.newImage("graphics/spearman-walk.png"),
	["spearman-charge"] = love.graphics.newImage("graphics/spearman-charge.png"),
	["mage-walk"] = love.graphics.newImage("graphics/mage-walk.png"),
	["reanimino-walk"] = love.graphics.newImage("graphics/reanimino-walk.png"),
	["reanimino-charge"] = love.graphics.newImage("graphics/reanimino-charge.png"),
	["magic-blast"] = love.graphics.newImage("graphics/magic-blast.png"),
	["tiles"] = love.graphics.newImage("graphics/tiles.png"),
	["heart"] = love.graphics.newImage("graphics/heart.png"),
}

gFrames = {
	["player-walk"] = GenerateQuads(gTextures["player-walk"], 16, 16),
	["player-slash"] = GenerateQuads(gTextures["player-slash"], 48, 48),
	["player-dash"] = GenerateQuads(gTextures["player-dash"], 48, 48),
	["mino-walk"] = GenerateQuads(gTextures["mino-walk"], 16, 16),
	["spearman-walk"] = GenerateQuads(gTextures["spearman-walk"], 16, 16),
	["spearman-charge"] = GenerateQuads(gTextures["spearman-charge"], 48, 48),
	["mage-walk"] = GenerateQuads(gTextures["mage-walk"], 16, 16),
	["reanimino-walk"] = GenerateQuads(gTextures["reanimino-walk"], 16, 16),
	["reanimino-charge"] = GenerateQuads(gTextures["reanimino-charge"], 48, 48),
	["magic-blast"] = GenerateQuads(gTextures["magic-blast"], 16, 16),
	["tiles"] = GenerateQuads(gTextures["tiles"], 16, 16),
	["heart"] = GenerateQuads(gTextures["heart"], 16, 16)
}

gSounds = {
	["start_game"] = love.audio.newSource("sounds/start_game.wav", "static"),
	["next_level"] = love.audio.newSource("sounds/next_level.wav", "static"),
	["game_over"] = love.audio.newSource("sounds/game_over.wav", "static"),
	["slash"] = love.audio.newSource("sounds/slash.wav", "static"),
	["dash"] = love.audio.newSource("sounds/dash.wav", "static"),
	["tetro_invulnerable"] = love.audio.newSource("sounds/tetro_invulnerable.wav", "static"),
	["player_damage"] = love.audio.newSource("sounds/player_damage.wav", "static"),
	["enemy_damage"] = love.audio.newSource("sounds/enemy_damage.wav", "static"),
	["magic_blast"] = love.audio.newSource("sounds/magic_blast.wav", "static"),
	["spear_charge"] = love.audio.newSource("sounds/spear_charge.wav", "static"),
	["title"] = love.audio.newSource("sounds/title.wav", "static"),
	["play"] = love.audio.newSource("sounds/play.wav", "static")
}

require "src/preferences"