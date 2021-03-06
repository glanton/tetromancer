--[[
	Tetromancer

	Alex Friberg

	Created:			12.03.20
	Lasted Updated:		12.03.20
]]

TETROMINOS = {
	["straight-H"] = {
		name = "straight-H",
		pattern = {
			{1, 1, 1, 1},
			{0, 0, 0, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["straight-V"] = {
		name = "straight-V",
		pattern = {
			{1, 0, 0, 0},
			{1, 0, 0, 0},
			{1, 0, 0, 0},
			{1, 0, 0, 0},
		},
	},
	["square"] = {
		name = "square",
		pattern = {
			{1, 1, 0, 0},
			{1, 1, 0, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["T-0"] = {
		name = "T-0",
		pattern = {
			{1, 1, 1, 0},
			{0, 1, 0, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["T-90"] = {
		name = "T-90",
		pattern = {
			{0, 1, 0, 0},
			{1, 1, 0, 0},
			{0, 1, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["T-180"] = {
		name = "T-180",
		pattern = {
			{0, 1, 0, 0},
			{1, 1, 1, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["T-270"] = {
		name = "T-270",
		pattern = {
			{1, 0, 0, 0},
			{1, 1, 0, 0},
			{1, 0, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["L-0"] = {
		name = "L-0",
		pattern = {
			{1, 0, 0, 0},
			{1, 0, 0, 0},
			{1, 1, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["L-90"] = {
		name = "L-90",
		pattern = {
			{1, 1, 1, 0},
			{1, 0, 0, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["L-180"] = {
		name = "L-180",
		pattern = {
			{1, 1, 0, 0},
			{0, 1, 0, 0},
			{0, 1, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["L-270"] = {
		name = "L-270",
		pattern = {
			{0, 0, 1, 0},
			{1, 1, 1, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["J-0"] = {
		name = "J-0",
		pattern = {
			{0, 1, 0, 0},
			{0, 1, 0, 0},
			{1, 1, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["J-90"] = {
		name = "J-90",
		pattern = {
			{1, 0, 0, 0},
			{1, 1, 1, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["J-180"] = {
		name = "J-180",
		pattern = {
			{1, 1, 0, 0},
			{1, 0, 0, 0},
			{1, 0, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["J-270"] = {
		name = "J-270",
		pattern = {
			{1, 1, 1, 0},
			{0, 0, 1, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["S-H"] = {
		name = "S-H",
		pattern = {
			{0, 1, 1, 0},
			{1, 1, 0, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["S-V"] = {
		name = "S-V",
		pattern = {
			{1, 0, 0, 0},
			{1, 1, 0, 0},
			{0, 1, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["Z-H"] = {
		name = "Z-H",
		pattern = {
			{1, 1, 0, 0},
			{0, 1, 1, 0},
			{0, 0, 0, 0},
			{0, 0, 0, 0},
		},
	},
	["Z-V"] = {
		name = "Z-V",
		pattern = {
			{0, 1, 0, 0},
			{1, 1, 0, 0},
			{1, 0, 0, 0},
			{0, 0, 0, 0},
		},
	},
}