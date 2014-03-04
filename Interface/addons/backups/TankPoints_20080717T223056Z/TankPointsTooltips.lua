--[[
Name: TankPoints Tooltips
Description: Displays TankPoints difference in item tooltips
Revision: $Revision: 1 $
Developed by: Whitetooth@Cenarius (hotdogee@bahamut.twbbs.org)
]]

---------------
-- Libraries --
---------------
local TipHooker = AceLibrary("TipHooker-1.0")
StatLogic = AceLibrary("StatLogic-1.0")
local L = AceLibrary("AceLocale-2.2"):new("TankPoints")


--------------------
-- Initialization --
--------------------
TankPointsTooltips = {}
local TPTips = TankPointsTooltips
local TP = TankPoints


---------------------
-- Local Variables --
---------------------
local DEBUG = true

-- Localize Lua globals
local pairs = pairs
local ipairs = ipairs
local strsplit = strsplit
local floor = floor
local setmetatable = setmetatable
local getmetatable = getmetatable

-- Localize WoW globals
local IsEquippableItem = IsEquippableItem
local IsEquippedItemType = IsEquippedItemType
local GetCombatRating = GetCombatRating


-----------
-- Cache --
-----------
local cache = {}
setmetatable(cache, {__mode = "kv"}) -- weak table to enable garbage collection

function TPTips.ClearCache()
	for k in pairs(cache) do
		cache[k] = nil
	end
end


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

-- Color Numbers
local GREEN_FONT_COLOR_CODE = GREEN_FONT_COLOR_CODE -- "|cff20ff20" Green
local HIGHLIGHT_FONT_COLOR_CODE = HIGHLIGHT_FONT_COLOR_CODE -- "|cffffffff" White
local RED_FONT_COLOR_CODE = RED_FONT_COLOR_CODE -- "|cffffffff" White
local FONT_COLOR_CODE_CLOSE = FONT_COLOR_CODE_CLOSE -- "|r"
local function colorNum(text, num)
	if num > 0 then
		return GREEN_FONT_COLOR_CODE..text..FONT_COLOR_CODE_CLOSE
	elseif num < 0 then
		return RED_FONT_COLOR_CODE..text..FONT_COLOR_CODE_CLOSE
	else
		return HIGHLIGHT_FONT_COLOR_CODE..text..FONT_COLOR_CODE_CLOSE
	end
end


----------------------
-- TankPoints Tools --
----------------------
-- TPTips:GetItemSubType(itemID|"name"|"itemlink")
function TPTips:GetItemSubType(item)
	local _, _, _, _, _, _, itemSubType = GetItemInfo(item)
	return itemSubType
end
-- TPTips:IsShield(itemID|"name"|"itemlink")
function TPTips:IsShield(item)
	return GetItemEquipLoc(item) == "INVTYPE_SHIELD"
end
-- TPTips:GetItemEquipLoc(itemID|"name"|"itemlink")
function TPTips:GetItemEquipLoc(item)
	local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(item)
	return itemEquipLoc
	--[[
	INVTYPE_AMMO           = 0,
	INVTYPE_GUNPROJECTILE  = 0,
	INVTYPE_BOWPROJECTILE  = 0,
	INVTYPE_HEAD           = 1,
	INVTYPE_NECK           = 2,
	INVTYPE_SHOULDER       = 3,
	INVTYPE_BODY           = 4,
	INVTYPE_CHEST          = 5,
	INVTYPE_ROBE           = 5,
	INVTYPE_WAIST          = 6,
	INVTYPE_LEGS           = 7,
	INVTYPE_FEET           = 8,
	INVTYPE_WRIST          = 9,
	INVTYPE_HAND           = 10,
	INVTYPE_FINGER         = {11,12},
	INVTYPE_TRINKET        = {13,14},
	INVTYPE_CLOAK          = 15,
	INVTYPE_WEAPON         = {16,17},
	INVTYPE_2HWEAPON       = 16+17,
	INVTYPE_WEAPONMAINHAND = 16,
	INVTYPE_WEAPONOFFHAND  = 17,
	INVTYPE_SHIELD         = 17,
	INVTYPE_HOLDABLE       = 17,
	INVTYPE_RANGED         = 18,
	INVTYPE_RANGEDRIGHT    = 18,
	INVTYPE_RELIC          = 18,
	INVTYPE_GUN            = 18,
	INVTYPE_CROSSBOW       = 18,
	INVTYPE_WAND           = 18,
	INVTYPE_THROWN         = 18,
	INVTYPE_TABARD         = 19,
	--]]
