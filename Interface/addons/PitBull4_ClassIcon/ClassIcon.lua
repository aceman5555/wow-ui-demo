if select(6, GetAddOnInfo("PitBull4_" .. (debugstack():match("[o%.][d%.][u%.]les\\(.-)\\") or ""))) ~= "MISSING" then return end

local CLASS_TEX_COORDS = CLASS_ICON_TCOORDS

local PitBull4 = _G.PitBull4
if not PitBull4 then
	error("PitBull4_ClassIcon requires PitBull4")
end

local L = PitBull4.L

local PitBull4_ClassIcon = PitBull4:NewModule("ClassIcon", "AceEvent-3.0")

PitBull4_ClassIcon:SetModuleType("indicator")
PitBull4_ClassIcon:SetName(L["Class icon"])
PitBull4_ClassIcon:SetDescription(L["Shows an class icon on the unit frame."])
PitBull4_ClassIcon:SetDefaults({
	attach_to = "root",
	location = "edge_bottom_left",
	position = 1,
})

function PitBull4_ClassIcon:GetTexture(frame)
	if UnitClass(frame.unit) then
		return [[Interface\Glues\CharacterCreate\UI-CharacterCreate-Classes]]
	end
	return nil
end

function PitBull4_ClassIcon:GetExampleTexture(frame)
	return [[Interface\Glues\CharacterCreate\UI-CharacterCreate-Classes]]
end

function PitBull4_ClassIcon:GetTexCoord(frame, texture)
	local _, class = UnitClass(frame.unit)
	if class then
		local ctc = CLASS_TEX_COORDS[class]
		return unpack(ctc)
	end
end

function PitBull4_ClassIcon:GetExampleTexCoord(frame, texture)
	local unit = frame.unit
	local SEED_CLASS = {
		"WARRIOR",
		"MAGE",
		"PALADIN",
		"ROGUE",
		"DRUID",
		"HUNTER",
		"SHAMAN",
		"PRIEST",
		"WARLOCK",
		"DEATHKNIGHT",
		"MONK",
	}
	local seed
	if unit == "pet" or unit:match("^raidpet(%d%d?)$") or unit:match("^partypet(%d)$") then
		seed = random(4) -- pets can be Warriors, Mages, Paladins and Rogues (DK's Ghouls)
	else
		seed = random(10) -- others can be anything
	end
	local seed_table = CLASS_TEX_COORDS[SEED_CLASS[seed]]
	return unpack(seed_table)
end
