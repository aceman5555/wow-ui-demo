-- Load Libraries
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

-- Spell Power Stats
local Spell_Power_Frame = ldb:NewDataObject("SN - Spell Power", {type = "data source", label = "Spell Power", text = "", icon = "Interface\\Icons\\Spell_shaman_spectraltransformation"})
local Spell_Crit_Frame = ldb:NewDataObject("SN - Spell Crit", {type = "data source", label = "Spell Crit", text = "", icon = "Interface\\Icons\\spell_arcane_invocation"})
local Spell_Hit_Frame = ldb:NewDataObject("SN - Spell Hit", {type = "data source", label = "Spell Hit", text = "", icon = "Interface\\Icons\\Spell_ChargePositive"})
local Spell_Haste_Frame = ldb:NewDataObject("SN - Spell Haste", {type = "data source", label = "Spell Haste", text = "", icon = "Interface\\Icons\\spell_nature_astralrecalgroup"})
local MP5_Frame = ldb:NewDataObject("SN - MP5", {type = "data source", label = "MP5", text = "", icon = "Interface\\Icons\\Spell_Magic_ManaGain"})
local Spell_Mastery_Frame = ldb:NewDataObject("SN - Spell Mastery", {type = "data source", label = "Mastery", text = "", icon = "Interface\\Icons\\spell_mage_flameorb"})

-- Spell Power Frames
local Spell_Power = CreateFrame("frame")
local Spell_Crit = CreateFrame("frame")
local Spell_Hit = CreateFrame("frame")
local Spell_Haste = CreateFrame("frame")
local MP5 = CreateFrame("frame")
local Spell_Mastery = CreateFrame("frame")

-- Data Input
Spell_Power:SetScript("OnUpdate", function(self, elap)
	local SP = GetSpellBonusDamage("2")
	Spell_Power_Frame.text = SP
end)

Spell_Crit:SetScript("OnUpdate", function(self, elap)
	local SC = GetSpellCritChance("2")
	Spell_Crit_Frame.text = string.format("%.2f%%", SC)
end)

Spell_Haste:SetScript("OnUpdate", function(self, elap)
	local Total_Spell_Haste = UnitSpellHaste("player")
	Spell_Haste_Frame.text = string.format("%.2f%%", Total_Spell_Haste)
end)

Spell_Hit:SetScript("OnUpdate", function(self, elap)
	local Total_Spell_Hit = GetCombatRatingBonus("8")
	Spell_Hit_Frame.text = string.format("%.2f%%", Total_Spell_Hit)
end)

MP5:SetScript("OnUpdate", function(self, elap)
	local base, casting = GetManaRegen()
	local MP5_1 = (casting * 5)
	MP5_Frame.text = string.format("%.0f", MP5_1)
end)

Spell_Mastery:SetScript("OnUpdate", function(self, elap)
	local Total_SM = GetMasteryEffect("player")
	Spell_Mastery_Frame.text = string.format("%.2f%%", Total_SM)
end)