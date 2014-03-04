if not HCoold then return end
local hcd_status = "hagakure_cooldowns_cd"
HCoold.grid_def_track_values = {
	[hcd_status .. 3] = {
		["spells"] = {
			{
				["spell"] = {
					["type"] = 5,
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 300,
					["quality"] = 1,
					["cast_time"] = 10,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "PALADIN",
					["spellID"] = 1022,
				},
				["sp_ids"] = {
					1022, -- [1]
				},
				["class"] = "PALADIN",
				["priority"] = 50,
				["spec"] = 1,
			}, -- [1]
			{
				["spell"] = {
					["type"] = 5,
					["specs"] = {
						2, -- [1]
					},
					["CD"] = 120,
					["quality"] = 2,
					["cast_time"] = 12,
					["class"] = "PALADIN",
					["succ"] = "SPELL_CAST_SUCCESS",
					["spellID"] = 6940,
				},
				["sp_ids"] = {
					6940, -- [1]
				},
				["class"] = "PALADIN",
				["priority"] = 50,
				["spec"] = 2,
			}, -- [2]
			{
				["spell"] = {
					["type"] = 4,
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 300,
					["quality"] = 1,
					["cast_time"] = 8,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "PALADIN",
					["spellID"] = 642,
				},
				["sp_ids"] = {
					642, -- [1]
				},
				["class"] = "PALADIN",
				["priority"] = 50,
				["spec"] = 3,
			}, -- [3]
			{
				["spell"] = {
					["type"] = 5,
					["specs"] = {
						1, -- [1]
					},
					["CD"] = 180,
					["quality"] = 3,
					["cast_time"] = 8,
					["class"] = "PRIEST",
					["succ"] = "SPELL_CAST_SUCCESS",
					["spellID"] = 33206,
				},
				["sp_ids"] = {
					33206, -- [1]
				},
				["class"] = "PRIEST",
				["priority"] = 50,
				["spec"] = 1,
			}, -- [4]
			{
				["spell"] = {
					["type"] = 5,
					["specs"] = {
						2, -- [1]
					},
					["CD"] = 180,
					["quality"] = 3,
					["cast_time"] = 10,
					["class"] = "PRIEST",
					["succ"] = "SPELL_CAST_SUCCESS",
					["spellID"] = 47788,
				},
				["sp_ids"] = {
					47788, -- [1]
				},
				["class"] = "PRIEST",
				["priority"] = 50,
				["spec"] = 2,
			}, -- [5]
			{
				["spell"] = {
					["type"] = 4,
					["specs"] = {
						3, -- [1]
					},
					["CD"] = 120,
					["quality"] = 1,
					["cast_time"] = 6,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "PRIEST",
					["spellID"] = 47585,
				},
				["spec"] = 3,
				["sp_ids"] = {
					47585, -- [1]
				},
				["class"] = "PRIEST",
				["priority"] = 50,
			}, -- [6]
			{
				["spell"] = {
					["type"] = 4,
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 180,
					["quality"] = 1,
					["cast_time"] = 20,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "DRUID",
					["spellID"] = 106922,
				},
				["sp_ids"] = {
					106922, -- [1]
				},
				["class"] = "DRUID",
				["priority"] = 50,
				["spec"] = 0,
			}, -- [7]
			{
				["spell"] = {
					["type"] = 5,
					["specs"] = {
						4, -- [1]
					},
					["CD"] = 120,
					["quality"] = 1,
					["cast_time"] = 12,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "DRUID",
					["spellID"] = 102342,
				},
				["sp_ids"] = {
					102342, -- [1]
				},
				["class"] = "DRUID",
				["priority"] = 69,
				["spec"] = 4,
			}, -- [8]
			{
				["spell"] = {
					["type"] = 4,
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 180,
					["quality"] = 1,
					["cast_time"] = 8,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "WARLOCK",
					["spellID"] = 104773,
				},
				["sp_ids"] = {
					104773, -- [1]
				},
				["class"] = "WARLOCK",
				["priority"] = 50,
				["spec"] = 0,
			}, -- [9]
			{
				["spell"] = {
					["type"] = 4,
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 120,
					["quality"] = 1,
					["cast_time"] = 5,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "HUNTER",
					["spellID"] = 19263,
				},
				["sp_ids"] = {
					19263, -- [1]
				},
				["class"] = "HUNTER",
				["priority"] = 50,
				["spec"] = 0,
			}, -- [10]
			{
				["spell"] = {
					["type"] = 4,
					["specs"] = {
						2, -- [1]
					},
					["CD"] = 60,
					["quality"] = 1,
					["cast_time"] = 15,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "SHAMAN",
					["spellID"] = 30823,
				},
				["sp_ids"] = {
					30823, -- [1]
				},
				["class"] = "SHAMAN",
				["priority"] = 50,
				["spec"] = 2,
			}, -- [11]
			{
				["spell"] = {
					["quality"] = 1,
					["type"] = 2,
					["turn_on"] = true,
					["succ"] = "SPELL_CAST_SUCCESS",
					["cast_time"] = 10,
					["class"] = "SHAMAN",
					["CD"] = 180,
					["spellID"] = 108280,
				},
				["sp_ids"] = {
					108280, -- [1]
				},
				["class"] = "SHAMAN",
				["priority"] = 50,
				["spec"] = 3,
			}, -- [12]
			{
				["spell"] = {
					["type"] = 4,
					["CD"] = 120,
					["quality"] = 1,
					["trigger"] = {
						87024, -- [1]
						87023, -- [2]
					},
					["class"] = "MAGE",
					["succ"] = "SPELL_AURA_APPLIED",
					["spellID"] = 86949,
				},
				["sp_ids"] = {
					86949, -- [1]
					87023, -- [2]
					87024, -- [3]
				},
				["class"] = "MAGE",
				["priority"] = 50,
				["spec"] = 0,
			}, -- [13]
			{
				["spell"] = {
					["type"] = 4,
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 300,
					["quality"] = 1,
					["cast_time"] = 10,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "MAGE",
					["spellID"] = 45438,
				},
				["sp_ids"] = {
					45438, -- [1]
				},
				["class"] = "MAGE",
				["priority"] = 18,
				["spec"] = 0,
			}, -- [14]
			{
				["spell"] = {
					["type"] = 4,
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 120,
					["quality"] = 1,
					["cast_time"] = 5,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "ROGUE",
					["spellID"] = 31224,
				},
				["sp_ids"] = {
					31224, -- [1]
				},
				["class"] = "ROGUE",
				["priority"] = 50,
				["spec"] = 0,
			}, -- [15]
			{
				["spell"] = {
					["type"] = 4,
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 180,
					["quality"] = 1,
					["cast_time"] = 12,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "DEATHKNIGHT",
					["spellID"] = 48792,
				},
				["sp_ids"] = {
					48792, -- [1]
				},
				["class"] = "DEATHKNIGHT",
				["priority"] = 50,
				["spec"] = 0,
			}, -- [16]
			{
				["spell"] = {
					["type"] = 4,
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 180,
					["quality"] = 1,
					["cast_time"] = 4,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "MONK",
					["spellID"] = 115203,
				},
				["sp_ids"] = {
					115203, -- [1]
				},
				["class"] = "MONK",
				["priority"] = 50,
				["spec"] = 0,
			}, -- [17]
			{
				["spell"] = {
					["type"] = 4,
					["specs"] = {
						1, -- [1]
						2, -- [2]
					},
					["CD"] = 300,
					["quality"] = 1,
					["cast_time"] = 12,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "WARRIOR",
					["spellID"] = 871,
				},
				["sp_ids"] = {
					871, -- [1]
				},
				["class"] = "WARRIOR",
				["priority"] = 50,
				["spec"] = 1,
			}, -- [18]
			{
				["spell"] = {
					["type"] = 4,
					["specs"] = {
						1, -- [1]
						2, -- [2]
					},
					["CD"] = 300,
					["quality"] = 1,
					["cast_time"] = 12,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "WARRIOR",
					["spellID"] = 871,
				},
				["sp_ids"] = {
					871, -- [1]
				},
				["class"] = "WARRIOR",
				["priority"] = 50,
				["spec"] = 2,
			}, -- [19]
			{
				["spell"] = {
					["type"] = 4,
					["specs"] = {
						3, -- [1]
					},
					["CD"] = 120,
					["quality"] = 1,
					["cast_time"] = 12,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "WARRIOR",
					["spellID"] = 871,
				},
				["sp_ids"] = {
					871, -- [1]
				},
				["class"] = "WARRIOR",
				["priority"] = 50,
				["spec"] = 3,
			}, -- [20]
		},
	},
	[hcd_status .. 1] = {
		["spells"] = {
			{
				["spell"] = {
					["type"] = 1,
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 180,
					["quality"] = 1,
					["cast_time"] = 6,
					["class"] = "PALADIN",
					["succ"] = "SPELL_CAST_SUCCESS",
					["spellID"] = 31821,
				},
				["spec"] = 0,
				["sp_ids"] = {
					31821, -- [1]
				},
				["class"] = "PALADIN",
				["priority"] = 50,
			}, -- [1]
			{
				["spell"] = {
					["type"] = 1,
					["specs"] = {
						1, -- [1]
					},
					["CD"] = 180,
					["quality"] = 1,
					["cast_time"] = 10,
					["class"] = "PRIEST",
					["succ"] = "SPELL_CAST_SUCCESS",
					["spellID"] = 62618,
				},
				["sp_ids"] = {
					62618, -- [1]
				},
				["class"] = "PRIEST",
				["priority"] = 50,
				["spec"] = 1,
			}, -- [2]
			{
				["spell"] = {
					["type"] = 2,
					["specs"] = {
						2, -- [1]
					},
					["CD"] = 180,
					["quality"] = 3,
					["cast_time"] = 8,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "PRIEST",
					["spellID"] = 64843,
				},
				["sp_ids"] = {
					64843, -- [1]
				},
				["class"] = "PRIEST",
				["priority"] = 50,
				["spec"] = 2,
			}, -- [3]
			{
				["spell"] = {
					["type"] = 2,
					["specs"] = {
						1, -- [1]
					},
					["CD"] = 480,
					["quality"] = 2,
					["cast_time"] = 8,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "DRUID",
					["spellID"] = 740,
				},
				["sp_ids"] = {
					740, -- [1]
				},
				["class"] = "DRUID",
				["priority"] = 50,
				["spec"] = 1,
			}, -- [4]
			{
				["spell"] = {
					["type"] = 2,
					["specs"] = {
						2, -- [1]
						3, -- [2]
					},
					["CD"] = 480,
					["quality"] = 1,
					["cast_time"] = 8,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "DRUID",
					["spellID"] = 740,
				},
				["sp_ids"] = {
					740, -- [1]
				},
				["class"] = "DRUID",
				["priority"] = 50,
				["spec"] = 2,
			}, -- [5]
			{
				["spell"] = {
					["type"] = 2,
					["specs"] = {
						2, -- [1]
						3, -- [2]
					},
					["CD"] = 480,
					["quality"] = 1,
					["cast_time"] = 8,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "DRUID",
					["spellID"] = 740,
				},
				["sp_ids"] = {
					740, -- [1]
				},
				["class"] = "DRUID",
				["priority"] = 50,
				["spec"] = 3,
			}, -- [6]
			{
				["spell"] = {
					["type"] = 2,
					["specs"] = {
						4, -- [1]
					},
					["CD"] = 180,
					["quality"] = 3,
					["cast_time"] = 8,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "DRUID",
					["spellID"] = 740,
				},
				["sp_ids"] = {
					740, -- [1]
				},
				["class"] = "DRUID",
				["priority"] = 50,
				["spec"] = 4,
			}, -- [7]
			{
				["spell"] = {
					["type"] = 1,
					["specs"] = {
						3, -- [1]
					},
					["CD"] = 180,
					["quality"] = 3,
					["cast_time"] = 6,
					["class"] = "SHAMAN",
					["succ"] = "SPELL_CAST_SUCCESS",
					["spellID"] = 98008,
				},
				["sp_ids"] = {
					98008, -- [1]
				},
				["class"] = "SHAMAN",
				["priority"] = 50,
				["spec"] = 3,
			}, -- [8]
			{
				["spell"] = {
					["type"] = 1,
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 180,
					["quality"] = 1,
					["cast_time"] = 10,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "WARRIOR",
					["spellID"] = 97462,
				},
				["sp_ids"] = {
					97462, -- [1]
				},
				["class"] = "WARRIOR",
				["priority"] = 50,
				["spec"] = 0,
			}, -- [9]
			{
				["spell"] = {
					["specs"] = {
						2, -- [1]
					},
					["CD"] = 180,
					["type"] = 2,
					["quality"] = 1,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "MONK",
					["spellID"] = 115310,
				},
				["sp_ids"] = {
					115310, -- [1]
				},
				["class"] = "MONK",
				["priority"] = 50,
				["spec"] = 2,
			}, -- [10]
		},
	},
	[hcd_status .. 2] = {
		["spells"] = {
			{
				["spell"] = {
					["type"] = 3,
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 360,
					["quality"] = 3,
					["cast_time"] = 8,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "PRIEST",
					["spellID"] = 64901,
				},
				["sp_ids"] = {
					64901, -- [1]
				},
				["class"] = "PRIEST",
				["priority"] = 50,
				["spec"] = 0,
			}, -- [1]
			{
				["spell"] = {
					["type"] = 3,
					["specs"] = {
						3, -- [1]
					},
					["CD"] = 180,
					["quality"] = 3,
					["cast_time"] = 16,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "SHAMAN",
					["spellID"] = 16190,
				},
				["sp_ids"] = {
					16190, -- [1]
				},
				["class"] = "SHAMAN",
				["priority"] = 50,
				["spec"] = 3,
			}, -- [2]
			{
				["spell"] = {
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 600,
					["type"] = 7,
					["quality"] = 3,
					["succ"] = "SPELL_RESURRECT",
					["class"] = "DRUID",
					["spellID"] = 20484,
				},
				["sp_ids"] = {
					20484, -- [1]
				},
				["class"] = "DRUID",
				["priority"] = 50,
				["spec"] = 0,
			}, -- [3]
			{
				["spell"] = {
					["specs"] = {
						1, -- [1]
					},
					["CD"] = 600,
					["class"] = "PALADIN",
					["symb"] = "raid",
					["turn_on"] = true,
					["quality"] = 1,
					["succ"] = "SPELL_RESURRECT",
					["type"] = 7,
					["spellID"] = 113269,
				},
				["sp_ids"] = {
					113269, -- [1]
				},
				["class"] = "PALADIN",
				["priority"] = 50,
				["spec"] = 1,
			}, -- [4]
			{
				["spell"] = {
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 600,
					["type"] = 7,
					["quality"] = 2,
					["succ"] = "SPELL_CAST_SUCCESS",
					["class"] = "DEATHKNIGHT",
					["spellID"] = 61999,
				},
				["sp_ids"] = {
					61999, -- [1]
				},
				["class"] = "DEATHKNIGHT",
				["priority"] = 50,
				["spec"] = 0,
			}, -- [5]
			{
				["spell"] = {
					["specs"] = {
						0, -- [1]
					},
					["CD"] = 900,
					["type"] = 7,
					["quality"] = 1,
					["succ"] = {
						"SPELL_CAST_START", -- [1]
					},
					["class"] = "WARLOCK",
					["spellID"] = 20707,
				},
				["sp_ids"] = {
					20707, -- [1]
				},
				["class"] = "WARLOCK",
				["priority"] = 50,
				["spec"] = 0,
			}, -- [6]
		},
	},
}