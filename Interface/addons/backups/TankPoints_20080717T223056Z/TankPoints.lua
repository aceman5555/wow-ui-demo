--[[
Name: TankPoints
Description: Calculates and shows your TankPoints in the PaperDall Frame
Revision: $Revision: 39338 $
Developed by: Whitetooth@Cenarius (hotdogee@bahamut.twbbs.org)
]]

---------------
-- Libraries --
---------------
local Gratuity = AceLibrary("Gratuity-2.0")
local Deformat = AceLibrary("Deformat-2.0")
local TipHooker = AceLibrary("TipHooker-1.0")
local StatLogic = AceLibrary("StatLogic-1.0")
local Waterfall = AceLibrary("Waterfall-1.0")
local L = AceLibrary("AceLocale-2.2"):new("TankPoints")


--------------------
-- AceAddon Setup --
--------------------
-- AceAddon Initialization
TankPoints = AceLibrary("AceAddon-2.0"):new("AceDB-2.0", "AceConsole-2.0", "AceEvent-2.0", "AceDebug-2.0")
TankPoints.title = "TankPoints"
TankPoints.version = "2.6.8 (r"..gsub("$Revision: 39338 $", "(%d+)", "%1")..")"
TankPoints.date = gsub("$Date: 2007-06-10 14:56:42 +0800 (星期日, 10 六月 2007) $", "^.-(%d%d%d%d%-%d%d%-%d%d).-$", "%1")

local TankPoints = TankPoints


-------------------
-- Set Debugging --
-------------------
TankPoints:SetDebugging(false)


----------------------
-- Global Variables --
----------------------
-- Set Dropdown Options Global
PLAYERSTAT_TANKPOINTS = L["TankPoints"]

TP_RANGED = 0
TP_MELEE = 1
TP_HOLY = 2
TP_FIRE = 3
TP_NATURE = 4
TP_FROST = 5
TP_SHADOW = 6
TP_ARCANE = 7

TankPoints.SchoolName = {
	[TP_RANGED] = PLAYERSTAT_RANGED_COMBAT,
	[TP_MELEE] = PLAYERSTAT_MELEE_COMBAT,
	[TP_HOLY] = SPELL_SCHOOL1_CAP,
	[TP_FIRE] = SPELL_SCHOOL2_CAP,
	[TP_NATURE] = SPELL_SCHOOL3_CAP,
	[TP_FROST] = SPELL_SCHOOL4_CAP,
	[TP_SHADOW] = SPELL_SCHOOL5_CAP,
	[TP_ARCANE] = SPELL_SCHOOL6_CAP,
}

local schoolIDToString = {
	[TP_RANGED] = "RANGED",
	[TP_MELEE] = "MELEE",
	[TP_HOLY] = "HOLY",
	[TP_FIRE] = "FIRE",
	[TP_NATURE] = "NATURE",
	[TP_FROST] = "FROST",
	[TP_SHADOW] = "SHADOW",
	[TP_ARCANE] = "ARCANE",
}

---------------------
-- Local Variables --
---------------------
local profileDB -- Initialized in :OnInitialize()

-- Localize Lua globals
local _
local _G = getfenv(0)
local strfind = strfind
local pairs = pairs
local ipairs = ipairs
local type = type
local tinsert = tinsert
local tremove = tremove
local unpack = unpack
local max = max
local min = min
local floor = floor
local round = function(n)
	return floor(n + 0.5)
end
local loadstring = loadstring

-- Localize WoW globals
local GameTooltip = GameTooltip
local CreateFrame = CreateFrame
local UnitClass = UnitClass
local UnitRace = UnitRace
local UnitLevel = UnitLevel
local UnitStat = UnitStat
local UnitDefense = UnitDefense
local UnitHealthMax = UnitHealthMax
local UnitArmor = UnitArmor
local UnitResistance = UnitResistance
local IsEquippedItemType = IsEquippedItemType
local GetTime = GetTime
local GetInventorySlotInfo = GetInventorySlotInfo
local GetTalentInfo = GetTalentInfo
local GetShapeshiftForm = GetShapeshiftForm
local GetShapeshiftFormInfo = GetShapeshiftFormInfo
local GetDodgeChance = GetDodgeChance
local GetParryChance = GetParryChance
local GetBlockChance = GetBlockChance
local GetCombatRating = GetCombatRating
local GetPlayerBuffName = GetPlayerBuffName

---------------------
-- Saved Variables --
---------------------
-- Register DB
TankPoints:RegisterDB("TankPointsDB")
-- Default values
TankPoints.DBDefaults = {
	showTooltipDiff = true,
	showTooltipTotal = false,
	mobLevelDiff = 3,
	mobDamage = 0,
	mobAttackSpeed = 2,
	mobCritChance = 0.05,
	mobCritBonus = 1,
	mobMissChance = 0.05,
	mobSpellCritChance = 0,
	mobSpellCritBonus = 0.5,
	mobSpellMissChance = 0,
	playerSBFreq = 8,
}
-- Register Defaults
TankPoints:RegisterDefaults("profile", TankPoints.DBDefaults)

-- Set Default Mob Stats
function TankPoints.SetDefaultMobStats()
	profileDB.mobLevelDiff = 3
	profileDB.mobDamage = 0
	profileDB.mobAttackSpeed = 2
	profileDB.mobCritChance = 0.05
	profileDB.mobCritBonus = 1
	profileDB.mobMissChance = 0.05
	profileDB.mobSpellCritChance = 0
	profileDB.mobSpellCritBonus = 0.5
	profileDB.mobSpellMissChance = 0
	profileDB.playerSBFreq = 8
	PaperDollFrame_UpdateStats()
	-- Update Calculator
	if TankPointsCalculatorFrame:IsVisible() then
		TPCalc:UpdateResults()
	end
	TankPoints:Print(L["Restored Mob Stats Defaults"])
end

---------------------------
-- Slash Command Options --
---------------------------
local consoleOptions = {
	type = "group",
	args = {
		optionswin = {
			type = "execute",
			name = L["Options Window"],
			desc = L["Shows the Options Window"],
			func = function()
				Waterfall:Open("TankPoints")
			end,
		},
		calc = {
			type = "execute",
			name = L["TankPoints Calculator"],
			desc = L["Shows the TankPoints Calculator"],
			func = function()
				if(TankPointsCalculatorFrame:IsVisible()) then
					TankPointsCalculatorFrame:Hide()
				else
					TankPointsCalculatorFrame:Show()
				end
				PaperDollFrame_UpdateStats()
			end,
		},
		tip = {
			type = "group",
			name = L["Tooltip Options"],
			desc = L["TankPoints tooltip options"],
			args = {
				diff = {
					type = 'toggle',
					name = L["Show Tooltips Difference"],
					desc = L["Show TankPoints difference in item tooltips"],
					get = function() return profileDB.showTooltipDiff end,
					set = function(v)
						profileDB.showTooltipDiff = v
						TankPointsTooltips.ClearCache()
					end,
				},
				total = {
					type = 'toggle',
					name = L["Show Tooltips Total"],
					desc = L["Show TankPoints total in item tooltips"],
					get = function() return profileDB.showTooltipTotal end,
					set = function(v)
						profileDB.showTooltipTotal = v
						TankPointsTooltips.ClearCache()
					end,
				},
			},
		},
		player = {
			type = "group",
			name = L["Player Stats"],
			desc = L["Change default player stats"],
			args = {
				sbfreq = {
					type = "range",
					name = L["Shield Block Key Press Frequency"],
					desc = L["Sets the time in seconds between Shield Block key presses"],
					get = function() return profileDB.playerSBFreq end,
					set = function(v)
						profileDB.playerSBFreq = v
						PaperDollFrame_UpdateStats()
						-- Update Calculator
						if TankPointsCalculatorFrame:IsVisible() then
							TPCalc:UpdateResults()
						end
					end,
					min = 5,
					max = 100,
				},
			},
		},
		mob = {
			type = "group",
			name = L["Mob Stats"],
			desc = L["Change default mob stats"],
			args = {
				level = {
					type = "range",
					name = L["Mob Level"],
					desc = L["Sets the level difference between the mob and you"],
					get = function() return profileDB.mobLevelDiff end,
					set = function(v)
						profileDB.mobLevelDiff = v
						PaperDollFrame_UpdateStats()
						-- Update Calculator
						if TankPointsCalculatorFrame:IsVisible() then
							TPCalc:UpdateResults()
						end
					end,
					min = -20,
					max = 20,
					step = 1,
				},
				damage = {
					type = "range",
					name = L["Mob Damage"],
					desc = L["Sets mob's damage before damage reduction"],
					get = function() return TankPoints:GetMobDamage(UnitLevel("player") + profileDB.mobLevelDiff) end,
					set = function(v)
						profileDB.mobDamage = v
						PaperDollFrame_UpdateStats()
						-- Update Calculator
						if TankPointsCalculatorFrame:IsVisible() then
							TPCalc:UpdateResults()
						end
					end,
					min = 0,
					max = 99999,
					step = 1,
				},
				speed = {
					type = "range",
					name = L["Mob Attack Speed"],
					desc = L["Sets mob's attack speed"],
					get = function() return profileDB.mobAttackSpeed end,
					set = function(v)
						profileDB.mobAttackSpeed = v
						PaperDollFrame_UpdateStats()
						-- Update Calculator
						if TankPointsCalculatorFrame:IsVisible() then
							TPCalc:UpdateResults()
						end
					end,
					min = 0.1,
					max = 10,
				},
				default = {
					type = "execute",
					name = L["Restore Default"],
					desc = L["Restores default mob stats"],
					func = TankPoints.SetDefaultMobStats,
				},
				advanced = {
					type = "group",
					name = L["Mob Stats Advanced Settings"],
					desc = L["Change advanced mob stats"],
					args = {
						crit = {
							type = "range",
							name = L["Mob Melee Crit"],
							desc = L["Sets mob's melee crit chance"],
							get = function() return profileDB.mobCritChance end,
							set = function(v)
								profileDB.mobCritChance = v
								PaperDollFrame_UpdateStats()
								-- Update Calculator
								if TankPointsCalculatorFrame:IsVisible() then
									TPCalc:UpdateResults()
								end
							end,
							min = 0,
							max = 1,
							isPercent = true,
						},
						critbonus = {
							type = "range",
							name = L["Mob Melee Crit Bonus"],
							desc = L["Sets mob's melee crit bonus"],
							get = function() return profileDB.mobCritBonus end,
							set = function(v)
								profileDB.mobCritBonus = v
								PaperDollFrame_UpdateStats()
								-- Update Calculator
								if TankPointsCalculatorFrame:IsVisible() then
									TPCalc:UpdateResults()
								end
							end,
							min = 0,
							max = 2,
						},
						miss = {
							type = "range",
							name = L["Mob Melee Miss"],
							desc = L["Sets mob's melee miss chance"],
							get = function() return profileDB.mobMissChance end,
							set = function(v)
								profileDB.mobMissChance = v
								PaperDollFrame_UpdateStats()
								-- Update Calculator
								if TankPointsCalculatorFrame:IsVisible() then
									TPCalc:UpdateResults()
								end
							end,
							min = 0,
							max = 1,
							isPercent = true,
						},
						spellcrit = {
							type = "range",
							name = L["Mob Spell Crit"],
							desc = L["Sets mob's spell crit chance"],
							get = function() return profileDB.mobSpellCritChance end,
							set = function(v)
								profileDB.mobSpellCritChance = v
								PaperDollFrame_UpdateStats()
								-- Update Calculator
								if TankPointsCalculatorFrame:IsVisible() then
									TPCalc:UpdateResults()
								end
							end,
							min = 0,
							max = 1,
							isPercent = true,
						},
						spellcritbonus = {
							type = "range",
							name = L["Mob Spell Crit Bonus"],
							desc = L["Sets mob's spell crit bonus"],
							get = function() return profileDB.mobSpellCritBonus end,
							set = function(v)
								profileDB.mobSpellCritBonus = v
								PaperDollFrame_UpdateStats()
								-- Update Calculator
								if TankPointsCalculatorFrame:IsVisible() then
									TPCalc:UpdateResults()
								end
							end,
							min = 0,
							max = 2,
						},
						spellmiss = {
							type = "range",
							name = L["Mob Spell Miss"],
							desc = L["Sets mob's spell miss chance"],
							get = function() return profileDB.mobSpellMissChance end,
							set = function(v)
								profileDB.mobSpellMissChance = v
								PaperDollFrame_UpdateStats()
								-- Update Calculator
								if TankPointsCalculatorFrame:IsVisible() then
									TPCalc:UpdateResults()
								end
							end,
							min = 0,
							max = 1,
							isPercent = true,
						},
					},
				},
			},
		},
	},
}

TankPoints:RegisterChatCommand({"/tp", "/tankpoints"}, consoleOptions)

Waterfall:Register("TankPoints", 
"aceOptions", consoleOptions, 
"title", L["TankPoints Options"])

-----------
-- Tools --
-----------
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

-- Schedule Table
TankPoints.ScheduledTasks = {}
function TankPoints:Schedule(taskName, timeAfter, functionName, ...)
	if (taskName and timeAfter) then -- functionName not required so we can use IsScheduled as a timer check
		self.ScheduledTasks[taskName] = {
			TargetTime = GetTime() + timeAfter,
			FunctionName = functionName,
			Arg = {...},
		}
	end
end

function TankPoints:ScheduleRepeat(taskName, repeatRate, functionName, ...)
	if (taskName and repeatRate and functionName) then -- functionName required
		self.ScheduledTasks[taskName] = {
			Elapsed = 0,
			RepeatRate = repeatRate,
			FunctionName = functionName,
			Arg = {...},
		}
	end
end

function TankPoints:UnSchedule(taskName)
	--WT_RaidWarningAPI.Announce({HOTDOG = taskName})
	if not taskName then return end
	self.ScheduledTasks[taskName] = nil
end

function TankPoints:IsScheduled(taskName)
	return (self.ScheduledTasks[taskName] ~= nil)
end

