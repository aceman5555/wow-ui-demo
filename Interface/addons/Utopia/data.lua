local Utopia = LibStub("AceAddon-3.0"):GetAddon("Utopia", true)
if (not Utopia) then
	return
end
Utopia:UpdateVersion("$Revision: 219 $")

local wowVersion = tonumber((select(2,GetBuildInfo())))

local L = LibStub("AceLocale-3.0"):GetLocale("Utopia")

-- All talent scans are done by name. No messing around with slot indexes etc.
-- Notable fields:
--		interested	- The types of player interested in seeing this icon (for the automatic icon selection)

-- 4.0 TODO
-- 1) lvl calcs. All amounts are fixed to level 80 atm

Utopia.bloodlustID = UnitFactionGroup("player") == "Horde" and 2825 or 32182		-- Bloodlust/Heroism
Utopia.bloodlustList = {
	[Utopia.bloodlustID] = true,
	[80353] = true,
	[90355] = true,
}
Utopia.bloodlustNames = {}
for id in pairs(Utopia.bloodlustList) do
	Utopia.bloodlustNames[GetSpellInfo(id)] = id
end

Utopia.buffs = {
	[L["Armor"]] = {
		icon = select(3, GetSpellInfo(465)),
		attribute = L["Armor"],
		interested = "tank",
		spells = {
			[465] = {									-- Devotion Aura
				class			= "PALADIN",
				exclusive		= "aura",
				amount			= 1150,
				minLevel		= 5,
			},
			[8072] = {									-- Stoneskin (now non-stacking or?)
				class			= "SHAMAN",
				totem			= "earth",
				source			= 8071,					-- Stoneskin Totem
				amount			= 1150,
				minLevel		= 48,
			},
		},
	},
	[L["Attack Power"]] = {
		icon = select(3, GetSpellInfo(19506)),
		attribute = L["AP"],
		interested = "melee,tank",
		spells = {
			[19740] = {										-- Blessing of Might
				class			= "PALADIN",
				exclusive		= "blessing",
				amount			= 10,
				amountType		= "%",
				minLevel		= 56,
			},
			[19506] = {										-- Trueshot Aura
				class			= "HUNTER",
				spec			= "Marksmanship",
				amount			= 10,
				amountType		= "%",
				requiredTalent	= 19506,					-- Trueshot Aura
				minLevel		= 25,
			},
			[53138] = {										-- Abomination's Might
				class			= "DEATHKNIGHT",
				spec			= "Blood",
				amount			= 10,
				amountType		= "%",
				requiredTalent	= 53138,					-- Abomination's Might
				minLevel		= 55,
			},
			[30802] = {										-- Unleashed Rage
				class			= "SHAMAN",
				spec			= "Enhancement",
				amountPerTalentPoint = 10/2,
				maxTalentPoints = 2,
				amountType		= "%",
				requiredTalent	= 30802,
				minLevel		= 30,
			},
		},
	},
	["Bloodlust/Heroism"] = {
		icon = select(3, GetSpellInfo(Utopia.bloodlustID)),
		attribute = L["Haste"],
		spells = {
			[Utopia.bloodlustID] = {						-- Bloodlust / Heroism
				class			= "SHAMAN",
				amount			= 30,
				amountType		= "%",
				minLevel		= 70,
				temporary		= true,
			},
			[80353] = {										-- Time Warp
				class			= "MAGE",
				amount			= 30,
				amountType		= "%",
				minLevel		= 85,
				temporary		= true,
			},
			[90355] = {										-- Ancient Hysteria
				class			= "HUNTER",
				pet				= L["Core Hound"],
				spec			= "Beast Mastery",
				amount			= 30,
				amountType		= "%",
				minLevel		= 57,						-- Min level based on lowest level Core Hounds (I think)..
				temporary		= true,
			},
		},
	},
	[L["Critical Strike Chance"]] = {
		icon = select(3, GetSpellInfo(17007)),
		attribute = L["Crit"],
		spells = {
			[17007] = {										-- Leader of the Pack
				class			= "DRUID",
				spec			= "Feral",
				amount			= 5,
				amountType		= "%",
				requiredTalent	= 17007,					-- Leader of the Pack
				minLevel		= 40,
				temporary		= true,
			},
			[29801] = {										-- Rampage
				class			= "WARRIOR",
				spec			= "Fury",
				amount			= 5,
				amountType		= "%",
				requiredTalent	= 29801,					-- Rampage
				minLevel		= 50,
			},
			[51698] = {										-- Honor Among Thieves
				class			= "ROGUE",					-- TODO Check Debuff Name
				spec			= "Subtlety",
				amount			= 5,
				amountType		= "%",
				requiredTalent	= 51698,					-- Honor Among Thieves
				minLevel		= 25,
			},
			[24604] = {										-- Furious Howl
				class			= "HUNTER",
				pet				= L["Wolf"],				-- TODO: Add Dog
				amount			= 5,
				amountType		= "%",
				temporary		= true,
				minLevel		= 20,
			},
			[90309] = {										-- Terrifying Roar
				class			= "HUNTER",
				spec			= "Beast Mastery",
				pet				= L["Devilsaur"],
				amount			= 5,
				amountType		= "%",
				temporary		= true,
				requiredTalent	= 53270,					-- Beast Mastery
				minLevel		= 40,
			},
			[51466] = {										-- Elemental Oath
				class			= "SHAMAN",
				spec			= "Elemental",
				amountPerTalentPoint = 2.5,
				maxTalentPoints	= 2,
				amountType		= "%",
				requiredTalent	= 51466,					-- Elemental Oath
				minLevel		= 25,
			},
		},
	},
	[L["Damage (%)"]] = {
		icon = select(3, GetSpellInfo(34460)),
		attribute = L["Damage Modifier"],
		attributeShort = L["Damage"],
		interested = "melee,caster",
		spells = {
			[75447] = {										-- Ferocious Inspiration
				class			= "HUNTER",
				spec			= "Beast Mastery",
				amount			= 3,
				amountType		= "%",
				requiredTalent	= 34460,					-- Ferocious Inspiration
				minLevel		= 40,
			},
			[31876] = {										-- Communion (was Sanctified Retribution)
				class			= "PALADIN",				-- TODO: Is this the name of the raid buff? Not found one on wowhead.
				spec			= "Retribution",
				amount			= 3,
				amountType		= "%",
				requiredTalent	= 31876,					-- Communion (was Sanctified Retribution)
				minLevel		= 30,
			},
			[82930] = {										-- Arcane Tactics
				class			= "MAGE",
				spec			= "Arcane",
				amount			= 3,
				amountType		= "%",
				requiredTalent	= 82930,					-- Arcane Tactics
				minLevel		= 25,
			},
		},
	},
	[L["Damage Reduction Physical (%)"]] = {
		icon = select(3, GetSpellInfo(16177)),
		attribute = L["Physical Damage Reduction"],
		attributeShort = L["Reduction"],
		interested = "tank",
		spells = {
			[16177] = {										-- Ancestral Fortitude
				class			= "SHAMAN",
				spec			= "Restoration",
				amountPerTalentPoint = 10/2,
				maxTalentPoints	= 2,
				amountType		= "%",
				requiredTalent	= 16176,					-- Ancestral Healing
				minLevel		= 20,
				temporary		= true,
			},
			[14893] = {										-- Inspiration
				class			= "PRIEST",
				spec			= "Holy",
				amountPerTalentPoint = 10/2,
				maxTalentPoints	= 2,
				amountType		= "%",
				requiredTalent	= 14892,					-- Inspiration
				minLevel		= 20,
				temporary		= true,
			},
		},
	},
	[L["Attack Speed"]] = {
		icon = select(3, GetSpellInfo(55610)),
		attribute = L["Haste"],
		interested = "melee",
		spells = {
			[55610] = {										-- Improved Icy Talons
				alternate		= 50887,					-- Icy Talons (The DK themself only get this aura)
				class			= "DEATHKNIGHT",
				spec			= "Frost",
				amount			= 10,
				amountType		= "%",
				requiredTalent	= 55610,					-- Improved Icy Talons
				minLevel		= 55,						-- 25?
			},
			[8512] = {										-- Windfury	Totem
				class			= "SHAMAN",
				totem			= "air",
				amount			= 10,
				amountType		= "%",
				minLevel		= 32,
			},
			[53290] = {										-- Hunting Party
				class			= "HUNTER",
				spec			= "Survival",
				amount			= 10,
				amountType		= "%",
				requiredTalent	= 53290,					-- Hunting Party
				minLevel		= 30,
			},
		},
	},
	[L["Spell Haste"]] = {
		icon = select(3, GetSpellInfo(3738)),
		attribute = L["Haste"],
		interested = "caster,healer",
		spells = {
			[3738] = {										-- Wrath of Air Totem
				class			= "SHAMAN",
				totem			= "air",
				amount			= 5,
				amountType		= "%",
				minLevel		= 44,
			},
			[24907] = {										-- Moonkin Aura
				class			= "DRUID",
				spec			= "Moonkin",
				amount			= 5,
				amountType		= "%",
				requiredTalent	= 24858,					-- Moonkin Form
				minLevel		= 20,
			},
			[49868] = {										-- Mind Quickening
				alternate		= 15473,					-- Shadowform
				class			= "PRIEST",
				spec			= "Shadow",
				amount			= 5,
				amountType		= "%",
				requiredTalent	= 15473,					-- Shadowform
				minLevel		= 20,
			},
		},
	},
	[L["Mana"]] = {
		icon = select(3, GetSpellInfo(1459)),
		attribute = L["Mana"],
		interested = "manauser",
		reportable = true,
		spells = {
			[1459] = {										-- Arcane Brilliance
				alternate		= 61316,					-- Dalaran Brilliance
				class			= "MAGE",
				amount			= 600,
				minLevel		= 58,
			},
			[54424] = {										-- Fel Intelligence
				class			= "WARLOCK",
				pet				= L["Felhunter"],
				amount			= 600,
				minLevel		= 32,
			},
		},
	},
	[L["Mana Regen"]] = {
		icon = select(3, GetSpellInfo(5675)),
		attribute = L["mp5"],
		interested = "manauser",
		spells = {
			[19740] = {										-- Blessing of Might
				class			= "PALADIN",
				exclusive		= "blessing",
				amount			= 92,
				minLevel		= 56,
			},
			[54424] = {										-- Fel Intelligence
				class			= "WARLOCK",
				pet				= L["Felhunter"],
				amount			= 92,
				minLevel		= 32,
			},
			[5675] = {										-- Mana Spring Totem
				class			= "SHAMAN",
				totem			= "water",
				amount			= 92,
				minLevel		= 42,
			},
		},
	},
	[L["Replenishment"]] = {
		icon = select(3, GetSpellInfo(57669)),
		id = 57669,
		attribute = L["Mana Regen"],
		interested = "manauser",
		spells = {
			[31876] = {										-- Communion (was Judgements of the Wise)
				alternate		= 57669,					-- Replenishment
				class			= "PALADIN",
				spec			= "Retribution",
				requiredTalent	= 31876,					-- Communion (was Judgements of the Wise)
				minLevel		= 40,
				temporary		= true,
			},
			[34914] = {										-- Vampiric Touch
				alternate		= 57669,					-- Replenishment
				class			= "PRIEST",
				spec			= "Shadow",
				requiredTalent	= 34914,					-- Vampiric Touch
				minLevel		= 30,
				temporary		= true,
			},
			[44561] = {										-- Enduring Winter
				alternate		= 57669,					-- Replenishment
				class			= "MAGE",
				spec			= "Frost",
				requiredTalent	= 44561,					-- Enduring Winter
				minLevel		= 25,
				temporary		= true,
			},
			[30293] = {										-- Soul Leech
				alternate		= 57669,					-- Replenishment
				class			= "WARLOCK",
				spec			= "Destruction",
				requiredTalent	= 30293,					-- Soul Leech
				minLevel		= 45,
				temporary		= true,
			},
			[48539] = {										-- Revitalise
				alternate		= 57669,					-- Replenishment
				class			= "DRUID",
				spec			= "Restoration",
				requiredTalent	= 48539,					-- Revitalise
				minLevel		= 45,
				temporary		= true,
			},
		},
	},
	[L["Spell Power"]] = {
		icon = select(3, GetSpellInfo(8227)),
		attribute = L["Spell Power"],
		interested = "manauser",
		spells = {
			[1459] = {										-- Arcane Brilliance
				class			= "MAGE",
				amount			= 6,
				amountType		= "%",
				minLevel		= 58,
			},
			[53646] = {										-- Demonic Pact
				class			= "WARLOCK",
				spec			= "Demonology",
				pet				= "any",
				amount			= 10,
				amountType		= "%",
				requiredTalent	= 47236,					-- Demonic Pact
				minLevel		= 35,
			},
			[8227] = {										-- Flametongue Totem
				class			= "SHAMAN",
				totem			= "fire",
				amount			= 6,
				amountType		= "%",
				minLevel		= 12,
			},
			[77746] = {										-- Totemic Wrath
				class			= "SHAMAN",
				totem			= "fire",					-- Any fire totem
				spec			= "Elemental",
				amount			= 10,
				amountType		= "%",
				requiredTalent	= 77746,					-- Totemic Wrath
				minLevel		= 30,
			},
		},
	},
	[L["Stamina"]] = {
		icon = select(3, GetSpellInfo(21562)),
		attribute = L["Stamina"],
		interested = "tank,healer",
		raidbuff = true,
		reportable = true,
		spells = {
			[21562] = {										-- Power Word: Fortitude
				-- 10=11, 40=34,80=165
				class			= "PRIEST",
				amount			= 165,
				minLevel		= 14,
			},
			[72590] = {										-- Fortitude
				amount			= 165,
				runescroll		= 49632,					-- Runescroll of Fortitude
				minLevel		= 80,
			},
			[6307] = {										-- Blood Pact
				class			= "WARLOCK",
				pet				= L["Imp"],
				amount			= 165,
				minLevel		= 4,
			},
			[469] = {										-- Commanding Shout
				class			= "WARRIOR",
				exclusive		= "warriorbuff",
				amount			= 165,
				minLevel		= 68,
			},
			[90364] = {
				class			= "HUNTER",
				spec			= "Beast Mastery",
				pet				= L["Silithid"],
				amount			= 165,
				minLevel		= 40,
			},
		},
	},
	[L["Stats"]] = {
		icon = select(3, GetSpellInfo(1126)),
		attribute = L["Stats"],
		raidbuff = true,
		reportable = true,
		spells = {
			[1126] = {										-- Mark of the Wild
				class			= "DRUID",
				amount			= 5,
				amountType		= "%",
				minLevel		= 2,
			},
			[79062] = {										-- Blessing of Kings
				class			= "PALADIN",
				amount			= 5,
				amountType		= "%",
				minLevel		= 20,
			},
			[90363] = {										-- Embrace of the Shale Spider
				class			= "HUNTER",
				pet				= L["Shale Spider"],
				amount			= 5,
				amountType		= "%",
				minLevel		= 50,
			},
			[69378] = {										-- Blessing of Forgotten Kings
				amount			= 4,
				amountType		= "%",
				runescroll		= 49633,					-- Drums of Forgotten Kings
				minLevel		= 80,
			},
		},
	},
	[L["Strength & Agility"]] = {
		icon = select(3, GetSpellInfo(8075)),
		attribute = L["Str & Agi"],
		interested = "melee,tank",
		spells = {
			[8075] = {										-- Strength of Earth Totem
				class			= "SHAMAN",
				totem			= "earth",
				amount			= 155,
				temporary		= true,
				minLevel		= 4,
			},
			[57330] = {										-- Horn of Winter
				class			= "DEATHKNIGHT",
				amount			= 155,
				temporary		= true,
				minLevel		= 65,
			},
			[93435] = {										-- Roar of Courage
				class			= "HUNTER",
				pet				= L["Cat"],					-- TODO - And Spirit Beast
				amount			= 155,
				minLevel		= 20,
			},
			[6673] = {										-- Battle Shout
				class			= "WARRIOR",
				exclusive		= "warriorbuff",
				amount			= 155,
				minLevel		= 20,
			},
		},
	},
	[L["Spell Pushback Prevention"]] = {
		icon = select(3, GetSpellInfo(19746)),
		attribute = L["Pushback"],
		interested = "caster",
		spells = {
			[19746] = {										-- Concentration Aura
				class			= "PALADIN",
				amount			= 35,
				amountType		= "%",
				exclusive		= "aura",
				minLevel		= 42,
			},
			[87718] = {										-- Totem of Tranquil Mind
				class			= "SHAMAN",
				totem			= "water",
				amount			= 30,
				amountType		= "%",
				minLevel		= 74,
			},
		},
	},
}

