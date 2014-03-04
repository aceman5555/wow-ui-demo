
SkadaDB = {
	["namespaces"] = {
		["LibDualSpec-1.0"] = {
		},
	},
	["profileKeys"] = {
		["Evun - Azuremyst"] = "Default",
		["Gyit - Area 52"] = "Default",
		["Ghit - Azuremyst"] = "Default",
		["Giit - Azuremyst"] = "Default",
		["Evyyn - Azuremyst"] = "Default",
		["Giitt - Silvermoon"] = "Default",
		["Cowbeary - Azuremyst"] = "Default",
		["Gilt - Azuremyst"] = "Default",
		["Ezyn - Azuremyst"] = "Default",
		["Worgit - Moon Guard"] = "Default",
		["Gitt - Cho'gall"] = "Default",
		["Giit - Cho'gall"] = "Default",
		["Gimm - Cho'gall"] = "Default",
		["Evn - Azuremyst"] = "Default",
		["Git - Cho'gall"] = "Default",
		["Burk - Azuremyst"] = "Default",
		["Spih - Cho'gall"] = "Default",
		["Git - Azuremyst"] = "Default",
		["Giitt - Feathermoon"] = "Default",
		["Lihte - Cho'gall"] = "Lihte-DPS",
		["Greny - Azuremyst"] = "Default",
		["Raweo - Azuremyst"] = "Default",
	},
	["profiles"] = {
		["Default"] = {
			["windows"] = {
				{
					["barheight"] = 11,
					["barslocked"] = true,
					["background"] = {
						["height"] = 258.0458374023438,
					},
					["y"] = -0,
					["barfont"] = "DorisPP",
					["title"] = {
						["font"] = "DorisPP",
						["fontsize"] = 9,
						["height"] = 14,
						["texture"] = "Flat",
					},
					["mode"] = "DPS",
					["x"] = 402.417236328125,
					["barwidth"] = 267.6577453613281,
					["point"] = "BOTTOM",
					["barfontsize"] = 7,
					["bartexture"] = "Minimalist",
				}, -- [1]
			},
			["icon"] = {
				["hide"] = true,
			},
			["report"] = {
				["number"] = 25,
				["channel"] = "raid",
				["target"] = "Tydesin",
				["mode"] = "Damage on Siege Engineer",
			},
			["tooltiprows"] = 10,
			["reset"] = {
				["join"] = 2,
			},
		},
		["Lihte-DPS"] = {
			["windows"] = {
				{
					["y"] = -58.9373779296875,
					["x"] = -364.0623779296875,
					["point"] = "TOPRIGHT",
					["barwidth"] = 237.0463256835938,
					["mode"] = "Damage",
					["background"] = {
						["height"] = 189.9232482910156,
					},
				}, -- [1]
			},
			["report"] = {
				["number"] = 25,
				["chantype"] = "whisper",
				["target"] = "Raehn",
				["channel"] = "whisper",
			},
			["icon"] = {
				["hide"] = true,
			},
			["reset"] = {
				["instance"] = 3,
			},
		},
	},
}
