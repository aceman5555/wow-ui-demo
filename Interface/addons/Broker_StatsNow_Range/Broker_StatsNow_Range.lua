-- Load Libraries
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

-- Range Stats
local Range_Armor_Pen_Frame = ldb:NewDataObject("SN - Ranged Armor Penetration", {type = "data source", label = "Armor Penetration", text = "", icon = "Interface\\Icons\\Ability_Hunter_PiercingShots"})
local Range_AP_Frame = ldb:NewDataObject("SN - Ranged Attack Power", {type = "data source", label = "RAP", text = "", icon = "Interface\\Icons\\Ability_Hunter_MasterMarksman"})
local Range_Crit_Frame = ldb:NewDataObject("SN - Ranged Crit", {type = "data source", label = "Crit", text = "", icon = "Interface\\Icons\\Ability_Hunter_Assassinate2"})
local Range_Hit_Frame = ldb:NewDataObject("SN - Ranged Hit", {type = "data source", label = "Hit", text = "", icon = "Interface\\Icons\\Spell_ChargePositive"})
local Range_Haste_Frame = ldb:NewDataObject("SN - Ranged Haste", {type = "data source", label = "Haste", text = "", icon = "Interface\\Icons\\ability_warrior_innerrage"})
local Range_Speed_Frame = ldb:NewDataObject("SN - Ranged Speed", {type = "data source", label = "Ranged Speed", text = "", icon = "Interface\\Icons\\inv_weapon_bow_08"})
local Range_Mastery_Frame = ldb:NewDataObject("SN - Ranged Mastery", {type = "data source", label = "Mastery", text = "", icon = "Interface\\Icons\\inv_misc_cat_trinket01"})

-- Range Frames
local Range_Armor_Pen = CreateFrame("frame")
local Range_AP = CreateFrame("frame")
local Range_Crit = CreateFrame("frame")
local Range_Hit = CreateFrame("frame")
local Range_Haste = CreateFrame("frame")
local Range_Speed = CreateFrame("frame")
local Range_Mastery = CreateFrame("frame")

-- Data Input
Range_Haste:SetScript("OnUpdate", function(self, elap)
	local Total_Range_Haste = GetRangedHaste("player")
	Range_Haste_Frame.text = string.format("%.2f%%", Total_Range_Haste)
end)

Range_Hit:SetScript("OnUpdate", function(self, elap)
	local Total_Range_Hit = GetCombatRatingBonus("7")
	Range_Hit_Frame.text = string.format("%.2f%%", Total_Range_Hit)
end)

Range_Armor_Pen:SetScript("OnUpdate", function(self, elap)
	local Range_Armor_Pen = GetCombatRatingBonus("25")
	Range_Armor_Pen_Frame.text = string.format("%.2f%%", Range_Armor_Pen)
end)

Range_AP:SetScript("OnUpdate", function(self, elap)
	local base, posBuff, negBuff = UnitRangedAttackPower("player")
	local Range_AP = base + posBuff + negBuff
	Range_AP_Frame.text = Range_AP
end)

Range_Crit:SetScript("OnUpdate", function(self, elap)
	local Range_Crit = GetRangedCritChance("25")
	Range_Crit_Frame.text = string.format("%.2f%%", Range_Crit)
end)

Range_Speed:SetScript("OnUpdate", function(self, elap)
	local speed = UnitRangedDamage("player")
	local Total_Range_Speed = speed
	Range_Speed_Frame.text = string.format("%.2f", Total_Range_Speed)
end)

Range_Mastery:SetScript("OnUpdate", function(self, elap)
	local Total_RM = GetMasteryEffect("player")
	Range_Mastery_Frame.text = string.format("%.2f%%", Total_RM)
end)