do
	-- Mark of the wild resist amounts
	-- (cond($lte(PL,70),PL/2,cond($lte(PL,80),PL/2+(PL-70)/2*5,PL/2+(PL-70)/2*5+(PL-80)/2*7))-0.5),
	local function markResistFunc(unit)
		local PL = UnitLevel(unit or "player") or MAX_PLAYER_LEVEL
		if (PL) then
			if (PL <= 70) then
				return ceil(PL/2)
			else
				if (PL <= 80) then
					return ceil((PL/2+(PL-70)/2*5)-0.5)
				else
					return ceil((PL/2+(PL-70)/2*5+(PL-80)/2*7)-0.5)
				end
			end
		end
	end

	-- Resistance Aura/Totems
	-- (cond($lte(PL,70),PL,cond($lte(PL,80),PL+(PL-70)*5,PL+(PL-70)*5+(PL-80)*7)))
	local function resistAuraFunc(unit)
		local PL = UnitLevel(unit or "player") or MAX_PLAYER_LEVEL
		if (PL) then
			if (PL <= 70) then
				return PL
			else
				if (PL <= 80) then
					return PL+(PL-70)*5
				else
					return PL+(PL-70)*5+(PL-80)*7
				end
			end
		end
	end

	Utopia.buffs[L["Resistance"]] = {
		icon = select(3, GetSpellInfo(19891)),
		attribute = L["Resists"],
		raidbuff = true,
		spells = {
			[19891] = {										-- Resistance Aura
				class = "PALADIN",
				schools			= SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_SHADOW,		-- TODO: This does nothing yet
				amount			= 130,						-- TODO values
				amountFunc		= resistAuraFunc,
				minLevel		= 76,
			},
			[8184] = {
				class			= "SHAMAN",
				schools			= SCHOOL_MASK_FIRE + SCHOOL_MASK_FROST + SCHOOL_MASK_NATURE,
				amount			= 130,
				amountFunc		= resistAuraFunc,
				minLevel		= 62,
			},
			[1126] = {										-- Mark of the Wild
				-- All resists
				class			= "DRUID",
				amount			= 65,
				amountFunc		= markResistFunc,
				minLevel		= 2,
			},
			[79062] = {										-- Blessing of Kings
				-- All resists
				class			= "PALADIN",
				amount			= 65,
				amountFunc		= markResistFunc,
				minLevel		= 20,
			},
		}
	}
