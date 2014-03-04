local addonName, addon = ...
addon.L = addon.L or {} --setup localization
local L = setmetatable(addon.L, {__index = function(t,i) return i end} )

local colorMap = {
	["1"] = "|cff000000"..L.Black,
	["2"] = "|cff0000ff"..L.Blue,
	["3"] = "|cff00ff00"..L.Green,
	["4"] = "|cffff00ff"..L.Purple,
	["5"] = "|cffff0000"..L.Red,
	["6"] = "|cffffff00"..L.Yellow,
}

local defaults = {
	global = {
		["enabled"] = true,
		["announces"] = {
			yell = true,
			raid = false,
			raidWarning = true,
			privateRaidWarning = false,
			privateChatMessage = false,
		},
		["priorities"] = {
			["lfr"] = { --Looking for raid mode combos:
				["126"] = L.Yellow, --Black, Blue, Yellow
				["135"] = L.Green, --Black, Green, Red
				["145"] = L.Purple, --Black, Purple, Red
				["234"] = L.Purple, --Blue, Green, Purple
				["246"] = L.Purple, --Blue, Purple, Yellow
				["356"] = L.Green, --Green, Red, Yellow
			},
			["normal"] = { --Normal mode combos:		
				["126"] = L.Yellow, --Black, Blue, Yellow
				["135"] = L.Green, --Black, Green, Red
				["145"] = L.Purple, --Black, Purple, Red
				["234"] = L.Purple, --Blue, Green, Purple
				["246"] = L.Purple, --Blue, Purple, Yellow
				["356"] = L.Green, --Green, Red, Yellow
			},
			["heroic"] = { --Heroic mode combos:
				["1234"] = L.Green, --Black, Blue, Green, Purple
				["1235"] = L.Green, --Black, Blue, Green, Red
				["1246"] = L.Yellow, --Black, Blue, Purple, Yellow
				["1356"] = L.Green, --Black, Green, Red, Yellow
				["1456"] = L.Purple, --Black, Purple, Red, Yellow
				["2346"] = L.Yellow, --Blue, Green, Purple, Yellow
			},
		},
		["modesEnabled"] = {
			["lfr"] = true,
			["normal"] = true,
			["heroic"] = true,
		},
	},
}

local optionsTable = {
    name = addonName,
    handler = addon,
    type = 'group',
    args = {
		enable = {
			name = L.Enable,
			desc = L["Enable/disable announces for all raid difficulties. This setting overrides any enable/disable setting for indiviual raid difficulties."],
			type = 'toggle',
			order = 1,
			set = function(_, enabled)
				addon.db.global.enabled = enabled
				if enabled then
					addon:Enable()
				else
					addon:Disable()
				end
			end,
			get = function() return addon.db.global.enabled end,
		},
		reset = {
			name = L['Restore Defaults'],
			desc = L['Restore all combinations to default kill targets.'],
			type = 'execute',
			order = 2,
			func = function()
				addon.db:ResetDB()
			end,
		},
		priorities = {
			name = L['Kill Priorities'],
			desc = L['Setup globule kill priorities.'],
			type = 'group',
			order = 3,
			args = {
				lfr = {
					type = 'group',
					name = L['Looking For Raid'],
					desc = L['Setup priorities for LFR mode combinations.'],
					order = 1,
					args = {
						Header = {
							type = 'header',
							name = L['Looking For Raid Mode Globule Combinations'],
							order = 1,
						},
					},
				},
				normal = {
					type = 'group',
					name = L['Normal'],
					desc = L['Setup priorities for normal mode combinations.'],
					order = 2,
					args = {
						Header = {
							type = 'header',
							name = L['Normal Mode Globule Combinations'],
							order = 1,
						},
					},
				},
				heroic = {
					type = 'group',
					name = L['Heroic'],
					desc = L['Setup priorities for heroic mode combinations.'],
					order = 3,
					args = {
						Header = {
							type = 'header',
							name = L['Heroic Mode Globule Combinations'],
							order = 1,
						},
					},
				},
			},
		},
		output = {
			name = L.Output,
			desc = L['Setup where output messages are sent.'],
			type = 'group',
			order = 4,
			args = {
				yell = {
					name = L.Yell,
					type = 'toggle',
					order = 1,
					set = function(_, enabled)
						addon.db.global.announces.yell = enabled
					end,
					get = function() return addon.db.global.announces.yell end,
				},
				raid = {
					name = L.Raid,
					type = 'toggle',
					order = 2,
					set = function(_, enabled)
						addon.db.global.announces.raid = enabled
					end,
					get = function() return addon.db.global.announces.raid end,
				},
				raidWarning = {
					name = L['Raid Warning'],
					type = 'toggle',
					order = 3,
					set = function(_, enabled)
						addon.db.global.announces.raidWarning = enabled
					end,
					get = function() return addon.db.global.announces.raidWarning end,
				},
				privateRaidWarning = {
					name = L['Private Raid Warning'],
					type = 'toggle',
					order = 4,
					set = function(_, enabled)
						addon.db.global.announces.privateRaidWarning = enabled
					end,
					get = function() return addon.db.global.announces.privateRaidWarning end,
				},
				privateChatMessage = {
					name = L['Private Chat Message'],
					type = 'toggle',
					order = 5,
					set = function(_, enabled)
						addon.db.global.announces.privateChatMessage = enabled
					end,
					get = function() return addon.db.global.announces.privateChatMessage end,
				},
			},
		},
    },
}

local function CreateOptionsSetting(mode, numberString)
	local nameString = ""
	for i = 1,numberString:len() do
		nameString = nameString..colorMap[numberString:sub(i,i)].." "
	end
	local optionTable = {
		type = 'input',
		name = nameString,
		set = function(_, value)
			addon.db.global.priorities[mode][numberString] = value
		end,
		get = function() return addon.db.global.priorities[mode][numberString] end,
	}
	return optionTable
end

function addon:SetupDB()
	self.db = LibStub("AceDB-3.0"):New("YorsahjPriorityDB", defaults)
end

function addon:SetupOptions()
	for mode,prioritiesTable in pairs(defaults.global.priorities) do --Create mode settings tables
		optionsTable.args.priorities.args[mode].args.enable = {
			name = L.Enable,
			desc = L["Enable/disable announces for this raid difficulty only."],
			type = 'toggle',
			order = 0,
			order = 1,
			set = function(_, enabled)
				addon.db.global.modesEnabled[mode] = enabled
			end,
			get = function() return addon.db.global.modesEnabled[mode] end,
		}
		for numberString,killPriority in pairs(prioritiesTable) do
			optionsTable.args.priorities.args[mode].args[numberString] = CreateOptionsSetting(mode, numberString)
		end
	end
	LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, optionsTable)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName)
end