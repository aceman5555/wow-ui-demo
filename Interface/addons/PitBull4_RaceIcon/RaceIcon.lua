if select(6, GetAddOnInfo("PitBull4_" .. (debugstack():match("[o%.][d%.][u%.]les\\(.-)\\") or ""))) ~= "MISSING" then return end

local gl=GetLocale()
local lT = {}
if gl == "deDE" then
	lT={["Wildtier"]="Beast",["Tier"]="Critter",["Dämon"]="Demon",["Drachkin"]="Dragonkin",["Elementar"]="Elemental",["Riese"]="Giant",["Humanoid"]="Humanoid",["Mechanisch"]="Mechanical",["Untoter"]="Undead",["Totem"]="Totem",["Haustier"]="Non-combat Pet",["Nicht spezifiziert"]="Not specified",["Gaswolke"]="Gas Cloud",}
elseif gl == "frFR" then
	lT={["Bête"]="Beast",["Bestiole"]="Critter",["Démon"]="Demon",["Draconien"]="Dragonkin",["Elémentaire"]="Elemental",["Géant"]="Giant",["Humanoïde"]="Humanoid",["Mécanique"]="Mechanical",["Mort-vivant"]="Undead",["Totem"]="Totem",["Familier pacifique"]="Non-combat Pet",["Non spécifié"]="Not specified",["Nuage de gaz"]="Gas Cloud",}
elseif gl == "koKR" then
	lT={["야수"]="Beast",["작은 동물"]="Critter",["악마"]="Demon",["용족"]="Dragonkin",["정령"]="Elemental",["거인"]="Giant",["인간"]="Humanoid",["기계"]="Mechanical",["언데드"]="Undead",["koKR:TOTEM"]="Totem",["koKR:NON-COMBAT_PET"]="Non-combat Pet",["koKR:NOT_SPECIFIED"]="Not specified",["koKR:GAS_CLOUD"]="Gas Cloud",}
elseif gl == "esES" then
	lT={["Bestia"]="Beast",["Alimaña"]="Critter",["Demonio"]="Demon",["Dragonante"]="Dragonkin",["Elemental"]="Elemental",["Gigante"]="Giant",["Humanoide"]="Humanoid",["Mecánico"]="Mechanical",["No-muerto"]="Undead",["Tótem"]="Totem",["Mascota mansa"]="Non-combat Pet",["Sin especificar"]="Not specified",["Nube de gas"]="Gas Cloud",}
elseif gl == "esMX" then
	lT={["Bestia"]="Beast",["Alma"]="Critter",["Demonio"]="Demon",["Dragon"]="Dragonkin",["Elemental"]="Elemental",["Gigante"]="Giant",["Humanoide"]="Humanoid",["Mecánico"]="Mechanical",["No-muerto"]="Undead",["esMX:TOTEM"]="Totem",["esMX:NON-COMBAT_PET"]="Non-combat Pet",["esMX:NOT_SPECIFIED"]="Not specified",["esMX:GAS_CLOUD"]="Gas Cloud",}
elseif gl == "ruRU" then
	lT={["Животное"]="Beast",["Существо"]="Critter",["Демон"]="Demon",["Дракон"]="Dragonkin",["Элементаль"]="Elemental",["Великан"]="Giant",["Гуманоид"]="Humanoid",["Механизм"]="Mechanical",["Нежить"]="Undead",["Тотем"]="Totem",["Спутник"]="Non-combat Pet",["Не указано"]="Not specified",["Облако газа"]="Gas Cloud",}
elseif gl == "zhCN" then
	lT={["野兽"]="Beast",["小动物"]="Critter",["恶魔"]="Demon",["龙类"]="Dragonkin",["元素生物"]="Elemental",["巨人"]="Giant",["人型生物"]="Humanoid",["机械"]="Mechanical",["亡灵"]="Undead",["图腾"]="Totem",["小伙伴"]="Non-combat Pet",["未指定"]="Not specified",["气体云雾"]="Gas Cloud",}
elseif gl == "zhTW" then
	lT={["野獸"]="Beast",["小動物"]="Critter",["惡魔"]="Demon",["龍類"]="Dragonkin",["元素生物"]="Elemental",["巨人"]="Giant",["人型生物"]="Humanoid",["機械"]="Mechanical",["不死族"]="Undead",["圖騰"]="Totem",["非戰鬥寵物"]="Non-combat Pet",["未指定"]="Not specified",["氣體雲"]="Gas Cloud",}
else   -- enUS enGB enCN enTW
	lT={["Beast"]="Beast",["Critter"]="Critter",["Demon"]="Demon",["Dragonkin"]="Dragonkin",["Elemental"]="Elemental",["Giant"]="Giant",["Humanoid"]="Humanoid",["Mechanical"]="Mechanical",["Undead"]="Undead",["Totem"]="Totem",["Non-combat Pet"]="Non-combat Pet",["Not specified"]="Not specified",["Gas Cloud"]="Gas Cloud",}
end