end

Utopia.debuffs = {
	[L["Armor"]] = {
		icon = select(3, GetSpellInfo(7386)),
		attribute = L["Armor"],
		interested = "melee,tank",
		spells = {
			[8647] = {										-- Expose Armor
				class			= "ROGUE",
				amount			= 12,
				amountType		= "%",
				minLevel		= 36,
			},
			[7386] = {										-- Sunder Armor
				class			= "WARRIOR",
				amountPerStack	= 4,
				amountType		= "%",
				maxStacks		= 3,
				minLevel		= 18,
			},
			[770] = {										-- Faerie Fire
				class			= "DRUID",
				amountPerStack	= 4,
				amountType		= "%",
				maxStacks		= 3,
				priority		= 1,
				minLevel		= 24,
			},
			[16857] = {										-- Faerie Fire (Feral)
				class			= "DRUID",
				amountPerStack	= 4,
				amountType		= "%",
				maxStacks		= 3,
				minLevel		= 24,
				priority		= 1,
			},
			[50498] = {										-- Tear Armor
				class			= "HUNTER",
				pet				= L["Raptor"],
				amountPerStack	= 4,
				amountType		= "%",
				maxStacks		= 3,
				minLevel		= 24,
				priority		= 1,
			},
			[35387] = {										-- Corrosive Spit
				class			= "HUNTER",
				pet				= L["Serpent"],
				amountPerStack	= 4,
				amountType		= "%",
				maxStacks		= 3,
				minLevel		= 24,
				priority		= 1,
			},
		},
	},
	[L["Bleed Damage"]] = {
		icon = select(3, GetSpellInfo(33878)),
		interested = "melee,tank",
		spells = {
			[33878] = {										-- Mangle
				class			= "DRUID",
				amount			= 30,
				amountType		= "%",
				spec			= "Feral",
				requiredTalent	= 33917,					-- Mangle
				minLevel		= 10,
			},
			[16511] = {										-- Hemorrhage
				class			= "ROGUE",
				spec			= "Subtlety",
				amount			= 30,
				amountType		= "%",
				requiredTalent	= 16511,					-- Hemorrhage
				minLevel		= 20,
			},
			[29836] = {										-- Blood Frenzy
				class			= "WARRIOR",
				spec			= "Arms",
				amountPerTalentPoint = 15,
				amountType		= "%",
				maxTalentPoints	= 2,
				requiredTalent	= 29836,					-- Blood Frenzy
				minLevel		= 25,
			},
			[57386] = {										-- Stampede
				class			= "HUNTER",
				spec			= "Beast Mastery",
				pet				= L["Rhino"],
				amount			= 30,
				amountType		= "%",
				minLevel		= 40,
			},
			[35290] = {										-- Gore
				class			= "HUNTER",
				spec			= "Beast Mastery",
				pet				= L["Boar"],
				amount			= 30,
				amountType		= "%",
				minLevel		= 40,
			},
			[50271] = {										-- Tendon Rip
				class			= "HUNTER",
				spec			= "Beast Mastery",
				pet				= L["Hyena"],
				amount			= 30,
				amountType		= "%",
				minLevel		= 40,
			},
		},
	},
	[L["Damage Done (Physical)"]] = {
		icon = select(3, GetSpellInfo(1160)),
		attribute = L["Physical Damage"],
		interested = "tank",
		spells = {
			[702] = {										-- Curse of Weakness
				class			= "WARLOCK",
				amount			= 10,
				amountType		= "%",
				exclusive		= "curse",
				minLevel		= 16,
			},
			[99] = {										-- Demoralizing Roar
				class			= "DRUID",
				spec			= "Feral",
				amount			= 10,
				amountType		= "%",
				minLevel		= 15,
			},
			[1160] = {										-- Demoralizing Shout
				class			= "WARRIOR",
				amount			= 10,
				amountType		= "%",
				minLevel		= 52,
			},
			[26016] = {										-- Vindication
				class			= "PALADIN",
				spec			= "Protection",
				amount			= 10,
				amountType		= "%",
				requiredTalent	= 26016,
				minLevel		= 30,
			},
			[81131] = {										-- Scarlet Fever
				class			= "DEATHKNIGHT",
				spec			= "Blood",
				amount			= 10,
				amountType		= "%",
				requiredTalent	= 81131,
				minLevel		= 55,
			},
			--[50256] = {										-- Demoralizing Roar
			--	class			= "HUNTER",		-- TODO: Conflict with druid..
			--	pet				= "Bear",
			--	amount			= 10,
			--	amountType		= "%",
			--},
			[24423] = {										-- Demoralizing Screech
				class			= "HUNTER",
				amount			= 10,
				amountType		= "%",
				pet				= L["Bird of Prey"],		-- TODO Carrion Bird
				minLevel		= 5,						-- Lowest level carrion bird
			},
		},
	},
	[L["Cast Speed Slow"]] = {
		icon = select(3, GetSpellInfo(5761)),
		interested = "tank",
		exclude = function(unit) return UnitPowerMax(unit, 0) == 0 end,
		spells = {
			[1714] = {										-- Curse of Tongues
				class			= "WARLOCK",
				amount			= 30,
				amountType		= "%",
				exclusive		= "curse",
				minLevel		= 26,
			},
			[25810] = {										-- Mind-numbing Poison
				class			= "ROGUE",
				amount			= 30,
				amountType		= "%",
				minLevel		= 24,
			},
			[58604] = {										-- Lava Breath
				class			= "HUNTER",
				spec			= "Beast Mastery",
				pet				= L["Core Hound"],
				amount			= 25,
				amountType		= "%",
				requiredTalent	= 53270,					-- Beast Mastery
				temporary		= true,
				minLevel		= 40,
			},
			[31589] = {										-- Slow
				class			= "MAGE",
				spec			= "Arcane",
				amount			= 30,
				amountType		= "%",
				requiredTalent	= 31589,					-- Slow
				minLevel		= 30,
      		},
			[50274] = {										-- Spore Cloud
				class			= "HUNTER",
				pet				= L["Sporebat"],
				amount			= 25,
				amountType		= "%",
				minLevel		= 60,						-- Lowest level Sporebat
			},
		},
	},
	[L["Healing Taken"]] = {
		icon = select(3, GetSpellInfo(12294)),
		interested = "tank",
		spells = {
			[12294] = {										-- Mortal Strike
				class			= "WARRIOR",
				spec			= "Arms",
				amount			= 25,
				amountType		= "%",
				requiredTalent	= 12294,					-- Mortal Strike
				minLevel		= 10,
			},
			[13218] = {										-- Wound Poison
				class			= "ROGUE",
				amount			= 25,
				amountType		= "%",
				minLevel		= 32,
			},
			[48301] = {										-- Mind Trauma
				class			= "PRIEST",
				spec			= "Shadow",
				amount			= 25,
				amountType		= "%",
				requiredTalent	= 15273,					-- Improved Mind Blast
				minLevel		= 15,
			},
			[7321] = {										-- Chilled
				class			= "MAGE",					-- Need to validate that chilled was from this mage
				spec			= "Frost",
				amountPerTalentPoint = 25 / 3,
				maxTalentPoints	= 3,
				amountType		= "%",
				requiredTalent	= 11175,					-- Permafrost
				minLevel		= 15,
			},
			[46910] = {										-- Furious Attacks
				class			= "WARRIOR",
				spec			= "Fury",
				amount			= 25,
				amountType		= "%",
				requiredTalent	= 46910,					-- Furious Attacks
				minLevel		= 45,
			},
			[82654] = {										-- Widow Venom
				class			= "HUNTER",
				amount			= 25,
				amountType		= "%",
				minLevel		= 40,
			},
			[54680] = {										-- Monsterous Bite
				class			= "HUNTER",
				spec			= "Beast Mastery",
				pet				= L["Devilsaur"],
				amount			= 25,
				amountType		= "%",
				minLevel		= 40,
			},
			[30213] = {										-- Legion Strike
				class			= "WARLOCK",
				spec			= "Demonology",
				pet				= L["Felguard"],
				amount			= 25,
				amountType		= "%",
				minLevel		= 10,
			},
		},
	},
	[L["Melee Attack Speed Slow"]] = {
		icon = select(3, GetSpellInfo(6343)),
		interested = "tank",
		spells = {
			[59921] = {										-- Frost Fever
				class			= "DEATHKNIGHT",
				amount			= 20,
				amountType		= "%",
				minLevel		= 55,
			},
			[48483] = {										-- Infected Wounds
				class			= "DRUID",
				spec			= "Feral",
				amountPerTalentPoint = 10,
				amountType		= "%",
				maxTalentPoints	= 2,
				requiredTalent	= 48483,					-- Infected Wounds
				minLevel		= 15,
			},
			[53695] = {										-- Judgements of the Just
				class			= "PALADIN",
				spec			= "Protection",
				amountPerTalentPoint = 10,
				amountType		= "%",
				maxTalentPoints	= 2,
				requiredTalent	= 53695,					-- Judgements of the Just
				minLevel		= 15,
			},
			[6343] = {										-- Thunder Clap
				class			= "WARRIOR",
				amount			= 20,
				amountType		= "%",
				minLevel		= 9,
			},
			[51692] = {										-- Waylay
				class			= "ROGUE",
				amount			= 20,
				amountType		= "%",
				requiredTalent	= 51692,
				minLevel		= 15,
			},
			[8042] = {										-- Earth Shock
				class			= "SHAMAN",
				amount			= 20,
				amountType		= "%",
				minLevel		= 5,
			},
			[50285] = {										-- Dust Cloud
				class			= "HUNTER",
				pet				= L["Tallstrider"],
				amount			= 20,
				amountType		= "%",
				minLevel		= 8,
			},
			[90314] = {										-- Tailspin
				class			= "HUNTER",
				pet				= L["Fox"],
				amount			= 20,
				amountType		= "%",
				minLevel		= 8,
			},
		},
	},
	[L["Physical Vulnerability"]] = {
		icon = select(3, GetSpellInfo(58413)),
		interested = "tank,melee",
		spells = {
			[51682] = {										-- Savage Combat
				class			= "ROGUE",
				spec			= "Combat",
				amountPerTalentPoint = 2,
				amountType		= "%",
				maxTalentPoints	= 2,
				requiredTalent	= 51682,					-- Savage Combat
				minLevel		= 30,
			},
			[81327] = {										-- Brittle Bones
				class			= "DEATHKNIGHT",
				spec			= "Frost",
				amountPerTalentPoint = 2,
				amountType		= "%",
				maxTalentPoints	= 2,
				requiredTalent	= 81327,					-- Brittle Bones
				minLevel		= 20,
			},
			[55749] = {										-- Acid Spit
				class			= "HUNTER",
				spec			= "Beast Mastery",
				pet				= L["Worm"],
				amount			= 4,
				amountType		= "%",
				minLevel		= 40,
			},
			[50518] = {										-- Ravage
				class			= "HUNTER",
				pet				= L["Ravager"],
				amount			= 4,
				amountType		= "%",
				minLevel		= 40,
			},
		},
	},
	[L["Spell Critical Strike Chance"]] = {
		icon = select(3, GetSpellInfo(11095)),
		interested = "caster",
		spells = {
			[11095] = {										-- Critical Mass
				class			= "MAGE",					-- TODO Check Debuff Name
				spec			= "Fire",
				amount			= 5,
				amountType		= "%",
				requiredTalent	= 11095,					-- Critical Mass
				minLevel		= 25,
			},
			[17799] = {										-- Shadow Mastery
				--alternate		= 17793,					-- Shadow and Flame
				class			= "WARLOCK",				-- TODO Check Debuff Name
				spec			= "Destruction",
				amount			= 5,
				amountType		= "%",
				requiredTalent	= 17793,					-- Shadow and Flame
				minLevel		= 10,
			},
		},
	},
	[L["Spell Damage Taken"]] = {
		icon = select(3, GetSpellInfo(65142)),
		interested = "caster",
		spells = {
			[93068] = {										-- Master Poisoner
				class			= "ROGUE",
				spec			= "Assassination",
				amount			= 8,
				amountType		= "%",
				requiredTalent	= 58410,					-- Master Poisoner
				minLevel		= 30,
			},
			[1490] = {										-- Curse of the Elements
				class			= "WARLOCK",
				spec			= "Affliction",
				amount			= 8,
				amountType		= "%",
				exclusive		= "curse",
				minLevel		= 52,
			},
			[48506] = {										-- Earth and Moon
				class			= "DRUID",
				spec			= "Balance",
				amount			= 8,
				amountType		= "%",
				requiredTalent	= 48506,					-- Earth and Moon
				minLevel		= 30,
			},
			[65142] = {										-- Ebon Plague
				class			= "DEATHKNIGHT",
				spec			= "Unholy",
				amount			= 8,
				amountType		= "%",
				requiredTalent	= 51099,					-- Ebon Plaguebringer
				minLevel		= 55,
			},
			[34889] = {										-- Fire Breath
				class			= "HUNTER",
				pet				= L["Dragonhawk"],
				amount			= 8,
				amountType		= "%",
				minLevel		= 20,
			},
			[24844] = {										-- Fire Breath
				class			= "HUNTER",
				pet				= L["Wind Serpent"],
				amount			= 8,
				amountType		= "%",
				minLevel		= 20,
			},
		},
	},
}

