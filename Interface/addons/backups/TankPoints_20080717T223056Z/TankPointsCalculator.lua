--[[
Name: TankPoints Calculator
Description: Interactive Calculator for TankPoints
Revision: $Revision: 2 $
Developed by: Whitetooth@Cenarius (hotdogee@¤Ú«¢©i¯Sbaha)
]]

---------------
-- Libraries --
---------------
local StatLogic = AceLibrary("StatLogic-1.0")
local L = AceLibrary("AceLocale-2.2"):new("TankPoints")


--------------------
-- Initialization --
--------------------
TPCalc = {}
TPCalc.sourceDT = {}
TPCalc.resultsDT = {}
local TPCalc = TPCalc


---------------------
-- Local Variables --
---------------------
-- Localize Lua globals
local _G = getfenv(0)
local pairs = pairs
local ipairs = ipairs
local setmetatable = setmetatable
local getmetatable = getmetatable
local tinsert = tinsert
local tostring = tostring
local select = select


-------------------
-- General Tools --
-------------------
-- copyTable
local function copyTable(to, from)
	if to then
		for k in pairs(to) do
			to[k] = nil
		end
		setmetatable(to, nil)
	else
		to = {}
	end
	for k,v in pairs(from) do
		if type(k) == "table" then
			k = copyTable({}, k)
		end
		if type(v) == "table" then
			v = copyTable({}, v)
		end
		to[k] = v
	end
	setmetatable(to, getmetatable(from))
	return to
end

-------------------------------
-- TankPointsCalculatorFrame --
-------------------------------
function TankPointsCalculatorFrame_OnLoad()
	-- Esc closes the window
	tinsert(UISpecialFrames, this:GetName())
	
	-- Set title text
	TankPointsCalculatorFrame_HeaderText:SetText(L["TankPoints Calculator"])
	-- Set drag frame tooltip
	TankPointsCalculatorFrame_DragFrame.tooltip = L["Left click to drag\nRight click to reset position"]
	-- Set button text
	TankPointsCalculatorFrame_ResetButton:SetText(L["Reset"])
	TankPointsCalculatorFrame_CloseButton:SetText(L["Close"])
	-- Set option frame box title
	TPCResultsFrameTitle:SetText(L["Results"])
	TPCCombatTableFrameTitle:SetText(L["Combat Table"])
	TPCPlayerStatsFrameTitle:SetText(L["Player Stats"])
	TPCMobStatsFrameTitle:SetText(L["Mob Stats"])
	-- Set label text
	TPCalc:SetLabels()
	
	-- Set tooltips
	TPCMobStats2.tooltip = L["Mob Damage before DR"]
	
	-- Register events
	this:RegisterEvent("UNIT_LEVEL")
	this:RegisterEvent("UNIT_RESISTANCES")
	this:RegisterEvent("UNIT_STATS")
	this:RegisterEvent("UNIT_DEFENSE")
	this:RegisterEvent("UNIT_MAXHEALTH")
	this:RegisterEvent("UNIT_AURA")
	this:RegisterEvent("UNIT_INVENTORY_CHANGED")
end

function TankPointsCalculatorFrame_OnEvent(self, event, ...)
	--TankPoints:Print(tostring(self)..", "..event..", "..select(1, ...))
	-- Do nothing if Calculator frame is not visable
	if (not self:IsVisible()) then
		return
	end
	-- Do nothing if event target is not player
	if (not select(1, ...) == "player") then
		return
	end
	-- Update stuff
	TankPoints:Schedule("TPCalcUpdateResults", 0.01, TPCalc.UpdateResults, TPCalc)
end

function TankPointsCalculatorFrame_OnShow()
	TankPoints:Schedule("TPCalcUpdateResults", 0.01, TPCalc.UpdateResults, TPCalc)
end

-- VariableFrame
function TankPointsCalculatorVariables_IncrementButton_OnClick(self, button, down)
	--TankPoints:Print(tostring(self)..", "..tostring(button)..", "..tostring(this)..", "..tostring(down))
	local inputBox = _G[self:GetParent():GetName().."_InputEditBox"]
	inputBox:SetNumber(inputBox:GetNumber() + 1)
	inputBox:ClearFocus()
end

