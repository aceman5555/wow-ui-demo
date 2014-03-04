
oRA3DB = {
	["namespaces"] = {
		["Tanks"] = {
			["factionrealm"] = {
				["Horde - Azuremyst"] = {
					["persistentTanks"] = {
						"Necrosuss", -- [1]
						"Git", -- [2]
						"Gosuhaxbear", -- [3]
					},
				},
				["Horde - Cho'gall"] = {
					["persistentTanks"] = {
						"Git", -- [1]
						"Malvision", -- [2]
						"Layonhooves", -- [3]
					},
				},
			},
		},
		["Loot"] = {
			["profiles"] = {
				["Gilt"] = {
					["enable"] = true,
					["raid"] = {
						["threshold"] = 3,
					},
				},
				["WARRIOR"] = {
					["enable"] = true,
					["raid"] = {
						["master"] = "Got",
					},
				},
				["Default"] = {
					["enable"] = true,
					["raid"] = {
						["master"] = "Git",
					},
				},
				["Giit tank"] = {
					["enable"] = true,
					["raid"] = {
						["threshold"] = 3,
						["master"] = "Shv",
					},
				},
			},
		},
		["Invite"] = {
			["global"] = {
				["keyword"] = "jailbreak",
			},
		},
		["Cooldowns"] = {
			["profiles"] = {
				["Gilt"] = {
					["lockDisplay"] = true,
					["spells"] = {
						[98008] = true,
						[62618] = true,
						[740] = true,
						[20484] = true,
						[2825] = true,
						[33206] = true,
						[61999] = true,
						[97462] = true,
						[1022] = true,
						[47788] = true,
						[64901] = false,
						[31821] = true,
					},
				},
				["WARRIOR"] = {
					["showDisplay"] = false,
					["spells"] = {
						[98008] = true,
						[62618] = true,
						[77761] = false,
						[740] = true,
						[20484] = false,
						[73325] = true,
						[33206] = true,
						[29166] = false,
						[47788] = true,
						[2825] = true,
						[97462] = true,
					},
					["neverShowMine"] = true,
					["lockDisplay"] = true,
				},
				["Default"] = {
					["showDisplay"] = false,
					["spells"] = {
						[98008] = true,
						[62618] = true,
						[740] = true,
						[33206] = true,
						[97462] = true,
						[31821] = true,
						[1022] = true,
						[47788] = true,
						[64901] = false,
					},
					["barClassColor"] = false,
				},
				["Giit tank"] = {
					["spells"] = {
						[98008] = true,
						[77761] = false,
						[740] = true,
						[2825] = true,
						[33206] = true,
						[97462] = true,
						[47788] = true,
						[73325] = true,
						[29166] = true,
					},
					["neverShowMine"] = true,
					["lockDisplay"] = true,
				},
			},
		},
		["ReadyCheck"] = {
			["profiles"] = {
				["Giit tank"] = {
					["relayReady"] = true,
				},
				["WARRIOR"] = {
					["relayReady"] = true,
				},
			},
		},
		["Promote"] = {
			["factionrealm"] = {
				["Horde - Azuremyst"] = {
					["promotes"] = {
						"Findadar", -- [1]
						"Duckiebutter", -- [2]
					},
					["promoteGuild"] = false,
					["promoteRank"] = {
						["Requiem"] = {
							nil, -- [1]
							true, -- [2]
							true, -- [3]
							true, -- [4]
							true, -- [5]
						},
					},
					["promoteAll"] = false,
				},
				["Horde - Cho'gall"] = {
					["promoteRank"] = {
						["Lusting on Trash"] = {
							true, -- [1]
							true, -- [2]
							true, -- [3]
							true, -- [4]
						},
					},
					["promotes"] = {
						"Nidater", -- [1]
					},
				},
				["Horde - Silvermoon"] = {
					["promotes"] = {
					},
					["promoteRank"] = {
					},
				},
			},
		},
		["LibDualSpec-1.0"] = {
		},
	},
	["char"] = {
		["Git - Cho'gall"] = {
			["lastRaidDifficulty"] = 4,
		},
	},
	["profileKeys"] = {
		["Gitt - Cho'gall"] = "WARRIOR",
		["Giit - Cho'gall"] = "Giit tank",
		["Gimm - Cho'gall"] = "Default",
		["Gyit - Area 52"] = "Default",
		["Git - Cho'gall"] = "Default",
		["Ghit - Azuremyst"] = "Default",
		["Giit - Azuremyst"] = "Default",
		["Evyyn - Azuremyst"] = "Default",
		["Giitt - Silvermoon"] = "Default",
		["Giitt - Feathermoon"] = "Default",
		["Git - Azuremyst"] = "Default",
		["Ezyn - Azuremyst"] = "Default",
		["Spih - Cho'gall"] = "Default",
		["Gilt - Azuremyst"] = "Gilt",
		["Worgit - Moon Guard"] = "Default",
	},
	["profiles"] = {
		["Gilt"] = {
			["lastSelectedPanel"] = "Tanks",
			["positions"] = {
				["oRA3ReadyCheck"] = {
					["Height"] = 366.9999749069572,
					["Width"] = 320.0000764740353,
					["PosY"] = 562.0201343702588,
					["PosX"] = 245.9203676480566,
				},
				["oRA3CooldownFrame"] = {
					["Height"] = 219.6308381828392,
					["PosX"] = 1098.040652373624,
					["PosY"] = 309.6998636741114,
					["Width"] = 208.8617105540706,
				},
			},
			["lastSelectedList"] = 2,
		},
		["WARRIOR"] = {
			["lastSelectedPanel"] = "Tanks",
			["positions"] = {
				["oRA3ReadyCheck"] = {
					["Height"] = 311,
					["Width"] = 319.999755859375,
					["PosY"] = 448.8857712166209,
					["PosX"] = 927.0401355290378,
				},
				["oRA3CooldownFrame"] = {
					["Height"] = 354.0307006835938,
					["Width"] = 210.3385009765625,
					["PosY"] = 390.3401407117053,
					["PosX"] = 1066.359396921325,
				},
			},
			["lastSelectedList"] = 1,
		},
		["Default"] = {
			["lastSelectedList"] = 2,
			["positions"] = {
				["oRA3ReadyCheck"] = {
					["Height"] = 309,
					["PosX"] = 248.3203460121076,
					["PosY"] = 472.9002238048561,
					["Width"] = 320.0000305175781,
				},
				["oRA3CooldownFrame"] = {
					["Height"] = 219.6308746337891,
					["Width"] = 208.8617095947266,
					["PosY"] = 309.6998172964195,
					["PosX"] = 1098.04060045688,
				},
			},
			["lastSelectedPanel"] = "Promote",
		},
		["Giit tank"] = {
			["lastSelectedList"] = 1,
			["positions"] = {
				["oRA3ReadyCheck"] = {
					["Height"] = 297,
					["PosX"] = 222.8804849888547,
					["PosY"] = 420.4053373628267,
					["Width"] = 319.9999389648438,
				},
				["oRA3CooldownFrame"] = {
					["Height"] = 354.0307006835938,
					["PosX"] = 1066.359396921325,
					["PosY"] = 390.3401407117053,
					["Width"] = 210.3385009765625,
				},
			},
			["lastSelectedPanel"] = "Checks",
		},
	},
}