function TankPoints:OnUpdate(elapsed)
	--TankPoints:Debug("update: "..tostring(elapsed))
	local currentTime = GetTime()
	for taskName, task in pairs(TankPoints.ScheduledTasks) do
		if type(task.TargetTime) ~= "nil" and (currentTime >= task.TargetTime) then
			TankPoints:UnSchedule(taskName)
			if (task.FunctionName) then
				task.FunctionName(unpack(task.Arg))
			end
		elseif type(task.Elapsed) ~= "nil" then
			task.Elapsed = task.Elapsed + arg1
			if (task.Elapsed >= task.RepeatRate) then
				task.FunctionName(unpack(task.Arg))
				task.Elapsed = task.Elapsed - task.RepeatRate
			end
		end
	end
end


---------------------
-- Initializations --
---------------------
--[[ Loading Process Event Reference
{
ADDON_LOADED - When this addon is loaded
VARIABLES_LOADED - When all addons are loaded
PLAYER_LOGIN - Most information about the game world should now be available to the UI
}
--]]
-- OnInitialize(name) called at ADDON_LOADED
function TankPoints:OnInitialize()
	-- Initialize profileDB
	profileDB = TankPoints.db.profile
	-- OnUpdate Frame
	self.OnUpdateFrame = CreateFrame("Frame")
	self.OnUpdateFrame:SetScript("OnUpdate", self.OnUpdate)
	-- Player TankPoints table
	self.sourceTable = {}
	self.resultsTable = {}
	-- Set player class, race, level
	local _, class = UnitClass("player")
	TankPoints.playerClass = class
	local _, race = UnitRace("player")
	TankPoints.playerRace = race
end

-- OnEnable() called at PLAYER_LOGIN
function TankPoints:OnEnable()
	-- Add "TankPoints" to playerstat drop down list
	tinsert(PLAYERSTAT_DROPDOWN_OPTIONS, "PLAYERSTAT_TANKPOINTS")
	-- Hook UpdatePaperdollStats(prefix, index)
	hooksecurefunc("UpdatePaperdollStats", self.UpdatePaperdollStatsHook)
	-- Event to monitor shift, alt, ctrl keys
	self:RegisterEvent("MODIFIER_STATE_CHANGED")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	-- Initialize TankPoints.playerLevel
	self.playerLevel = UnitLevel("player")
	-- Calculate TankPoints
	self:UpdateDataTable()
end

function TankPoints:OnDisable()
	-- Remove "Warrior Stats" from playerstat drop down list
	for k, v in ipairs(PLAYERSTAT_DROPDOWN_OPTIONS) do
		if v == "PLAYERSTAT_TANKPOINTS" then
			tremove(PLAYERSTAT_DROPDOWN_OPTIONS, k)
			-- reset stats if warrior stats are still selected
			if PLAYERSTAT_LEFTDROPDOWN_SELECTION == v then
				PLAYERSTAT_LEFTDROPDOWN_SELECTION = "PLAYERSTAT_BASE_STATS"
			end
			if PLAYERSTAT_RIGHTDROPDOWN_SELECTION == v then
				if self.playerClass == "MAGE" or self.playerClass == "PRIEST" or self.playerClass == "WARLOCK" or self.playerClass == "DRUID" then
					PLAYERSTAT_RIGHTDROPDOWN_SELECTION = "PLAYERSTAT_SPELL_COMBAT"
				elseif self.playerClass == "HUNTER" then
					PLAYERSTAT_RIGHTDROPDOWN_SELECTION = "PLAYERSTAT_RANGED_COMBAT"
				else
					PLAYERSTAT_RIGHTDROPDOWN_SELECTION = "PLAYERSTAT_MELEE_COMBAT"
				end
			end
			PaperDollFrame_UpdateStats()
			UIDropDownMenu_SetSelectedValue(PlayerStatFrameLeftDropDown, PLAYERSTAT_LEFTDROPDOWN_SELECTION)
			UIDropDownMenu_SetSelectedValue(PlayerStatFrameRightDropDown, PLAYERSTAT_RIGHTDROPDOWN_SELECTION)
		end
	end
end


-------------------------
-- PaperdollStats Hook --
-------------------------
local StatFrame = {
	["PlayerStatFrameLeft"] = {
		[1] = _G["PlayerStatFrameLeft1"],
		[2] = _G["PlayerStatFrameLeft2"],
		[3] = _G["PlayerStatFrameLeft3"],
		[4] = _G["PlayerStatFrameLeft4"],
		[5] = _G["PlayerStatFrameLeft5"],
		[6] = _G["PlayerStatFrameLeft6"],
	},
	["PlayerStatFrameRight"] = {
		[1] = _G["PlayerStatFrameRight1"],
		[2] = _G["PlayerStatFrameRight2"],
		[3] = _G["PlayerStatFrameRight3"],
		[4] = _G["PlayerStatFrameRight4"],
		[5] = _G["PlayerStatFrameRight5"],
		[6] = _G["PlayerStatFrameRight6"],
	},
}
function TankPoints.UpdatePaperdollStatsHook(prefix, index)
	-- this gets called multiple times per sec durning stance change or equipment change, which is is not needed
	-- we'll schedule it to update 0.01 sec after its called, fast enough for no delay, slow enough to catch all the repeted calls
	if index == "PLAYERSTAT_TANKPOINTS" then
		TankPoints:Schedule("UpdateStatsSelected"..prefix, 0.01, TankPoints.UpdateStatsSelected, TankPoints, prefix, index)
		StatFrame[prefix][1]:SetScript("OnEnter", TankPoints.TankPointsFrame_OnEnter) -- OnEnter: function(self, motion) 
		StatFrame[prefix][2]:SetScript("OnEnter", TankPoints.MeleeReductionFrame_OnEnter)
		StatFrame[prefix][3]:SetScript("OnEnter", TankPoints.BlockValueFrame_OnEnter)
		StatFrame[prefix][4]:SetScript("OnEnter", TankPoints.SpellTankPointsFrame_OnEnter)
		StatFrame[prefix][4]:SetScript("OnMouseUp", TankPoints.SpellTankPointsFrame_OnMouseUp) -- OnMouseUp: function(self,button)
		StatFrame[prefix][5]:SetScript("OnEnter", TankPoints.SpellReductionFrame_OnEnter)
		StatFrame[prefix][5]:SetScript("OnMouseUp", TankPoints.SpellTankPointsFrame_OnMouseUp)
		StatFrame[prefix][6]:SetScript("OnEnter", TankPoints.TankPointsCalculatorStat_OnEnter)
		StatFrame[prefix][6]:SetScript("OnLeave", TankPoints.TankPointsCalculatorStat_OnLeave) -- OnLeave: function(self, motion)
		StatFrame[prefix][6]:SetScript("OnMouseUp", TankPoints.TankPointsCalculatorStat_OnMouseUp)
	-- plays nice with other mods that add to the dropdown list
	elseif index == "PLAYERSTAT_BASE_STATS" or index == "PLAYERSTAT_MELEE_COMBAT" or index == "PLAYERSTAT_RANGED_COMBAT" or index == "PLAYERSTAT_SPELL_COMBAT" or index == "PLAYERSTAT_DEFENSES" then
		StatFrame[prefix][3]:SetScript("OnEnter", PaperDollStatTooltip)
		StatFrame[prefix][5]:SetScript("OnEnter", PaperDollStatTooltip)
		StatFrame[prefix][6]:SetScript("OnEnter", PaperDollStatTooltip)
		StatFrame[prefix][6]:SetScript("OnLeave", function (self, motion) GameTooltip:Hide() end)
		StatFrame[prefix][4]:SetScript("OnMouseUp", nil)
		StatFrame[prefix][5]:SetScript("OnMouseUp", nil)
		StatFrame[prefix][6]:SetScript("OnMouseUp", nil)
	end
end


-------------------------
-- Updating TankPoints --
-------------------------
--[[------------------------
{	PaperDollFrame_UpdateStats in PaperDollFrame.lua
function PaperDollFrame_UpdateStats()
	UpdatePaperdollStats("PlayerStatFrameLeft", PLAYERSTAT_LEFTDROPDOWN_SELECTION);	
	UpdatePaperdollStats("PlayerStatFrameRight", PLAYERSTAT_RIGHTDROPDOWN_SELECTION);	
end
- This will recalculate TankPoints data and update the char stat panal if the TankPoints panal is shown
- Called by the game at:
	VARIABLES_LOADED
	UNIT_DAMAGE
	PLAYER_DAMAGE_DONE_MODS
	UNIT_ATTACK_SPEED
	UNIT_RANGEDDAMAGE
	UNIT_ATTACK
	UNIT_STATS
	UNIT_RANGED_ATTACK_POWER
	UNIT_RESISTANCES
	COMBAT_RATING_UPDATE
	PaperDollFrame_OnShow()
}
--]]
-- Update TankPoints panal stats if selected
function TankPoints:UpdateStats()
	if PLAYERSTAT_RIGHTDROPDOWN_SELECTION == "PLAYERSTAT_TANKPOINTS" then
		self:Debug("** UNIT_AURA - RIGHT **") -- debug
		self:Schedule("UpdateStatsSelected".."PlayerStatFrameRight", 0.01, self.UpdateStatsSelected, self, "PlayerStatFrameRight", PLAYERSTAT_RIGHTDROPDOWN_SELECTION)
	end
	if PLAYERSTAT_LEFTDROPDOWN_SELECTION == "PLAYERSTAT_TANKPOINTS" then
		self:Debug("** UNIT_AURA - LEFT **") -- debug
		self:Schedule("UpdateStatsSelected".."PlayerStatFrameLeft", 0.01, self.UpdateStatsSelected, self, "PlayerStatFrameLeft", PLAYERSTAT_LEFTDROPDOWN_SELECTION)
	end
end

-- Recalculate TankPoints, Update Panal Stats, Update Tooltip
function TankPoints:UpdateStatsSelected(prefix, index)
	-- Calculate TankPoints
	self:UpdateDataTable()
	-- Set stats
	self:SetTankPoints(StatFrame[prefix][1])
	self:SetMeleeReduction(StatFrame[prefix][2])
	self:SetBlockValue(StatFrame[prefix][3])
	self:SetSpellTankPoints(StatFrame[prefix][4])
	self:SetSpellReduction(StatFrame[prefix][5])
	self:SetTankPointsCalculator(StatFrame[prefix][6])
	-- Update tooltip
	self:UpdateStatsTooltips()
end

-- Updates scource and recalculates TankPoints
function TankPoints:UpdateDataTable()
	self:GetSourceData(self.sourceTable)
	copyTable(self.resultsTable, self.sourceTable)
	self:GetTankPoints(self.resultsTable)
	TankPointsTooltips.ClearCache()
end

-- Update tooltip if owned by one of the TankPoint stats
function TankPoints:UpdateStatsTooltips()
	if PLAYERSTAT_RIGHTDROPDOWN_SELECTION == "PLAYERSTAT_TANKPOINTS" then
		for i = 1, 6 do
			local frame = StatFrame["PlayerStatFrameRight"][i]
			if GameTooltip:IsOwned(frame) then
				--self:Debug("UpdateStatsTooltips")
				frame:GetScript("OnEnter")(frame)
				break
			end
		end
	end
	if PLAYERSTAT_LEFTDROPDOWN_SELECTION == "PLAYERSTAT_TANKPOINTS" then
		for i = 1, 6 do
			local frame = StatFrame["PlayerStatFrameLeft"][i]
			if GameTooltip:IsOwned(frame) then
				frame:GetScript("OnEnter")(frame)
				break
			end
		end
	end
end

------------
-- Events --
------------
-- event = MODIFIER_STATE_CHANGED
-- arg1 = SHIFT or CTRL or ALT
-- arg2 = 1 for down, 0 for up
function TankPoints:MODIFIER_STATE_CHANGED()
	-- Stat Frame Tooltips
	if CharacterAttributesFrame:IsVisible() and GameTooltip:IsVisible() and arg1 == "ALT" then
		self:UpdateStatsTooltips()
	end
	--self:Debug("** "..arg1.." = "..arg2.." **") -- debug
end

-- event = UNIT_AURA
-- arg1 = the UnitID of the entity
function TankPoints:UNIT_AURA()
	-- Do nothing if event target is not player
	if not (arg1 == "player") then return end
	-- Update TankPoints panal stats if selected
	self:UpdateStats()
end

-- event = PLAYER_LEVEL_UP
-- arg1 = New player level
function TankPoints:PLAYER_LEVEL_UP()
	TankPoints.playerLevel = arg1
end


-----------------------------------
-- Set TankPoints PaperdollStats --
-----------------------------------
-- Line1: TankPoints
function TankPoints:SetTankPoints(statFrame)
	local tankpoints = format("%d", self.resultsTable.tankPoints[TP_MELEE])
	PaperDollFrame_SetLabelAndText(statFrame, L["TankPoints"], tankpoints)
	statFrame:Show()
end

-- Line2: MeleeReduction
function TankPoints:SetMeleeReduction(statFrame)
	local meleeReduction = format("%.2f", self.resultsTable.totalReduction[TP_MELEE] * 100)
	PaperDollFrame_SetLabelAndText(statFrame, self.SchoolName[TP_MELEE]..L[" DR"], meleeReduction, true)
	statFrame:Show()
end

-- Line3: BlockValue
function TankPoints:SetBlockValue(statFrame)
	local blockValue = self.resultsTable.blockValue
	PaperDollFrame_SetLabelAndText(statFrame, L["Block Value"], blockValue)
	statFrame:Show()
end

-- Line4: SpellTankPoints
function TankPoints:SetSpellTankPoints(statFrame)
	if TankPoints.setSchool then
		TankPoints.currentSchool = TankPoints.setSchool
	else
		-- Find highest SpellTankPoints school
		TankPoints.currentSchool = TP_FIRE
		for s = TP_FIRE + 1, TP_ARCANE, 1 do
			if self.resultsTable.tankPoints[s] > self.resultsTable.tankPoints[TankPoints.currentSchool] then
				TankPoints.currentSchool = s
			end
		end
	end
	local spellTankPoints = format("%d", self.resultsTable.tankPoints[TankPoints.currentSchool])
	PaperDollFrame_SetLabelAndText(statFrame, self.SchoolName[TankPoints.currentSchool]..L[" TP"], spellTankPoints)
	statFrame:Show()
end