function TankPointsCalculatorVariables_DecrementButton_OnClick(self, button, down)
	local inputBox = _G[self:GetParent():GetName().."_InputEditBox"]
	inputBox:SetNumber(inputBox:GetNumber() - 1)
	inputBox:ClearFocus()
end

function TankPointsCalculatorVariables_InputEditBox_OnTextChanged()
	--TankPoints:Print(tostring(self)..", "..tostring(this))
	local self = this
	if (self:GetNumber() > 0) then
		self:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (self:GetNumber() < 0) then
		self:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		self:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	TPCalc:UpdateResults()
end

TPCalc.LabelText = {
	{-- TPCResults1
		L["TankPoints"],
		L["Total Reduction"]..L["(%)"],
	},
	{-- TPCCombatTable1
		MISS..L["(%)"],
		DODGE..L["(%)"],
		PARRY..L["(%)"],
		BLOCK..L["(%)"],
		L["Crit"]..L["(%)"],
		L["Crushing"]..L["(%)"],
		L["Hit"]..L["(%)"],
	},
	{-- TPCPlayerStats1
		SPELL_STAT1_NAME, -- "Strength"
		SPELL_STAT2_NAME, -- "Agility"
		SPELL_STAT3_NAME, -- "Stamina"
		L["Max Health"],
		"["..ARMOR.." - "..L["Items"].."]",
		"["..ARMOR.."]",
		"["..COMBAT_RATING_NAME2.."]", -- "Defense Rating"
		"["..DEFENSE.."]",
		"["..COMBAT_RATING_NAME3.."]", -- "Dodge Rating"
		"["..DODGE..L["(%)"].."]",
		"["..COMBAT_RATING_NAME4.."]", -- "Parry Rating"
		"["..PARRY..L["(%)"].."]",
		"["..COMBAT_RATING_NAME5.."]", -- "Block Rating"
		"["..BLOCK..L["(%)"].."]",
		L["Block Value"],
		COMBAT_RATING_NAME15, -- "Resilience"
	},
	{-- TPCMobStats1
		L["Mob Level"],
		L["Mob Damage"],
		L["Mob Attack Speed"],
	},
}
-- Set label text
function TPCalc:SetLabels()
	for i, text in ipairs(self.LabelText[1]) do
		_G["TPCResults"..i.."_LabelText"]:SetText(text)
	end
	for i, text in ipairs(self.LabelText[2]) do
		_G["TPCCombatTable"..i.."_LabelText"]:SetText(text)
	end
	for i, text in ipairs(self.LabelText[3]) do
		_G["TPCPlayerStats"..i.."_LabelText"]:SetText(text)
	end
	for i, text in ipairs(self.LabelText[4]) do
		_G["TPCMobStats"..i.."_LabelText"]:SetText(text)
	end
end

function TankPointsCalculatorFrame_ResetButton_OnClick(self, button, down)
	for i, _ in ipairs(TPCalc.LabelText[3]) do
		local inputBox = _G["TPCPlayerStats"..i.."_InputEditBox"]
		inputBox:SetText("0")
		inputBox:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	for i, _ in ipairs(TPCalc.LabelText[4]) do
		local inputBox = _G["TPCMobStats"..i.."_InputEditBox"]
		inputBox:SetText("0")
		inputBox:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
end

