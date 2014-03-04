RaidBoss = {}; RaidBoss.constants = {}; RaidBoss.constants.specs = {}; RaidBoss.constants.spells = {}; RaidBoss.constants.start = {}; RaidBoss.constants.finish = {}; RaidBoss.constants.groups = {}
local c = RaidBoss.constants; local specs = RaidBoss.constants.specs; local spells = RaidBoss.constants.spells; local start = RaidBoss.constants.start; local finish = RaidBoss.constants.finish; local groups = RaidBoss.constants.groups;
local L = LibStub("AceLocale-3.0"):GetLocale("RaidBoss")

------------------------------------------------
-- how to use this file                      ---
------------------------------------------------

--[[
	
	You can add as many spell groups/spells as you like. Each spell group will have a separate window on the player's UI.
	
	Defining a new group:
		groups.<namehere> = { name = "<namehere>", title = "<titlehere>" }
	Where name is a unique identifier, and title is some string to display in the respective window
	
	Defining a new spell:
		spells[<spell id>] = { group1 = "<groupname>", group2 = "<groupname>", group3 = ..., class = "<classname>", len=<spellduration>, cd=<basecooldown>, mt=<ismultitarget>, talentrequired=<istalentrequired>, thetalent=<othertalentrequired>, rolerequired=<role>, start=<start event>, finish=<finish event> }
		1. gruop1, group2, etc... define as many groups as you would like this spell to belong to.
		2. Class name MUST be an un-localised english name, in all-capitals
		3. 'mt' should be set to true for AoE-type abilities, or abilities which only affect the casting player. For abilities which are cast on other players, set this to false.
		4. (optional) thetalent: if talentrequired is true, then this will define a different talent to check for instead of the spellid
		5. start: combat log event which indicates the start of this event. If unsure, try "SPELL_CAST_SUCCESS"
		6. (optional) finish: combat log event which indicates the end of this event. Only useful for spells which can fail or be interrupted, such as channeled spells
		7. (optional) rolerequired; can be one of the following (non-localised) strings: "melee", "caster", "healer", "tank"
	
	Defining cooldown-modifying talents
		spells[<spell id>].talents = { [<talent id>] = { flatreduction = 10 } }
			OR
		spells[<spell id>].talents = { [<talent id>] = { percentreduction = 0.1 }} 
		1. Talent ID should be the spell id of the talent. If different points have different spell IDs, just use any of them
		2. The flat reduction and percent reductions are always applied per point. So for the above, 3 talent points spent in the talent would mean a 30 second or 30% cooldown reduction
		
]]

------------------------------------------------
-- spell groups                              ---
------------------------------------------------

	groups.raidheal = { name = "raidheal", title = L["Raid Heal Cooldowns"] }
	groups.raidmana = { name = "raidmana", title = L["Raid Mana Cooldowns"] }
	groups.tankheal = { name = "tankheal", title = L["Tank Heal Cooldowns"] }
	groups.tank = { name = "tank", title = L["Tank Cooldowns"], rolerequired="tank" }
	groups.bres = { name = "bres", title = L["Combat Resurrection"] }

------------------------------------------------
-- spells                                    ---
------------------------------------------------

-- SHAMAN
	-- Spirit Link Totem
	spells[98008] = { group1 = "raidheal", class = "SHAMAN", len=6, cd=180, mt=true, talentrequired=true, start="SPELL_CAST_SUCCESS" }
	
	-- Mana Tide
	spells[16190] = { group1 = "raidmana", class = "SHAMAN", len=12, cd=180, mt=true, talentrequired=true, start="SPELL_CAST_SUCCESS" }

-- DRUID
	-- Tranquility
	spells[740] = { group1 = "raidheal", class = "DRUID", len=8, cd=480, mt=true, talentrequired=false, start = "SPELL_AURA_APPLIED", finish = "SPELL_AURA_REMOVED" }
	spells[740].talents = { [92363] = { flatreduction = 150 } }
	
	-- 4set frenzied regen; just check for the berserk talent - simply assumes they have the bonus	
	spells[22842] = { group1 = "raidheal", group2="tank", class = "DRUID", len=20, cd=180, mt=true, talentrequired=true, thetalent=50334,  start = "SPELL_CAST_SUCCESS" }
	
	-- survival instincts (check for thick hide to eliminate some kittys)
	spells[61336] = { group1 = "tank", class = "DRUID", len=12, cd=180, mt=true, talentrequired=true, thetalent=16929,  start = "SPELL_CAST_SUCCESS" }
	
	-- barkskin (check for thick hide to eliminate some kittys)
	spells[22812] = { group1 = "tank", class = "DRUID", len=12, cd=60, mt=true, talentrequired=true, thetalent=16929, start = "SPELL_CAST_SUCCESS" }	
	
	-- rebirth -- using a fake length for visibility
	spells[20484] = { group1 = "bres", class = "DRUID", len=10, cd=600, mt=false, talentrequired=false, start="SPELL_RESURRECT" }

-- PRIEST
	-- Divine Hymn
	spells[64843] = { group1 = "raidheal", class = "PRIEST", len=8, cd=480, mt=true, talentrequired=false, start= "SPELL_AURA_APPLIED", finish="SPELL_AURA_REMOVED" }
	spells[64843].talents = { [87430] = { flatreduction = 150 } }

	-- barrier
	spells[62618] = { group1 = "raidheal", class = "PRIEST", len=10, cd=180, mt=true, talentrequired=true, start="SPELL_CAST_SUCCESS" }
	
	-- guardian spirit
	spells[47788] = { group1 = "tankheal", class = "PRIEST", len=10, cd=180, mt=false, talentrequired=true, start="SPELL_AURA_APPLIED", finish="SPELL_AURA_REMOVED" }
	
	-- pain suppression
	spells[33206] = { group1 = "tankheal",class = "PRIEST", len=8, cd=180, mt=false, talentrequired=true, start="SPELL_AURA_APPLIED", finish="SPELL_AURA_REMOVED" }
	
	-- hymn of hope
	spells[64901] = { group1 = "raidmana", class = "PRIEST", len=8, cd=360, mt=true, talentrequired=false, start="SPELL_AURA_APPLIED", finish="SPELL_AURA_REMOVED" }


