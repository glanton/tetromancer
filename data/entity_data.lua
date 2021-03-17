--[[
	Tetromancer

	Alex Friberg

	Created:		11.29.20
	Last Updated:	12.10.20
]]

ENTITY_DATA = {
	["player"] = {
		name = "player",
		type = "player",
		health = 4,
		speed = 60,
		attack = 1,
		width = 10,
		height = 6,
		states = {
			["idle"] = "PlayerIdleState",
			["walk"] = "PlayerWalkState",
			["slash"] = "PlayerSlashState",
			["dash"] = "PlayerDashState"
		},
		timers = {
			["damage-invuln"] = 1.5,
			["blink"] = 0.1,
			["tetro-invuln"] = 2,
			["tetro-cooldown"] = 6
		},
		abilities = {
			["slash"] = {
				breadth = 24,
				depth = 14,
				depthOffset = -2,
				speed = 30,
				damage = 1,
				target = "single"
			},
			["dash"] = {
				breadth = 12,
				depth = 24,
				depthOffset = -22,
				speed = 150,
				damage = 1,
				target = "all"
			}
		},
		animations = {
			["idle-down"] = {
				texture = "player-walk",
				frames = {2}
			},
			["idle-right"] = {
				texture = "player-walk",
				frames = {6}
			},
			["idle-up"] = {
				texture = "player-walk",
				frames = {10}
			},
			["idle-left"] = {
				texture = "player-walk",
				frames = {14}
			},
			["walk-down"] = {
				texture = "player-walk",
				frames = {1, 2, 3, 4},
				interval = 0.2
			},
			["walk-right"] = {
				texture = "player-walk",
				frames = {5, 6, 7, 8},
				interval = 0.2
			},
			["walk-up"] = {
				texture = "player-walk",
				frames = {9, 10, 11, 12},
				interval = 0.2
			},
			["walk-left"] = {
				texture = "player-walk",
				frames = {13, 14, 15, 16},
				interval = 0.2
			},
			["slash-down"] = {
				texture = "player-slash",
				frames = {1, 1},
				interval = 0.1
			},
			["slash-right"] = {
				texture = "player-slash",
				frames = {2, 2},
				interval = 0.1
			},
			["slash-up"] = {
				texture = "player-slash",
				frames = {3, 3},
				interval = 0.1
			},
			["slash-left"] = {
				texture = "player-slash",
				frames = {4, 4},
				interval = 0.1
			},
			["dash-down"] = {
				texture = "player-dash",
				frames = {1, 1},
				interval = 0.25
			},
			["dash-right"] = {
				texture = "player-dash",
				frames = {2, 2},
				interval = 0.25
			},
			["dash-up"] = {
				texture = "player-dash",
				frames = {3, 3},
				interval = 0.25
			},
			["dash-left"] = {
				texture = "player-dash",
				frames = {4, 4},
				interval = 0.25
			},
		}
	},
	["mino"] = {
		name = "mino",
		type = "enemy",
		difficulty_score = 1,
		health = 1,
		speed = 40,
		attack = 1,
		width = 4,
		height = 4,
		states = {
			["idle"] = "SwarmerIdleState",
			["walk"] = "SwarmerWalkState"
		},
		timers = {
			["search"] = 0.5
		},
		abilities = {
			["collide"] = {
				breadth = 6,
				depth = 6,
				depthOffset = -5,
				damage = 1,
				target = "player"
			}
		},
		animations = {
			["idle-down"] = {
				texture = "mino-walk",
				frames = {1, 2, 3, 4, 5, 6, 7, 8},
				interval = 0.2
			},
			["idle-right"] = {
				texture = "mino-walk",
				frames = {1, 2, 3, 4, 5, 6, 7, 8},
				interval = 0.2
			},
			["idle-up"] = {
				texture = "mino-walk",
				frames = {1, 2, 3, 4, 5, 6, 7, 8},
				interval = 0.2
			},
			["idle-left"] = {
				texture = "mino-walk",
				frames = {1, 2, 3, 4, 5, 6, 7, 8},
				interval = 0.2
			},
			["walk-down"] = {
				texture = "mino-walk",
				frames = {1, 2, 3, 4, 5, 6, 7, 8},
				interval = 0.2
			},
			["walk-right"] = {
				texture = "mino-walk",
				frames = {1, 2, 3, 4, 5, 6, 7, 8},
				interval = 0.2
			},
			["walk-up"] = {
				texture = "mino-walk",
				frames = {1, 2, 3, 4, 5, 6, 7, 8},
				interval = 0.2
			},
			["walk-left"] = {
				texture = "mino-walk",
				frames = {1, 2, 3, 4, 5, 6, 7, 8},
				interval = 0.2
			}
		}
	},
	["spearman"] = {
		name = "spearman",
		type = "enemy",
		difficulty_score = 2,
		health = 1,
		speed = 50,
		attack = 1,
		width = 12,
		height = 6,
		states = {
			["idle"] = "PatrollerIdleState",
			["walk"] = "PatrollerWalkState",
			["attack"] = "ChargerAttackState"
		},
		timers = {
			["wait"] = 0.5,
			["patrol"] = 2,
			["search"] = 0.5,
		},
		abilities = {
			["attack"] = {
				breadth = 6,
				depth = 16,
				depthOffset = -4,
				range = 100,
				speed = 100,
				damage = 1,
				target = "player",
				sound = "spear_charge"
			}
		},
		animations = {
			["idle-down"] = {
				texture = "spearman-walk",
				frames = {2}
			},
			["idle-right"] = {
				texture = "spearman-walk",
				frames = {6}
			},
			["idle-up"] = {
				texture = "spearman-walk",
				frames = {10}
			},
			["idle-left"] = {
				texture = "spearman-walk",
				frames = {14}
			},
			["walk-down"] = {
				texture = "spearman-walk",
				frames = {1, 2, 3, 4},
				interval = 0.2
			},
			["walk-right"] = {
				texture = "spearman-walk",
				frames = {5, 6, 7, 8},
				interval = 0.2
			},
			["walk-up"] = {
				texture = "spearman-walk",
				frames = {9, 10, 11, 12},
				interval = 0.2
			},
			["walk-left"] = {
				texture = "spearman-walk",
				frames = {13, 14, 15, 16},
				interval = 0.2
			},
			["attack-down"] = {
				texture = "spearman-charge",
				frames = {1, 1},
				interval = 0.5
			},
			["attack-right"] = {
				texture = "spearman-charge",
				frames = {2, 2},
				interval = 0.5
			},
			["attack-up"] = {
				texture = "spearman-charge",
				frames = {3, 3},
				interval = 0.5
			},
			["attack-left"] = {
				texture = "spearman-charge",
				frames = {4, 4},
				interval = 0.5
			}
		}
	},
	["mage"] = {
		name = "mage",
		type = "enemy",
		difficulty_score = 3,
		health = 1,
		speed = 50,
		attack = 1,
		width = 12,
		height = 6,
		states = {
			["idle"] = "PatrollerIdleState",
			["walk"] = "CasterWalkState",
			["flee"] = "CasterFleeState",
			["attack"] = "CasterAttackState"
		},
		timers = {
			["wait"] = 1,
			["patrol"] = 2,
			["panic"] = 0.5,
			["search"] = 0.2,
		},
		abilities = {
			["attack"] = {
				name = "magic blast",
				type = "projectile",
				breadth = 6,
				depth = 6,
				depthOffset = -6,
				range = 400,
				speed = 100,
				damage = 1,
				target = "player",
				animations = {
					["down"] = {
						texture = "magic-blast",
						frames = {1}
					},
					["right"] = {
						texture = "magic-blast",
						frames = {2}
					},
					["up"] = {
						texture = "magic-blast",
						frames = {3}
					},
					["left"] = {
						texture = "magic-blast",
						frames = {4}
					}
				}
			},
			["flee"] = {
				range = 40,
				speed = 100
			}
		},
		animations = {
			["idle-down"] = {
				texture = "mage-walk",
				frames = {2}
			},
			["idle-right"] = {
				texture = "mage-walk",
				frames = {6}
			},
			["idle-up"] = {
				texture = "mage-walk",
				frames = {10}
			},
			["idle-left"] = {
				texture = "mage-walk",
				frames = {14}
			},
			["walk-down"] = {
				texture = "mage-walk",
				frames = {1, 2, 3, 4},
				interval = 0.2
			},
			["walk-right"] = {
				texture = "mage-walk",
				frames = {5, 6, 7, 8},
				interval = 0.2
			},
			["walk-up"] = {
				texture = "mage-walk",
				frames = {9, 10, 11, 12},
				interval = 0.2
			},
			["walk-left"] = {
				texture = "mage-walk",
				frames = {13, 14, 15, 16},
				interval = 0.2
			},
			["attack-down"] = {
				texture = "mage-walk",
				frames = {1, 2, 3, 4},
				interval = 0.1
			},
			["attack-right"] = {
				texture = "mage-walk",
				frames = {5, 6, 7, 8},
				interval = 0.1
			},
			["attack-up"] = {
				texture = "mage-walk",
				frames = {9, 10, 11, 12},
				interval = 0.1
			},
			["attack-left"] = {
				texture = "mage-walk",
				frames = {13, 14, 15, 16},
				interval = 0.1
			}
		}
	},
	["reanimino"] = {
		name = "reanimino",
		type = "enemy",
		difficulty_score = 4,
		health = 1,
		speed = 50,
		attack = 1,
		width = 12,
		height = 6,
		states = {
			["idle"] = "PatrollerIdleState",
			["walk"] = "PatrollerWalkState",
			["attack"] = "ChargerAttackState"
		},
		timers = {
			["wait"] = 2,
			["patrol"] = 2,
			["search"] = 0.2,
		},
		abilities = {
			["attack"] = {
				breadth = 12,
				depth = 24,
				depthOffset = -22,
				range = 200,
				speed = 150,
				damage = 1,
				target = "player",
				sound = "dash"
			}
		},
		animations = {
			["idle-down"] = {
				texture = "reanimino-walk",
				frames = {2}
			},
			["idle-right"] = {
				texture = "reanimino-walk",
				frames = {6}
			},
			["idle-up"] = {
				texture = "reanimino-walk",
				frames = {10}
			},
			["idle-left"] = {
				texture = "reanimino-walk",
				frames = {14}
			},
			["walk-down"] = {
				texture = "reanimino-walk",
				frames = {1, 2, 3, 4},
				interval = 0.2
			},
			["walk-right"] = {
				texture = "reanimino-walk",
				frames = {5, 6, 7, 8},
				interval = 0.2
			},
			["walk-up"] = {
				texture = "reanimino-walk",
				frames = {9, 10, 11, 12},
				interval = 0.2
			},
			["walk-left"] = {
				texture = "reanimino-walk",
				frames = {13, 14, 15, 16},
				interval = 0.2
			},
			["attack-down"] = {
				texture = "reanimino-charge",
				frames = {1, 1},
				interval = 0.6
			},
			["attack-right"] = {
				texture = "reanimino-charge",
				frames = {2, 2},
				interval = 0.6
			},
			["attack-up"] = {
				texture = "reanimino-charge",
				frames = {3, 3},
				interval = 0.6
			},
			["attack-left"] = {
				texture = "reanimino-charge",
				frames = {4, 4},
				interval = 0.6
			}
		}
	}
}