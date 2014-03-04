--[[
Name: TankPoints zhTW locale
Revision: $Revision: 1 $
Translated by: 
- CuteMiyu@bahamut.twbbs.org
]]
-- Global Strings that don't need translations
--[[
PLAYERSTAT_MELEE_COMBAT = "Melee"
SPELL_SCHOOL0_CAP = "Physical"
SPELL_SCHOOL0_NAME = "physical"
SPELL_SCHOOL1_CAP = "Holy"
SPELL_SCHOOL1_NAME = "holy"
SPELL_SCHOOL2_CAP = "Fire"
SPELL_SCHOOL2_NAME = "fire"
SPELL_SCHOOL3_CAP = "Nature"
SPELL_SCHOOL3_NAME = "nature"
SPELL_SCHOOL4_CAP = "Frost"
SPELL_SCHOOL4_NAME = "frost"
SPELL_SCHOOL5_CAP = "Shadow"
SPELL_SCHOOL5_NAME = "shadow"
SPELL_SCHOOL6_CAP = "Arcane"
SPELL_SCHOOL6_NAME = "arcane"
SPELL_STAT1_NAME = "Strength"
SPELL_STAT2_NAME = "Agility"
SPELL_STAT3_NAME = "Stamina"
SPELL_STAT4_NAME = "Intellect"
SPELL_STAT5_NAME = "Spirit"
COMBAT_RATING_NAME1 = "Weapon Skill"
COMBAT_RATING_NAME2 = "Defense Rating"
COMBAT_RATING_NAME3 = "Dodge Rating"
COMBAT_RATING_NAME4 = "Parry Rating"
COMBAT_RATING_NAME5 = "Block Rating"
COMBAT_RATING_NAME6 = "Hit Rating"
COMBAT_RATING_NAME7 = "Hit Rating" -- Ranged hit rating
COMBAT_RATING_NAME8 = "Hit Rating" -- Spell hit rating
COMBAT_RATING_NAME9 = "Crit Rating" -- Melee crit rating
COMBAT_RATING_NAME10 = "Crit Rating" -- Ranged crit rating
COMBAT_RATING_NAME11 = "Crit Rating" -- Spell Crit Rating
COMBAT_RATING_NAME15 = "Resilience"
ARMOR = "Armor"
DEFENSE = "Defense"
DODGE = "Dodge"
PARRY = "Parry"
BLOCK = "Block"
--]]

TP_STR = 1
TP_AGI = 2
TP_STA = 3
TP_HEALTH = 4
TP_ARMOR = 5
TP_DEFENSE = 6
TP_DODGE = 7
TP_PARRY = 8
TP_BLOCK = 9
TP_BLOCKVALUE = 10
TP_RESILIENCE = 11