end

----------
-- Core --
----------
-- Build changes table for TP:AlterSourceData from StatLogic:GetDiff table
function TPTips:BuildChanges(changes, table)
	changes.str = table.STR
	changes.agi = table.AGI
	changes.sta = table.STA
	changes.playerHealth = table.HEALTH
	changes.armorFromItems = table.ARMOR
	changes.armor = table.ARMOR_BONUS
	if table.DEFENSE_RATING then
		-- Ratings are floored in game
		current = GetCombatRating(CR_DEFENSE_SKILL)
		changes.defense = floor(StatLogic:GetEffectFromRating(current + table.DEFENSE_RATING, CR_DEFENSE_SKILL, TP.playerLevel)) - floor(StatLogic:GetEffectFromRating(current, CR_DEFENSE_SKILL, TP.playerLevel))
	end
	if table.DODGE_RATING then
		changes.dodgeChance = StatLogic:GetEffectFromRating(table.DODGE_RATING, CR_DODGE, TP.playerLevel) * 0.01
	end
	if table.PARRY_RATING then
		changes.parryChance = StatLogic:GetEffectFromRating(table.PARRY_RATING, CR_PARRY, TP.playerLevel) * 0.01
	end
	if table.BLOCK_RATING then
		changes.blockChance = StatLogic:GetEffectFromRating(table.BLOCK_RATING, CR_BLOCK, TP.playerLevel) * 0.01
	end
	changes.blockValue = table.BLOCK_VALUE
	changes.resilience = table.RESILIENCE_RATING
	return changes
end

