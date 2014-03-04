-- Load Libraries
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

-- Melee/Range Stats
local Melee_AP_Frame = ldb:NewDataObject("SN - Melee Attack Power", {type = "data source", label = "AP", text = "", icon = "Interface\\Icons\\Ability_MeleeDamage"})
local Melee_Crit_Frame = ldb:NewDataObject("SN - Melee Crit", {type = "data source", label = "Crit", text = "", icon = "Interface\\Icons\\ability_criticalstrike"})
local Expertise_Frame = ldb:NewDataObject("SN - Expertise", {type = "data source", label = "Expertise", text = "", icon = "Interface\\Icons\\Ability_Warrior_Challange"})
local Melee_Armor_Pen_Frame = ldb:NewDataObject("SN - Melee Armor Penetration", {type = "data source", label = "Armor Penetration", text = "", icon = "Interface\\Icons\\ability_warrior_riposte"})
local Melee_Hit_Frame = ldb:NewDataObject("SN - Melee Hit", {type = "data source", label = "Hit", text = "", icon = "Interface\\Icons\\Spell_ChargePositive"})
local Melee_Haste_Frame = ldb:NewDataObject("SN - Melee Haste", {type = "data source", label = "Haste", text = "", icon = "Interface\\Icons\\Ability_Rogue_SliceDice"})
local Weapon_Speed_Frame = ldb:NewDataObject("SN - Weapon Speed", {type = "data source", label = "Weapon Speed", text = "", icon = "Interface\\Icons\\spell_nature_unrelentingstorm"})
local Melee_Mastery_Frame = ldb:NewDataObject("SN - Melee Mastery", {type = "data source", label = "Mastery", text = "", icon = "Interface\\Icons\\inv_axe_1h_cataclysm_c_01"})

-- Melee Frames
local Melee_AP = CreateFrame("frame")
local Melee_Crit = CreateFrame("frame")
local Expertise = CreateFrame("frame")
local Melee_Armor_Pen = CreateFrame("frame")
local Melee_Hit = CreateFrame("frame")
local Melee_Haste = CreateFrame("frame")
local Weapon_Speed = CreateFrame("frame")
local Melee_Mastery = CreateFrame("frame")

-- Data Input
Melee_Haste:SetScript("OnUpdate", function(self, elap)
	local Total_Melee_Haste = GetMeleeHaste("player")
	Melee_Haste_Frame.text = string.format("%.2f%%", Total_Melee_Haste)
end)

Melee_Hit:SetScript("OnUpdate", function(self, elap)
	local Total_Hit = GetCombatRatingBonus("6")
	Melee_Hit_Frame.text = string.format("%.2f%%", Total_Hit)
end)

Melee_AP:SetScript("OnUpdate", function(self, elap)
	local base, posBuff, negBuff = UnitAttackPower("player")
	local Melee_AP = base + posBuff + negBuff
	Melee_AP_Frame.text = Melee_AP
end)

Melee_Crit:SetScript("OnUpdate", function(self, elap)
	local Melee_Crit = GetCritChance("player")
	Melee_Crit_Frame.text = string.format("%.2f%%", Melee_Crit)
end)

Expertise:SetScript("OnUpdate", function(self, elap)
	local Expertise = GetCombatRatingBonus("24")
	Expertise_Frame.text = string.format("%.2f%%", Expertise)
end)

Melee_Armor_Pen:SetScript("OnUpdate", function(self, elap)
	local Melee_Armor_Pen = GetCombatRatingBonus("25")
	Melee_Armor_Pen_Frame.text = string.format("%.2f%%", Melee_Armor_Pen)
end)

Weapon_Speed:SetScript("OnUpdate", function(self, elap)
	local mainSpeed, offSpeed = UnitAttackSpeed("player");
	local MH = mainSpeed
	local OH = offSpeed
	Weapon_Speed_Frame.text = string.format("%.2f", MH)
end)

Melee_Mastery:SetScript("OnUpdate", function(self, elap)
	local Total_MM = GetMasteryEffect("player");
	Melee_Mastery_Frame.text = string.format("%.2f%%", Total_MM)
end)