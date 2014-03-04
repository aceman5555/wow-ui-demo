-- Load Libraries
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

-- PvP Stats
local Dmg_Reduction_Frame = ldb:NewDataObject("SN - Dmg Reduction", {type = "data source", label = "Dmg Reduction", text = "", icon = "Interface\\Icons\\Spell_holy_greaterblessingofsanctuary"})
local Total_Resilience_Frame = ldb:NewDataObject("SN - PvP Resilience", {type = "data source", label = "PvP Resilience", text = "", icon = "Interface\\Icons\\achievement_bg_kill_flag_carrier"})
local Total_PvPPower_Frame = ldb:NewDataObject("SN - PvP Power", {type = "data source", label = "PvP Power", text = "", icon = "Interface\\Icons\\Ability_rogue_shadowstrikes"})

-- PvP Frames
local Dmg_Reduction = CreateFrame("frame")
local Total_Resilience = CreateFrame("frame")
local Total_PvPPower = CreateFrame("frame")

-- Data Input
Dmg_Reduction:SetScript("OnUpdate", function(self, elap)
	local PvPDmg = GetCombatRatingBonus("16") + 72
	Dmg_Reduction_Frame.text = string.format("-%.2f%%", PvPDmg)
end)

Total_Resilience:SetScript("OnUpdate", function(self, elap)
	local Total_Resil = GetCombatRating("16")
	Total_Resilience_Frame.text = Total_Resil
end)

Total_PvPPower:SetScript("OnUpdate", function(self, elap)
	local PvPPower = GetCombatRatingBonus("27")
	Total_PvPPower_Frame.text = string.format("%.2f%%", PvPPower)
end)