-- Line5: SpellReduction
function TankPoints:SetSpellReduction(statFrame)
	if TankPoints.setSchool then
		TankPoints.currentSchool = TankPoints.setSchool
	else
		-- Find highest SpellTankPoints school
		TankPoints.currentSchool = TP_FIRE
		for s = TP_FIRE + 1, TP_ARCANE, 1 do
			if self.resultsTable.tankPoints[s] > self.resultsTable.tankPoints[TankPoints.currentSchool] then
				TankPoints.currentSchool = s
			end
		end
	end
	local spellReduction = format("%.2f", self.resultsTable.totalReduction[TankPoints.currentSchool] * 100)
	PaperDollFrame_SetLabelAndText(statFrame, self.SchoolName[TankPoints.currentSchool]..L[" DR"], spellReduction, true)
	statFrame:Show()
end

-- Line6: TankPointsCalculator
function TankPoints:SetTankPointsCalculator(statFrame)
	if(TankPointsCalculatorFrame:IsVisible()) then
		_G[statFrame:GetName().."Label"]:SetText(L["Close Calculator"])
	else
		_G[statFrame:GetName().."Label"]:SetText(L["Open Calculator"])
	end
	_G[statFrame:GetName().."StatText"]:SetText("");
	statFrame:Show()
end


--------------------------------------
-- TankPoints PaperdollStats Events --
--------------------------------------
-- Toggle TankPointsCalculator OnMouseUp
function TankPoints.TankPointsCalculatorStat_OnMouseUp(frame, button)
	if(TankPointsCalculatorFrame:IsVisible()) then
		TankPointsCalculatorFrame:Hide()
		_G[frame:GetName().."Label"]:SetText(L["Open Calculator"])
	else
		TankPointsCalculatorFrame:Show()
		_G[frame:GetName().."Label"]:SetText(L["Close Calculator"])
	end
end

-- Change text color to Green OnEnter
function TankPoints.TankPointsCalculatorStat_OnEnter(frame, motion)
	_G[frame:GetName().."Label"]:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
end

-- Change text color to Green OnLeave
function TankPoints.TankPointsCalculatorStat_OnLeave(frame, motion)
	_G[frame:GetName().."Label"]:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
end

-- Cycle through schools OnClick left, Reset to strongest school OnClick right
-- Holy(2) -> Fire(3) -> Nature(4) -> Frost(5) -> Shadow(6) -> Arcane(7)
function TankPoints.SpellTankPointsFrame_OnMouseUp(frame, button)
	-- Set School
	if button == "LeftButton" then
		--TankPoints:Debug(tostring(button))
		if not TankPoints.setSchool then
			TankPoints.setSchool = TankPoints.currentSchool + 1
		else
			TankPoints.setSchool = TankPoints.setSchool + 1
		end
		if TankPoints.setSchool > 7 then
			TankPoints.setSchool = 2
		end
		TankPoints.currentSchool = TankPoints.setSchool
		--[[DEBUG
		local test1 = self:GetScript("OnEnter") == TankPoints.SpellTankPointsFrame_OnEnter
		local test2 = type(self:GetScript("OnEnter"))
		local test3 = self == _G["PlayerStatFrameRight"..4]
		TankPoints:Debug(tostring(test1)..", "..tostring(test2)..", "..tostring(test3)..", ")
		--]]
		frame:GetScript("OnEnter")(frame)
		PaperDollFrame_UpdateStats()
	-- Reset school
	elseif button == "RightButton" then
		TankPoints.setSchool = nil
		-- Find highest SpellTankPoints school
		TankPoints.currentSchool = TP_FIRE
		for s = TP_FIRE + 1, TP_ARCANE, 1 do
			if TankPoints.resultsTable.tankPoints[s] > TankPoints.resultsTable.tankPoints[TankPoints.currentSchool] then
				TankPoints.currentSchool = s
			end
		end
		frame:GetScript("OnEnter")(frame)
		PaperDollFrame_UpdateStats()
	end
end


----------------------------------------
-- TankPoints PaperdollStats Tooltips --
----------------------------------------
--[[
-- Reference --
Font Color Codes:
NORMAL_FONT_COLOR_CODE = "|cffffd200" -- Yellow
HIGHLIGHT_FONT_COLOR_CODE = "|cffffffff" -- White
FONT_COLOR_CODE_CLOSE = "|r"

Font Colors:
NORMAL_FONT_COLOR = {r = 1, g = 0.82, b = 0} -- Yellow
HIGHLIGHT_FONT_COLOR = {r = 1, g = 1, b = 1} -- White

-- TankPoints Tooltip --
in what stance
Mob Stats
Mob Level: 60, Mob Damage: 2000
Mob Crit: 5%, Mob Miss: 5%
1 change in each stat = how many TankPoints
-- Reduction Tooltip --
Armor Damage Reduction
MobLevel, PlayerLevel
Combat Table
-- Block Value --
Mob Damage(Raw)
Mob Damage(DR)
Blocked Percentage
Equivalent Block Mitigation(Block% * BlockMod)
-- Spell TP --
Damage Taken Percentage
25%Melee 75%Spell
50%Melee 50%Spell
75%Melee 25%Spell
-- Spell Reduction --
Improved Defense Stance
Reduction for all schools
--]]
-- TankPoints Stat Tooltip
--[[
-- Static
mobLevel, mobDamage
mobCritChance, mobMissChance

-- Dynamic
-- stat name, increase by statValue, increase by 1
-- strength, 1, 1 -- no strength cause it only increases block value by 0.05
agility, 1, 1
stamina, 1.5, 1
armor, 10, 1
resilience, 1, 1
defenseRating, 1, 1
dodgeRating, 1, 1
parryRating, 1, 1
blockRating, 1, 1
blockValue, 1/0.65, 1
--
TankPoints.MeleePerStatTable = {
	-- stat name, increase by statValue
	-- {SPELL_STAT1_NAME, 1}, -- strength
	{SPELL_STAT2_NAME, 1}, -- agility
	{SPELL_STAT3_NAME, 1.5}, -- stamina
	{ARMOR, 10}, -- armor
	{COMBAT_RATING_NAME15, 1}, -- resilience
	{COMBAT_RATING_NAME2, 10}, -- defenseRating
	{COMBAT_RATING_NAME3, 1}, -- dodgeRating
	{COMBAT_RATING_NAME4, 1}, -- parryRating
	{COMBAT_RATING_NAME5, 1}, -- blockRating
	{L["Block Value"], 1/0.65}, -- blockValue
}
--]]