-- Buffs we want to enhance the tooltips for, but are not showing them in the icon grid
Utopia.otherBuffs = {
	[7294] = {exclusive = "aura"},				-- Retribution Aura
	[19746] = {exclusive = "aura"},				-- Concentration Aura
	--[32223] = {exclusive = "aura"},				-- Crusader Aura (leave this one out, on purpose)
}

-- Mapping spells. These don't actually appear on the target, but are
-- 'hidden' auras that we have to infer, often given as an additional
-- effect to a spell.  (With the exception of Wound Poison which is a
-- straight mapping to cope with the varying names)

do
	Utopia.mapping = {}
--[[
	local paladinAuraList = {
		[GetSpellInfo(465)] = true,			-- Devotion Aura
		[GetSpellInfo(7294)] = true,		-- Retribution Aura
		[GetSpellInfo(19746)] = true,		-- Concentration Aura
		[GetSpellInfo(19891)] = true,		-- Resistance Aura
		[GetSpellInfo(32223)] = true,		-- Crusader Aura
	}
	Utopia.mapping = {
		[GetSpellInfo(13218)] = {					-- Wound Poison (unranked name)
			class = "ROGUE",
			type = "map",
			list = {
				[GetSpellInfo(13225)] = true,		-- Wound Poison II
				[GetSpellInfo(13226)] = true,		-- Wound Poison III
				[GetSpellInfo(13227)] = true,		-- Wound Poison IV
				[GetSpellInfo(27188)] = true,		-- Wound Poison V
				[GetSpellInfo(57977)] = true,		-- Wound Poison VI
				[GetSpellInfo(57978)] = true,		-- Wound Poison VII
			},
		},

		[GetSpellInfo(2818)] = {					-- Deadly Poison (unranked name)
			class = "ROGUE",						-- Mapping for Master Poisoner to work
			type = "map",
			list = {
				[GetSpellInfo(2819)] = true,		-- Deadly Poison II
				[GetSpellInfo(11353)] = true,		-- Deadly Poison III
				[GetSpellInfo(11354)] = true,		-- Deadly Poison IV
				[GetSpellInfo(25349)] = true,		-- Deadly Poison V
				[GetSpellInfo(26968)] = true,		-- Deadly Poison VI
				[GetSpellInfo(27187)] = true,		-- Deadly Poison VII
				[GetSpellInfo(57969)] = true,		-- Deadly Poison VIII
				[GetSpellInfo(57970)] = true,		-- Deadly Poison IX
			},
		},

		[GetSpellInfo(58410)] = {					-- Master Poisoner
			class = "ROGUE",
			requiredTalent = GetSpellInfo(58410),	-- Master Poisoner
			type = "trigger",
			list = {
				[GetSpellInfo(3408)] = true,		-- Crippling Poison
				[GetSpellInfo(41190)] = true,		-- Mind-numbing Poison
				[GetSpellInfo(13218)] = true,		-- Wound Poison
				[GetSpellInfo(2818)] = true,		-- Deadly Poison
			},
		},

		[GetSpellInfo(53696)] = {					-- Judgements of the Just
			class = "PALADIN",
			requiredTalent = GetSpellInfo(53696),	-- Judgements of the Just
			type = "trigger",
			list = {
				[GetSpellInfo(53408)] = true,		-- Judgement of Wisdom
				[GetSpellInfo(20271)] = true,		-- Judgement of Light
				[GetSpellInfo(53407)] = true,		-- Judgement of Justice
			},
		},

		[GetSpellInfo(20140)] = {					-- Improved Devotion Aura
			class = "PALADIN",
			requiredTalent = GetSpellInfo(20140),	-- Improved Devotion Aura
			type = "trigger",
			list = paladinAuraList,
		},

		[GetSpellInfo(53648)] = {					-- Swift Retribution
			class = "PALADIN",
			requiredTalent = GetSpellInfo(53648),	-- Swift Retribution
			type = "trigger",
			list = paladinAuraList,
		},

		[GetSpellInfo(31869)] = {					-- Sanctified Retribution
			class = "PALADIN",
			requiredTalent = GetSpellInfo(31869),	-- Sanctified Retribution
			type = "trigger",
			list = paladinAuraList,
		},

		[GetSpellInfo(33602)] = {					-- Improved Faerie Fire
			class = "DRUID",
			requiredTalent = GetSpellInfo(33602),	-- Improved Faerie Fire
			type = "trigger",
			list = {
				[GetSpellInfo(770)] = true,			-- Faerie Fire
				[GetSpellInfo(16857)] = true,		-- Faerie Fire (Feral)
			},
		},

		[GetSpellInfo(48396)] = {					-- Improved Moonkin Form
			class = "DRUID",
			requiredTalent = GetSpellInfo(48396),	-- Moonkin Aura
			list = {
				[GetSpellInfo(24907)] = true,		-- Moonkin Aura
			}
		},

		[GetSpellInfo(33917)] = {
			class = "DRUID",
			requiredTalent = GetSpellInfo(33917),
			type = "trigger",
			list = {
				[GetSpellInfo(48564)] = true,		-- Mangle - Bear
				[GetSpellInfo(48566)] = true,		-- Mangle - Cat
			},
		},
	}
]]
end