local RACE_TEX_COORDS = {
	["Human_2"]     = {0, 0.125, 0, 0.25},
	["Dwarf_2"]     = {0.125, 0.25, 0, 0.25},
	["Gnome_2"]     = {0.25, 0.375, 0, 0.25},
	["NightElf_2"]  = {0.375, 0.5, 0, 0.25},
	["Draenei_2"]   = {0.5, 0.625, 0, 0.25},
	["Tauren_2"]    = {0, 0.125, 0.25, 0.5},
	["Scourge_2"]   = {0.125, 0.25, 0.25, 0.5},
	["Troll_2"]     = {0.25, 0.375, 0.25, 0.5},
	["Orc_2"]       = {0.375, 0.5, 0.25, 0.5},
	["BloodElf_2"]  = {0.5, 0.625, 0.25, 0.5},
	["Human_3"]     = {0, 0.125, 0.5, 0.75},
	["Dwarf_3"]     = {0.125, 0.25, 0.5, 0.75},
	["Gnome_3"]     = {0.25, 0.375, 0.5, 0.75},
	["NightElf_3"]  = {0.375, 0.5, 0.5, 0.75},
	["Draenei_3"]   = {0.5, 0.625, 0.5, 0.75},
	["Tauren_3"]    = {0, 0.125, 0.75, 1},
	["Scourge_3"]   = {0.125, 0.25, 0.75, 1},
	["Troll_3"]     = {0.25, 0.375, 0.75, 1},
	["Orc_3"]       = {0.375, 0.5, 0.75, 1},
	["BloodElf_3"]  = {0.5, 0.625, 0.75, 1},
	["Worgen_2"]	= {0.625, 0.75, 0, 0.25},
	["Goblin_2"]	= {0.625, 0.75, 0.25, 0.5},
	["Worgen_3"]	= {0.625, 0.75, 0.5, 0.75},
	["Goblin_3"]	= {0.625, 0.75, 0.75, 1},
	["Pandaren_2"] = {0.750, 0.875, 0, 0.25},
	["Pandaren_3"]= {0.750, 0.875, 0.5, 0.75},
}

local CREATURE_ICONS = {
    ["Beast"]          = "Interface\\ICONS\\Ability_Tracking",
    ["Dragonkin"]      = "Interface\\ICONS\\INV_Misc_Head_Dragon_01",
    ["Demon"]          = "Interface\\ICONS\\Spell_Shadow_SummonFelHunter",
    ["Elemental"]      = "Interface\\ICONS\\Spell_Frost_SummonWaterElemental",
    ["Giant"]          = "Interface\\ICONS\\Ability_Racial_Avatar",
    ["Undead"]         = "Interface\\ICONS\\Spell_Shadow_DarkSummoning",
    ["Humanoid"]       = "Interface\\ICONS\\Spell_Holy_PrayerOfHealing",
    ["Critter"]        = "Interface\\ICONS\\ABILITY_SEAL",
    ["Mechanical"]     = "Interface\\ICONS\\INV_Misc_Gear_01",
--    ["Not specified"]  = "Interface\\ICONS\\INV_Misc_QuestionMark",
    ["Totem"]          = "Interface\\Icons\\Spell_Totem_WardOfDraining",
    ["Non-combat Pet"] = "Interface\\Icons\\INV_Gizmo_GoblingTonkController",
    ["Gas Cloud"]      = "Interface\\Icons\\Spell_Nature_StormReach",
}

local PitBull4 = _G.PitBull4
if not PitBull4 then
	error("PitBull4_RaceIcon requires PitBull4")
end

local L = PitBull4.L

local PitBull4_RaceIcon = PitBull4:NewModule("RaceIcon", "AceEvent-3.0")

PitBull4_RaceIcon:SetModuleType("indicator")
PitBull4_RaceIcon:SetName(L["Race icon"])
PitBull4_RaceIcon:SetDescription(L["Shows an race or creature type icon on the unit frame."])
PitBull4_RaceIcon:SetDefaults({
	attach_to = "root",
	location = "edge_bottom_left",
	position = 1,
})

function PitBull4_RaceIcon:GetTexture(frame)
	local _, race = UnitRace(frame.unit)
	if race then
		return [[Interface\Glues\CharacterCreate\UI-CharacterCreate-Races]]
	else
		local ct = UnitCreatureType(frame.unit)
		if ct then
			return CREATURE_ICONS[lT[ct]]
		end
	end
	return nil
end

function PitBull4_RaceIcon:GetExampleTexture(frame)
	local unit = frame.unit
	if unit == "player" or unit:match("^raid(%d%d?)$") or unit:match("^party(%d)$") then
		return [[Interface\Glues\CharacterCreate\UI-CharacterCreate-Races]]
	else
		local SEED_CREATURE = {
			"Beast",
			"Demon",
			"Undead",
			"Mechanical",
			"Dragonkin",
			"Giant",
			"Elemental",
			"Humanoid",
			"Critter",
			"Totem",
			"Non-combat Pet",
			"Gas Cloud",
		}
		local seed
		if unit == "pet" or unit:match("^raidpet(%d%d?)$") or unit:match("^partypet(%d)$") then
			seed = random(7) -- pets can be Beasts, Demons and Undeads; I suppose vehicles can not be Critters, Totems, Non-combat Pets and Gas Clouds
		else
			seed = random(12)
		end
		return CREATURE_ICONS[SEED_CREATURE[seed]]
	end
end

function PitBull4_RaceIcon:GetTexCoord(frame, texture)
	local _, race = UnitRace(frame.unit)
	if race then
		local race_sex = RACE_TEX_COORDS[race .. "_" .. UnitSex(frame.unit)]
		return race_sex[1], race_sex[2], race_sex[3], race_sex[4]
	elseif UnitCreatureType(frame.unit) then
		return 0, 1, 0, 1
	end
end

function PitBull4_RaceIcon:GetExampleTexCoord(frame, texture)
	if texture == [[Interface\Glues\CharacterCreate\UI-CharacterCreate-Races]] then
		local SEED_RACE = {
			"Human",
			"Dwarf",
			"Gnome",
			"NightElf",
			"Draenei",
			"Tauren",
			"Scourge",
			"Troll",
			"Orc",
			"BloodElf",
			"Worgen",
			"Goblin",
			"Pandaren",
		}
		local race_sex_seed = RACE_TEX_COORDS[SEED_RACE[random(12)] .. "_" .. random(2,3)]
		return unpack(race_sex_seed)
	else
		return 0, 1, 0, 1
	end
end