local L = AceLibrary("AceLocale-2.2"):new("TankPoints")
-- To translate AceLocale strings, replace true with the translation string
-- Before: ["Show Item ID"] = true,
-- After:  ["Show Item ID"] = "顯示物品編號",
L:RegisterTranslations("zhTW", function() return {
	-------------
	-- General --
	-------------
	["TankPoints"] = "坦克點",
	["Block Value"] = "格擋值",
	--------------------
	-- Character Info --
	--------------------
	-- Stats
	[" TP"] = " TP", -- concatenated after a school name for Spell TankPoints, ex: "Nature TP"
	[" DR"] = "減傷", -- concatenated after a school name for Damage Reductions, ex: "Nature DR"
	-- TankPoints Stat Tooltip
	["In "] = "在", -- concatenated before stance name, ex: "In Battle Stance"
	["Mob Stats"] = "怪物狀態",
	["Mob Level"] = "怪物等級",
	["Mob Damage"] = "怪物傷害",
	["Mob Crit"] = "怪物致命",
	["Mob Miss"] = "怪物未擊中",
	["Per StatValue"] = "每等價屬性的坦克點數",
	["Per Stat"] = "每一點屬性的坦克點數",
	["Hold ALT for Per Stat TankPoints"] = "按住 ALT 以顯示每一點屬性的坦克點數",
	-- Melee Reduction Tooltip
	[" Damage Reduction"] = "傷害減免", -- concatenated after a school name for Damage Reductions, ex: "Nature Damage Reduction"
	["Player Level"] = "玩家等級",
	["Combat Table"] = "戰鬥列表",
	["Crit"] = "致命",
	["Crushing"] = "輾壓",
	["Hit"] = "命中",
	-- Block Value Tooltip
	["Mob Damage before DR"] = "減傷前怪物傷害",
	["Mob Damage after DR"] = "減傷後怪物傷害",
	["Blocked Percentage"] = "格檔率",
	["Equivalent Block Mitigation"] = "等值檔格減傷",
	-- Spell TankPoints Tooltip
	["Melee/Spell Damage Ratio"] = "近戰/法術傷害比率",
	["Left click: Show next school"] = "左鍵: 顯示下一個屬性",
	["Right click: Show strongest school"] = "右鍵: 顯示最強的屬性",
	-- Spell Reduction Tooltip
	-- Toggle Calculator
	["Open Calculator"] = "開啟計算機",
	["Close Calculator"] = "關閉計算機",
	---------------------------
	-- Slash Command Options --
	---------------------------
	-- /tp calc
	["TankPoints Calculator"] = "坦克點計算機",
	["Shows the TankPoints Calculator"] = "顯示坦克點計算機",
	-- /tp tooltip
	["Tooltip Options"] = "工具提示選項",
	["TankPoints tooltip options"] = "坦克點工具提示選項",
	-- /tp tooltip diff
	["Show Tooltips Difference"] = "顯示工具提示差異",
	["Show TankPoints difference in item tooltips"] = "在物品工具提示中顯示坦克點差值",
	-- /tp tooltip total
	["Show Tooltips Total"] = "顯示工具提示總共",
	["Show TankPoints total in item tooltips"] = "在物品工具提示中顯示坦克點總值",
	-- /tp mob
	["Mob Stats"] = "怪物狀態",
	["Change default mob stats"] = "改變怪物預設狀態",
	-- /tp mob level
	["Mob Level"] = "怪物等級",
	["Sets the level difference between the mob and you"] = "設定你和怪物的等級差距",
	-- /tp mob damage
	["Mob Damage"] = "怪物傷害",
	["Sets mob's damage before damage reduction"] = "設定減傷之前的怪物傷害",
	-- /tp mob default
	["Restore Default"] = "還原為預設值",
	["Restores default mob stats"] = "還原預設怪物狀態",
	["Restored Mob Stats Defaults"] = "怪物狀態已經還原為預設值", -- command feedback
	-- /tp mob advanced
	["Mob Stats Advanced Settings"] = "怪物狀態進階設定",
	["Change advanced mob stats"] = "更進一步更改怪物狀態",
	-- /tp mob advanced crit
	["Mob Melee Crit"] = "怪物近戰致命",
	["Sets mob's melee crit chance"] = "設定怪物近戰的致命一擊機率",
	-- /tp mob advanced critbonus
	["Mob Melee Crit Bonus"] = "怪物近戰致命傷害加成",
	["Sets mob's melee crit bonus"] = "設定怪物近戰的致命一擊傷害加成",
	-- /tp mob advanced miss
	["Mob Melee Miss"] = "怪物近戰未擊中",
	["Sets mob's melee miss chance"] = "設定怪物近戰的未擊中機率",
	-- /tp mob advanced spellcrit
	["Mob Spell Crit"] = "怪物法術致命",
	["Sets mob's spell crit chance"] = "設定怪物法術的致命一擊機率",
	-- /tp mob advanced spellcritbonus
	["Mob Spell Crit Bonus"] = "怪物法術致命傷害加成",
	["Sets mob's spell crit bonus"] = "設定怪物法術的致命一擊傷害加成",
	-- /tp mob advanced spellmiss
	["Mob Spell Miss"] = "怪物法術未擊中",
	["Sets mob's spell miss chance"] = "設定怪物的法術未擊中率",
	----------------------
	-- GetDodgePerAgi() --
	----------------------
	["Cat Form"] = "獵豹形態",
	---------------------------
	-- GetTalantBuffEffect() --
	---------------------------
	["Soul Link"] = "靈魂鏈結",
	["Voidwalker"] = "虛空行者",
	["Righteous Fury"] = "正義之怒",
	["Pain Suppression"] = "痛苦鎮壓",
	["Shield Wall"] = "盾牆",
	["Death Wish"] = "死亡之願",
	["Recklessness"] = "魯莽",
	["Cloak of Shadows"] = "暗影披風",
	----------------------
	-- AlterSourceData() --
	----------------------
	["Bear Form"] = "熊形態",
	["Dire Bear Form"] = "巨熊形態",
	["Moonkin Form"] = "梟獸形態",
	-----------------------
	-- PlayerHasShield() --
	-----------------------
	["Shields"] = "盾",
	---------------------
	-- GetBlockValue() --
	---------------------
	["^(%d+) Block$"] = "^(%d+)格擋$",
	------------------------
	-- Item Scan Patterns --
	------------------------
	["ItemScan"] = {
		[TP_BLOCKVALUE] = {
			{"使你盾牌的格擋值提高(%d+)點。"},
			{"%+(%d+) 格擋值"},
		}
	},
	---------------------------
	-- TankPoints Calculator --
	---------------------------
	-- Title
	["TankPoints Calculator"] = "坦克點計算機",
	["Left click to drag\nRight click to reset position"] = "左鍵點擊以拖曳\n右鍵點擊以重置位置",
	-- Buttons
	["Reset"] = "重置",
	["Close"] = "關閉",
	-- Option frame box title
	["Results"] = "計算結果",
	["Player Stats"] = "玩家狀態",
	["Total Reduction"] = "總共減傷",
	["(%)"] = "(%)",
	["Max Health"] = "最大生命力",
	["Items"] = "Items",
	-------------------------
	-- TankPoints Tooltips --
	-------------------------
	[" (Top/Bottom):"] = " (上面/下面):",
	[" (Main/Off):"] = " (主手/副手):",
	[" (Main+Off):"] = " (主手+副手):",
	["Gems"] = "寶石",
} end)