--[===[@debug@
for Type,data in pairs(Utopia.debuffs) do
	assert(type(Type) == "string")
	assert(data.spells)
	for spellID,info in pairs(data.spells) do
		assert(info.class)
		assert(type(spellID) == "number")
		if (info.amount) then
			assert(type(info.amount) == "number")
		elseif (info.amountsPerStack) then
			assert(info.rankLevels)
			assert(#info.amountsPerStack == #info.rankLevels)
		elseif (info.amounts) then
			assert(type(info.amounts) == "table")
			assert(info.rankLevels)
			assert(#info.amounts == #info.rankLevels)
		end
		if (info.rankIDs) then
			if (info.amounts) then
				assert(#info.rankIDs == #info.amounts)
			end
			if (info.rankLevels) then
				assert(#info.rankIDs == #info.rankLevels)
			end
			local spellName = GetSpellInfo(spellID)
			local n = GetSpellInfo(info.rankIDs[1])
			for i,id in ipairs(info.rankIDs) do
				if (GetSpellInfo(id) ~= spellName) then
					error(format("Utopia: [%q].rankIDs[%d] (%d) ~= %q", spellName, i, id, n))
				end
			end
			if (info.rankIDsAlternate) then
				assert(type(info.alternateOffset) == "number")
				assert(#info.rankIDsAlternate == #info.rankIDs + info.alternateOffset)
				n = GetSpellInfo(info.rankIDsAlternate[1])
				for i,id in ipairs(info.rankIDs) do
					if (GetSpellInfo(id) ~= n) then
						error(format("[%q].rankIDsAlternate[%d] (%d) ~= %q", spellName, i, id, n))
					end
				end
			end
		end
	end
end

if (Utopia.mapping) then
	for name,data in pairs(Utopia.mapping) do
		assert(data.class)
		assert(data.list)
		for spellName,True in pairs(data.list) do
			assert(type(spellName) == "string")
			assert(True)
		end
	end
end

-- ValidateAgainstClassData
-- Checks maxTalentPoints values read from actual live talents by LGT against maxTalentPoints we have specified in our data

local LGT = LibStub("LibGroupTalents-1.0")

local function validateSub(mode, class)
	for cat,info in pairs(Utopia[mode]) do
		for id,spellInfo in pairs(info.spells) do
			if (spellInfo.class == class and LGT.classTalentData[spellInfo.class]) then
				if (spellInfo.maxTalentPoints) then
					local maxRank = LGT:GetClassTalentInfo(spellInfo.class, spellInfo.requiredTalent or spellInfo.improved)
					if (maxRank) then
						if (maxRank ~= spellInfo.maxTalentPoints) then
							error(format("Utopia.%s[%q].spells[%q].maxTalentPoints = %d. Live data = %d", mode, cat, GetSpellInfo(spellInfo.requiredTalent or spellInfo.improved) or "nil", spellInfo.maxTalentPoints, maxRank))
						end
					else
						error(format("Did not find talent called %s in %s data", GetSpellInfo(spellInfo.requiredTalent or spellInfo.improved) or "nil", spellInfo.class))
					end
				end
			end
		end
	end
end

function Utopia:ValidateAgainstClassData(class)
	validateSub("buffs", class)
	validateSub("debuffs", class)
end
--@end-debug@]===]
