
WeakAurasSaved = {
	["displays"] = {
		["TCD: Demo"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["stacksPoint"] = "RIGHT",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
				["spellName"] = 1160,
			},
			["yOffset"] = 0,
			["anchorPoint"] = "CENTER",
			["parent"] = "Tank CDs Long",
			["xOffset"] = 0,
			["inverse"] = true,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["unit"] = "player",
				["event"] = "Cooldown Progress (Spell)",
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
				["use_spellName"] = true,
				["unevent"] = "auto",
				["use_unit"] = true,
				["itemName"] = 0,
				["spellName"] = 1160,
				["use_itemName"] = true,
				["custom_hide"] = "timed",
			},
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "TCD: Demo",
			["desaturate"] = false,
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["width"] = 30,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["height"] = 30,
			["regionType"] = "icon",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Ra-Den Energy"] = {
			["textFlags"] = "None",
			["stacksSize"] = 12,
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = 16.49981689453125,
			["stacksFlags"] = "None",
			["untrigger"] = {
				["unit"] = "focus",
				["use_unit"] = true,
			},
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "update",
			["rotateText"] = "NONE",
			["displayTextLeft"] = "Ra-Den's Energy",
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "status",
				["unevent"] = "auto",
				["use_power"] = false,
				["event"] = "Power",
				["unit"] = "focus",
				["powertype"] = 3,
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["use_unit"] = true,
				["subeventSuffix"] = "_CAST_START",
				["use_powertype"] = true,
				["debuffType"] = "HELPFUL",
			},
			["text"] = true,
			["barColor"] = {
				1, -- [1]
				0, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["actions"] = {
				["start"] = {
					["do_sound"] = false,
				},
				["finish"] = {
				},
			},
			["stickyDuration"] = false,
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["height"] = 40,
			["timer"] = true,
			["timerFlags"] = "None",
			["load"] = {
				["zone"] = "Throne of Thunder",
				["use_role"] = true,
				["class"] = {
					["multi"] = {
					},
				},
				["difficulty"] = "heroic",
				["use_zone"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["use_difficulty"] = true,
				["role"] = {
					["single"] = "TANK",
					["multi"] = {
						["TANK"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["barInFront"] = true,
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["inverse"] = false,
			["yOffset"] = -91.25027465820313,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["borderOffset"] = 5,
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "aurabar",
			["borderSize"] = 16,
			["frameStrata"] = 1,
			["icon_side"] = "RIGHT",
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["id"] = "Ra-Den Energy",
			["auto"] = true,
			["texture"] = "Blizzard",
			["textFont"] = "Friz Quadrata TT",
			["stacksFont"] = "Friz Quadrata TT",
			["timerSize"] = 18,
			["displayTextRight"] = "%p",
			["additional_triggers"] = {
				{
					["trigger"] = {
						["type"] = "status",
						["unevent"] = "auto",
						["event"] = "Unit Characteristics",
						["subeventPrefix"] = "SPELL",
						["use_name"] = true,
						["name"] = "Ra-Den",
						["unit"] = "target",
						["subeventSuffix"] = "_CAST_START",
						["use_unit"] = true,
					},
					["untrigger"] = {
						["unit"] = "target",
					},
				}, -- [1]
			},
			["timerFont"] = "Friz Quadrata TT",
			["alpha"] = 1,
			["width"] = 400,
			["stacks"] = true,
			["borderInset"] = 11,
			["numTriggers"] = 2,
			["textSize"] = 15,
			["orientation"] = "HORIZONTAL",
			["displayIcon"] = "Interface\\Icons\\Ability_Defend",
			["icon"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Rogue Smoke Bomb"] = {
			["xOffset"] = 0,
			["customText"] = "function(...)\n    local GetAuraSourceName = function(aura)\n        local RAID_SIZE = 25 -- CHANGE THIS        \n        if not aura then return end\n        local auraName = aura\n        if type(aura) == 'number' then auraName = GetSpellInfo(aura) end\n        for i=1,RAID_SIZE do\n            local unitCaster = select(8, UnitAura('raid'..i, auraName))\n            if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n        end    \n        local unitCaster = select(8, UnitAura('player', auraName))\n        if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n    end\n    \n    return GetAuraSourceName(select(5, ...))    \nend",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "event",
			["actions"] = {
				["start"] = {
					["do_glow"] = true,
					["glow_action"] = "show",
					["message_type"] = "RAID",
					["glow_frame"] = "WeakAuras:Rogue Smoke Bomb",
					["do_message"] = false,
					["message"] = "",
				},
				["finish"] = {
					["message"] = "",
					["message_type"] = "RAID",
					["do_message"] = false,
					["do_sound"] = false,
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["name_info"] = "aura",
				["names"] = {
					"Smoke Bomb", -- [1]
				},
				["debuffType"] = "HARMFUL",
				["group_countOperator"] = ">=",
				["subeventPrefix"] = "SPELL",
				["group_count"] = "2",
				["unit"] = "player",
				["event"] = "Health",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 60,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 19,
			["displayStacks"] = "  (%p) %n - %c",
			["regionType"] = "icon",
			["parent"] = "Raid Cooldowns Thok",
			["cooldown"] = true,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["icon"] = true,
			["id"] = "Rogue Smoke Bomb",
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 60,
			["yOffset"] = 0,
			["numTriggers"] = 1,
			["inverse"] = false,
			["stickyDuration"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["additional_triggers"] = {
			},
			["stacksPoint"] = "RIGHT",
			["textColor"] = {
				0.2549019607843137, -- [1]
				1, -- [2]
				0.01176470588235294, -- [3]
				1, -- [4]
			},
		},
		["Malkorok - Ancient Barrier"] = {
			["fontSize"] = 16,
			["displayStacks"] = "%c",
			["regionType"] = "icon",
			["xOffset"] = 165.9999389648438,
			["stacksPoint"] = "BOTTOMRIGHT",
			["customText"] = "function()\n    local i,name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1,value2;\n    for i = 1, 40 do\n        name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1,value2 = UnitAura(\"player\", i, \"HARMFUL\");\n        if (name == \"Ancient Barrier\" or name == \"Weak Ancient Barrier\" or name == \"Strong Ancient Barrier\") then\n            return value2;\n        end\n    end\n    return \"Nope\";\nend\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["yOffset"] = -24.50006103515625,
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["customTextUpdate"] = "update",
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["trigger"] = {
				["debuffType"] = "HARMFUL",
				["type"] = "aura",
				["custom_hide"] = "timed",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Ancient Barrier", -- [1]
					"Weak Ancient Barrier", -- [2]
					"Strong Ancient Barrier", -- [3]
				},
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["additional_triggers"] = {
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["width"] = 64,
			["font"] = "Friz Quadrata TT",
			["inverse"] = false,
			["id"] = "Malkorok - Ancient Barrier",
			["height"] = 64,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Tank CDs Long"] = {
			["grow"] = "UP",
			["controlledChildren"] = {
				"TCD: SW", -- [1]
				"TCD: DB", -- [2]
				"TCD: RC", -- [3]
				"TCD: Mocking", -- [4]
				"TCD: Spell Reflection", -- [5]
				"TCD: Demo", -- [6]
				"TCD: Last Stand", -- [7]
				"TCD: Vigilance", -- [8]
				"TCD: Disrupting Shout", -- [9]
				"TCD: Rook", -- [10]
			},
			["animate"] = true,
			["xOffset"] = 284.9987182617188,
			["border"] = "None",
			["yOffset"] = -160,
			["anchorPoint"] = "CENTER",
			["untrigger"] = {
			},
			["sort"] = "ascending",
			["expanded"] = false,
			["space"] = 2,
			["background"] = "None",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["constantFactor"] = "RADIUS",
			["selfPoint"] = "BOTTOMLEFT",
			["borderOffset"] = 16,
			["align"] = "LEFT",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["names"] = {
				},
				["type"] = "aura",
				["debuffType"] = "HELPFUL",
				["unit"] = "player",
			},
			["backgroundInset"] = 0,
			["frameStrata"] = 1,
			["width"] = 30,
			["rotation"] = 0,
			["radius"] = 200,
			["numTriggers"] = 1,
			["stagger"] = 0,
			["height"] = 317.9999694824219,
			["id"] = "Tank CDs Long",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "dynamicgroup",
		},
		["Sha of Pride - Projection"] = {
			["parent"] = "SoO 1st Part",
			["fontSize"] = 24,
			["displayStacks"] = "Find Projection: %p",
			["stacksPoint"] = "BOTTOM",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["regionType"] = "icon",
			["additional_triggers"] = {
			},
			["yOffset"] = 166,
			["anchorPoint"] = "CENTER",
			["actions"] = {
				["start"] = {
					["message"] = "To the Arrow!",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_message"] = true,
				},
				["finish"] = {
				},
			},
			["numTriggers"] = 1,
			["selfPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["id"] = "Sha of Pride - Projection",
			["icon"] = true,
			["stickyDuration"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["debuffType"] = "HARMFUL",
				["type"] = "aura",
				["names"] = {
					"Projection", -- [1]
				},
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["xOffset"] = 620,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Arial Narrow",
			["inverse"] = false,
			["width"] = 64,
			["height"] = 64,
			["untrigger"] = {
			},
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_zone"] = true,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				0.9725490196078431, -- [1]
				1, -- [2]
				0.984313725490196, -- [3]
				1, -- [4]
			},
		},
		["LC"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["xOffset"] = 170,
			["cooldown"] = true,
			["regionType"] = "icon",
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["parent"] = "Tank Def Buffs",
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["inverse"] = false,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["trigger"] = {
				["unit"] = "player",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Life Cocoon", -- [1]
				},
				["debuffType"] = "HELPFUL",
				["event"] = "Health",
				["custom_hide"] = "timed",
			},
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "LC",
			["desaturate"] = false,
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["width"] = 30,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["height"] = 30,
			["untrigger"] = {
			},
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["LS Stacks"] = {
			["outline"] = true,
			["fontSize"] = 72,
			["color"] = {
				0.3607843137254902, -- [1]
				0.580392156862745, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayText"] = "%s",
			["yOffset"] = 274.9996337890625,
			["regionType"] = "text",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["anchorPoint"] = "CENTER",
			["justify"] = "LEFT",
			["selfPoint"] = "BOTTOM",
			["additional_triggers"] = {
			},
			["id"] = "LS Stacks",
			["frameStrata"] = 1,
			["width"] = 18.61504173278809,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["font"] = "Accidental Presidency",
			["numTriggers"] = 1,
			["xOffset"] = 242.9994506835938,
			["height"] = 34.99999237060547,
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["countOperator"] = ">=",
				["unit"] = "focus",
				["useCount"] = true,
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Scary Fog", -- [1]
				},
				["event"] = "Health",
				["debuffType"] = "HARMFUL",
			},
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["use_combat"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
		},
		["Mass Ress"] = {
			["outline"] = true,
			["fontSize"] = 12,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayText"] = "Mass Rez - %c\n",
			["customText"] = "function()\n    \n    return string.format(\"1\")\nend\n\n\n\n\n\n\n\n",
			["yOffset"] = -128.250244140625,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["justify"] = "LEFT",
			["selfPoint"] = "BOTTOM",
			["trigger"] = {
				["type"] = "aura",
				["unit"] = "player",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["regionType"] = "text",
			["frameStrata"] = 1,
			["width"] = 76.79994201660156,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["id"] = "Mass Ress",
			["height"] = 23.99999237060547,
			["xOffset"] = 1658.250122070313,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["use_combat"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
		},
		["Tank CDs 3"] = {
			["grow"] = "UP",
			["controlledChildren"] = {
				"TCD: Charge", -- [1]
				"TCD: Intervene", -- [2]
				"TCD: Heroic Leap", -- [3]
			},
			["animate"] = false,
			["xOffset"] = 415,
			["border"] = "None",
			["yOffset"] = -160,
			["anchorPoint"] = "CENTER",
			["untrigger"] = {
			},
			["sort"] = "ascending",
			["expanded"] = false,
			["space"] = 2,
			["background"] = "None",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["constantFactor"] = "RADIUS",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["borderOffset"] = 16,
			["align"] = "LEFT",
			["selfPoint"] = "BOTTOMLEFT",
			["id"] = "Tank CDs 3",
			["backgroundInset"] = 0,
			["frameStrata"] = 1,
			["width"] = 30,
			["stagger"] = 0,
			["radius"] = 200,
			["numTriggers"] = 1,
			["rotation"] = 0,
			["height"] = 94,
			["trigger"] = {
				["names"] = {
				},
				["type"] = "aura",
				["debuffType"] = "HELPFUL",
				["unit"] = "player",
			},
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "dynamicgroup",
		},
		["TCD: Mocking"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["cooldown"] = true,
			["regionType"] = "icon",
			["untrigger"] = {
				["spellName"] = 114192,
			},
			["anchorPoint"] = "CENTER",
			["yOffset"] = 0,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["icon"] = true,
			["width"] = 30,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["use_itemName"] = true,
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["spellName"] = 114192,
				["use_spellName"] = true,
				["itemName"] = 0,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "TCD: Mocking",
			["font"] = "DorisPP",
			["inverse"] = true,
			["xOffset"] = 0,
			["height"] = 30,
			["parent"] = "Tank CDs Long",
			["stacksPoint"] = "RIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Rallying Cry"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["cooldown"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
			["yOffset"] = 20,
			["regionType"] = "icon",
			["xOffset"] = 170,
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["width"] = 30,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Rallying Cry", -- [1]
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "Rallying Cry",
			["font"] = "DorisPP",
			["inverse"] = false,
			["parent"] = "Tank Def Buffs",
			["height"] = 30,
			["anchorPoint"] = "CENTER",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Ultimatum"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["stacksPoint"] = "BOTTOM",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["anchorPoint"] = "CENTER",
			["yOffset"] = 20,
			["regionType"] = "icon",
			["xOffset"] = 108,
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["inverse"] = false,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["id"] = "TCD: Ultimatum",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["unit"] = "player",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Ultimatum", -- [1]
				},
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 30,
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["parent"] = "Tank CDs",
			["height"] = 30,
			["untrigger"] = {
			},
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["SoO 1st Part"] = {
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["controlledChildren"] = {
				"Immerseus - Swelling Corruption", -- [1]
				"Immerseus - Swirl", -- [2]
				"Protectors - Mark of Anguish", -- [3]
				"Protectors - Noxious Poison", -- [4]
				"Protectors - Sha Sear", -- [5]
				"Protectors - Poison Cloud", -- [6]
				"Norushen - Residual Corruption", -- [7]
				"Sha of Pride - Aura of Pride", -- [8]
				"Sha of Pride - Bursting Pride", -- [9]
				"Sha of Pride - Gift of the Titans", -- [10]
				"Sha of Pride - Power of the Titans", -- [11]
				"Sha of Pride - Projection", -- [12]
				"Sha of Pride - Swelling Pride", -- [13]
				"Sha of Pride - Weakened Resolve Rift", -- [14]
				"Galakras - Burning Blood", -- [15]
				"Galakras - Flame Arrows", -- [16]
				"Galakras - Flames of Galakrond", -- [17]
				"Galakras - Stacks", -- [18]
				"Iron Juggernaut - Locked On", -- [19]
				"Dark Shamans - Ashen Wall", -- [20]
				"Dark Shamans - Falling Ash", -- [21]
				"Dark Shamans - Falling Ash Warning", -- [22]
				"Dark Shamans - Froststorm Strike", -- [23]
				"Dark Shamans - Froststorm Strike 2nd Tank", -- [24]
				"Dark Shamans - Froststorm Strike Timer", -- [25]
				"Dark Shamans - Iron Prison", -- [26]
			},
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = -171.2194213867188,
			["border"] = false,
			["yOffset"] = -13.42041015625,
			["regionType"] = "group",
			["borderSize"] = 16,
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["expanded"] = false,
			["borderOffset"] = 5,
			["selfPoint"] = "BOTTOMLEFT",
			["id"] = "SoO 1st Part",
			["anchorPoint"] = "CENTER",
			["frameStrata"] = 1,
			["additional_triggers"] = {
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["borderInset"] = 11,
			["numTriggers"] = 1,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["unit"] = "player",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["borderEdge"] = "None",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
		},
		["GS"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["parent"] = "Tank Def Buffs",
			["cooldown"] = true,
			["anchorPoint"] = "CENTER",
			["yOffset"] = 20,
			["regionType"] = "icon",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["inverse"] = false,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["id"] = "GS",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["unit"] = "player",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Guardian Spirit", -- [1]
				},
				["debuffType"] = "HELPFUL",
				["event"] = "Health",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 30,
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["xOffset"] = 170,
			["height"] = 30,
			["untrigger"] = {
			},
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Vigilance"] = {
			["user_y"] = 0,
			["user_x"] = 0,
			["xOffset"] = -354,
			["displayText"] = "%p",
			["yOffset"] = 75.0001220703125,
			["foregroundColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["desaturateBackground"] = false,
			["sameTexture"] = true,
			["backgroundColor"] = {
				0.5, -- [1]
				0.5, -- [2]
				0.5, -- [3]
				0.5, -- [4]
			},
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["sourceunit"] = "player",
				["duration"] = "12",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
				["type"] = "event",
				["unevent"] = "timed",
				["subeventSuffix"] = "_AURA_APPLIED",
				["event"] = "Combat Log",
				["custom_hide"] = "timed",
				["custom_type"] = "event",
				["use_spellName"] = true,
				["events"] = "SPELL_CAST_SUCCESS",
				["use_sourceunit"] = true,
				["use_destunit"] = false,
				["spellName"] = "Vigilance",
				["unit"] = "player",
				["subeventPrefix"] = "SPELL",
			},
			["stickyDuration"] = false,
			["rotation"] = 0,
			["font"] = "DorisPP",
			["height"] = 39.00000381469727,
			["load"] = {
				["use_name"] = false,
				["role"] = {
					["multi"] = {
					},
				},
				["use_class"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 39,
			["foregroundTexture"] = "Textures\\SpellActivationOverlays\\Eclipse_Sun",
			["mirror"] = false,
			["regionType"] = "text",
			["blendMode"] = "BLEND",
			["customTextUpdate"] = "update",
			["outline"] = true,
			["color"] = {
				0.2901960784313725, -- [1]
				0.9686274509803922, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
			},
			["actions"] = {
				["start"] = {
					["sound"] = "Sound\\interface\\iTellMessage.wav",
					["do_sound"] = false,
				},
				["finish"] = {
				},
			},
			["inverse"] = false,
			["crop_y"] = 0.41,
			["justify"] = "CENTER",
			["compress"] = false,
			["id"] = "Vigilance",
			["frameStrata"] = 1,
			["alpha"] = 1,
			["width"] = 63.37502670288086,
			["backgroundTexture"] = "Textures\\SpellActivationOverlays\\Eclipse_Sun",
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "slidebottom",
					["duration_type"] = "seconds",
				},
			},
			["numTriggers"] = 1,
			["desaturateForeground"] = false,
			["orientation"] = "VERTICAL",
			["crop_x"] = 0.41,
			["anchorPoint"] = "CENTER",
			["backgroundOffset"] = 2,
		},
		["Protectors - Noxious Poison"] = {
			["xOffset"] = 490,
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["names"] = {
					"Noxious Poison", -- [1]
				},
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HARMFUL",
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["cooldown"] = true,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["do_message"] = false,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
				},
				["finish"] = {
				},
			},
			["id"] = "Protectors - Noxious Poison",
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 64,
			["yOffset"] = 166,
			["numTriggers"] = 1,
			["inverse"] = false,
			["selfPoint"] = "CENTER",
			["additional_triggers"] = {
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Tricks of the Trade Group"] = {
			["grow"] = "RIGHT",
			["controlledChildren"] = {
				"Tricks 2", -- [1]
			},
			["animate"] = false,
			["xOffset"] = -635.0000610351563,
			["untrigger"] = {
			},
			["border"] = "None",
			["yOffset"] = 191.0001220703125,
			["anchorPoint"] = "CENTER",
			["expanded"] = true,
			["sort"] = "none",
			["additional_triggers"] = {
			},
			["space"] = 2,
			["background"] = "None",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["constantFactor"] = "RADIUS",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["borderOffset"] = 16,
			["align"] = "CENTER",
			["selfPoint"] = "LEFT",
			["trigger"] = {
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["radius"] = 200,
			["frameStrata"] = 1,
			["width"] = 64.00000190734863,
			["rotation"] = 0,
			["stagger"] = 0,
			["numTriggers"] = 1,
			["id"] = "Tricks of the Trade Group",
			["height"] = 64.00006103515625,
			["backgroundInset"] = 0,
			["load"] = {
				["class"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "dynamicgroup",
		},
		["Bloodbath"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["cooldown"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["xOffset"] = 0,
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["stickyDuration"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["id"] = "Bloodbath",
			["width"] = 30,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Bloodbath", -- [1]
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["font"] = "DorisPP",
			["inverse"] = false,
			["parent"] = "Tank DPS Buffs",
			["height"] = 30,
			["regionType"] = "icon",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Taunt"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
				["spellName"] = 355,
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["names"] = {
					"Shield Block", -- [1]
				},
				["use_spellName"] = true,
				["subeventPrefix"] = "SPELL",
				["unevent"] = "auto",
				["use_unit"] = true,
				["use_remaining"] = false,
				["spellName"] = 355,
				["custom_hide"] = "timed",
			},
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["height"] = 30,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["desaturate"] = false,
			["stacksPoint"] = "BOTTOM",
			["icon"] = true,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["additional_triggers"] = {
			},
			["id"] = "TCD: Taunt",
			["frameStrata"] = 1,
			["width"] = 30,
			["numTriggers"] = 1,
			["yOffset"] = 20,
			["inverse"] = true,
			["disjunctive"] = true,
			["xOffset"] = -16,
			["parent"] = "Tank CDs",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Weakened"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["fontSize"] = 12,
			["displayStacks"] = "%s",
			["cooldown"] = true,
			["xOffset"] = 1.5001220703125,
			["yOffset"] = -96.75003051757813,
			["regionType"] = "icon",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["stacksPoint"] = "BOTTOMRIGHT",
			["inverse"] = false,
			["desaturate"] = false,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["stickyDuration"] = false,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "preset",
					["preset"] = "pulse",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["additional_triggers"] = {
				{
					["trigger"] = {
						["type"] = "status",
						["use_hostility"] = true,
						["subeventSuffix"] = "_CAST_START",
						["level_operator"] = "<",
						["event"] = "Unit Characteristics",
						["use_unit"] = true,
						["use_level"] = true,
						["character"] = "npc",
						["subeventPrefix"] = "SPELL",
						["hostility"] = "hostile",
						["use_character"] = true,
						["level"] = "90",
						["unevent"] = "auto",
						["unit"] = "target",
					},
					["untrigger"] = {
						["unit"] = "target",
					},
				}, -- [1]
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Health",
				["unit"] = "target",
				["inverse"] = true,
				["subeventPrefix"] = "SPELL",
				["remOperator"] = "<=",
				["rem"] = "5",
				["names"] = {
					"Weakened Blows", -- [1]
				},
				["debuffType"] = "HARMFUL",
			},
			["frameStrata"] = 1,
			["width"] = 64,
			["id"] = "Weakened",
			["font"] = "DorisPP",
			["numTriggers"] = 2,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["height"] = 64,
			["displayIcon"] = "Interface\\Icons\\INV_Relics_TotemofRage",
			["load"] = {
				["use_name"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["name"] = "Git",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Stuns"] = {
			["grow"] = "DOWN",
			["controlledChildren"] = {
				"Shockwave", -- [1]
				"Leg Sweep", -- [2]
			},
			["animate"] = false,
			["xOffset"] = -421.5001831054688,
			["border"] = "None",
			["yOffset"] = 291.7498779296875,
			["anchorPoint"] = "CENTER",
			["regionType"] = "dynamicgroup",
			["sort"] = "none",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["space"] = 2,
			["background"] = "None",
			["expanded"] = false,
			["constantFactor"] = "RADIUS",
			["id"] = "Stuns",
			["borderOffset"] = 16,
			["trigger"] = {
				["unit"] = "player",
				["type"] = "aura",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
			},
			["selfPoint"] = "TOP",
			["align"] = "CENTER",
			["stagger"] = 0,
			["frameStrata"] = 1,
			["width"] = 105.2499389648438,
			["rotation"] = 0,
			["radius"] = 200,
			["numTriggers"] = 1,
			["backgroundInset"] = 0,
			["height"] = 211.0002136230469,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["load"] = {
				["class"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
		},
		["Devo Plague 2"] = {
			["stacksPoint"] = "BOTTOM",
			["fontSize"] = 12,
			["displayStacks"] = "%s",
			["cooldown"] = false,
			["xOffset"] = -80,
			["untrigger"] = {
				["spellName"] = 8092,
			},
			["anchorPoint"] = "CENTER",
			["yOffset"] = -140,
			["regionType"] = "icon",
			["parent"] = "Shadow Priest",
			["inverse"] = false,
			["actions"] = {
				["start"] = {
					["do_custom"] = true,
				},
				["finish"] = {
				},
			},
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["duration_type"] = "seconds",
					["preset"] = "fade",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["duration_type"] = "seconds",
					["preset"] = "fade",
				},
			},
			["icon"] = true,
			["desaturate"] = true,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["id"] = "Devo Plague 2",
			["trigger"] = {
				["type"] = "status",
				["debuffType"] = "HELPFUL",
				["power"] = "2",
				["power_operator"] = "==",
				["use_power"] = true,
				["event"] = "Shadow Orbs",
				["unit"] = "player",
				["subeventSuffix"] = "_CAST_START",
				["use_spellName"] = true,
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
				["unevent"] = "auto",
				["use_unit"] = true,
				["spellName"] = 8092,
				["custom_hide"] = "timed",
			},
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["width"] = 40,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["color"] = {
				0.9254901960784314, -- [1]
				1, -- [2]
				0.9294117647058824, -- [3]
				1, -- [4]
			},
			["height"] = 40,
			["displayIcon"] = "Interface\\Icons\\Spell_Shadow_DevouringPlague.",
			["load"] = {
				["use_name"] = false,
				["role"] = {
					["multi"] = {
					},
				},
				["name"] = "Spih",
				["use_class"] = true,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["class"] = {
					["single"] = "PRIEST",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				0.9725490196078431, -- [1]
				1, -- [2]
				0.02352941176470588, -- [3]
				1, -- [4]
			},
		},
		["Nazgrim - Defensive Stance Inc Warning 2"] = {
			["textFlags"] = "None",
			["stacksSize"] = 24,
			["xOffset"] = 702.0003051757813,
			["displayText"] = "",
			["yOffset"] = 150.0003051757813,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["rotateText"] = "NONE",
			["icon"] = true,
			["selfPoint"] = "CENTER",
			["barColor"] = {
				1, -- [1]
				0, -- [2]
				0.1372549019607843, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["font"] = "Friz Quadrata TT",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["regionType"] = "text",
			["stacks"] = true,
			["texture"] = "Blizzard",
			["textFont"] = "Friz Quadrata TT",
			["zoom"] = 0,
			["auto"] = true,
			["timerFont"] = "Friz Quadrata TT",
			["alpha"] = 1,
			["borderInset"] = 11,
			["displayIcon"] = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["outline"] = true,
			["borderBackdrop"] = "Blizzard Tooltip",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["barInFront"] = true,
			["customTextUpdate"] = "update",
			["textSize"] = 12,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "event",
				["source"] = "General Nazgrim",
				["subeventSuffix"] = "_AURA_APPLIED",
				["custom_hide"] = "timed",
				["duration"] = "55",
				["event"] = "Combat Log",
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Defensive Stance", -- [1]
				},
				["use_spellName"] = true,
				["use_source"] = true,
				["specificUnit"] = "boss1",
				["unevent"] = "timed",
				["spellName"] = "Berserker Stance",
				["unit"] = "member",
				["debuffType"] = "HELPFUL",
			},
			["text"] = true,
			["stickyDuration"] = false,
			["timer"] = true,
			["timerFlags"] = "None",
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["fontSize"] = 12,
			["displayStacks"] = "Face assassin: %s",
			["border"] = false,
			["borderEdge"] = "None",
			["borderSize"] = 16,
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["icon_side"] = "RIGHT",
			["actions"] = {
				["start"] = {
					["message"] = "Defensive Stance in 5, STOP DPS NOW!",
					["do_sound"] = false,
					["message_type"] = "SAY",
					["do_message"] = false,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
				},
				["finish"] = {
					["message"] = "Defensive Stance in 5, STOP DPS NOW!",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_message"] = true,
				},
			},
			["borderOffset"] = 5,
			["justify"] = "LEFT",
			["additional_triggers"] = {
			},
			["stacksContainment"] = "OUTSIDE",
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayTextRight"] = "%p",
			["numTriggers"] = 1,
			["id"] = "Nazgrim - Defensive Stance Inc Warning 2",
			["height"] = 0.9999997019767761,
			["frameStrata"] = 1,
			["width"] = 0.9999997019767761,
			["stacksFont"] = "Friz Quadrata TT",
			["displayTextLeft"] = "Defensive Stance in:",
			["inverse"] = false,
			["timerSize"] = 24,
			["orientation"] = "HORIZONTAL",
			["stacksFlags"] = "None",
			["cooldown"] = true,
			["untrigger"] = {
			},
		},
		["Acceleration"] = {
			["outline"] = true,
			["fontSize"] = 72,
			["color"] = {
				1, -- [1]
				0.09411764705882353, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["displayText"] = "%s",
			["yOffset"] = -220.4936218261719,
			["regionType"] = "text",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["xOffset"] = -245.000732421875,
			["justify"] = "LEFT",
			["selfPoint"] = "BOTTOMRIGHT",
			["additional_triggers"] = {
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Health",
				["names"] = {
					"Acceleration", -- [1]
				},
				["specificUnit"] = "boss1",
				["debuffType"] = "HELPFUL",
				["unit"] = "member",
				["subeventPrefix"] = "SPELL",
				["custom_hide"] = "timed",
			},
			["frameStrata"] = 1,
			["width"] = 47.25000762939453,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["anchorPoint"] = "CENTER",
			["height"] = 72,
			["id"] = "Acceleration",
			["load"] = {
				["use_name"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = false,
				["name"] = "Git",
				["use_combat"] = true,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
		},
		["Vigil"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["cooldown"] = true,
			["parent"] = "Tank Def Buffs",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
			["yOffset"] = 20,
			["regionType"] = "icon",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["width"] = 30,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Vigilance", -- [1]
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "Vigil",
			["font"] = "DorisPP",
			["inverse"] = false,
			["xOffset"] = 170,
			["height"] = 30,
			["anchorPoint"] = "CENTER",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Immerseus - Swirl"] = {
			["outline"] = true,
			["fontSize"] = 36,
			["xOffset"] = 135,
			["displayText"] = "SWIRL!",
			["untrigger"] = {
				["unit"] = "focus",
			},
			["regionType"] = "text",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_sound"] = true,
				},
				["finish"] = {
				},
			},
			["disjunctive"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["additional_triggers"] = {
				{
					["trigger"] = {
						["type"] = "status",
						["subeventSuffix"] = "_CAST_START",
						["event"] = "Cast",
						["subeventPrefix"] = "SPELL",
						["use_spell"] = true,
						["use_unit"] = true,
						["spell"] = "Swirl",
						["unevent"] = "auto",
						["unit"] = "boss1",
						["use_specific_unit"] = true,
					},
					["untrigger"] = {
						["unit"] = "boss1",
						["use_specific_unit"] = true,
					},
				}, -- [1]
			},
			["justify"] = "LEFT",
			["selfPoint"] = "BOTTOM",
			["trigger"] = {
				["source"] = "Immerseus",
				["use_spell"] = true,
				["unit"] = "focus",
				["spellName"] = "Swirl",
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["use_source"] = false,
				["event"] = "Cast",
				["custom_hide"] = "timed",
				["use_unit"] = true,
				["use_spellName"] = true,
				["debuffType"] = "HELPFUL",
				["use_sourceunit"] = true,
				["unevent"] = "auto",
				["spell"] = "Swirl",
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
			},
			["yOffset"] = 270.0000610351563,
			["frameStrata"] = 1,
			["width"] = 129.3750762939453,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["font"] = "Friz Quadrata TT",
			["numTriggers"] = 2,
			["anchorPoint"] = "CENTER",
			["height"] = 35.9999885559082,
			["id"] = "Immerseus - Swirl",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_zone"] = true,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["parent"] = "SoO 1st Part",
		},
		["CrystalFull"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["fontSize"] = 12,
			["displayStacks"] = "Full",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["parent"] = "Tortos",
			["untrigger"] = {
			},
			["regionType"] = "icon",
			["yOffset"] = 11.00006103515625,
			["anchorPoint"] = "CENTER",
			["xOffset"] = -67.00030517578125,
			["inverse"] = false,
			["desaturate"] = false,
			["customTextUpdate"] = "update",
			["trigger"] = {
				["name_operator"] = "find('%s')",
				["subeventSuffix"] = "_CAST_START",
				["ownOnly"] = true,
				["event"] = "Health",
				["names"] = {
					"Crystal Shell: Full Capacity!", -- [1]
				},
				["use_name"] = true,
				["subcount"] = true,
				["name"] = "Crystal Shell",
				["custom_hide"] = "timed",
				["unit"] = "player",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["debuffType"] = "HARMFUL",
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["stickyDuration"] = false,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["additional_triggers"] = {
			},
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 65,
			["id"] = "CrystalFull",
			["font"] = "Friz Quadrata TT",
			["numTriggers"] = 1,
			["icon"] = true,
			["height"] = 65,
			["disjunctive"] = true,
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Sha of Pride - Mark of Arrogance"] = {
			["load"] = {
				["use_zone"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "Use a CD %p",
			["stacksPoint"] = "BOTTOM",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["regionType"] = "icon",
			["additional_triggers"] = {
			},
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["icon"] = true,
			["numTriggers"] = 1,
			["selfPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["trigger"] = {
				["debuffType"] = "HARMFUL",
				["type"] = "aura",
				["names"] = {
					"Mark of Arrogance", -- [1]
				},
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["actions"] = {
				["start"] = {
					["message"] = "Gift of the Titans",
					["do_sound"] = false,
					["message_type"] = "SAY",
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\BikeHorn.mp3",
					["do_message"] = false,
				},
				["finish"] = {
				},
			},
			["stickyDuration"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "Sha of Pride - Mark of Arrogance",
			["xOffset"] = 490,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["inverse"] = false,
			["width"] = 64,
			["height"] = 64,
			["yOffset"] = 101,
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["DP"] = {
			["textFlags"] = "None",
			["stacksSize"] = 12,
			["borderBackdrop"] = "Blizzard Tooltip",
			["parent"] = "Track DP Group",
			["stacksFlags"] = "None",
			["barInFront"] = true,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "update",
			["rotateText"] = "NONE",
			["icon"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
				["name"] = "Devouring Plague",
				["custom_hide"] = "timed",
				["unit"] = "multi",
				["names"] = {
				},
				["debuffType"] = "HARMFUL",
			},
			["text"] = true,
			["barColor"] = {
				0.615686274509804, -- [1]
				0.3333333333333333, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["stickyDuration"] = false,
			["timer"] = true,
			["height"] = 15,
			["timerFlags"] = "None",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["single"] = 3,
					["multi"] = {
						[3] = true,
					},
				},
				["class"] = {
					["single"] = "PRIEST",
					["multi"] = {
					},
				},
				["use_talent"] = false,
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["untrigger"] = {
			},
			["numTriggers"] = 1,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["xOffset"] = 0,
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "aurabar",
			["stacks"] = true,
			["displayTextRight"] = "%n",
			["icon_side"] = "RIGHT",
			["frameStrata"] = 1,
			["borderOffset"] = 5,
			["timerSize"] = 10,
			["texture"] = "Flat",
			["textFont"] = "DorisPP",
			["stacksFont"] = "Friz Quadrata TT",
			["auto"] = true,
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["id"] = "DP",
			["timerFont"] = "DorisPP",
			["alpha"] = 1,
			["width"] = 200,
			["borderSize"] = 16,
			["borderInset"] = 11,
			["inverse"] = false,
			["yOffset"] = 0,
			["orientation"] = "HORIZONTAL",
			["textSize"] = 12,
			["displayTextLeft"] = "%p",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Disc Priest Barrier"] = {
			["xOffset"] = 0,
			["customText"] = "function(...)\n    local GetAuraSourceName = function(aura)\n        local RAID_SIZE = 25 -- CHANGE THIS        \n        if not aura then return end\n        local auraName = aura\n        if type(aura) == 'number' then auraName = GetSpellInfo(aura) end\n        for i=1,RAID_SIZE do\n            local unitCaster = select(8, UnitAura('raid'..i, auraName))\n            if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n        end    \n        local unitCaster = select(8, UnitAura('player', auraName))\n        if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n    end\n    \n    return GetAuraSourceName(select(5, ...))    \nend",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "event",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["glow_action"] = "show",
					["message_type"] = "RAID",
					["do_glow"] = true,
					["do_message"] = false,
					["glow_frame"] = "WeakAuras:Disc Priest Barrier",
				},
				["finish"] = {
					["message_type"] = "RAID",
					["message"] = "",
					["do_message"] = false,
					["do_sound"] = false,
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "event",
				["subeventSuffix"] = "_CAST_START",
				["name_info"] = "aura",
				["unit"] = "group",
				["group_countOperator"] = ">=",
				["names"] = {
					"Power Word: Barrier", -- [1]
				},
				["custom_hide"] = "timed",
				["subeventPrefix"] = "SPELL",
				["group_count"] = "2",
				["event"] = "Combat Log",
				["unevent"] = "timed",
				["debuffType"] = "HELPFUL",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 60,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 19,
			["displayStacks"] = "  (%s) %n - %c",
			["regionType"] = "icon",
			["parent"] = "Raid Cooldowns Thok",
			["cooldown"] = true,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["icon"] = true,
			["additional_triggers"] = {
			},
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 60,
			["yOffset"] = 0,
			["numTriggers"] = 1,
			["inverse"] = false,
			["stickyDuration"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["id"] = "Disc Priest Barrier",
			["stacksPoint"] = "RIGHT",
			["textColor"] = {
				0.2549019607843137, -- [1]
				1, -- [2]
				0.01176470588235294, -- [3]
				1, -- [4]
			},
		},
		["Nazgrim - Berserker Stance"] = {
			["stacksPoint"] = "BOTTOM",
			["fontSize"] = 24,
			["displayStacks"] = "Berserker Stance",
			["cooldown"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
				["form"] = 0,
				["use_specific_unit"] = true,
				["unit"] = "member",
			},
			["regionType"] = "icon",
			["yOffset"] = 166,
			["anchorPoint"] = "CENTER",
			["xOffset"] = 555,
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_message"] = false,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\BikeHorn.mp3",
					["do_sound"] = false,
				},
				["finish"] = {
				},
			},
			["customTextUpdate"] = "update",
			["stickyDuration"] = false,
			["icon"] = true,
			["width"] = 64,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["preset"] = "bounceDecay",
					["type"] = "preset",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["use_form"] = true,
				["source"] = "General Nazgrim",
				["use_inverse"] = false,
				["names"] = {
					"Defensive Stance", -- [1]
				},
				["specificUnit"] = "boss1",
				["custom_hide"] = "timed",
				["type"] = "event",
				["unevent"] = "timed",
				["use_specific_unit"] = true,
				["form"] = 0,
				["event"] = "Combat Log",
				["use_unit"] = true,
				["use_source"] = true,
				["use_spellName"] = true,
				["unit"] = "member",
				["subeventSuffix"] = "_AURA_APPLIED",
				["duration"] = "60",
				["debuffType"] = "HARMFUL",
				["spellName"] = "Berserker Stance",
				["subeventPrefix"] = "SPELL",
			},
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "Nazgrim - Berserker Stance",
			["font"] = "Friz Quadrata TT",
			["inverse"] = false,
			["additional_triggers"] = {
			},
			["height"] = 64,
			["displayIcon"] = "Interface\\Icons\\Ability_Racial_Avatar",
			["load"] = {
				["use_zone"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["zone"] = "Siege of Orgrimmar",
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["use_combat"] = true,
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: BB"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["stacksPoint"] = "RIGHT",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
				["spellName"] = 12292,
			},
			["yOffset"] = 0,
			["anchorPoint"] = "CENTER",
			["parent"] = "Tank CDs 2",
			["xOffset"] = 0,
			["inverse"] = true,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["unit"] = "player",
				["event"] = "Cooldown Progress (Spell)",
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
				["use_spellName"] = true,
				["unevent"] = "auto",
				["use_unit"] = true,
				["itemName"] = 0,
				["spellName"] = 12292,
				["use_itemName"] = true,
				["custom_hide"] = "timed",
			},
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "TCD: BB",
			["desaturate"] = false,
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["width"] = 30,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["height"] = 30,
			["regionType"] = "icon",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Nazgrim - Battle Stance"] = {
			["cooldown"] = true,
			["fontSize"] = 24,
			["displayStacks"] = "Battle Stance",
			["stacksPoint"] = "BOTTOM",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["yOffset"] = 166,
			["regionType"] = "icon",
			["untrigger"] = {
				["form"] = 0,
				["unit"] = "member",
				["use_specific_unit"] = true,
			},
			["anchorPoint"] = "CENTER",
			["xOffset"] = 555,
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
					["message"] = "",
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\BikeHorn.mp3",
					["do_message"] = false,
					["do_sound"] = false,
				},
				["finish"] = {
				},
			},
			["customTextUpdate"] = "update",
			["stickyDuration"] = false,
			["icon"] = true,
			["width"] = 64,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "bounceDecay",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["use_form"] = true,
				["source"] = "General Nazgrim",
				["duration"] = "60",
				["names"] = {
					"Defensive Stance", -- [1]
				},
				["specificUnit"] = "boss1",
				["custom_hide"] = "timed",
				["type"] = "event",
				["subeventSuffix"] = "_AURA_APPLIED",
				["spellName"] = "Battle Stance",
				["form"] = 0,
				["event"] = "Combat Log",
				["use_inverse"] = false,
				["debuffType"] = "HARMFUL",
				["use_spellName"] = true,
				["unevent"] = "timed",
				["unit"] = "member",
				["use_specific_unit"] = true,
				["use_source"] = true,
				["use_unit"] = true,
				["subeventPrefix"] = "SPELL",
			},
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "Nazgrim - Battle Stance",
			["font"] = "Friz Quadrata TT",
			["inverse"] = false,
			["additional_triggers"] = {
			},
			["height"] = 64,
			["displayIcon"] = "Interface\\Icons\\Ability_Warrior_OffensiveStance",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Shockwave"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["fontSize"] = 24,
			["displayStacks"] = "%t",
			["load"] = {
				["use_size"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["difficulty"] = "heroic",
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["use_combat"] = true,
				["use_difficulty"] = true,
				["size"] = {
					["single"] = "twentyfive",
					["multi"] = {
					},
				},
			},
			["parent"] = "Stuns",
			["yOffset"] = 121.4999389648438,
			["regionType"] = "icon",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["xOffset"] = -294.7500610351563,
			["inverse"] = false,
			["icon"] = true,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["duration_type"] = "seconds",
					["preset"] = "shrink",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["duration_type"] = "seconds",
					["preset"] = "fade",
				},
			},
			["actions"] = {
				["start"] = {
					["do_sound"] = true,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\Bleat.mp3",
					["sound_channel"] = "Master",
				},
				["finish"] = {
					["sound"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\swordecho.ogg",
					["do_sound"] = true,
				},
			},
			["desaturate"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "event",
				["subeventSuffix"] = "_CAST_SUCCESS",
				["duration"] = "4",
				["event"] = "Combat Log",
				["unit"] = "player",
				["debuffType"] = "HELPFUL",
				["use_spellName"] = true,
				["names"] = {
				},
				["use_sourceunit"] = false,
				["subeventPrefix"] = "SPELL",
				["unevent"] = "timed",
				["spellName"] = "Shockwave",
				["custom_hide"] = "timed",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 105.2499542236328,
			["id"] = "Shockwave",
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["stacksPoint"] = "RIGHT",
			["height"] = 104.5000839233398,
			["displayIcon"] = "Interface\\Icons\\Ability_Warrior_Shockwave",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: LS"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["cooldown"] = true,
			["xOffset"] = 170,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["parent"] = "Tank Def Buffs",
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["stickyDuration"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["id"] = "TCD: LS",
			["width"] = 30,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Last Stand", -- [1]
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["font"] = "DorisPP",
			["inverse"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["height"] = 30,
			["regionType"] = "icon",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Lei Shen Transistions 2"] = {
			["outline"] = true,
			["fontSize"] = 72,
			["color"] = {
				1, -- [1]
				0, -- [2]
				0.1137254901960784, -- [3]
				1, -- [4]
			},
			["displayText"] = "%c\n",
			["customText"] = "function()\n    local percent = (UnitHealth(\"focus\")/UnitHealthMax(\"focus\"))*100 - 30.5;\n    return (\"%i\",2):format(percent);\nend",
			["yOffset"] = 102.0000610351563,
			["regionType"] = "text",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["justify"] = "CENTER",
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "status",
				["use_health"] = false,
				["unevent"] = "auto",
				["use_unit"] = true,
				["percenthealth"] = "33",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
				},
				["health"] = "68",
				["health_operator"] = "<",
				["unit"] = "focus",
				["use_percenthealth"] = true,
				["percenthealth_operator"] = "<=",
				["debuffType"] = "HELPFUL",
			},
			["anchorPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 25.18499755859375,
			["selfPoint"] = "BOTTOM",
			["font"] = "Boris Black Bloxx",
			["numTriggers"] = 1,
			["id"] = "Lei Shen Transistions 2",
			["height"] = 70.00006866455078,
			["xOffset"] = 48.7498779296875,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
				["use_unit"] = true,
				["health"] = "65.5",
				["use_health"] = false,
				["health_operator"] = "<=",
				["use_percenthealth"] = true,
				["percenthealth"] = "65.8",
				["percenthealth_operator"] = "<=",
				["unit"] = "focus",
			},
		},
		["TCD: Last Stand"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["cooldown"] = true,
			["regionType"] = "icon",
			["untrigger"] = {
				["spellName"] = 12975,
			},
			["anchorPoint"] = "CENTER",
			["yOffset"] = 0,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["icon"] = true,
			["width"] = 30,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["use_itemName"] = true,
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["spellName"] = 12975,
				["use_spellName"] = true,
				["itemName"] = 0,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "TCD: Last Stand",
			["font"] = "DorisPP",
			["inverse"] = true,
			["xOffset"] = 0,
			["height"] = 30,
			["parent"] = "Tank CDs Long",
			["stacksPoint"] = "RIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Tank DPS Buffs"] = {
			["grow"] = "HORIZONTAL",
			["controlledChildren"] = {
				"DPS Lust", -- [1]
				"Reck", -- [2]
				"Bloodbath", -- [3]
				"Crit Banner", -- [4]
				"Mocking Banner", -- [5]
				"Enraged", -- [6]
				"Berserker Rage", -- [7]
				"Riposte", -- [8]
				"Tactitian", -- [9]
			},
			["animate"] = false,
			["xOffset"] = 0,
			["border"] = "None",
			["yOffset"] = -290,
			["anchorPoint"] = "CENTER",
			["untrigger"] = {
			},
			["sort"] = "none",
			["expanded"] = false,
			["space"] = 2,
			["background"] = "None",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["constantFactor"] = "RADIUS",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["borderOffset"] = 16,
			["align"] = "CENTER",
			["selfPoint"] = "LEFT",
			["id"] = "Tank DPS Buffs",
			["backgroundInset"] = 0,
			["frameStrata"] = 1,
			["width"] = 286,
			["stagger"] = 0,
			["radius"] = 200,
			["numTriggers"] = 1,
			["rotation"] = 0,
			["height"] = 30,
			["trigger"] = {
				["names"] = {
				},
				["type"] = "aura",
				["debuffType"] = "HELPFUL",
				["unit"] = "player",
			},
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "dynamicgroup",
		},
		["Galakras - Burning Blood"] = {
			["xOffset"] = 555,
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["debuffType"] = "HARMFUL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Burning Blood", -- [1]
				},
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["cooldown"] = true,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["do_message"] = false,
					["sound"] = "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.wav",
					["sound_channel"] = "SFX",
				},
				["finish"] = {
				},
			},
			["additional_triggers"] = {
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 64,
			["yOffset"] = 166,
			["numTriggers"] = 1,
			["inverse"] = false,
			["selfPoint"] = "CENTER",
			["id"] = "Galakras - Burning Blood",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: S Slam"] = {
			["xOffset"] = 139,
			["untrigger"] = {
				["spellName"] = 23922,
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["debuffType"] = "HELPFUL",
				["use_spellName"] = true,
				["names"] = {
					"Shield Block", -- [1]
				},
				["subeventPrefix"] = "SPELL",
				["unevent"] = "auto",
				["use_unit"] = true,
				["use_remaining"] = false,
				["spellName"] = 23922,
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 30,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["use_never"] = true,
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%s",
			["regionType"] = "icon",
			["disjunctive"] = true,
			["stacksPoint"] = "BOTTOM",
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["stickyDuration"] = false,
			["id"] = "TCD: S Slam",
			["yOffset"] = 20,
			["frameStrata"] = 1,
			["width"] = 30,
			["numTriggers"] = 2,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["inverse"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["additional_triggers"] = {
				{
					["trigger"] = {
						["type"] = "status",
						["unevent"] = "auto",
						["event"] = "Action Usable",
						["subeventPrefix"] = "SPELL",
						["use_spellName"] = true,
						["unit"] = "player",
						["use_unit"] = true,
						["subeventSuffix"] = "_CAST_START",
						["spellName"] = 23922,
					},
					["untrigger"] = {
						["spellName"] = 23922,
					},
				}, -- [1]
			},
			["parent"] = "Tank CDs",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Tank Def Buffs"] = {
			["grow"] = "HORIZONTAL",
			["controlledChildren"] = {
				"HOP", -- [1]
				"TCD: Shiel Wall", -- [2]
				"PS", -- [3]
				"GS", -- [4]
				"Vigil", -- [5]
				"TCD: LS", -- [6]
				"LC", -- [7]
				"Demo", -- [8]
				"Demo Banner", -- [9]
				"Rallying Cry", -- [10]
				"Avoidance", -- [11]
				"Reflec", -- [12]
				"Regen", -- [13]
				"Sac", -- [14]
			},
			["animate"] = true,
			["xOffset"] = 0,
			["border"] = "None",
			["yOffset"] = -245,
			["anchorPoint"] = "CENTER",
			["untrigger"] = {
			},
			["sort"] = "none",
			["expanded"] = false,
			["space"] = 2,
			["background"] = "None",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["constantFactor"] = "RADIUS",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["borderOffset"] = 16,
			["align"] = "CENTER",
			["selfPoint"] = "LEFT",
			["id"] = "Tank Def Buffs",
			["backgroundInset"] = 0,
			["frameStrata"] = 1,
			["width"] = 445.9999389648438,
			["stagger"] = 0,
			["radius"] = 200,
			["numTriggers"] = 1,
			["rotation"] = 0,
			["height"] = 30.00000762939453,
			["trigger"] = {
				["names"] = {
				},
				["type"] = "aura",
				["debuffType"] = "HELPFUL",
				["unit"] = "player",
			},
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "dynamicgroup",
		},
		["Demo Banner"] = {
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["cooldown"] = true,
			["xOffset"] = 0,
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["yOffset"] = 20,
			["regionType"] = "icon",
			["parent"] = "Tank Def Buffs",
			["inverse"] = false,
			["icon"] = true,
			["customTextUpdate"] = "update",
			["trigger"] = {
				["type"] = "event",
				["subeventSuffix"] = "_CAST_SUCCESS",
				["duration"] = "15",
				["event"] = "Combat Log",
				["unit"] = "player",
				["use_spellName"] = true,
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Recklessness", -- [1]
				},
				["subeventPrefix"] = "SPELL",
				["custom_hide"] = "timed",
				["unevent"] = "timed",
				["spellName"] = "Demoralizing Banner",
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["desaturate"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "Demo Banner",
			["width"] = 30,
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["selfPoint"] = "CENTER",
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["height"] = 30,
			["displayIcon"] = "Interface\\Icons\\demoralizing_banner",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Norushen - Residual Corruption"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_sound"] = false,
					["message_type"] = "SAY",
					["do_message"] = false,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["scaleFunc"] = "return function(progress, startX, startY, scaleX, scaleY)\n  return startX + (progress * (scaleX - startX)), startY + (progress * (scaleY - startY))\nend\n",
					["use_scale"] = true,
					["colorB"] = 1,
					["colorG"] = 1,
					["use_translate"] = false,
					["scaleType"] = "straightScale",
					["scalex"] = 1.5,
					["preset"] = "bounce",
					["alpha"] = 0,
					["type"] = "custom",
					["y"] = 0,
					["x"] = 0,
					["duration"] = "1.5",
					["colorA"] = 1,
					["colorR"] = 1,
					["rotate"] = 0,
					["scaley"] = 1.5,
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "event",
				["unevent"] = "timed",
				["spellName"] = "Residual Corruption",
				["duration"] = "2",
				["use_source"] = false,
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_DAMAGE",
				["use_spellName"] = true,
				["custom_hide"] = "timed",
				["use_sourceunit"] = false,
				["event"] = "Combat Log",
				["names"] = {
					"Residual Corruption", -- [1]
				},
				["unit"] = "player",
				["debuffType"] = "HARMFUL",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 80,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["use_combat"] = true,
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "Orb",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["stacksPoint"] = "BOTTOM",
			["icon"] = true,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["id"] = "Norushen - Residual Corruption",
			["additional_triggers"] = {
			},
			["yOffset"] = 166,
			["frameStrata"] = 1,
			["width"] = 80,
			["numTriggers"] = 1,
			["stickyDuration"] = false,
			["inverse"] = false,
			["selfPoint"] = "CENTER",
			["xOffset"] = 490,
			["displayIcon"] = "Interface\\Icons\\sha_spell_shadow_shadesofdarkness",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Sha of Pride - Gift of the Titans"] = {
			["xOffset"] = 490,
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["debuffType"] = "HARMFUL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Gift of the Titans", -- [1]
				},
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["cooldown"] = true,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["actions"] = {
				["start"] = {
					["message"] = "Gift of the Titans",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\BikeHorn.mp3",
					["do_message"] = true,
				},
				["finish"] = {
				},
			},
			["id"] = "Sha of Pride - Gift of the Titans",
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 64,
			["yOffset"] = 166,
			["numTriggers"] = 1,
			["inverse"] = false,
			["selfPoint"] = "CENTER",
			["additional_triggers"] = {
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["/o"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.75, -- [4]
			},
			["mirror"] = false,
			["yOffset"] = 0,
			["regionType"] = "texture",
			["blendMode"] = "BLEND",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["texture"] = "Textures\\SpellActivationOverlays\\Eclipse_Sun",
			["untrigger"] = {
			},
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["id"] = "/o",
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["width"] = 200,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["rotation"] = 0,
			["anchorPoint"] = "CENTER",
			["numTriggers"] = 1,
			["discrete_rotation"] = 0,
			["height"] = 200,
			["rotate"] = true,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["xOffset"] = 0,
		},
		["Nazgrim - Defensive Stance Inc Warning"] = {
			["textFlags"] = "None",
			["stacksSize"] = 24,
			["xOffset"] = 702.0003051757813,
			["displayText"] = "",
			["yOffset"] = 150.0003051757813,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["rotateText"] = "NONE",
			["icon"] = true,
			["selfPoint"] = "CENTER",
			["barColor"] = {
				1, -- [1]
				0, -- [2]
				0.1372549019607843, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["font"] = "Friz Quadrata TT",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["regionType"] = "text",
			["stacks"] = true,
			["texture"] = "Blizzard",
			["textFont"] = "Friz Quadrata TT",
			["zoom"] = 0,
			["auto"] = true,
			["timerFont"] = "Friz Quadrata TT",
			["alpha"] = 1,
			["borderInset"] = 11,
			["displayIcon"] = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["outline"] = true,
			["borderBackdrop"] = "Blizzard Tooltip",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["barInFront"] = true,
			["customTextUpdate"] = "update",
			["textSize"] = 12,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "event",
				["source"] = "General Nazgrim",
				["subeventSuffix"] = "_AURA_APPLIED",
				["custom_hide"] = "timed",
				["duration"] = "55",
				["event"] = "Combat Log",
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Defensive Stance", -- [1]
				},
				["use_spellName"] = true,
				["use_source"] = true,
				["specificUnit"] = "boss1",
				["unevent"] = "timed",
				["spellName"] = "Berserker Stance",
				["unit"] = "member",
				["debuffType"] = "HELPFUL",
			},
			["text"] = true,
			["stickyDuration"] = false,
			["timer"] = true,
			["timerFlags"] = "None",
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["fontSize"] = 12,
			["displayStacks"] = "Face assassin: %s",
			["border"] = false,
			["borderEdge"] = "None",
			["borderSize"] = 16,
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["icon_side"] = "RIGHT",
			["actions"] = {
				["start"] = {
					["message"] = "Defensive Stance in 5, STOP DPS NOW!",
					["do_sound"] = false,
					["message_type"] = "SAY",
					["do_message"] = false,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
				},
				["finish"] = {
					["message"] = "Defensive Stance in 5, STOP DPS NOW!",
					["do_sound"] = false,
					["message_type"] = "SAY",
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\BoxingArenaSound.mp3",
					["do_message"] = true,
				},
			},
			["borderOffset"] = 5,
			["justify"] = "LEFT",
			["additional_triggers"] = {
			},
			["stacksContainment"] = "OUTSIDE",
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayTextRight"] = "%p",
			["numTriggers"] = 1,
			["id"] = "Nazgrim - Defensive Stance Inc Warning",
			["height"] = 0.9999997019767761,
			["frameStrata"] = 1,
			["width"] = 0.9999997019767761,
			["stacksFont"] = "Friz Quadrata TT",
			["displayTextLeft"] = "Defensive Stance in:",
			["inverse"] = false,
			["timerSize"] = 24,
			["orientation"] = "HORIZONTAL",
			["stacksFlags"] = "None",
			["cooldown"] = true,
			["untrigger"] = {
			},
		},
		["TCD: Charge"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["xOffset"] = 0,
			["stacksPoint"] = "RIGHT",
			["regionType"] = "icon",
			["yOffset"] = 0,
			["anchorPoint"] = "CENTER",
			["untrigger"] = {
				["spellName"] = 100,
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["icon"] = true,
			["width"] = 30,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["use_itemName"] = true,
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["spellName"] = 100,
				["use_spellName"] = true,
				["itemName"] = 0,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "TCD: Charge",
			["font"] = "DorisPP",
			["inverse"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["height"] = 30,
			["parent"] = "Tank CDs 3",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Weakened Armor 3"] = {
			["xOffset"] = 0,
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["countOperator"] = "==",
				["names"] = {
					"Weakened Armor", -- [1]
				},
				["useCount"] = true,
				["count"] = "3",
				["subeventPrefix"] = "SPELL",
				["unit"] = "target",
				["event"] = "Health",
				["debuffType"] = "HARMFUL",
			},
			["desaturate"] = false,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["use_class"] = false,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["use_never"] = true,
				["class"] = {
					["multi"] = {
						["DRUID"] = true,
						["WARRIOR"] = true,
						["ROGUE"] = true,
					},
				},
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 12,
			["displayStacks"] = "%s",
			["regionType"] = "icon",
			["parent"] = "weakened armor",
			["stacksPoint"] = "BOTTOMRIGHT",
			["color"] = {
				0, -- [1]
				1, -- [2]
				0.04705882352941176, -- [3]
				1, -- [4]
			},
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["icon"] = true,
			["id"] = "Weakened Armor 3",
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 64,
			["numTriggers"] = 1,
			["yOffset"] = 0,
			["inverse"] = false,
			["selfPoint"] = "CENTER",
			["additional_triggers"] = {
			},
			["displayIcon"] = "Interface\\Icons\\Ability_Warrior_Sunder",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Sha of Pride - Swelling Pride"] = {
			["outline"] = true,
			["fontSize"] = 36,
			["xOffset"] = 135,
			["displayText"] = "Swelling Pride Coming",
			["untrigger"] = {
				["unit"] = "boss1",
				["use_specific_unit"] = true,
				["use_unit"] = true,
			},
			["regionType"] = "text",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_sound"] = true,
				},
				["finish"] = {
				},
			},
			["disjunctive"] = false,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["additional_triggers"] = {
				{
					["trigger"] = {
						["type"] = "custom",
						["custom"] = "function()\nif UnitName(\"boss1\") == \"Sha of Pride\" then\nreturn true\nelse \nreturn false\nend\nend",
						["subeventSuffix"] = "_CAST_START",
						["check"] = "update",
						["custom_type"] = "status",
						["event"] = "Health",
						["subeventPrefix"] = "SPELL",
					},
					["untrigger"] = {
						["custom"] = "function()\nreturn true\nend",
					},
				}, -- [1]
			},
			["justify"] = "LEFT",
			["selfPoint"] = "BOTTOM",
			["id"] = "Sha of Pride - Swelling Pride",
			["yOffset"] = 270,
			["frameStrata"] = 1,
			["width"] = 398.25,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["font"] = "Friz Quadrata TT",
			["numTriggers"] = 2,
			["anchorPoint"] = "CENTER",
			["height"] = 35.9999885559082,
			["trigger"] = {
				["use_power"] = false,
				["unit"] = "boss1",
				["powertype"] = 3,
				["use_powertype"] = true,
				["custom_hide"] = "timed",
				["type"] = "status",
				["unevent"] = "auto",
				["power_operator"] = ">=",
				["subeventPrefix"] = "SPELL",
				["event"] = "Power",
				["use_percentpower"] = true,
				["names"] = {
				},
				["use_specific_unit"] = true,
				["power"] = "90",
				["use_unit"] = true,
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["percentpower"] = "90",
				["percentpower_operator"] = ">=",
			},
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["use_combat"] = true,
				["size"] = {
					["multi"] = {
					},
				},
			},
			["parent"] = "SoO 1st Part",
		},
		["Avoidance"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["xOffset"] = 170,
			["cooldown"] = true,
			["anchorPoint"] = "CENTER",
			["yOffset"] = 20,
			["regionType"] = "icon",
			["parent"] = "Tank Def Buffs",
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["inverse"] = false,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["id"] = "Avoidance",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["unit"] = "player",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Avoidance", -- [1]
				},
				["debuffType"] = "HELPFUL",
				["event"] = "Health",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 30,
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["height"] = 30,
			["untrigger"] = {
			},
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Poisons"] = {
			["outline"] = true,
			["fontSize"] = 20,
			["color"] = {
				0.2549019607843137, -- [1]
				1, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["displayText"] = "%n",
			["yOffset"] = 66.75018310546875,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Instant Poison", -- [1]
					"Noxious Poison", -- [2]
				},
				["event"] = "Health",
				["unit"] = "focus",
			},
			["justify"] = "LEFT",
			["selfPoint"] = "BOTTOM",
			["additional_triggers"] = {
			},
			["untrigger"] = {
			},
			["frameStrata"] = 1,
			["width"] = 150.7500305175781,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["xOffset"] = -231.000244140625,
			["height"] = 20.25000953674316,
			["id"] = "Poisons",
			["load"] = {
				["use_name"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["name"] = "Git",
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "text",
		},
		["Injection Bar"] = {
			["textFlags"] = "None",
			["stacksSize"] = 17,
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = 0,
			["stacksFlags"] = "None",
			["customText"] = "function()\n    return WA_DEV.count \nend\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
			["yOffset"] = 165,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "event",
			["rotateText"] = "NONE",
			["icon"] = false,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "custom",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["duration"] = "9",
				["event"] = "Chat Message",
				["unit"] = "player",
				["customDuration"] = "function()\n    return 9\nend\n\n\n\n\n\n\n",
				["events"] = "COMBAT_LOG_EVENT_UNFILTERED",
				["custom"] = "function(_,timeStamp,message,_,_,source,_,_,_,target,tarGUID,_,_,spell)\n    if spell == 'Injection' and message == 'SPELL_CAST_SUCCESS' then\n        --        print(string.format('Caught %s on %s %s %s', source, target, spell or 'nil', message or 'nothing'))\n        WA_DEV = WA_DEV or {}\n        WA_DEV.count = WA_DEV.count or 1\n        \n        WA_DEV.last = WA_DEV.last or 0\n        \n        if timeStamp - WA_DEV.last > 15 then\n            WA_DEV.count = 1\n        end\n        \n        WA_DEV.last = timeStamp\n        \n        WA_DEV.count = WA_DEV.count + 1\n        \n        --        print(WA_DEV.count .. \" \" .. timeStamp)\n        return WA_DEV.count ~= 1 and WA_DEV.count ~= 7\n    else\n        return false\n    end\nend\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
				["custom_type"] = "event",
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
			},
			["text"] = true,
			["barColor"] = {
				1, -- [1]
				0, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["parent"] = "Injection+",
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["timer"] = true,
			["timerFlags"] = "None",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["barInFront"] = true,
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["textSize"] = 12,
			["inverse"] = false,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["height"] = 20,
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "aurabar",
			["stacks"] = true,
			["auto"] = true,
			["icon_side"] = "RIGHT",
			["alpha"] = 1,
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayTextRight"] = "%p",
			["texture"] = "Minimalist",
			["textFont"] = "DorisPP",
			["stacksFont"] = "Enigmatic",
			["timerSize"] = 12,
			["borderOffset"] = 5,
			["id"] = "Injection Bar",
			["timerFont"] = "DorisPP",
			["frameStrata"] = 1,
			["width"] = 400,
			["borderSize"] = 16,
			["borderInset"] = 11,
			["numTriggers"] = 1,
			["displayTextLeft"] = "Injection (%c)",
			["orientation"] = "HORIZONTAL",
			["stickyDuration"] = false,
			["untrigger"] = {
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Br"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "RIGHT",
			["parent"] = "Tank CDs 2",
			["yOffset"] = 0,
			["regionType"] = "icon",
			["untrigger"] = {
				["spellName"] = 18499,
			},
			["xOffset"] = 0,
			["inverse"] = true,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["id"] = "TCD: Br",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["use_itemName"] = true,
				["unit"] = "player",
				["subeventPrefix"] = "SPELL",
				["use_spellName"] = true,
				["unevent"] = "auto",
				["use_unit"] = true,
				["itemName"] = 0,
				["spellName"] = 18499,
				["event"] = "Cooldown Progress (Spell)",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 30,
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["icon"] = true,
			["height"] = 30,
			["anchorPoint"] = "CENTER",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Sha of Pride - Bursting Pride"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["message"] = "Aura of Pride, Get Away!",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["do_message"] = true,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["ownOnly"] = true,
				["event"] = "Health",
				["unit"] = "player",
				["custom_hide"] = "timed",
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Bursting Pride", -- [1]
				},
				["debuffType"] = "HARMFUL",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["use_combat"] = true,
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "Spread 5 Yards! %p",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["stacksPoint"] = "BOTTOM",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["stickyDuration"] = false,
			["id"] = "Sha of Pride - Bursting Pride",
			["yOffset"] = 166,
			["frameStrata"] = 1,
			["width"] = 64,
			["selfPoint"] = "CENTER",
			["numTriggers"] = 1,
			["inverse"] = false,
			["xOffset"] = 620,
			["additional_triggers"] = {
			},
			["icon"] = true,
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Dark Shamans - Froststorm Strike"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_sound"] = false,
					["message_type"] = "SAY",
					["do_message"] = false,
					["sound"] = "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.wav",
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["names"] = {
					"Froststorm Strike", -- [1]
				},
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HARMFUL",
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_role"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["single"] = "TANK",
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_combat"] = true,
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "%s  %p",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["stacksPoint"] = "BOTTOM",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["stickyDuration"] = false,
			["additional_triggers"] = {
			},
			["yOffset"] = 166.0000610351563,
			["frameStrata"] = 1,
			["width"] = 64,
			["selfPoint"] = "CENTER",
			["numTriggers"] = 1,
			["inverse"] = false,
			["xOffset"] = 490,
			["id"] = "Dark Shamans - Froststorm Strike",
			["icon"] = true,
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Horridon CDs"] = {
			["outline"] = true,
			["fontSize"] = 12,
			["xOffset"] = -400.7496337890625,
			["displayText"] = "CD 1 - Trinket, Shield Wall, Last Stand\n           Sac, Sac, Ironbark\nCD 2 - Guardian Spirit\n           Pain Sup, Shout, Barrier",
			["yOffset"] = 285.2501220703125,
			["regionType"] = "text",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["additional_triggers"] = {
			},
			["justify"] = "LEFT",
			["selfPoint"] = "BOTTOM",
			["id"] = "Horridon CDs",
			["trigger"] = {
				["type"] = "status",
				["unevent"] = "auto",
				["percenthealth"] = "0",
				["event"] = "Health",
				["use_unit"] = true,
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["unit"] = "target",
				["subeventSuffix"] = "_CAST_START",
				["use_percenthealth"] = true,
				["percenthealth_operator"] = ">=",
				["debuffType"] = "HELPFUL",
			},
			["frameStrata"] = 1,
			["width"] = 233.7599945068359,
			["anchorPoint"] = "CENTER",
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["height"] = 48.00000762939453,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["use_zone"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
				["unit"] = "target",
			},
		},
		["TCD: S Block"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["parent"] = "Tank CDs",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["cooldown"] = true,
			["untrigger"] = {
			},
			["yOffset"] = 20,
			["regionType"] = "icon",
			["stacksPoint"] = "BOTTOM",
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["width"] = 30,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Health",
				["unit"] = "player",
				["use_name"] = true,
				["fullscan"] = true,
				["name"] = "Shield Block",
				["name_operator"] = "==",
				["custom_hide"] = "timed",
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Shield Block", -- [1]
				},
				["debuffType"] = "HELPFUL",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "TCD: S Block",
			["font"] = "DorisPP",
			["inverse"] = false,
			["xOffset"] = 232,
			["height"] = 30,
			["anchorPoint"] = "CENTER",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Vamp Embrace"] = {
			["fontSize"] = 12,
			["displayStacks"] = "%p",
			["cooldown"] = true,
			["xOffset"] = -230,
			["stacksPoint"] = "BOTTOM",
			["regionType"] = "icon",
			["yOffset"] = -140,
			["anchorPoint"] = "CENTER",
			["untrigger"] = {
				["spellName"] = 15286,
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = true,
				},
				["finish"] = {
				},
			},
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["icon"] = true,
			["width"] = 40,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["custom_hide"] = "timed",
				["use_spellName"] = true,
				["spellName"] = 15286,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "Vamp Embrace",
			["font"] = "DorisPP",
			["inverse"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["height"] = 40,
			["parent"] = "Shadow Priest",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["name"] = "Spih",
				["use_name"] = false,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["class"] = {
					["single"] = "PRIEST",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Spell Reflection"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "RIGHT",
			["parent"] = "Tank CDs Long",
			["yOffset"] = 0,
			["regionType"] = "icon",
			["untrigger"] = {
				["spellName"] = 23920,
			},
			["xOffset"] = 0,
			["inverse"] = true,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["id"] = "TCD: Spell Reflection",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["use_itemName"] = true,
				["unit"] = "player",
				["subeventPrefix"] = "SPELL",
				["use_spellName"] = true,
				["unevent"] = "auto",
				["use_unit"] = true,
				["itemName"] = 0,
				["spellName"] = 23920,
				["event"] = "Cooldown Progress (Spell)",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 30,
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["icon"] = true,
			["height"] = 30,
			["anchorPoint"] = "CENTER",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Protectors - Sha Sear"] = {
			["xOffset"] = 555,
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["names"] = {
					"Sha Sear", -- [1]
				},
				["type"] = "aura",
				["debuffType"] = "HARMFUL",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["cooldown"] = true,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["actions"] = {
				["start"] = {
					["message"] = "Sha Sear on me!",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["do_message"] = true,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\BikeHorn.mp3",
				},
				["finish"] = {
				},
			},
			["id"] = "Protectors - Sha Sear",
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 64,
			["yOffset"] = 166,
			["numTriggers"] = 1,
			["inverse"] = false,
			["selfPoint"] = "CENTER",
			["additional_triggers"] = {
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Sha of Pride - Weakened Resolve Rift"] = {
			["parent"] = "SoO 1st Part",
			["fontSize"] = 18,
			["displayStacks"] = "Can't Soak %p",
			["stacksPoint"] = "TOP",
			["xOffset"] = 685,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["regionType"] = "icon",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["stickyDuration"] = false,
			["inverse"] = false,
			["selfPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["id"] = "Sha of Pride - Weakened Resolve Rift",
			["icon"] = true,
			["width"] = 64,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["debuffType"] = "HARMFUL",
				["type"] = "aura",
				["names"] = {
					"Weakened Resolve", -- [1]
				},
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["actions"] = {
				["start"] = {
					["do_sound"] = true,
					["sound"] = "Interface\\AddOns\\Prat-3.0\\Sounds\\Xylo.ogg",
					["sound_channel"] = "SFX",
				},
				["finish"] = {
				},
			},
			["frameStrata"] = 1,
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["numTriggers"] = 1,
			["additional_triggers"] = {
			},
			["height"] = 64,
			["yOffset"] = 166,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_zone"] = true,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Tricks Group"] = {
			["grow"] = "UP",
			["controlledChildren"] = {
				"Tricks Tracker", -- [1]
			},
			["animate"] = false,
			["xOffset"] = 410.9996948242188,
			["border"] = "None",
			["yOffset"] = 70.49981689453125,
			["anchorPoint"] = "CENTER",
			["untrigger"] = {
			},
			["sort"] = "none",
			["expanded"] = true,
			["space"] = 2,
			["background"] = "None",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["constantFactor"] = "RADIUS",
			["selfPoint"] = "BOTTOM",
			["borderOffset"] = 16,
			["align"] = "CENTER",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["names"] = {
				},
				["type"] = "aura",
				["debuffType"] = "HELPFUL",
				["unit"] = "player",
			},
			["backgroundInset"] = 0,
			["frameStrata"] = 1,
			["width"] = 49.99993896484375,
			["rotation"] = 0,
			["radius"] = 200,
			["numTriggers"] = 1,
			["stagger"] = 0,
			["height"] = 49.99996948242188,
			["id"] = "Tricks Group",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "dynamicgroup",
		},
		["Holy Priest Divine Hymn"] = {
			["xOffset"] = 0,
			["customText"] = "function(...)\n    local GetAuraSourceName = function(aura)\n        local RAID_SIZE = 25 -- CHANGE THIS        \n        if not aura then return end\n        local auraName = aura\n        if type(aura) == 'number' then auraName = GetSpellInfo(aura) end\n        for i=1,RAID_SIZE do\n            local unitCaster = select(8, UnitAura('raid'..i, auraName))\n            if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n        end    \n        local unitCaster = select(8, UnitAura('player', auraName))\n        if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n    end\n    \n    return GetAuraSourceName(select(5, ...))    \nend",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "event",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["glow_action"] = "show",
					["message_type"] = "RAID",
					["do_glow"] = true,
					["do_message"] = false,
					["glow_frame"] = "WeakAuras:Holy Priest Divine Hymn",
				},
				["finish"] = {
					["message_type"] = "RAID",
					["message"] = "",
					["do_message"] = false,
					["do_sound"] = false,
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["name_info"] = "aura",
				["unit"] = "group",
				["custom_hide"] = "timed",
				["names"] = {
					"Divine Hymn", -- [1]
				},
				["group_countOperator"] = ">=",
				["group_count"] = "2",
				["subeventPrefix"] = "SPELL",
				["event"] = "Health",
				["debuffType"] = "HELPFUL",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 60,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 19,
			["displayStacks"] = "  (%s) %n - %c",
			["regionType"] = "icon",
			["parent"] = "Raid Cooldowns Thok",
			["cooldown"] = true,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["icon"] = true,
			["id"] = "Holy Priest Divine Hymn",
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 60,
			["yOffset"] = 0,
			["numTriggers"] = 1,
			["inverse"] = false,
			["stickyDuration"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["additional_triggers"] = {
			},
			["stacksPoint"] = "RIGHT",
			["textColor"] = {
				0.2549019607843137, -- [1]
				1, -- [2]
				0.01176470588235294, -- [3]
				1, -- [4]
			},
		},
		["Weakened Armor 1"] = {
			["xOffset"] = 0,
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["countOperator"] = "==",
				["names"] = {
					"Weakened Armor", -- [1]
				},
				["useCount"] = true,
				["count"] = "1",
				["subeventPrefix"] = "SPELL",
				["unit"] = "target",
				["event"] = "Health",
				["debuffType"] = "HARMFUL",
			},
			["desaturate"] = false,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["use_class"] = false,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["use_combat"] = true,
				["class"] = {
					["multi"] = {
						["DRUID"] = true,
						["WARRIOR"] = true,
						["ROGUE"] = true,
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 12,
			["displayStacks"] = "%s",
			["regionType"] = "icon",
			["parent"] = "weakened armor",
			["stacksPoint"] = "BOTTOMRIGHT",
			["color"] = {
				1, -- [1]
				0.3764705882352941, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["icon"] = true,
			["id"] = "Weakened Armor 1",
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 64,
			["numTriggers"] = 1,
			["yOffset"] = 0,
			["inverse"] = false,
			["selfPoint"] = "CENTER",
			["additional_triggers"] = {
			},
			["displayIcon"] = "Interface\\Icons\\Ability_Warrior_Sunder",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Projection"] = {
			["fontSize"] = 22,
			["displayStacks"] = "%p",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["xOffset"] = 0,
			["stacksPoint"] = "BOTTOM",
			["anchorPoint"] = "CENTER",
			["yOffset"] = 284.34,
			["regionType"] = "icon",
			["trigger"] = {
				["type"] = "aura",
				["debuffType"] = "HARMFUL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Projection", -- [1]
				},
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["selfPoint"] = "CENTER",
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["additional_triggers"] = {
			},
			["actions"] = {
				["start"] = {
					["sound"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\phone.ogg",
					["do_sound"] = true,
				},
				["finish"] = {
				},
			},
			["stickyDuration"] = false,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "Projection",
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 120,
			["progressPrecision"] = 2,
			["font"] = "Arial Narrow",
			["inverse"] = false,
			["icon"] = true,
			["height"] = 120,
			["untrigger"] = {
			},
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["zone"] = "",
				["use_zone"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				0.9333333333333334, -- [1]
				1, -- [2]
				0.5098039215686274, -- [3]
				1, -- [4]
			},
		},
		["Ra-Den Unstable Vita"] = {
			["fontSize"] = 17,
			["displayStacks"] = "%p",
			["xOffset"] = 235.00048828125,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["load"] = {
				["use_never"] = false,
				["zone"] = "Throne of Thunder",
				["class"] = {
					["multi"] = {
					},
				},
				["difficulty"] = "heroic",
				["use_zone"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["use_difficulty"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["anchorPoint"] = "CENTER",
			["untrigger"] = {
			},
			["regionType"] = "icon",
			["yOffset"] = 123.9998779296875,
			["actions"] = {
				["start"] = {
					["message_type"] = "SAY",
					["do_message"] = false,
					["message"] = "",
				},
				["finish"] = {
				},
			},
			["inverse"] = false,
			["customTextUpdate"] = "update",
			["additional_triggers"] = {
			},
			["icon"] = true,
			["id"] = "Ra-Den Unstable Vita",
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["type"] = "preset",
					["preset"] = "bounce",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["subeventPrefix"] = "SPELL",
				["type"] = "aura",
				["custom_hide"] = "timed",
				["subeventSuffix"] = "_CAST_START",
				["unit"] = "player",
				["debuffType"] = "HARMFUL",
				["event"] = "Health",
				["names"] = {
					"Unstable Vita", -- [1]
				},
			},
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 100,
			["stickyDuration"] = false,
			["font"] = "ElvUI Font",
			["numTriggers"] = 1,
			["selfPoint"] = "CENTER",
			["height"] = 100,
			["displayIcon"] = "Interface\\Icons\\ability_vehicle_electrocharge",
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["vengeance"] = {
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["controlledChildren"] = {
				"vengeance text", -- [1]
				"text 2", -- [2]
			},
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = 0,
			["border"] = false,
			["yOffset"] = 0,
			["anchorPoint"] = "CENTER",
			["borderSize"] = 16,
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["expanded"] = true,
			["borderOffset"] = 5,
			["selfPoint"] = "BOTTOMLEFT",
			["additional_triggers"] = {
			},
			["id"] = "vengeance",
			["frameStrata"] = 1,
			["untrigger"] = {
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["borderInset"] = 11,
			["numTriggers"] = 1,
			["borderEdge"] = "None",
			["trigger"] = {
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["load"] = {
				["class"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "group",
		},
		["Monk Zen Meditation"] = {
			["xOffset"] = 0,
			["customText"] = "function(...)\n    local GetAuraSourceName = function(aura)\n        local RAID_SIZE = 25 -- CHANGE THIS        \n        if not aura then return end\n        local auraName = aura\n        if type(aura) == 'number' then auraName = GetSpellInfo(aura) end\n        for i=1,RAID_SIZE do\n            local unitCaster = select(8, UnitAura('raid'..i, auraName))\n            if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n        end    \n        local unitCaster = select(8, UnitAura('player', auraName))\n        if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n    end\n    \n    return GetAuraSourceName(select(5, ...))    \nend",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "event",
			["actions"] = {
				["start"] = {
					["do_glow"] = true,
					["glow_action"] = "show",
					["message_type"] = "RAID",
					["message"] = "",
					["do_message"] = false,
					["glow_frame"] = "WeakAuras:Monk Zen Meditation",
				},
				["finish"] = {
					["message_type"] = "RAID",
					["message"] = "",
					["do_message"] = false,
					["do_sound"] = false,
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["name_info"] = "aura",
				["unit"] = "group",
				["group_countOperator"] = ">=",
				["names"] = {
					"Zen Meditation", -- [1]
				},
				["custom_hide"] = "timed",
				["group_count"] = "2",
				["subeventPrefix"] = "SPELL",
				["event"] = "Health",
				["debuffType"] = "HELPFUL",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 60,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 19,
			["displayStacks"] = "  (%s) %n - %c",
			["regionType"] = "icon",
			["parent"] = "Raid Cooldowns Thok",
			["stacksPoint"] = "RIGHT",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["icon"] = true,
			["id"] = "Monk Zen Meditation",
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 60,
			["yOffset"] = 0,
			["numTriggers"] = 1,
			["inverse"] = false,
			["stickyDuration"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["additional_triggers"] = {
			},
			["cooldown"] = true,
			["textColor"] = {
				0.2549019607843137, -- [1]
				1, -- [2]
				0.01176470588235294, -- [3]
				1, -- [4]
			},
		},
		["TCD: DB"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["stacksPoint"] = "RIGHT",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
				["spellName"] = 114203,
			},
			["yOffset"] = 0,
			["anchorPoint"] = "CENTER",
			["parent"] = "Tank CDs Long",
			["xOffset"] = 0,
			["inverse"] = true,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["unit"] = "player",
				["event"] = "Cooldown Progress (Spell)",
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
				["use_spellName"] = true,
				["unevent"] = "auto",
				["use_unit"] = true,
				["itemName"] = 0,
				["spellName"] = 114203,
				["use_itemName"] = true,
				["custom_hide"] = "timed",
			},
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "TCD: DB",
			["desaturate"] = false,
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["width"] = 30,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["height"] = 30,
			["regionType"] = "icon",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Riposte"] = {
			["parent"] = "Tank DPS Buffs",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["unit"] = "player",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Riposte", -- [1]
				},
				["debuffType"] = "HELPFUL",
				["event"] = "Health",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 30,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["cooldown"] = true,
			["selfPoint"] = "CENTER",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["disjunctive"] = true,
			["additional_triggers"] = {
				{
					["trigger"] = {
						["type"] = "aura",
						["subeventPrefix"] = "SPELL",
						["subeventSuffix"] = "_CAST_START",
						["unit"] = "player",
						["names"] = {
							"Time Warp", -- [1]
						},
						["event"] = "Health",
						["debuffType"] = "HELPFUL",
					},
					["untrigger"] = {
					},
				}, -- [1]
			},
			["xOffset"] = 0,
			["frameStrata"] = 1,
			["width"] = 30,
			["inverse"] = false,
			["yOffset"] = 20,
			["numTriggers"] = 2,
			["id"] = "Riposte",
			["stickyDuration"] = false,
			["actions"] = {
				["start"] = {
					["do_glow"] = true,
					["do_custom"] = false,
					["glow_action"] = "show",
				},
				["finish"] = {
				},
			},
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Protectors - Mark of Anguish"] = {
			["parent"] = "SoO 1st Part",
			["fontSize"] = 24,
			["displayStacks"] = "%p  %s",
			["stacksPoint"] = "BOTTOMRIGHT",
			["xOffset"] = 490,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["regionType"] = "icon",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["actions"] = {
				["start"] = {
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_sound"] = true,
				},
				["finish"] = {
				},
			},
			["numTriggers"] = 1,
			["stickyDuration"] = false,
			["customTextUpdate"] = "update",
			["additional_triggers"] = {
			},
			["icon"] = true,
			["desaturate"] = false,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["scaleType"] = "straightScale",
					["type"] = "none",
					["use_scale"] = true,
					["duration"] = "2",
					["colorA"] = 1,
					["duration_type"] = "seconds",
					["alpha"] = 0,
					["x"] = 0,
					["y"] = 0,
					["colorB"] = 1,
					["colorG"] = 1,
					["scaleFunc"] = "return function(progress, startX, startY, scaleX, scaleY)\n  return startX + (progress * (scaleX - startX)), startY + (progress * (scaleY - startY))\nend\n",
					["scalex"] = 2,
					["rotate"] = 0,
					["scaley"] = 2,
					["colorR"] = 1,
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["ownOnly"] = true,
				["event"] = "Health",
				["names"] = {
					"Mark of Anguish", -- [1]
				},
				["debuffType"] = "HELPFUL",
				["unit"] = "player",
				["subeventPrefix"] = "SPELL",
				["custom_hide"] = "timed",
			},
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 64,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["inverse"] = false,
			["id"] = "Protectors - Mark of Anguish",
			["height"] = 64,
			["yOffset"] = 166,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_zone"] = true,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Rev"] = {
			["xOffset"] = 170,
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["spellName"] = 6572,
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["use_remaining"] = false,
				["use_spellName"] = true,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Shield Block", -- [1]
				},
				["debuffType"] = "HELPFUL",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 30,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["use_never"] = true,
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%s",
			["regionType"] = "icon",
			["stickyDuration"] = false,
			["cooldown"] = true,
			["parent"] = "Tank CDs",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["disjunctive"] = true,
			["additional_triggers"] = {
				{
					["trigger"] = {
						["type"] = "status",
						["unevent"] = "auto",
						["event"] = "Action Usable",
						["subeventPrefix"] = "SPELL",
						["use_spellName"] = true,
						["unit"] = "player",
						["use_unit"] = true,
						["subeventSuffix"] = "_CAST_START",
						["spellName"] = 6572,
					},
					["untrigger"] = {
						["spellName"] = 6572,
					},
				}, -- [1]
			},
			["id"] = "TCD: Rev",
			["frameStrata"] = 1,
			["width"] = 30,
			["numTriggers"] = 2,
			["untrigger"] = {
				["spellName"] = 6572,
			},
			["inverse"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["actions"] = {
				["start"] = {
					["do_glow"] = false,
				},
				["finish"] = {
				},
			},
			["selfPoint"] = "CENTER",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Dark Shamans - Falling Ash"] = {
			["textFlags"] = "None",
			["stacksSize"] = 38,
			["borderBackdrop"] = "Blizzard Tooltip",
			["color"] = {
				0.8392156862745098, -- [1]
				1, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["stacksFlags"] = "None",
			["yOffset"] = 242.0003051757813,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "update",
			["rotateText"] = "NONE",
			["textSize"] = 38,
			["parent"] = "SoO 1st Part",
			["untrigger"] = {
				["unit"] = "Earthbreaker Haromm",
				["use_specific_unit"] = true,
			},
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["preset"] = "alphaPulse",
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["selfPoint"] = "BOTTOM",
			["trigger"] = {
				["use_castType"] = false,
				["sourceunit"] = "target",
				["source"] = "Earthbreaker Haromm",
				["duration"] = "15",
				["use_spell"] = true,
				["use_specific_unit"] = true,
				["custom_hide"] = "timed",
				["type"] = "event",
				["use_unit"] = true,
				["unevent"] = "timed",
				["unit"] = "Earthbreaker Haromm",
				["event"] = "Combat Log",
				["use_source"] = false,
				["subeventSuffix"] = "_CAST_START",
				["spellName"] = "Falling Ash",
				["use_spellName"] = true,
				["spell"] = "Ashen Wall",
				["use_sourceunit"] = false,
				["use_destunit"] = false,
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
			},
			["text"] = true,
			["barColor"] = {
				1, -- [1]
				0, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["displayText"] = "Adds Wall Incoming!!",
			["numTriggers"] = 1,
			["stickyDuration"] = false,
			["height"] = 40,
			["timer"] = true,
			["timerFlags"] = "None",
			["load"] = {
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_role"] = true,
				["class"] = {
					["single"] = "PALADIN",
					["multi"] = {
						["PALADIN"] = true,
					},
				},
				["role"] = {
					["single"] = "TANK",
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_combat"] = true,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["outline"] = true,
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["alpha"] = 1,
			["borderSize"] = 16,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["id"] = "Dark Shamans - Falling Ash",
			["timerSize"] = 38,
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "aurabar",
			["stacks"] = true,
			["justify"] = "LEFT",
			["icon_side"] = "LEFT",
			["stacksFont"] = "Friz Quadrata TT",
			["barInFront"] = true,
			["displayTextRight"] = "%p",
			["texture"] = "Blizzard",
			["textFont"] = "Friz Quadrata TT",
			["borderOffset"] = 5,
			["auto"] = true,
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["additional_triggers"] = {
			},
			["timerFont"] = "Friz Quadrata TT",
			["frameStrata"] = 1,
			["width"] = 300,
			["xOffset"] = 608.0005493164063,
			["borderInset"] = 11,
			["inverse"] = false,
			["icon"] = true,
			["orientation"] = "HORIZONTAL",
			["displayTextLeft"] = "Falling Ash",
			["actions"] = {
				["start"] = {
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_sound"] = false,
				},
				["finish"] = {
					["do_glow"] = false,
					["sound"] = "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.wav",
					["do_sound"] = false,
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["SW: Pain"] = {
			["fontSize"] = 12,
			["displayStacks"] = "%p",
			["stacksPoint"] = "BOTTOM",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["load"] = {
				["use_name"] = false,
				["role"] = {
					["multi"] = {
					},
				},
				["name"] = "Spih",
				["use_class"] = true,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["class"] = {
					["single"] = "PRIEST",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["parent"] = "Shadow Priest",
			["untrigger"] = {
				["spellName"] = 8092,
			},
			["anchorPoint"] = "CENTER",
			["yOffset"] = -140,
			["xOffset"] = 80,
			["inverse"] = false,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["ownOnly"] = true,
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "target",
				["debuffType"] = "HARMFUL",
				["use_spellName"] = true,
				["names"] = {
					"Shadow Word: Pain", -- [1]
				},
				["subeventPrefix"] = "SPELL",
				["unevent"] = "auto",
				["use_unit"] = true,
				["spellName"] = 8092,
				["custom_hide"] = "timed",
			},
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["duration_type"] = "seconds",
					["preset"] = "fade",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["duration_type"] = "seconds",
					["preset"] = "fade",
				},
			},
			["id"] = "SW: Pain",
			["desaturate"] = false,
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["width"] = 40,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
					["do_custom"] = true,
				},
				["finish"] = {
				},
			},
			["height"] = 40,
			["regionType"] = "icon",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: S Barrier"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%s",
			["cooldown"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "BOTTOM",
			["yOffset"] = 20,
			["untrigger"] = {
			},
			["regionType"] = "icon",
			["parent"] = "Tank CDs",
			["xOffset"] = 263,
			["inverse"] = false,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["id"] = "TCD: S Barrier",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
				["use_name"] = true,
				["subcount"] = true,
				["name"] = "Shield Barrier",
				["fullscan"] = true,
				["name_operator"] = "==",
				["unit"] = "player",
				["names"] = {
					"Shield Barrier", -- [1]
				},
				["debuffType"] = "HELPFUL",
			},
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 30,
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["icon"] = true,
			["height"] = 30,
			["anchorPoint"] = "CENTER",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["r"] = {
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["controlledChildren"] = {
				"Timer 1st Engi", -- [1]
				"Timer 2nd Engi", -- [2]
			},
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = 0,
			["border"] = false,
			["yOffset"] = 0,
			["anchorPoint"] = "CENTER",
			["borderSize"] = 16,
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["expanded"] = true,
			["borderOffset"] = 5,
			["selfPoint"] = "BOTTOMLEFT",
			["additional_triggers"] = {
			},
			["id"] = "r",
			["frameStrata"] = 1,
			["untrigger"] = {
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["borderInset"] = 11,
			["numTriggers"] = 1,
			["borderEdge"] = "None",
			["trigger"] = {
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["load"] = {
				["class"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "group",
		},
		["Pally Devotion Aura"] = {
			["xOffset"] = 0,
			["customText"] = "function(...)\n    local GetAuraSourceName = function(aura)\n        local RAID_SIZE = 25 -- CHANGE THIS        \n        if not aura then return end\n        local auraName = aura\n        if type(aura) == 'number' then auraName = GetSpellInfo(aura) end\n        for i=1,RAID_SIZE do\n            local unitCaster = select(8, UnitAura('raid'..i, auraName))\n            if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n        end    \n        local unitCaster = select(8, UnitAura('player', auraName))\n        if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n    end\n    \n    return GetAuraSourceName(select(5, ...))    \nend",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "event",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["glow_action"] = "show",
					["message_type"] = "RAID",
					["do_glow"] = true,
					["do_message"] = false,
					["glow_frame"] = "WeakAuras:Pally Devotion Aura",
				},
				["finish"] = {
					["message_type"] = "RAID",
					["message"] = "",
					["do_message"] = false,
					["do_sound"] = false,
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["name_info"] = "aura",
				["unit"] = "group",
				["custom_hide"] = "timed",
				["names"] = {
					"Devotion Aura", -- [1]
				},
				["group_countOperator"] = ">=",
				["group_count"] = "2",
				["subeventPrefix"] = "SPELL",
				["event"] = "Health",
				["debuffType"] = "HELPFUL",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 60,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 19,
			["displayStacks"] = "  (%s) %n - %c",
			["regionType"] = "icon",
			["parent"] = "Raid Cooldowns Thok",
			["stacksPoint"] = "RIGHT",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["icon"] = true,
			["id"] = "Pally Devotion Aura",
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 60,
			["yOffset"] = 0,
			["numTriggers"] = 1,
			["inverse"] = false,
			["stickyDuration"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["additional_triggers"] = {
			},
			["cooldown"] = true,
			["textColor"] = {
				0.2549019607843137, -- [1]
				1, -- [2]
				0.01176470588235294, -- [3]
				1, -- [4]
			},
		},
		["Galakras - Flame Arrows"] = {
			["xOffset"] = 490,
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["debuffType"] = "HARMFUL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Flame Arrows", -- [1]
				},
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["cooldown"] = true,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_sound"] = false,
					["message_type"] = "SAY",
					["do_message"] = false,
					["sound"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\wilhelm.ogg",
				},
				["finish"] = {
				},
			},
			["id"] = "Galakras - Flame Arrows",
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 64,
			["yOffset"] = 166,
			["numTriggers"] = 1,
			["inverse"] = false,
			["selfPoint"] = "CENTER",
			["additional_triggers"] = {
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["SW: Death"] = {
			["fontSize"] = 12,
			["displayStacks"] = "%p",
			["cooldown"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "BOTTOM",
			["anchorPoint"] = "CENTER",
			["yOffset"] = -140,
			["regionType"] = "icon",
			["parent"] = "Shadow Priest",
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = true,
				},
				["finish"] = {
				},
			},
			["stickyDuration"] = false,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["id"] = "SW: Death",
			["width"] = 40,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["custom_hide"] = "timed",
				["use_spellName"] = true,
				["spellName"] = 32379,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
			},
			["font"] = "DorisPP",
			["inverse"] = true,
			["xOffset"] = -130,
			["height"] = 40,
			["untrigger"] = {
				["spellName"] = 32379,
			},
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["name"] = "Spih",
				["use_name"] = false,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["class"] = {
					["single"] = "PRIEST",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Protectors - Poison Cloud"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\WaterDrop.mp3",
					["do_message"] = false,
					["do_glow"] = false,
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["colorR"] = 1,
					["duration"] = "2",
					["colorB"] = 1,
					["colorG"] = 1,
					["scaleType"] = "pulse",
					["use_scale"] = true,
					["scalex"] = 2,
					["colorA"] = 1,
					["use_color"] = false,
					["alpha"] = 0,
					["x"] = 0,
					["y"] = 0,
					["colorType"] = "straightColor",
					["type"] = "custom",
					["scaley"] = 2,
					["colorFunc"] = "return function(progress, r1, g1, b1, a1, r2, g2, b2, a2)\n  return r1 + (progress * (r2 - r1)), g1 + (progress * (g2 - g1)), b1 + (progress * (b2 - b1)), a1 + (progress * (a2 - a1))\nend\n",
					["rotate"] = 0,
					["scaleFunc"] = "return function(progress, startX, startY, scaleX, scaleY)\n  local angle = (progress * 2 * math.pi) - (math.pi / 2)\n  return startX + (((math.sin(angle) + 1)/2) * (scaleX - 1)), startY + (((math.sin(angle) + 1)/2) * (scaleY - 1))\nend\n",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["names"] = {
					"Poison Cloud", -- [1]
				},
				["type"] = "aura",
				["debuffType"] = "HARMFUL",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["use_zone"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 18,
			["displayStacks"] = "%n",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["cooldown"] = true,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["stickyDuration"] = false,
			["additional_triggers"] = {
			},
			["yOffset"] = 166,
			["frameStrata"] = 1,
			["width"] = 64,
			["selfPoint"] = "CENTER",
			["numTriggers"] = 1,
			["inverse"] = false,
			["xOffset"] = 620,
			["id"] = "Protectors - Poison Cloud",
			["icon"] = true,
			["stacksPoint"] = "CENTER",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Tortos"] = {
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["controlledChildren"] = {
				"CrystalFull", -- [1]
				"Crystal Shell", -- [2]
				"New", -- [3]
			},
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = -190.1670532226563,
			["border"] = false,
			["yOffset"] = -312.111328125,
			["regionType"] = "group",
			["borderSize"] = 16,
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["expanded"] = false,
			["borderOffset"] = 5,
			["selfPoint"] = "BOTTOMLEFT",
			["id"] = "Tortos",
			["untrigger"] = {
			},
			["frameStrata"] = 1,
			["additional_triggers"] = {
			},
			["borderEdge"] = "None",
			["borderInset"] = 11,
			["numTriggers"] = 1,
			["trigger"] = {
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["load"] = {
				["class"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["anchorPoint"] = "CENTER",
		},
		["Track SWP Group"] = {
			["grow"] = "UP",
			["controlledChildren"] = {
				"SWP", -- [1]
			},
			["animate"] = false,
			["xOffset"] = 280,
			["border"] = "None",
			["yOffset"] = -175,
			["anchorPoint"] = "CENTER",
			["regionType"] = "dynamicgroup",
			["sort"] = "none",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["space"] = 2,
			["background"] = "None",
			["expanded"] = true,
			["constantFactor"] = "RADIUS",
			["id"] = "Track SWP Group",
			["borderOffset"] = 16,
			["trigger"] = {
			},
			["selfPoint"] = "BOTTOM",
			["align"] = "CENTER",
			["stagger"] = 0,
			["frameStrata"] = 1,
			["width"] = 199.9999389648438,
			["rotation"] = 0,
			["radius"] = 200,
			["numTriggers"] = 1,
			["backgroundInset"] = 0,
			["height"] = 15,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["load"] = {
				["class"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
		},
		["Sha of Pride - Aura of Pride"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["message"] = "Aura of Pride, Get Away!",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["do_message"] = true,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["ownOnly"] = true,
				["event"] = "Health",
				["unit"] = "player",
				["debuffType"] = "HARMFUL",
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Aura of Pride", -- [1]
				},
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "Spread 5 Yards! %p",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["cooldown"] = true,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["stickyDuration"] = false,
			["id"] = "Sha of Pride - Aura of Pride",
			["yOffset"] = 166,
			["frameStrata"] = 1,
			["width"] = 64,
			["selfPoint"] = "CENTER",
			["numTriggers"] = 1,
			["inverse"] = false,
			["xOffset"] = 620,
			["additional_triggers"] = {
			},
			["icon"] = true,
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Shaman Healing Tide Totem"] = {
			["xOffset"] = 0,
			["customText"] = "function(...)\n    local GetAuraSourceName = function(aura)\n        local RAID_SIZE = 25 -- CHANGE THIS        \n        if not aura then return end\n        local auraName = aura\n        if type(aura) == 'number' then auraName = GetSpellInfo(aura) end\n        for i=1,RAID_SIZE do\n            local unitCaster = select(8, UnitAura('raid'..i, auraName))\n            if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n        end    \n        local unitCaster = select(8, UnitAura('player', auraName))\n        if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n    end\n    \n    return GetAuraSourceName(select(5, ...))    \nend",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "event",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["glow_action"] = "show",
					["message_type"] = "RAID",
					["do_glow"] = true,
					["do_message"] = false,
					["glow_frame"] = "WeakAuras:Shaman Healing Tide Totem",
				},
				["finish"] = {
					["message_type"] = "RAID",
					["message"] = "",
					["do_message"] = false,
					["do_sound"] = false,
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["name_info"] = "aura",
				["unit"] = "group",
				["group_countOperator"] = ">=",
				["names"] = {
					"Healing Tide Totem", -- [1]
				},
				["custom_hide"] = "timed",
				["group_count"] = "2",
				["subeventPrefix"] = "SPELL",
				["event"] = "Health",
				["debuffType"] = "HELPFUL",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 60,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 19,
			["displayStacks"] = "  (%s) %n - %c",
			["regionType"] = "icon",
			["parent"] = "Raid Cooldowns Thok",
			["stacksPoint"] = "RIGHT",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["icon"] = true,
			["additional_triggers"] = {
			},
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 60,
			["yOffset"] = 0,
			["numTriggers"] = 1,
			["inverse"] = false,
			["stickyDuration"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["id"] = "Shaman Healing Tide Totem",
			["cooldown"] = true,
			["textColor"] = {
				0.2549019607843137, -- [1]
				1, -- [2]
				0.01176470588235294, -- [3]
				1, -- [4]
			},
		},
		["Mindbender"] = {
			["fontSize"] = 12,
			["displayStacks"] = "%p",
			["stacksPoint"] = "BOTTOM",
			["xOffset"] = -180,
			["cooldown"] = true,
			["parent"] = "Shadow Priest",
			["untrigger"] = {
				["spellName"] = 123040,
			},
			["anchorPoint"] = "CENTER",
			["yOffset"] = -140,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["inverse"] = true,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["debuffType"] = "HELPFUL",
				["use_spellName"] = true,
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
				["unevent"] = "auto",
				["use_unit"] = true,
				["spellName"] = 123040,
				["custom_hide"] = "timed",
			},
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["duration_type"] = "seconds",
					["preset"] = "fade",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["duration_type"] = "seconds",
					["preset"] = "fade",
				},
			},
			["id"] = "Mindbender",
			["desaturate"] = false,
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["width"] = 40,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
					["do_custom"] = true,
				},
				["finish"] = {
				},
			},
			["height"] = 40,
			["regionType"] = "icon",
			["load"] = {
				["use_name"] = false,
				["role"] = {
					["multi"] = {
					},
				},
				["name"] = "Spih",
				["use_class"] = true,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["class"] = {
					["single"] = "PRIEST",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Intervene"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["parent"] = "Tank CDs 3",
			["xOffset"] = 0,
			["cooldown"] = true,
			["stacksPoint"] = "RIGHT",
			["untrigger"] = {
				["spellName"] = 3411,
			},
			["regionType"] = "icon",
			["yOffset"] = 0,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["inverse"] = true,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["id"] = "TCD: Intervene",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["use_itemName"] = true,
				["unit"] = "player",
				["subeventPrefix"] = "SPELL",
				["use_spellName"] = true,
				["unevent"] = "auto",
				["use_unit"] = true,
				["itemName"] = 0,
				["spellName"] = 3411,
				["event"] = "Cooldown Progress (Spell)",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 30,
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["icon"] = true,
			["height"] = 30,
			["anchorPoint"] = "CENTER",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Weakened Armor"] = {
			["color"] = {
				1, -- [1]
				0, -- [2]
				0.3176470588235294, -- [3]
				1, -- [4]
			},
			["fontSize"] = 12,
			["displayStacks"] = "%s",
			["load"] = {
				["use_class"] = false,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["use_combat"] = true,
				["class"] = {
					["multi"] = {
						["DRUID"] = true,
						["WARRIOR"] = true,
						["ROGUE"] = true,
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["parent"] = "weakened armor",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["yOffset"] = 0,
			["regionType"] = "icon",
			["icon"] = true,
			["numTriggers"] = 1,
			["stickyDuration"] = false,
			["customTextUpdate"] = "update",
			["additional_triggers"] = {
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["width"] = 64,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["unit"] = "target",
				["type"] = "aura",
				["inverse"] = true,
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HARMFUL",
				["names"] = {
					"Weakened Armor", -- [1]
				},
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["id"] = "Weakened Armor",
			["frameStrata"] = 1,
			["desaturate"] = false,
			["selfPoint"] = "CENTER",
			["font"] = "Friz Quadrata TT",
			["inverse"] = false,
			["xOffset"] = 0,
			["height"] = 64,
			["displayIcon"] = "Interface\\Icons\\Ability_Warrior_Sunder",
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Shockwave"] = {
			["xOffset"] = 15,
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["spellName"] = 46968,
				["use_spellName"] = true,
				["use_remaining"] = false,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Shield Block", -- [1]
				},
				["debuffType"] = "HELPFUL",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 30,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["stickyDuration"] = false,
			["cooldown"] = true,
			["disjunctive"] = true,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["parent"] = "Tank CDs",
			["additional_triggers"] = {
			},
			["id"] = "TCD: Shockwave",
			["frameStrata"] = 1,
			["width"] = 30,
			["numTriggers"] = 1,
			["untrigger"] = {
				["spellName"] = 46968,
			},
			["inverse"] = true,
			["selfPoint"] = "CENTER",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["icon"] = true,
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Berserker Rage"] = {
			["parent"] = "Tank DPS Buffs",
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["do_glow"] = true,
					["do_custom"] = false,
					["glow_action"] = "show",
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Berserker Rage", -- [1]
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 30,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["disjunctive"] = true,
			["stacksPoint"] = "BOTTOM",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["id"] = "Berserker Rage",
			["additional_triggers"] = {
				{
					["trigger"] = {
						["type"] = "aura",
						["debuffType"] = "HELPFUL",
						["subeventSuffix"] = "_CAST_START",
						["unit"] = "player",
						["names"] = {
							"Time Warp", -- [1]
						},
						["event"] = "Health",
						["subeventPrefix"] = "SPELL",
					},
					["untrigger"] = {
					},
				}, -- [1]
			},
			["icon"] = true,
			["frameStrata"] = 1,
			["width"] = 30,
			["numTriggers"] = 2,
			["untrigger"] = {
			},
			["inverse"] = false,
			["stickyDuration"] = false,
			["xOffset"] = 0,
			["selfPoint"] = "CENTER",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Dark Shamans - Falling Ash Warning"] = {
			["textFlags"] = "None",
			["stacksSize"] = 38,
			["borderBackdrop"] = "Blizzard Tooltip",
			["color"] = {
				0.8392156862745098, -- [1]
				1, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["stacksFlags"] = "None",
			["untrigger"] = {
				["use_specific_unit"] = true,
				["unit"] = "Earthbreaker Haromm",
			},
			["anchorPoint"] = "CENTER",
			["parent"] = "SoO 1st Part",
			["textSize"] = 38,
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "update",
			["rotateText"] = "NONE",
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["yOffset"] = 335.0004272460938,
			["actions"] = {
				["start"] = {
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_sound"] = false,
				},
				["finish"] = {
					["message"] = "Meteor Falling in 5, POP A CD!",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["do_message"] = true,
					["sound"] = "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.wav",
				},
			},
			["animation"] = {
				["start"] = {
					["preset"] = "bounceDecay",
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["preset"] = "alphaPulse",
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["inverse"] = false,
			["selfPoint"] = "BOTTOM",
			["trigger"] = {
				["use_castType"] = false,
				["sourceunit"] = "target",
				["source"] = "Earthbreaker Haromm",
				["duration"] = "11",
				["use_spell"] = true,
				["unit"] = "Earthbreaker Haromm",
				["spellName"] = "Falling Ash",
				["type"] = "event",
				["use_specific_unit"] = true,
				["unevent"] = "timed",
				["use_unit"] = true,
				["event"] = "Combat Log",
				["use_source"] = false,
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["use_spellName"] = true,
				["spell"] = "Ashen Wall",
				["use_sourceunit"] = false,
				["use_destunit"] = false,
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
			},
			["text"] = true,
			["barColor"] = {
				1, -- [1]
				0, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["barInFront"] = true,
			["font"] = "Friz Quadrata TT",
			["icon"] = true,
			["height"] = 0.9999997019767761,
			["timer"] = true,
			["timerFlags"] = "None",
			["load"] = {
				["role"] = {
					["single"] = "TANK",
					["multi"] = {
						["TANK"] = true,
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["class"] = {
					["single"] = "PALADIN",
					["multi"] = {
						["PALADIN"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["alpha"] = 1,
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["fontSize"] = 55,
			["borderSize"] = 16,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["additional_triggers"] = {
			},
			["displayTextRight"] = "%p",
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "text",
			["stacks"] = true,
			["timerSize"] = 38,
			["icon_side"] = "LEFT",
			["stacksFont"] = "Friz Quadrata TT",
			["displayText"] = "",
			["borderOffset"] = 5,
			["texture"] = "Blizzard",
			["textFont"] = "Friz Quadrata TT",
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["justify"] = "LEFT",
			["auto"] = true,
			["id"] = "Dark Shamans - Falling Ash Warning",
			["timerFont"] = "Friz Quadrata TT",
			["frameStrata"] = 1,
			["width"] = 0.9999997019767761,
			["xOffset"] = 113.000244140625,
			["borderInset"] = 11,
			["numTriggers"] = 1,
			["stickyDuration"] = false,
			["orientation"] = "HORIZONTAL",
			["outline"] = true,
			["displayTextLeft"] = "Falling Ash",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Injection Bar Skip"] = {
			["textFlags"] = "None",
			["stacksSize"] = 17,
			["borderBackdrop"] = "Blizzard Tooltip",
			["parent"] = "Injection+",
			["stacksFlags"] = "None",
			["customText"] = "function()\n    return WA_DEV.count + 1\nend\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
			["barInFront"] = true,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "event",
			["rotateText"] = "NONE",
			["textSize"] = 12,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "custom",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["duration"] = "9",
				["event"] = "Chat Message",
				["unit"] = "player",
				["customDuration"] = "function()\n    return 9\nend\n\n\n\n\n\n\n",
				["names"] = {
				},
				["events"] = "COMBAT_LOG_EVENT_UNFILTERED",
				["subeventPrefix"] = "SPELL",
				["unevent"] = "auto",
				["custom_type"] = "event",
				["custom"] = "function(_,timeStamp,message,_,_,source,_,_,_,target,tarGUID,_,_,spell)\n    if spell == 'Injection' and message == 'SPELL_CAST_SUCCESS' then\n        WA_DEV = WA_DEV or {}\n        WA_DEV.count = WA_DEV.count or 1\n        \n        WA_DEV.last = WA_DEV.last or 0\n        \n        local count = WA_DEV.count + 1\n        \n        return count == 1 or count == 7\n    else\n        return false\n    end\nend\n\n\n",
				["custom_hide"] = "timed",
			},
			["text"] = true,
			["barColor"] = {
				0, -- [1]
				1, -- [2]
				0.07058823529411765, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["selfPoint"] = "CENTER",
			["untrigger"] = {
			},
			["stickyDuration"] = false,
			["timer"] = true,
			["timerFlags"] = "None",
			["load"] = {
				["class"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["icon"] = false,
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["displayTextLeft"] = "Injection (%c)",
			["numTriggers"] = 1,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["xOffset"] = 0,
			["borderSize"] = 16,
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "aurabar",
			["stacks"] = true,
			["displayTextRight"] = "%p",
			["icon_side"] = "RIGHT",
			["frameStrata"] = 1,
			["stacksFont"] = "Enigmatic",
			["timerSize"] = 12,
			["texture"] = "Minimalist",
			["textFont"] = "DorisPP",
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["auto"] = true,
			["borderOffset"] = 5,
			["id"] = "Injection Bar Skip",
			["timerFont"] = "DorisPP",
			["alpha"] = 1,
			["width"] = 400,
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["borderInset"] = 11,
			["inverse"] = false,
			["yOffset"] = 165,
			["orientation"] = "HORIZONTAL",
			["height"] = 20,
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Crit Banner"] = {
			["cooldown"] = true,
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["parent"] = "Tank DPS Buffs",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
			},
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["xOffset"] = 0,
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["stickyDuration"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["type"] = "event",
				["subeventSuffix"] = "_CAST_SUCCESS",
				["duration"] = "10",
				["event"] = "Combat Log",
				["unit"] = "player",
				["use_spellName"] = true,
				["spellName"] = "Skull Banner",
				["unevent"] = "timed",
				["custom_hide"] = "timed",
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Recklessness", -- [1]
				},
				["debuffType"] = "HELPFUL",
			},
			["width"] = 30,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "Crit Banner",
			["font"] = "DorisPP",
			["inverse"] = false,
			["regionType"] = "icon",
			["height"] = 30,
			["displayIcon"] = "Interface\\Icons\\warrior_skullbanner",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Vigilance"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["parent"] = "Tank CDs Long",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["stacksPoint"] = "RIGHT",
			["yOffset"] = 0,
			["regionType"] = "icon",
			["untrigger"] = {
				["spellName"] = 114030,
			},
			["xOffset"] = 0,
			["inverse"] = true,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["id"] = "TCD: Vigilance",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["use_itemName"] = true,
				["unit"] = "player",
				["subeventPrefix"] = "SPELL",
				["use_spellName"] = true,
				["unevent"] = "auto",
				["use_unit"] = true,
				["itemName"] = 0,
				["spellName"] = 114030,
				["event"] = "Cooldown Progress (Spell)",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 30,
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["icon"] = true,
			["height"] = 30,
			["anchorPoint"] = "CENTER",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Pummel"] = {
			["disjunctive"] = true,
			["untrigger"] = {
				["spellName"] = 6552,
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["names"] = {
					"Shield Block", -- [1]
				},
				["use_spellName"] = true,
				["subeventPrefix"] = "SPELL",
				["unevent"] = "auto",
				["use_unit"] = true,
				["use_remaining"] = false,
				["spellName"] = 6552,
				["custom_hide"] = "timed",
			},
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["height"] = 30,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["desaturate"] = false,
			["stacksPoint"] = "BOTTOM",
			["selfPoint"] = "CENTER",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["xOffset"] = 46,
			["additional_triggers"] = {
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["frameStrata"] = 1,
			["width"] = 30,
			["inverse"] = true,
			["yOffset"] = 20,
			["numTriggers"] = 1,
			["parent"] = "Tank CDs",
			["id"] = "TCD: Pummel",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Shiel Wall"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["cooldown"] = true,
			["anchorPoint"] = "CENTER",
			["yOffset"] = 20,
			["regionType"] = "icon",
			["xOffset"] = 170,
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["inverse"] = false,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["id"] = "TCD: Shiel Wall",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["unit"] = "player",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Shield Wall", -- [1]
				},
				["debuffType"] = "HELPFUL",
				["event"] = "Health",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 30,
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["parent"] = "Tank Def Buffs",
			["height"] = 30,
			["untrigger"] = {
			},
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Devo Plauge 3"] = {
			["cooldown"] = false,
			["fontSize"] = 12,
			["displayStacks"] = "%s",
			["stacksPoint"] = "BOTTOM",
			["color"] = {
				0.9254901960784314, -- [1]
				1, -- [2]
				0.9294117647058824, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
				["spellName"] = 8092,
			},
			["regionType"] = "icon",
			["yOffset"] = -140,
			["anchorPoint"] = "CENTER",
			["xOffset"] = -80,
			["numTriggers"] = 1,
			["icon"] = true,
			["customTextUpdate"] = "update",
			["stickyDuration"] = false,
			["actions"] = {
				["start"] = {
					["do_custom"] = true,
				},
				["finish"] = {
				},
			},
			["width"] = 40,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["id"] = "Devo Plauge 3",
			["trigger"] = {
				["type"] = "status",
				["custom_hide"] = "timed",
				["power"] = "3",
				["power_operator"] = "==",
				["use_power"] = true,
				["event"] = "Shadow Orbs",
				["unit"] = "player",
				["spellName"] = 8092,
				["use_spellName"] = true,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
			},
			["frameStrata"] = 1,
			["desaturate"] = false,
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["font"] = "DorisPP",
			["inverse"] = false,
			["parent"] = "Shadow Priest",
			["height"] = 40,
			["displayIcon"] = "Interface\\Icons\\Spell_Shadow_DevouringPlague.",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["name"] = "Spih",
				["use_name"] = false,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["class"] = {
					["single"] = "PRIEST",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				0, -- [1]
				1, -- [2]
				0.06666666666666667, -- [3]
				1, -- [4]
			},
		},
		["Dark Shamans - Froststorm Strike 2nd Tank"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_sound"] = false,
					["message_type"] = "SAY",
					["do_message"] = false,
					["sound"] = "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.wav",
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Health",
				["unit"] = "member",
				["specificUnit"] = "Malvision",
				["debuffType"] = "HARMFUL",
				["names"] = {
					"Froststorm Strike", -- [1]
				},
				["subeventPrefix"] = "SPELL",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 54,
			["load"] = {
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_role"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["role"] = {
					["single"] = "TANK",
					["multi"] = {
					},
				},
				["use_combat"] = true,
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "%s  %p",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["stacksPoint"] = "BOTTOM",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["stickyDuration"] = false,
			["id"] = "Dark Shamans - Froststorm Strike 2nd Tank",
			["yOffset"] = 161,
			["frameStrata"] = 1,
			["width"] = 54,
			["icon"] = true,
			["numTriggers"] = 1,
			["inverse"] = false,
			["xOffset"] = 555,
			["additional_triggers"] = {
			},
			["selfPoint"] = "CENTER",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["VT"] = {
			["textFlags"] = "None",
			["stacksSize"] = 12,
			["borderBackdrop"] = "Blizzard Tooltip",
			["parent"] = "Track VT Group",
			["stacksFlags"] = "None",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "update",
			["rotateText"] = "NONE",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
				["name"] = "Vampiric Touch",
				["debuffType"] = "HARMFUL",
				["names"] = {
				},
				["unit"] = "multi",
				["custom_hide"] = "timed",
			},
			["text"] = true,
			["barColor"] = {
				0.2823529411764706, -- [1]
				0.5882352941176471, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["selfPoint"] = "CENTER",
			["displayTextLeft"] = "%p",
			["textSize"] = 12,
			["timer"] = true,
			["timerFlags"] = "None",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_talent"] = false,
				["spec"] = {
					["single"] = 3,
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "PRIEST",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["icon"] = true,
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["yOffset"] = 0,
			["inverse"] = false,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["xOffset"] = 0,
			["stacks"] = true,
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "aurabar",
			["borderSize"] = 16,
			["auto"] = true,
			["icon_side"] = "RIGHT",
			["alpha"] = 1,
			["stacksFont"] = "Friz Quadrata TT",
			["displayTextRight"] = "%n",
			["texture"] = "Flat",
			["textFont"] = "DorisPP",
			["borderOffset"] = 5,
			["timerSize"] = 10,
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["id"] = "VT",
			["timerFont"] = "DorisPP",
			["frameStrata"] = 1,
			["width"] = 200,
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["borderInset"] = 11,
			["numTriggers"] = 1,
			["height"] = 15,
			["orientation"] = "HORIZONTAL",
			["barInFront"] = true,
			["stickyDuration"] = false,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Dark Shamans - Falling Ash Warning 2"] = {
			["textFlags"] = "None",
			["stacksSize"] = 38,
			["borderBackdrop"] = "Blizzard Tooltip",
			["color"] = {
				0.8392156862745098, -- [1]
				1, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["stacksFlags"] = "None",
			["untrigger"] = {
				["use_specific_unit"] = true,
				["unit"] = "Earthbreaker Haromm",
			},
			["anchorPoint"] = "CENTER",
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "update",
			["rotateText"] = "NONE",
			["textSize"] = 38,
			["outline"] = true,
			["xOffset"] = -54.999755859375,
			["yOffset"] = 257.75048828125,
			["animation"] = {
				["start"] = {
					["preset"] = "bounceDecay",
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["preset"] = "alphaPulse",
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["selfPoint"] = "BOTTOM",
			["trigger"] = {
				["use_castType"] = false,
				["sourceunit"] = "target",
				["source"] = "Earthbreaker Haromm",
				["duration"] = "16",
				["use_spell"] = true,
				["unit"] = "Earthbreaker Haromm",
				["custom_hide"] = "timed",
				["spell"] = "Ashen Wall",
				["subeventPrefix"] = "SPELL",
				["unevent"] = "timed",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
				["event"] = "Combat Log",
				["subeventSuffix"] = "_CAST_START",
				["spellName"] = "Falling Ash",
				["use_spellName"] = true,
				["use_source"] = false,
				["use_sourceunit"] = false,
				["use_destunit"] = false,
				["type"] = "event",
				["use_unit"] = true,
				["use_specific_unit"] = true,
			},
			["text"] = true,
			["barColor"] = {
				1, -- [1]
				0, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["inverse"] = false,
			["font"] = "DorisPP",
			["displayTextLeft"] = "Falling Ash",
			["timer"] = true,
			["height"] = 54.99990081787109,
			["timerFlags"] = "None",
			["load"] = {
				["role"] = {
					["single"] = "TANK",
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_combat"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_role"] = true,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["class"] = {
					["single"] = "PALADIN",
					["multi"] = {
						["PALADIN"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["barInFront"] = true,
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["fontSize"] = 55,
			["frameStrata"] = 1,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["borderSize"] = 16,
			["additional_triggers"] = {
			},
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "text",
			["stacks"] = true,
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["icon_side"] = "LEFT",
			["auto"] = true,
			["borderOffset"] = 5,
			["displayTextRight"] = "%p",
			["texture"] = "Blizzard",
			["textFont"] = "Friz Quadrata TT",
			["stacksFont"] = "Friz Quadrata TT",
			["timerSize"] = 38,
			["justify"] = "LEFT",
			["id"] = "Dark Shamans - Falling Ash Warning 2",
			["timerFont"] = "Friz Quadrata TT",
			["alpha"] = 1,
			["width"] = 696.3516845703125,
			["displayText"] = "Falling Ash Damage:  %p",
			["borderInset"] = 11,
			["numTriggers"] = 1,
			["stickyDuration"] = false,
			["orientation"] = "HORIZONTAL",
			["icon"] = true,
			["actions"] = {
				["start"] = {
					["sound_channel"] = "Master",
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_sound"] = false,
				},
				["finish"] = {
					["message"] = "Meteor Falling in 5, POP A CD!",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["do_message"] = false,
					["sound"] = "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.wav",
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Demo"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["parent"] = "Tank Def Buffs",
			["cooldown"] = true,
			["regionType"] = "icon",
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["inverse"] = false,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["trigger"] = {
				["unit"] = "player",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Demoralizing Shout", -- [1]
				},
				["debuffType"] = "HELPFUL",
				["event"] = "Health",
				["custom_hide"] = "timed",
			},
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "Demo",
			["desaturate"] = false,
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["width"] = 30,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["xOffset"] = 170,
			["height"] = 30,
			["untrigger"] = {
			},
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Reck"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["stacksPoint"] = "RIGHT",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["xOffset"] = 0,
			["yOffset"] = 0,
			["anchorPoint"] = "CENTER",
			["untrigger"] = {
				["spellName"] = 1719,
			},
			["parent"] = "Tank CDs 2",
			["inverse"] = true,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["unit"] = "player",
				["event"] = "Cooldown Progress (Spell)",
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
				["use_spellName"] = true,
				["unevent"] = "auto",
				["use_unit"] = true,
				["itemName"] = 0,
				["spellName"] = 1719,
				["use_itemName"] = true,
				["custom_hide"] = "timed",
			},
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "TCD: Reck",
			["desaturate"] = false,
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["width"] = 30,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["height"] = 30,
			["regionType"] = "icon",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Track VT Group"] = {
			["grow"] = "UP",
			["controlledChildren"] = {
				"VT", -- [1]
			},
			["animate"] = false,
			["xOffset"] = 280,
			["border"] = "None",
			["yOffset"] = -65,
			["anchorPoint"] = "CENTER",
			["regionType"] = "dynamicgroup",
			["sort"] = "none",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["space"] = 2,
			["background"] = "None",
			["expanded"] = true,
			["constantFactor"] = "RADIUS",
			["id"] = "Track VT Group",
			["borderOffset"] = 16,
			["trigger"] = {
			},
			["selfPoint"] = "BOTTOM",
			["align"] = "CENTER",
			["stagger"] = 0,
			["frameStrata"] = 1,
			["width"] = 199.9999389648438,
			["rotation"] = 0,
			["radius"] = 200,
			["numTriggers"] = 1,
			["backgroundInset"] = 0,
			["height"] = 15,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["load"] = {
				["class"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
		},
		["Tricks 2"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["groupclone"] = true,
				["name_info"] = "aura",
				["unit"] = "group",
				["debuffType"] = "HELPFUL",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
				["group_count"] = "1",
				["custom_hide"] = "timed",
				["names"] = {
					"Tricks of the Trade", -- [1]
				},
				["group_countOperator"] = ">=",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["parent"] = "Tricks of the Trade Group",
			["xOffset"] = -661.9999084472656,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = false,
			["id"] = "Tricks 2",
			["additional_triggers"] = {
			},
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 64,
			["yOffset"] = 371.0000610351563,
			["inverse"] = false,
			["numTriggers"] = 1,
			["stickyDuration"] = false,
			["actions"] = {
				["start"] = {
					["do_message"] = true,
					["message_type"] = "SAY",
				},
				["finish"] = {
				},
			},
			["displayIcon"] = "Interface\\Icons\\Ability_Rogue_TricksOftheTrade",
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Injection+"] = {
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["controlledChildren"] = {
				"Injection Bar", -- [1]
				"Injection Bar Skip", -- [2]
			},
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = 0,
			["border"] = false,
			["yOffset"] = 0,
			["anchorPoint"] = "CENTER",
			["borderSize"] = 16,
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["borderOffset"] = 5,
			["selfPoint"] = "BOTTOMLEFT",
			["trigger"] = {
				["unit"] = "player",
				["type"] = "aura",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
			},
			["frameStrata"] = 1,
			["regionType"] = "group",
			["untrigger"] = {
			},
			["borderInset"] = 11,
			["numTriggers"] = 1,
			["id"] = "Injection+",
			["borderEdge"] = "None",
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["load"] = {
				["class"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["expanded"] = true,
		},
		["DPS Lust"] = {
			["parent"] = "Tank DPS Buffs",
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["do_glow"] = true,
					["do_custom"] = false,
					["glow_action"] = "show",
				},
				["finish"] = {
				},
			},
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Bloodlust", -- [1]
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 30,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["disjunctive"] = true,
			["stacksPoint"] = "BOTTOM",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["additional_triggers"] = {
				{
					["trigger"] = {
						["type"] = "aura",
						["debuffType"] = "HELPFUL",
						["subeventSuffix"] = "_CAST_START",
						["unit"] = "player",
						["names"] = {
							"Time Warp", -- [1]
						},
						["event"] = "Health",
						["subeventPrefix"] = "SPELL",
					},
					["untrigger"] = {
					},
				}, -- [1]
			},
			["id"] = "DPS Lust",
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 30,
			["inverse"] = false,
			["icon"] = true,
			["numTriggers"] = 2,
			["untrigger"] = {
			},
			["xOffset"] = 0,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Nazgrim - Defensive Stance Alert"] = {
			["stacksPoint"] = "BOTTOM",
			["fontSize"] = 24,
			["displayStacks"] = "Defensive Stance",
			["cooldown"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["xOffset"] = 555,
			["regionType"] = "icon",
			["untrigger"] = {
				["form"] = 0,
				["use_specific_unit"] = true,
				["unit"] = "member",
			},
			["anchorPoint"] = "CENTER",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_message"] = false,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\BikeHorn.mp3",
					["do_sound"] = true,
				},
				["finish"] = {
				},
			},
			["numTriggers"] = 1,
			["stickyDuration"] = false,
			["customTextUpdate"] = "update",
			["additional_triggers"] = {
			},
			["icon"] = true,
			["width"] = 64,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["preset"] = "bounceDecay",
					["type"] = "preset",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["use_form"] = true,
				["source"] = "General Nazgrim",
				["duration"] = "60.5",
				["names"] = {
					"Defensive Stance", -- [1]
				},
				["specificUnit"] = "boss1",
				["custom_hide"] = "timed",
				["type"] = "event",
				["subeventSuffix"] = "_AURA_APPLIED",
				["use_specific_unit"] = true,
				["form"] = 0,
				["event"] = "Combat Log",
				["use_unit"] = true,
				["use_source"] = true,
				["use_spellName"] = true,
				["unit"] = "member",
				["unevent"] = "timed",
				["debuffType"] = "HARMFUL",
				["use_inverse"] = false,
				["spellName"] = "Defensive Stance",
				["subeventPrefix"] = "SPELL",
			},
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "Nazgrim - Defensive Stance Alert",
			["font"] = "Friz Quadrata TT",
			["inverse"] = false,
			["yOffset"] = 166,
			["height"] = 64,
			["displayIcon"] = "Interface\\Icons\\Ability_Warrior_DefensiveStance",
			["load"] = {
				["use_zone"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Vampiric Touch"] = {
			["fontSize"] = 12,
			["displayStacks"] = "%p",
			["cooldown"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "BOTTOM",
			["anchorPoint"] = "CENTER",
			["yOffset"] = -140,
			["regionType"] = "icon",
			["parent"] = "Shadow Priest",
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = true,
				},
				["finish"] = {
				},
			},
			["stickyDuration"] = false,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["id"] = "Vampiric Touch",
			["width"] = 40,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["ownOnly"] = true,
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "target",
				["custom_hide"] = "timed",
				["use_spellName"] = true,
				["spellName"] = 8092,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Vampiric Touch", -- [1]
				},
				["debuffType"] = "HARMFUL",
			},
			["font"] = "DorisPP",
			["inverse"] = false,
			["xOffset"] = 30,
			["height"] = 40,
			["untrigger"] = {
				["spellName"] = 8092,
			},
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["name"] = "Spih",
				["use_name"] = false,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["class"] = {
					["single"] = "PRIEST",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Showeave"] = {
			["outline"] = true,
			["fontSize"] = 12,
			["displayStacks"] = "%t",
			["anchorPoint"] = "CENTER",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayText"] = "New",
			["load"] = {
				["class"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["yOffset"] = 288.7498168945313,
			["regionType"] = "icon",
			["xOffset"] = -459,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["auto"] = true,
			["customTextUpdate"] = "update",
			["numTriggers"] = 1,
			["icon"] = true,
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["ownOnly"] = true,
				["event"] = "Health",
				["unit"] = "focus",
				["use_name"] = true,
				["debuffType"] = "HARMFUL",
				["name"] = "Shockwave",
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
				["name_operator"] = "==",
				["autoclone"] = false,
				["fullscan"] = true,
			},
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["justify"] = "LEFT",
			["selfPoint"] = "BOTTOM",
			["id"] = "Showeave",
			["desaturate"] = false,
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["width"] = 54.74983215332031,
			["font"] = "DorisPP",
			["inverse"] = false,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["height"] = 47.99990081787109,
			["untrigger"] = {
			},
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Heroic Leap"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["xOffset"] = 0,
			["stacksPoint"] = "RIGHT",
			["anchorPoint"] = "CENTER",
			["yOffset"] = 0,
			["regionType"] = "icon",
			["untrigger"] = {
				["spellName"] = 6544,
			},
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["stickyDuration"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["id"] = "TCD: Heroic Leap",
			["width"] = 30,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["event"] = "Cooldown Progress (Spell)",
				["use_itemName"] = true,
				["names"] = {
				},
				["spellName"] = 6544,
				["use_spellName"] = true,
				["itemName"] = 0,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["unit"] = "player",
				["debuffType"] = "HELPFUL",
			},
			["font"] = "DorisPP",
			["inverse"] = true,
			["parent"] = "Tank CDs 3",
			["height"] = 30,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Dark Shamans - Iron Prison"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["do_message"] = false,
					["sound"] = "Sound\\Creature\\AlgalonTheObserver\\UR_Algalon_BHole01.wav",
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["names"] = {
					"Iron Prison", -- [1]
				},
				["type"] = "aura",
				["debuffType"] = "HARMFUL",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "Move out!  %p",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["cooldown"] = true,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["stickyDuration"] = false,
			["additional_triggers"] = {
			},
			["yOffset"] = 166,
			["frameStrata"] = 1,
			["width"] = 64,
			["selfPoint"] = "CENTER",
			["numTriggers"] = 1,
			["inverse"] = false,
			["xOffset"] = 490,
			["id"] = "Dark Shamans - Iron Prison",
			["icon"] = true,
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: TC"] = {
			["xOffset"] = 77,
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["spellName"] = 6343,
				["use_spellName"] = true,
				["use_remaining"] = false,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Shield Block", -- [1]
				},
				["debuffType"] = "HELPFUL",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 30,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["stickyDuration"] = false,
			["cooldown"] = true,
			["parent"] = "Tank CDs",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["disjunctive"] = true,
			["additional_triggers"] = {
			},
			["id"] = "TCD: TC",
			["frameStrata"] = 1,
			["width"] = 30,
			["numTriggers"] = 1,
			["untrigger"] = {
				["spellName"] = 6343,
			},
			["inverse"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["selfPoint"] = "CENTER",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Mocking Banner"] = {
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["stacksPoint"] = "BOTTOM",
			["parent"] = "Tank DPS Buffs",
			["xOffset"] = 0,
			["yOffset"] = 20,
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["regionType"] = "icon",
			["inverse"] = false,
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["customTextUpdate"] = "update",
			["id"] = "Mocking Banner",
			["icon"] = true,
			["desaturate"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "event",
				["subeventSuffix"] = "_CAST_SUCCESS",
				["duration"] = "30",
				["event"] = "Combat Log",
				["unit"] = "player",
				["use_spellName"] = true,
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Recklessness", -- [1]
				},
				["subeventPrefix"] = "SPELL",
				["custom_hide"] = "timed",
				["unevent"] = "timed",
				["spellName"] = "Mocking Banner",
			},
			["width"] = 30,
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["height"] = 30,
			["displayIcon"] = "Interface\\Icons\\mocking_banner",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Shaman Spirit Link Totem"] = {
			["xOffset"] = 0,
			["customText"] = "function(...)\n    local GetAuraSourceName = function(aura)\n        local RAID_SIZE = 25 -- CHANGE THIS        \n        if not aura then return end\n        local auraName = aura\n        if type(aura) == 'number' then auraName = GetSpellInfo(aura) end\n        for i=1,RAID_SIZE do\n            local unitCaster = select(8, UnitAura('raid'..i, auraName))\n            if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n        end    \n        local unitCaster = select(8, UnitAura('player', auraName))\n        if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n    end\n    \n    return GetAuraSourceName(select(5, ...))    \nend",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "event",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["glow_action"] = "show",
					["message_type"] = "RAID",
					["do_glow"] = true,
					["do_message"] = false,
					["glow_frame"] = "WeakAuras:Shaman Spirit Link Totem",
				},
				["finish"] = {
					["message_type"] = "RAID",
					["message"] = "",
					["do_message"] = false,
					["do_sound"] = false,
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["name_info"] = "aura",
				["unit"] = "group",
				["custom_hide"] = "timed",
				["names"] = {
					"Spirit Link Totem", -- [1]
				},
				["group_countOperator"] = ">=",
				["group_count"] = "2",
				["subeventPrefix"] = "SPELL",
				["event"] = "Health",
				["debuffType"] = "HELPFUL",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 60,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 19,
			["displayStacks"] = "  (%s) %n - %c",
			["regionType"] = "icon",
			["parent"] = "Raid Cooldowns Thok",
			["stacksPoint"] = "RIGHT",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["icon"] = true,
			["id"] = "Shaman Spirit Link Totem",
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 60,
			["yOffset"] = 0,
			["numTriggers"] = 1,
			["inverse"] = false,
			["stickyDuration"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["additional_triggers"] = {
			},
			["cooldown"] = true,
			["textColor"] = {
				0.2549019607843137, -- [1]
				1, -- [2]
				0.01176470588235294, -- [3]
				1, -- [4]
			},
		},
		["Timer 2nd Engi"] = {
			["outline"] = true,
			["fontSize"] = 12,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayText"] = "",
			["yOffset"] = 0,
			["regionType"] = "text",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_sound"] = false,
				},
				["finish"] = {
					["message"] = "*** ENGINEER TIME!  MOVE OUT! ***",
					["do_sound"] = false,
					["message_type"] = "YELL",
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_message"] = true,
				},
			},
			["parent"] = "r",
			["selfPoint"] = "BOTTOM",
			["additional_triggers"] = {
				{
					["trigger"] = {
						["type"] = "custom",
						["custom"] = "function()\n    if UnitName(\"boss1\") == \"Garrosh Hellscream\" then\n        return true\n    else \n        return false\n    end\nend",
						["subeventSuffix"] = "_CAST_START",
						["check"] = "update",
						["custom_type"] = "status",
						["event"] = "Health",
						["subeventPrefix"] = "SPELL",
					},
					["untrigger"] = {
						["custom"] = "function()\n    return true\nend",
					},
				}, -- [1]
			},
			["justify"] = "LEFT",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["debuffType"] = "HELPFUL",
				["type"] = "custom",
				["unevent"] = "timed",
				["custom_type"] = "event",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["event"] = "Combat Log",
				["use_unit"] = true,
				["customDuration"] = "function()\n    return 10, GetTime() + 62\nend",
				["character"] = "player",
				["custom"] = "function(event, ...)\n    return event == \"PLAYER_REGEN_DISABLED\"\nend",
				["unit"] = "player",
				["events"] = "PLAYER_REGEN_DISABLED",
				["use_character"] = true,
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "custom",
			},
			["disjunctive"] = false,
			["frameStrata"] = 1,
			["width"] = 0.9999997019767761,
			["xOffset"] = 0,
			["font"] = "Friz Quadrata TT",
			["numTriggers"] = 2,
			["anchorPoint"] = "CENTER",
			["height"] = 0.9999997019767761,
			["id"] = "Timer 2nd Engi",
			["load"] = {
				["difficulty"] = "heroic",
				["use_zone"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["zone"] = "Siege of Orgrimmar",
				["spec"] = {
					["multi"] = {
					},
				},
				["use_difficulty"] = true,
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
		},
		["Sundering Blow"] = {
			["fontSize"] = 24,
			["displayStacks"] = "%s",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "BOTTOMRIGHT",
			["yOffset"] = 277.518798828125,
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["xOffset"] = 1.50018310546875,
			["selfPoint"] = "CENTER",
			["inverse"] = false,
			["customTextUpdate"] = "update",
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Health",
				["unit"] = "member",
				["useCount"] = true,
				["count"] = "3",
				["specificUnit"] = "Malvision",
				["countOperator"] = ">=",
				["names"] = {
					"Sundering Blow", -- [1]
				},
				["subeventPrefix"] = "SPELL",
				["debuffType"] = "HARMFUL",
			},
			["actions"] = {
				["start"] = {
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_sound"] = true,
				},
				["finish"] = {
				},
			},
			["width"] = 107.4999084472656,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "preset",
					["duration_type"] = "seconds",
					["preset"] = "bounce",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["additional_triggers"] = {
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "Sundering Blow",
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["icon"] = true,
			["height"] = 100.0005111694336,
			["regionType"] = "icon",
			["cooldown"] = false,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Weakened Armor 2"] = {
			["xOffset"] = 0,
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["countOperator"] = "==",
				["unit"] = "target",
				["useCount"] = true,
				["count"] = "2",
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Weakened Armor", -- [1]
				},
				["event"] = "Health",
				["debuffType"] = "HARMFUL",
			},
			["desaturate"] = false,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["use_class"] = false,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["use_combat"] = true,
				["class"] = {
					["multi"] = {
						["DRUID"] = true,
						["WARRIOR"] = true,
						["ROGUE"] = true,
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 12,
			["displayStacks"] = "%s",
			["regionType"] = "icon",
			["parent"] = "weakened armor",
			["stacksPoint"] = "BOTTOMRIGHT",
			["color"] = {
				1, -- [1]
				0.8117647058823529, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["icon"] = true,
			["id"] = "Weakened Armor 2",
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 64,
			["numTriggers"] = 1,
			["yOffset"] = 0,
			["inverse"] = false,
			["selfPoint"] = "CENTER",
			["additional_triggers"] = {
			},
			["displayIcon"] = "Interface\\Icons\\Ability_Warrior_Sunder",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["d"] = {
			["outline"] = true,
			["fontSize"] = 55,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayText"] = "Interrupted",
			["yOffset"] = 467.2501831054688,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["justify"] = "LEFT",
			["selfPoint"] = "BOTTOM",
			["trigger"] = {
				["type"] = "event",
				["subeventSuffix"] = "_INTERRUPT",
				["duration"] = "3",
				["event"] = "Combat Log",
				["unit"] = "player",
				["sourceunit"] = "player",
				["use_sourceunit"] = true,
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
				["unevent"] = "timed",
				["debuffType"] = "HELPFUL",
			},
			["regionType"] = "text",
			["frameStrata"] = 1,
			["width"] = 308.7750244140625,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["font"] = "Friz Quadrata TT",
			["numTriggers"] = 1,
			["id"] = "d",
			["height"] = 55.00000381469727,
			["xOffset"] = -9.00006103515625,
			["load"] = {
				["spec"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
		},
		["Tricks"] = {
			["untrigger"] = {
			},
			["fontSize"] = 22,
			["displayStacks"] = "%c",
			["cooldown"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["anchorPoint"] = "CENTER",
			["customText"] = "function(a,b,c,d,e,f,g,h,i,j,k,l)\n    return string.format(\"hey %s - %s - %s - %s - %s - %s - %s \", f, g, h, i, j, k, l)\n end\n    \n    \n    \n    \n    \n    \n\n",
			["yOffset"] = 171.7499389648438,
			["regionType"] = "icon",
			["stacksPoint"] = "BOTTOM",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["numTriggers"] = 1,
			["customTextUpdate"] = "event",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["icon"] = true,
			["width"] = 100,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["id"] = "Tricks",
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "event",
				["subeventSuffix"] = "_CAST_SUCCESS",
				["duration"] = "6",
				["event"] = "Combat Log",
				["unit"] = "group",
				["use_spellName"] = true,
				["spellName"] = "Tricks of the Trade",
				["name_info"] = "aura",
				["unevent"] = "timed",
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Tricks of the Trade", -- [1]
				},
				["debuffType"] = "HELPFUL",
			},
			["font"] = "DorisPP",
			["inverse"] = false,
			["xOffset"] = 471.7498168945313,
			["height"] = 100,
			["displayIcon"] = "Interface\\Icons\\Ability_Rogue_TricksOftheTrade",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["text 2"] = {
			["outline"] = true,
			["fontSize"] = 10,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayText"] = "%s",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["regionType"] = "text",
			["yOffset"] = -160,
			["justify"] = "CENTER",
			["selfPoint"] = "RIGHT",
			["additional_triggers"] = {
			},
			["xOffset"] = -130.2496337890625,
			["frameStrata"] = 1,
			["width"] = 39.00000381469727,
			["id"] = "text 2",
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["height"] = 9.750034332275391,
			["trigger"] = {
				["name_operator"] = "==",
				["subeventSuffix"] = "_CAST_START",
				["fullscan"] = true,
				["type"] = "aura",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
				["use_name"] = true,
				["subcount"] = true,
				["name"] = "Vengeance",
				["specificUnit"] = "Chugnoris",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["unit"] = "member",
				["custom_hide"] = "timed",
			},
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["use_talent"] = false,
			},
			["parent"] = "vengeance",
		},
		["Tricks Tracker"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["customText"] = "function() \n    if WA_CRC and WA_CRC['Git ToT'] then\n        local record = WA_CRC['Git ToT']\n        return string.format('%s on %s', record.source, record.target)\n    else\n        return 'boo'\n    end\nend\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
			["yOffset"] = -3.75018310546875,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "event",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["duration"] = "6",
				["name_info"] = "aura",
				["subeventPrefix"] = "SPELL",
				["spellName"] = "Tricks of the Trade",
				["type"] = "custom",
				["unevent"] = "timed",
				["event"] = "Combat Log",
				["debuffType"] = "HELPFUL",
				["custom"] = "function(_,_,message,_,_,source,_,_,_,target,tarGUID,_,_,spell)\n    if ((spell == 'Tricks of the Trade' and message == \"SPELL_AURA_APPLIED\")\n    and source ~= nil and target ~= nil and target ~= source)\n    then\n        print(string.format('Caught %s on %s %s %s', source, target, spell or 'nil', message or 'nothing'))\n        WA_CRC = WA_CRC or {};\n        WA_CRC['Git ToT'] = WA_CRC['Git ToT'] or {};\n        local record = WA_CRC['Git ToT']\n        record.source = source\n        record.target = target\n        return true\n    else\n        return false\n    end\nend\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
				["use_spellName"] = true,
				["events"] = "COMBAT_LOG_EVENT_UNFILTERED",
				["subeventSuffix"] = "_CAST_SUCCESS",
				["custom_hide"] = "timed",
				["unit"] = "group",
				["custom_type"] = "event",
				["names"] = {
					"Tricks of the Trade", -- [1]
				},
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 50,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 22,
			["displayStacks"] = "%c",
			["regionType"] = "icon",
			["parent"] = "Tricks Group",
			["stacksPoint"] = "RIGHT",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["xOffset"] = 480.7495727539063,
			["id"] = "Tricks Tracker",
			["untrigger"] = {
			},
			["frameStrata"] = 1,
			["width"] = 50,
			["icon"] = true,
			["inverse"] = false,
			["numTriggers"] = 1,
			["selfPoint"] = "CENTER",
			["stickyDuration"] = false,
			["displayIcon"] = "Interface\\Icons\\Ability_Rogue_TricksOftheTrade",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Dark Shamans - Froststorm Strike Timer"] = {
			["textFlags"] = "None",
			["stacksSize"] = 25,
			["borderBackdrop"] = "Blizzard Tooltip",
			["color"] = {
				0.8392156862745098, -- [1]
				1, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["stacksFlags"] = "None",
			["untrigger"] = {
				["unit"] = "Earthbreaker Haromm",
				["use_specific_unit"] = true,
			},
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "update",
			["rotateText"] = "NONE",
			["actions"] = {
				["start"] = {
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_sound"] = false,
				},
				["finish"] = {
				},
			},
			["parent"] = "SoO 1st Part",
			["yOffset"] = 76.00006103515625,
			["textSize"] = 18,
			["selfPoint"] = "BOTTOM",
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["preset"] = "alphaPulse",
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["use_castType"] = false,
				["sourceunit"] = "target",
				["source"] = "Earthbreaker Haromm",
				["duration"] = "6",
				["use_spell"] = true,
				["use_unit"] = true,
				["custom_hide"] = "timed",
				["type"] = "event",
				["spellName"] = "Froststorm Strike",
				["subeventSuffix"] = "_CAST_SUCCESS",
				["unit"] = "Earthbreaker Haromm",
				["use_specific_unit"] = true,
				["event"] = "Combat Log",
				["use_source"] = false,
				["unevent"] = "timed",
				["use_spellName"] = true,
				["spell"] = "Ashen Wall",
				["use_sourceunit"] = false,
				["use_destunit"] = false,
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
			},
			["text"] = true,
			["barColor"] = {
				0, -- [1]
				0.5215686274509804, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["displayText"] = "Adds Wall Incoming!!",
			["numTriggers"] = 1,
			["stickyDuration"] = false,
			["xOffset"] = 608,
			["height"] = 26,
			["timerFlags"] = "None",
			["load"] = {
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_role"] = true,
				["class"] = {
					["single"] = "PALADIN",
					["multi"] = {
						["PALADIN"] = true,
					},
				},
				["use_zone"] = true,
				["role"] = {
					["single"] = "TANK",
					["multi"] = {
					},
				},
				["use_combat"] = true,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["outline"] = true,
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["alpha"] = 1,
			["borderSize"] = 16,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["id"] = "Dark Shamans - Froststorm Strike Timer",
			["justify"] = "LEFT",
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "aurabar",
			["stacks"] = true,
			["auto"] = true,
			["icon_side"] = "LEFT",
			["stacksFont"] = "Friz Quadrata TT",
			["barInFront"] = true,
			["displayTextRight"] = "%p",
			["texture"] = "Blizzard",
			["textFont"] = "Friz Quadrata TT",
			["borderOffset"] = 5,
			["timerSize"] = 24,
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["additional_triggers"] = {
			},
			["timerFont"] = "Friz Quadrata TT",
			["frameStrata"] = 1,
			["width"] = 300,
			["timer"] = true,
			["borderInset"] = 11,
			["inverse"] = false,
			["icon"] = true,
			["orientation"] = "HORIZONTAL",
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["displayTextLeft"] = "Froststorm Strike",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Foul Geyser"] = {
			["textFlags"] = "None",
			["stacksSize"] = 12,
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = 439.4996948242188,
			["stacksFlags"] = "None",
			["yOffset"] = 74.25018310546875,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "update",
			["rotateText"] = "NONE",
			["icon"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Cast",
				["unit"] = "focus",
				["spell"] = "Foul Geyser",
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
				["unevent"] = "auto",
				["use_unit"] = true,
				["use_spell"] = true,
				["debuffType"] = "HELPFUL",
			},
			["text"] = true,
			["barColor"] = {
				1, -- [1]
				0, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["untrigger"] = {
				["unit"] = "focus",
			},
			["stickyDuration"] = false,
			["timer"] = true,
			["timerFlags"] = "None",
			["load"] = {
				["use_name"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["name"] = "Git",
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["barInFront"] = true,
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["displayTextLeft"] = "%n",
			["height"] = 47.99996185302734,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["numTriggers"] = 1,
			["stacks"] = true,
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "aurabar",
			["borderSize"] = 16,
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["icon_side"] = "RIGHT",
			["stacksFont"] = "Friz Quadrata TT",
			["frameStrata"] = 1,
			["auto"] = true,
			["texture"] = "Blizzard",
			["textFont"] = "Friz Quadrata TT",
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayTextRight"] = "%p",
			["borderOffset"] = 5,
			["id"] = "Foul Geyser",
			["timerFont"] = "Friz Quadrata TT",
			["alpha"] = 1,
			["width"] = 326.0001831054688,
			["timerSize"] = 12,
			["borderInset"] = 11,
			["inverse"] = false,
			["textSize"] = 12,
			["orientation"] = "HORIZONTAL",
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["actions"] = {
				["start"] = {
					["do_sound"] = true,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["sound_channel"] = "Master",
				},
				["finish"] = {
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Reflec"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["cooldown"] = true,
			["parent"] = "Tank Def Buffs",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["stickyDuration"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["id"] = "Reflec",
			["width"] = 30,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Spell Reflection", -- [1]
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["font"] = "DorisPP",
			["inverse"] = false,
			["xOffset"] = 170,
			["height"] = 30,
			["regionType"] = "icon",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Rook"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "RIGHT",
			["parent"] = "Tank CDs Long",
			["yOffset"] = 0,
			["regionType"] = "icon",
			["untrigger"] = {
				["itemName"] = 105438,
				["spellName"] = 12975,
			},
			["xOffset"] = 0,
			["inverse"] = true,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["id"] = "TCD: Rook",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["use_itemName"] = true,
				["unit"] = "player",
				["subeventPrefix"] = "SPELL",
				["use_spellName"] = true,
				["unevent"] = "auto",
				["use_unit"] = true,
				["itemName"] = 105438,
				["spellName"] = 12975,
				["event"] = "Cooldown Progress (Item)",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 30,
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["icon"] = true,
			["height"] = 30,
			["anchorPoint"] = "CENTER",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["New"] = {
			["outline"] = true,
			["fontSize"] = 46,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayText"] = "%c%",
			["customText"] = "function()\n  local percent = (UnitHealth(\"player\")/UnitHealthMax(\"player\"))*100\n  return (\"%i\"):format(percent)\nend",
			["yOffset"] = 34.50045776367188,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["regionType"] = "text",
			["justify"] = "LEFT",
			["selfPoint"] = "BOTTOM",
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Health",
				["unit"] = "player",
				["custom_hide"] = "timed",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["unevent"] = "auto",
				["use_percenthealth"] = false,
				["use_unit"] = true,
				["debuffType"] = "HELPFUL",
			},
			["untrigger"] = {
			},
			["frameStrata"] = 1,
			["width"] = 74.88001251220703,
			["id"] = "New",
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["xOffset"] = -31.5,
			["height"] = 45.9999885559082,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["parent"] = "Tortos",
		},
		["RESIDIUAL!"] = {
			["outline"] = true,
			["fontSize"] = 45,
			["color"] = {
				1, -- [1]
				0, -- [2]
				0.1254901960784314, -- [3]
				1, -- [4]
			},
			["displayText"] = "RESIDUAL!!!",
			["yOffset"] = 0,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["sound_channel"] = "Master",
					["sound"] = "Interface\\AddOns\\Omen\\aoogah.ogg",
					["do_sound"] = true,
				},
				["finish"] = {
				},
			},
			["justify"] = "LEFT",
			["selfPoint"] = "BOTTOM",
			["trigger"] = {
				["type"] = "event",
				["subeventSuffix"] = "_DAMAGE",
				["duration"] = "1s",
				["event"] = "Combat Log",
				["unit"] = "player",
				["use_spellName"] = true,
				["destunit"] = "player",
				["unevent"] = "timed",
				["use_destunit"] = true,
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
			},
			["untrigger"] = {
			},
			["frameStrata"] = 1,
			["width"] = 287.6400146484375,
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "spiral",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["xOffset"] = 0,
			["height"] = 45.00000762939453,
			["id"] = "RESIDIUAL!",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "text",
		},
		["Shadow Priest"] = {
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["controlledChildren"] = {
				"Devo Plauge 3", -- [1]
				"Devo Plague 2", -- [2]
				"Devo Plague 1", -- [3]
				"Mind Blast", -- [4]
				"SW: Death", -- [5]
				"Mindbender", -- [6]
				"Vamp Embrace", -- [7]
				"Vampiric Touch", -- [8]
				"SW: Pain", -- [9]
			},
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = -0.749755859375,
			["border"] = false,
			["yOffset"] = -2.24993896484375,
			["anchorPoint"] = "CENTER",
			["borderSize"] = 16,
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["borderOffset"] = 5,
			["selfPoint"] = "BOTTOMLEFT",
			["trigger"] = {
				["unit"] = "player",
				["type"] = "aura",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
			},
			["frameStrata"] = 1,
			["regionType"] = "group",
			["untrigger"] = {
			},
			["borderInset"] = 11,
			["numTriggers"] = 1,
			["id"] = "Shadow Priest",
			["borderEdge"] = "None",
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["load"] = {
				["class"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["expanded"] = false,
		},
		["TCD: RC"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["cooldown"] = true,
			["regionType"] = "icon",
			["untrigger"] = {
				["spellName"] = 97462,
			},
			["anchorPoint"] = "CENTER",
			["yOffset"] = 0,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["icon"] = true,
			["width"] = 30,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["use_itemName"] = true,
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["spellName"] = 97462,
				["use_spellName"] = true,
				["itemName"] = 0,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "TCD: RC",
			["font"] = "DorisPP",
			["inverse"] = true,
			["xOffset"] = 0,
			["height"] = 30,
			["parent"] = "Tank CDs Long",
			["stacksPoint"] = "RIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Stun"] = {
			["textFlags"] = "None",
			["stacksSize"] = 12,
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = -10.50030517578125,
			["stacksFlags"] = "None",
			["customText"] = "function()\n    return WA_TDEVART\nend\n\n\n\n\n\n\n\n\n",
			["yOffset"] = 370.7498779296875,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				0.8509803921568627, -- [1]
				0.3764705882352941, -- [2]
				0.06274509803921569, -- [3]
				1, -- [4]
			},
			["totalPrecision"] = 3,
			["rotateText"] = "NONE",
			["displayTextLeft"] = "Stun: %n",
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "slideright",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["preset"] = "alphaPulse",
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "slideleft",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "custom",
				["custom_hide"] = "custom",
				["custom_type"] = "event",
				["subeventSuffix"] = "_CAST_START",
				["events"] = "COMBAT_LOG_EVENT_UNFILTERED",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
				["customDuration"] = "function()\n    local _, _, _, _, _, duration, expirationTime = UnitDebuff(\"target\" , WA_TNVART)\n    local x = 0\n    if WA_TNVART == \"\" then\n        return 0, 0, function() return 0, 0 end\n    else    \n        x = expirationTime - GetTime() - 0.001\n        WA_TDEVART = ceil(x)\n        return x, duration, function() local _, _, _, _, _, duration, expirationTime = UnitDebuff(\"target\" , WA_TNVART) local y = 0 if WA_TNVART == \"\" then return 0, 0 else y = expirationTime - GetTime() - 0.001 WA_TDEVART = ceil(y) return y, duration end end\n    end\nend",
				["customName"] = "function()\n    return WA_TNVART\nend",
				["custom"] = "function(event, timestamp, message, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)\n    if (message == \"SPELL_AURA_APPLIED\" or message == \"SPELL_AURA_REFRESH\") and destName == UnitName(\"target\") then\n        local spellId, spellName, _, auraType = ...\n        if auraType == \"DEBUFF\" then            \n            if spellName == \"Aftermath\" or spellName == \"Asphyxiate\" or spellName == \"Axe Toss\" or spellName == \"Bash\" or spellName == \"Bear Hug\" or spellName == \"Binding Shot\" or spellName == \"Charge Stun\" or spellName == \"Charging Ox Wave\" or spellName == \"Cheap Shot\" or spellName == \"Combustion Impact\" or spellName == \"Concussion Blow\" or spellName == \"Deep Freeze\" or spellName == \"Demonic Leap\" or spellName == \"Dragon Roar\" or spellName == \"Fist of Justice\" or spellName == \"Gnaw\" or spellName == \"Hammer of Justice\" or spellName == \"Impact\" or spellName == \"Intercept\" or spellName == \"Intimidation\" or spellName == \"Kidney Shot\" or spellName == \"Leg Sweep\" or spellName == \"Maim\" or spellName == \"Mighty Bash\" or spellName == \"Monstrous Blow\" or spellName == \"Pounce\" or spellName == \"Pulverize\" or spellName == \"Ring of Frost\" or spellName == \"Shadowfury\" or spellName == \"Shockwave\" or spellName == \"Sonic Blast\" or spellName == \"Sting\" or spellName == \"Storm Bolt\" or spellName == \"Stun\" or spellName == \"Stunned\" or spellName == \"War Stomp\" or spellName == \"Web Wrap\" or spellId == 115752 or spellId == 77505 or spellId == 115001 or spellId == 118905 then\n                WA_TNVART = spellName\n                return true\n            else\n                for i=1,40 do\n                    if spellName == \"Mesmerize\" then\n                        break\n                    end\n                    local d = UnitDebuff(\"target\" , i)\n                    if d then\n                        if d == spellName then\n                            local f = CreateFrame('GameTooltip', 'MyTooltip', UIParent, 'GameTooltipTemplate')\n                            f:SetOwner(UIParent, 'ANCHOR_NONE')\n                            f:SetUnitDebuff('target', i)\n                            local sttp = MyTooltipTextLeft2:GetText()\n                            f:Hide()\n                            if sttp == \"Stunned.\" then\n                                WA_TNVART = d\n                                return true\n                            end\n                        end\n                    else\n                        break\n                    end\n                end\n            end\n        end\n    end\nend",
				["customIcon"] = "function()\n    local _, _, icon = UnitDebuff(\"target\" , WA_TNVART)\n    return icon\nend",
				["check"] = "event",
				["unit"] = "player",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
			},
			["text"] = true,
			["barColor"] = {
				0.9529411764705882, -- [1]
				0, -- [2]
				0.01176470588235294, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["customTextUpdate"] = "update",
			["icon"] = true,
			["height"] = 27.00001335144043,
			["timer"] = true,
			["timerFlags"] = "None",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["selfPoint"] = "CENTER",
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["numTriggers"] = 1,
			["stickyDuration"] = false,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["borderSize"] = 16,
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["border"] = true,
			["borderEdge"] = "Blizzard Dialog Gold",
			["regionType"] = "aurabar",
			["stacks"] = false,
			["alpha"] = 1,
			["icon_side"] = "RIGHT",
			["borderOffset"] = 5,
			["id"] = "Stun",
			["auto"] = true,
			["texture"] = "Blizzard",
			["textFont"] = "Friz Quadrata TT",
			["stacksFont"] = "Friz Quadrata TT",
			["displayTextRight"] = "%c",
			["timerSize"] = 14,
			["additional_triggers"] = {
			},
			["timerFont"] = "Friz Quadrata TT",
			["frameStrata"] = 1,
			["width"] = 351.0001220703125,
			["barInFront"] = true,
			["borderInset"] = 11,
			["inverse"] = false,
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["orientation"] = "HORIZONTAL",
			["untrigger"] = {
				["custom"] = "function(event, timestamp, message, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)\n    if (message == \"SPELL_AURA_REMOVED\" or message == \"SPELL_AURA_BROKEN\" or message == \"SPELL_AURA_BROKEN_SPELL\")  and destName == UnitName(\"target\") then\n        local _, spellName = ...\n        if spellName == WA_TNVART then\n            WA_TNVART = \"\"\n            return true\n        end\n    end\nend",
			},
			["textSize"] = 15,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Dragon Roar"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["cooldown"] = true,
			["regionType"] = "icon",
			["untrigger"] = {
				["spellName"] = 118000,
			},
			["anchorPoint"] = "CENTER",
			["yOffset"] = 0,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["icon"] = true,
			["width"] = 30,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["use_itemName"] = true,
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["spellName"] = 118000,
				["use_spellName"] = true,
				["itemName"] = 0,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "TCD: Dragon Roar",
			["font"] = "DorisPP",
			["inverse"] = true,
			["xOffset"] = 0,
			["height"] = 30,
			["parent"] = "Tank CDs 2",
			["stacksPoint"] = "RIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Shattering"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["stacksPoint"] = "RIGHT",
			["parent"] = "Tank CDs 2",
			["cooldown"] = true,
			["regionType"] = "icon",
			["untrigger"] = {
				["spellName"] = 64382,
			},
			["anchorPoint"] = "CENTER",
			["xOffset"] = 0,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["width"] = 30,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["use_itemName"] = true,
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["spellName"] = 64382,
				["use_spellName"] = true,
				["itemName"] = 0,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "TCD: Shattering",
			["font"] = "DorisPP",
			["inverse"] = true,
			["icon"] = true,
			["height"] = 30,
			["yOffset"] = 0,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Sac"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["cooldown"] = true,
			["parent"] = "Tank Def Buffs",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
			["yOffset"] = 20,
			["regionType"] = "icon",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["width"] = 30,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Hand of Sacrifice", -- [1]
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "Sac",
			["font"] = "DorisPP",
			["inverse"] = false,
			["xOffset"] = 170,
			["height"] = 30,
			["anchorPoint"] = "CENTER",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Immerseus - Swelling Corruption"] = {
			["parent"] = "SoO 1st Part",
			["fontSize"] = 24,
			["displayStacks"] = "GET OUT! %p  %s",
			["stacksPoint"] = "BOTTOM",
			["xOffset"] = 490,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["regionType"] = "icon",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["stickyDuration"] = false,
			["inverse"] = false,
			["selfPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["id"] = "Immerseus - Swelling Corruption",
			["icon"] = true,
			["width"] = 64,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["fullscan"] = true,
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["ownOnly"] = true,
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
				["use_name"] = true,
				["useCount"] = true,
				["name"] = "Sha Corruption",
				["count"] = "6",
				["unit"] = "player",
				["countOperator"] = ">=",
				["names"] = {
					"Swelling Corruption", -- [1]
				},
				["debuffType"] = "HELPFUL",
			},
			["actions"] = {
				["start"] = {
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_sound"] = true,
				},
				["finish"] = {
				},
			},
			["frameStrata"] = 1,
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["numTriggers"] = 1,
			["additional_triggers"] = {
			},
			["height"] = 64,
			["yOffset"] = 166,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_zone"] = true,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Shadowform"] = {
			["xOffset"] = 0,
			["yOffset"] = 49.908935546875,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["unit"] = "player",
				["type"] = "aura",
				["inverse"] = true,
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Shadowform", -- [1]
				},
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["desaturate"] = false,
			["rotation"] = 0,
			["font"] = "DorisPP",
			["height"] = 152.4999847412109,
			["rotate"] = true,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "PRIEST",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 17,
			["displayStacks"] = "%n",
			["mirror"] = false,
			["regionType"] = "texture",
			["blendMode"] = "BLEND",
			["untrigger"] = {
			},
			["texture"] = "Textures\\SpellActivationOverlays\\Shadow_of_Death",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["discrete_rotation"] = 0,
			["id"] = "Shadowform",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["frameStrata"] = 1,
			["width"] = 175.0000915527344,
			["stickyDuration"] = false,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "preset",
					["duration_type"] = "seconds",
					["preset"] = "bounce",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["inverse"] = false,
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["displayIcon"] = "Interface\\Icons\\",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Tank CDs 2"] = {
			["grow"] = "UP",
			["controlledChildren"] = {
				"TCD: BB", -- [1]
				"TCD: Shattering", -- [2]
				"TCD: Dragon Roar", -- [3]
				"TCD: Br", -- [4]
				"TCD: SB", -- [5]
				"TCD: Reck", -- [6]
			},
			["animate"] = true,
			["xOffset"] = 350,
			["border"] = "None",
			["yOffset"] = -160,
			["anchorPoint"] = "CENTER",
			["untrigger"] = {
			},
			["sort"] = "ascending",
			["expanded"] = false,
			["space"] = 2,
			["background"] = "None",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["constantFactor"] = "RADIUS",
			["selfPoint"] = "BOTTOMLEFT",
			["borderOffset"] = 16,
			["align"] = "LEFT",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["names"] = {
				},
				["type"] = "aura",
				["debuffType"] = "HELPFUL",
				["unit"] = "player",
			},
			["backgroundInset"] = 0,
			["frameStrata"] = 1,
			["width"] = 29.99993896484375,
			["rotation"] = 0,
			["radius"] = 200,
			["numTriggers"] = 1,
			["stagger"] = 0,
			["height"] = 190,
			["id"] = "Tank CDs 2",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "dynamicgroup",
		},
		["Iron Juggernaut - Locked On"] = {
			["xOffset"] = 490,
			["mirror"] = false,
			["yOffset"] = 166,
			["regionType"] = "texture",
			["blendMode"] = "BLEND",
			["untrigger"] = {
			},
			["color"] = {
				1, -- [1]
				0, -- [2]
				0.1803921568627451, -- [3]
				1, -- [4]
			},
			["actions"] = {
				["start"] = {
					["message"] = "Laser on me WATCH OUT!",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["do_message"] = true,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
				},
				["finish"] = {
				},
			},
			["texture"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Auras\\Aura110",
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["preset"] = "bounce",
					["type"] = "preset",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "Iron Juggernaut - Locked On",
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Health",
				["names"] = {
					"Locked On", -- [1]
				},
				["custom_hide"] = "timed",
				["unit"] = "player",
				["autoclone"] = true,
				["subeventPrefix"] = "SPELL",
				["debuffType"] = "HARMFUL",
			},
			["selfPoint"] = "CENTER",
			["additional_triggers"] = {
			},
			["rotation"] = 0,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["discrete_rotation"] = 0,
			["anchorPoint"] = "CENTER",
			["numTriggers"] = 1,
			["width"] = 128,
			["height"] = 128,
			["rotate"] = true,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["parent"] = "SoO 1st Part",
		},
		["Thok: CDs 2"] = {
			["outline"] = true,
			["fontSize"] = 16,
			["color"] = {
				1, -- [1]
				0.9176470588235294, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["displayText"] = "1: RAIDs WPs\n\n2: ROGUEs Bomb (Nath then Nyt)\n\n3: Bloodmonk's Revival\n\n4: Tyd SLT/Star Devo\n\n5: Shinerr's Tranq (Star's BoP) / ET Barrier\n\n6: RAIDs SPs / Phaze' Devo / Tyds HTT/\n\n7: Primal Tranq (Phaze's BoP) / Git's DB-RC\n\n8: Marcus Hymn  / Hooves' Devo\n\n9: Saint's Barrier",
			["yOffset"] = 386.7938232421875,
			["regionType"] = "text",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["untrigger"] = {
			},
			["justify"] = "LEFT",
			["selfPoint"] = "CENTER",
			["additional_triggers"] = {
			},
			["trigger"] = {
				["type"] = "status",
				["unevent"] = "auto",
				["use_vehicle"] = false,
				["event"] = "Conditions",
				["use_unit"] = true,
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["unit"] = "player",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
			},
			["frameStrata"] = 1,
			["width"] = 329.2799987792969,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["font"] = "Friz Quadrata TT",
			["numTriggers"] = 1,
			["id"] = "Thok: CDs 2",
			["height"] = 261.1200256347656,
			["anchorPoint"] = "CENTER",
			["load"] = {
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["class"] = {
					["multi"] = {
					},
				},
				["difficulty"] = "none",
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["use_difficulty"] = false,
				["use_zone"] = false,
				["size"] = {
					["single"] = "twentyfive",
					["multi"] = {
						["twentyfive"] = true,
					},
				},
			},
			["xOffset"] = 559.0164184570313,
		},
		["Sha of Pride - Power of the Titans"] = {
			["xOffset"] = 555,
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["names"] = {
					"Power of the Titans", -- [1]
				},
				["type"] = "aura",
				["debuffType"] = "HARMFUL",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["cooldown"] = true,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_message"] = false,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\Applause.mp3",
					["do_sound"] = true,
				},
				["finish"] = {
				},
			},
			["additional_triggers"] = {
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 64,
			["yOffset"] = 166,
			["numTriggers"] = 1,
			["inverse"] = false,
			["selfPoint"] = "CENTER",
			["id"] = "Sha of Pride - Power of the Titans",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Malkorok - Enrage"] = {
			["textFlags"] = "None",
			["stacksSize"] = 12,
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = 3.75,
			["stacksFlags"] = "None",
			["yOffset"] = 147.7498779296875,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "update",
			["rotateText"] = "NONE",
			["icon"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["sourceunit"] = "focus",
				["source"] = "Malkorok",
				["subeventSuffix"] = "_CAST_SUCCESS",
				["debuffType"] = "HELPFUL",
				["duration"] = "20",
				["event"] = "Combat Log",
				["unit"] = "player",
				["names"] = {
				},
				["use_spellName"] = true,
				["subeventPrefix"] = "SPELL",
				["use_sourceunit"] = false,
				["unevent"] = "timed",
				["use_source"] = true,
				["type"] = "event",
				["spellName"] = "Blood Rage",
			},
			["text"] = true,
			["barColor"] = {
				1, -- [1]
				0, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["untrigger"] = {
			},
			["stickyDuration"] = false,
			["timer"] = true,
			["timerFlags"] = "THICKOUTLINE",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["barInFront"] = true,
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["displayTextLeft"] = "%n",
			["height"] = 47.25029373168945,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["numTriggers"] = 1,
			["stacks"] = false,
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "aurabar",
			["borderSize"] = 16,
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["icon_side"] = "RIGHT",
			["stacksFont"] = "Friz Quadrata TT",
			["frameStrata"] = 1,
			["auto"] = true,
			["texture"] = "Blizzard",
			["textFont"] = "DorisPP",
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayTextRight"] = "%p",
			["borderOffset"] = 5,
			["id"] = "Malkorok - Enrage",
			["timerFont"] = "DorisPP",
			["alpha"] = 1,
			["width"] = 356.0001220703125,
			["timerSize"] = 25,
			["borderInset"] = 11,
			["inverse"] = false,
			["textSize"] = 9,
			["orientation"] = "HORIZONTAL",
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["actions"] = {
				["start"] = {
					["do_sound"] = true,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["sound_channel"] = "Master",
				},
				["finish"] = {
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Mind Blast"] = {
			["fontSize"] = 12,
			["displayStacks"] = "%p",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["parent"] = "Shadow Priest",
			["load"] = {
				["use_name"] = false,
				["role"] = {
					["multi"] = {
					},
				},
				["name"] = "Spih",
				["use_class"] = true,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["class"] = {
					["single"] = "PRIEST",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["anchorPoint"] = "CENTER",
			["untrigger"] = {
				["spellName"] = 8092,
			},
			["regionType"] = "icon",
			["stacksPoint"] = "BOTTOM",
			["xOffset"] = -30,
			["inverse"] = true,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["id"] = "Mind Blast",
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["duration_type"] = "seconds",
					["preset"] = "fade",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["duration_type"] = "seconds",
					["preset"] = "fade",
				},
			},
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["debuffType"] = "HELPFUL",
				["use_spellName"] = true,
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
				["unevent"] = "auto",
				["use_unit"] = true,
				["spellName"] = 8092,
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 40,
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
					["do_custom"] = true,
				},
				["finish"] = {
				},
			},
			["height"] = 40,
			["yOffset"] = -140,
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Rev 2"] = {
			["disjunctive"] = true,
			["untrigger"] = {
				["spellName"] = 6572,
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["use_remaining"] = false,
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["event"] = "Cooldown Progress (Spell)",
				["unit"] = "player",
				["debuffType"] = "HELPFUL",
				["use_spellName"] = true,
				["names"] = {
					"Shield Block", -- [1]
				},
				["subeventPrefix"] = "SPELL",
				["unevent"] = "auto",
				["use_unit"] = true,
				["type"] = "status",
				["spellName"] = 6572,
			},
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["height"] = 30,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["use_level"] = false,
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%s",
			["regionType"] = "icon",
			["desaturate"] = false,
			["stacksPoint"] = "BOTTOM",
			["selfPoint"] = "CENTER",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["xOffset"] = 201,
			["additional_triggers"] = {
				{
					["trigger"] = {
						["type"] = "status",
						["unevent"] = "auto",
						["event"] = "Action Usable",
						["subeventPrefix"] = "SPELL",
						["use_spellName"] = true,
						["unit"] = "player",
						["subeventSuffix"] = "_CAST_START",
						["use_unit"] = true,
						["spellName"] = 6572,
					},
					["untrigger"] = {
						["spellName"] = 6572,
					},
				}, -- [1]
			},
			["actions"] = {
				["start"] = {
					["do_glow"] = false,
				},
				["finish"] = {
				},
			},
			["frameStrata"] = 1,
			["width"] = 30,
			["numTriggers"] = 2,
			["yOffset"] = 20,
			["inverse"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["id"] = "TCD: Rev 2",
			["parent"] = "Tank CDs",
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Reck"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["parent"] = "Tank DPS Buffs",
			["cooldown"] = true,
			["anchorPoint"] = "CENTER",
			["yOffset"] = 20,
			["regionType"] = "icon",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["inverse"] = false,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["id"] = "Reck",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["unit"] = "player",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Recklessness", -- [1]
				},
				["debuffType"] = "HELPFUL",
				["event"] = "Health",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["frameStrata"] = 1,
			["width"] = 30,
			["stickyDuration"] = false,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["xOffset"] = 0,
			["height"] = 30,
			["untrigger"] = {
			},
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Track DP Group"] = {
			["grow"] = "UP",
			["controlledChildren"] = {
				"DP", -- [1]
			},
			["animate"] = false,
			["xOffset"] = 280,
			["border"] = "None",
			["yOffset"] = 45,
			["anchorPoint"] = "CENTER",
			["regionType"] = "dynamicgroup",
			["sort"] = "none",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["space"] = 2,
			["background"] = "None",
			["expanded"] = true,
			["constantFactor"] = "RADIUS",
			["id"] = "Track DP Group",
			["borderOffset"] = 16,
			["trigger"] = {
			},
			["selfPoint"] = "BOTTOM",
			["align"] = "CENTER",
			["stagger"] = 0,
			["frameStrata"] = 1,
			["width"] = 199.9999389648438,
			["rotation"] = 0,
			["radius"] = 200,
			["numTriggers"] = 1,
			["backgroundInset"] = 0,
			["height"] = 15,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["load"] = {
				["class"] = {
					["multi"] = {
					},
				},
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
		},
		["weakened armor"] = {
			["grow"] = "DOWN",
			["controlledChildren"] = {
				"Weakened Armor", -- [1]
				"Weakened Armor 1", -- [2]
				"Weakened Armor 2", -- [3]
				"Weakened Armor 3", -- [4]
			},
			["animate"] = false,
			["xOffset"] = -343.5000610351563,
			["anchorPoint"] = "CENTER",
			["border"] = "None",
			["yOffset"] = 267.7500610351563,
			["regionType"] = "dynamicgroup",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["sort"] = "none",
			["borderOffset"] = 16,
			["space"] = 2,
			["background"] = "None",
			["expanded"] = false,
			["constantFactor"] = "RADIUS",
			["selfPoint"] = "TOP",
			["backgroundInset"] = 0,
			["additional_triggers"] = {
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["align"] = "CENTER",
			["radius"] = 200,
			["frameStrata"] = 1,
			["width"] = 63.99998474121094,
			["rotation"] = 0,
			["stagger"] = 0,
			["numTriggers"] = 1,
			["id"] = "weakened armor",
			["height"] = 262,
			["trigger"] = {
				["type"] = "aura",
				["unit"] = "player",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
		},
		["PS"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["cooldown"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["xOffset"] = 170,
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["stickyDuration"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["id"] = "PS",
			["width"] = 30,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Pain Suppression", -- [1]
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["font"] = "DorisPP",
			["inverse"] = false,
			["parent"] = "Tank Def Buffs",
			["height"] = 30,
			["regionType"] = "icon",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Galakras - Stacks"] = {
			["xOffset"] = 490,
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["names"] = {
					"Flames of Galakrond", -- [1]
				},
				["type"] = "aura",
				["debuffType"] = "HARMFUL",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["unit"] = "player",
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "%p  %s",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["cooldown"] = false,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_sound"] = false,
					["message_type"] = "SAY",
					["do_message"] = false,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
				},
				["finish"] = {
				},
			},
			["additional_triggers"] = {
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 64,
			["yOffset"] = 166,
			["numTriggers"] = 1,
			["inverse"] = false,
			["selfPoint"] = "CENTER",
			["id"] = "Galakras - Stacks",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Crystal Shell"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["fontSize"] = 15,
			["displayStacks"] = "%s",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["parent"] = "Tortos",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["yOffset"] = 21.50018310546875,
			["regionType"] = "icon",
			["xOffset"] = -147.75,
			["inverse"] = false,
			["width"] = 100,
			["customTextUpdate"] = "update",
			["trigger"] = {
				["debuffType"] = "HARMFUL",
				["name_operator"] = "==",
				["spellId"] = "137633",
				["unevent"] = "auto",
				["subeventSuffix"] = "_CAST_START",
				["subeventPrefix"] = "SPELL",
				["event"] = "Health",
				["names"] = {
					"Crystal Shell", -- [1]
				},
				["type"] = "aura",
				["use_spellId"] = true,
				["name"] = "Crystal Shell",
				["unit"] = "player",
				["subcount"] = true,
				["use_unit"] = true,
				["custom_hide"] = "timed",
				["fullscan"] = true,
			},
			["icon"] = true,
			["stickyDuration"] = false,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["id"] = "Crystal Shell",
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["desaturate"] = false,
			["additional_triggers"] = {
			},
			["font"] = "Friz Quadrata TT",
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["height"] = 100,
			["disjunctive"] = true,
			["stacksPoint"] = "BOTTOMRIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Devo Plague 1"] = {
			["cooldown"] = false,
			["fontSize"] = 12,
			["displayStacks"] = "%s",
			["stacksPoint"] = "BOTTOM",
			["parent"] = "Shadow Priest",
			["untrigger"] = {
				["spellName"] = 8092,
			},
			["regionType"] = "icon",
			["yOffset"] = -140,
			["anchorPoint"] = "CENTER",
			["color"] = {
				0.9254901960784314, -- [1]
				1, -- [2]
				0.9294117647058824, -- [3]
				1, -- [4]
			},
			["numTriggers"] = 1,
			["actions"] = {
				["start"] = {
					["do_custom"] = true,
				},
				["finish"] = {
				},
			},
			["customTextUpdate"] = "update",
			["width"] = 40,
			["icon"] = true,
			["stickyDuration"] = false,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "Devo Plague 1",
			["trigger"] = {
				["type"] = "status",
				["custom_hide"] = "timed",
				["power"] = "1",
				["power_operator"] = "==",
				["use_power"] = true,
				["event"] = "Shadow Orbs",
				["unit"] = "player",
				["spellName"] = 8092,
				["use_spellName"] = true,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
			},
			["frameStrata"] = 1,
			["desaturate"] = true,
			["selfPoint"] = "CENTER",
			["font"] = "DorisPP",
			["inverse"] = false,
			["xOffset"] = -80,
			["height"] = 40,
			["displayIcon"] = "Interface\\Icons\\Spell_Shadow_DevouringPlague.",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["name"] = "Spih",
				["use_name"] = false,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["class"] = {
					["single"] = "PRIEST",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				0.9725490196078431, -- [1]
				1, -- [2]
				0.9372549019607843, -- [3]
				1, -- [4]
			},
		},
		["Spoils - Gusting Bomb"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["do_message"] = false,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["preset"] = "fade",
					["duration_type"] = "seconds",
					["type"] = "preset",
				},
				["main"] = {
					["preset"] = "bounce",
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["preset"] = "fade",
					["duration_type"] = "seconds",
					["type"] = "preset",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "event",
				["subeventSuffix"] = "_CAST_SUCCESS",
				["duration"] = "5",
				["event"] = "Combat Log",
				["names"] = {
					"Gusting Bomb", -- [1]
				},
				["debuffType"] = "HELPFUL",
				["use_spellName"] = true,
				["subeventPrefix"] = "SPELL",
				["unit"] = "target",
				["name_info"] = "aura",
				["custom_hide"] = "timed",
				["unevent"] = "timed",
				["spellName"] = "Gusting Bomb",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["use_zone"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["zone"] = "Siege of Orgrimmar",
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["use_combat"] = true,
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = " ",
			["regionType"] = "icon",
			["icon"] = true,
			["cooldown"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["additional_triggers"] = {
			},
			["id"] = "Spoils - Gusting Bomb",
			["xOffset"] = 620,
			["frameStrata"] = 1,
			["width"] = 63.99995040893555,
			["selfPoint"] = "CENTER",
			["inverse"] = false,
			["numTriggers"] = 1,
			["yOffset"] = 166,
			["stickyDuration"] = false,
			["displayIcon"] = "Interface\\Icons\\Spell_Nature_Cyclone",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Galakras - Flames of Galakrond"] = {
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["do_sound"] = true,
					["message_type"] = "SAY",
					["do_message"] = false,
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "aura",
				["spellId"] = "147068",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Health",
				["names"] = {
					"Flames of Galakrond", -- [1]
				},
				["use_spellId"] = true,
				["fullscan"] = true,
				["custom_hide"] = "timed",
				["subeventPrefix"] = "SPELL",
				["unit"] = "player",
				["debuffType"] = "HARMFUL",
			},
			["desaturate"] = false,
			["progressPrecision"] = 0,
			["font"] = "Friz Quadrata TT",
			["height"] = 64,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_zone"] = true,
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_combat"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "MAGE",
					["multi"] = {
						["MAGE"] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 24,
			["displayStacks"] = "Move out! %p",
			["regionType"] = "icon",
			["parent"] = "SoO 1st Part",
			["cooldown"] = true,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["stickyDuration"] = false,
			["additional_triggers"] = {
			},
			["yOffset"] = 166,
			["frameStrata"] = 1,
			["width"] = 64,
			["selfPoint"] = "CENTER",
			["numTriggers"] = 1,
			["inverse"] = false,
			["xOffset"] = 555,
			["id"] = "Galakras - Flames of Galakrond",
			["icon"] = true,
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["SWP"] = {
			["textFlags"] = "None",
			["stacksSize"] = 12,
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = 0,
			["stacksFlags"] = "None",
			["yOffset"] = 0,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "update",
			["rotateText"] = "NONE",
			["icon"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Health",
				["unit"] = "multi",
				["name"] = "Shadow Word: Pain",
				["debuffType"] = "HARMFUL",
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
				["custom_hide"] = "timed",
			},
			["text"] = true,
			["barColor"] = {
				1, -- [1]
				0, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["parent"] = "Track SWP Group",
			["stickyDuration"] = false,
			["barInFront"] = true,
			["timer"] = true,
			["timerFlags"] = "None",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["single"] = 3,
					["multi"] = {
						[3] = true,
					},
				},
				["class"] = {
					["single"] = "PRIEST",
					["multi"] = {
					},
				},
				["use_talent"] = false,
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["height"] = 15,
			["numTriggers"] = 1,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["textSize"] = 12,
			["borderOffset"] = 5,
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "aurabar",
			["borderSize"] = 16,
			["timerSize"] = 10,
			["icon_side"] = "RIGHT",
			["frameStrata"] = 1,
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["auto"] = true,
			["texture"] = "Flat",
			["textFont"] = "DorisPP",
			["stacksFont"] = "Friz Quadrata TT",
			["displayTextRight"] = "%n",
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["id"] = "SWP",
			["timerFont"] = "DorisPP",
			["alpha"] = 1,
			["width"] = 200,
			["stacks"] = true,
			["borderInset"] = 11,
			["inverse"] = false,
			["displayTextLeft"] = "%p",
			["orientation"] = "HORIZONTAL",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["untrigger"] = {
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Monk Avert Harm "] = {
			["xOffset"] = 0,
			["customText"] = "function(...)\n    local GetAuraSourceName = function(aura)\n        local RAID_SIZE = 25 -- CHANGE THIS        \n        if not aura then return end\n        local auraName = aura\n        if type(aura) == 'number' then auraName = GetSpellInfo(aura) end\n        for i=1,RAID_SIZE do\n            local unitCaster = select(8, UnitAura('raid'..i, auraName))\n            if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n        end    \n        local unitCaster = select(8, UnitAura('player', auraName))\n        if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n    end\n    \n    return GetAuraSourceName(select(5, ...))    \nend",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "event",
			["actions"] = {
				["start"] = {
					["do_glow"] = true,
					["glow_action"] = "show",
					["message_type"] = "RAID",
					["message"] = "",
					["do_message"] = false,
					["glow_frame"] = "WeakAuras:Monk Avert Harm",
				},
				["finish"] = {
					["message_type"] = "RAID",
					["message"] = "",
					["do_message"] = false,
					["do_sound"] = false,
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["name_info"] = "aura",
				["unit"] = "group",
				["group_countOperator"] = ">=",
				["names"] = {
					"Avert Harm", -- [1]
				},
				["custom_hide"] = "timed",
				["group_count"] = "2",
				["subeventPrefix"] = "SPELL",
				["event"] = "Health",
				["debuffType"] = "HELPFUL",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 60,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 19,
			["displayStacks"] = "  (%s) %n - %c",
			["regionType"] = "icon",
			["parent"] = "Raid Cooldowns Thok",
			["stacksPoint"] = "RIGHT",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["icon"] = true,
			["id"] = "Monk Avert Harm ",
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 60,
			["yOffset"] = 0,
			["numTriggers"] = 1,
			["inverse"] = false,
			["stickyDuration"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["additional_triggers"] = {
			},
			["cooldown"] = true,
			["textColor"] = {
				0.2549019607843137, -- [1]
				1, -- [2]
				0.01176470588235294, -- [3]
				1, -- [4]
			},
		},
		["Tactitian"] = {
			["parent"] = "Tank DPS Buffs",
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Tactician", -- [1]
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 30,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["disjunctive"] = true,
			["stacksPoint"] = "BOTTOM",
			["actions"] = {
				["start"] = {
					["do_glow"] = true,
					["do_custom"] = false,
					["glow_action"] = "show",
				},
				["finish"] = {
				},
			},
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["additional_triggers"] = {
				{
					["trigger"] = {
						["type"] = "aura",
						["debuffType"] = "HELPFUL",
						["subeventSuffix"] = "_CAST_START",
						["unit"] = "player",
						["names"] = {
							"Time Warp", -- [1]
						},
						["event"] = "Health",
						["subeventPrefix"] = "SPELL",
					},
					["untrigger"] = {
					},
				}, -- [1]
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["width"] = 30,
			["inverse"] = false,
			["untrigger"] = {
			},
			["numTriggers"] = 2,
			["id"] = "Tactitian",
			["selfPoint"] = "CENTER",
			["xOffset"] = 0,
			["cooldown"] = true,
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Regen"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["cooldown"] = true,
			["regionType"] = "icon",
			["yOffset"] = 20,
			["anchorPoint"] = "CENTER",
			["xOffset"] = 170,
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["inverse"] = false,
			["customTextUpdate"] = "update",
			["selfPoint"] = "CENTER",
			["icon"] = true,
			["trigger"] = {
				["unit"] = "player",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Enraged Regeneration", -- [1]
				},
				["debuffType"] = "HELPFUL",
				["event"] = "Health",
				["custom_hide"] = "timed",
			},
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "Regen",
			["desaturate"] = false,
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["width"] = 30,
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["parent"] = "Tank Def Buffs",
			["height"] = 30,
			["untrigger"] = {
			},
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Warrior Demoralizing Banner"] = {
			["xOffset"] = 0,
			["customText"] = "function(...)\n    local GetAuraSourceName = function(aura)\n        local RAID_SIZE = 25 -- CHANGE THIS        \n        if not aura then return end\n        local auraName = aura\n        if type(aura) == 'number' then auraName = GetSpellInfo(aura) end\n        for i=1,RAID_SIZE do\n            local unitCaster = select(8, UnitAura('raid'..i, auraName))\n            if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n        end    \n        local unitCaster = select(8, UnitAura('player', auraName))\n        if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n    end\n    \n    return GetAuraSourceName(select(5, ...))    \nend",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "event",
			["icon"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["duration"] = "15",
				["name_info"] = "aura",
				["unit"] = "target",
				["group_count"] = "2",
				["custom_hide"] = "timed",
				["type"] = "aura",
				["subeventSuffix"] = "_SUMMON",
				["event"] = "Combat Log",
				["group_countOperator"] = ">=",
				["use_spellName"] = true,
				["names"] = {
					"Demoralizing Banner", -- [1]
				},
				["debuffType"] = "HARMFUL",
				["use_destunit"] = false,
				["unevent"] = "timed",
				["spellName"] = "Demoralizing Banner",
				["subeventPrefix"] = "SPELL",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 60,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 19,
			["displayStacks"] = "  (%s) %n - %c",
			["regionType"] = "icon",
			["parent"] = "Raid Cooldowns Thok",
			["cooldown"] = true,
			["stickyDuration"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["id"] = "Warrior Demoralizing Banner",
			["additional_triggers"] = {
			},
			["actions"] = {
				["start"] = {
					["message"] = "",
					["glow_action"] = "show",
					["message_type"] = "RAID",
					["do_glow"] = true,
					["do_message"] = false,
					["glow_frame"] = "WeakAuras:Warrior Demoralizing Banner",
				},
				["finish"] = {
					["message_type"] = "RAID",
					["message"] = "",
					["do_message"] = false,
					["do_sound"] = false,
				},
			},
			["frameStrata"] = 1,
			["width"] = 60,
			["numTriggers"] = 1,
			["selfPoint"] = "CENTER",
			["inverse"] = false,
			["yOffset"] = 0,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayIcon"] = "Interface\\Icons\\demoralizing_banner",
			["stacksPoint"] = "RIGHT",
			["textColor"] = {
				0.2549019607843137, -- [1]
				1, -- [2]
				0.01176470588235294, -- [3]
				1, -- [4]
			},
		},
		["Tank CDs"] = {
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["controlledChildren"] = {
				"TCD: Shockwave", -- [1]
				"TCD: Taunt", -- [2]
				"TCD: Pummel", -- [3]
				"TCD: TC", -- [4]
				"TCD: Ultimatum", -- [5]
				"TCD: S Slam", -- [6]
				"TCD: Rev", -- [7]
				"TCD: Rev 2", -- [8]
				"TCD: S Block", -- [9]
				"TCD: S Barrier", -- [10]
			},
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = -150,
			["border"] = false,
			["yOffset"] = -220.0000305175781,
			["anchorPoint"] = "CENTER",
			["borderSize"] = 16,
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["borderOffset"] = 5,
			["selfPoint"] = "BOTTOMLEFT",
			["trigger"] = {
				["names"] = {
				},
				["type"] = "aura",
				["debuffType"] = "HELPFUL",
				["unit"] = "player",
			},
			["frameStrata"] = 1,
			["expanded"] = false,
			["untrigger"] = {
			},
			["borderInset"] = 11,
			["numTriggers"] = 1,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["borderEdge"] = "None",
			["id"] = "Tank CDs",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "group",
		},
		["HOP"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["cooldown"] = true,
			["xOffset"] = 170,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
			["yOffset"] = 20,
			["regionType"] = "icon",
			["parent"] = "Tank Def Buffs",
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
					["do_custom"] = false,
				},
				["finish"] = {
				},
			},
			["width"] = 30,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["custom_hide"] = "timed",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
					"Hand of Protection", -- [1]
				},
				["event"] = "Health",
				["unit"] = "player",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["id"] = "HOP",
			["font"] = "DorisPP",
			["inverse"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["height"] = 30,
			["anchorPoint"] = "CENTER",
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: Disrupting Shout"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["cooldown"] = true,
			["anchorPoint"] = "CENTER",
			["untrigger"] = {
				["spellName"] = 102060,
			},
			["regionType"] = "icon",
			["yOffset"] = 0,
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["stickyDuration"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["id"] = "TCD: Disrupting Shout",
			["width"] = 30,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["event"] = "Cooldown Progress (Spell)",
				["use_itemName"] = true,
				["names"] = {
				},
				["spellName"] = 102060,
				["use_spellName"] = true,
				["itemName"] = 0,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["unit"] = "player",
				["debuffType"] = "HELPFUL",
			},
			["font"] = "DorisPP",
			["inverse"] = true,
			["parent"] = "Tank CDs Long",
			["height"] = 30,
			["xOffset"] = 0,
			["stacksPoint"] = "RIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Druid Tranquility"] = {
			["xOffset"] = 0,
			["customText"] = "function(...)\n    local GetAuraSourceName = function(aura)\n        local RAID_SIZE = 25 -- CHANGE THIS        \n        if not aura then return end\n        local auraName = aura\n        if type(aura) == 'number' then auraName = GetSpellInfo(aura) end\n        for i=1,RAID_SIZE do\n            local unitCaster = select(8, UnitAura('raid'..i, auraName))\n            if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n        end    \n        local unitCaster = select(8, UnitAura('player', auraName))\n        if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n    end\n    \n    return GetAuraSourceName(select(5, ...))    \nend",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "event",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["glow_action"] = "show",
					["message_type"] = "RAID",
					["do_glow"] = true,
					["do_message"] = false,
					["glow_frame"] = "WeakAuras:Druid Tranquility",
				},
				["finish"] = {
					["message_type"] = "RAID",
					["message"] = "",
					["do_message"] = false,
					["do_sound"] = false,
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["name_info"] = "aura",
				["unit"] = "group",
				["group_countOperator"] = ">=",
				["names"] = {
					"Tranquility", -- [1]
				},
				["custom_hide"] = "timed",
				["group_count"] = "2",
				["subeventPrefix"] = "SPELL",
				["event"] = "Health",
				["debuffType"] = "HELPFUL",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 60,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 19,
			["displayStacks"] = "  (%s) %n - %c",
			["regionType"] = "icon",
			["parent"] = "Raid Cooldowns Thok",
			["stacksPoint"] = "RIGHT",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["icon"] = true,
			["additional_triggers"] = {
			},
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 60,
			["yOffset"] = 0,
			["numTriggers"] = 1,
			["inverse"] = false,
			["stickyDuration"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["id"] = "Druid Tranquility",
			["cooldown"] = true,
			["textColor"] = {
				0.2549019607843137, -- [1]
				1, -- [2]
				0.01176470588235294, -- [3]
				1, -- [4]
			},
		},
		["Enraged"] = {
			["parent"] = "Tank DPS Buffs",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["do_glow"] = true,
					["do_custom"] = false,
					["glow_action"] = "show",
				},
				["finish"] = {
				},
			},
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["unit"] = "player",
				["type"] = "aura",
				["subeventPrefix"] = "SPELL",
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
					"Enraged", -- [1]
				},
				["debuffType"] = "HELPFUL",
				["event"] = "Health",
				["custom_hide"] = "timed",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 30,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_level"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["regionType"] = "icon",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["cooldown"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["disjunctive"] = true,
			["additional_triggers"] = {
				{
					["trigger"] = {
						["type"] = "aura",
						["subeventPrefix"] = "SPELL",
						["subeventSuffix"] = "_CAST_START",
						["unit"] = "player",
						["names"] = {
							"Time Warp", -- [1]
						},
						["event"] = "Health",
						["debuffType"] = "HELPFUL",
					},
					["untrigger"] = {
					},
				}, -- [1]
			},
			["xOffset"] = 0,
			["frameStrata"] = 1,
			["width"] = 30,
			["numTriggers"] = 2,
			["yOffset"] = 20,
			["inverse"] = false,
			["stickyDuration"] = false,
			["id"] = "Enraged",
			["icon"] = true,
			["stacksPoint"] = "BOTTOM",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Monk Revival"] = {
			["xOffset"] = 0,
			["customText"] = "function(...)\n    local GetAuraSourceName = function(aura)\n        local RAID_SIZE = 25 -- CHANGE THIS        \n        if not aura then return end\n        local auraName = aura\n        if type(aura) == 'number' then auraName = GetSpellInfo(aura) end\n        for i=1,RAID_SIZE do\n            local unitCaster = select(8, UnitAura('raid'..i, auraName))\n            if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n        end    \n        local unitCaster = select(8, UnitAura('player', auraName))\n        if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n    end\n    \n    return GetAuraSourceName(select(5, ...))    \nend",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "event",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["glow_action"] = "show",
					["message_type"] = "RAID",
					["glow_frame"] = "WeakAuras:Monk Revival",
					["do_message"] = false,
					["do_glow"] = true,
				},
				["finish"] = {
					["message"] = "",
					["message_type"] = "RAID",
					["do_message"] = false,
					["do_sound"] = false,
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["name_info"] = "aura",
				["unit"] = "group",
				["custom_hide"] = "timed",
				["names"] = {
					"Revival", -- [1]
				},
				["group_countOperator"] = ">=",
				["group_count"] = "2",
				["subeventPrefix"] = "SPELL",
				["event"] = "Health",
				["debuffType"] = "HELPFUL",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 60,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 19,
			["displayStacks"] = "  (%s) %n - %c",
			["regionType"] = "icon",
			["parent"] = "Raid Cooldowns Thok",
			["cooldown"] = true,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["icon"] = true,
			["id"] = "Monk Revival",
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 60,
			["yOffset"] = 0,
			["numTriggers"] = 1,
			["inverse"] = false,
			["stickyDuration"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["additional_triggers"] = {
			},
			["stacksPoint"] = "RIGHT",
			["textColor"] = {
				0.2549019607843137, -- [1]
				1, -- [2]
				0.01176470588235294, -- [3]
				1, -- [4]
			},
		},
		["Flask"] = {
			["fontSize"] = 24,
			["displayStacks"] = "%p",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["untrigger"] = {
			},
			["yOffset"] = 185.9998779296875,
			["anchorPoint"] = "CENTER",
			["stacksPoint"] = "BOTTOMRIGHT",
			["regionType"] = "icon",
			["selfPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["trigger"] = {
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Health",
				["unit"] = "player",
				["useRem"] = true,
				["rem"] = "900",
				["remOperator"] = "<=",
				["subeventPrefix"] = "SPELL",
				["names"] = {
					"Flask of the Earth", -- [1]
				},
				["debuffType"] = "HELPFUL",
			},
			["icon"] = true,
			["numTriggers"] = 1,
			["stacksContainment"] = "INSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["id"] = "Flask",
			["width"] = 100,
			["frameStrata"] = 1,
			["stickyDuration"] = false,
			["xOffset"] = -408,
			["font"] = "DorisPP",
			["inverse"] = false,
			["desaturate"] = false,
			["height"] = 100,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["load"] = {
				["use_size"] = true,
				["use_role"] = true,
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["use_class"] = true,
				["role"] = {
					["single"] = "TANK",
					["multi"] = {
					},
				},
				["use_spec"] = true,
				["use_difficulty"] = false,
				["use_combat"] = false,
				["spec"] = {
					["single"] = 3,
					["multi"] = {
					},
				},
				["size"] = {
					["single"] = "twentyfive",
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: SW"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["parent"] = "Tank CDs Long",
			["cooldown"] = true,
			["yOffset"] = 0,
			["untrigger"] = {
				["spellName"] = 871,
			},
			["anchorPoint"] = "CENTER",
			["stacksPoint"] = "RIGHT",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["icon"] = true,
			["stickyDuration"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["id"] = "TCD: SW",
			["width"] = 30,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["event"] = "Cooldown Progress (Spell)",
				["use_itemName"] = true,
				["names"] = {
				},
				["spellName"] = 871,
				["use_spellName"] = true,
				["itemName"] = 0,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["unit"] = "player",
				["debuffType"] = "HELPFUL",
			},
			["font"] = "DorisPP",
			["inverse"] = true,
			["xOffset"] = 0,
			["height"] = 30,
			["regionType"] = "icon",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Melee Range"] = {
			["color"] = {
				1, -- [1]
				0, -- [2]
				0.02745098039215686, -- [3]
				0.75, -- [4]
			},
			["mirror"] = false,
			["yOffset"] = -200.2500305175781,
			["regionType"] = "texture",
			["blendMode"] = "BLEND",
			["xOffset"] = 4.50018310546875,
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["texture"] = "Interface\\AddOns\\WeakAuras\\Media\\Textures\\Square_White",
			["trigger"] = {
				["type"] = "custom",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Health",
				["unit"] = "player",
				["custom"] = "function()\n    if(IsSpellInRange(\"Shield Slam\", \"target\") == 1) then\n        return false\n    else\n        return true\n    end\nend\n\n\n\n",
				["custom_type"] = "status",
				["check"] = "update",
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
				["debuffType"] = "HELPFUL",
			},
			["selfPoint"] = "CENTER",
			["additional_triggers"] = {
				{
					["trigger"] = {
						["subeventPrefix"] = "SPELL",
						["type"] = "status",
						["event"] = "Unit Characteristics",
						["unevent"] = "auto",
						["unit"] = "target",
						["subeventSuffix"] = "_CAST_START",
						["use_attackable"] = true,
						["use_unit"] = true,
					},
					["untrigger"] = {
						["unit"] = "target",
					},
				}, -- [1]
			},
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "Melee Range",
			["rotation"] = 0,
			["frameStrata"] = 5,
			["desaturate"] = false,
			["discrete_rotation"] = 0,
			["anchorPoint"] = "CENTER",
			["numTriggers"] = 2,
			["width"] = 94.00044250488281,
			["height"] = 48.24996948242188,
			["rotate"] = true,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["use_combat"] = true,
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
				["custom"] = "function()\n    if(IsSpellInRange(\"Shield Slam\", \"target\") == 1) then\n        return true\n    else\n        return false\n    end\nend",
			},
		},
		["Timer 1st Engi"] = {
			["outline"] = true,
			["fontSize"] = 12,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["displayText"] = "",
			["yOffset"] = 0,
			["regionType"] = "text",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_sound"] = false,
				},
				["finish"] = {
					["message"] = "*** ENGINEER TIME!  MOVE OUT! ***",
					["do_sound"] = false,
					["message_type"] = "YELL",
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_message"] = true,
				},
			},
			["parent"] = "r",
			["selfPoint"] = "BOTTOM",
			["id"] = "Timer 1st Engi",
			["justify"] = "LEFT",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["additional_triggers"] = {
				{
					["trigger"] = {
						["subeventPrefix"] = "SPELL",
						["type"] = "custom",
						["custom"] = "function()\n    if UnitName(\"boss1\") == \"Garrosh Hellscream\" then\n        return true\n    else \n        return false\n    end\nend",
						["subeventSuffix"] = "_CAST_START",
						["check"] = "update",
						["custom_type"] = "status",
						["event"] = "Health",
						["custom_hide"] = "timed",
					},
					["untrigger"] = {
						["custom"] = "function()\n    return true\nend",
					},
				}, -- [1]
			},
			["disjunctive"] = false,
			["frameStrata"] = 1,
			["width"] = 0.9999997019767761,
			["xOffset"] = 0,
			["font"] = "Friz Quadrata TT",
			["numTriggers"] = 2,
			["anchorPoint"] = "CENTER",
			["height"] = 0.9999997019767761,
			["trigger"] = {
				["debuffType"] = "HELPFUL",
				["type"] = "custom",
				["custom_type"] = "event",
				["unevent"] = "timed",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["event"] = "Combat Log",
				["use_unit"] = true,
				["customDuration"] = "function()\n    return 10, GetTime() + 17\nend",
				["character"] = "player",
				["events"] = "PLAYER_REGEN_DISABLED",
				["unit"] = "player",
				["custom"] = "function(event, ...)\n    return event == \"PLAYER_REGEN_DISABLED\"\nend",
				["use_character"] = true,
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "custom",
			},
			["load"] = {
				["difficulty"] = "heroic",
				["use_zone"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["zone"] = "Siege of Orgrimmar",
				["spec"] = {
					["multi"] = {
					},
				},
				["use_difficulty"] = true,
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
		},
		["Lei Shen Transistions"] = {
			["outline"] = true,
			["fontSize"] = 72,
			["color"] = {
				1, -- [1]
				0, -- [2]
				0.1137254901960784, -- [3]
				1, -- [4]
			},
			["displayText"] = "%c\n",
			["customText"] = "function()\n    local percent = (UnitHealth(\"focus\")/UnitHealthMax(\"focus\"))*100 - 65.5;\n    return (\"%i\",2):format(percent);\nend",
			["yOffset"] = 102.0000610351563,
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["justify"] = "CENTER",
			["selfPoint"] = "BOTTOM",
			["trigger"] = {
				["type"] = "status",
				["use_health"] = false,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["percenthealth"] = "68",
				["event"] = "Health",
				["use_unit"] = true,
				["subeventSuffix"] = "_CAST_START",
				["names"] = {
				},
				["health"] = "68",
				["unit"] = "focus",
				["health_operator"] = "<",
				["use_percenthealth"] = true,
				["percenthealth_operator"] = "<=",
				["debuffType"] = "HELPFUL",
			},
			["untrigger"] = {
				["unit"] = "focus",
				["use_health"] = false,
				["health"] = "65.5",
				["health_operator"] = "<=",
				["percenthealth"] = "65.8",
				["use_percenthealth"] = true,
				["percenthealth_operator"] = "<=",
				["use_unit"] = true,
			},
			["frameStrata"] = 1,
			["width"] = 51.74994277954102,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["font"] = "Boris Black Bloxx",
			["numTriggers"] = 1,
			["xOffset"] = 48.7498779296875,
			["height"] = 144.0000457763672,
			["id"] = "Lei Shen Transistions",
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["regionType"] = "text",
		},
		["Dark Shamans - Ashen Wall"] = {
			["textFlags"] = "None",
			["stacksSize"] = 38,
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = 608.0005493164063,
			["stacksFlags"] = "None",
			["untrigger"] = {
				["use_specific_unit"] = true,
				["unit"] = "Earthbreaker Haromm",
			},
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "update",
			["rotateText"] = "NONE",
			["textSize"] = 38,
			["parent"] = "SoO 1st Part",
			["yOffset"] = 200.0001220703125,
			["displayTextLeft"] = "Ashen Wall",
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["preset"] = "alphaPulse",
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["selfPoint"] = "BOTTOM",
			["trigger"] = {
				["use_castType"] = false,
				["sourceunit"] = "target",
				["source"] = "Earthbreaker Haromm",
				["duration"] = "31",
				["use_spell"] = true,
				["unit"] = "Earthbreaker Haromm",
				["spellName"] = "Ashen Wall",
				["type"] = "event",
				["use_unit"] = true,
				["unevent"] = "timed",
				["use_specific_unit"] = true,
				["use_source"] = false,
				["event"] = "Combat Log",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["use_spellName"] = true,
				["spell"] = "Ashen Wall",
				["use_sourceunit"] = false,
				["use_destunit"] = false,
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["subeventPrefix"] = "SPELL",
			},
			["text"] = true,
			["barColor"] = {
				0.9607843137254902, -- [1]
				0.9647058823529412, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["displayText"] = "Adds Wall Incoming!!",
			["numTriggers"] = 1,
			["stickyDuration"] = false,
			["color"] = {
				0.8392156862745098, -- [1]
				1, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["height"] = 40,
			["timerFlags"] = "None",
			["load"] = {
				["use_never"] = true,
				["zone"] = "Siege of Orgrimmar",
				["use_role"] = true,
				["class"] = {
					["single"] = "PALADIN",
					["multi"] = {
						["PALADIN"] = true,
					},
				},
				["use_zone"] = true,
				["role"] = {
					["single"] = "TANK",
					["multi"] = {
					},
				},
				["use_combat"] = true,
				["spec"] = {
					["single"] = 2,
					["multi"] = {
						[2] = true,
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["outline"] = true,
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["alpha"] = 1,
			["borderSize"] = 16,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["additional_triggers"] = {
			},
			["timerSize"] = 38,
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "aurabar",
			["stacks"] = true,
			["auto"] = true,
			["icon_side"] = "LEFT",
			["stacksFont"] = "Friz Quadrata TT",
			["barInFront"] = true,
			["displayTextRight"] = "%p",
			["texture"] = "Blizzard",
			["textFont"] = "Friz Quadrata TT",
			["borderOffset"] = 5,
			["justify"] = "LEFT",
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["id"] = "Dark Shamans - Ashen Wall",
			["timerFont"] = "Friz Quadrata TT",
			["frameStrata"] = 1,
			["width"] = 300,
			["timer"] = true,
			["borderInset"] = 11,
			["inverse"] = false,
			["icon"] = true,
			["orientation"] = "HORIZONTAL",
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["actions"] = {
				["start"] = {
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\AirHorn.mp3",
					["do_sound"] = true,
				},
				["finish"] = {
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["TCD: SB"] = {
			["fontSize"] = 8,
			["displayStacks"] = "%p",
			["stacksPoint"] = "RIGHT",
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["cooldown"] = true,
			["anchorPoint"] = "CENTER",
			["untrigger"] = {
				["spellName"] = 114207,
			},
			["regionType"] = "icon",
			["yOffset"] = 0,
			["icon"] = true,
			["numTriggers"] = 1,
			["customTextUpdate"] = "update",
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["stickyDuration"] = false,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["selfPoint"] = "CENTER",
			["id"] = "TCD: SB",
			["width"] = 30,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["event"] = "Cooldown Progress (Spell)",
				["use_itemName"] = true,
				["names"] = {
				},
				["spellName"] = 114207,
				["use_spellName"] = true,
				["itemName"] = 0,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["unit"] = "player",
				["debuffType"] = "HELPFUL",
			},
			["font"] = "DorisPP",
			["inverse"] = true,
			["parent"] = "Tank CDs 2",
			["height"] = 30,
			["xOffset"] = 0,
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["vengeance text"] = {
			["outline"] = true,
			["fontSize"] = 10,
			["xOffset"] = -130.2496337890625,
			["displayText"] = "%s",
			["yOffset"] = -140,
			["regionType"] = "text",
			["customTextUpdate"] = "update",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["parent"] = "vengeance",
			["untrigger"] = {
			},
			["justify"] = "CENTER",
			["selfPoint"] = "RIGHT",
			["additional_triggers"] = {
			},
			["trigger"] = {
				["name_operator"] = "==",
				["subeventSuffix"] = "_CAST_START",
				["custom_hide"] = "timed",
				["event"] = "Health",
				["unit"] = "player",
				["use_name"] = true,
				["subcount"] = true,
				["name"] = "Vengeance",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
				["type"] = "aura",
				["fullscan"] = true,
			},
			["frameStrata"] = 1,
			["width"] = 39.00000381469727,
			["id"] = "vengeance text",
			["font"] = "DorisPP",
			["numTriggers"] = 1,
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["height"] = 9.750034332275391,
			["anchorPoint"] = "CENTER",
			["load"] = {
				["use_class"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["use_talent"] = false,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["single"] = "WARRIOR",
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Leg Sweep"] = {
			["cooldown"] = true,
			["fontSize"] = 24,
			["displayStacks"] = "%t",
			["load"] = {
				["use_size"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["difficulty"] = "heroic",
				["use_zone"] = false,
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["use_difficulty"] = true,
				["use_combat"] = true,
				["size"] = {
					["single"] = "twentyfive",
					["multi"] = {
					},
				},
			},
			["parent"] = "Stuns",
			["yOffset"] = 121.4999389648438,
			["regionType"] = "icon",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["xOffset"] = -294.7500610351563,
			["numTriggers"] = 1,
			["icon"] = true,
			["customTextUpdate"] = "update",
			["id"] = "Leg Sweep",
			["actions"] = {
				["start"] = {
					["sound_channel"] = "Master",
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\Bleat.mp3",
					["do_sound"] = true,
				},
				["finish"] = {
					["sound"] = "Interface\\Addons\\WeakAuras\\PowerAurasMedia\\Sounds\\swordecho.ogg",
					["do_sound"] = true,
				},
			},
			["width"] = 105.2499542236328,
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0,
			["auto"] = true,
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "shrink",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["type"] = "event",
				["subeventSuffix"] = "_CAST_SUCCESS",
				["duration"] = "5",
				["event"] = "Combat Log",
				["unit"] = "player",
				["spellName"] = "Leg Sweep",
				["use_spellName"] = true,
				["unevent"] = "timed",
				["use_sourceunit"] = false,
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
				["custom_hide"] = "timed",
			},
			["stickyDuration"] = false,
			["frameStrata"] = 1,
			["desaturate"] = false,
			["selfPoint"] = "CENTER",
			["font"] = "DorisPP",
			["inverse"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["height"] = 104.5000839233398,
			["displayIcon"] = "Interface\\Icons\\ability_monk_legsweep",
			["stacksPoint"] = "RIGHT",
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Injection"] = {
			["textFlags"] = "None",
			["stacksSize"] = 12,
			["borderBackdrop"] = "Blizzard Tooltip",
			["xOffset"] = -9.74981689453125,
			["stacksFlags"] = "None",
			["yOffset"] = 205.5001220703125,
			["anchorPoint"] = "CENTER",
			["borderColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["customTextUpdate"] = "update",
			["rotateText"] = "NONE",
			["icon"] = true,
			["selfPoint"] = "CENTER",
			["trigger"] = {
				["type"] = "status",
				["subeventSuffix"] = "_CAST_START",
				["event"] = "Cast",
				["unit"] = "target",
				["spell"] = "Injection",
				["use_spell"] = true,
				["use_unit"] = true,
				["unevent"] = "auto",
				["subeventPrefix"] = "SPELL",
				["names"] = {
				},
				["debuffType"] = "HELPFUL",
			},
			["text"] = true,
			["barColor"] = {
				1, -- [1]
				0, -- [2]
				0, -- [3]
				1, -- [4]
			},
			["desaturate"] = false,
			["disjunctive"] = true,
			["actions"] = {
				["start"] = {
					["sound_channel"] = "Master",
					["sound"] = "Interface\\AddOns\\WeakAuras\\Media\\Sounds\\Bleat.mp3",
					["do_sound"] = true,
				},
				["finish"] = {
				},
			},
			["animation"] = {
				["start"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["main"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
				["finish"] = {
					["duration_type"] = "seconds",
					["type"] = "none",
				},
			},
			["barInFront"] = true,
			["timer"] = true,
			["timerFlags"] = "None",
			["load"] = {
				["use_name"] = true,
				["role"] = {
					["multi"] = {
					},
				},
				["name"] = "Git",
				["use_never"] = true,
				["spec"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["textSize"] = 12,
			["backdropColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				0.5, -- [4]
			},
			["inverse"] = false,
			["height"] = 115.499870300293,
			["timerColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["backgroundColor"] = {
				0, -- [1]
				0, -- [2]
				0, -- [3]
				0.5, -- [4]
			},
			["stacksFont"] = "Friz Quadrata TT",
			["border"] = false,
			["borderEdge"] = "None",
			["regionType"] = "aurabar",
			["stacks"] = true,
			["alpha"] = 1,
			["icon_side"] = "RIGHT",
			["stacksColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["id"] = "Injection",
			["auto"] = true,
			["texture"] = "Blizzard",
			["textFont"] = "DorisPP",
			["borderOffset"] = 5,
			["timerSize"] = 12,
			["displayTextRight"] = "%p",
			["additional_triggers"] = {
				{
					["trigger"] = {
						["use_castType"] = false,
						["type"] = "status",
						["unevent"] = "auto",
						["event"] = "Cast",
						["subeventPrefix"] = "SPELL",
						["unit"] = "target",
						["subeventSuffix"] = "_CAST_START",
						["use_unit"] = true,
						["use_spell"] = true,
						["spell"] = "Caustic Blood",
					},
					["untrigger"] = {
						["unit"] = "target",
					},
				}, -- [1]
				{
					["trigger"] = {
						["type"] = "status",
						["subeventSuffix"] = "_CAST_START",
						["event"] = "Cast",
						["subeventPrefix"] = "SPELL",
						["spell"] = "Gouge",
						["use_spell"] = true,
						["use_unit"] = true,
						["unevent"] = "auto",
						["unit"] = "focus",
					},
					["untrigger"] = {
						["unit"] = "focus",
					},
				}, -- [2]
			},
			["timerFont"] = "Friz Quadrata TT",
			["frameStrata"] = 1,
			["width"] = 682.2501220703125,
			["borderSize"] = 16,
			["borderInset"] = 11,
			["numTriggers"] = 3,
			["displayTextLeft"] = "%n",
			["orientation"] = "HORIZONTAL",
			["stickyDuration"] = false,
			["untrigger"] = {
				["unit"] = "target",
			},
			["textColor"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
		},
		["Warrior Rallying Cry"] = {
			["xOffset"] = 0,
			["customText"] = "function(...)\n    local GetAuraSourceName = function(aura)\n        local RAID_SIZE = 25 -- CHANGE THIS        \n        if not aura then return end\n        local auraName = aura\n        if type(aura) == 'number' then auraName = GetSpellInfo(aura) end\n        for i=1,RAID_SIZE do\n            local unitCaster = select(8, UnitAura('raid'..i, auraName))\n            if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n        end    \n        local unitCaster = select(8, UnitAura('player', auraName))\n        if unitCaster and UnitExists(unitCaster) then return UnitName(unitCaster) end\n    end\n    \n    return GetAuraSourceName(select(5, ...))    \nend",
			["untrigger"] = {
			},
			["anchorPoint"] = "CENTER",
			["customTextUpdate"] = "event",
			["actions"] = {
				["start"] = {
					["message"] = "",
					["glow_action"] = "show",
					["message_type"] = "RAID",
					["do_glow"] = true,
					["do_message"] = false,
					["glow_frame"] = "WeakAuras:Warrior Rallying Cry",
				},
				["finish"] = {
					["message_type"] = "RAID",
					["message"] = "",
					["do_message"] = false,
					["do_sound"] = false,
				},
			},
			["animation"] = {
				["start"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "preset",
					["preset"] = "fade",
					["duration_type"] = "seconds",
				},
			},
			["trigger"] = {
				["stack_info"] = "count",
				["type"] = "aura",
				["subeventSuffix"] = "_CAST_START",
				["name_info"] = "aura",
				["unit"] = "group",
				["group_countOperator"] = ">=",
				["names"] = {
					"Rallying Cry", -- [1]
				},
				["custom_hide"] = "timed",
				["group_count"] = "2",
				["subeventPrefix"] = "SPELL",
				["event"] = "Health",
				["debuffType"] = "HELPFUL",
			},
			["desaturate"] = false,
			["font"] = "DorisPP",
			["height"] = 60,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["use_never"] = false,
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["fontSize"] = 19,
			["displayStacks"] = "  (%s) %n - %c",
			["regionType"] = "icon",
			["parent"] = "Raid Cooldowns Thok",
			["stacksPoint"] = "RIGHT",
			["stacksContainment"] = "OUTSIDE",
			["zoom"] = 0.3,
			["auto"] = true,
			["icon"] = true,
			["additional_triggers"] = {
			},
			["selfPoint"] = "CENTER",
			["frameStrata"] = 1,
			["width"] = 60,
			["yOffset"] = 0,
			["numTriggers"] = 1,
			["inverse"] = false,
			["stickyDuration"] = false,
			["color"] = {
				1, -- [1]
				1, -- [2]
				1, -- [3]
				1, -- [4]
			},
			["id"] = "Warrior Rallying Cry",
			["cooldown"] = true,
			["textColor"] = {
				0.2549019607843137, -- [1]
				1, -- [2]
				0.01176470588235294, -- [3]
				1, -- [4]
			},
		},
		["Raid Cooldowns Thok"] = {
			["grow"] = "DOWN",
			["controlledChildren"] = {
				"Disc Priest Barrier", -- [1]
				"Holy Priest Divine Hymn", -- [2]
				"Druid Tranquility", -- [3]
				"Monk Avert Harm ", -- [4]
				"Monk Revival", -- [5]
				"Monk Zen Meditation", -- [6]
				"Pally Devotion Aura", -- [7]
				"Rogue Smoke Bomb", -- [8]
				"Shaman Healing Tide Totem", -- [9]
				"Shaman Spirit Link Totem", -- [10]
				"Warrior Demoralizing Banner", -- [11]
				"Warrior Rallying Cry", -- [12]
			},
			["animate"] = false,
			["xOffset"] = 342.7498168945313,
			["regionType"] = "dynamicgroup",
			["border"] = "None",
			["yOffset"] = 516.5000610351563,
			["anchorPoint"] = "CENTER",
			["actions"] = {
				["start"] = {
				},
				["finish"] = {
				},
			},
			["sort"] = "none",
			["radius"] = 200,
			["space"] = 2,
			["background"] = "None",
			["expanded"] = false,
			["constantFactor"] = "RADIUS",
			["additional_triggers"] = {
			},
			["backgroundInset"] = 0,
			["align"] = "CENTER",
			["animation"] = {
				["start"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["main"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
				["finish"] = {
					["type"] = "none",
					["duration_type"] = "seconds",
				},
			},
			["id"] = "Raid Cooldowns Thok",
			["selfPoint"] = "TOP",
			["frameStrata"] = 1,
			["width"] = 59.99993896484375,
			["rotation"] = 0,
			["stagger"] = 0,
			["numTriggers"] = 1,
			["trigger"] = {
				["type"] = "aura",
				["unit"] = "player",
				["subeventSuffix"] = "_CAST_START",
				["debuffType"] = "HELPFUL",
				["names"] = {
				},
				["event"] = "Health",
				["subeventPrefix"] = "SPELL",
			},
			["height"] = 742.0000152587891,
			["borderOffset"] = 16,
			["load"] = {
				["role"] = {
					["multi"] = {
					},
				},
				["class"] = {
					["multi"] = {
					},
				},
				["spec"] = {
					["multi"] = {
					},
				},
				["size"] = {
					["multi"] = {
					},
				},
			},
			["untrigger"] = {
			},
		},
	},
	["talent_cache"] = {
		["HUNTER"] = {
		},
		["WARRIOR"] = {
			{
				["name"] = "Juggernaut",
				["icon"] = "Interface\\Icons\\Ability_Warrior_BullRush",
			}, -- [1]
			{
				["name"] = "Double Time",
				["icon"] = "Interface\\Icons\\INV_Misc_Horn_04",
			}, -- [2]
			{
				["name"] = "Warbringer",
				["icon"] = "Interface\\Icons\\Ability_Warrior_Warbringer",
			}, -- [3]
			{
				["name"] = "Enraged Regeneration",
				["icon"] = "Interface\\Icons\\Ability_Warrior_FocusedRage",
			}, -- [4]
			{
				["name"] = "Second Wind",
				["icon"] = "Interface\\Icons\\Ability_Hunter_Harass",
			}, -- [5]
			{
				["name"] = "Impending Victory",
				["icon"] = "Interface\\Icons\\spell_impending_victory",
			}, -- [6]
			{
				["name"] = "Staggering Shout",
				["icon"] = "Interface\\Icons\\Ability_BullRush",
			}, -- [7]
			{
				["name"] = "Piercing Howl",
				["icon"] = "Interface\\Icons\\Spell_Shadow_DeathScream",
			}, -- [8]
			{
				["name"] = "Disrupting Shout",
				["icon"] = "Interface\\Icons\\warrior_disruptingshout",
			}, -- [9]
			{
				["name"] = "Bladestorm",
				["icon"] = "Interface\\Icons\\Ability_Warrior_Bladestorm",
			}, -- [10]
			{
				["name"] = "Shockwave",
				["icon"] = "Interface\\Icons\\Ability_Warrior_Shockwave",
			}, -- [11]
			{
				["name"] = "Dragon Roar",
				["icon"] = "Interface\\Icons\\ability_warrior_dragonroar",
			}, -- [12]
			{
				["name"] = "Mass Spell Reflection",
				["icon"] = "Interface\\Icons\\Ability_Warrior_ShieldBreak",
			}, -- [13]
			{
				["name"] = "Safeguard",
				["icon"] = "Interface\\Icons\\Ability_Warrior_Safeguard",
			}, -- [14]
			{
				["name"] = "Vigilance",
				["icon"] = "Interface\\Icons\\Ability_Warrior_Vigilance",
			}, -- [15]
			{
				["name"] = "Avatar",
				["icon"] = "Interface\\Icons\\warrior_talent_icon_avatar",
			}, -- [16]
			{
				["name"] = "Bloodbath",
				["icon"] = "Interface\\Icons\\Ability_Warrior_BloodBath",
			}, -- [17]
			{
				["name"] = "Storm Bolt",
				["icon"] = "Interface\\Icons\\warrior_talent_icon_stormbolt",
			}, -- [18]
		},
		["ROGUE"] = {
		},
		["MAGE"] = {
		},
		["PRIEST"] = {
			{
				["name"] = "Void Tendrils",
				["icon"] = "Interface\\Icons\\spell_priest_voidtendrils",
			}, -- [1]
			{
				["name"] = "Psyfiend",
				["icon"] = "Interface\\Icons\\spell_priest_psyfiend",
			}, -- [2]
			{
				["name"] = "Dominate Mind",
				["icon"] = "Interface\\Icons\\Spell_Shadow_ShadowWordDominate",
			}, -- [3]
			{
				["name"] = "Body and Soul",
				["icon"] = "Interface\\Icons\\Spell_Holy_SymbolOfHope",
			}, -- [4]
			{
				["name"] = "Angelic Feather",
				["icon"] = "Interface\\Icons\\ability_priest_angelicfeather",
			}, -- [5]
			{
				["name"] = "Phantasm",
				["icon"] = "Interface\\Icons\\ability_priest_phantasm",
			}, -- [6]
			{
				["name"] = "From Darkness, Comes Light",
				["icon"] = "Interface\\Icons\\Spell_Holy_SurgeOfLight",
			}, -- [7]
			{
				["name"] = "Mindbender",
				["icon"] = "Interface\\Icons\\Spell_Shadow_SoulLeech_3",
			}, -- [8]
			{
				["name"] = "Solace and Insanity",
				["icon"] = "Interface\\Icons\\ability_priest_flashoflight",
			}, -- [9]
			{
				["name"] = "Desperate Prayer",
				["icon"] = "Interface\\Icons\\Spell_Holy_TestOfFaith",
			}, -- [10]
			{
				["name"] = "Spectral Guise",
				["icon"] = "Interface\\Icons\\spell_priest_spectralguise",
			}, -- [11]
			{
				["name"] = "Angelic Bulwark",
				["icon"] = "Interface\\Icons\\ability_priest_angelicbulwark",
			}, -- [12]
			{
				["name"] = "Twist of Fate",
				["icon"] = "Interface\\Icons\\Spell_Shadow_MindTwisting",
			}, -- [13]
			{
				["name"] = "Power Infusion",
				["icon"] = "Interface\\Icons\\Spell_Holy_PowerInfusion",
			}, -- [14]
			{
				["name"] = "Divine Insight",
				["icon"] = "Interface\\Icons\\spell_priest_burningwill",
			}, -- [15]
			{
				["name"] = "Cascade",
				["icon"] = "Interface\\Icons\\ability_priest_cascade",
			}, -- [16]
			{
				["name"] = "Divine Star",
				["icon"] = "Interface\\Icons\\spell_priest_divinestar",
			}, -- [17]
			{
				["name"] = "Halo",
				["icon"] = "Interface\\Icons\\ability_priest_halo",
			}, -- [18]
		},
		["WARLOCK"] = {
		},
		["SHAMAN"] = {
		},
		["DEATHKNIGHT"] = {
		},
		["DRUID"] = {
			{
				["name"] = "Feline Swiftness",
				["icon"] = "Interface\\Icons\\spell_druid_tirelesspursuit",
			}, -- [1]
			{
				["name"] = "Displacer Beast",
				["icon"] = "Interface\\Icons\\spell_druid_displacement",
			}, -- [2]
			{
				["name"] = "Wild Charge",
				["icon"] = "Interface\\Icons\\spell_druid_wildcharge",
			}, -- [3]
			{
				["name"] = "Ysera's Gift",
				["icon"] = "Interface\\Icons\\INV_Misc_Head_Dragon_Green",
			}, -- [4]
			{
				["name"] = "Renewal",
				["icon"] = "Interface\\Icons\\Spell_Nature_NatureBlessing",
			}, -- [5]
			{
				["name"] = "Cenarion Ward",
				["icon"] = "Interface\\Icons\\Ability_Druid_NaturalPerfection",
			}, -- [6]
			{
				["name"] = "Faerie Swarm",
				["icon"] = "Interface\\Icons\\spell_druid_swarm",
			}, -- [7]
			{
				["name"] = "Mass Entanglement",
				["icon"] = "Interface\\Icons\\spell_druid_massentanglement",
			}, -- [8]
			{
				["name"] = "Typhoon",
				["icon"] = "Interface\\Icons\\Ability_Druid_Typhoon",
			}, -- [9]
			{
				["name"] = "Soul of the Forest",
				["icon"] = "Interface\\Icons\\Ability_Druid_ManaTree",
			}, -- [10]
			{
				["name"] = "Incarnation",
				["icon"] = "Interface\\Icons\\spell_druid_incarnation",
			}, -- [11]
			{
				["name"] = "Force of Nature",
				["icon"] = "Interface\\Icons\\Ability_Druid_ForceofNature",
			}, -- [12]
			{
				["name"] = "Disorienting Roar",
				["icon"] = "Interface\\Icons\\Ability_Druid_DemoralizingRoar",
			}, -- [13]
			{
				["name"] = "Ursol's Vortex",
				["icon"] = "Interface\\Icons\\spell_druid_ursolsvortex",
			}, -- [14]
			{
				["name"] = "Mighty Bash",
				["icon"] = "Interface\\Icons\\Ability_Druid_Bash",
			}, -- [15]
			{
				["name"] = "Heart of the Wild",
				["icon"] = "Interface\\Icons\\Spell_Holy_BlessingOfAgility",
			}, -- [16]
			{
				["name"] = "Dream of Cenarius",
				["icon"] = "Interface\\Icons\\Ability_Druid_Dreamstate",
			}, -- [17]
			{
				["name"] = "Nature's Vigil",
				["icon"] = "Interface\\Icons\\Achievement_Zone_Feralas",
			}, -- [18]
		},
		["MONK"] = {
		},
		["PALADIN"] = {
		},
	},
	["login_squelch_time"] = 5,
	["frame"] = {
		["xOffset"] = -1069.756408691406,
		["yOffset"] = -503.2496948242188,
		["height"] = 492,
		["width"] = 630.0006713867188,
	},
	["tempIconCache"] = {
		["Life Cocoon"] = "Interface\\Icons\\ability_monk_chicocoon",
		["Projection"] = "Interface\\Icons\\sha_ability_warrior_bloodnova",
		["Shockwave"] = "Interface\\Icons\\Ability_Warrior_Shockwave",
		["Shadow Word: Pain"] = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
		["Sundering Blow"] = "Interface\\Icons\\Ability_Warrior_Sunder",
		["Riposte"] = "Interface\\Icons\\Ability_Warrior_Riposte",
		["Pain Suppression"] = "Interface\\Icons\\Spell_Holy_PainSupression",
		["Power Word: Barrier"] = "Interface\\Icons\\spell_holy_powerwordbarrier",
		["Shield Barrier"] = "Interface\\Icons\\inv_shield_07",
		["Tricks of the Trade"] = "Interface\\Icons\\Ability_Rogue_TricksOftheTrade",
		["Smoke Bomb"] = "INTERFACE\\ICONS\\ability_rogue_smoke",
		["Demoralizing Shout"] = "Interface\\Icons\\Ability_Warrior_WarCry",
		["Rallying Cry"] = "INTERFACE\\ICONS\\ability_toughness",
		["Zen Meditation"] = "Interface\\Icons\\ability_monk_zenmeditation",
		["Destabilize"] = "Interface\\Icons\\Ability_CriticalStrike",
		["Last Stand"] = "Interface\\Icons\\Spell_Holy_AshesToAshes",
		["Weakened Blows"] = "Interface\\Icons\\INV_Relics_TotemofRage",
		["Flame Arrows"] = "Interface\\Icons\\INV_Elemental_Primal_Fire",
		["Ancient Barrier"] = "Interface\\Icons\\ability_malkorok_blightofyshaarj_yellow",
		["Froststorm Strike"] = "INTERFACE\\ICONS\\spell_shaman_unleashweapon_frost",
		["Strong Ancient Barrier"] = "Interface\\Icons\\ability_malkorok_blightofyshaarj_green",
		["Noxious Poison"] = "Interface\\Icons\\Ability_Rogue_DeviousPoisons",
		["Acidic Spines"] = "Interface\\Icons\\Ability_PoisonArrow",
		["Demoralizing Banner"] = "Interface\\Icons\\demoralizing_banner",
		["Mark of Arrogance"] = "INTERFACE\\ICONS\\ability_warlock_impoweredimp",
		["Crystal Shell: Full Capacity!"] = "Interface\\Icons\\inv_datacrystal08",
		["Vigilance"] = "Interface\\Icons\\Ability_Warrior_Vigilance",
		["Avoidance"] = "Interface\\Icons\\Ability_Rogue_QuickRecovery",
		["Fusion"] = "Interface\\Icons\\sha_spell_fire_blueimmolation",
		["Erupting Pustules"] = "Interface\\Icons\\Spell_Shadow_CorpseExplode",
		["Unstable Vita"] = "Interface\\Icons\\Spell_Nature_LightningBolt",
		["Shield Wall"] = "Interface\\Icons\\Ability_Warrior_ShieldWall",
		["Vengeance"] = "Interface\\Icons\\Spell_Shadow_Charm",
		["Hand of Protection"] = "Interface\\Icons\\Spell_Holy_SealOfProtection",
		["Tranquility"] = "Interface\\Icons\\Spell_Nature_Tranquility",
		["Weakened Resolve"] = "Interface\\Icons\\ability_titankeeper_phasing",
		["Wounded Pride"] = "Interface\\Icons\\Spell_Misc_EmotionSad",
		["Shield Block"] = "Interface\\Icons\\Ability_Defend",
		["Bloodbath"] = "Interface\\Icons\\Ability_Warrior_BloodBath",
		["Instant Poison"] = "Interface\\Icons\\Ability_Creature_Poison_04",
		["Weakened Armor"] = "Interface\\Icons\\Ability_Warrior_Sunder",
		["Shadowform"] = "Interface\\Icons\\Spell_Shadow_Shadowform",
		["Gas Bladder"] = "Interface\\Icons\\Ability_Rogue_DeviousPoisons",
		["Crystal Shell"] = "Interface\\Icons\\INV_DataCrystal01",
		["Time Warp"] = "INTERFACE\\ICONS\\ability_mage_timewarp",
		["Avert Harm"] = "Interface\\Icons\\monk_ability_avertharm",
		["Spirit Link Totem"] = "Interface\\Icons\\Spell_Shaman_SpiritLink",
		["Recklessness"] = "Interface\\Icons\\Ability_CriticalStrike",
		["Acceleration"] = "Interface\\Icons\\ability_vehicle_sonicshockwave",
		["Devotion Aura"] = "Interface\\Icons\\Spell_Holy_AuraMastery",
		["Flames of Galakrond"] = "Interface\\Icons\\spell_fire_moltenblood",
		["Ultimatum"] = "Interface\\Icons\\Ability_Warrior_StalwartProtector",
		["Scary Fog"] = "Interface\\Icons\\Spell_Shadow_Haunting",
		["Reshape Life"] = "INTERFACE\\ICONS\\trade_archaeology_insect in amber",
		["Bloodlust"] = "Interface\\Icons\\Spell_Nature_BloodLust",
		["Spell Reflection"] = "Interface\\Icons\\Ability_Warrior_ShieldReflection",
		["Flask of the Earth"] = "Interface\\Icons\\trade_alchemy_potione6",
		["Divine Hymn"] = "Interface\\Icons\\Spell_Holy_DivineProvidence",
		["Guardian Spirit"] = "Interface\\Icons\\Spell_Holy_GuardianSpirit",
		["Hand of Sacrifice"] = "Interface\\Icons\\Spell_Holy_SealOfSacrifice",
		["Vampiric Touch"] = "Interface\\Icons\\Spell_Holy_Stoicism",
		["Berserker Rage"] = "Interface\\Icons\\Spell_Nature_AncestralGuardian",
		["Weak Ancient Barrier"] = "Interface\\Icons\\ability_malkorok_blightofyshaarj_red",
	},
	["registered"] = {
	},
}