function TPCalc:UpdateResults()
	-- Update base data
	TankPoints:GetSourceData(self.sourceDT)
	copyTable(self.resultsDT, self.sourceDT)
	TankPoints:GetTankPoints(self.resultsDT)
	local newDT = {}
	copyTable(newDT, self.sourceDT)
	local prefix
	--------------------
	-- Get input data --
	--------------------
	-- input data is writen in the changes table
	local changes = {}
	local inputEditBox = "_InputEditBox"
	local currentText = "_CurrentText"
	local resultText = "_ResultText"
	local differenceText = "_DifferenceText"
	local originalStatText = "_OriginalStatText"
	local newStatText = "_NewStatText"
	
	local current, new, diff
	
	prefix = "TPCPlayerStats"
	local i = 1
	-- Strength
	changes.str = _G[prefix..i..inputEditBox]:GetNumber()
	i = i + 1
	-- Agility
	changes.agi = _G[prefix..i..inputEditBox]:GetNumber()
	i = i + 1
	-- Stamina
	changes.sta = _G[prefix..i..inputEditBox]:GetNumber()
	i = i + 1
	-- Max Health
	changes.playerHealth = _G[prefix..i..inputEditBox]:GetNumber()
	i = i + 1
	-- Armor (Items)
	changes.armorFromItems = _G[prefix..i..inputEditBox]:GetNumber()
	i = i + 1
	-- Armor
	changes.armor = _G[prefix..i..inputEditBox]:GetNumber()
	i = i + 1
	-- Defense Rating
	changes.defense = 0
	diff = _G[prefix..i..inputEditBox]:GetNumber()
	if diff then
		-- Ratings are floored in game
		current = GetCombatRating(CR_DEFENSE_SKILL)
		changes.defense = floor(StatLogic:GetEffectFromRating(current + diff, CR_DEFENSE_SKILL, newDT.playerLevel)) - floor(StatLogic:GetEffectFromRating(current, CR_DEFENSE_SKILL, newDT.playerLevel))
	end
	i = i + 1
	-- Defense
	changes.defense = changes.defense + _G[prefix..i..inputEditBox]:GetNumber()
	i = i + 1
	-- Dodge Rating
	changes.dodgeChance = 0
	diff = _G[prefix..i..inputEditBox]:GetNumber()
	if diff then
		changes.dodgeChance = StatLogic:GetEffectFromRating(diff, CR_DODGE, newDT.playerLevel) * 0.01
	end
	i = i + 1
	-- Dodge
	changes.dodgeChance = changes.dodgeChance + _G[prefix..i..inputEditBox]:GetNumber() * 0.01
	i = i + 1
	-- Parry Rating
	changes.parryChance = 0
	diff = _G[prefix..i..inputEditBox]:GetNumber()
	if diff then
		changes.parryChance = StatLogic:GetEffectFromRating(diff, CR_PARRY, newDT.playerLevel) * 0.01
	end
	i = i + 1
	-- Parry
	changes.parryChance = changes.parryChance + _G[prefix..i..inputEditBox]:GetNumber() * 0.01
	i = i + 1
	-- Block Rating
	changes.blockChance = 0
	diff = _G[prefix..i..inputEditBox]:GetNumber()
	if diff then
		changes.blockChance = StatLogic:GetEffectFromRating(diff, CR_BLOCK, newDT.playerLevel) * 0.01
	end
	i = i + 1
	-- Block
	changes.blockChance = changes.blockChance + _G[prefix..i..inputEditBox]:GetNumber() * 0.01
	i = i + 1
	-- Block Value
	changes.blockValue = _G[prefix..i..inputEditBox]:GetNumber()
	i = i + 1
	-- Resilience
	changes.resilience = _G[prefix..i..inputEditBox]:GetNumber()
	
	prefix = "TPCMobStats"
	i = 1
	-- mobLevel
	changes.mobLevel = _G[prefix..i..inputEditBox]:GetNumber()
	i = i + 1
	-- mobDamage
	changes.mobDamage = _G[prefix..i..inputEditBox]:GetNumber()
	i = i + 1
	-- mobDamage
	changes.mobAttackSpeed = _G[prefix..i..inputEditBox]:GetNumber()
	
	----------------
	-- AlterTable --
	----------------
	TankPoints:AlterSourceData(newDT, changes)
	
	------------------------------
	-- Calculate new TankPoints --
	------------------------------
	TankPoints:GetTankPoints(newDT, TP_MELEE)
	
	------------------
	-- Display data --
	------------------
	--TPCPlayerStats1_OriginalStatText
	--TPCPlayerStats1_NewStatText
	--TPCResults1_CurrentText
	--TPCResults1_DifferenceText
	--TPCResults1_ResultText
	
	
	-------------------
	-- Results Frame --
	-------------------
	prefix = "TPCResults"
	-- TankPoints
	i = 1
	current = floor(self.resultsDT.tankPoints[TP_MELEE])
	new = floor(newDT.tankPoints[TP_MELEE])
	_G[prefix..i..currentText]:SetText(current)
	_G[prefix..i..resultText]:SetText(new)
	_G[prefix..i..differenceText]:SetText(format("%d", (new - current)))
	if (new > current) then
		_G[prefix..i..resultText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..resultText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..resultText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Damage Reduction
	i = i + 1
	current = floor(self.resultsDT.totalReduction[TP_MELEE] * 100 * 100) / 100
	new = floor(newDT.totalReduction[TP_MELEE] * 100 * 100) / 100
	_G[prefix..i..currentText]:SetText(format("%.2f", current))
	_G[prefix..i..resultText]:SetText(format("%.2f", new))
	_G[prefix..i..differenceText]:SetText(format("%.2f", (new - current)))
	if (new > current) then
		_G[prefix..i..resultText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..resultText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..resultText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	------------------------
	-- Combat Table Frame --
	------------------------
	prefix = "TPCCombatTable"
	-- mobMissChance
	i = 1
	current = floor(self.resultsDT.mobMissChance * 100 * 100) / 100
	new = floor(newDT.mobMissChance * 100 * 100) / 100
	_G[prefix..i..currentText]:SetText(format("%.2f", current))
	_G[prefix..i..resultText]:SetText(format("%.2f", new))
	_G[prefix..i..differenceText]:SetText(format("%.2f", (new - current)))
	if (new > current) then
		_G[prefix..i..resultText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..resultText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..resultText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- dodgeChance
	i = i + 1
	current = floor(self.resultsDT.dodgeChance * 100 * 100) / 100
	new = floor(newDT.dodgeChance * 100 * 100) / 100
	_G[prefix..i..currentText]:SetText(format("%.2f", current))
	_G[prefix..i..resultText]:SetText(format("%.2f", new))
	_G[prefix..i..differenceText]:SetText(format("%.2f", (new - current)))
	if (new > current) then
		_G[prefix..i..resultText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..resultText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..resultText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- parryChance
	i = i + 1
	current = floor(self.resultsDT.parryChance * 100 * 100) / 100
	new = floor(newDT.parryChance * 100 * 100) / 100
	_G[prefix..i..currentText]:SetText(format("%.2f", current))
	_G[prefix..i..resultText]:SetText(format("%.2f", new))
	_G[prefix..i..differenceText]:SetText(format("%.2f", (new - current)))
	if (new > current) then
		_G[prefix..i..resultText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..resultText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..resultText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- blockChance
	i = i + 1
	current = floor(self.resultsDT.blockChance * 100 * 100) / 100
	new = floor(newDT.blockChance * 100 * 100) / 100
	_G[prefix..i..currentText]:SetText(format("%.2f", current))
	_G[prefix..i..resultText]:SetText(format("%.2f", new))
	_G[prefix..i..differenceText]:SetText(format("%.2f", (new - current)))
	if (new > current) then
		_G[prefix..i..resultText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..resultText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..resultText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- mobCritChance
	i = i + 1
	current = floor(self.resultsDT.mobCritChance * 100 * 100) / 100
	new = floor(newDT.mobCritChance * 100 * 100) / 100
	_G[prefix..i..currentText]:SetText(format("%.2f", current))
	_G[prefix..i..resultText]:SetText(format("%.2f", new))
	_G[prefix..i..differenceText]:SetText(format("%.2f", (new - current)))
	if (new < current) then
		_G[prefix..i..resultText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new > current) then
		_G[prefix..i..resultText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..resultText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- mobCrushChance
	i = i + 1
	current = floor(self.resultsDT.mobCrushChance * 100 * 100) / 100
	new = floor(newDT.mobCrushChance * 100 * 100) / 100
	_G[prefix..i..currentText]:SetText(format("%.2f", current))
	_G[prefix..i..resultText]:SetText(format("%.2f", new))
	_G[prefix..i..differenceText]:SetText(format("%.2f", (new - current)))
	if (new < current) then
		_G[prefix..i..resultText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new > current) then
		_G[prefix..i..resultText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..resultText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- mobHitChance
	i = i + 1
	current = floor(max(0, (1 - self.resultsDT.mobCrushChance - self.resultsDT.mobCritChance - self.resultsDT.blockChance - self.resultsDT.parryChance - self.resultsDT.dodgeChance - self.resultsDT.mobMissChance)) * 100 * 100) / 100
	new = floor(max(0, (1 - newDT.mobCrushChance - newDT.mobCritChance - newDT.blockChance - newDT.parryChance - newDT.dodgeChance - newDT.mobMissChance)) * 100 * 100) / 100
	_G[prefix..i..currentText]:SetText(format("%.2f", current))
	_G[prefix..i..resultText]:SetText(format("%.2f", new))
	_G[prefix..i..differenceText]:SetText(format("%.2f", (new - current)))
	if (new < current) then
		_G[prefix..i..resultText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new > current) then
		_G[prefix..i..resultText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..resultText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		_G[prefix..i..differenceText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	------------------------
	-- Player Stats Frame --
	------------------------
	prefix = "TPCPlayerStats"
	-- Strength
	i = 1
	_, current = UnitStat("player", 1)
	new = floor(current + changes.str)
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Agility
	i = i + 1
	_, current = UnitStat("player", 2)
	new = floor(current + changes.agi)
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Stamina
	i = i + 1
	_, current = UnitStat("player", 3)
	new = floor(current + changes.sta)
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Max Health
	i = i + 1
	current = self.resultsDT.playerHealth
	new = floor(newDT.playerHealth)
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Armor (Items)
	i = i + 1
	current = self.resultsDT.armor
	new = floor(newDT.armor)
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Armor
	i = i + 1
	current = self.resultsDT.armor
	new = floor(newDT.armor)
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Defense Rating
	i = i + 1
	current = GetCombatRating(CR_DEFENSE_SKILL)
	new = floor(current + _G[prefix..i..inputEditBox]:GetNumber())
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Defense
	i = i + 1
	current = self.resultsDT.defense
	new = floor(newDT.defense)
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Dodge Rating
	i = i + 1
	current = GetCombatRating(CR_DODGE)
	new = floor(current + _G[prefix..i..inputEditBox]:GetNumber())
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Dodge
	i = i + 1
	current = floor(self.resultsDT.dodgeChance * 100 * 100) / 100
	new = floor(newDT.dodgeChance * 100 * 100) / 100
	_G[prefix..i..originalStatText]:SetText(format("%.2f", current))
	_G[prefix..i..newStatText]:SetText(format("%.2f", new))
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Parry Rating
	i = i + 1
	current = GetCombatRating(CR_PARRY)
	new = floor(current + _G[prefix..i..inputEditBox]:GetNumber())
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Parry
	i = i + 1
	current = floor(self.resultsDT.parryChance * 100 * 100) / 100
	new = floor(newDT.parryChance * 100 * 100) / 100
	_G[prefix..i..originalStatText]:SetText(format("%.2f", current))
	_G[prefix..i..newStatText]:SetText(format("%.2f", new))
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Block Rating
	i = i + 1
	current = GetCombatRating(CR_BLOCK)
	new = floor(current + _G[prefix..i..inputEditBox]:GetNumber())
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Block
	i = i + 1
	current = floor(self.resultsDT.blockChance * 100 * 100) / 100
	new = floor(newDT.blockChance * 100 * 100) / 100
	_G[prefix..i..originalStatText]:SetText(format("%.2f", current))
	_G[prefix..i..newStatText]:SetText(format("%.2f", new))
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Block Value
	i = i + 1
	current = self.resultsDT.blockValue
	new = floor(newDT.blockValue)
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- Resilience
	i = i + 1
	current = self.resultsDT.resilience
	new = floor(newDT.resilience)
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	---------------------
	-- Mob Stats Frame --
	---------------------
	prefix = "TPCMobStats"
	-- mobLevel
	i = 1
	current = self.resultsDT.mobLevel
	new = floor(newDT.mobLevel)
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- mobDamage
	i = i + 1
	current = floor(TankPoints:GetMobDamage(self.resultsDT.mobLevel))
	new = floor(TankPoints:GetMobDamage(newDT.mobLevel) + _G[prefix..i..inputEditBox]:GetNumber())
	_G[prefix..i..originalStatText]:SetText(current)
	_G[prefix..i..newStatText]:SetText(new)
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	-- mobAttackSpeed
	i = i + 1
	current = floor(self.resultsDT.mobAttackSpeed * 10) / 10
	new = floor(newDT.mobAttackSpeed * 10) / 10
	_G[prefix..i..originalStatText]:SetText(format("%.1f", current))
	_G[prefix..i..newStatText]:SetText(format("%.1f", new))
	if (new > current) then
		_G[prefix..i..newStatText]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	elseif (new < current) then
		_G[prefix..i..newStatText]:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		_G[prefix..i..newStatText]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
	
	--------------
	-- Clean up --
	--------------
end