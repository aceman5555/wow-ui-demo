-- Load Libraries
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

-- Defense Stats
local Dodge_Frame = ldb:NewDataObject("SN - Dodge", {type = "data source", label = "Dodge", text = "", icon = "Interface\\Icons\\spell_shadow_shadowward"})
local Parry_Frame = ldb:NewDataObject("SN - Parry", {type = "data source", label = "Parry", text = "", icon = "Interface\\Icons\\Ability_Parry"})
local Block_Frame = ldb:NewDataObject("SN - Block", {type = "data source", label = "Block", text = "", icon = "Interface\\Icons\\Ability_Defend"})
local Armor_Defense_Frame = ldb:NewDataObject("SN - Armor", {type = "data source", label = "Armor", text = "", icon = "Interface\\Icons\\Spell_DeathKnight_BladedArmor"})
local Defense_Mastery_Frame = ldb:NewDataObject("SN - Defense Mastery", {type = "data source", label = "Mastery", text = "", icon = "Interface\\Icons\\ability_warrior_safeguard"})
local Vengeance_Frame = ldb:NewDataObject("SN - Vengeance", {type = "data source", label = "Vengeance", text = "", icon = "Interface\\Icons\\spell_shadow_charm"})

-- Defense Frames
local Dodge = CreateFrame("frame")
local Parry = CreateFrame("frame")
local Block = CreateFrame("frame")
local Armor_Defense = CreateFrame("frame")
local Defense_Mastery = CreateFrame("frame")
local Vengeance = CreateFrame("frame")
local tooltip = CreateFrame("GameTooltip", "SN_Defence_Tooltip", UIParent, "GameTooltipTemplate")
tooltip:SetOwner(UIParent, "ANCHOR_NONE")

-- Data Input
Dodge:SetScript("OnUpdate", function(self, elap)
	local Total_Dodge = GetDodgeChance()
	Dodge_Frame.text = string.format("%.2f%%", Total_Dodge)
end)

Parry:SetScript("OnUpdate", function(self, elap)
	local Total_Parry = GetParryChance()
	Parry_Frame.text = string.format("%.2f%%", Total_Parry)
end)

Block:SetScript("OnUpdate", function(self, elap)
	local Total_Block = GetBlockChance()
	Block_Frame.text = string.format("%.2f%%", Total_Block)
end)

Armor_Defense:SetScript("OnUpdate", function(self, elap)
	local base, effectiveArmor, armor, posBuff, negBuff = UnitArmor("player")
	local Melee_Reduction = effectiveArmor
	Armor_Defense_Frame.text = Melee_Reduction
end)

Defense_Mastery:SetScript("OnUpdate", function(self, elap)
	local Total_DM = GetMasteryEffect("player")
	Defense_Mastery_Frame.text = string.format("%.2f%%", Total_DM)
end)

local function getTooltipText(...)
	local text = ""
	for i=1,select("#",...) do
		local rgn = select(i,...)
		if rgn and rgn:GetObjectType() == "FontString" then
			text = text .. (rgn:GetText() or "")
		end
	end
	return text
end

Vengeance:SetScript("OnUpdate", function(self, elap)
	local shield = UnitAura("player", "Vengeance")
	if shield then
		tooltip:ClearLines()
		tooltip:SetUnitBuff("player", shield)
		local text = getTooltipText(tooltip:GetRegions())
		local value = tonumber(string.match(text,"%d+"))
		Vengeance_Frame.text = value
		else
		Vengeance_Frame.text = 0
	end
end)