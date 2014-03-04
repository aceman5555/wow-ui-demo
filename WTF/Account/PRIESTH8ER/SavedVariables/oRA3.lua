
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
					["spells"] = {
						[98008] = true,
						[62618] = true,
						[740] = true,
						[20484] = true,
						[2825] = true,
						[33206] = true,
						[61999] = true,
						[31821] = true,
						[1022] = true,
						[47788] = true,
						[64901] = false,
						[97462] = true,
					},
					["lockDisplay"] = true,
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
						[97462] = true,
						[2825] = true,
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
						[64901] = false,
						[1022] = true,
						[47788] = true,
						[31821] = true,
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
						[29166] = true,
						[73325] = true,
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
		["LibDualSpec-1.0"] = {
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
		["Git - Azuremyst"] = "Default",
		["Ghit - Azuremyst"] = "Default",
		["Giit - Azuremyst"] = "Default",
		["Evyyn - Azuremyst"] = "Default",
		["Giitt - Silvermoon"] = "Default",
		["Ezyn - Azuremyst"] = "Default",
		["Gilt - Azuremyst"] = "Gilt",
		["Spih - Cho'gall"] = "Default",
		["Giitt - Feathermoon"] = "Default",
		["Git - Cho'gall"] = "Default",
		["Worgit - Moon Guard"] = "Default",
	},
	["profiles"] = {
		["Gilt"] = {
			["lastSelectedList"] = 2,
			["positions"] = {
				["oRA3ReadyCheck"] = {
					["Height"] = 366.9999749069572,
					["PosX"] = 245.9203676480566,
					["PosY"] = 562.0201343702588,
					["Width"] = 320.0000764740353,
				},
				["oRA3CooldownFrame"] = {
					["Height"] = 219.6308381828392,
					["Width"] = 208.8617105540706,
					["PosY"] = 309.6998636741114,
					["PosX"] = 1098.040652373624,
				},
			},
			["lastSelectedPanel"] = "Tanks",
		},
		["WARRIOR"] = {
			["lastSelectedList"] = 1,
			["positions"] = {
				["oRA3ReadyCheck"] = {
					["Height"] = 311,
					["PosX"] = 927.0401355290378,
					["PosY"] = 448.8857712166209,
					["Width"] = 319.999755859375,
				},
				["oRA3CooldownFrame"] = {
					["Height"] = 354.0307006835938,
					["PosX"] = 1066.359396921325,
					["PosY"] = 390.3401407117053,
					["Width"] = 210.3385009765625,
				},
			},
			["lastSelectedPanel"] = "Tanks",
		},
		["Default"] = {
			["lastSelectedList"] = 2,
			["positions"] = {
				["oRA3ReadyCheck"] = {
					["Height"] = 309,
					["Width"] = 320.0000305175781,
					["PosY"] = 472.9002238048561,
					["PosX"] = 248.3203460121076,
				},
				["oRA3CooldownFrame"] = {
					["Height"] = 219.630859375,
					["PosX"] = 1098.040678581878,
					["PosY"] = 309.6998563589186,
					["Width"] = 208.8617095947266,
				},
			},
			["lastSelectedPanel"] = "Promote",
		},
		["Giit tank"] = {
			["lastSelectedPanel"] = "Checks",
			["positions"] = {
				["oRA3ReadyCheck"] = {
					["Height"] = 297,
					["Width"] = 319.9999389648438,
					["PosY"] = 420.4053373628267,
					["PosX"] = 222.8804849888547,
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
	},
}