------------------------------------------------------------------------------------------
function TankPoints.TankPointsFrame_OnEnter(frame, motion)
	--self:Debug(motion)
	--local time = GetTime() -- Performance Analysis
	-----------------------
	-- Initialize Tables --
	-----------------------
	local sourceDT = TankPoints.sourceTable
	local resultsDT = TankPoints.resultsTable
	local newDT = {}
	------------------------
	-- Initialize Tooltip --
	------------------------
	local textL, textR
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	-------------
	-- Title Line
	textL = L["TankPoints"].." "..format("%d", resultsDT.tankPoints[TP_MELEE])
	GameTooltip:SetText(textL, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	---------
	-- Stance
	local currentStance = GetShapeshiftForm()
	if currentStance ~= 0 then
		local _, stanceName = GetShapeshiftFormInfo(currentStance)
		if stanceName then
			textL = L["In "]..stanceName
			textR = format("%d%%", resultsDT.damageTakenMod[TP_MELEE] * 100)
			GameTooltip:AddDoubleLine(textL, textR, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		end
	end
	------------
	-- Mob Stats
	textL = L["Mob Stats"]
	GameTooltip:AddLine(textL, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	-- Mob Level: 60, Mob Damage: 2000
	textL = L["Mob Level"]..": "..resultsDT.mobLevel..", "..L["Mob Damage"]..": "..format("%d", resultsDT.mobDamage)
	GameTooltip:AddLine(textL, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	-- Mob Crit: 5%, Mob Miss: 5%
	textL = L["Mob Crit"]..": "..format("%.2f", resultsDT.mobCritChance * 100).."%, "..L["Mob Miss"]..": "..format("%.2f", resultsDT.mobMissChance * 100).."%"
	GameTooltip:AddLine(textL, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	--[[
	TankPoints Per StatValue
	1 Agility =
	1.5 Stamina =
	10 Armor =
	1 Resilience =
	1 Defense Rating =
	1 Dodge Rating =
	1 Parry Rating =
	1 Block Rating =
	1/0.65 Block Value =
	TankPoints.MeleePerStatTable = {
		-- stat name, increase by statValue
		-- {SPELL_STAT1_NAME, 1}, -- strength
		{SPELL_STAT2_NAME, 1}, -- agility
		{SPELL_STAT3_NAME, 1.5}, -- stamina
		{ARMOR, 10}, -- armor
		{COMBAT_RATING_NAME15, 1}, -- resilience
		{COMBAT_RATING_NAME2, 1}, -- defenseRating
		{COMBAT_RATING_NAME3, 1}, -- dodgeRating
		{COMBAT_RATING_NAME4, 1}, -- parryRating
		{COMBAT_RATING_NAME5, 1}, -- blockRating
		{L["Block Value"], 1/0.65}, -- blockValue
	}
	TankPoints:GetSourceData([TP_Table], [school])
	TankPoints:GetTankPoints([TP_Table], [school])
	--]]
	------------------------------
	-- TankPoints Per StatValue --
	------------------------------
	-- Press Alt key for Per Stat TankPoints
	local alt = IsAltKeyDown()
	if alt then
		textL = L["Per Stat"]
	else
		textL = L["Per StatValue"]
	end
	textR = L["TankPoints"]
	GameTooltip:AddDoubleLine(textL, textR, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)

	-------------
	-- Agility --
	-------------
	-- 1 Agi = 2 Armor
	-- 1 Agi = StatLogic:GetDodgePerAgi() dodge%
	copyTable(newDT, sourceDT) -- load default data

	textL = "1 "..SPELL_STAT2_NAME.." = "
	newDT.armor = newDT.armor + 2
	newDT.dodgeChance = newDT.dodgeChance + StatLogic:GetStatMod("MOD_AGI") * StatLogic:GetDodgePerAgi() * 0.01
	TankPoints:GetTankPoints(newDT, TP_MELEE)
	textR = format("%.1f", newDT.tankPoints[TP_MELEE] - resultsDT.tankPoints[TP_MELEE])..L[" TP"]
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	-------------
	-- Stamina --
	-------------
	-- 1 Sta = 10 * StatLogic:GetStatMod("MOD_HEALTH") HP
	copyTable(newDT, sourceDT) -- load default data
	if alt then
		textL = "1 "..SPELL_STAT3_NAME.." = "

		newDT.playerHealth = newDT.playerHealth + 10 * StatLogic:GetStatMod("MOD_HEALTH")
	else
		textL = "1.5 "..SPELL_STAT3_NAME.." = "
		newDT.playerHealth = newDT.playerHealth + 1.5 * 10 * StatLogic:GetStatMod("MOD_HEALTH")
	end
	TankPoints:GetTankPoints(newDT, TP_MELEE)
	textR = format("%.1f", newDT.tankPoints[TP_MELEE] - resultsDT.tankPoints[TP_MELEE])..L[" TP"]
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	-----------
	-- Armor --
	-----------
	copyTable(newDT, sourceDT) -- load default data
	local armorMod = StatLogic:GetStatMod("MOD_ARMOR")
	if alt then
		textL = "1 "..ARMOR.." = "
		newDT.armor = newDT.armor + 1 * armorMod
	else
		textL = "10 "..ARMOR.." = "
		newDT.armor = newDT.armor + 10 * armorMod
	end
	TankPoints:GetTankPoints(newDT, TP_MELEE)
	textR = format("%.1f", newDT.tankPoints[TP_MELEE] - resultsDT.tankPoints[TP_MELEE])..L[" TP"]
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	----------------
	-- Resilience --
	----------------
	copyTable(newDT, sourceDT) -- load default data
	textL = "1 "..COMBAT_RATING_NAME15.." = "
	newDT.resilience = newDT.resilience + 1
	TankPoints:GetTankPoints(newDT, TP_MELEE)
	textR = format("%.1f"..L[" TP"], newDT.tankPoints[TP_MELEE] - resultsDT.tankPoints[TP_MELEE])
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	--------------------
	-- Defense Rating --
	--------------------
	copyTable(newDT, sourceDT) -- load default data
	if alt then
		textL = "1 "..DEFENSE.." = "
		newDT.defense = newDT.defense + 1
		newDT.dodgeChance = newDT.dodgeChance + 0.0004
		newDT.parryChance = newDT.parryChance + 0.0004
		newDT.blockChance = newDT.blockChance + 0.0004
	else
		textL = "1 "..COMBAT_RATING_NAME2.." = "
		newDT.defense = newDT.defense + StatLogic:GetEffectFromRating(1, CR_DEFENSE_SKILL, newDT.playerLevel)
		newDT.dodgeChance = newDT.dodgeChance + 0.0004 * StatLogic:GetEffectFromRating(1, CR_DEFENSE_SKILL, newDT.playerLevel)
		newDT.parryChance = newDT.parryChance + 0.0004 * StatLogic:GetEffectFromRating(1, CR_DEFENSE_SKILL, newDT.playerLevel)
		newDT.blockChance = newDT.blockChance + 0.0004 * StatLogic:GetEffectFromRating(1, CR_DEFENSE_SKILL, newDT.playerLevel)
	end
	TankPoints:GetTankPoints(newDT, TP_MELEE)
	textR = format("%.1f"..L[" TP"], newDT.tankPoints[TP_MELEE] - resultsDT.tankPoints[TP_MELEE])
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	------------------
	-- Dodge Rating --
	------------------
	copyTable(newDT, sourceDT) -- load default data
	if alt then
		textL = "1% "..DODGE.." = "
		newDT.dodgeChance = newDT.dodgeChance + 0.01
	else
		textL = "1 "..COMBAT_RATING_NAME3.." = "
		newDT.dodgeChance = newDT.dodgeChance + StatLogic:GetEffectFromRating(1, CR_DODGE, newDT.playerLevel) * 0.01
	end
	TankPoints:GetTankPoints(newDT, TP_MELEE)
	textR = format("%.1f"..L[" TP"], newDT.tankPoints[TP_MELEE] - resultsDT.tankPoints[TP_MELEE])
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	------------------
	-- Parry Rating --
	------------------
	copyTable(newDT, sourceDT) -- load default data
	if alt then
		textL = "1% "..PARRY.." = "
		newDT.parryChance = newDT.parryChance + 0.01
	else
		textL = "1 "..COMBAT_RATING_NAME4.." = "
		newDT.parryChance = newDT.parryChance + StatLogic:GetEffectFromRating(1, CR_PARRY, newDT.playerLevel) * 0.01
	end
	TankPoints:GetTankPoints(newDT, TP_MELEE)
	textR = format("%.1f"..L[" TP"], newDT.tankPoints[TP_MELEE] - resultsDT.tankPoints[TP_MELEE])
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	------------------
	-- Block Rating --
	------------------
	copyTable(newDT, sourceDT) -- load default data
	if alt then
		textL = "1% "..BLOCK.." = "
		newDT.blockChance = newDT.blockChance + 0.01
	else
		textL = "1 "..COMBAT_RATING_NAME5.." = "
		newDT.blockChance = newDT.blockChance + StatLogic:GetEffectFromRating(1, CR_BLOCK, newDT.playerLevel) * 0.01
	end
	TankPoints:GetTankPoints(newDT, TP_MELEE)
	textR = format("%.1f"..L[" TP"], newDT.tankPoints[TP_MELEE] - resultsDT.tankPoints[TP_MELEE])
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	-----------------
	-- Block Value --
	-----------------
	copyTable(newDT, sourceDT) -- load default data
	if alt then
		textL = "1 "..L["Block Value"].." = "
		newDT.blockValue = newDT.blockValue + StatLogic:GetStatMod("MOD_BLOCK_VALUE")
	else
		textL = format("%.2f", 1/0.65).." "..L["Block Value"].." = "
		newDT.blockValue = newDT.blockValue + 1/0.65 * StatLogic:GetStatMod("MOD_BLOCK_VALUE")
	end
	TankPoints:GetTankPoints(newDT, TP_MELEE)
	textR = format("%.1f"..L[" TP"], newDT.tankPoints[TP_MELEE] - resultsDT.tankPoints[TP_MELEE])
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	------------------------------------
	-- Press ALT for Per Stat TankPoints
	textL = L["Hold ALT for Per Stat TankPoints"]
	GameTooltip:AddLine(textL, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)

	GameTooltip:Show()

	-- Performance Analysis
	-- Before copyTable: 0.25秒
	-- After copyTable: 0.03秒
	--self:Debug(format("%.4f", GetTime() - time))
end

------------------------------------------------------------------------------------------
--[[
Melee Damage Reduction
Armor Damage Reduction
MobLevel, PlayerLevel
Combat Table
--]]
function TankPoints.MeleeReductionFrame_OnEnter(frame, motion)
	local resultsDT = TankPoints.resultsTable
	local textL, textR
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	-------------
	-- Title Line
	textL = TankPoints.SchoolName[TP_MELEE]..L[" Damage Reduction"].." "..format("%.2f%%", resultsDT.totalReduction[TP_MELEE] * 100)
	GameTooltip:SetText(textL, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)

	-------------------------
	-- Armor Damage Reduction
	textL = ARMOR..L[" Damage Reduction"]..":"
	textR = format("%.2f%%", resultsDT.armorReduction * 100)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	-- Mob Level: 60, Player Level: 60
	textL = L["Mob Level"]..": "..resultsDT.mobLevel..", "..L["Player Level"]..": "..format("%d", resultsDT.playerLevel)
	GameTooltip:AddLine(textL, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	---------------
	-- Combat Table
	textL = L["Combat Table"]
	GameTooltip:AddLine(textL, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)

	-- Miss --
	textL = MISS..":"
	textR = format("%.2f%%", resultsDT.mobMissChance * 100)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	-- Dodge --
	textL = DODGE..":"
	textR = format("%.2f%%", resultsDT.dodgeChance * 100)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	-- Parry --
	textL = PARRY..":"
	textR = format("%.2f%%", resultsDT.parryChance * 100)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	-- Block --
	textL = BLOCK..":"
	textR = format("%.2f%%", resultsDT.blockChance * 100)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	-- Crit --
	textL = L["Crit"]..":"
	textR = format("%.2f%%", resultsDT.mobCritChance * 100)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	-- Crushing --
	textL = L["Crushing"]..":"
	textR = format("%.2f%%", resultsDT.mobCrushChance * 100)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	-- Hit --
	textL = L["Hit"]..":"
	textR = format("%.2f%%", (1 - resultsDT.mobCrushChance - resultsDT.mobCritChance - resultsDT.blockChance - resultsDT.parryChance - resultsDT.dodgeChance - resultsDT.mobMissChance) * 100)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	GameTooltip:Show()
end

------------------------------------------------------------------------------------------
--[[
Mob Damage(Raw):
Mob Damage(DR):
Blocked Percentage:
Equivalent Block Mitigation:
--]]
function TankPoints.BlockValueFrame_OnEnter(frame, motion)
	local resultsDT = TankPoints.resultsTable
	local textL, textR
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	-------------
	-- Title Line
	textL = L["Block Value"].." "..format("%d", resultsDT.blockValue)
	GameTooltip:SetText(textL, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)

	-----------------------
	-- Mob Damage before DR
	textL = L["Mob Damage before DR"]..":"
	textR = format("%d", TankPoints:GetMobDamage(resultsDT.mobLevel))
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	----------------------
	-- Mob Damage after DR
	textL = L["Mob Damage after DR"]..":"
	textR = format("%d", resultsDT.mobDamage)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	---------------------
	-- Blocked Percentage
	textL = L["Blocked Percentage"]..":"
	textR = format("%.2f%%", resultsDT.blockedMod * 100)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	---------------
	-- Block Chance
	textL = BLOCK_CHANCE..":"
	textR = format("%.2f%%", resultsDT.blockChance * 100)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	------------------------------
	-- Equivalent Block Mitigation
	textL = L["Equivalent Block Mitigation"]..":"
	textR = format("%.2f%%", resultsDT.blockChance * resultsDT.blockedMod * 100)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	-----------------------
	-- Shield Block Up Time
	if TankPoints.playerClass == "WARRIOR" then
		textL = L["Shield Block Up Time"]..":"
		textR = format("%.2f%%", (resultsDT.shieldBlockUpPercent or 0) * 100)
		GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end

	GameTooltip:Show()
end

------------------------------------------------------------------------------------------
--[[
TankPoints Considering Melee/Spell Damage Ratio
25% Melee Damage + 75% Spell Damage:
50% Melee Damage + 50% Spell Damage:
75% Melee Damage + 25% Spell Damage:
--]]
function TankPoints.SpellTankPointsFrame_OnEnter(frame, motion)
	--TankPoints:Debug("SpellTankPointsFrame_OnEnter")
	local resultsDT = TankPoints.resultsTable
	local textL, textR
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	-------------------
	-- Spell TankPoints
	textL = TankPoints.SchoolName[TankPoints.currentSchool].." "..L["TankPoints"].." "..format("%d", resultsDT.tankPoints[TankPoints.currentSchool])
	GameTooltip:SetText(textL, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	---------
	-- Stance
	local currentStance = GetShapeshiftForm()
	if currentStance ~= 0 then
		local _, stanceName = GetShapeshiftFormInfo(currentStance)
		if stanceName then
			textL = L["In "]..stanceName
			textR = format("%d%%", resultsDT.damageTakenMod[TankPoints.currentSchool] * 100)
			GameTooltip:AddDoubleLine(textL, textR, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		end
	end
	--------------------------------------------------
	-- TankPoints Considering Melee/Spell Damage Ratio
	textL = L["Melee/Spell Damage Ratio"]
	textR = L["TankPoints"]
	GameTooltip:AddDoubleLine(textL, textR, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	--------------------------------------
	-- 25% Melee Damage + 75% Spell Damage
	textL = "25% "..TankPoints.SchoolName[TP_MELEE].." + 75% "..TankPoints.SchoolName[TankPoints.currentSchool]..":"
	textR = format("%d", resultsDT.tankPoints[TP_MELEE] * 0.25 + resultsDT.tankPoints[TankPoints.currentSchool] * 0.75)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	--------------------------------------
	-- 50% Melee Damage + 50% Spell Damage
	textL = "50% "..TankPoints.SchoolName[TP_MELEE].." + 50% "..TankPoints.SchoolName[TankPoints.currentSchool]..":"
	textR = format("%d", resultsDT.tankPoints[TP_MELEE] * 0.50 + resultsDT.tankPoints[TankPoints.currentSchool] * 0.50)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	--------------------------------------
	-- 75% Melee Damage + 25% Spell Damage
	textL = "75% "..TankPoints.SchoolName[TP_MELEE].." + 25% "..TankPoints.SchoolName[TankPoints.currentSchool]..":"
	textR = format("%d", resultsDT.tankPoints[TP_MELEE] * 0.75 + resultsDT.tankPoints[TankPoints.currentSchool] * 0.25)
	GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)

	---------------------------------
	-- Left click: Show next school
	textL = L["Left click: Show next school"]
	GameTooltip:AddLine(textL, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	---------------------------------
	-- Right click: Show strongest school
	textL = L["Right click: Show strongest school"]
	GameTooltip:AddLine(textL, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	-----------------
	-- Current School
	textL = ""
	local color
	if TP_HOLY == TankPoints.currentSchool then
		color = HIGHLIGHT_FONT_COLOR_CODE
	else
		color = GRAY_FONT_COLOR_CODE
	end
	textL = textL..color..TankPoints.SchoolName[TP_HOLY]..GRAY_FONT_COLOR_CODE
	for s = TP_FIRE, TP_ARCANE do
		if s == TankPoints.currentSchool then
			color = HIGHLIGHT_FONT_COLOR_CODE
		else
			color = GRAY_FONT_COLOR_CODE
		end
		textL = textL.."->"..color..TankPoints.SchoolName[s]..GRAY_FONT_COLOR_CODE
	end
	textL = textL..FONT_COLOR_CODE_CLOSE
	GameTooltip:AddLine(textL)

	GameTooltip:Show()
end

------------------------------------------------------------------------------------------
--[[
Improved Defense Stance
Reduction for all schools
--]]
function TankPoints.SpellReductionFrame_OnEnter(frame, motion)
	local resultsDT = TankPoints.resultsTable
	local textL, textR
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	-------------
	-- Title Line
	textL = TankPoints.SchoolName[TankPoints.currentSchool]..L[" Damage Reduction"].." "..format("%.2f%%", resultsDT.totalReduction[TankPoints.currentSchool] * 100)
	GameTooltip:SetText(textL, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	----------------------------
	-- Reduction for all schools
	for s = TP_HOLY, TP_ARCANE do
		textL = _G["DAMAGE_SCHOOL"..s]
		textR = format("%.2f%%", resultsDT.totalReduction[s] * 100)
		GameTooltip:AddDoubleLine(textL, textR, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		GameTooltip:AddTexture("Interface\\PaperDollInfoFrame\\SpellSchoolIcon"..s);
	end
	
	---------------------------------
	-- Left click: Show next school
	textL = L["Left click: Show next school"]
	GameTooltip:AddLine(textL, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	---------------------------------
	-- Right click: Show strongest school
	textL = L["Right click: Show strongest school"]
	GameTooltip:AddLine(textL, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
	-----------------
	-- Current School
	textL = ""
	local color
	if TP_HOLY == TankPoints.currentSchool then
		color = HIGHLIGHT_FONT_COLOR_CODE
	else
		color = GRAY_FONT_COLOR_CODE
	end
	textL = textL..color..TankPoints.SchoolName[TP_HOLY]..GRAY_FONT_COLOR_CODE
	for s = TP_FIRE, TP_ARCANE do
		if s == TankPoints.currentSchool then
			color = HIGHLIGHT_FONT_COLOR_CODE
		else
			color = GRAY_FONT_COLOR_CODE
		end
		textL = textL.."->"..color..TankPoints.SchoolName[s]..GRAY_FONT_COLOR_CODE
	end
	textL = textL..FONT_COLOR_CODE_CLOSE
	GameTooltip:AddLine(textL)
	
	GameTooltip:Show()
end

---------------------
-- TankPoints Core --
---------------------
--[[
armorReductionTemp = armor / ((85 * levelModifier) + 400)
armorReduction = armorReductionTemp / (armorReductionTemp + 1)
defenseEffect = (defense - attackerLevel * 5) * 0.04 * 0.01
blockValueFromStrength = (strength * 0.05) - 1
blockValue = floor(blockValueFromStrength) + floor((blockValueFromItems + blockValueFromShield) * blockValueMod)
mobDamage = (levelModifier * 55) * meleeTakenMod * (1 - armorReduction)
resilienceEffect = StatLogic:GetEffectFromRating(resilience, playerLevel) * 0.01
mobCritChance = max(0, 0.05 - defenseEffect - resilienceEffect)
mobCritBonus = 1
mobMissChance = max(0, 0.05 + defenseEffect)
mobCrushChance = 0.15 + max(0, (playerLevel * 5 - defense) * 0.02) (if mobLevel is +3)
mobCritDamageMod = max(0, 1 - resilienceEffect * 2)
blockedMod = min(1, blockValue / mobDamage)
mobSpellCritChance = max(0, 0 - resilienceEffect)
mobSpellCritBonus = 0.5
mobSpellMissChance = 0
mobSpellCritDamageMod = max(0, 1 - resilienceEffect * 2)
schoolReduction[SCHOOL] = 0.75 * (resistance[SCHOOL] / (mobLevel * 5))
totalReduction[MELEE] = 1 - ((mobCritChance * (1 + mobCritBonus) * mobCritDamageMod) + (mobCrushChance * 1.5) + (1 - mobCrushChance - mobCritChance - blockChance * blockedMod - parryChance - dodgeChance - mobMissChance)) * (1 - armorReduction) * meleeTakenMod
totalReduction[SCHOOL] = 1 - ((mobSpellCritChance * (1 + mobSpellCritBonus) * mobSpellCritDamageMod) + (1 - mobSpellCritChance - mobSpellMissChance)) * (1 - schoolReduction[SCHOOL]) * spellTakenMod
tankPoints = playerHealth / (1 - totalReduction)
--]]
function TankPoints:GetArmorReduction(armor, attackerLevel)
	local levelModifier = attackerLevel
	if ( levelModifier > 59 ) then
		levelModifier = levelModifier + (4.5 * (levelModifier - 59))
	end
	local temp = armor / (85 * levelModifier + 400)
	local armorReduction = temp / (1 + temp)
	-- caps at 75%
	if armorReduction > 0.75 then
		armorReduction = 0.75
	end
	if armorReduction < 0 then
		armorReduction = 0
	end
	return armorReduction
end

function TankPoints:GetDefenseEffect(defense, attackerLevel)
	return (defense - attackerLevel * 5) * 0.04 * 0.01
end

function TankPoints:GetDefense()
	local base, modifier = UnitDefense("player");
	return base + modifier
end

function TankPoints:ShieldIsEquipped()
	--local _, _, _, _, _, _, itemSubType = GetItemInfo(GetInventoryItemLink("player", 17) or "")
	--return itemSubType == L["Shields"]
	return IsEquippedItemType("INVTYPE_SHIELD")
end

-- Returns your shield block value, Whitetooth@Cenarius (hotdogee@bahamut.twbbs.org)
function TankPoints:GetBlockValue(strength, forceShield)
	-- Block from Strength
	-- Talents: Pal, War
	-- (%d+) Block (on shield)
	-- %+(%d+) Block Value (ZG enchant)
	-- Equip: Increases the block value of your shield by (%d+)
	-- Set: Increases the block value of your shield by (%d+)
	-------------------------------------------------------
	-- Get Block Value from shield if shield is equipped --
	-------------------------------------------------------
	if (not self:ShieldIsEquipped()) and (forceShield ~= true) then -- doesn't have shield equipped
		return 0
	end
	-----------------------------------
	-- Get Block Value from strength --
	-----------------------------------
	if not strength then
		_, strength = UnitStat("player", 1)
	end
	local blockValueFromStrength = max(0, (strength * 0.05) - 1)
	--------------------------------
	-- Get Block Value from items --
	--------------------------------
	local blockValueFromItems = 0
	local scannedSets = {} -- table to flag scanned sets so we don't scan twice
	for slot = 1, 18 do -- equipped item's slotID 1 to 18
		local itemsum = StatLogic:GetSum(GetInventoryItemLink("player", slot))
		if type(itemsum) == "table" then
			blockValueFromItems = blockValueFromItems + (itemsum["BLOCK_VALUE"] or 0)
		end
		Gratuity:SetInventoryItem("player", slot) -- set tooltip
		for i = 2, Gratuity:NumLines() do -- loop through lines
			local line = Gratuity:GetLine(i)
			local setName, _, setTotal = Deformat(line, ITEM_SET_NAME)
			if setName then
				if not scannedSets[setName] then
					scannedSets[setName] = true -- flag scanned
					for j = i + setTotal + 2, Gratuity:NumLines() do
						-- ITEM_SET_BONUS =
						-- Check if set bonus is enabled
						line = Deformat(Gratuity:GetLine(j), ITEM_SET_BONUS)
						if line then
							-- scan for block value
							for _, pattern in ipairs(L["ItemScan"][TP_BLOCKVALUE]) do
								local _, _, num = strfind(line, pattern[1])
								blockValueFromItems = blockValueFromItems + (num or 0)
							end
						end
					end
				end
				break -- break out to next slot
			end
		end
	end
	-----------------------
	-- Final Calculation --
	-----------------------
	-- Tested to be separate floors by Whitetooth@Cenarius (hotdogee@bahamut.twbbs.org)
	blockValue = floor(blockValueFromStrength) + floor(blockValueFromItems * StatLogic:GetStatMod("MOD_BLOCK_VALUE") + 0.499)
	return blockValue, blockValueFromStrength, blockValueFromItems * StatLogic:GetStatMod("MOD_BLOCK_VALUE")
end

------------------------------------
-- mobDamage, for factoring in block
-- I designed this formula with the goal to model the normal damage of a raid boss at your level
-- the level modifier was taken from the armor reduction formula to base the level effects
-- at level 63 mobDamage is 4455, this is what Nefarian does before armor reduction
-- at level 73 mobDamage is 6518, which matches TBC raid bosses
function TankPoints:GetMobDamage(mobLevel)
	if profileDB.mobDamage and profileDB.mobDamage ~= 0 then
		return profileDB.mobDamage
	end
	local levelMod = mobLevel
	if ( levelMod > 59 ) then
		levelMod = levelMod + (4.5 * (levelMod - 59))
	end
	return levelMod * 55 -- this is the value before mitigation, which we will do in GetTankPoints
end


------------------------
-- Shield Block Skill --
------------------------

-- TankPoints:GetShieldBlockOnTime(4, 1, 70, nil)
function TankPoints:GetShieldBlockOnTime(atkCount, mobAtkSpeed, blockChance, talant)
	local time = 0
	if blockChance > 1 then
		blockChance = blockChance * 0.01
	end
	if not talant then
		--[[
		Block =    70.0% = 50.0%
		------------
		NNNN = 4 =  2.7% = 12.5% = 4 下平均是 3.5 * mobAtkSpeed秒
		NNB  = 3 =  6.3% = 12.5% = 3 下平均是 2.5 * mobAtkSpeed秒
		NB   = 2 = 21.0% = 25.0% = 2 下平均是 1.5 * mobAtkSpeed秒
		B    = 1 = 70.0% = 50.0% = 1 下平均是 0.5 * mobAtkSpeed秒
		--]]
		if ((atkCount - 1) * mobAtkSpeed) > 5 then
			atkCount = ceil(5 / mobAtkSpeed)
		end
		for c = 1, atkCount do
			if c == atkCount then
				time = time + ((1 - blockChance) ^ (c - 1)) * (c - 0.5) * mobAtkSpeed
				--TankPoints:Print((((1 - blockChance) ^ (c - 1)) * 100).."%")
			else
				time = time + blockChance * ((1 - blockChance) ^ (c - 1)) * (c - 0.5) * mobAtkSpeed
				--TankPoints:Print((blockChance * ((1 - blockChance) ^ (c - 1)) * 100).."%")
			end
		end
		if atkCount <= 0 then
			time = 5
		end
	else
		--[[
		Block =     70.0% = 50.0%
		------------
		NNN   = 4 =  2.7% = 12.5%
		BNN   = 4 =  6.3% = 12.5%
		NBN   = 4 =  6.3% = 12.5%
		NNB   = 4 =  6.3% = 12.5%
		BNB   = 3 = 14.7% = 12.5%
		NBB   = 3 = 14.7% = 12.5%
		BB    = 2 = 49.0% = 24.0%
		--]]
		if ((atkCount - 1) * mobAtkSpeed) > 6 then
			atkCount = ceil(6 / mobAtkSpeed)
		end
		for c = 2, atkCount do
			if c == atkCount then
				time = time + ((blockChance * ((1 - blockChance) ^ (c - 2)) * (c - 1)) + ((1 - blockChance) ^ (c - 1))) * (c - 0.5) * mobAtkSpeed
				--TankPoints:Print((((blockChance * ((1 - blockChance) ^ (c - 2)) * (c - 1)) + ((1 - blockChance) ^ (c - 1))) * 100).."%")
			else
				time = time + blockChance * blockChance * ((1 - blockChance) ^ (c - 2)) * (c - 1) * (c - 0.5) * mobAtkSpeed
				--TankPoints:Print((blockChance * blockChance * ((1 - blockChance) ^ (c - 2)) * (c - 1) * 100).."%")
			end
		end
		if atkCount <= 1 then
			time = 6
		end
	end
	return time
end

-- TankPoints:GetShieldBlockUpPercent(10, 2, 55, 1)
function TankPoints:GetShieldBlockUpPercent(timeBetweenPresses, mobAtkSpeed, blockChance, talant)
	local shieldBlockDuration = 5
	if talant then
		shieldBlockDuration = 6
	end
	local avgAttackCount = shieldBlockDuration / mobAtkSpeed
	local min = floor(avgAttackCount)
	local percentage = avgAttackCount - floor(avgAttackCount)
	local avgOnTime = self:GetShieldBlockOnTime(min, mobAtkSpeed, blockChance, talant) * (1 - percentage) + 
	                  self:GetShieldBlockOnTime(min + 1, mobAtkSpeed, blockChance, talant) * percentage
	return avgOnTime / timeBetweenPresses
end


----------------
-- TankPoints --
----------------
--[[
TankPoints:GetSourceData([TP_Table], [school], [forceShield])
TankPoints:AlterSourceData(TP_Table, changes, [forceShield])
TankPoints:CheckSourceData(TP_Table, [school], [forceShield])
TankPoints:GetTankPoints([TP_Table], [school], [forceShield])
-- school
TP_RANGED = 0
TP_MELEE = 1
TP_HOLY = 2
TP_FIRE = 3
TP_NATURE = 4
TP_FROST = 5
TP_SHADOW = 6
TP_ARCANE = 7

-- TP_Table Inputs
{
	playerLevel = ,
	playerHealth = ,
	playerClass = ,
	mobLevel = ,
	resilience = ,
	-- Melee
	mobCritChance = 0.05, -- talant effects
	mobCritBonus = 1,
	mobMissChance = 0.05,
	armor = ,
	defense = ,
	dodgeChance = ,
	parryChance = ,
	blockChance = ,
	blockValue = ,
	mobDamage = ,
	mobCritDamageMod = , -- from talants
	-- Spell
	mobSpellCritChance = 0, -- talant effects
	mobSpellCritBonus = 0.5,
	mobSpellMissChance = 0, -- this should change with mobLevel, but we don't have enough data yet
	resistance = {
		[TP_HOLY] = 0,
		[TP_FIRE] = ,
		[TP_NATURE] = ,
		[TP_FROST] = ,
		[TP_SHADOW] = ,
		[TP_ARCANE] = ,
	},
	mobSpellCritDamageMod = , -- from talants
	-- All
	damageTakenMod = {
		[TP_MELEE] = ,
		[TP_HOLY] = ,
		[TP_FIRE] = ,
		[TP_NATURE] = ,
		[TP_FROST] = ,
		[TP_SHADOW] = ,
		[TP_ARCANE] = ,
	},
}
-- TP_Table Output adds calculated fields to the table
{
	resilienceEffect = ,
	-- Melee - Added
	armorReduction = ,
	defenseEffect = ,
	mobCrushChance = ,
	mobCritDamageMod = , -- from resilience
	blockedMod = ,
	-- Melee - Changed
	mobMissChance = ,
	dodgeChance = ,
	parryChance = ,
	blockChance = ,
	mobCritChance = ,
	mobDamage = ,
	-- Spell - Added
	mobSpellCritDamageMod = ,
	-- Spell - Changed
	mobSpellCritChance = ,
	-- Results
	schoolReduction = {
		[TP_MELEE] = , -- armorReduction
		[TP_HOLY] = ,
		[TP_FIRE] = ,
		[TP_NATURE] = ,
		[TP_FROST] = ,
		[TP_SHADOW] = ,
		[TP_ARCANE] = ,
	},
	totalReduction = {
		[TP_MELEE] = ,
		[TP_HOLY] = ,
		[TP_FIRE] = ,
		[TP_NATURE] = ,
		[TP_FROST] = ,
		[TP_SHADOW] = ,
		[TP_ARCANE] = ,
	},
	tankPoints = {
		[TP_MELEE] = ,
		[TP_HOLY] = ,
		[TP_FIRE] = ,
		[TP_NATURE] = ,
		[TP_FROST] = ,
		[TP_SHADOW] = ,
		[TP_ARCANE] = ,
	},
}
--]]

--[[---------------------------------
{	:GetSourceData(TP_Table, school, forceShield)
-------------------------------------
-- Description
	GetSourceData is the slowest function here, dont call it unless you are sure the stats have changed.
-- Arguments
	[TP_Table]
	    table - obtained data is to be stored in this table
	[school]
	    number - specify a school id to get only data for that school
			TP_RANGED = 0
			TP_MELEE = 1
			TP_HOLY = 2
			TP_FIRE = 3
			TP_NATURE = 4
			TP_FROST = 5
			TP_SHADOW = 6
			TP_ARCANE = 7
	[forceShield]
		bool - arg added for tooltips
			true: force shield on
			false: force shield off
			nil: check if user has shield equipped
-- Returns
	TP_Table
	    table - obtained data is to be stored in this table
-- Examples
}
-----------------------------------]]
function TankPoints:GetSourceData(TP_Table, school, forceShield)
	if not TP_Table then
		-- Acquire temp table
		TP_Table = {}
	end
	-- Unit
	local unit = "player"
	TP_Table.playerLevel = UnitLevel(unit)
	TP_Table.playerHealth = UnitHealthMax(unit)
	TP_Table.playerClass = self.playerClass
	TP_Table.mobLevel = UnitLevel(unit) + self.db.profile.mobLevelDiff
	-- Resilience
	TP_Table.resilience = GetCombatRating(CR_CRIT_TAKEN_MELEE)
	TP_Table.damageTakenMod = {}
	----------------
	-- Melee Data --
	----------------
	if (not school) or school == TP_MELEE then
		-- Mob's Default Crit and Miss Chance
		TP_Table.mobCritChance = self.db.profile.mobCritChance + StatLogic:GetStatMod("ADD_CRIT_TAKEN", "MELEE")
		TP_Table.mobCritBonus = self.db.profile.mobCritBonus
		TP_Table.mobMissChance = self.db.profile.mobMissChance - StatLogic:GetStatMod("ADD_HIT_TAKEN", "MELEE")
		-- Armor
		_, TP_Table.armor = UnitArmor(unit)
		-- Defense
		TP_Table.defense = self:GetDefense()
		-- Dodge, Parry
		-- 2.0.2.6144 includes defense factors in these functions
		TP_Table.dodgeChance = GetDodgeChance() * 0.01-- + TP_Table.defenseEffect
		TP_Table.parryChance = GetParryChance() * 0.01-- + TP_Table.defenseEffect
		-- Block Chance, Block Value
		-- Check if player has shield or forceShield is set to true
		if (forceShield == true) or ((forceShield == nil) and self:ShieldIsEquipped()) then
			TP_Table.blockChance = GetBlockChance() * 0.01-- + TP_Table.defenseEffect
			TP_Table.blockValue = self:GetBlockValue(nil, forceShield)
		-- (forceShield == false) or ((not forceShield) and (not self:ShieldIsEquipped()))
		else
			TP_Table.blockChance = 0
			TP_Table.blockValue = 0
		end
		-- Melee Taken Mod
		TP_Table.damageTakenMod[TP_MELEE] = StatLogic:GetStatMod("MOD_DMG_TAKEN", "MELEE")
		-- mobDamage, for factoring in block
		TP_Table.mobDamage = self:GetMobDamage(TP_Table.mobLevel)
		-- mobCritDamageMod from talants
		TP_Table.mobCritDamageMod = StatLogic:GetStatMod("MOD_CRIT_DAMAGE_TAKEN", "MELEE")
		-- Mob Attack Speed
		TP_Table.mobAttackSpeed = self.db.profile.mobAttackSpeed
		-- Time in seconds between Shield Block key presses
		TP_Table.playerSBFreq = self.db.profile.playerSBFreq
	end
	----------------
	-- Spell Data --
	----------------
	if (not school) or school > TP_MELEE then
		TP_Table.mobSpellCritChance = self.db.profile.mobSpellCritChance + StatLogic:GetStatMod("ADD_CRIT_TAKEN", "HOLY")
		TP_Table.mobSpellCritBonus = self.db.profile.mobSpellCritBonus
		TP_Table.mobSpellMissChance = self.db.profile.mobSpellMissChance - StatLogic:GetStatMod("ADD_HIT_TAKEN", "HOLY")
		-- Resistances
		TP_Table.resistance = {}
		if not school then
			for s = 2, 6, 1 do
				_, TP_Table.resistance[s + 1] = UnitResistance(unit, s)
			end
			-- Holy Resistance always 0
			TP_Table.resistance[TP_HOLY] = 0
		else
			_, TP_Table.resistance[school] = UnitResistance(unit, school - 1)
		end
		-- Spell Taken Mod
		for s = TP_HOLY, TP_ARCANE, 1 do
			TP_Table.damageTakenMod[s] = StatLogic:GetStatMod("MOD_DMG_TAKEN", schoolIDToString[s])
		end
		-- mobSpellCritDamageMod from talants
		TP_Table.mobSpellCritDamageMod = StatLogic:GetStatMod("MOD_CRIT_DAMAGE_TAKEN", TP_HOLY)
	end

	------------------
	-- Return table --
	------------------
	return TP_Table
end

--[[
changes = {
	-- player stats
	str = ,
	agi = ,
	sta = ,
	playerHealth = ,
	armor = ,
	armorFromItems = ,
	defense = ,
	dodgeChance = ,
	parryChance = ,
	blockChance = ,
	blockValue = ,
	resilience = ,
	-- mob stats
	mobLevel = ,
	mobDamage = ,
}
--]]
-- 1. Players current DataTable is obtained from TP_Table = TankPoints:GetSourceData(newDT, TP_MELEE)
-- 2. Target stat changes are writen in the changes table
-- 3. These 2 tables are passed in TankPoints:AlterSourceData(TP_Table, changes), and it makes changes to TP_Table
-- 4. TP_Table is then passed in TankPoints:GetTankPoints(TP_Table, TP_MELEE), and the results are writen in TP_Table
-- 5. Read the results from TP_Table
function TankPoints:AlterSourceData(tpTable, changes, forceShield)
	local doBlock = (forceShield == true) or ((forceShield == nil) and self:ShieldIsEquipped())
	if changes.str and changes.str ~= 0 then
		------- Formulas -------
		-- str = floor(str * strMod)
		-- blockValue = floor((strength * 0.05) - 1) + floor((blockValueFromItems + blockValueFromShield) * blockValueMod)
		------- Talants -------
		-- Warrior: Vitality (Rank 5) - 3,21
		--          Increases your total Stamina by 1%/2%/3%/4%/5% and your total Strength by 2%/4%/6%/8%/10%.
		-- Paladin: Divine Strength (Rank 5) - 1,1
		--          Increases your total Strength by 2%/4%/6%/8%/10%.
		------------------------
		local _, _, strength = UnitStat("player", 1)
		local strMod = StatLogic:GetStatMod("MOD_STR")
		-- WoW floors numbers after being multiplied by stat mods, so to obtain the original value, you need to ceil it after dividing it with the stat mods
		changes.str = max(0, floor((ceil(strength / strMod) + changes.str) * strMod)) - strength
		-- Check if player has shield equipped
		if doBlock then
			-- Subtract block value from current strength, add block value from new strength
			tpTable.blockValue = tpTable.blockValue - floor((strength * 0.05) - 1) + floor(((strength + changes.str) * 0.05) - 1)
		end
	end
	if changes.agi and changes.agi ~= 0 then
		------- Formulas -------
		-- agi = floor(agi * agiMod)
		-- dodgeChance = baseDodge + dodgeFromRating + dodgeFromAgi + dodgeFromRacial + dodgeFromTalant + dodgeFromDefense
		-- armor = floor((armorFromItem * armorMod) + 0.5) + agi * 2 + posArmorBuff - negArmorBuff
		------- Talants -------
		-- Rogue: Vitality (Rank 2) - 2,20
		--        Increases your total Stamina by 2%/4% and your total Agility by 1%/2%.
		-- Rogue: Sinister Calling (Rank 5) - 3,21
		--        Increases your total Agility by 3%/6%/9%/12%/15%.
		-- Hunter: Combat Experience (Rank 2) - 2,14
		--         Increases your total Agility by 1%/2% and your total Intellect by 3%/6%.
		-- Hunter: Lightning Reflexes (Rank 5) - 3,18
		--         Increases your Agility by 3%/6%/9%/12%/15%.
		------------------------
		local _, _, agility = UnitStat("player", 2)
		local agiMod = StatLogic:GetStatMod("MOD_AGI")
		changes.agi = max(0, floor((ceil(agility / agiMod) + changes.agi) * agiMod)) - agility
		-- Calculate dodge chance
		tpTable.dodgeChance = tpTable.dodgeChance + changes.agi * StatLogic:GetDodgePerAgi() * 0.01
		-- Armor mods don't effect armor from agi
		tpTable.armor = tpTable.armor + changes.agi * 2
	end
	if changes.sta and changes.sta ~= 0 then
		------- Formulas -------
		-- sta = floor(sta * staMod)
		-- By testing with the hunter talants: Endurance Training and Survivalist,
		-- I found that the healthMods are mutiplicative instead of additive, this is the same as armor mod
		-- playerHealth = round((baseHealth + addedHealth + addedSta * 10) * healthMod)
		------- Talants -------
		-- Warrior: Vitality (Rank 5) - 3,21
		--          Increases your total Stamina by 1%/2%/3%/4%/5% and your total Strength by 2%/4%/6%/8%/10%.
		-- Warlock: Demonic Embrace (Rank 5) - 2,3
		--          Increases your total Stamina by 3%/6%/9%/12%/15% but reduces your total Spirit by 1%/2%/3%/4%/5%.
		-- Rogue: Vitality (Rank 2) - 2,20
		--        Increases your total Stamina by 2%/4% and your total Agility by 1%/2%.
		-- Priest: Enlightenment (Rank 5) - 1,20
		--         Increases your total Stamina, Intellect and Spirit by 1%/2%/3%/4%/5%.
		-- Druid: Bear Form - buff (didn't use stance because Bear Form and Dire Bear Form has the same icon)
		--        Shapeshift into a bear, increasing melee attack power by 30, armor contribution from items by 180%, and stamina by 25%.
		-- Druid: Dire Bear Form - buff
		--        Shapeshift into a dire bear, increasing melee attack power by 120, armor contribution from items by 400%, and stamina by 25%.
		------------------------
		local _, _, stamina = UnitStat("player", 3)
		local staMod = StatLogic:GetStatMod("MOD_STA")
		changes.sta = max(0, floor((ceil(stamina / staMod) + changes.sta) * staMod)) - stamina
		-- Calculate player health
		local healthMod = StatLogic:GetStatMod("MOD_HEALTH")
		tpTable.playerHealth = floor(((floor((tpTable.playerHealth / healthMod) + 0.5) + changes.sta * 10) * healthMod) + 0.5)
	end
	if changes.playerHealth and changes.playerHealth ~= 0 then
		------- Formulas -------
		-- By testing with the hunter talants: Endurance Training and Survivalist,
		-- I found that the healMods are mutiplicative instead of additive, this is the same as armor mod
		-- playerHealth = round((baseHealth + addedHealth + addedSta * 10) * healthMod)
		------- Talants -------
		-- Tauren: Endurance (Rank 3)
		--         Total Health increased by 5%.
		-- Warlock: Fel Stamina (Rank 3) - 2,9
		--          Increases the Stamina of your Imp, Voidwalker, Succubus, Felhunter and Felguard by 5%/10%/15% and increases your maximum health by 1%/2%/3%.
		-- Hunter: Survivalist (Rank 5) - 3,9
		--         Increases total health by 2%/4%/6%/8%/10%.
		-- Hunter: Endurance Training (Rank 5) - 1,2
		--         Increases the Health of your pet by 2%/4%/6%/8%/10% and your total health by 1%/2%/3%/4%/5%.
		------------------------
		local healthMod = StatLogic:GetStatMod("MOD_HEALTH")
		tpTable.playerHealth = floor(((floor((tpTable.playerHealth / healthMod) + 0.5) + changes.playerHealth) * healthMod) + 0.5)
	end
	if (changes.armorFromItems and changes.armorFromItems ~= 0) or (changes.armor and changes.armor ~= 0) then
		-- Hunter: Thick Hide (Rank 3) - 1,5
		--         Increases the armor rating of your pets by 20% and your armor contribution from items by 4%/7%/10%.
		-- Druid: Thick Hide (Rank 3) - 2,5
		--        Increases your Armor contribution from items by 4%/7%/10%.
		-- Druid: Bear Form - buff (didn't use stance because Bear Form and Dire Bear Form has the same icon)
		--        Shapeshift into a bear, increasing melee attack power by 30, armor contribution from items by 180%, and stamina by 25%.
		-- Druid: Dire Bear Form - buff
		--        Shapeshift into a dire bear, increasing melee attack power by 120, armor contribution from items by 400%, and stamina by 25%.
		-- Druid: Moonkin Form - buff
		--        While in this form the armor contribution from items is increased by 400%, attack power is increased by 150% of your level and all party members within 30 yards have their spell critical chance increased by 5%.
		-- Shaman: Toughness (Rank 5) - 2,11
		--          Increases your armor value from items by 2%/4%/6%/8%/10%.
		-- Warrior: Toughness (Rank 5) - 3,5
		--          Increases your armor value from items by 2%/4%/6%/8%/10%.
		------------------------
		-- Make sure armorFromItems and armor aren't nil
		changes.armorFromItems = changes.armorFromItems or 0
		changes.armor = changes.armor or 0
		local armorMod = StatLogic:GetStatMod("MOD_ARMOR")
		local _, _, _, pos, neg = UnitArmor("player")
		local _, agility = UnitStat("player", 2)
		if changes.agi then
			agility = agility + changes.agi
		end
		-- Armor is treated different then stats, 小數點採四捨五入法
		--local armorFromItem = floor(((tpTable.armor - agility * 2 - pos + neg) / armorMod) + 0.5)
		--tpTable.armor = floor(((armorFromItem + changes.armor) * armorMod) + 0.5) + agility * 2 + pos - neg
		--(floor((ceil(stamina / staMod) + changes.sta) * staMod) - stamina)
		tpTable.armor = floor(((floor(((tpTable.armor - agility * 2 - pos + neg) / armorMod) + 0.5) + changes.armorFromItems) * armorMod) + 0.5) + agility * 2 + pos - neg + changes.armor
		--self:Print(tpTable.armor.." = floor(((floor((("..tpTable.armor.." - "..agility.." * 2 - "..pos.." + "..neg..") / "..armorMod..") + 0.5) + "..changes.armor..") * "..armorMod..") + 0.5) + "..agility.." * 2 + "..pos.." - "..neg)
	end
	if changes.defense and changes.defense ~= 0 then
		tpTable.defense = tpTable.defense + changes.defense
		tpTable.dodgeChance = tpTable.dodgeChance + changes.defense * 0.0004
		if GetParryChance() ~= 0 then
			tpTable.parryChance = tpTable.parryChance + changes.defense * 0.0004
		end
		if doBlock then
			tpTable.blockChance = tpTable.blockChance + changes.defense * 0.0004
		end
	end
	if changes.dodgeChance and changes.dodgeChance ~= 0 then
		tpTable.dodgeChance = tpTable.dodgeChance + changes.dodgeChance
	end
	if changes.parryChance and changes.parryChance ~= 0 then
		if GetParryChance() ~= 0 then
			tpTable.parryChance = tpTable.parryChance + changes.parryChance
		end
	end
	if changes.blockChance and changes.blockChance ~= 0 then
		if doBlock then
			tpTable.blockChance = tpTable.blockChance + changes.blockChance
		end
	end
	if changes.blockValue and changes.blockValue ~= 0 then
		-- Warrior: Shield Mastery (Rank 3) - 3,16
		--          Increases the amount of damage absorbed by your shield by 10%/20%/30%.
		-- Paladin: Shield Specialization (Rank 3) - 2,8
		--          Increases the amount of damage absorbed by your shield by 10%/20%/30%.
		-- Shaman: Shield Specialization (Rank 5) - 2,2

		--         Increases your chance to block attacks with a shield by 5% and increases the amount blocked by 5%/10%/15%/20%/25%.
		if doBlock then
			local blockValueMod = StatLogic:GetStatMod("MOD_BLOCK_VALUE")
			local _, strength = UnitStat("player", 1)
			if changes.str then
				strength = strength + changes.str
			end
			tpTable.blockValue = floor((ceil((tpTable.blockValue - floor((strength * 0.05) - 1)) / blockValueMod) + changes.blockValue) * blockValueMod) + floor((strength * 0.05) - 1)
		end
	end
	if changes.resilience and changes.resilience ~= 0 then
		tpTable.resilience = tpTable.resilience + changes.resilience
	end
	if changes.mobLevel and changes.mobLevel ~= 0 then
		tpTable.mobLevel = tpTable.mobLevel + changes.mobLevel
	end
	if changes.mobDamage and changes.mobDamage ~= 0 then
		tpTable.mobDamage = tpTable.mobDamage + changes.mobDamage
	end
	if changes.mobAttackSpeed and changes.mobAttackSpeed ~= 0 then
		tpTable.mobAttackSpeed = tpTable.mobAttackSpeed + changes.mobAttackSpeed
	end
	if changes.playerSBFreq and changes.playerSBFreq ~= 0 then
		tpTable.playerSBFreq = tpTable.playerSBFreq + changes.playerSBFreq
	end
end

function TankPoints:CheckSourceData(TP_Table, school, forceShield)
	-- Check for nil
	-- Fix values that are below minimum
	if TP_Table.playerLevel == nil then self.Print("playerLevel".."is nil") return
	else TP_Table.playerLevel = max(1, TP_Table.playerLevel) end
	if TP_Table.playerHealth == nil then self.Print("playerHealth".."is nil") return
	else TP_Table.playerHealth = max(0, TP_Table.playerHealth) end
	if TP_Table.mobLevel == nil then self.Print("mobLevel".."is nil") return
	else TP_Table.mobLevel = max(1, TP_Table.mobLevel) end
	if TP_Table.resilience == nil then self.Print("resilience".."is nil") return
	else TP_Table.resilience = max(0, TP_Table.resilience) end
	-- Melee
	if (not school) or school == TP_MELEE then
		if TP_Table.mobCritChance == nil then self.Print("mobCritChance".."is nil") return
		else TP_Table.mobCritChance = max(0, TP_Table.mobCritChance) end
		if TP_Table.mobCritBonus == nil then self.Print("mobCritBonus".."is nil") return
		else TP_Table.mobCritBonus = max(0, TP_Table.mobCritBonus) end
		if TP_Table.mobMissChance == nil then self.Print("mobMissChance".."is nil") return
		else TP_Table.mobMissChance = max(0, TP_Table.mobMissChance) end
		if TP_Table.armor == nil then self.Print("armor".."is nil") return
		else TP_Table.armor = max(0, TP_Table.armor) end
		if TP_Table.defense == nil then self.Print("defense".."is nil") return
		else TP_Table.defense = max(0, TP_Table.defense) end
		if TP_Table.dodgeChance == nil then self.Print("dodgeChance".."is nil") return
		else TP_Table.dodgeChance = max(0, TP_Table.dodgeChance) end
		if GetParryChance() == 0 then
			TP_Table.parryChance = 0
		end
		if TP_Table.parryChance == nil then self.Print("parryChance".."is nil") return
		else TP_Table.parryChance = max(0, TP_Table.parryChance) end
		if (forceShield == true) or ((forceShield == nil) and self:ShieldIsEquipped()) then
			if TP_Table.blockChance == nil then self.Print("blockChance".."is nil") return
			else TP_Table.blockChance = max(0, TP_Table.blockChance) end
			if TP_Table.blockValue == nil then self.Print("blockValue".."is nil") return
			else TP_Table.blockValue = max(0, TP_Table.blockValue) end
		else
			TP_Table.blockChance = 0
			TP_Table.blockValue = 0
		end
		if TP_Table.mobDamage == nil then self.Print("mobDamage".."is nil") return
		else TP_Table.mobDamage = max(0, TP_Table.mobDamage) end
		if TP_Table.damageTakenMod[TP_MELEE] == nil then self.Print("damageTakenMod[TP_MELEE]".."is nil") return
		else TP_Table.damageTakenMod[TP_MELEE] = max(0, TP_Table.damageTakenMod[TP_MELEE]) end
		if TP_Table.mobAttackSpeed == nil then self.Print("mobAttackSpeed".."is nil") return
		else TP_Table.mobAttackSpeed = max(0.1, TP_Table.mobAttackSpeed) end
		if TP_Table.playerSBFreq == nil then self.Print("playerSBFreq".."is nil") return
		else TP_Table.playerSBFreq = max(5, TP_Table.playerSBFreq) end
	end
	-- Spell
	if (not school) or school > TP_MELEE then
		if TP_Table.mobSpellCritChance == nil then self.Print("mobSpellCritChance".."is nil") return
		else TP_Table.mobSpellCritChance = max(0, TP_Table.mobSpellCritChance) end
		if TP_Table.mobSpellCritBonus == nil then self.Print("mobSpellCritBonus".."is nil") return
		else TP_Table.mobSpellCritBonus = max(0, TP_Table.mobSpellCritBonus) end
		if TP_Table.mobSpellMissChance == nil then self.Print("mobSpellMissChance".."is nil") return
		else TP_Table.mobSpellMissChance = max(0, TP_Table.mobSpellMissChance) end
		-- Negative resistances don't work anymore?
		if not school then
			for s = TP_HOLY, TP_ARCANE, 1 do
				if TP_Table.resistance[s] == nil then self.Print("resistance["..s.."]".."is nil") return
				else TP_Table.resistance[s] = max(0, TP_Table.resistance[s]) end
				if TP_Table.damageTakenMod[s] == nil then self.Print("damageTakenMod["..s.."]".."is nil") return
				else TP_Table.damageTakenMod[s] = max(0, TP_Table.damageTakenMod[s]) end
			end
		else
			if TP_Table.resistance[school] == nil then self.Print("resistance["..school.."]".."is nil") return
			else TP_Table.resistance[school] = max(0, TP_Table.resistance[school]) end
			if TP_Table.damageTakenMod[school] == nil then self.Print("damageTakenMod["..school.."]".."is nil") return
			else TP_Table.damageTakenMod[school] = max(0, TP_Table.damageTakenMod[school]) end
		end
	end
	return true
end

local shieldBlockChangesTable = {blockChance = 0.75}

function TankPoints:GetTankPoints(TP_Table, school, forceShield)
	-----------------
	-- Aquire Data --
	-----------------
	-- Set true if temp table is created
	local tempTableFlag
	if not TP_Table then
		tempTableFlag = true
		-- Fill table with player values
		TP_Table = TankPoints:GetSourceData(nil, school)
	end
	------------------
	-- Check Inputs --
	------------------
	if not TankPoints:CheckSourceData(TP_Table, school, forceShield) then return end
	-- Get a copy for Shield Block skill calculations
	local inputCopy
	if self.playerClass == "WARRIOR" then
		inputCopy = {}
		copyTable(inputCopy, TP_Table)
	end
	-----------------
	-- Caculations --
	-----------------
	-- Resilience Mod
	TP_Table.resilienceEffect = StatLogic:GetEffectFromRating(TP_Table.resilience, CR_CRIT_TAKEN_MELEE, TP_Table.playerLevel) * 0.01
	if (not school) or school == TP_MELEE then
		-- Armor Reduction
		TP_Table.armorReduction = self:GetArmorReduction(TP_Table.armor, TP_Table.mobLevel)
		-- Defense Mod (may return negative)
		TP_Table.defenseEffect = self:GetDefenseEffect(TP_Table.defense, TP_Table.mobLevel)
		-- Mob's Crit, Miss
		TP_Table.mobCritChance = max(0, TP_Table.mobCritChance - TP_Table.defenseEffect - TP_Table.resilienceEffect)
		TP_Table.mobMissChance = max(0, TP_Table.mobMissChance + TP_Table.defenseEffect)
		-- Dodge, Parry, Block
		TP_Table.dodgeChance = max(0, TP_Table.dodgeChance - (TP_Table.mobLevel - TP_Table.playerLevel) * 0.002)
		TP_Table.parryChance = max(0, TP_Table.parryChance - (TP_Table.mobLevel - TP_Table.playerLevel) * 0.002)
		-- Block Chance, Block Value
		-- Check if player has shield or forceShield is set to true
		if (forceShield == true) or ((forceShield == nil) and self:ShieldIsEquipped()) then
			TP_Table.blockChance = max(0, TP_Table.blockChance - (TP_Table.mobLevel - TP_Table.playerLevel) * 0.002)
		else
			TP_Table.blockChance = 0
		end
		
		-- Crushing Blow Chance
		TP_Table.mobCrushChance = 0
		if (TP_Table.mobLevel - TP_Table.playerLevel) > 2 then -- if mob is 3 levels or above crushing blow will happen
			-- minimum 15% and additional 2% every defense point under playerLevel*5
			TP_Table.mobCrushChance = 0.15 + max(0, (TP_Table.playerLevel * 5 - TP_Table.defense) * 0.02)
		end
		-- Mob's Crit Damage Mod
		TP_Table.mobCritDamageMod = max(0, 1 - TP_Table.resilienceEffect * 2)
		-- Mob Damage
		-- blocked value is subtracted from the damage after armor and stance mods are factored in
		TP_Table.mobDamage = TP_Table.mobDamage * TP_Table.damageTakenMod[TP_MELEE] * (1 - TP_Table.armorReduction)
		-- Blocked Damage Percentage (blockedMod)
		-- ex: if mob hits you for 1000 and you block 200 of it, then you avoid 200/1000 = 20% of the damage
		-- this value multiplied by block% can now be treated like dodge and parry except that these avoid 100% of the damage
		TP_Table.blockedMod = min(1, TP_Table.blockValue / TP_Table.mobDamage)
	end
	if (not school) or school > TP_MELEE then
		-- Mob's Spell Crit
		TP_Table.mobSpellCritChance = max(0, TP_Table.mobSpellCritChance - TP_Table.resilienceEffect)
		-- Mob's Spell Crit Damage Mod
		TP_Table.mobSpellCritDamageMod = max(0, 1 - TP_Table.resilienceEffect * 2)
	end
	---------------------
	-- High caps check --
	---------------------
	if (not school) or school == TP_MELEE then
		-- Hit < Crushing < Crit < Block < Parry < Dodge < Miss
		local combatTable = {}
		-- build total sums
		local total = TP_Table.mobMissChance
		tinsert(combatTable, total)
		total = total + TP_Table.dodgeChance
		tinsert(combatTable, total)
		total = total + TP_Table.parryChance
		tinsert(combatTable, total)
		total = total + TP_Table.blockChance
		tinsert(combatTable, total)
		total = total + TP_Table.mobCritChance
		tinsert(combatTable, total)
		total = total + TP_Table.mobCrushChance
		tinsert(combatTable, total)
		-- check caps
		if combatTable[1] > 1 then
			TP_Table.mobMissChance = 1
		end
		if combatTable[2] > 1 then
			TP_Table.dodgeChance = max(0, 1 - combatTable[1])
		end
		if combatTable[3] > 1 then
			TP_Table.parryChance = max(0, 1 - combatTable[2])
		end
		if combatTable[4] > 1 then
			TP_Table.blockChance = max(0, 1 - combatTable[3])
		end
		if combatTable[5] > 1 then
			TP_Table.mobCritChance = max(0, 1 - combatTable[4])
		end
		if combatTable[6] > 1 then
			TP_Table.mobCrushChance = max(0, 1 - combatTable[5])
		end
	end
	if (not school) or school > TP_MELEE then
		-- Hit < Crit < Miss
		local combatTable = {}
		-- build total sums
		local total = TP_Table.mobSpellMissChance
		tinsert(combatTable, total)
		total = total + TP_Table.mobSpellCritChance
		tinsert(combatTable, total)
		-- check caps
		if combatTable[1] > 1 then
			TP_Table.mobSpellMissChance = 1
		end
		if combatTable[2] > 1 then
			TP_Table.mobSpellCritChance = max(0, 1 - combatTable[1])
		end
	end

	--self:Debug(TP_Table.mobMissChance, TP_Table.dodgeChance, TP_Table.parryChance, TP_Table.blockChance, TP_Table.mobCritChance, TP_Table.mobCrushChance)
	------------------------
	-- Final Calculations --
	------------------------
	--self:Debug("TankPoints Caculated")
	if type(TP_Table.schoolReduction) ~= "table" then
		TP_Table.schoolReduction = {}
	end
	if type(TP_Table.totalReduction) ~= "table" then
		TP_Table.totalReduction = {}
	end
	if type(TP_Table.tankPoints) ~= "table" then
		TP_Table.tankPoints = {}
	end
	if not school then
		-- School Reduction
		TP_Table.schoolReduction[TP_MELEE] = TP_Table.armorReduction
		-- Total Reduction
		TP_Table.totalReduction[TP_MELEE] = 1 - ((TP_Table.mobCritChance * (1 + TP_Table.mobCritBonus) * TP_Table.mobCritDamageMod) + (TP_Table.mobCrushChance * 1.5) + (1 - TP_Table.mobCrushChance - TP_Table.mobCritChance - TP_Table.blockChance * TP_Table.blockedMod - TP_Table.parryChance - TP_Table.dodgeChance - TP_Table.mobMissChance)) * (1 - TP_Table.armorReduction) * TP_Table.damageTakenMod[TP_MELEE]
		-- TankPoints
		TP_Table.tankPoints[TP_MELEE] = TP_Table.playerHealth / (1 - TP_Table.totalReduction[TP_MELEE])
		-- Shield Block Skill
		if self.playerClass == "WARRIOR" then
			-- +75% Block Chance
			self:AlterSourceData(inputCopy, shieldBlockChangesTable, forceShield)
			self:GetTankPointsWithoutShieldBlock(inputCopy, TP_MELEE, forceShield)
			local _, _, _, _, r = GetTalentInfo(3, 7)
			local improvedShieldBlock
			if r == 1 then
				improvedShieldBlock = true
			end
			local shieldBlockUpPercent = self:GetShieldBlockUpPercent(inputCopy.playerSBFreq, inputCopy.mobAttackSpeed, inputCopy.blockChance, improvedShieldBlock)
			TP_Table.totalReduction[TP_MELEE] = TP_Table.totalReduction[TP_MELEE] * (1 - shieldBlockUpPercent) + inputCopy.totalReduction[TP_MELEE] * shieldBlockUpPercent
			TP_Table.tankPoints[TP_MELEE] = TP_Table.tankPoints[TP_MELEE] * (1 - shieldBlockUpPercent) + inputCopy.tankPoints[TP_MELEE] * shieldBlockUpPercent
			TP_Table.shieldBlockUpPercent = shieldBlockUpPercent
		end
		for s = TP_HOLY, TP_ARCANE, 1 do
			-- Resistance Reduction = 0.75 (resistance / (mobLevel * 5))
			TP_Table.schoolReduction[s] = 0.75 * (TP_Table.resistance[s] / (max(TP_Table.mobLevel, 20) * 5))
			-- Total Reduction
			TP_Table.totalReduction[s] = 1 - ((TP_Table.mobSpellCritChance * (1 + TP_Table.mobSpellCritBonus) * TP_Table.mobSpellCritDamageMod) + (1 - TP_Table.mobSpellCritChance - TP_Table.mobSpellMissChance)) * (1 - TP_Table.schoolReduction[s]) * TP_Table.damageTakenMod[s]
			-- TankPoints
			TP_Table.tankPoints[s] = TP_Table.playerHealth / (1 - TP_Table.totalReduction[s])
		end
	else
		if school == TP_MELEE then
			-- School Reduction
			TP_Table.schoolReduction[school] = TP_Table.armorReduction
			-- Total Reduction
			TP_Table.totalReduction[school] = 1 - ((TP_Table.mobCritChance * (1 + TP_Table.mobCritBonus) * TP_Table.mobCritDamageMod) + (TP_Table.mobCrushChance * 1.5) + (1 - TP_Table.mobCrushChance - TP_Table.mobCritChance - TP_Table.blockChance * TP_Table.blockedMod - TP_Table.parryChance - TP_Table.dodgeChance - TP_Table.mobMissChance)) * (1 - TP_Table.armorReduction) * TP_Table.damageTakenMod[school]
			-- TankPoints
			TP_Table.tankPoints[school] = TP_Table.playerHealth / (1 - TP_Table.totalReduction[school])
			-- Shield Block Skill
			if self.playerClass == "WARRIOR" then
				-- +75% Block Chance
				self:AlterSourceData(inputCopy, shieldBlockChangesTable, forceShield)
				self:GetTankPointsWithoutShieldBlock(inputCopy, TP_MELEE, forceShield)
				local _, _, _, _, r = GetTalentInfo(3, 7)
				local improvedShieldBlock
				if r == 1 then
					improvedShieldBlock = true
				end
				local shieldBlockUpPercent = self:GetShieldBlockUpPercent(inputCopy.playerSBFreq, inputCopy.mobAttackSpeed, inputCopy.blockChance, improvedShieldBlock)
				TP_Table.totalReduction[TP_MELEE] = TP_Table.totalReduction[TP_MELEE] * (1 - shieldBlockUpPercent) + inputCopy.totalReduction[TP_MELEE] * shieldBlockUpPercent
				TP_Table.tankPoints[TP_MELEE] = TP_Table.tankPoints[TP_MELEE] * (1 - shieldBlockUpPercent) + inputCopy.tankPoints[TP_MELEE] * shieldBlockUpPercent
				TP_Table.shieldBlockUpPercent = shieldBlockUpPercent
			end
		else
			-- Resistance Reduction
			TP_Table.schoolReduction[school] = 0.75 * (TP_Table.resistance[school] / (max(TP_Table.mobLevel, 20) * 5))
			-- Total Reduction
			TP_Table.totalReduction[school] = 1 - ((TP_Table.mobSpellCritChance * (1 + TP_Table.mobSpellCritBonus) * TP_Table.mobSpellCritDamageMod) + (1 - TP_Table.mobSpellCritChance - TP_Table.mobSpellMissChance)) * (1 - TP_Table.schoolReduction[school]) * TP_Table.damageTakenMod[school]
			-- TankPoints
			TP_Table.tankPoints[school] = TP_Table.playerHealth / (1 - TP_Table.totalReduction[school])
		end
	end
	-------------
	-- Cleanup --
	-------------
	if tempTableFlag and school then
		local tankPoints, totalReduction, schoolReduction = TP_Table.tankPoints[school], TP_Table.totalReduction[school], TP_Table.schoolReduction[school]
		return tankPoints, totalReduction, schoolReduction
	end
	return TP_Table
end

function TankPoints:GetTankPointsWithoutShieldBlock(TP_Table, school, forceShield)
	-----------------
	-- Aquire Data --
	-----------------
	-- Set true if temp table is created
	local tempTableFlag
	if not TP_Table then
		tempTableFlag = true
		-- Fill table with player values
		TP_Table = TankPoints:GetSourceData(nil, school)
	end
	------------------
	-- Check Inputs --
	------------------
	if not TankPoints:CheckSourceData(TP_Table, school, forceShield) then return end
	-----------------
	-- Caculations --
	-----------------
	-- Resilience Mod
	TP_Table.resilienceEffect = StatLogic:GetEffectFromRating(TP_Table.resilience, CR_CRIT_TAKEN_MELEE, TP_Table.playerLevel) * 0.01
	if (not school) or school == TP_MELEE then
		-- Armor Reduction
		TP_Table.armorReduction = self:GetArmorReduction(TP_Table.armor, TP_Table.mobLevel)
		-- Defense Mod (may return negative)
		TP_Table.defenseEffect = self:GetDefenseEffect(TP_Table.defense, TP_Table.mobLevel)
		-- Mob's Crit, Miss
		TP_Table.mobCritChance = max(0, TP_Table.mobCritChance - TP_Table.defenseEffect - TP_Table.resilienceEffect)
		TP_Table.mobMissChance = max(0, TP_Table.mobMissChance + TP_Table.defenseEffect)
		-- Dodge, Parry, Block
		TP_Table.dodgeChance = max(0, TP_Table.dodgeChance - (TP_Table.mobLevel - TP_Table.playerLevel) * 0.002)
		TP_Table.parryChance = max(0, TP_Table.parryChance - (TP_Table.mobLevel - TP_Table.playerLevel) * 0.002)
		-- Block Chance, Block Value
		-- Check if player has shield or forceShield is set to true
		if (forceShield == true) or ((forceShield == nil) and self:ShieldIsEquipped()) then
			TP_Table.blockChance = max(0, TP_Table.blockChance - (TP_Table.mobLevel - TP_Table.playerLevel) * 0.002)
		else
			TP_Table.blockChance = 0
		end
		
		-- Crushing Blow Chance
		TP_Table.mobCrushChance = 0
		if (TP_Table.mobLevel - TP_Table.playerLevel) > 2 then -- if mob is 3 levels or above crushing blow will happen
			-- minimum 15% and additional 2% every defense point under playerLevel*5
			TP_Table.mobCrushChance = 0.15 + max(0, (TP_Table.playerLevel * 5 - TP_Table.defense) * 0.02)
		end
		-- Mob's Crit Damage Mod
		TP_Table.mobCritDamageMod = max(0, 1 - TP_Table.resilienceEffect * 2)
		-- Mob Damage
		-- blocked value is subtracted from the damage after armor and stance mods are factored in
		TP_Table.mobDamage = TP_Table.mobDamage * TP_Table.damageTakenMod[TP_MELEE] * (1 - TP_Table.armorReduction)
		-- Blocked Damage Percentage (blockedMod)
		-- ex: if mob hits you for 1000 and you block 200 of it, then you avoid 200/1000 = 20% of the damage
		-- this value multiplied by block% can now be treated like dodge and parry except that these avoid 100% of the damage
		TP_Table.blockedMod = min(1, TP_Table.blockValue / TP_Table.mobDamage)
	end
	if (not school) or school > TP_MELEE then
		-- Mob's Spell Crit
		TP_Table.mobSpellCritChance = max(0, TP_Table.mobSpellCritChance - TP_Table.resilienceEffect)
		-- Mob's Spell Crit Damage Mod
		TP_Table.mobSpellCritDamageMod = max(0, 1 - TP_Table.resilienceEffect * 2)
	end
	---------------------
	-- High caps check --
	---------------------
	if (not school) or school == TP_MELEE then
		-- Hit < Crushing < Crit < Block < Parry < Dodge < Miss
		local combatTable = {}
		-- build total sums
		local total = TP_Table.mobMissChance
		tinsert(combatTable, total)
		total = total + TP_Table.dodgeChance
		tinsert(combatTable, total)
		total = total + TP_Table.parryChance
		tinsert(combatTable, total)
		total = total + TP_Table.blockChance
		tinsert(combatTable, total)
		total = total + TP_Table.mobCritChance
		tinsert(combatTable, total)
		total = total + TP_Table.mobCrushChance
		tinsert(combatTable, total)
		-- check caps
		if combatTable[1] > 1 then
			TP_Table.mobMissChance = 1
		end
		if combatTable[2] > 1 then
			TP_Table.dodgeChance = max(0, 1 - combatTable[1])
		end
		if combatTable[3] > 1 then
			TP_Table.parryChance = max(0, 1 - combatTable[2])
		end
		if combatTable[4] > 1 then
			TP_Table.blockChance = max(0, 1 - combatTable[3])
		end
		if combatTable[5] > 1 then
			TP_Table.mobCritChance = max(0, 1 - combatTable[4])
		end
		if combatTable[6] > 1 then
			TP_Table.mobCrushChance = max(0, 1 - combatTable[5])
		end
	end
	if (not school) or school > TP_MELEE then
		-- Hit < Crit < Miss
		local combatTable = {}
		-- build total sums
		local total = TP_Table.mobSpellMissChance
		tinsert(combatTable, total)
		total = total + TP_Table.mobSpellCritChance
		tinsert(combatTable, total)
		-- check caps
		if combatTable[1] > 1 then
			TP_Table.mobSpellMissChance = 1
		end
		if combatTable[2] > 1 then
			TP_Table.mobSpellCritChance = max(0, 1 - combatTable[1])
		end
	end

	--self:Debug(TP_Table.mobMissChance, TP_Table.dodgeChance, TP_Table.parryChance, TP_Table.blockChance, TP_Table.mobCritChance, TP_Table.mobCrushChance)
	------------------------
	-- Final Calculations --
	------------------------
	--self:Debug("TankPoints Caculated")
	if type(TP_Table.schoolReduction) ~= "table" then
		TP_Table.schoolReduction = {}
	end
	if type(TP_Table.totalReduction) ~= "table" then
		TP_Table.totalReduction = {}
	end
	if type(TP_Table.tankPoints) ~= "table" then
		TP_Table.tankPoints = {}
	end
	if not school then
		-- School Reduction
		TP_Table.schoolReduction[TP_MELEE] = TP_Table.armorReduction
		-- Total Reduction
		TP_Table.totalReduction[TP_MELEE] = 1 - ((TP_Table.mobCritChance * (1 + TP_Table.mobCritBonus) * TP_Table.mobCritDamageMod) + (TP_Table.mobCrushChance * 1.5) + (1 - TP_Table.mobCrushChance - TP_Table.mobCritChance - TP_Table.blockChance * TP_Table.blockedMod - TP_Table.parryChance - TP_Table.dodgeChance - TP_Table.mobMissChance)) * (1 - TP_Table.armorReduction) * TP_Table.damageTakenMod[TP_MELEE]
		-- TankPoints
		TP_Table.tankPoints[TP_MELEE] = TP_Table.playerHealth / (1 - TP_Table.totalReduction[TP_MELEE])
		for s = TP_HOLY, TP_ARCANE, 1 do
			-- Resistance Reduction = 0.75 (resistance / (mobLevel * 5))
			TP_Table.schoolReduction[s] = 0.75 * (TP_Table.resistance[s] / (max(TP_Table.mobLevel, 20) * 5))
			-- Total Reduction
			TP_Table.totalReduction[s] = 1 - ((TP_Table.mobSpellCritChance * (1 + TP_Table.mobSpellCritBonus) * TP_Table.mobSpellCritDamageMod) + (1 - TP_Table.mobSpellCritChance - TP_Table.mobSpellMissChance)) * (1 - TP_Table.schoolReduction[s]) * TP_Table.damageTakenMod[s]
			-- TankPoints
			TP_Table.tankPoints[s] = TP_Table.playerHealth / (1 - TP_Table.totalReduction[s])
		end
	else
		if school == TP_MELEE then
			-- School Reduction
			TP_Table.schoolReduction[school] = TP_Table.armorReduction
			-- Total Reduction
			TP_Table.totalReduction[school] = 1 - ((TP_Table.mobCritChance * (1 + TP_Table.mobCritBonus) * TP_Table.mobCritDamageMod) + (TP_Table.mobCrushChance * 1.5) + (1 - TP_Table.mobCrushChance - TP_Table.mobCritChance - TP_Table.blockChance * TP_Table.blockedMod - TP_Table.parryChance - TP_Table.dodgeChance - TP_Table.mobMissChance)) * (1 - TP_Table.armorReduction) * TP_Table.damageTakenMod[school]
			-- TankPoints
			TP_Table.tankPoints[school] = TP_Table.playerHealth / (1 - TP_Table.totalReduction[school])
		else
			-- Resistance Reduction
			TP_Table.schoolReduction[school] = 0.75 * (TP_Table.resistance[school] / (max(TP_Table.mobLevel, 20) * 5))
			-- Total Reduction
			TP_Table.totalReduction[school] = 1 - ((TP_Table.mobSpellCritChance * (1 + TP_Table.mobSpellCritBonus) * TP_Table.mobSpellCritDamageMod) + (1 - TP_Table.mobSpellCritChance - TP_Table.mobSpellMissChance)) * (1 - TP_Table.schoolReduction[school]) * TP_Table.damageTakenMod[school]
			-- TankPoints
			TP_Table.tankPoints[school] = TP_Table.playerHealth / (1 - TP_Table.totalReduction[school])
		end
	end
	-------------
	-- Cleanup --
	-------------
	if tempTableFlag and school then
		local tankPoints, totalReduction, schoolReduction = TP_Table.tankPoints[school], TP_Table.totalReduction[school], TP_Table.schoolReduction[school]
		return tankPoints, totalReduction, schoolReduction
	end
	return TP_Table
end