-- Debug
-- TankPointsTooltips:BuildChanges({}, StatLogic:GetDiff(24396))
function TPTips.ProcessTooltip(tooltip, name, link)
	local profile = TankPoints.db.profile
	-- Check if option is enabled
	if not (profile.showTooltipDiff or profile.showTooltipTotal) then return end
	-- Check if item is equippable, bags will still pass through
	if not (IsEquippableItem(link) or (TPTips:GetItemSubType(link) == L["Gems"])) then return end
	-- Get data from cache if available
	local cacheText = cache[link]
	if cacheText then
		tooltip:AddDoubleLine(strsplit("@", cacheText))
		tooltip:Show()
		return
	end
	-- Get diff tables
	local diffTable1, diffTable2
	if TPTips:GetItemSubType(link) == L["Gems"] then
		diffTable1 = StatLogic:GetSum(link)
	else
		diffTable1, diffTable2 = StatLogic:GetDiff(link)
	end
	-- Check for bags
	if not diffTable1 then
		return
	end
	-- Item type
	local itemType = diffTable1.itemType
	local right
	-- Calculate current TankPoints
	local tpSource = {}
	TP:GetSourceData(tpSource, TP_MELEE)
	local tpResults = {}
	copyTable(tpResults, tpSource)
	TP:GetTankPoints(tpResults, TP_MELEE)
	-- Update and ClearCache if different
	if floor(TP.resultsTable.tankPoints[TP_MELEE]) ~= floor(tpResults.tankPoints[TP_MELEE]) then
		copyTable(TP.sourceTable, tpSource)
		copyTable(TP.resultsTable, tpResults)
		TPTips.ClearCache()
	end
	----------------------------------------------------
	-- Calculate TP difference with 1st equipped item --
	----------------------------------------------------
	local tpTable = {}
	-- Set the forceShield arg
	local forceShield
	-- if not equipped shield and item is shield then force on
	-- if not equipped shield and item is not shield then nil
	-- if equipped shield and item is shield then nil
	-- if equipped shield and item is not shield then force off
	if ((diffTable1.diffItemType1 ~= "INVTYPE_SHIELD") and (diffTable1.diffItemType2 ~= "INVTYPE_SHIELD")) and (itemType == "INVTYPE_SHIELD") then
		forceShield = true
	elseif ((diffTable1.diffItemType1 == "INVTYPE_SHIELD") or (diffTable1.diffItemType2 == "INVTYPE_SHIELD")) and (itemType ~= "INVTYPE_SHIELD") then
		forceShield = false
	end
	-- Get the tp table
	TP:GetSourceData(tpTable, TP_MELEE, forceShield)
	-- Build changes table
	local changes = TPTips:BuildChanges({}, diffTable1)
	-- Alter tp table
	TP:AlterSourceData(tpTable, changes, forceShield)
	-- Calculate TankPoints from tpTable
	TP:GetTankPoints(tpTable, TP_MELEE, forceShield)
	-- Calculate tp difference
	local diff = floor(tpTable.tankPoints[TP_MELEE]) - floor(TP.resultsTable.tankPoints[TP_MELEE])
	if profile.showTooltipDiff then
		right = colorNum(format("%+d", diff), diff)
	end
	if profile.showTooltipTotal then
		local total = floor(tpTable.tankPoints[TP_MELEE])
		if profile.showTooltipDiff then
			right = right.."("..colorNum(format("%d", total), diff)..")"
		else
			right = colorNum(format("%d", total), diff)
		end
	end
	
	if TPTips:GetItemSubType(link) == L["Gems"] and diff == 0 then
		right = nil
	end
	--------------------------------------------------------------
	-- Calculate TP difference with 2ed equipped item if needed --
	--------------------------------------------------------------
	if diffTable2 then
		local tpTable = {}
		local forceShield
		if (diffTable2.diffItemType1 ~= "INVTYPE_SHIELD") and (itemType == "INVTYPE_SHIELD") then
			forceShield = true
		elseif (diffTable2.diffItemType1 == "INVTYPE_SHIELD") and (itemType ~= "INVTYPE_SHIELD") then
			forceShield = false
		end
		TP:GetSourceData(tpTable, TP_MELEE, forceShield)
		local changes = TPTips:BuildChanges({}, diffTable2)
		TP:AlterSourceData(tpTable, changes, forceShield)
		TP:GetTankPoints(tpTable, TP_MELEE, forceShield)
		local diff  = floor(tpTable.tankPoints[TP_MELEE]) - floor(TP.resultsTable.tankPoints[TP_MELEE])
		if profile.showTooltipDiff then
			right = right.."/"..colorNum(format("%+d", diff), diff)
		end
		if profile.showTooltipTotal then
			local total = floor(tpTable.tankPoints[TP_MELEE])
			if profile.showTooltipDiff then
				right = right.."("..colorNum(format("%d", total), diff)..")"
			else
				right = right.."/"..colorNum(format("%d", total), diff)
			end
		end
	end
	-----------------
	-- Append Text --
	-----------------
	if right then
		-- Build left
		local left = L["TankPoints"]
		if itemType == "INVTYPE_FINGER" or itemType == "INVTYPE_TRINKET" then
			left = left..L[" (Top/Bottom):"]
		elseif itemType == "INVTYPE_WEAPON" then
			left = left..L[" (Main/Off):"]
		elseif itemType == "INVTYPE_2HWEAPON" then
			left = left..L[" (Main+Off):"]
		else
			left = left..":"
		end
		-- Add double line
		tooltip:AddDoubleLine(left, right)
		tooltip:Show()
		cache[link] = left.."@"..right
	end
	-- Cleanup
	StatLogic.StatTable.del(diffTable1)
	StatLogic.StatTable.del(diffTable2)
end

TipHooker:Hook(TPTips.ProcessTooltip, "item")