-- WARRIOR
	-- Rallying Cry
	spells[97462] = { group1 = "raidheal",class = "WARRIOR", len=10, cd=180, mt=true, talentrequired=false, start="SPELL_CAST_SUCCESS" }
	
	-- shield wall (check for devastate)
	spells[871] = { group1 = "tank", group2="raidheal", class = "WARRIOR", len=12, cd=300, mt=true, talentrequired=true, thetalent=20243, start="SPELL_CAST_SUCCESS" }
	spells[871].talents = { [29598] = { flatreduction = 60 } } -- shield mastery
	
	-- last stand
	spells[12975] = { group1 = "tank", class = "WARRIOR", len=20, cd = 180, mt=true, talentrequired=true, start="SPELL_CAST_SUCCESS" }
	
-- PALADIN
	-- Aura Mastery
	spells[31821] = { group1 = "raidheal",class = "PALADIN", len=6, cd=120, mt=true, talentrequired=true, start="SPELL_CAST_SUCCESS" }
	
	-- divine guardian; once again just assuming tanks will have the 4set
	spells[70940] = { group1 = "raidheal",group2="tank", class = "PALADIN", len=6, cd=120, mt=true, talentrequired=true, start="SPELL_CAST_SUCCESS" }
	
	-- hand of sac
	spells[6940] = { group1 = "tankheal",class = "PALADIN", len=12, cd=120, mt=false, talentrequired=false, start="SPELL_AURA_APPLIED", finish="SPELL_AURA_REMOVED" }
	spells[6940].talents = {  [85446] = { percentreduction = 0.1 }, [93418] = { flatreduction = 15 } } -- ret and holy talents, respectively
	
	-- ardent defender
	spells[31850] = { group1 = "tank", class = "PALADIN", len=10, cd=180, mt=true, talentrequired=true, start="SPELL_CAST_SUCCESS" }
	
	-- divine protection -- check for ardent defender
	spells[498] = { group1 = "tank", class = "PALADIN", len = 10, cd = 60, mt=true, talentrequired=true, thetalent=31850, start="SPELL_CAST_SUCCESS" }
	
	-- lay on hands
	spells[633] = { group1 = "tankheal", class = "PALADIN", len = 0, cd = 600, mt=false, talentrequired=false, start="SPELL_CAST_SUCCESS" }
	spells[633].glyphs = { [57955] = { flatreduction = 180 } } -- glyph of lay onhands
	
	-- guardian of ancient kings (tank version only)
	spells[86659] = { group1 = "tank", class = "PALADIN", len=12, cd=300, mt=true, talentrequired=false, rolerequired="tank", start="SPELL_AURA_APPLIED" }
	spells[86659].talents = { [31848] = { flatreduction = 40 } } -- Shield of the Templar

-- DEATHKNIGHT
	-- Anti-Magic Zone
	spells[51052] = { group1 = "raidheal",class = "DEATHKNIGHT", len=10, cd=120, mt=true, talentrequired=true, start="SPELL_CAST_SUCCESS" }
	
	-- 4 set tier 13 vamp blood (assumed-willshow for any tank regardless of whether they actually have the set)
	-- vampiric blood
	spells[55233] = { group1 = "raidheal", group2 = "tank", class = "DEATHKNIGHT", len=10, cd=60, mt=true, talentrequired=true, start="SPELL_CAST_SUCCESS" }
	
	-- bone shield
	spells[49222] = { group1 = "tank", class = "DEATHKNIGHT", len=300, cd=60, mt=true, talentrequired=true, start="SPELL_CAST_SUCCESS", finish="SPELL_AURA_REMOVED" }
	
	-- rune tap
	-- spells[48982] = { group1 = "tank", class = "DEATHKNIGHT", len=1, cd=30, mt=true, talentrequired=true, start="SPELL_CAST_SUCCESS" }
	
	-- dancing rune weapon
	spells[49028] = { group1 = "tank", class = "DEATHKNIGHT", len=12, cd=90, mt=true, talentrequired=true, start="SPELL_CAST_SUCCESS" }
	
	-- icebound fortitude (check for dancing rune weapon)
	spells[48792] = { group1 = "tank", class= "DEATHKNIGHT", len=12, cd=180, mt=true, talentrequired=true, thetalent=49028, start="SPELL_CAST_SUCCESS" }
	
	-- anti magic shell (check for dancing rune weapon)
	spells[48707] = { group1 = "tank", class = "DEATHKNIGHT", len=5, cd=45, mt=true, talentrequired=true, thetalent=49028, start="SPELL_CAST_SUCCESS" }

	-- raise ally using a fake length for visibility
	spells[61999] = { group1 = "bres", class = "DEATHKNIGHT", len=10, cd=600, mt=false, talentrequired=false, start="SPELL_RESURRECT" }

-- LOCK
	
	-- Soulstone
	spells[95750] = { group1 = "bres", class = "WARLOCK", len=10, cd = 900, mt=false, talentrequired=false, start="SPELL_RESURRECT" }
