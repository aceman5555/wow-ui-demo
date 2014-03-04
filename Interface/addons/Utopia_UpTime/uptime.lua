local Utopia = LibStub("AceAddon-3.0"):GetAddon("Utopia", true)
if (not Utopia or Utopia.modules.UpTime) then
	return
end
Utopia:UpdateVersion("$Revision: 213 $")

local wowVersion = tonumber((select(2,GetBuildInfo())))

local d = Utopia.debugprint
local module = Utopia:NewModule("UpTime", "AceConsole-3.0", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceSerializer-3.0", "AceComm-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Utopia")
local LGT = LibStub("LibGroupTalents-1.0")
local bossid = LibStub("LibBossIDs-1.0").BossIDs
local db, dlookup, blookup, mlookup
local active
local new, del, copy, deepDel = Utopia.new, Utopia.del, Utopia.copy, Utopia.deepDel
local Gradient, UnitFullName, ClassColour, SmoothColour = Utopia.Gradient, Utopia.UnitFullName, Utopia.ClassColour, Utopia.SmoothColour
local rotate, propercase = Utopia.rotate, Utopia.propercase
local band = bit.band

local lzf = LibStub("LibZekFrames-1.0")
lzf:AssignTableResources(new, del, copy, deepDel)
lzf:AssignTextureResources(
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-ResizeGrip",
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-TopLeft",
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-Top",
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-TopRight",
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-BottomLeft",
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-Bottom",
	"Interface\\Addons\\Utopia\\Textures\\LibZekFrames-BottomRight"
)

local classOrder = {"WARRIOR", "DEATHKNIGHT", "ROGUE", "HUNTER", "DRUID", "SHAMAN", "PALADIN", "PRIEST", "MAGE", "WARLOCK"}
local classIndex = {}
for k,v in pairs(classOrder) do classIndex[v] = k end

-- Non configurable ignored mobs. Everything from Flame Leviathan basically plus a couple of extras
local ignoreMobIDs = {
	[4075] = true,		-- Rat
	[5913] = true,		-- Tremor Totem (Faction Champions)
	[5925] = true,		-- Grounding Totem (Faction Champions)
	[6112] = true,		-- Windfury Totem (Faction Champions)
	[14881] = true,		-- Spider
	[16129] = true,		-- Shadow Fissure (Kel'Thazud)
	[16286] = true,		-- Spore (Loatheb)
	[16400] = true,		-- Toxic Tunnel (Gluth)
	[16474] = true,		-- Blizzard (Sapphiron)
	[16486] = true,		-- Web Wrap (Maexxna)
	[16697] = true,		-- Void Zone (Four Horsemen)
	[28926] = true,		-- Spark of Ionar (Halls of Lightning)
	[34686] = true,		-- Healing Stream Totem (Faction Champions)
	[34784] = true,		-- Legion Flame (Jaraxxus)
	[34606] = true,		-- Frost Sphere (Anub'Arak)
	[34813] = true,		-- Infernal Volcano (Jaraxxus)
	[34825] = true,		-- Nether Portal (Jaraxxus)
	[34854] = true,		-- Fire Bomb (Jaraxxus)
	[30616] = true,		-- Flame Tsunami (Obsidian Sanctum)
	[30641] = true,		-- Twilight Fissure (Obsidian Sanctum)
	[30648] = true,		-- Fire Cyclone (Obsidian Sanctum)
	[32926] = true,		-- Flash Freeze (Hodir)
	[32938] = true,		-- Flash Freeze (Hodir)
	[33050] = true,		-- Unstable Sun Beam (Freya's Guardian)
	[33090] = true,		-- Pool of Tar (Flame Leviathan)
	[33113] = true,		-- Flame Leviathan
	[33134] = true,		-- Sara (Yogg-Saron)
	[33139] = true,		-- Flame Leviathan Turret (Flame Leviathan)
	[33142] = true,		-- Leviathan Defense Turret (Flame Leviathan)
	[33169] = true,		-- Icicle (Hodir)
	[33173] = true,		-- Snowpacked Icicle (Hodir)
	[33212] = true,		-- Hodir's Fury (Flame Leviathan)
	[33214] = true,		-- Mechanolift 304-A (Flame Leviathan)
	[33216] = true,		-- Mechagnome Pilot (Flame Leviathan)
	[33221] = true,		-- Scorch (Ignis)
	[33236] = true,		-- Steelforged Defender (Flame Leviathan)
	[33237] = true,		-- Ulduar Colossus (Flame Leviathan)
	[33255] = true,		-- Titanium Stormlord (Flame Leviathan)
	[33264] = true,		-- Ironwork Cannon (Flame Leviathan)
	[33367] = true,		-- Freya's Ward (Flame Leviathan)
	[33387] = true,		-- Writhing Lasher (Flame Leviathan)
	[33572] = true,		-- Steelforged Defender (Flame Leviathan)
	[33715] = true,		-- Charged Sphere (Ulduar Trash)
	[33990] = true,		-- Laughing Skull (Yogg-Saron)
	[34001] = true,		-- Void Zone (XT-002 Hard Mode)
	[34004] = true,		-- Life Spark (XT-002 Hard Mode)
	[34047] = true,		-- Rocket Strike (Mimiron)
	[34129] = true,		-- Nature Bomb (Freya)
	[34161] = true,		-- Mechanostriker 54-A (Flame Leviathan)
	[34164] = true,		-- Mechagnome Battletank (Flame Leviathan)
	[34194] = true,		-- Superheated Winds (Ulduar Trash)
	[34234] = true,		-- Runeforged Sentry (Flame Leviathan)
	[34275] = true,		-- Ward of Life (Flame Leviathan)
	[34288] = true,		-- Salvagebot Sawblade (Ulduar Trash)
	[34307] = true,		-- Time Bomb (Chillmaw)
	[34034] = true,		-- Swarming Guardian
	[34362] = true,		-- Proximity Mine (Mimiron)
	[34628] = true,		-- Concentrated Darkness (Val'kyr Twins)
	[34630] = true,		-- Concentrated Light (Val'kyr Twins)
	[36672] = true,		-- Coldflame (Lord Marrowgar)
	[37186] = true,		-- Frost Bomb (Sindragosa)
	[37690] = true,		-- Growing Ooze Puddle (Professor Putricide)
	[38163] = true,		-- Swarming Shadows
	[38288] = true,		-- Plagued Insect (ICC Critter)
}
module.ignoreMobIDs = ignoreMobIDs

-- Quick list of boss names when the guarenteed GUID lookup is not available in the fight
-- There's not many that won't be found near start of fight.
local unavailableBossNames = {
	[33288] = L["Yogg-Saron"],
	[33350] = L["Mimiron"],
	[32867] = L["Assembly of Iron"],		-- This is actually Steelbreaker's ID
	[-1] = L["The Four Horsemen"],
	[-2] = L["Faction Champions"],
	[-3] = L["Val'kyr Twins"],
	[-4] = L["Beasts of Northrend"],
	[-5] = L["Gunship Battle"],
}

-- Simple table to choose the right boss ID for the description in the fight listings
local bossEventGUIDLookup = {
	-- The Four Horsemen
	[16063] = -1,				-- Sir Zeliek
	[16064] = -1,				-- Thane Korth'azz
	[16065] = -1,				-- Lady Blaumeux
	[30549] = -1,				-- Baron Rivendare

	-- Instructor Razuvious
	[16803] = 16061,			-- Death Knight Understudy

	-- Thaddius
	[15929] = 15928,			-- Stalagg
	[15930] = 15928,			-- Feugen

	-- Iron Council
	[32857] = 32867,			-- Stormcaller Brundir
	[32867] = 32867,			-- Steelbreaker
	[32927] = 32867,			-- Runemaster Molgeim

	-- Thorim
	[32882] = 32865,			-- Jormungar Behemoth

	-- Freya
	[32913] = 32906,			-- Elder Ironbranch
	[32914] = 32906,			-- Elder Stonebark
	[32915] = 32906,			-- Elder Brightleaf

	-- Kologarn
	[32933] = 32930,			-- Left Arm
	[32934] = 32930,			-- Right Arm

	-- XT-002 Deconstructor
	[33329] = 33293,			-- Heart of the Deconstructor

	-- Mimiron
	[33432] = 33350,			-- Flame Leviathen Mk II -> Mimiron
	[33651] = 33350,			-- VX-001 -> Mimiron
	[33670] = 33350,			-- Aerial Command Unit -> Mimiron

	-- General Vezax
	[33524] = 33271,			-- Saronite Vapour

	-- Yogg-Saron
	[33890] = 33288,			-- Brain of Yogg-Saron
	[33136] = 33288,			-- Guardian of Yogg-Saron

	-- Auraiya
	[34014] = 33515,			-- Sanctum Sentry
	[34035] = 33515,			-- Feral Defender

	-- Beasts of Northrend
	[34796] = -4,				-- Gormok the Impaler
	[34797] = -4,				-- Icehowl
	[34799] = -4,				-- Dreadscale
	[34800] = -4,				-- Snobold Vassal
	[35144] = -4,				-- Acidmaw

	-- Faction Champions (Horde instance)
	[34460] = -2,				-- Kavina Grovesong
	[34461] = -2,				-- Tyrius Duskblade
	[34465] = -2,				-- Velanaa
	[34466] = -2,				-- Anthar Forgemender
	[34467] = -2,				-- Alyssia Moonstalker
	[34468] = -2,				-- Noozle Whizzlestick
	[34469] = -2,				-- Melador Valestrider
	[34470] = -2,				-- Saamul
	[34471] = -2,				-- Baelnor Lightbearer
	[34472] = -2,				-- Irieth Shadowstep
	[34473] = -2,				-- Brienna Nightfell
	[34474] = -2,				-- Serissa Grimdabbler
	[34475] = -2,				-- Shocuul

	-- Faction Champions (Alliance instance)
	[34441] = -2,				-- Vivienne
	[34444] = -2,				-- Thrakgar
	[34445] = -2,				-- Liandra
	[34447] = -2,				-- Caiphus
	[34448] = -2,				-- Ruj'kah
	[34449] = -2,				-- Ginselle
	[34450] = -2,				-- Harkzog
	[34451] = -2,				-- Birana
	[34453] = -2,				-- Narrhok
	[34454] = -2,				-- Maz'dinah
	[34455] = -2,				-- Broln
	[34456] = -2,				-- Malithas
	[34458] = -2,				-- Gorgrim
	[34459] = -2,				-- Erin

	-- Val'kyr Twins
	[34496] = -3,				-- Eydis Darkbane
	[34497] = -3,				-- Fjola Lightbane

	-- Gunship
	[36948] = -5,				-- Muradin Bronzebeard
	[36950] = -5,				-- Skybreaker Marine
	[36961] = -5,				-- Skybreaker Sergeant
	[36969] = -5,				-- Skybreaker Rifleman
	[36978] = -5,				-- Skybreaker Mortar Soldier
	[37116] = -5,				-- Skybreaker Sorcerer
}

local BossIDWeakLookup = setmetatable({}, {
	__mode = "k",
	__index = function(self, guid)
		local id = tonumber(strsub(guid, -12, -7), 16)
		self[guid] = bossid[id] and true or false
		return self[guid]
	end,
})

local function optionsHide()
	return not Utopia.db.profile.modules.UpTime
end

local function getFunc(info) return db[info[#info]] end
local function setFunc(info, value) db[info[#info]] = value end

module.options = {
	type = "group",
	name = L["Up-Time"],
	desc = L["Records debuff up-time on fights"],
	get = getFunc,
	set = getFunc,
	guiInline = true,
	order = 100,
	args = {
		notifications = {
			type = "toggle",
			name = L["Notifications"],
			desc = L["Display start and end statistics of fights. More to remind you that data is being stored and munching your addon ram up than anything else"],
			order = 90,
			hidden = optionsHide,
		},
		recording = {
			type = "group",
			name = L["Recording Options"],
			desc = L["Recording Options"],
			guiInline = true,
			get = getFunc,
			set = setFunc,
			order = 100,
			hidden = optionsHide,
			args = {
				bossesOnly = {
					type = "toggle",
					name = L["Bosses Only"],
					desc = L["Only record boss fights"],
					order = 10,
				},
				recordDPS = {
					type = "toggle",
					name = L["Record DPS"],
					desc = L["Records DPS during fights. Just the basics; damage done to each mob per second by any source in your group. So you can see how raid debuffs are affecting things"],
					order = 30,
				},
				playerDPS = {
					type = "toggle",
					name = L["Individual Raid DPS"],
					desc = L["Records DPS seperately for each raid member during fights. Simply dmg done in each 1 second window during a fight, with no number crunching until you view it later. This will obviously store a little more data than without"],
					disabled = function() return not db.recordDPS end,
					order = 35,
				},
				schoolDPS = {
					type = "toggle",
					name = L["Typed DPS"],
					desc = L["Records Physical and Magical DPS seperately for the whole raid"],
					disabled = function() return not db.recordDPS end,
					order = 36,
				},
				recordDeaths = {
					type = "toggle",
					name = L["Record Deaths"],
					desc = L["Records raid member deaths during fights"],
					order = 40,
				},
				bossEvents = {
					type = "toggle",
					name = L["Record Events"],
					desc = L["Records significant events during a boss encounter which can be later marked on the chart"],
					order = 50,
				},
				minimumDuration = {
					type = "range",
					name = L["Minimum Duration"],
					desc = L["Set the minimum duration for a fight to be stored for (last fight is always stored temporarily)"],
					order = 310,
					min = 0,
					max = 600,
					step = 1,
				},
				keep = {
					type = "range",
					name = L["History Size"],
					desc = L["How many fights to keep"],
					order = 320,
					min = 1,
					max = 500,
					step = 1,
				},
			},
		},
		display = {
			type = "group",
			name = L["Display"],
			desc = L["Display settings"],
			guiInline = true,
			get = getFunc,
			set = setFunc,
			order = 300,
			hidden = optionsHide,
			args = {
				mergeAppliers = {
					type = "toggle",
					name = L["Merge Appliers"],
					desc = format(L["Merge appliers of the same spell into a single display texture if they are just swapping application of a debuff. %s for example"], GetSpellInfo(13218)),
					order = 5,
				},
				coloursExtreme = {
					type = "toggle",
					name = L["Coloured Categories"],
					desc = L["Colour the category names to reflect all the class colours applicable (Bring Shades)"],
					order = 10,
		        },
			},
		},
	},
}

local FRIEND_FLAGS = COMBATLOG_OBJECT_AFFILIATION_MINE + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
local ENEMY_FLAGS = COMBATLOG_OBJECT_REACTION_HOSTILE + COMBATLOG_OBJECT_REACTION_NEUTRAL
local EXLCUDE_FLAGS = COMBATLOG_OBJECT_TYPE_OBJECT + COMBATLOG_OBJECT_TYPE_PLAYER

-- MakeDestKey
-- Make a compressed Mob GUID for storing, and an ID -> Name lookup attached to the fight data
-- 0xF530000ABCD000123 becomes 43981:1
-- 0xF530000ABCD000492 becomes 43981:2
function module:MakeDestKey(fight, name, guid)
	local mobID = tonumber(guid:sub(-12, -7), 16)
	if (mobID <= 9 or ignoreMobIDs[mobID] or db.ignoreMobIDs[mobID]) then
		return
	end
	local mobUnique = tonumber(guid:sub(-6), 16)

	local lookup = fight.mobLookup[mobID]
	if (not lookup) then
		lookup = new()
		fight.mobLookup[mobID] = lookup
	end
	local key = lookup[mobUnique]
	if (not key) then
		key = (self.lastID[mobID] or 0) + 1
		self.lastID[mobID] = key
		lookup[mobUnique] = key
	end

	local mob = fight.mobs[mobID]
	if (not mob) then
		if (not name) then
			return
		end
		fight.mobs[mobID] = name
	end
	if (key == 1) then
		return mobID
	end
	return format("%d:%d", mobID, key)
end

-- MakeSourceKey
-- Make a compressed Player GUID for storing, and an ID -> Name lookup attached to the fight data
-- 0x0100000000009AFEB becomes 9AFEB
function module:MakeSourceKey(fight, name, guid)
	local playerID = tonumber(guid:sub(-8), 16)
	local player = fight.players[playerID]
	if (not player) then
		if (not name) then
			return
		end
		local _, class = UnitClass(name)
		if (class) then
			fight.players[playerID] = format("%s:%s", name, classIndex[class])
		else
			fight.players[playerID] = name
		end
	end
	return format("%X", playerID)
end

-- BuildStoredData
function module:BuildStoredData(fight, timeStart, timeEnd, sourceName, sourceGUID, spellId, realSpellId, stacks)
	local temp = new()
	local playerID = tonumber(sourceGUID:sub(-8), 16)
	local sourceKey = self:MakeSourceKey(fight, sourceName, sourceGUID)
	if (not sourceKey) then
		return
	end
	timeEnd = timeEnd and (timeEnd - timeStart)
	timeStart = max(0, timeStart - fight.combatStart)

	local spellInfo = dlookup[GetSpellInfo(spellId)]
	if (spellInfo) then
		if (spellInfo.improved) then
			local improved = LGT:UnitHasTalent(sourceName, spellInfo.improved)
			if (improved) then
				-- Show if it's improved in the data
				return format("%.3f,%.3f,%s,%d,%s,%s", timeStart, timeEnd or 0, sourceKey, spellId, realSpellId ~= spellId and realSpellId or "", improved)
			end
		elseif (spellInfo.maxTalentPoints and spellInfo.requiredTalent and spellInfo.amountPerTalentPoint) then
			local gotPoints = LGT:UnitHasTalent(sourceName, spellInfo.requiredTalent)
			if (gotPoints and gotPoints < spellInfo.maxTalentPoints) then
				-- Show if it's NOT max talented in data
				return format("%.3f,%.3f,%s,%d,%s,%s", timeStart, timeEnd or 0, sourceKey, spellId, realSpellId ~= spellId and realSpellId or "", gotPoints)
			end
		elseif (spellInfo.maxStacks) then
			return format("%.3f,%.3f,%s,%d,%s,%s", timeStart, timeEnd or 0, sourceKey, spellId, realSpellId ~= spellId and realSpellId or "", stacks or 1)
		end
	end

	if (realSpellId and realSpellId ~= spellId) then
		return format("%.3f,%.3f,%s,%d,%d", timeStart, timeEnd or 0, sourceKey, spellId, realSpellId)
	end

	return format("%.3f,%.3f,%s,%d", timeStart, timeEnd or 0, sourceKey, spellId)
end

-- GetStoredData
function module:GetStoredData(fight, data)
	local timeStart, timeEnd, sourceID, spellId, realSpellId, improved = strsplit(",", data)
	sourceID = tonumber(sourceID, 16)
	timeStart = tonumber(timeStart) + fight.combatStart
	local player, playerClass = strsplit(":", fight.players[sourceID])
	return timeStart, tonumber(timeEnd) + timeStart, player, playerClass and classOrder[tonumber(playerClass)], format("0x010%013X", sourceID), tonumber(spellId), tonumber(realSpellId), tonumber(improved)
end

-- MobIDFromKey
function module:MobIDFromKey(key)
	if (type(key) == "number") then
		return key
	else
		local mobid, index = strsplit(":", key)
		mobid = tonumber(mobid)
		index = index and tonumber(index) or nil
		return mobid, index
	end
end

-- MakeMobGUID
local function MakeMobGUID(key)
	local id, ind = module:MobIDFromKey(key)
	return format("0xF53%07X%06X", id, ind or 1)
end

local bossSPELL_AURA_APPLIED = {
	[64163] = 4,								-- Yogg-Saron: Lunatic Gaze, 4 secs
	[64164] = 4,								-- Yogg-Saron: Lunatic Gaze, 4 secs
	[63849] = 30,								-- XT-002: Exposed Heart
	[64193] = true,								-- XT-002: Heartbreak
	[62269] = true,								-- Iron Council: Runemaster Molgeim: Rune of Death
	[63490] = true,								-- Iron Council: Runemaster Molgeim: Rune of Death
	[61886] = 35,								-- Iron Council: Stormcaller Brundir: Lightning Tendrils
	[63485] = 35,								-- Iron Council: Stormcaller Brundir: Lightning Tendrils
	[61869] = 6,								-- Iron Council: Stormcaller Brundir: Overload
	[63481] = 6,								-- Iron Council: Stormcaller Brundir: Overload
	[62478] = 20,								-- Hodir: Frozen Blows
	[63512] = 20,								-- Hodir: Frozen Blows
	[62662] = 10,								-- General Vezax: Surge of Darkness
	[64455] = "Feral Defender Up",				-- Auriaya: Feral Essence
	[67650] = true,								-- Arctic Breath
	[67660] = true,								-- Massive Crash

	-- Icehowl
	[67650] = 5,								-- Arctic Breath
	[66689] = 5,								-- Arctic Breath
	[67651] = 5,								-- Arctic Breath (10 heroic)
	[67652] = 5,								-- Arctic Breath (25 heroic)
	[66758] = 15,								-- Staggered Daze
	[67657] = true,								-- Frothing Rage
	[67658] = true,								-- Frothing Rage (10 heroic)
	[66759] = true,								-- Frothing Rage
	[67659] = true,								-- Frothing Rage (25 heroic)

	-- Faction Champions
	[65947] = 8,								-- Bladestorm
	[65980] = true,								-- Bloodlust
	[65983] = true,								-- Heroism

	-- Twin Val'kyr
	[65858] = true,								-- Shield of Lights (10 normal)
	[67259] = true,								-- Shield of Lights (25 normal)
	[67260] = true,								-- Shield of Lights (10 heroic)
	[67261] = true,								-- Shield of Lights (25 heroic)
	[67256] = true,								-- Shield of Darkness (25 normal)
	[65874] = true,								-- Shield of Darkness
	[67257] = true,								-- Shield of Darkness (10 heroic)
	[67258] = true,								-- Shield of Darkness

	-- Lord Marrowgar
	[69076] = 15,								-- Bonestorm

	-- Saurfang
	[72737] = true,								-- Frenzy
}

local bossSPELL_AURA_REMOVED = {
	-- Deathwhisper
	[70842] = format(L["BOSSPHASE"], 2),		-- Mana Barrier Removed
}

local bossSPELL_CAST_SUCCESS = {
	--[64144] = "Crusher Tentacle Spawns",		-- Yogg-Saron: Erupt (seems to be any testicle)
	[62130] = true,								-- Thorim: Unbalancing Strike
	[63414] = 4,								-- Mimiron: Spinning Up
	[60835] = true,								-- General Vezax: Shadow Crash
	[62660] = true,								-- General Vezax: Shadow Crash
	[64412] = true,								-- Algalon: Phase Punch
	[62301] = true,								-- Algalon: Cosmic Smash
	[64598] = true,								-- Algalon: Cosmic Smash
	[64218] = 20,								-- Emalon: Overcharge
	[61889] = true,								-- Iron Council: Meltdown

	-- Jaraxxus
	[66269] = true,								-- Nether Portal (10 normal)
	[67898] = true,								-- Nether Portal (25 normal)
	[67899] = true,								-- Nether Portal (10 heroic)
	[67900] = true,								-- Nether Portal (25 heroic)
	[66258] = true,								-- Infernal Eruption (10 normal)
	[67901] = true,								-- Infernal Eruption (25 normal)
	[67902] = true,								-- Infernal Eruption (10 heroic)
	[67903] = true,								-- Infernal Eruption (25 heroic)

	-- Anub
	[66118] = true,								-- Leeching Swarm

	-- Saurfang
	[72293] = true,								-- Mark of the Fallen Champion

	-- Festergut
	[69278] = 12,								-- Gas Spore
	[71221] = 12,								-- Gas Spore

	-- Putricide
	[71255] = true,								-- Choking Gas Bomb

	-- Blood Princess
	[71336] = true,								-- Pact of the Darkfallen
	[73070] = 4,								-- Incite Terror

	-- Sindragosa
	[70126] = 6,								-- Icy Grip
}

local bossSPELL_CAST_START = {
	[62776] = 12,								-- XT-002: Tympanic Tantrum
	[64623] = 2,								-- Mimiron: Frost Bomb
	[63631] = 4,								-- Mimiron: Shock Blast
	[62997] = 3,								-- Mimiron: Plasma Blast
	[64529] = 3,								-- Mimiron: Plasma Blast
	[63493] = true,								-- Iron Council: Steelbreaker: Fusion Punch
	[61903] = true,								-- Iron Council: Steelbreaker: Fusion Punch
	[62273] = true,								-- Iron Council: Runemaster Molgeim: Rune of Summoning
	[61974] = true,								-- Iron Council: Runemaster Molgeim: Rune of Power
	[61973] = true,								-- Iron Council: Runemaster Molgeim: Rune of Power
	[63472] = true,								-- Ignis: Flame Jets
	[62680] = true,								-- Ignis: Flame Jets
	[61968] = 9,								-- Hodir: Flash Freeze
	[64422] = true,								-- Auriaya: Sonic Screech
	[64688] = true,								-- Auriaya: Sonic Screech
	[64386] = true,								-- Auriaya: Terrifying Screech
	[64443] = 8,								-- Algalon: Big Bang
	[64584] = 8,								-- Algalon: Big Bang
	[64216] = 5,								-- Emalon: Lightning Nova
	[65279] = 5,								-- Emalon: Lightning Nova
	[58663] = true,								-- Archavon: Stomp
	[60880] = true,								-- Archavon: Stomp

	-- Jormungers
	[66821] = 3.5,								-- Molten Spew (Dreadscale)

	-- Icehowl
	[67660] = true,								-- Massive Crash
	[66683] = true,								-- Massive Crash
	[67661] = true,								-- Massive Crash (10 heroic)
	[67662] = true,								-- Massive Crash

	-- Twin Val'kyr
	[66046] = true,								-- Light Vortex (10 normal)
	[67206] = true,								-- Light Vortex (25 normal)
	[67207] = true,								-- Light Vortex (10 heroic)
	[67208] = true,								-- Light Vortex (25 heroic)
	[66058] = true,								-- Dark Vortex (10 normal)
	[67182] = true,								-- Dark Vortex (25 normal)
	[67183] = true,								-- Dark Vortex (10 heroic)
	[67184] = true,								-- Dark Vortex (25 heroic)

	-- Anub'arak
	[67322] = true,								-- Submerge

	-- Lord Marrowgar
	[70826] = true,								-- Bonespike Graveyard (25)
	[72089] = true,								-- Bonespike Graveyard (25 hard)
	[69057] = true,								-- Bonespike Graveyard (10)

	-- Festergut
	[72227] = true,								-- Gastric Explosion
	[72228] = true,								-- Gastric Explosion
	[72229] = true,								-- Gastric Explosion
	[72230] = true,								-- Gastric Explosion
	[69195] = true,								-- Gastric Blight (10)
	[71219] = true,								-- Gastric Blight (25)
	[73031] = true,								-- Gastric Blight (10h)
	[73032] = true,								-- Gastric Blight (25h)

	-- Rotface
	[69508] = 7,								-- Slime Spray

	-- Putricide
	[71966] = true,								-- Unstable Experiment
	[71617] = true,								-- Tear Gas

	-- Sindrigosa
	[69712] = true,								-- Ice Tomb
	[71047] = 5,								-- Blistering Cold
	[70123] = 5,								-- Blistering Cold

	-- Lich King
	[70372] = true,								-- Summon Shambling Horror
	[72762] = true,								-- Defile
	[74270] = 10,								-- Remourseless Winter
	[72262] = true,								-- Quake
	[70498] = 5,								-- Raging Spirits
}

local bossSPELL_SUMMON = {
	[64444] = 15,								-- Mimiron: Weakened
}

local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
-- FixForPets
local function FixForPets(sourceGUID, sourceName, sourceFlags)
	if (band(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == 0) then
		-- Someone's pet
		local owner = Utopia.petlookup and Utopia.petlookup[sourceGUID]
		if (owner) then
			local guid = UnitGUID(owner)
			if (guid) then
				return guid, owner
			end
		end
		return
	end
	return sourceGUID, sourceName
end

-- AddBossEvent
function module:AddBossEvent(text, duration)
	if (self.bossEvents) then
		local timestamp = self.lastTimestamp
		for i = #self.bossEvents,1,-1 do
			local entry = self.bossEvents[i]
			if (entry[2] < timestamp - 1) then
				break
			elseif (entry[1] == text and entry[2] >= timestamp - 1) then
				-- Throttle same events for spellIDs that occur on multiple players within small window (1 second)
				-- TODO: Retroactive cleanup
				return
			end
		end

		tinsert(self.bossEvents, new(text, timestamp, duration))
	end
end

-- AddAura
function module:AddAura(timestamp, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, realSpellId, realSpellName, auraType, stacks)
	local fight = self.fight
	if (fight and auraType == "DEBUFF") then
		local spellInfo = dlookup[spellName]
		if (destName and sourceName and spellInfo) then
			if (stacks and spellInfo.maxStacks) then
				-- Applied Dose, so finish previous and reapply new level
				self:RemoveAura(timestamp, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, realSpellId, realSpellName, auraType)
			end

			if (not fight.combatStart) then
				fight.combatStart = timestamp
			end

			local target = active[destGUID]
			if (not target) then
				target = new()
				active[destGUID] = target
			end

			sourceGUID, sourceName = FixForPets(sourceGUID, sourceName, sourceFlags)
			if (not sourceGUID) then
				return
			end

			local source = target[sourceGUID]
			if (not source) then
				source = new()
				target[sourceGUID] = source
			end

			local s = source[spellName]
			if (not s) then
				local n = new()
				n.timeStart = timestamp
				n.spellId = spellId
				n.realSpellId = realSpellId

				if (spellInfo.maxStacks) then
					if (stacks) then
						n.stacks = stacks
					else
						n.stacks = 1
					end
				end

				source[spellName] = n
			end

			self.lastEventTime = timestamp
			self.applyCount = self.applyCount + 1
		end

		local mapList = mlookup[spellName]
		if (mapList) then
			for i,map in ipairs(mapList) do
				local mapping = dlookup[map.key]
				if (not mapping or not mapping.requiredTalent or LGT:UnitHasTalent(sourceName, mapping.requiredTalent)) then
					self:AddAura(timestamp, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, mapping and mapping.id or 0, map.key, realSpellId or spellId, realSpellName or spellName, auraType)
				end
			end
		end
	end
end

-- RemoveAura
function module:RemoveAura(timestamp, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, realSpellId, realSpellName, auraType)
	local fight = self.fight
	if (fight and auraType == "DEBUFF") then
		if (dlookup[spellName]) then
			local target = active[destGUID]
			if (target) then
				sourceGUID, sourceName = FixForPets(sourceGUID, sourceName, sourceFlags)
				if (not sourceGUID) then
					return
				end
				
				local source = target[sourceGUID]
				if (source) then
					local s = source[spellName]
					if (s) then
						source[spellName] = nil

						if (not fight.combatStart) then
							fight.combatStart = timestamp
						end

						if (timestamp > s.timeStart + 0.0009) then	-- Skip things that disappear the same timestamp they apply
							local destKey = self:MakeDestKey(fight, destName, destGUID)
							if (destKey) then
								local entry = self:BuildStoredData(fight, s.timeStart, timestamp, sourceName, sourceGUID, spellId, realSpellId, s.stacks)
								local data = fight.data[destKey]
								if (not data) then
									data = new()
									fight.data[destKey] = data
								end
								tinsert(data, entry)
							end
						end

						self.lastEventTime = timestamp
						self.removeCount = self.removeCount + 1
						del(s)
					end
				end
			end
		end

		local mapList = mlookup[spellName]
		if (mapList) then
			for i,map in ipairs(mapList) do
				local mapping = dlookup[map.key]
				if (not mapping or not mapping.requiredTalent or LGT:UnitHasTalent(sourceName, mapping.requiredTalent)) then
					module:RemoveAura(timestamp, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, mapping and mapping.id or 0, map.key, realSpellId or spellId, realSpellName or spellName, auraType)
				end
			end
		end
	end
end

-- RecordDamage
function module:RecordDamage(timestamp, raidDmg, sourceGUID, sourceName, sourceFlags, destGUID, destName, amount, physical)
	local f = self.fight
	if (not f) then
		return
	elseif (not f.combatStart) then
		f.combatStart = timestamp
	end

	local destKey = self:MakeDestKey(f, destName, destGUID)
	if (destKey) then
		local index = floor(timestamp - f.combatStart) + 1
		self:RecordDamagePart(destKey, index, raidDmg, amount, physical)

		if (raidDmg and self.playerdps) then
			sourceGUID, sourceName = FixForPets(sourceGUID, sourceName, sourceFlags)
			if (not sourceGUID) then
				return
			end
			local sourceID = tonumber(sourceGUID:sub(-8), 16)
			if (sourceID) then
				if (not f.players[sourceID]) then
					self:MakeSourceKey(f, sourceName, sourceGUID)
				end

				self:RecordPlayerDamage(destKey, index, sourceID, amount)
			end
		end
	end
end

-- RecordDamage
function module:RecordPlayerDamage(destKey, index, sourceID, amount, physical)
	local target = self.playerdps[destKey]
	if (not target) then
		target = new()
		self.playerdps[destKey] = target
	end

	local playerTarget = target[sourceID]
	if (not playerTarget) then
		playerTarget = new()
		target[sourceID] = playerTarget
	end

	for i = #playerTarget + 1,index - 1 do
		tinsert(playerTarget, 0)
	end
	playerTarget[index] = (playerTarget[index] or 0) + amount
end

-- RecordDamagePart
function module:RecordDamagePart(destKey, index, raidDmg, amount, physical)
	local target
	if (raidDmg) then
		local base
		if (db.schoolDPS) then
			base = self[physical and "dpsp" or "dpsm"]
		else
			base = self.dps
		end

		target = base[destKey]
		if (not target) then
			target = new()
			base[destKey] = target
		end
	else
		target = self.bossdps[destKey]
		if (not target) then
			target = new()
			self.bossdps[destKey] = target
		end
	end			

	for i = #target + 1,index - 1 do
		tinsert(target, 0)
	end
	target[index] = (target[index] or 0) + amount
end

local clEvents = {}
local dpsEvents = {}

-- SPELL_AURA_APPLIED
function clEvents:SPELL_AURA_APPLIED(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags,
	spellId, spellName, spellSchool, auraType)

	if (band(sourceFlags, FRIEND_FLAGS) ~= 0) then
		if (band(destFlags, ENEMY_FLAGS) ~= 0 and band(destFlags, FRIEND_FLAGS) == 0) then
			if (band(destFlags, EXLCUDE_FLAGS) == 0) then
				if (not db.bossesOnly or BossIDWeakLookup[destGUID]) then
					self:AddAura(timestamp, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, nil, nil, auraType)
				end
			end
		end
	else
		if (self.bossEvents) then
			-- Check for significant boss event auras
			local result = bossSPELL_AURA_APPLIED[spellId]
			if (result) then
				self:AddBossEvent(spellId, type(result) == "number" and result or nil)
			end
		end
	end
end

-- SPELL_AURA_APPLIED_DOSE
function clEvents:SPELL_AURA_APPLIED_DOSE(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags,
	spellId, spellName, spellSchool, auraType, stacks)

	if (band(sourceFlags, FRIEND_FLAGS) ~= 0) then
		if (band(destFlags, ENEMY_FLAGS) ~= 0 and band(destFlags, FRIEND_FLAGS) == 0) then
			if (band(destFlags, EXLCUDE_FLAGS) == 0) then
				self:AddAura(timestamp, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, nil, nil, auraType, stacks)
			end
		end
	end
end

local feignDeath = GetSpellInfo(5384)
local spiritOfRedemption = GetSpellInfo(20711)
local rebirth = GetSpellInfo(20484)

-- SPELL_CAST_SUCCESS
function clEvents:SPELL_CAST_SUCCESS(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags,
	spellId, spellName, spellSchool)

	if (self.deaths) then
		if (spellName == rebirth and destName) then
			if (band(destFlags, FRIEND_FLAGS) ~= 0) then
				if (UnitInRaid(destName) or UnitInParty(destName)) then
					tinsert(self.deaths, new(timestamp, destName, destGUID, sourceName, sourceGUID))
				end
			end
		end
	end

	if (self.bossEvents) then
		local result = bossSPELL_CAST_SUCCESS[spellId]
		if (result) then
			if (type(result) == "string") then
				self:AddBossEvent(result)
			elseif (type(result) == "number") then
				self:AddBossEvent(spellId, result)
			else
				self:AddBossEvent(spellId)
			end
		end
	end
end

-- SPELL_CAST_SUCCESS
function clEvents:SPELL_CAST_START(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags,
	spellId, spellName, spellSchool)

	if (self.bossEvents) then
		local result = bossSPELL_CAST_START[spellId]
		if (result) then
			if (type(result) == "string") then
				self:AddBossEvent(result)
			elseif (type(result) == "number") then
				self:AddBossEvent(spellId, result)
			else
				self:AddBossEvent(spellId)
			end
		end
	end
end

-- SPELL_AURA_REMOVED
function clEvents:SPELL_AURA_REMOVED(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags,
	spellId, spellName, spellSchool, auraType)

	if (band(sourceFlags, FRIEND_FLAGS) ~= 0) then
		if (band(destFlags, ENEMY_FLAGS) ~= 0 and band(destFlags, FRIEND_FLAGS) == 0) then
			if (band(destFlags, EXLCUDE_FLAGS) == 0) then
				if (not db.bossesOnly or BossIDWeakLookup[destGUID]) then
					self:RemoveAura(timestamp, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, nil, nil, auraType)
				end
			end
		end
	end

	if (self.bossEvents) then
		local result = bossSPELL_AURA_REMOVED[spellId]
		if (result) then
			if (type(result) == "string") then
				self:AddBossEvent(result)
			elseif (type(result) == "number") then
				self:AddBossEvent(spellId, result)
			else
				self:AddBossEvent(spellId)
			end
		end
	end
end

-- UNIT_DIED
function clEvents:UNIT_DIED(timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags)
	if (self.deaths) then
		if (band(destFlags, FRIEND_FLAGS) ~= 0) then
			if (UnitInRaid(destName) or UnitInParty(destName)) then
				if (not UnitBuff(destName, spiritOfRedemption) and not UnitBuff(destName, feignDeath)) then
					tinsert(self.deaths, new(timestamp, destName, destGUID))
				end
			end
		end
	end
	if (band(destFlags, ENEMY_FLAGS) ~= 0) then
		self:MobDeath(timestamp, destGUID, destName, destFlags)
	end
end

-- SPELL_DAMAGE
function dpsEvents:SWING_DAMAGE(timestamp, raidDmg, sourceGUID, sourceName, sourceFlags, destGUID, destName, amount, overkill)
	self:RecordDamage(timestamp, raidDmg, sourceGUID, sourceName, sourceFlags, destGUID, destName, amount - overkill, true)
end

-- SPELL_DAMAGE
local SCHOOL_MASK_PHYSICAL = SCHOOL_MASK_PHYSICAL
function dpsEvents:SPELL_DAMAGE(timestamp, raidDmg, sourceGUID, sourceName, sourceFlags, destGUID, destName, spellId, spellName, spellSchool, amount, overkill)
	self:RecordDamage(timestamp, raidDmg, sourceGUID, sourceName, sourceFlags, destGUID, destName, amount - overkill, spellSchool == SCHOOL_MASK_PHYSICAL)
end

dpsEvents.RANGE_DAMAGE = dpsEvents.SPELL_DAMAGE
dpsEvents.SPELL_PERIODIC_DAMAGE = dpsEvents.SPELL_DAMAGE

local fightStarters = {
	SPELL_DAMAGE = true,
	SWING_DAMAGE = true,
	SPELL_AURA_APPLIED = true,
}
local ignoreSpells = {
	[GetSpellInfo(1130)] = true,				-- Hunter's Mark
}

-- COMBAT_LOG_EVENT_UNFILTERED
function module:COMBAT_LOG_EVENT_UNFILTERED(_, timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
	if (not active) then
		-- Check for start of a fight by someone in group, first events will happen before you enter combat
		-- We do this because first events will often happen before you're in combat, and we don't really
		-- want to miss anything
		if (sourceFlags and band(sourceFlags, FRIEND_FLAGS) ~= 0) then
			if (destFlags and band(destFlags, ENEMY_FLAGS) ~= 0 and band(destFlags, FRIEND_FLAGS) == 0) then
				if (band(destFlags, EXLCUDE_FLAGS) == 0) then
					if (sourceName and (UnitInRaid(sourceName) or UnitInParty(sourceName))) then
						if (not fightStarters[event]) then
							return
						end
						if (event == "SPELL_AURA_APPLIED") then
							local spellId, spellName = ...
							if (ignoreSpells[spellName]) then
								-- Don't start a fight with Hunter's Mark or Mark of Blood
								return
							end
						end

						self:StartFighting()
					end
				end
			end
		end
	end
	if (active) then
		self.lastTimestamp = timestamp
		local f = clEvents[event]
		if (f) then
			f(self, timestamp, event, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
		elseif (self.dps or self.dpsp or self.dpsm) then
			f = dpsEvents[event]
			if (f) then
				if (band(sourceFlags, FRIEND_FLAGS) ~= 0) then
					if (band(destFlags, ENEMY_FLAGS) ~= 0 and band(destFlags, FRIEND_FLAGS) == 0) then
						if (not db.bossesOnly or BossIDWeakLookup[destGUID]) then
							f(self, timestamp, true, sourceGUID, sourceName, sourceFlags, destGUID, destName, ...)
						end
					end
				elseif (band(sourceFlags, ENEMY_FLAGS) ~= 0 and band(sourceFlags, EXLCUDE_FLAGS) == 0) then
					if (band(destFlags, FRIEND_FLAGS) ~= 0) then
						if (not db.bossesOnly or BossIDWeakLookup[sourceGUID]) then
							f(self, timestamp, false, sourceGUID, sourceName, sourceFlags, sourceGUID, sourceName, ...)
						end
					end					
				end
			end
		end
	end
end

--local totemOfWrath = GetSpellInfo(30706)

-- UNIT_AURA
function module:UNIT_AURA(e, unit)
	if (active) then
		if (UnitInRaid(unit) or UnitInParty(unit)) then
			if (self.deaths and UnitBuff(unit, feignDeath)) then
				local name = UnitName(unit)
				local cutoff = time() - 5
				for i = #self.deaths,1,-1 do
					local info = self.deaths[i]
					if (info[2] == name) then
						if (info[1] >= cutoff) then
							--d("Removing death for %s because of Feign Death", Utopia:ColourPlayer(unit))
							del(tremove(self.deaths, i))
							return
						end
					end
				end
			end
		--elseif (UnitCanAttack("player", unit)) then
		--	-- Check for debuffs not appearing in combat log (Totem of Wrath etc)
        --
		--	local name, rank, tex, count, debuffType, duration, endTime, caster, isStealable = UnitDebuff(unit, totemOfWrath)
		--	if (name) then
		--		self:UnitAuraOn(unit, name, rank, tex, count, debuffType, duration, endTime, caster)
		--	else
		--		self:UnitAuraOff(unit, totemOfWrath)
		--	end
		end
	end
end

-- PLAYER_TARGET_CHANGED
function module:PLAYER_TARGET_CHANGED()
	if (active) then
		if (UnitCanAttack("player", "target")) then
			self:UNIT_AURA(nil, "target")
		end
	end
end

-- SpellIDFromNameRank
local function SpellIDFromNameRank(name, rank)
	local spellInfo = Utopia.lookup.debuffs[name]
	local numrank = tonumber(rank:match("(%d+)"))
	if (not numrank or numrank == 0) then
		numrank = Utopia:MyLevelRank(spellInfo.rankLevels)
	end
	local spellId = spellInfo.rankIDs[numrank]
assert(spellId)
	return spellId
end

-- MakeSourceFlagsForFriend
local function MakeSourceFlagsForFriend(unit)
	local sourceFlags = COMBATLOG_OBJECT_REACTION_FRIENDLY + COMBATLOG_OBJECT_CONTROL_PLAYER + COMBATLOG_OBJECT_TYPE_PLAYER
	if (UnitIsUnit("player", unit)) then
		sourceFlags = sourceFlags + COMBATLOG_OBJECT_AFFILIATION_MINE
	end
	if (UnitInParty(unit)) then
		sourceFlags = sourceFlags + COMBATLOG_OBJECT_AFFILIATION_PARTY
	end
	if (UnitInRaid(unit)) then
		sourceFlags = sourceFlags + COMBATLOG_OBJECT_AFFILIATION_RAID
	end
	return sourceFlags
end

-- UnitAuraOn
function module:UnitAuraOn(unit, name, rank, tex, count, debuffType, duration, endTime, caster)
	local a = self.specialAuras
	if (not a) then
		a = new()
		self.specialAuras = a
	end

	local destGUID = UnitGUID(unit)
	local mob = a[destGUID]
	if (not mob) then
		mob = new()
		a[destGUID] = mob
	end

	local current = mob[name]
	if (not current and caster) then
		--d("UnitAuraOn(%s, %s, %s, %s)", UnitName(unit), tostring(name), tostring(rank), Utopia:ColourPlayer(caster))
		local n = new()
		n.name = name
		n.rank = rank
		n.tex = tex
		n.count = count
		n.debuffType = debuffType
		n.duration = duration
		n.endTime = endTime
		n.caster = caster
		n.timeStart = time()
		n.spellId = SpellIDFromNameRank(name, rank)
		mob[name] = n

		local sourceGUID = UnitGUID(caster)
		local sourceName = UnitName(caster)
		local destName = UnitName(unit)
		local destFlags = COMBATLOG_OBJECT_AFFILIATION_OUTSIDER + COMBATLOG_OBJECT_REACTION_HOSTILE + COMBATLOG_OBJECT_CONTROL_NPC + COMBATLOG_OBJECT_TYPE_NPC
		local sourceFlags = MakeSourceFlagsForFriend(caster)
		n.destFlags = destFlags
		n.sourceFlags = sourceFlags

		self:AddAura(time(), sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, n.spellId, name, nil, nil, "DEBUFF", count)
	end
end

-- UnitAuraOff
function module:UnitAuraOff(unit, spellName)
	local a = self.specialAuras
	if (a) then
		local destGUID = UnitGUID(unit)
		local mob = a[destGUID]
		if (mob) then
			local current = mob[spellName]
			if (current) then
				--d("UnitAuraOff(%s, %s, %s, %s)", UnitName(unit), tostring(spellName), tostring(current.rank), Utopia:ColourPlayer(current.caster))
				local sourceGUID = UnitGUID(current.caster)
				local sourceName = UnitName(current.caster)
				local destName = UnitName(unit)

				self:RemoveAura(time(), sourceGUID, sourceName, current.sourceFlags, destGUID, destName, current.destFlags, current.spellId, spellName, nil, nil, "DEBUFF")

				mob[spellName] = del(mob[spellName])
				if (not next(mob)) then
					a[destGUID] = del(mob)
					if (not next(a)) then
						self.specialAuras = del(a)
					end
				end
			end
		end
	end
end

-- SourceGUIDToName
local function SourceGUIDToUnitName(guid)
	for unit in Utopia:IterateRoster() do
		local g = UnitGUID(unit)
		if (g == guid) then
			return unit, UnitName(unit)
		else
			local petunit = unit:gsub("^(%a+)(%d+)$", "%1pet%2")
			g = UnitGUID(unit)
			if (g == guid) then
				return unit, UnitName(unit)			-- Yes, we want the owner name. Not the pet.
			end
		end
	end
end

-- MobDeath
function module:MobDeath(timestamp, destGUID, destName, destFlags)
	-- Enemy has died, so make sure we finish off all auras tied to it at this point
	-- Most finish up from combat log events, but a few can linger (Such as Totem of Wrath which doesn't have an event)
	local dest = active[destGUID]
	if (dest) then
		for target,targetInfo in pairs(dest) do
			for sourceGUID,sourceInfo in pairs(targetInfo) do
				for spellName,spell in pairs(sourceInfo) do
					local sourceUnit, sourceName = SourceGUIDToUnitName(sourceGUID)		-- This happens very rarely, so no real need to cache the roster guids
					if (sourceUnit) then
						local sourceFlags = MakeSourceFlagsForFriend(sourceUnit)
						local realSpellName = spell.realSpellId and GetSpellInfo(spell.realSpellId)

						--d("- Ending |cFFFFFF80%s|r by %s", spellName, Utopia:ColourPlayer(sourceUnit))
						self:RemoveAura(timestamp, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spell.spellId, spellName, spell.realSpellId, realSpellName, "DEBUFF")
					end
				end
			end
		end
	end
end

-- PLAYER_REGEN_DISABLED
function module:PLAYER_REGEN_DISABLED()
	if (not Utopia:ShouldShow()) then
		return
	end
	self:StartFighting()
end

-- StartFighting
function module:StartFighting()
	if (self.fight) then
		if (self.fight.combatStart and self.fight.combatStart < time() - 15) then
			-- Clear out ones that have done nothing
			self:EndFighting()
		else
			-- Already an active fight running, we were probably rezzed mid fight
			return
		end
	end

	--d("Fight Started: %s", date("%X",time()))
	self.active = {}
	local fight = {}
	self.fight = fight
	fight.boss = self.activeBossEncounter
	fight.data = {}
	fight.players = {}
	fight.mobs = {}
	self.lastID = {}
	fight.mobLookup = {}
	if (db.recordDPS) then
		if (db.schoolDPS) then
			self.dpsm, self.dpsp = {}, {}
		else
			self.dps = {}
		end
		self.bossdps = {}
		if (db.playerDPS) then
			self.playerdps = {}
		end
	end
	if (db.recordDeaths) then
		self.deaths = {}
	end
	if (db.bossEvents) then
		self.bossEvents = {}
	end

	active = self.active

	self.combatStart = time()
	self.applyCount, self.removeCount = 0, 0
	if (IsInInstance()) then
		if (GetNumRaidMembers() > 5) then
			fight.difficultyRaid = GetRaidDifficulty()
		else
			fight.difficulty = GetInstanceDifficulty()
		end
	end

	dlookup = Utopia.lookup.debuffs
	blookup = Utopia.lookup.buffs
	mlookup = Utopia.mappingLookup

	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:PLAYER_TARGET_CHANGED()
end

-- PLAYER_LEAVING_WORLD
function module:PLAYER_LEAVING_WORLD()
	self:CheckEndOfFight()
end

-- PLAYER_REGEN_ENABLED
function module:PLAYER_REGEN_ENABLED()
	if (not self:CheckEndOfFight()) then
		self:RegisterEvent("UNIT_DIED")
		if (not self.fightEndTimer) then
			self.fightEndTimer = self:ScheduleRepeatingTimer("CheckEndOfFight", 2)
		end
	end
end

-- UNIT_DIED
function module:UNIT_DIED()
	self:CheckEndOfFight()
end

-- CheckEndOfFight
function module:CheckEndOfFight()
	if (not InCombatLockdown()) then
		for unit in Utopia:IterateRoster() do
			if (UnitAffectingCombat(unit)) then
				return
			end
		end
		self:EndFighting()
		return true
	end
end

-- MakeDPSString
local function MakeDPSString(data)
	local zero = 0
	for i = 1,#data do
		if (data[i] == 0) then
			zero = zero + 1
		else
			break
		end
	end
	if (zero > 1) then
		return format("%d,%s", -zero, table.concat(data, ",", zero + 1))
	else
		return table.concat(data, ",")
	end
end

-- StoreDPSData
function module:StoreDPSData(fight, key)
	if (self[key] and next(self[key])) then
		fight[key] = {}
		for mobKey,data in pairs(self[key]) do
			fight[key][mobKey] = MakeDPSString(data)
		end
	end
end

-- EndFighting
function module:EndFighting()
	if (self.fightEndTimer) then
		self:CancelTimer(self.fightEndTimer)
		self.fightEndTimer = nil
	end
	if (not self.fight) then
		return
	end

	--d("Fight Ended: %s", date("%X",time()))
	self:UnregisterEvent("UNIT_DIED")
	self:UnregisterEvent("PLAYER_LEAVING_WORLD")
	self:UnregisterEvent("UNIT_AURA")
	self:UnregisterEvent("PLAYER_TARGET_CHANGED")

	if (not db.history) then
		db.history = {}
	end

	self:Cleanup()

	if (self.fight.combatStart and (not db.minimumDuration or (time() - self.fight.combatStart >= db.minimumDuration))) then
		if (next(self.fight.data)) then
			local fight = self.fight
			self.fight = nil

			-- End any in self.active at this point (ie: for when you release
			-- and combat still going on, you won't see the AURA_REMOVED events)
			for targetGUID,targetInfo in pairs(active) do
				for sourceGUID,sourceInfo in pairs(targetInfo) do
					for spellName,info in pairs(sourceInfo) do
						local destKey = self:MakeDestKey(fight, nil, targetGUID)
						if (destKey) then
							local playerID = tonumber(sourceGUID:sub(-8), 16)
							local player = fight.players[playerID]
							if (player) then
								local sourceName = strsplit(":", player)
								local entry = self:BuildStoredData(fight, info.timeStart, self.lastTimestamp, sourceName, sourceGUID, info.spellId, info.realSpellId, info.stacks)
								if (entry) then
									local data = fight.data[destKey]
									if (not data) then
										data = new()
										fight.data[destKey] = data
									end
									tinsert(data, entry)
								end
							end
						end
					end
				end
			end

			-- Compress data from table of entries to single string. Some 16-32 bytes less memory per aura
			for mobKey,data in pairs(fight.data) do
				fight.data[mobKey] = table.concat(data, ";")
			end

			fight.mobLookup = deepDel(fight.mobLookup)
			fight.combatEnd = self.lastEventTime
			fight.player = UnitName("player")

			tinsert(db.history, fight)
			Utopia.callbacks:Fire("Utopia_FightAdded", #db.history)

			if (db.notifications) then
				local link = format("|cFF80FF80|Hutopia_fight:%d:%s|h[%s]|h|r", fight.combatStart, UnitName("player"), L["View"])
				module:Print(format(L["Recorded |cFFFFFF80%s|r (%d secs) - |cFF80FF80%d|r auras %s"], date("%X"), time() - fight.combatStart, max(self.applyCount, self.removeCount), link))

				if (not self.doneUptimeHelp) then
					self.doneUptimeHelp = true
					module:Print(L["You can access |cFFFFFF80UpTime|r at any time with |cFF80FF80Ctrl-Click|r on the LDB or Fubar icon, or with the |cFF80FF80/uptime|r command."])
				end
			end

			self:StoreDPSData(fight, "dps")
			self:StoreDPSData(fight, "dpsp")
			self:StoreDPSData(fight, "dpsm")
			self:StoreDPSData(fight, "bossdps")

			if (self.playerdps and next(self.playerdps)) then
				fight.playerdps = {}
				for mobKey,data in pairs(self.playerdps) do
					local n = new()
					fight.playerdps[mobKey] = n
					for playerID,data2 in pairs(data) do
						n[playerID] = MakeDPSString(data2)
					end
				end
			end
			if (self.deaths and #self.deaths > 0) then
				for i,info in ipairs(self.deaths) do
					local key = self:MakeSourceKey(fight, info[2], info[3])
					if (key) then
						local key2
						if (info[4]) then
							key2 = self:MakeSourceKey(fight, info[4], info[5])
						end
						self.deaths[i] = strjoin(",", floor((info[1] - fight.combatStart) * 100) / 100, key) .. (key2 and ","..key2 or "")
					end
					del(info)
				end
				fight.deaths = table.concat(self.deaths, ";")
			end
			if (self.bossEvents and #self.bossEvents > 0) then
				for i,info in ipairs(self.bossEvents) do
					info[2] = floor((info[2] - fight.combatStart) * 100) / 100
					self.bossEvents[i] = table.concat(info, ",")
					del(info)
				end
				fight.events = table.concat(self.bossEvents, ";")
			end
			self.fight = nil
		end
	end

	self.dps = deepDel(self.dps)
	self.dpsm = deepDel(self.dpsm)
	self.dpsp = deepDel(self.dpsp)
	self.bossdps = deepDel(self.bossdps)
	self.playerdps = deepDel(self.playerdps)
	self.deaths = deepDel(self.deaths)
	self.active = deepDel(self.active)
	active = nil
	self.fight = deepDel(self.fight)
	self.lastID = deepDel(self.lastID)
	self.bossEvents = del(self.bossEvents)
	self.feigns = del(self.feigns)
	self.specialAuras = deepDel(self.specialAuras)
end

-- ColourPlayerFromFight
function module:ColourPlayerFromFight(fight, playerName)
	if (not playerName) then
		playerName = fight.player
	end
	local _, class = UnitClass(playerName)
	if (not class) then
		for id,info in pairs(fight.players) do
			local name,classID = strsplit(":", info)
			if (name == playerName) then
				classID = tonumber(classID)
				if (classID) then
					class = classOrder[classID]
				end
				break
			end
		end
	end
	if (class) then
		local classColour = ClassColour(class)
		playerName = classColour .. playerName .. "|r"
	end
	return playerName
end

-- LinkFightStats
function module:LinkFightStats(fight)
	local str = format("%s: %s %s - %d secs", self:FightName(fight), self:DescribeDate(fight.combatStart), date("%X", fight.combatStart), fight.combatEnd - fight.combatStart)
	local activeWindow = ChatEdit_GetActiveWindow()
	if activeWindow then
		activeWindow:Insert(str)
	end
end

-- SetItemRef
function module:SetItemRef(link, text, button)
	local cmd, when, who = strsplit(":", link)
	if (cmd == "utopia_fight") then
		when = tonumber(when)
		for i,fight in ipairs(db.history) do
			if (floor(fight.combatStart) == when) then
				if (not who or who == UnitName("player") or who == fight.receivedFrom) then
					if (IsModifiedClick("CHATLINK")) then
						module:LinkFightStats(fight)
					else
						module:OpenView(i)
					end
					break
				end
			end
		end
		return true

	elseif (cmd == "utopia_accept") then
		self:AcceptFightSendQuery(when, tonumber(who))
		return true
	end
	return self.hooks.SetItemRef(link, text, button)
end

-- Cleanup
function module:Cleanup()
	local purged = 0
	for i = #db.history,1,-1 do
		local fight = db.history[i]
		if (not fight.keep and (db.minimumDuration and (fight.combatEnd - fight.combatStart < db.minimumDuration))) then
			purged = purged + 1
			tremove(db.history, i)
--[===[@debug@
		else
			-- Fix bad player dps data (read: delete) due to pets not being accounted for
			-- and player IDs not all making it into the lookup if they didn't debuff
			local any
			if (fight.playerdps) then
				for mobkey,data in pairs(fight.playerdps) do
					for playerid,data2 in pairs(data) do
						if (not fight.players[playerid]) then
							data[playerid] = nil
							any = true
						end
					end
					if (not next(data)) then
						fight.playerdps[mobkey] = nil
					end
				end
				if (not next(fight.playerdps)) then
					fight.playerdps = nil
				end
			end
			if (any) then
				d("Fixed bad playerdps data for %s", self:FightName(fight))
			end
--@end-debug@]===]
		end
	end

	local i = 1
	for j = 1,1000 do
		if (i > #db.history or #db.history <= db.keep) then
			break
		end

		local fight = db.history[i]
		if (not fight.keep) then
			purged = purged + 1
			tremove(db.history, i)
		else
			i = i + 1
		end
	end
end

-- AddToTimeRange
local function AddToTimeRange(segments, timeStart, timeEnd, recursing)
	local done, done2
	for i,range in ipairs(segments) do
		if (timeStart >= range.Start) then
			if (timeStart <= range.End) then
				done2 = done
				done = i
				if (timeEnd > range.End) then
					range.End = timeEnd
				end
			end
		elseif (timeEnd >= range.Start) then
			if (timeEnd <= range.End) then
				done2 = done
				done = i
				if (timeStart < range.Start) then
					range.Start = timeStart
				end
			else
				if (timeStart <= range.Start) then
					range.Start = timeStart
					done2 = done
					done = i
					if (timeEnd > range.End) then
						range.End = timeEnd
					end
				elseif (timeStart <= range.End) then
					done2 = done
					done = i
					if (timeEnd > range.End) then
						range.End = timeEnd
					end
				end
			end
		end
	end
	if (not done) then
		local range = new()
		range.Start = timeStart
		range.End = timeEnd
		tinsert(segments, range)
	elseif (done2 and not recursing) then
		-- We've created two overlapping time frames
		local Start, End = segments[done].Start, segments[done].End
		del(tremove(segments, done))
		AddToTimeRange(segments, Start, End, true)
	end
end

-- GetUptime
-- Get's the uptime of a spell in a fight
function module:GetUptime(fight, mobKey, cat, spell)
	-- Build a temp table of non-overlapping time ranges, then do the easy math of (totalEnd - totalStart) / combatLength
	local fightData = fight.data[mobKey]
	if (fightData) then
		local delFD
		if (type(fightData) == "string") then
			fightData = new(strsplit(";", fightData))
			delFD = true
		end

		local spells = new()
		if (cat) then
			for spellName,spellInfo in pairs(cat.spells) do
				spells[spellInfo.name] = true
			end
		else
			spells[spell.name] = true
		end

		local minTime, maxTime
		local range = new()
		for i = 1,#fightData do
			local segment = fightData[i]
			local timeStart, timeEnd, sourceName, sourceClass, sourceGUID, spellId, realSpellId, improved = module:GetStoredData(fight, segment)

			if (not minTime or timeStart < minTime) then
				minTime = timeStart
			end
			if (not maxTime or timeEnd > maxTime) then
				maxTime = timeEnd
			end

			local spellName = GetSpellInfo(spellId)
			if (spells[spellName]) then
				AddToTimeRange(range, timeStart, timeEnd)
			end
		end
		local tStart, tEnd = 0, 0
		for i,range in ipairs(range) do
			tStart = tStart + range.Start
			tEnd = tEnd + range.End
		end

		del(range)
		del(spells)
		if (delFD) then
			del(fightData)
		end

		local tRange = maxTime - minTime
		return (tEnd - tStart) / tRange, tRange
	end
end

-- OpenView
function module:OpenView(key, count)
	if (not self.freeFrames) then
		self.freeFrames = {}
		self.frames = {}
	end

	if (self.mainlist) then
		for Frame in pairs(self.frames) do
			if (Frame.key == key) then
				Frame:SetFrameLevel(self.mainlist:GetFrameLevel() + (count or 1) * 5)
				return
			end
		end
	end

	local frame = tremove(self.freeFrames) or self:CreateUpTimeFrame()
	self.frames[frame] = true

	frame:SetView(key)
	return frame
end

do
	-- frame.OnSetShowEvents
	local function frameOnSetShowEvents(self, e, newval)
		self.area:CleanupDeaths("deaths")
		self.area:CleanupDeaths("events")
		self.area:PopulateDeaths()
		self.area:PopulateEvents()
	end

	-- frame.OnDeleteFight
	local function frameOnDeleteFight(self, e, index)
		if (index == self.key) then
			self:Hide()
		elseif (index < self.key) then
			self.key = self.key - 1
		end
	end

	-- OnFightChanged
	local function frameOnFightChanged(self, e, combatStart)
		if (self.fight and self.fight.combatStart == combatStart) then
			local sel = new(self.list:GetSelected())

			self:ClearSelected()
			self:OrderMobNames()
			self:PopulateMobNames()

			for i = #sel,1,-1 do
				local key = sel[i]
				if (not self.fight.mobs[key]) then
					tremove(sel, i)
				end
			end

			self.list:Click(unpack(sel))
			del(sel)
		end
	end
	
	-- OnShow
	local function frameOnShow(self)
		self:SetTitle()
		self.area:ShowScale()
		Utopia.RegisterCallback(self, "Utopia_SetShowEvents", frameOnSetShowEvents, self)
		Utopia.RegisterCallback(self, "Utopia_DeleteFight", frameOnDeleteFight, self)
		Utopia.RegisterCallback(self, "Utopia_FightChanged", frameOnFightChanged, self)
	end

	-- OnHide
	local function frameOnHide(self)
		Utopia.UnregisterCallback(self, "Utopia_SetShowEvents")
		Utopia.UnregisterCallback(self, "Utopia_DeleteFight")
		Utopia.UnregisterCallback(self, "Utopia_FightChanged")

		self.offset = nil
		self.fight = nil
		self.area.fight = nil
		self.area:OnClose()
		self:ClearSelected()
		if (self.dpsFrame) then
			self.showDPS = nil
			self:ShowDPS()
		end

		module.frames[self] = nil
		tinsert(module.freeFrames, self)

		self.orderedMobNames = del(self.orderedMobNames)
	end

	-- SetTitle
	local function frameSetTitle(self)
		local when = module:DescribeDate(self.fight.combatStart)
		local dur = self.fight.combatEnd - self.fight.combatStart
		if (dur > 60) then
			dur = format(MINUTES_ABBR.." "..SECONDS_ABBR, dur / 60, dur % 60)
		else
			dur = format(SECONDS_ABBR, dur)
		end

		local playerName = module:ColourPlayerFromFight(self.fight, self.fight.player)
		self.title:SetFormattedText("%s - |cFFFF0000%s|r - |cFF30E030%s %s - %s|r [|cFFA0A0A0%s|r]", playerName, module:FightName(self.fight), when, date("%X", self.fight.combatStart), date("%X", self.fight.combatEnd), dur)
	end

	-- framelist.OnClick
	local function framelistOnClick(self, what)
		local parent = self:GetParent()
		parent:ClearSelected()

		parent.area.mobKeys[self:GetSelected()] = true

		local lowTime, highTime = parent.area:SelectMobKey()
		parent.area.rightScroll.targetTime = lowTime
		parent.area.rightScroll.targetTimeHigh = highTime
	end

	-- framelist.OnSelectMultiple
	local function framelistOnSelectMultiple(self, ...)
		local parent = self:GetParent()
		parent:ClearSelected()

		local mobkeys = new(self:GetSelected())
		for i,mobkey in ipairs(mobkeys) do
			parent.area.mobKeys[mobkey] = true
		end

		local lowTime, highTime = parent.area:SelectMobKey()
		parent.area.rightScroll.targetTime = lowTime
		parent.area.rightScroll.targetTimeHigh = highTime
	end

	-- frame.ClearSelected
	local function frameClearSelected(self)
		del(self.area.mobKeys)
		self.area.mobKeys = new()
	end

	-- frame.SetView
	local function frameSetView(self, key)
		self.key = key
		local fight = db.history[key]
		assert(fight)
		self.fight = fight
		self.area.fight = fight

		self:Show()

		self:ClearSelected()
		self:OrderMobNames()
		self:PopulateMobNames()
		self.list:Click(1)
	end

	-- frame.PopulateMobNames
	local function framePopulateMobNames(self)
		local listItems = new()
		local last
		for i,name in ipairs(self.orderedMobNames) do
			if (last and name:sub(1,#last) == last) then
				local lastItem = listItems[#listItems]
				if (not lastItem.children) then
					lastItem.children = new()
				end
				tinsert(lastItem.children, new(name, self.mobnameToKeyLookup[name]))
			else
				tinsert(listItems, new(name, self.mobnameToKeyLookup[name]))
				last = name
			end
		end
		self.list:SetItems(listItems)
	end

	-- nameSort, aware of numbers in braces
	local function nameSort(a, b)
		local name1, num1 = strmatch(a, "(.+) %((%d+)%)$")
		if (num1) then
			local name2, num2 = strmatch(b, "(.+) %((%d+)%)$")
			if (num2 and name1 == name2) then
				return tonumber(num1) < tonumber(num2)
			end
		end
		return a < b
	end

	-- frame.OrderMobNamesPart
	local function frameOrderMobNamesPart(self, list, done, section)
		if (section) then
			local mobs = self.fight.mobs
			local l = self.mobnameToKeyLookup
			for mobKey,info in pairs(section) do
				if (not done[mobKey]) then
					done[mobKey] = true

					local mobid, index = module:MobIDFromKey(mobKey)
					local baseName = mobs[mobid]
					if (not baseName) then
						-- Assuming a broken purge (forgot to include all elements to purge)
						section[mobKey] = nil
					else
						local name

						if (index and index > 1) then
							name = format("%s (%d)", baseName, index)
						else
							name = baseName
						end
						if (l[name]) then
							-- Two mobs of same name can have a different ID, so we run into the problem of duplicates here
							-- ie: Tempest Minion with Emalon; the spawned ones during fight have a different ID than the 4
							-- static ones at start
							for i = 2,10000 do
								local temp = format("%s (%d)", baseName, i)
								if (not l[temp]) then
									name = temp
									break
								end
							end
						end

						tinsert(self.orderedMobNames, name)
						l[name] = mobKey
					end
				end
			end
		end
	end

	-- OrderMobNames
	local function frameOrderMobNames(self)
		self.offset = 0
		self.orderedMobNames = del(self.orderedMobNames)
		self.mobnameToKeyLookup = del(self.mobnameToKeyLookup)
		self.orderedMobNames = new()
		self.mobnameToKeyLookup = new()

		local done = new()
		self:OrderMobNamesPart(self, done, self.fight.data)
		self:OrderMobNamesPart(self, done, self.fight.dps)
		self:OrderMobNamesPart(self, done, self.fight.dpsm)
		self:OrderMobNamesPart(self, done, self.fight.dpsp)
		self:OrderMobNamesPart(self, done, self.fight.bossdps)
		self:OrderMobNamesPart(self, done, self.fight.playerdps)
		del(done)

		sort(self.orderedMobNames, nameSort)
	end

	local function setModeCat(self)
		self.area:SetMode("category")
	end
	local function setModeSpell(self)
		self.area:SetMode("spell")
	end

	local function getPlayerNames(self)
		return self.area.playerNames
	end

	local function setPlayerNames(self, newval)
		self.area.playerNames = newval
		self.area:SelectMobKey()
	end

	local function getShowDPS(self)
		self.dpsCheckbox:SetEnabled(self.fight.dps or self.fight.dpsp or self.fight.dpsm)
		return (self.fight.dps or self.fight.dpsp or self.fight.dpsm) and self.showDPS
	end

	local function setShowDPS(self, newval)
		self.showDPS = newval
		self:ShowDPS()
	end

	local function getShowDeaths(self)
		self.deathsCheckbox:SetEnabled(self.fight.deaths)
		return self.fight.deaths and self.showDeaths
	end

	local function setShowDeaths(self, newval)
		self.showDeaths = newval
		self.area:CleanupDeaths("deaths")
		self.area:CleanupDeaths("events")
		self.area:PopulateDeaths()
		self.area:PopulateEvents()
	end

	local function getShowEvents(self)
		self.eventsCheckbox:SetEnabled(self.fight.events)
		return self.fight.events and self.showEvents
	end

	local function setShowEvents(self, newval)
		self.showEvents = newval
		Utopia.callbacks:Fire("Utopia_SetShowEvents", newval)
	end

	local function frameGetKeep(self)
		return self.fight and self.fight.keep
	end

	local function frameSetKeep(self, newval)
		self.fight.keep = newval and true
	end

	-- frame.ShowDPS
	local function frameShowDPS(self)
		if (self.showDPS) then
			if (not self.dpsFrame) then
				self.dpsFrame = module:CreateDPSFrame(self)
				self.horizontalBar = lzf:CreateHorizontalBar(self.dpsFrame, "TOP")
				self.horizontalBar:SetPoint("TOPRIGHT", self.dpsFrame, "TOPRIGHT", 24, 8)

				self.dpsFrame:SetPoint("BOTTOMRIGHT", -40, 43)
			end
			self.dpsFrame:SetPoint("TOPLEFT", self.list.verticalBar, "BOTTOMRIGHT", 0, self.dpsFrame.height)
			self.dpsFrame:SetFight(self.fight)

			self.area:SetPoint("BOTTOMRIGHT", self.dpsFrame, "TOPRIGHT", 0, 6)
		else
			if (self.dpsFrame) then
				self.dpsFrame:Hide()
				self.dpsFrame:SetPoint("TOPLEFT", self.list, "BOTTOMRIGHT", 0, 0)
				self.area:SetPoint("BOTTOMRIGHT", self.dpsFrame, "TOPRIGHT", 0, 0)
			end
		end
	end

	-- frame.Refresh
	local function frameRefresh(self)
		self:SetTitle()
		self.statusbar:Refresh()
		self.keep:Hide()
		self.keep:Show()
		self.prev:Hide()
		self.prev:Show()
		self.next:Hide()
		self.next:Show()
	end

	-- frame.OnScaleChanged
	local function frameOnScaleChanged(self, newScale)
		if (not db.scale) then
			db.scale = {}
		end
		db.scale.uptime = newScale
	end

	-- prev.OnClick
	local function prevOnClick(self)
		if (self.key > 1) then
			self:SetView(self.key - 1)
			self:Refresh()
		end
	end

	-- next.OnClick
	local function nextOnClick(self)
		if (self.key < #db.history) then
			self:SetView(self.key + 1)
			self:Refresh()
		end
	end

	-- prev.OnShow
	local function prevOnShow(self)
		local frame = self:GetParent()
		if (frame.key > 1) then
			self:Enable()
		else
			self:Disable()
		end
	end

	-- next.OnShow
	local function nextOnShow(self)
		local frame = self:GetParent()
		if (frame.key < #db.history) then
			self:Enable()
		else
			self:Disable()
		end
	end

	-- button.ignore.OnClick
	local function buttonIgnore(self)
		module:ToggleIgnoreFrame(self.fight)
	end

	-- button.mainlist.OnClick
	local function buttonMainListOnClick(self)
		module:Toggle()
		if (not module.listFrame:IsShown()) then
			module:Toggle()
		end
	end

	-- CreateUpTimeFrame
	function module:CreateUpTimeFrame()
		self.frameNo = (self.frameNo or 0) + 1
		local frame = CreateFrame("Frame", "UtopiaUpTimeFrame"..self.frameNo, UIParent)
		frame:Hide()
		frame:SetScale(db.scale and db.scale.uptime or 0.8)
    	frame:SetWidth(768)
		frame:SetHeight(512)
		lzf:ApplyBackground(frame, "Interface\\AddOns\\Utopia\\Textures\\UtopiaCornerIcon")
		lzf:MovableFrame(frame)
		frame.OnPositionChanged = function(self) Utopia:SavePosition(self) end
		Utopia:RestorePosition(frame)

		frame.list = lzf:CreateListFrame(frame, true, true)
		frame.list:SetPoint("TOPLEFT", 24, -82)
		frame.list:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 195, 42)
		frame.list.OnSelectMultiple = framelistOnSelectMultiple
		frame.list.OnClick = framelistOnClick

		frame.bar = lzf:CreateVerticalBar(frame.list, "RIGHT", true)

		frame.ignore = lzf:Button(frame.statusbar, frame, IGNORE, buttonIgnore, "TOPLEFT")
		frame.button1 = lzf:Button(frame.statusbar, frame, L["By Category"], setModeCat, "TOPLEFT", 180, 0)
		frame.button2 = lzf:Button(frame.statusbar, frame, L["By Spell"], setModeSpell, "LEFT", frame.button1, "RIGHT", 5, 0)
		frame.checkbox1 = lzf:CheckBox(frame.statusbar, frame, L["Names"], getPlayerNames, setPlayerNames, "LEFT", frame.button2, "RIGHT", 5, 0)
		frame.dpsCheckbox = lzf:CheckBox(frame.statusbar, frame, L["DPS"], getShowDPS, setShowDPS, "LEFT", frame.checkbox1, "RIGHT", frame.checkbox1.text:GetStringWidth() + 15, 0)
		frame.deathsCheckbox = lzf:CheckBox(frame.statusbar, frame, L["Deaths"], getShowDeaths, setShowDeaths, "LEFT", frame.dpsCheckbox, "RIGHT", frame.dpsCheckbox.text:GetStringWidth() + 15, 0)
		frame.eventsCheckbox = lzf:CheckBox(frame.statusbar, frame, L["Events"], getShowEvents, setShowEvents, "LEFT", frame.deathsCheckbox, "RIGHT", frame.deathsCheckbox.text:GetStringWidth() + 15, 0)

		local area = self:CreateWorkArea(frame)
		frame.area = area
		area:SetPoint("TOPLEFT", frame.list.verticalBar, "TOPRIGHT", 0, 0)
		area:SetPoint("BOTTOMRIGHT", -40, 43)

		-- Keep option
		frame.keep = lzf:CheckBox(frame, frame, L["Keep"], frameGetKeep, frameSetKeep, "TOPLEFT", 70, -11.5)
		frame.keep.tooltip = L["Do not automatically purge this fight when it expires past the present age/size limits defined in options"]

		frame.prev = lzf:ButtonPrev(frame, frame, prevOnClick, "TOPLEFT", 75, -35)
		frame.prev:SetScript("OnShow", prevOnShow)
		frame.next = lzf:ButtonNext(frame, frame, nextOnClick, "LEFT", frame.prev, "RIGHT")
		frame.next:SetScript("OnShow", nextOnShow)
		frame.mainlist = lzf:Button(frame, frame, L["Listing"], buttonMainListOnClick, "LEFT", frame.next, "RIGHT")
		frame.mainlist:SetWidth(70)

		frame.OnShow			= frameOnShow
		frame.OnHide			= frameOnHide
		frame.SetTitle			= frameSetTitle
		frame.OrderMobNamesPart	= frameOrderMobNamesPart
		frame.OrderMobNames		= frameOrderMobNames
		frame.PopulateMobNames	= framePopulateMobNames
		frame.SetView			= frameSetView
		frame.ClearSelected		= frameClearSelected
		frame.ShowDPS			= frameShowDPS
		frame.ShowDeaths		= frameShowDeaths
		frame.Refresh			= frameRefresh
		frame.OnScaleChanged	= frameOnScaleChanged

		frame:SetScript("OnShow", frame.OnShow)
		frame:SetScript("OnHide", frame.OnHide)

		return frame
	end
end

do
	local areaCreateSpellLine

	-- area.Init
	local function areaInit(self)
		self:ClearDisplay()
		self.nameToLineLookup = new()
		self.dataIndex = new()
		self:BuildSpellNameList()
	end

	-- area.OnClose
	local function areaOnClose(self)
		self.scale = 6
		self.playerNames = nil
		self.lastTooltipInfo = deepDel(self.lastTooltipInfo)
		self:ClearDisplay()
		self.rightScroll:SetHorizontalScroll(0)
		self.rightScroll:SetVerticalScroll(0)
		self.leftScroll:SetVerticalScroll(0)
	end

	-- area.SetMode
	local function areaSetMode(self, mode)
		self.mode = mode
		self:Init()
		self:Populate()
	end

	-- area.SelectMobKey
	local function areaSelectMobKey(self)
		self:Init()
		local lowTime, highTime = self:Populate()
		return lowTime, highTime
	end

	-- area.RightScrollOnUpdate
	local function areaRightScrollOnUpdate(self, elapsed)
		self:GetParent():ShowCursorLocation()
	end

	local rightscrollOnUpdateSwoosh
	-- rightscrollOnUpdateCheckScrollRange
	local function rightscrollOnUpdateCheckScrollRange(self, elapsed)
		self.onUpdateCheck = self.onUpdateCheck + 1
		if (self.onUpdateCheck > 1) then
			local area = self:GetParent()
			if (self.targetTime) then
				local w = self:GetWidth()
				local wTime = w / area.scale

				local range = self.targetTimeHigh - self.targetTime
				local spare = (range < wTime) and ((wTime - range) / 2) or 0
				self.swooshTarget = max(0, (self.targetTime - spare - area.fight.combatStart) * area.scale)
				self:SetScript("OnUpdate", rightscrollOnUpdateSwoosh)
				self.targetTime, self.targetTimeHigh = nil, nil
				return
			end

			-- Can only validate the dimensions of the ScrollChild after 2nd frames are drawn
			local offset = self:GetHorizontalScroll()
			local newoffset = max(0, min(self:GetHorizontalScrollRange(), offset))
			if (offset ~= newoffset) then
				self:SetHorizontalScroll(newoffset)
			end
			if (area:MouseInArea()) then
				self:SetScript("OnUpdate", areaRightScrollOnUpdate)
			else
				self:SetScript("OnUpdate", nil)
			end

			local area = self:GetParent()
			area.lastX, area.lastY = nil, nil
			area:ShowCursorLocation()
		end
	end

	-- rightscrollOnUpdateSwoosh
	function rightscrollOnUpdateSwoosh(self, elapsed)
		local offset = self:GetHorizontalScroll()
		local diff = self.swooshTarget - offset
        local move = diff / 10 * 60 * elapsed
        local set = offset + move
        local Max = self:GetHorizontalScrollRange()
        if (self.swooshTarget > Max) then
        	self.swooshTarget = Max
        end

		if (set >= Max) then
			set = Max
			self.swooshTarget = nil
		elseif (set <= 0) then
			set = 0
			self.swooshTarget = nil
		elseif (abs(set - offset) < 0.1) then
			set = self.swooshTarget
			self.swooshTarget = nil
		end

		self:SetHorizontalScroll(set)

		if (not self.swooshTarget) then
			self.targetTime, self.targetTimeHigh = nil, nil
			self.onUpdateCheck = 0
			self:SetScript("OnUpdate", rightscrollOnUpdateCheckScrollRange)
		end

		self:GetParent():ShowCursorLocation()
	end

	-- area.ResetLines
	local function areaResetLines(self)
		for i,line in ipairs(self.lines) do
			line:Hide()
			line:Show()
		end
	end

	-- area.ClearDisplay
	local function areaClearDisplay(self)
		self.shownLines = 0
		self.offset = nil
		self.dataIndex = del(self.dataIndex)
		self.nameToLineLookup = deepDel(self.nameToLineLookup)
		for i,line in ipairs(self.lines) do
			line.info = nil
			line.spellId = nil
			line:UnlockHighlight()
			line:Hide()
		end
		self.offset = 0
		self.rowHighlight = nil
		self:CleanupDeaths("deaths")
		self:CleanupDeaths("events")
	end

	-- area.RightScrollOnEnter
	local function areaRightScrollOnEnter(self)
		if (not self.dragging and not self.speedX and not self.swooshTarget and not self.targetTime) then
			self:SetScript("OnUpdate", areaRightScrollOnUpdate)
		end
	end

	-- area.RightScrollOnLeave
	local function areaRightScrollOnLeave(self)
		local area = self:GetParent()
		if (not self.dragging and not self.speedX and not self.swooshTarget and not self.targetTime) then
			self:SetScript("OnUpdate", nil)
			area:HideCursorLocation()
		end
		area:RemoveHighlight()
		GameTooltip:Hide()
		self.lastTooltipInfo = deepDel(self.lastTooltipInfo)
	end

	-- area.Populate
	local function areaPopulate(self)
		if (not self.mobKeys) then
			return
		end

		local lowTime, highTime = self:PopulateAuras()
		self:CleanupDeaths("deaths")
		self:CleanupDeaths("events")
		self:PopulateDeaths()
		self:PopulateEvents()

		return lowTime, highTime
	end

	-- area.PopulateAuras
	local function areaPopulateAuras(self)
		local fight = self.fight
		local data = fight.data
		local w = max(200, (self.fight.combatEnd - self.fight.combatStart) * self.scale)
		self.rightScrollChild:SetWidth(w)

		local parent = self:GetParent()
		local keyLookup = parent.mobnameToKeyLookup
		local lowTime, highTime

		for i,mobName in ipairs(parent.orderedMobNames) do
			local mobKey = keyLookup[mobName]

			if (self.mobKeys[mobKey]) then
				local fightData = data[mobKey]
				if (fightData) then
					local delFD
					if (type(fightData) == "string") then
						fightData = new(strsplit(";", fightData))
						delFD = true
					end

					local index = self.dataIndex[mobKey] or 1

					for i = index,#fightData do
						local segment = fightData[i]
						local timeStart, timeEnd, sourceName, sourceClass, sourceGUID, spellId, realSpellId, improved = module:GetStoredData(fight, segment)
						if (timeEnd > timeStart + 0.0009) then		-- Sanity
							self:AddSpell(timeStart, timeEnd, sourceName, sourceGUID, spellId, realSpellId, mobName, mobKey, improved)
						end
						if (not lowTime or timeStart < lowTime) then
							lowTime = timeStart
						end
						if (not highTime or timeEnd > highTime) then
							highTime = timeEnd
						end
					end

					self.dataIndex[mobKey] = #fightData + 1
					if (delFD) then
						del(fightData)
					end
				end
			end
		end

		self.rightScroll.onUpdateCheck = 0
		self.rightScroll:SetScript("OnUpdate", rightscrollOnUpdateCheckScrollRange)

		if (parent.showDPS and parent.dpsFrame) then
			parent.dpsFrame:SetFight(self.fight)
		end

		self:ShowScroll()

		return lowTime, highTime
	end

	-- area.FindClearRow
	local function areaFindClearRow(self, xOffset, list, entry)
		if (list and entry.text:IsShown()) then
			local entrySizeD2 = entry.text:GetStringWidth() / 2 + 2
			for rowPush = 0,100 do
				local overlap
				for j,prev in pairs(list) do
					if (prev.text:IsShown()) then
						if ((prev.rowPush or 0) == rowPush) then
							local prevsizeD2 = prev.text:GetStringWidth() / 2 + 2
							if (xOffset - entrySizeD2 <= prev.xOffset + prevsizeD2) then
								if (xOffset + entrySizeD2 >= prev.xOffset - prevsizeD2) then
									overlap = true
									break
								end
							end
						end
					end
				end
				if (not overlap) then
					return rowPush
				end
			end
		end
	end

	-- area.PopulateDeaths
	local function areaPopulateDeaths(self)
		self:CleanupDeaths("deaths")
		local fight = self.fight
		if (not fight.deaths) then
			return
		end

		local parent = self:GetParent()
		if (not parent.showDeaths) then
			return
		end

		self.deaths = new()
		local list = new(strsplit(";", fight.deaths))
		for i,str in ipairs(list) do
			local timeOffset, playerID, resserID = strsplit(",", str)
			if (playerID) then
				timeOffset, playerID, resserID = tonumber(timeOffset), tonumber(playerID,16), resserID and tonumber(resserID,16)
				local player = fight.players[playerID]
				if (player) then
					local resser = resserID and fight.players[resserID]
					local class, r, g, b
					player, class = strsplit(":", player)
					if (class) then
						local c = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[classOrder[tonumber(class)]]
						r, g, b = c.r, c.g, c.b
					else
						r, g, b = 0.5, 0.5, 0.5
					end

					local death = self:AquireDeathMarker()
					if (resser) then
						death.text:SetFormattedText(L["%s ressed by %s"], player, resser)
						death:SetVertexColor(1, 1, 0)
					else
						death.text:SetText(player)
						death:SetVertexColor(1, 0, 0)
					end
					local xOffset = timeOffset * self.scale
					death:SetPoint("TOPLEFT", xOffset, 0)
					death.text:SetTextColor(r, g, b)
					death.xOffset = xOffset

					local rowPush = self:FindClearRow(xOffset, self.deaths, death)
					rowPush = max(rowPush or 0, self:FindClearRow(xOffset, self.events, death) or 0)

					if (rowPush > 0) then
						death:SetHeight(20 * self.shownLines + 5 + (rowPush * 10))
						death.rowPush = rowPush
					end

					tinsert(self.deaths, death)
				end
			end
		end
		del(list)
	end

	-- area.PopulateEvents
	local function areaPopulateEvents(self)
		self:CleanupDeaths("events")
		local fight = self.fight
		if (not fight.events) then
			return
		end

		local parent = self:GetParent()
		if (not parent.showEvents) then
			return
		end

		self.events = new()
		local list = new(strsplit(";", fight.events))
		for i,str in ipairs(list) do
			local text, timeOffset, duration = strsplit(",", str)
			if (timeOffset) then
				timeOffset, duration = tonumber(timeOffset), tonumber(duration)

				local spellId = tonumber(text)
				if (spellId) then
					text = GetSpellInfo(spellId)
				end

				local event = self:AquireDeathMarker()
				local xOffset = timeOffset * self.scale
				event:SetPoint("TOPLEFT", xOffset, 0)
				event.xOffset = xOffset
				event.text:SetText(text)

				if (duration and duration > 0) then
					xOffset = xOffset + (duration * self.scale) / 2
				end

				local rowPush = max(self:FindClearRow(xOffset, self.deaths, event) or 0,
									self:FindClearRow(xOffset, self.events, event) or 0)

				if (rowPush > 0) then
					event:SetHeight(20 * self.shownLines + 5 + (rowPush * 10))
					event.rowPush = rowPush
				else
					event:SetHeight(20 * self.shownLines + 5)
				end

				if (duration and duration < 0) then
					event:SetVertexColor(1, 0, 0)
					event.text:SetTextColor(1, 0, 0)
				elseif (not duration) then
					event:SetVertexColor(0, 1, 0)
					event.text:SetTextColor(0, 1, 0)
				else
					event:SetVertexColor(1, 0.5, 1)
					event.text:Hide()
				end

				tinsert(self.events, event)

				if (duration and duration > 0) then
					local event2 = self:AquireDeathMarker()
					event2:SetHeight(event:GetHeight())
					event2:SetVertexColor(1, 0.5, 1)
					event2:SetPoint("TOPLEFT", (timeOffset + duration) * self.scale, 0)
					event2.rowPush = rowPush > 0 and rowPush or nil
					event2.text:Hide()
					tinsert(self.events, event2)

					local event3 = self:AquireDeathMarker()
					event3:SetVertexColor(1, 0.5, 1)
					event3:SetHeight(0.8)
					event3:SetWidth(duration * self.scale)
					event3:SetPoint("TOPLEFT", event, "BOTTOMLEFT", 0, 0.8)
					event3.text:SetText(text)
					event3.text:SetTextColor(1, 0.5, 1)
					event3.rowPush = event.rowPush
					event3.xOffset = xOffset

					tinsert(self.events, event3)
				end
			end
		end
		del(list)
	end

	local function areaCleanupDeaths(self, what)
		if (self[what]) then
			for i,death in ipairs(self[what]) do
				self:ReleaseDeathMarker(death)
			end
		end
		self[what] = del(self[what])
	end

	local markers = {}
	local function areaCreateDeathMarker(self)
		local tex = self.rightScrollChild:CreateTexture(nil, "OVERLAY")
		tex:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
		tex.text = self.rightScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		tex.text:SetPoint("TOP", tex, "BOTTOM", 0, 0)
		return tex
	end
	
	local function areaAquireDeathMarker(self, parent)
		local marker = tremove(markers) or self:CreateDeathMarker()
		marker:SetParent(self.rightScrollChild)
		marker:SetWidth(0.8)
		marker.text:SetParent(self.rightScrollChild)
		marker:Show()
		marker.text:Show()
		marker:SetHeight(20 * self.shownLines + 5)
		return marker
	end

	local function areaReleaseDeathMarker(self, marker)
		tinsert(markers, marker)
		marker:Hide()
		marker.text:Hide()
		marker:ClearAllPoints()
		marker:SetParent(UIParent)
		marker.text:SetParent(UIParent)
		marker.text:SetText()
		marker.rowPush = nil
		marker.duration = nil
		marker.xOffset = nil
	end

	-- area.CreateSlidingIndicator
	local function areaCreateSlidingIndicator(self)
		local pointer = self:CreateTexture(nil, "OVERLAY")
		pointer:SetTexture("Interface\\Addons\\Utopia\\Textures\\SlidingIndicator")
		pointer:SetWidth(24)
		pointer:SetHeight(8)
		pointer:SetTexCoord(0, 1, 0.05, 0.5)

		local text = self:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		text:SetPoint("BOTTOM", pointer, "TOP", 0, -3)

		pointer.text = text
		return pointer
	end

	-- area.HideCursorLocation
	local function areaHideCursorLocation(self)
		if (self.cursorTick) then
			self.cursorTick:Hide()
			self.cursorTick.text:Hide()
		end
	end

	-- area.ShowCursorLocation
	local function areaShowCursorLocation(self)
		if (not self:MouseInArea()) then
			self:HideCursorLocation()
			self:RemoveHighlight()
			if (GameTooltip:IsOwned(self)) then
				GameTooltip:Hide()
			end
			self.lastTooltipInfo = deepDel(self.lastTooltipInfo)
			return
		end

		local x, y = GetCursorPosition()
		x, y = x / self:GetEffectiveScale(), y / self:GetEffectiveScale()
		if (self.lastX == x and self.lastY == y) then
			return
		end
		self.lastX, self.lastY = x, y

		local offset = self.rightScroll:GetHorizontalScroll()
		local left = self.rightScroll:GetLeft()
		local cursorTime = ((x - left) + offset) / self.scale
		self.cursorTime = cursorTime

		local startSec = offset / self.scale
		local endSec = (offset + self.rightScroll:GetWidth() - 1) / self.scale

		local tooltipShown
		if (cursorTime < startSec or cursorTime > endSec) then
			self:HideCursorLocation()
			self:RemoveHighlight()
		else
			local dpsFrame = self:GetParent().dpsFrame
			if (dpsFrame) then
				dpsFrame:ShowDPSForCursorTime(cursorTime)
			end

			if (not self.cursorTick) then
				self.cursorTick = self:CreateSlidingIndicator()
				self.cursorTick:SetHeight(24)
				self.cursorTick:SetVertexColor(0, 1, 0)
				self.cursorTick:SetTexCoord(0, 1, 0.14, 0.9)
			end

			self.cursorTick:Show()
			self.cursorTick:SetPoint("BOTTOM", self.timeStart, "BOTTOM", (cursorTime - startSec) * self.scale, 0)

			if (cursorTime < 60) then
				self.cursorTick.text:SetFormattedText("%.3fs", cursorTime)
			else
				self.cursorTick.text:SetFormattedText("%dm %.3fs", cursorTime / 60, cursorTime % 60)
			end
			self.cursorTick.text:Show()

			-- Now highlight the spell row for where we are
			local topLine = self.lines and self.lines[1]
			if (topLine) then
				local left, top, width, height = topLine:GetRect()
				local row = floor((top - y) / height) + 2

				if (self.rowHighlight ~= row) then
					self:RemoveHighlight()
				end
				if (row >= 1 and row <= #self.lines) then
					local line = self.lines[row]
					line:LockHighlight()
					self.rowHighlight = row

					if (self:IsMouseOver()) then
						-- Now see if any spells are under the cursor, and show the info
						-- We cache what we show and compare this with last tooltip. Because we're updating
						-- so often there's a noticable lag when updating the tooltip at this frequency
						local temp = new()
						local cursorTimestamp = self.fight.combatStart + cursorTime
						for i,block in ipairs(line.blocks.list) do
							if (cursorTimestamp >= block.timeStart and cursorTimestamp <= block.timeEnd) then
								local name, rank, tex = GetSpellInfo(block.spellId)
								local r, g, b = block:GetVertexColor()

								local sourceName
								if (block.sources) then
									local names = new()
									for name in pairs(block.sources) do
										tinsert(names, name)
									end
									sort(names)
									sourceName = table.concat(names, "|cFF808080, |r")
									del(names)
								else
									sourceName = block.sourceName
								end
								tinsert(temp, new(name, tex, sourceName, r, g, b, block.mobName, block.improved, block.mobKey))
							end
						end

						if (#temp > 0) then
							local redraw
							if (self.lastTooltipInfo) then
								if (#self.lastTooltipInfo ~= #temp) then
									redraw = true
								else
									for i = 1,#temp do
										local t1 = temp[i]
										local t2 = self.lastTooltipInfo[i]
										if (t1[1] ~= t2[1] or t1[3] ~= t2[3] or t1[8] ~= t2[8]) then
											redraw = true
											break
										end
									end
								end
							else
								redraw = true
							end

							local showTime = self.fight.combatStart + cursorTime
							showTime = format("%s.%03d", date("%X", showTime), showTime * 1000 % 1000)

							tooltipShown = true
							if (redraw) then
								local c = 0
								for key in pairs(self.mobKeys) do
									c = c + 1
								end

								GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
								GameTooltip:SetText(showTime, 1, 1, 1)

								for i,t in ipairs(temp) do
									local spellName = t[1]
									local improved, cimp
									if (t[8]) then
										-- Improved value
										local spellInfo = Utopia.lookup.debuffs[t[1]]
										if (spellInfo) then
											if (spellInfo.improved) then
												if (t[8] == spellInfo.maxTalentPoints) then
													improved = L["Improved"]
													cimp = "|cFF80FF80"
												else
													improved = format(L["Improved %d/%d"], t[8], spellInfo.maxTalentPoints)
													cimp = "|cFF80FF80"
												end

											elseif (spellInfo.requiredTalent and spellInfo.amountPerTalentPoint) then
												improved = format(L["Partial %d/%d"], t[8], spellInfo.maxTalentPoints)
												cimp = "|cFFFF8080"

											elseif (spellInfo.maxStacks) then
												if (t[8] < spellInfo.maxStacks) then
													improved = format(L["Partial %d/%d"], t[8], spellInfo.maxStacks)
													cimp = "|cFFFF8080"
												end
											end
										end
									end
									if (improved) then
										spellName = format("%s %s%s|r", spellName, cimp, improved)
									end

									local casterName = t[3]
									local upTime, r, g, b
									if (i == #temp or c > 1) then
										local cat, spell
										if (self.mode == "spell") then
											spell = Utopia.lookup.debuffs[line.catspell]
										else
											cat = Utopia.debuffs[line.catspell]
										end
										upTime = module:GetUptime(self.fight, t[9], cat, spell)
										r, g, b = SmoothColour(upTime)
										if (c > 1) then
											casterName = format("|cFF%02X%02X%02X%.2f%%|r %s", r * 255, g * 255, b * 255, upTime * 100, casterName)
										end
									end

									if (c > 1) then
										GameTooltip:AddDoubleLine(format(L["%s |cFF808080on %s"], spellName, t[7]), casterName, 1, 1, 0.5, t[4], t[5], t[6])
									else
										GameTooltip:AddDoubleLine(spellName, casterName, 1, 1, 0.5, t[4], t[5], t[6])
									end
									GameTooltip:AddTexture(t[2])

									if (c == 1 and i == #temp) then
										GameTooltip:AddDoubleLine("Up-Time:", format("%.2f%%", upTime * 100), 1, 1, 1, r, g, b)
									end
								end
								GameTooltip:Show()
							else
								-- Always update the cursor location time
								GameTooltipTextLeft1:SetText(showTime)
								GameTooltipTextLeft1:SetTextColor(1, 1, 1)
							end
						end

						deepDel(self.lastTooltipInfo)
						self.lastTooltipInfo = temp
					end
				end
			end
		end

		if (not tooltipShown) then
			GameTooltip:Hide()
			self.lastTooltipInfo = deepDel(self.lastTooltipInfo)
		end
	end

	-- area.RemoveHighlight
	local function areaRemoveHighlight(self)
		if (self.rowHighlight) then
			self.lines[self.rowHighlight]:UnlockHighlight()
			self.rowHighlight = nil
		end
	end

	-- area.ShowScroll
	local function areaShowScroll(self)
		local offset = self.rightScroll:GetHorizontalScroll()

		if (not self.timeStart) then
			self.timeStart = self:CreateSlidingIndicator()
			self.timeStart:SetPoint("BOTTOM", self.rightScroll, "TOPLEFT", 0, 0)
		end
		if (not self.timeEnd) then
			self.timeEnd = self:CreateSlidingIndicator()
			self.timeEnd:SetPoint("BOTTOM", self.rightScroll, "TOPRIGHT", -1, 0)
		end

		local width = self.rightScroll:GetWidth() - 1
		local startSec = offset / self.scale
		local endSec = (offset + width) / self.scale

		self.timeStart.text:SetFormattedText("%d", abs(startSec))
		self.timeEnd.text:SetFormattedText("%d", endSec)

		if (not self.ticks) then
			self.ticks = {}
		end

		local div = self.scale < 4 and 30 or self.scale < 8 and 15 or self.scale < 16 and 5 or 1
		local divText = self.scale < 4 and 60 or self.scale < 8 and 30 or self.scale < 16 and 15 or 5

		local startPoint = floor((startSec + div) / div) * div
		local i = 0
		for secs = startPoint,endSec,div do
			local short = secs % divText ~= 0
			local vshort = secs % 5 ~= 0
			local gap = short and 20 or 50

			local showOffset = (secs - startSec) * self.scale

			if (showOffset >= width - 10) then
				break
			elseif (showOffset > 10) then
				local nearEdge = min(showOffset - 10, width - 10 - showOffset)
				local fade
				if (nearEdge < gap) then
					fade = nearEdge / gap
				else
					fade = 1
				end

				i = i + 1
				local tick = self.ticks[i]
				if (not tick) then
					tick = self:CreateSlidingIndicator()
					self.ticks[i] = tick
				end

				tick:SetPoint("BOTTOM", self.timeStart, "BOTTOM", (secs - startSec) * self.scale, 0)
				tick:Show()

				if (vshort) then
					tick:SetVertexColor(0.5, 0.5, 0.5)
				else
					tick:SetVertexColor(1, 1, 1)
				end

				if (short) then
					tick:SetHeight(3)
					tick:SetTexCoord(0, 1, 0.5, 0.9)
					tick.text:Hide()
				else
					tick:SetHeight(8)
					tick:SetTexCoord(0, 1, 0.05, 0.5)
					tick.text:SetFormattedText("%d:%02d", secs / 60, secs % 60)

					tick.text:Show()
				end

				tick:SetAlpha(fade)
				tick.text:SetAlpha(fade)
			end
		end
		for j = i + 1,#self.ticks do
			local tick = self.ticks[j]
			tick:Hide()
			tick.text:Hide()
		end
	end

	-- area.BuildSpellNameList
	local function areaBuildSpellNameList(self)
		if (not self.mobKeys) then
			return
		end

		local fight = self.fight
		local data = fight.data
		if (not data) then
			return
		end

		local spellIcons = new()
		local spellIds = new()
		local lineColours = new()
		local activeClassesForCat = new()

		local temp = new()
		for mobKey in pairs(self.mobKeys) do
			local fightData = data[mobKey]
			if (fightData) then
				local delFD
				if (type(fightData) == "string") then
					fightData = new(strsplit(";", fightData))
					delFD = true
				end

				for i = 1,#fightData do
					local segment = fightData[i]
					local timeStart, timeEnd, sourceName, sourceClass, sourceGUID, spellId, realSpellId = module:GetStoredData(fight, segment)
					local name, rank, tex = GetSpellInfo(spellId)
					local spellInfo = Utopia.lookup.debuffs[name]
					if (self.mode == "category") then
						if (spellInfo) then
							name = spellInfo.key
							if (db.coloursExtreme) then
								local cat = Utopia.debuffs[name]
								local temp2 = activeClassesForCat[cat.key]
								if (not temp2) then
									temp2 = new()
									activeClassesForCat[cat.key] = temp2
								end
								temp2[spellInfo.class] = true
							end

							if (spellInfo.multiple) then
								for i,key in ipairs(spellInfo.multiple) do
									temp[key] = true

									if (db.coloursExtreme) then
										local temp2 = activeClassesForCat[key]
										if (not temp2) then
											temp2 = new()
											activeClassesForCat[key] = temp2
										end
										temp2[spellInfo.class] = true
									end
								end
							end
						end
					else
						if (name) then
							spellIcons[name] = tex
							spellIds[name] = spellId
							local c = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[spellInfo.class]
							lineColours[name] = new(c.r, c.g, c.b)
						end
					end

					if (name) then
						temp[name] = true
					end
				end

				if (delFD) then
					del(fightData)
				end
			end
		end

		local toSort = new()
		for name in pairs(temp) do
			tinsert(toSort, name)
		end
		del(temp)
		sort(toSort)

		for i,name in ipairs(toSort) do
			local displayLine = self.nameToLineLookup[name]
			if (not displayLine) then
				self.shownLines = self.shownLines + 1
				displayLine = self.shownLines
				self.nameToLineLookup[name] = displayLine
			end

			-- Pre-create the known spell lines, so they appear in correct order later
			local line = self.lines[displayLine]
			if (not line) then
				line = self:CreateSpellLine(displayLine)
			end
			line.catspell = name
			line.text:SetText(name)
			line:Show()

			if (self.mode == "category") then
				local cat = Utopia.debuffs[name]
				if (cat) then
					line.icon:SetTexture(cat.icon)
					line.text:SetTextColor(0.8, 0.8, 0.8)
				end
			else
				line.icon:SetTexture(spellIcons[name])
			end
			line.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

			if (self.mode == "spell") then
				line.spellId = spellIds[name]
				line.text:SetTextColor(unpack(lineColours[name]))
			else
				if (db.coloursExtreme) then
					local cat = Utopia.debuffs[name]
					if (cat) then
						local activeClasses = activeClassesForCat[cat.key]
						local temp = new()
						for class in pairs(activeClasses) do
							tinsert(temp, class)
						end
						sort(temp)

						lineColours[name] = new()
						for i,class in pairs(temp) do
							local c = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
							tinsert(lineColours[name], new(c.r, c.g, c.b))
						end
						del(temp)

						local str
						local lc = lineColours[name]
						if (#lc > 2) then
							str = ""
							for i = 1,#lc - 1 do
								local r1, g1, b1 = unpack(lc[i])
								local r2, g2, b2 = unpack(lc[i + 1])
	
								local part = name:sub(floor((i - 1) * (#name / (#lc - 1)) + 1), floor(i * (#name / (#lc - 1))))
								part = Gradient(part, r1, g1, b1, r2, g2, b2)
								str = str.. part
							end
						elseif (#lc == 2) then
							local r1, g1, b1 = unpack(lc[1])
							local r2, g2, b2 = unpack(lc[2])
							str = Gradient(name, r1, g1, b1, r2, g2, b2)
						else
							line.text:SetTextColor(unpack(lc[1]))
						end
						if (str) then
							line.text:SetText(str)
						end
					end
				end
			end
		end

		--self.leftScrollChild:SetHeight(self.shownLines * 20)
		--self.rightScrollChild:SetHeight(self.shownLines * 20)

		del(toSort)
		del(spellIcons)
		del(spellIds)
		del(lineColours)
	end

	-- area.AddSpell
	local function areaAddSpell(self, timeStart, timeEnd, sourceName, sourceGUID, spellId, realSpellId, mobName, mobKey, improved)
		local spellName, rank, tex = GetSpellInfo(spellId)
		if (spellName) then
			local spellInfo = Utopia.lookup.debuffs[spellName]
			if (spellInfo) then
				local name
				if (self.mode == "category") then
					name = spellInfo.key
				else
					name = spellName
				end

				self:AddSpellInfoToLine(timeStart, timeEnd, sourceName, sourceGUID, spellId, realSpellId, mobName, mobKey, name, spellInfo, improved)

				if (self.mode == "category" and spellInfo.multiple) then
					for i,key in ipairs(spellInfo.multiple) do
						self:AddSpellInfoToLine(timeStart, timeEnd, sourceName, sourceGUID, spellId, realSpellId, mobName, mobKey, key, spellInfo, improved)
					end
				end
			end
		end
	end

	-- area.AddSpellInfoToLine
	local function areaAddSpellInfoToLine(self, timeStart, timeEnd, sourceName, sourceGUID, spellId, realSpellId, mobName, mobKey, name, spellInfo, improved)
		local xOffsetStart = (timeStart - self.fight.combatStart) * self.scale
		local xWidth = (timeEnd - timeStart) * self.scale

		local displayLine = self.nameToLineLookup[name]
		if (not displayLine) then
			self.shownLines = self.shownLines + 1
			displayLine = self.shownLines
			self.nameToLineLookup[name] = displayLine
		end

		local line = self.lines[displayLine]
		if (not line) then
			line = self:CreateSpellLine(displayLine)
			line.catspell = name
		end

		local blocklist = line.blocks.list
		local last = blocklist[#blocklist]
		if (last) then
			-- Some jigery pokery here to cut down on the number of textures we display
			-- Basically matching up the start time of an aura with the end time of the previous one (-+ 0.1 secs)
			-- Also handles the mergeAppliers option to join multiple people doing the same debuff into one texture
			if (last.spellId == spellId and last.realSpellId == realSpellId and last.mobKey == mobKey and last.improved == improved) then
				if (timeStart >= last.timeStart and timeStart <= last.timeEnd + 0.1) then
					if (last.sourceName == sourceName or db.mergeAppliers) then
						local newWidth = (timeEnd - last.timeStart) * self.scale
						last.timeEnd = timeEnd
						last:SetWidth(newWidth)
						if (last.sourceName ~= sourceName) then
							if (not last.sources) then
								last.sources = new()
								last.sources[last.sourceName] = true
							end
							if (not last.sources[sourceName]) then
								last.sources[sourceName] = true

								if (self.playerNames and last.ownerText) then
									local names = new()
									for name in pairs(last.sources) do
										tinsert(names, name)
									end
									sort(names)
									local sourceName = table.concat(names, "|cFF808080, |r")
									last.ownerText:SetText(sourceName)
									del(names)
								end
							end
						end
						return
					end
				end
			end
		end
		if (xWidth < 0.5) then
			return
		end

		xOffsetStart = floor(xOffsetStart * 10) / 10

		local tex = module:AquireAreaTexture(line.blocks, self.playerNames)
		tex:SetPoint("LEFT", xOffsetStart, 0.1)	-- The 0.1 seems to help (not fix) the vertical nudging with fonts present
		tex:SetWidth(xWidth)					-- Yet to find a cure for the horizontal

		if (spellInfo.improved) then
			local height = floor(10 * (improved or 0) / spellInfo.maxTalentPoints + 0.5)
			tex:SetHeight(10+height)
		elseif (spellInfo.maxTalentPoints and spellInfo.requiredTalent and spellInfo.amountPerTalentPoint) then
			if (improved) then
				-- improved here is how many points they have in it. If this is absent, then full is assumed
				local height = floor(10 * improved / spellInfo.maxTalentPoints + 0.5)
				tex:SetHeight(10+height)
			end
		elseif (spellInfo.maxStacks) then
			if (improved and improved < spellInfo.maxStacks) then
				local height = floor(10 * improved / spellInfo.maxStacks + 0.5)
				tex:SetHeight(10+height)
			end
		end

		local c = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[spellInfo.class]
		local r, g, b = c.r, c.g, c.b
		if (displayLine % 2 == 1) then
			r, g, b = max(0, r * 0.9), max(0, g * 0.9), max(0, b * 0.9)
		end
		tex:SetVertexColor(r, g, b)

		if (self.playerNames) then
			tex:SetOwnerText(sourceName, r, g, b)
			if (last) then
				-- Move the caster name to bottom if it's going to overlap the previous one
				local _, _, _, xLastOffsetStart, _ = last:GetPoint(1)
				if (xOffsetStart >= xLastOffsetStart and xOffsetStart - xLastOffsetStart <= last.ownerText:GetStringWidth()) then
					if (last.ownerText:GetJustifyV() == "TOP") then
						tex.ownerText:SetJustifyV("BOTTOM")
					end
				end
			end
		end

		tex.spellId		= spellId
		tex.realSpellId	= realSpellId
		tex.sourceName	= sourceName
		tex.timeStart	= timeStart
		tex.timeEnd		= timeEnd
		tex.mobName		= mobName
		tex.mobKey		= mobKey
		tex.improved	= improved

		tinsert(blocklist, tex)
	end

	do
		local function slOnMouseDown(self)
			local area = self:GetParent():GetParent():GetParent()
			area.rightScroll:OnMouseDown()
		end

		local function slOnMouseUp(self)
			local area = self:GetParent():GetParent():GetParent()
			area.rightScroll:OnMouseUp()
		end

		local function slOnEnter(self)
			if (self.spellId) then
				local area = self:GetParent():GetParent():GetParent()
				local rs = area.rightScroll
				if (not rs.dragging and not rs.speedX and not rs.swooshTarget and not rs.targetTime) then
					GameTooltip:SetOwner(self, "ANCHOR_TOP")
					GameTooltip:SetHyperlink("spell:"..self.spellId)
				end
			end
		end

		local function slOnLeave(self)
			GameTooltip:Hide()
		end

		local function slOnShow(self)
			-- Also, we need to hide this when we hide the line else the ScrollFrame
			-- will keep the max growth height we've had even with hidden lines
			self.blocks:Show()
		end

		local function slOnHide(self)
			local list = self.blocks.list
			for i,tex in pairs(list) do
				module:ReleaseAreaTexture(tex)
			end
			del(list)
			self.blocks.list = new()
			self.blocks:Hide()
		end

		-- CreateSpellLine
		function areaCreateSpellLine(self, index)
			local l = CreateFrame("Button", nil, self.leftScrollChild)
			self.lines[index] = l
			l:EnableMouse(true)

			-- NOTE: Have to use absolute anchoring here only to the ScrollChild because of ScrollFrame limitations
			l:SetPoint("TOPLEFT", 0, -(index - 1) * 20)
			l:SetPoint("BOTTOMRIGHT", self.leftScrollChild, "TOPRIGHT", 0, -index * 20)

			if (index % 2 == 0) then
				l.bg = l:CreateTexture(nil, "BACKGROUND")
				l.bg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
				l.bg:SetVertexColor(0.3, 0.3, 0.8, 0.3)
				l.bg:SetAllPoints()
			end

			l.icon = l:CreateTexture(nil, "OVERLAY")
			l.icon:SetWidth(18)
			l.icon:SetHeight(18)
			l.icon:SetPoint("TOPLEFT", 1, -1)

			l.text = l:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			l.text:SetHeight(20)
			l.text:SetWidth(300)
			l.text:SetPoint("LEFT", l.icon, "RIGHT", 2, 0)
			l.text:SetJustifyH("LEFT")

			l:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
			l.highlight = l:GetHighlightTexture()
			l.highlight:SetBlendMode("ADD")
			l.highlight:SetTexCoord(0.25, 0.75, 0.25, 0.75)
			l.highlight:SetAlpha(0.3)
			l.highlight:SetAllPoints(true)

			l.blocks = CreateFrame("Frame", nil, self.rightScrollChild)
			l.blocks.list = {}

			-- NOTE: Have to use absolute anchoring here only to the ScrollChild because of ScrollFrame limitations
			l.blocks:SetPoint("TOPLEFT", 0, -(index - 1) * 20)
			l.blocks:SetPoint("BOTTOMRIGHT", self.rightScrollChild, "TOPRIGHT", 0, -index * 20)

			l:SetScript("OnMouseDown", slOnMouseDown)
			l:SetScript("OnMouseUp", slOnMouseUp)
			l:SetScript("OnEnter", slOnEnter)
			l:SetScript("OnLeave", slOnLeave)
			l:SetScript("OnHide", slOnHide)
			l:SetScript("OnShow", slOnShow)

			return l		
		end
	end


	local areaOnMouseDown, areaOnMouseUp
	do
		-- Dragging Functions
		local function draggingOnUpdate(self, elapsed)
			local x, y = GetCursorPosition()
			x, y = x / self:GetEffectiveScale(), y / self:GetEffectiveScale()

			local curX, curY = self:GetHorizontalScroll(), self:GetVerticalScroll()
	    	local newX = min(self:GetHorizontalScrollRange(), max(0, curX - x + self.dragX))
	    	local newY = min(self:GetVerticalScrollRange(), max(0, curY + y - self.dragY))

			self:SetHorizontalScroll(newX)
			self:SetVerticalScroll(newY)
			self:GetParent():ShowCursorLocation()

			local scale = self:GetParent().scale
			self.speedX = (newX - curX)
			self.speedY = newY - curY
			self.dragX, self.dragY = x, y
		end

		-- area.rightScroll.driftingOnUpdate
		local function driftingOnUpdate(self, elapsed)
			local curX, curY = self:GetHorizontalScroll(), self:GetVerticalScroll()
			local area = self:GetParent()

			local scale = area.scale
			self.speedX = self.speedX * (1 - elapsed * 10)
			self.speedY = self.speedY * (1 - elapsed * 10)

	    	local newX = min(self:GetHorizontalScrollRange(), max(0, curX + self.speedX))
	    	local newY = min(self:GetVerticalScrollRange(), max(0, curY + self.speedY))

			self:SetHorizontalScroll(newX)
			self:SetVerticalScroll(newY)
			self:GetParent():ShowCursorLocation()

			if (abs(self.speedX) < 0.1 and abs(self.speedY) < 0.1) then
				self.speedX, self.speedY = nil, nil
				if (area:MouseInArea()) then
					self:SetScript("OnUpdate", areaRightScrollOnUpdate)
				else
					self:SetScript("OnUpdate", nil)
				end
				return
			end
		end

		-- area.rightScroll.MouseInArea
		function areaMouseInArea(self)
			if (self:IsMouseOver()) then
				return true
			end
			local dpsFrame = self:GetParent().dpsFrame
			if (dpsFrame) then
				return dpsFrame:IsMouseOver()
			end
		end

		-- area.rightScroll.OnMouseDown
		function areaOnMouseDown(self)
			self.dragging = true
			self.downTime = GetTime()
			self.dragX, self.dragY = GetCursorPosition()
			self.dragX, self.dragY = self.dragX / self:GetEffectiveScale(), self.dragY / self:GetEffectiveScale()
			self:SetScript("OnUpdate", draggingOnUpdate)
		end

		-- area.rightScroll.OnMouseUp
		function areaOnMouseUp(self, button)
			self.dragging = nil
			if (max(abs(self.speedX or 0), abs(self.speedY or 0)) >= 0.1) then
				self:SetScript("OnUpdate", driftingOnUpdate)
			else
				self.speedX, self.speedY = nil, nil
				if (self:GetParent():MouseInArea()) then
					self:SetScript("OnUpdate", areaRightScrollOnUpdate)
				else
					self:SetScript("OnUpdate", nil)
				end

				if (self.dragX) then
					local x, y = GetCursorPosition()
					x, y = x / self:GetEffectiveScale(), y / self:GetEffectiveScale()
					if (abs(x - self.dragX) <= 1 and abs(y - self.dragY) < 1) then
						if (GetTime() - self.downTime < 0.5) then
							self:OnClick(button)
						end
					end
				end
			end
		end
	end

	-- area.rightScroll.OnClick
	local function areaOnClick(self, button)
		if (button == "LeftButton" and IsModifiedClick("CHATLINK")) then
			self:GetParent():ChatLinkCursorLocation()
		end
	end

	-- area.rightScroll.ChatLinkCursorLocation
	local function areaChatLinkCursorLocation(self)
		local x, y = GetCursorPosition()
		x, y = x / self:GetEffectiveScale(), y / self:GetEffectiveScale()
		local offset = self.rightScroll:GetHorizontalScroll()
		local left = self.rightScroll:GetLeft()
		local cursorTime = ((x - left) + offset) / self.scale

		local topLine = self.lines and self.lines[1]
		if (topLine) then
			local left, top, width, height = topLine:GetRect()
			local row = floor((top - y) / height) + 2
			if (row >= 1 and row <= #self.lines) then
				local line = self.lines[row]
				line:LockHighlight()

				local temp = new()
				local cursorTimestamp = self.fight.combatStart + cursorTime
				for i,block in ipairs(line.blocks.list) do
					if (cursorTimestamp >= block.timeStart and cursorTimestamp <= block.timeEnd) then
						local realname, realrank, realtex = GetSpellInfo(block.realSpellId or block.spellId)
						local name, rank, tex = GetSpellInfo(block.spellId)
						--local link = GetSpellLink(block.spellId)			-- Doesn't work for talents sometimes..
						if (strfind(realname, name)) then
							link = format("|cff71d5ff|Hspell:%d|h[%s]|h|r", block.realSpellId or block.spellId, realname or name)
						else
							link = format("|cff71d5ff|Hspell:%d|h[%s]|h|r", block.spellId, name)
						end

						local sourceName
						if (block.sources) then
							local names = new()
							for name in pairs(block.sources) do
								tinsert(names, name)
							end
							sort(names)
							sourceName = table.concat(names, "|cFF808080, |r")
							del(names)
						else
							sourceName = block.sourceName
						end

						local spell, cat
						if (self.mode == "spell") then
							spell = Utopia.lookup.debuffs[line.catspell]
						else
							cat = Utopia.debuffs[line.catspell]
						end

						local spellInfo = Utopia.lookup.debuffs[name]
						if (spellInfo) then
							local improved
							if (spellInfo.improved and block.improved) then
								if (block.improved == spellInfo.maxTalentPoints) then
									improved = L["Improved"]
								else
									improved = format(L["Improved %d/%d"], block.improved, spellInfo.maxTalentPoints)
								end

							elseif (spellInfo.requiredTalent and spellInfo.amountPerTalentPoint) then
								improved = format(L["Partial %d/%d"], block.improved, spellInfo.maxTalentPoints)

							elseif (spellInfo.maxStacks) then
								if (block.improved < spellInfo.maxStacks) then
									improved = format(L["Partial %d/%d"], block.improved, spellInfo.maxStacks)
								end
							end

							if (improved) then
								link = format("%s %s", link, improved)
							end
						end

						local upTime = module:GetUptime(self.fight, block.mobKey, cat, spell)
						local str = format(L["%s on %s by %s: %.2f%% Up-Time"], link, block.mobName, sourceName, upTime * 100)

						local activeWindow = ChatEdit_GetActiveWindow()
						if activeWindow then
							activeWindow:Insert(str)
						end
						break
					end
				end
			end
		end
	end

	-- area.Zoom
	local function areaZoom(self, zoomIn)
		-- Change the scale
		local oldScale = self.scale
		local diff = floor((self.scale + 10) / 10)			-- 1-10 steps 1, 11-20 steps 2 etc.
		if (zoomIn) then
			if (self.scale < 2) then
				diff = 0.5
			end
			self.scale = min(64, self.scale + diff)
		else
			if (self.scale == 2) then
				self.scale = 1.5
			else
				self.scale = max(1, self.scale - diff)
			end
		end
		self.scale = floor(self.scale * 10) / 10
		if (self.scale == oldScale) then
			return
		end

		-- Work out where our cursor is atm, we'll want it in the same position after zooming
		local offset = self.rightScroll:GetHorizontalScroll()
		local x = GetCursorPosition() / self:GetEffectiveScale()
		local cursorOffset = x - self.rightScroll:GetLeft()
		local cursorTime = (cursorOffset + offset) / oldScale
		local startSec = offset / oldScale
		if (cursorTime < startSec) then
			cursorTime = startSec	-- Mouse is not over the ScrollFrame (probably using the controls for zooming)
		end

		-- Redraw
		self:Init()
		self:Populate()
		self:ShowScale()

		-- Now set the new offset so the cursor is where it was before zooming
		local newOffset = (cursorTime * self.scale) - cursorOffset
		if (newOffset < 0) then
			newOffset = 0
		end
		self.rightScroll:SetHorizontalScroll(newOffset)
	end

	-- OnMouseWheel
	local function areaOnMouseWheel(self, delta)
		local area = self:GetParent()
		if (delta < 0) then
			area:Zoom()
		else
			area:Zoom(true)
		end
	end

	-- ShowScale
	-- Internally, a scale of 1 means 1 pixel to 1 second
	-- That's a bit small tho, 6 pixels to 1 second is a good visual point, so we'll call that the 100% mark
	local function areaShowScale(self)
		self.scaleFrame.text:SetFormattedText(L["Zoom: %d%%"], 100 / 6 * self.scale)
	end

	-- ScaleUpOnClick
	local function areaScaleUpOnClick(self)
		local area = self:GetParent():GetParent().area
		area:Zoom(true)
	end

	-- ScaleDownOnClick
	local function areaScaleDownOnClick(self)
		local area = self:GetParent():GetParent().area
		area:Zoom()
	end

	-- area.rightScroll:OnSizeChanged
	local function areaOnSizeChanged(self, x, y)
		self:GetParent():ShowScroll()
	end

	-- area:OnVerticalScroll
	local function areaOnVerticalScroll(self, offset)
		local rightScrollbar = getglobal(self:GetName().."ScrollBar")
		self:GetParent().leftScroll:SetVerticalScroll(rightScrollbar:GetValue())
		self:GetParent():ShowScroll()
	end

	-- area.rightScroll:OnHorizontalScroll
	local function areaOnHorizontalScroll(self, offset)
		local scrollbar = getglobal(self:GetName().."ScrollBar2")
		if (scrollbar) then
			scrollbar:SetValue(offset)
			local min, max = scrollbar:GetMinMaxValues()
			if ( offset <= 0 ) then
				getglobal(scrollbar:GetName().."ScrollUpButton"):Disable()
			else
				getglobal(scrollbar:GetName().."ScrollUpButton"):Enable()
			end
			if (offset >= max) then
				getglobal(scrollbar:GetName().."ScrollDownButton"):Disable()
			else
				getglobal(scrollbar:GetName().."ScrollDownButton"):Enable()
			end
		end

		local area = self:GetParent()
		local frame = area:GetParent()
		area:ShowScroll()
		if (frame.dpsFrame and frame.showDPS) then
			frame.dpsFrame.scroll:SetHorizontalScroll(self:GetHorizontalScroll())
		end
	end

	-- CreateWorkArea
	function module:CreateWorkArea(parent)
		local a = CreateFrame("Frame", nil, parent)
		-- info.record["0xF13000808A015559"]["0x010000000008BC20"]["Improved Scorch"]
		a.lines = {}
		a.mode = "category"
		a.scale = 6

		local leftScrollName = lzf:GenericSuffixName(parent, "ScrollFrame")
		local rightScrollName = lzf:GenericSuffixName(parent, "ScrollFrame")

		a.leftScroll = CreateFrame("ScrollFrame", leftScrollName, a)
		local ls = a.leftScroll
		a.leftScrollChild = CreateFrame("Frame", nil, ls)

		a.bar = lzf:CreateVerticalBar(a.leftScroll, "RIGHT", true)

		a.rightScroll = CreateFrame("ScrollFrame", rightScrollName, a, "UIPanelScrollFrameTemplate")
		local rs = a.rightScroll
		a.rightScrollChild = CreateFrame("Frame", nil, rs)

		ls:SetScrollChild(a.leftScrollChild)
		rs:SetScrollChild(a.rightScrollChild)

		ls:SetPoint("TOPLEFT")
		ls:SetPoint("BOTTOMRIGHT", a, "BOTTOMLEFT", 150, 0)
		rs:SetPoint("TOPLEFT", ls, "TOPRIGHT", 10, 0)
		rs:SetPoint("BOTTOMRIGHT")

		a.leftScrollChild:SetWidth(200)
		a.leftScrollChild:SetHeight(300)
		a.rightScrollChild:SetWidth(500)
		a.rightScrollChild:SetHeight(50)

		rs:HookScript("OnVerticalScroll", areaOnVerticalScroll)
		rs:SetScript("OnHorizontalScroll", areaOnHorizontalScroll)

		-- Header
		local htl = a:CreateTexture(nil, "BORDER")
		a.headerTopL = htl
		htl:SetTexture("Interface\\Addons\\Utopia\\Textures\\LibZekFrames-TopInset")
		htl:SetTexCoord(0, 0.25, 0, 1)
		htl:SetPoint("BOTTOMLEFT", a, "TOPLEFT", 120, -24)
		htl:SetWidth(64)
		htl:SetHeight(64)

		local htr = a:CreateTexture(nil, "BORDER")
		a.headerTopR = htr
		htr:SetTexture("Interface\\Addons\\Utopia\\Textures\\LibZekFrames-TopInset")
		htr:SetTexCoord(0.75, 1, 0, 1)
		htr:SetPoint("BOTTOMRIGHT", a, "TOPRIGHT", 30, -24)
		htr:SetWidth(64)
		htr:SetHeight(64)

		local hmid = a:CreateTexture(nil, "BORDER")
		a.headerMid = hmid
		hmid:SetTexture("Interface\\Addons\\Utopia\\Textures\\LibZekFrames-TopInset")
		hmid:SetTexCoord(0.0625, 0.9375, 0, 1)
		hmid:SetPoint("TOPLEFT", htl, "TOPRIGHT")
		hmid:SetPoint("BOTTOMRIGHT", htr, "BOTTOMLEFT")

		rs:EnableMouseWheel(true)
		rs:EnableMouse(true)
		rs:SetScript("OnMouseDown", areaOnMouseDown)
		rs:SetScript("OnMouseUp", areaOnMouseUp)
		rs:SetScript("OnSizeChanged", areaOnSizeChanged)
		rs:SetScript("OnEnter", areaRightScrollOnEnter)
		rs:SetScript("OnLeave", areaRightScrollOnLeave)
		rs:SetScript("OnMouseWheel", areaOnMouseWheel)

		rs.OnEnter = areaRightScrollOnEnter
		rs.OnLeave = areaRightScrollOnLeave
		rs.OnMouseDown = areaOnMouseDown
		rs.OnMouseUp = areaOnMouseUp
		rs.OnMouseWheel = areaOnMouseWheel
		rs.OnClick = areaOnClick

		-- Scale controls
		local sc = CreateFrame("Frame", nil, parent)
		a.scaleFrame = sc
		sc:SetPoint("BOTTOMLEFT", a, "TOPLEFT", 0, 10)
		sc:SetPoint("TOPRIGHT", htl, "TOPLEFT", -5, 0)

		sc.upButton = lzf:CreateArrowButton(sc, "up")
		sc.downButton = lzf:CreateArrowButton(sc, "down")
		sc.upButton:SetScript("OnClick", areaScaleUpOnClick)
		sc.downButton:SetScript("OnClick", areaScaleDownOnClick)

		sc.upButton:SetPoint("TOPRIGHT")
		sc.downButton:SetPoint("TOP", sc.upButton, "BOTTOM")
		sc.text = sc:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		sc.text:SetPoint("RIGHT", sc.upButton, "BOTTOMLEFT", -4, 0)

		-- Functions
		a.SelectMobKey			= areaSelectMobKey
		a.OnClose				= areaOnClose
		a.ResetLines			= areaResetLines
		a.ClearDisplay			= areaClearDisplay
		a.SetMode				= areaSetMode
		a.Init					= areaInit
		a.BuildSpellNameList	= areaBuildSpellNameList
		a.Populate				= areaPopulate
		a.PopulateAuras			= areaPopulateAuras
		a.PopulateDeaths		= areaPopulateDeaths
		a.PopulateEvents		= areaPopulateEvents
		a.FindClearRow			= areaFindClearRow
		a.CleanupDeaths			= areaCleanupDeaths
		a.ShowScroll			= areaShowScroll
		a.ShowScale				= areaShowScale
		a.ShowCursorLocation	= areaShowCursorLocation
		a.HideCursorLocation	= areaHideCursorLocation
		a.RemoveHighlight		= areaRemoveHighlight
		a.AddSpell				= areaAddSpell
		a.AddSpellInfoToLine	= areaAddSpellInfoToLine
		a.CreateSpellLine		= areaCreateSpellLine
		a.CreateSlidingIndicator = areaCreateSlidingIndicator
		a.Zoom					= areaZoom
		a.ShowDPS				= areaShowDPS
		a.CreateDeathMarker		= areaCreateDeathMarker
		a.AquireDeathMarker		= areaAquireDeathMarker
		a.ReleaseDeathMarker	= areaReleaseDeathMarker
		a.MouseInArea			= areaMouseInArea
		a.ChatLinkCursorLocation = areaChatLinkCursorLocation

		return a
	end
end

do
	-- dps.SetFight
	local function dpsSetFight(self, fight)
		if (fight ~= self.fight) then
			self.fight = fight
			self.playerSelection = del(self.playerSelection)
			self:ShowPlayerSelection()
		end
		self:Show()
		self:CalcDPS()
		self:DrawDPS()
	end

	-- frameOnSetSmoothing
	local function dpsOnSetSmoothing(self, e, newval)
		self:SetShowDPSColour(self)
		self:CalcDPS()
		self:DrawDPS()
	end

	-- dpsOnSetDPSMode
	local function dpsOnSetDPSMode(self, e, newOn)
		if (self.playerSelection) then
			self.playerSelection = del(self.playerSelection)
			self:ShowPlayerSelection()
		end

		self.showDPS = newOn
		self.raidDPSCheckBox:SetChecked(self.showDPS)
		self:SetShowDPSColour(self)
		self:CalcDPS()
		self:DrawDPS()
	end

	-- dpsOnShow
	local function dpsOnShow(self)
		Utopia.RegisterCallback(self, "Utopia_SetSmoothing", dpsOnSetSmoothing, self)
		Utopia.RegisterCallback(self, "Utopia_SetDPSMode", dpsOnSetDPSMode, self)
	end

	-- dps.OnHide
	local function dpsOnHide(self)
		Utopia.UnregisterCallback(self, "Utopia_SetSmoothing")
		Utopia.UnregisterCallback(self, "Utopia_SetDPSMode")
		self.playerSelection = del(self.playerSelection)
		self.fight = nil
		self.dmg = deepDel(self.dmg)
		self.showDPS = true
		self.showDPSBoss = nil
		self:ShowDPSForCursorTime()
		self:Cleanup()

		if (module.playersel and module.playersel:IsOwned(self)) then		
			module.playersel:Hide()
		end
	end

	-- dps.Cleanup
	local function dpsCleanup(self)
		if (self.texList) then
			for i,tex in pairs(self.texList) do
				self:ReleaseDPSBlock(tex)
			end
			self.texList = del(self.texList)
		end
	end

	local blocks = {}
	-- dps.CreateDPSBlock
	local function dpsCreateDPSBlock(self, parent)
		local tex = parent:CreateTexture(nil, "OVERLAY")
		tex:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
		return tex
	end

	-- dps.AquireDPSBlock
	local function dpsAquireDPSBlock(self, parent)
		local tex = tremove(blocks) or self:CreateDPSBlock(parent)
		tex:SetParent(parent)
		tex:Show()
		return tex
	end

	-- dps.ReleaseDPSBlock
	local function dpsReleaseDPSBlock(self, tex)
		tex:ClearAllPoints()
		tex:SetParent(UIParent)
		tex:Hide()
		tex:SetHeight(0)
		tex.amount = nil
		tinsert(blocks, tex)
	end

	-- dps.DrawDPS
	local function dpsDrawDPS(self)
		self:Cleanup()
		self.texList = new()

		local parent = self:GetParent()
		if (self.showDPS) then
			self:DrawDPSPart("raid")
		end
		if (self.showDPSBoss) then
			self:DrawDPSPart("boss")
		end

		local area = self:GetParent().area
		self.scroll:SetHorizontalScroll(area.rightScroll:GetHorizontalScroll())
	end

	-- dps.DrawDPS
	local function dpsDrawDPSPart(self, what)
		local dps, dps2
		if (self.dmg) then
			if (what == "raid" and (self.dmg.raidp or self.dmg.raidm)) then
				if (db.dpsMode == "pm") then
					dps = self.dmg.raidp
					dps2 = self.dmg.raidm
				elseif (db.dpsMode == "mp") then
					dps = self.dmg.raidm
					dps2 = self.dmg.raidp
				elseif (db.dpsMode == "p") then
					dps = self.dmg.raidp
				elseif (db.dpsMode == "m") then
					dps = self.dmg.raidm
				elseif (not db.dpsMode) then
					dps = self.dmg.raidp
					dps2 = self.dmg.raidm
				end
			else
				dps = self.dmg[what]
			end
		end
		if (not dps) then
			return
		end

		local dpsmax = dps.max + (dps2 and dps2.max or 0)
		local endSec = floor(self.fight.combatEnd - self.fight.combatStart + 1)
		local area = self:GetParent().area
		local oneSecWidth = area.scale
		local height = self.height - 1

		for i = 1,endSec do
			local amount = dps.amounts[i]
			if (not db.dpsMode and dps2) then
				amount = (amount or 0) + (dps2.amounts[i] or 0)
			end
			if (amount and amount >= 1) then
				local tex = self:AquireDPSBlock(self.scrollChild)
				tinsert(self.texList, tex)

				tex:SetWidth(oneSecWidth)
				tex:SetHeight(amount / dpsmax * height)
				tex:SetPoint("BOTTOMLEFT", oneSecWidth * (i - 1), 0)
				tex.amount = amount

				if (what == "boss") then
					tex:SetVertexColor(1, 0, 0)
				elseif (what == "raid") then
					if (db.dpsMode == "m" or db.dpsMode == "mp") then
						tex:SetVertexColor(0, 0.5, 1)
					else
						tex:SetVertexColor(0, 1, 0)
					end
				end
			end

			if (db.dpsMode) then
				amount2 = dps2 and dps2.amounts[i]
				if (amount2 and amount2 >= 1) then
					local tex2 = self:AquireDPSBlock(self.scrollChild)
					tinsert(self.texList, tex2)

					tex2:SetWidth(oneSecWidth)
					tex2:SetHeight(amount2 / dpsmax * height)
					tex2:SetPoint("BOTTOMLEFT", oneSecWidth * (i - 1), (amount or 0) / dpsmax * height)
					tex2.amount = amount2

					if (db.dpsMode == "pm") then
						tex2:SetVertexColor(0, 0.5, 1)
					else
						tex2:SetVertexColor(0, 1, 0)
					end
				end
			end
		end
	end

	-- dps.CalcDPS
	local function dpsCalcDPS(self)
		self.dmg = deepDel(self.dmg)
		self.dmg = new()

		if (self.showDPS and self.fight.playerdps and self.playerSelection) then
			self.dmg.raid = new()
			local tempMax
			self.dmg.raid.amounts, tempMax = self:CalcDPSPart(self.fight.playerdps, "playerdps")
			if (not self.playerDPSMax or tempMax > self.playerDPSMax) then
				self.playerDPSMax = tempMax
			end
			self.dmg.raid.max = self.playerDPSMax

			if (not self.dmg.raid.amounts) then
				self.dmg.raid = del(self.dmg.raid)
			end

		elseif (self.showDPS and (self.fight.dps or self.fight.dpsp or self.fight.dpsm)) then
			self.playerDPSMax = nil
			if (self.fight.dps) then
				self.dmg.raid = new()
				self.dmg.raid.amounts, self.dmg.raid.max = self:CalcDPSPart(self.fight.dps, "dps")

				if (not self.dmg.raid.amounts) then
					self.dmg.raid = del(self.dmg.raid)
				end
			else
				if (self.fight.dpsp) then
					self.dmg.raidp = new()
					self.dmg.raidp.amounts, self.dmg.raidp.max = self:CalcDPSPart(self.fight.dpsp, "dpsp")

					if (not self.dmg.raidp.amounts) then
						self.dmg.raidp = del(self.dmg.raidp)
					end
				end
				if (self.fight.dpsm) then
					self.dmg.raidm = new()
					self.dmg.raidm.amounts, self.dmg.raidm.max = self:CalcDPSPart(self.fight.dpsm, "dpsm")

					if (not self.dmg.raidm.amounts) then
						self.dmg.raidm = del(self.dmg.raidm)
					end
				end
			end
		end

		if (self.fight.bossdps and self.showDPSBoss) then
			self.dmg.boss = new()
			self.dmg.boss.amounts, self.dmg.boss.max = self:CalcDPSPart(self.fight.bossdps, "bossdps")
			if (not self.dmg.boss.amounts) then
				self.dmg.boss = del(self.dmg.boss)
			end
		end

		if (not next(self.dmg)) then
			self.dmg = deepDel(self.dmg)
		end
	end

	-- dps.ExtractForPlayers
	local function dpsExtractForPlayers(self, playerData)
		local amounts = new()
		local playerCount, maxDamage = 0, 0

		for j,name in ipairs(self.playerSelection) do
			local playerID
			for id,playerInfo in pairs(self.fight.players) do
				local playerName, playerClass = strsplit(":", playerInfo)
				if (playerName == name) then
					playerID = id
					break
				end
			end

			local data = playerData[playerID]
			if (data) then
				playerCount = playerCount + 1
				local temp = new(strsplit(",", data))

				local offset, zero, leading = 0, 0, true
				for i,dmg in ipairs(temp) do
					local amount = tonumber(dmg)
					if (i == 1 and amount < 0) then
						-- Any leading zeros in the dps data are replaced with
						-- a negative of how many empty seconds there are
						offset = -dmg - 1
						for j = 1,offset+1 do
							if (not amounts[j]) then
								amounts[j] = 0
							end
						end
					else
						if (amount > 0) then
							leading = nil
						elseif (leading) then
							zero = zero + 1
						end
						amounts[i + offset] = (amounts[i + offset] or 0) + amount
						maxDamage = max(maxDamage, amounts[i + offset])
					end
				end

				-- TODO: Remove this in a month or two
				if (zero > 1 and tonumber(temp[1]) >= 0) then
					-- Compress old DPS data with leading zeros
					for k,dmg in ipairs(temp) do
						temp[k] = tonumber(dmg)
					end
					local newstr = MakeDPSString(temp)
					playerData[playerID] = newstr
				end

				del(temp)
			end
		end

		return amounts, maxDamage, playerCount
	end

	-- dps.CalcDPSPart
	local function dpsCalcDPSPart(self, dps, what, otherdps)
		if (not dps) then
			return
		end

		local amounts = new()
		local maxDamage = 0
		local area = self:GetParent().area
		local pdps = self.playerSelection and what == "playerdps"

		for mobKey,data in pairs(dps) do
			if (area.mobKeys[mobKey]) then
				local temp, tempMax
				if (pdps) then
					assert(type(data) == "table")
					temp, tempMax = self:ExtractForPlayers(data)
				else
					assert(type(data) == "string")
					temp = new(strsplit(",", data))
				end

				if (pdps and not next(amounts)) then
					del(amounts)
					amounts = temp
					maxDamage = tempMax
				else
					local offset, zero, leading = 0, 0, true
					for i,dmg in ipairs(temp) do
						local amount = tonumber(dmg)
						if (i == 1 and amount < 0) then
							-- Any leading zeros in the dps data are replaced with
							-- a negative of how many empty seconds there are
							offset = -dmg - 1
							for j = 1,offset+1 do
								if (not amounts[j]) then
									amounts[j] = 0
								end
							end
						else
							if (amount > 0) then
								leading = nil
								maxDamage = max(maxDamage, amount)
							elseif (leading) then
								zero = zero + 1
							end
							amounts[i + offset] = max(amounts[i + offset] or 0, amount)
						end
					end

					if (not pdps) then
						-- TODO: Remove this in a month or two
						if (zero > 1 and tonumber(temp[1]) >= 0) then
							-- Compress old DPS data with leading zeros
							for i,dmg in ipairs(temp) do
								temp[i] = tonumber(dmg)
							end
							local newstr = MakeDPSString(temp)
							dps[mobKey] = newstr
						end
					end

					del(temp)
				end
			end
		end

		if (db.smoothDPS > 0) then
			for k = 1,db.smoothDPS do
				-- Smooth into a new table so we're not using averaged neighboring values each trip around
				local smoothed = new()
				for i = 1,#amounts do
					local average, count = 0, 0
					for j = i - 1, i + 1 do
						local val = amounts[j]
						if (val) then
							count = count + 1
							average = average + val
						end
					end
					smoothed[i] = average / count
				end
				del(amounts)
				amounts = smoothed
			end

			local smoothedMax = 0
			for i,amount in ipairs(amounts) do
				smoothedMax = max(smoothedMax, amount)
			end

			maxDamage = (maxDamage + smoothedMax) / 2
		end

		return amounts, maxDamage
	end

	-- dps.OnMouseWheel
	local function dpsOnMouseWheel(self, delta)
		local area = self:GetParent().area
		area.rightScroll:OnMouseWheel(delta)
	end

	-- dps.OnMouseDown
	local function dpsOnMouseDown(self)
		self.downX, self.downY = GetCursorPosition()
		self.downTime = GetTime()
		local area = self:GetParent().area
		area.rightScroll:OnMouseDown()
	end

	-- dps.OnMouseUp
	local function dpsOnMouseUp(self)
		local area = self:GetParent().area
		area.rightScroll:OnMouseUp()

		if (self.downX) then
			local x, y = GetCursorPosition()
			if (abs(x - self.downX) <= 1 and abs(y - self.downY) < 1) then
				if (GetTime() - self.downTime < 0.5) then
					self:OnClick()
				end
			end
			self.downX, self.downY, self.downTime = nil, nil, nil
		end
	end

	-- dps.OnClick
	local function dpsOnClick(self)
		self:TogglePlayerSelection()
	end

	-- dps.TogglePlayerSelection
	local function dpsTogglePlayerSelection(self)
		if (self.fight.playerdps) then
			if (not module.playersel) then
				module:CreatePlayerSelection()
			end

			if (not module.playersel:IsShown()) then
				module.playersel:SetOwner(self)
				module.playersel:Show()
			else
				module.playersel:Hide()
			end
		end
	end

	-- dps.OnPlayerSelectionChanged
	local function dpsOnPlayerSelectionChanged(self, ...)
		self.playerSelection = del(self.playerSelection)
		if (...) then
			self.playerSelection = new(...)
			if (not self.showDPS) then
				self.showDPS = true
				self.raidDPSCheckBox:SetChecked(true)
			end
		end

		self:CalcDPS()
		self:DrawDPS()
		self:ShowPlayerSelection()
	end

	-- ShowPlayerSelection
	local function dpsShowPlayerSelection(self)
		local f = self.selectionOverlay
		if (self.playerSelection) then
			if (not f) then
				f = CreateFrame("Frame", nil, self)
				self.selectionOverlay = f
				f:SetFrameLevel(self:GetFrameLevel() + 2)
				f:SetPoint("BOTTOMRIGHT", 20, 0)
				f:SetPoint("TOPLEFT", self.scroll, "TOPLEFT")

				f.text = f:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
				f.text:SetAllPoints()
				f.text:SetJustifyH("LEFT")
				f.text:SetJustifyV("TOP")
			else
				f:Show()
			end

			local items = module:SortNamesByClass(self.fight, self.playerSelection)
			local temp = new()
			for i,t in ipairs(items) do
				tinsert(temp, t[1])
			end
			f.text:SetText(table.concat(temp, ", "))
			del(temp)
			del(items)

		elseif (f) then
			f:Hide()
		end
	end

	-- dps.OnEnter
	local function dpsOnEnter(self)
		local area = self:GetParent().area
		area.rightScroll:OnEnter()
	end

	-- dps.OnLeave
	local function dpsOnLeave(self)
		local area = self:GetParent().area
		area.rightScroll:OnLeave()
		self:ShowDPSForCursorTime()
	end

	-- dps.GetSmoothValue
	local function dpsGetSmoothValue(self)
		return db.smoothDPS
	end

	-- dps.OnSmoothChanged
	local function dpsOnSmoothChanged(self, value)
		db.smoothDPS = value
		Utopia.callbacks:Fire("Utopia_SetSmoothing", value)
	end

	-- dps.ShowDPSForCursorTime
	local function dpsShowDPSForCursorTime(self, cursorTime)
		self.number1:Hide()
		self.number2:Hide()

		local frame = self:GetParent()
		if (self.showDPS or self.showDPSBoss) then
			local dmg = self.dmg
			if (dmg and cursorTime) then
				local index = floor(cursorTime) + 1
				local raidDmg
				if (dmg.raid) then
					raidDmg = dmg.raid and dmg.raid.amounts and dmg.raid.amounts[index]
				elseif (dmg.raidp or dmg.raidm) then
					if (not db.dpsMode or db.dpsMode == "pm" or db.dpsMode == "mp") then
						raidDmg = (dmg.raidp.amounts[index] or 0) + (dmg.raidm.amounts[index] or 0)
					elseif (strfind(db.dpsMode, "p")) then
						raidDmg = dmg.raidp.amounts[index] or 0
					elseif (strfind(db.dpsMode, "m")) then
						raidDmg = dmg.raidm.amounts[index] or 0
					end
				end
				local bossDmg = dmg.boss and dmg.boss.amounts and dmg.boss.amounts[index]

				if (frame.showDPS and raidDmg) then
					self.number1:SetFormattedNumber(raidDmg)
					self.number1:Show()
				end
				if (self.showDPSBoss and bossDmg) then
					self.number2:SetFormattedNumber(bossDmg)
					self.number2:Show()
				end
			end
		end
	end

	local modeList = {"c", "p", "m", "pm", "mp"}
	local modeDesc = {c = L["Combined"], p = L["Physical"], m = L["Magical"]}
	local colours = {c = "|cFF808080", p = "|cFF40BF40", m = "|cFF4040BF"}
	local coloursActive = {c = "|cFFF0F0F0", p = "|cFF80FF80", m = "|cFF8080FF"}
	local function dpsSetShowDPSColour(self)
		if (db.dpsMode and (self.fight.dpsp or self.fight.dpsm)) then
			if (db.dpsMode == "p") then
				self.raidDPSCheckBox.texCheckBoxCheck:SetVertexColor(0, 1, 0)
			elseif (db.dpsMode == "m") then
				self.raidDPSCheckBox.texCheckBoxCheck:SetVertexColor(0, 0.5, 1)
			elseif (db.dpsMode == "pm") then
				self.raidDPSCheckBox.texCheckBoxCheck:SetVertexColor(0, 1, 1)
			elseif (db.dpsMode == "mp") then
				self.raidDPSCheckBox.texCheckBoxCheck:SetVertexColor(1, 0, 1)
			end
		else
			self.raidDPSCheckBox.texCheckBoxCheck:SetVertexColor(1, 1, 1)
		end
		local mode = self.showDPS and (db.dpsMode == nil and "c" or db.dpsMode) or nil
		if (self.fight.dpsp or self.fight.dpsm) then
			local str = ""
			for i = 1,5 do
				local active = mode == modeList[i]
				local mode1 = modeList[i]:sub(1, 1)
				local c1 = (active and coloursActive or colours)[mode1]
				local desc = c1 .. modeDesc[mode1] .. "|r"

				if (#modeList[i] > 1) then
					local mode2 = modeList[i]:sub(-1)
					local c2 = (active and coloursActive or colours)[mode2]
					desc = desc .. (active and "|cFFFFFF80" or "") .. L[" stacked with "] .. c2 .. modeDesc[mode2] .. "|r"
				end
				if (active) then
					desc = "|cFFFFFFFF[|r".. desc .."|cFFFFFFFF]|r"
				end

				str = str .. (str == "" and "" or ", ") .. desc
			end

			self.raidDPSCheckBox:SetTooltipText(L["Cycle through DPS modes for this fight."] .. " " .. str)
		else
			self.raidDPSCheckBox.tooltip = nil
		end
	end

	-- dps.raidDPSCheckBox.getShowDPS
	local function getShowDPS(self)
		self.raidDPSCheckBox:SetEnabled(self.fight.dps or self.fight.dpsp or self.fight.dpsm)
		self:SetShowDPSColour(self)
		return (self.fight.dps or self.fight.dpsp or self.fight.dpsm) and self.showDPS
	end

	-- dps.raidDPSCheckBox.setShowDPS
	local function setShowDPS(self, newval)
		if (self.fight.dpsp or self.fight.dpsm) then
			if (self.showDPS) then
				if (not db.dpsMode) then
					db.dpsMode = self.fight.dpsp and "p" or "m"
				elseif (db.dpsMode == "p") then
					db.dpsMode = "m"
				elseif (db.dpsMode == "m") then
					db.dpsMode = "pm"
				elseif (db.dpsMode == "pm") then
					db.dpsMode = "mp"
				else
					db.dpsMode = nil
					self.showDPS = nil
				end
			else
				self.showDPS = true
				db.dpsMode = nil
			end
		else
			self.showDPS = newval
		end
		Utopia.callbacks:Fire("Utopia_SetDPSMode", self.showDPS)
	end

	-- dps.bossDPSCheckBox.getShowDPSBoss
	local function getShowDPSBoss(self)
		self.bossDPSCheckBox:SetEnabled(self.fight.bossdps)
		return self.fight.bossdps and self.showDPSBoss
	end

	-- dps.bossDPSCheckBox.setShowDPSBoss
	local function setShowDPSBoss(self, newval)
		self.showDPSBoss = newval
		self:CalcDPS()
		self:DrawDPS()
	end

	-- CreateDPSFrame
	function module:CreateDPSFrame(parent)
		local dps = CreateFrame("Frame", nil, parent)
		dps:Hide()

		dps:EnableMouse(true)
		dps:EnableMouseWheel(true)
		dps:SetScript("OnMouseDown", dpsOnMouseDown)
		dps:SetScript("OnMouseUp", dpsOnMouseUp)
		dps:SetScript("OnEnter", dpsOnEnter)
		dps:SetScript("OnLeave", dpsOnLeave)
		dps:SetScript("OnMouseWheel", dpsOnMouseWheel)
		dps:SetScript("OnShow", dpsOnShow)
		dps:SetScript("OnHide", dpsOnHide)

		dps.smoothSlider = lzf:Slider(dps, dps, "Smooth DPS", dpsGetSmoothValue, dpsOnSmoothChanged, 0, 10, 1, "BOTTOMLEFT", 10, 15)
		dps.smoothSlider.tooltip = L["DPS Smoothing will average out the dmg over the given number of seconds to provide a more useful visual representation of the damage output"]

		dps.raidDPSCheckBox = lzf:CheckBox(dps, dps, L["Raid DPS: "], getShowDPS, setShowDPS, "TOPLEFT", -2, 3)
		dps.bossDPSCheckBox = lzf:CheckBox(dps, dps, L["Enemy DPS: "], getShowDPSBoss, setShowDPSBoss, "TOPLEFT", dps.raidDPSCheckBox, "BOTTOMLEFT", 0, 5)

		dps.number1 = dps:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
		dps.number1.SetFormattedNumber = Utopia.SetFormattedNumber
		dps.number1:SetPoint("LEFT", dps.raidDPSCheckBox.text, "RIGHT")
		dps.number1:Hide()

		dps.number2 = dps:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
		dps.number2.SetFormattedNumber = Utopia.SetFormattedNumber
		dps.number2:SetPoint("LEFT", dps.bossDPSCheckBox.text, "RIGHT")
		dps.number2:Hide()

		local scrollName = lzf:GenericSuffixName(parent, "ScrollFrame")
		local scroll = CreateFrame("ScrollFrame", scrollName, dps)
		dps.scroll = scroll
		dps.height = 100
		dps.showDPS = true
		dps.showDPSBoss = nil

		local scrollChild = CreateFrame("Frame", nil, scroll)
		dps.scrollChild = scrollChild
		scroll:SetScrollChild(scrollChild)

		scrollChild:SetWidth(400)
		scrollChild:SetHeight(dps.height - 1)

		local offset = parent.area.rightScroll:GetLeft() - parent.area.leftScroll:GetLeft()

		scroll:SetPoint("TOPLEFT", offset, 0)
		scroll:SetPoint("BOTTOMRIGHT")

	    dps.SetFight		= dpsSetFight
	    dps.OnHide			= dpsOnHide
	    dps.OnShow			= dpsOnShow
	    dps.Cleanup			= dpsCleanup
	    dps.DrawDPS			= dpsDrawDPS
	    dps.DrawDPSPart		= dpsDrawDPSPart
	    dps.CalcDPS			= dpsCalcDPS
	    dps.CalcDPSPart		= dpsCalcDPSPart
	    dps.ExtractForPlayers = dpsExtractForPlayers
		dps.CreateDPSBlock	= dpsCreateDPSBlock
		dps.AquireDPSBlock	= dpsAquireDPSBlock
		dps.ReleaseDPSBlock	= dpsReleaseDPSBlock
		dps.ShowDPSForCursorTime = dpsShowDPSForCursorTime
		dps.OnClick			= dpsOnClick
		dps.TogglePlayerSelection = dpsTogglePlayerSelection
		dps.OnPlayerSelectionChanged = dpsOnPlayerSelectionChanged
		dps.ShowPlayerSelection = dpsShowPlayerSelection
		dps.SetShowDPSColour = dpsSetShowDPSColour

		return dps
	end
end

do
	-- plist.OnShow
	local function plistOnShow(self)
		--self.fadeOut:Stop()
		self:SetAlpha(1)
		self:ClearAllPoints()
		local x, y = GetCursorPosition()
		x, y = x / self:GetEffectiveScale(), y / self:GetEffectiveScale()
		self:SetPoint("LEFT", UIParent, "BOTTOMLEFT", x - 10, y)
	end

	-- plist.OnHide
	local function plistOnHide(self)
		--self.fadeOut:Stop()
		self:SetAlpha(1)
		self:SetParent(UIParent)
		self.fade, self.fight = nil, nil
	end

	-- plist.SetOwner
	local function plistSetOwner(self, owner)
		self:SetParent(owner)
		self:SetFrameLevel(self:GetParent():GetFrameLevel() + 5)
		self.fight = owner.fight
		self:Show()
		self:PopulatePlayers()
		self:SelectPlayers()
	end

	-- plist.IsOwned
	local function plistIsOwned(self, who)
		return self:IsShown() and self:GetParent() == who
	end

	-- plist.PopulatePlayers
	local function plistPopulatePlayers(self)
		if (not self.fight) then
			return
		end

		local items = module:SortNamesByClass(self.fight)
		self.list:SetItems(items)
	end

	-- plistSelectPlayers
	local function plistSelectPlayers(self)
		local p = self:GetParent()
		if (not p or not p.fight) then
			return
		end

		if (p.playerSelection) then
			self.list:Select(unpack(p.playerSelection))
		end
	end

	-- plist.list.OnSelectMultiple
	local function plistOnSelectMultiple(self, ...)
		local p = self:GetParent()
		if (not p or not p.fight) then
			return
		end
		p:GetParent():OnPlayerSelectionChanged(...)
	end

	-- plist.OnUpdate
	local function plistOnUpdate(self, elapsed)
		-- Well, all this fading work cos the animation system is b0rked
		if (self:IsMouseOver() or self.dragging) then
			self.fade = nil
			self:SetAlpha(1)
		else
			if (not self.fade) then
				self.fade = 2
			end
			self.fade = self.fade - elapsed * 2
			if (self.fade <= 0) then
				self:Hide()
			else
				self:SetAlpha(min(1, self.fade))
			end
		end
	end

	-- dps.CreatePlayerSelection
	function module:CreatePlayerSelection()
		local frame = CreateFrame("Frame", nil, UIParent)
		frame:Hide()
		self.playersel = frame
		frame:SetHeight(266)
		frame:SetWidth(140)
		frame:EnableMouse(true)
		frame:EnableMouseWheel(true)
		lzf:ApplyBorder(frame, "dialog")

		frame:SetScript("OnHide", plistOnHide)
		frame:SetScript("OnShow", plistOnShow)
		frame:SetScript("OnUpdate", plistOnUpdate)

		frame.list = lzf:CreateListFrame(frame, true, true)
		frame.list:SetPoint("TOPLEFT", 7, -7)
		frame.list:SetHeight(256)			-- Setting size rather than anchor so that the scrollbar can adjust
		frame.list:SetWidth(126)
		frame.list.OnSelectMultiple = plistOnSelectMultiple

		frame.PopulatePlayers		= plistPopulatePlayers
		frame.SelectPlayers			= plistSelectPlayers
		frame.SetOwner				= plistSetOwner
		frame.IsOwned				= plistIsOwned

--[[	-- !!!!!!!!!!!!! This is crashing WoW.exe... so we'll not do this. Instead we have an OnUpdate.. -.-
		frame.fadeOut = frame:CreateAnimationGroup()
		local a = frame.fadeOut:CreateAnimation("Alpha")
		fadeOut.alpha = a
		a:SetDuration(0.5)
		a:SetChange(-1)
		a:SetStartDelay(0.5)
		a:SetScript("OnFinished", function(self) self:GetRegionParent():Hide() end)	-- <<<<<<<< This line actually
]]
		self.CreatePlayerSelection = nil
	end
end

-- tfind
local function tfind(t, f)
	for k,v in pairs(t) do
		if (v == f) then
			return k
		end
	end
end

-- SortNamesByClass
function module:SortNamesByClass(fight, names)
	local list = new()
	for id,info in pairs(fight.players) do
		local name, class = strsplit(":", info)
		if (not names or tfind(names, name)) then
			if (class) then
				class = classOrder[tonumber(class)]
			else
				class = "|"
			end
			if (not list[class]) then
				list[class] = new()
			end
			tinsert(list[class], name)
		end
	end

	local temp = new()
	for i,class in ipairs(classOrder) do
		local list = list[class]
		if (list) then
			sort(list)
			for j,name in ipairs(list) do
				display = format("%s%s|r", ClassColour(class), name)
				tinsert(temp, new(display, name))
			end
		end
	end
	if (list["|"]) then
		for j,name in ipairs(list["|"]) do
			tinsert(temp, new(name, name))
		end
	end
	del(list)
	return temp
end


do
	local list = {}
	local listNames = {}

	-- AquireAreaTexture
	function module:AquireAreaTexture(frame, names)
		local tex
		if (names) then
			tex = tremove(listNames) or tremove(list) or self:CreateAreaTexture(frame)
		else
			tex = tremove(list) or tremove(listNames) or self:CreateAreaTexture(frame)
		end
		tex:SetParent(frame)
		if (tex.ownerText) then
			tex.ownerText:SetParent(frame)
		end
		tex:SetHeight(20)
		tex:Show()
		return tex
	end

	-- ReleaseAreaTexture
	function module:ReleaseAreaTexture(tex)
		tex:ClearAllPoints()
		tex:Hide()
		tex:SetParent(UIParent)
		tex.spellId		= nil
		tex.realSpellId	= nil
		tex.sourceName	= nil
		tex.timeStart	= nil
		tex.timeEnd		= nil
		tex.mobKey		= nil
		tex.mobName		= nil
		tex.improved	= nil
		tex.sources		= del(tex.sources)

		if (tex.ownerText) then
			tex.ownerText:Hide()
			tinsert(listNames, tex)
		else
			tinsert(list, tex)
		end
	end

	-- SetOwnerText
	local function setOwnerText(self, name, r, g, b)
		-- For some reason this will bump the position of the textures over a little
		-- Tried the alternatively anchoring the text blocks to the ScrollChild instead of the parent texture
		-- shown in the commented-out code with exact same results

		if (not self.ownerText) then
			self.ownerText = self:GetParent():CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			--self.ownerText:SetHeight(20)
			self.ownerText:SetPoint("LEFT", self, "LEFT")
		else
			self.ownerText:Show()
		end
		self.ownerText:SetHeight(self:GetHeight())
		self.ownerText:SetText(name)
		self.ownerText:SetTextColor(r or 0, g or 0, b or 0)
		self.ownerText:SetJustifyV("TOP")

		--local point, _, rel, x, y = self:GetPoint(1)
		--self.ownerText:SetPoint(point, self:GetParent(), rel, x, y)
	end

	-- CreateAreaTexture
	function module:CreateAreaTexture(frame)
		local tex = frame:CreateTexture(nil, "BACKGROUND")
		tex:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
		tex:SetVertexColor(0, 0.8, 0)
		tex.SetOwnerText = setOwnerText
		return tex
	end
end

-- DescribeDate
function module:DescribeDate(describe)
	local DAY = 24*60*60
	local today = date("%x")
	local yesterday = date("%x", time() - DAY)
	local week = time() - 6 * DAY
	local when = date("%x", describe)
	local startOfMonth = time() - (tonumber(date("%d",time()))-1) * DAY
	local age
	if (when == today) then
		when = L["Today"]
		age = 1
	elseif (when == yesterday) then
		when = L["Yesterday"]
		age = 2
	elseif (describe > week) then
		when = date("%A", describe)
		age = 3
	else
		local day = tonumber(date("%d", describe))			-- Want to change 01 to 1
		if (GetLocale() == "enGB" or GetLocale() == "enUS") then
			local bit = day % 10
			day = day..(day >= 11 and day <= 13 and "th" or (bit == 1 and "st" or bit == 2 and "nd" or bit == 3 and "rd" or "th"))
		elseif (GetLocale() == "deDE") then
			day = day.."."
		end

		if (describe < startOfMonth) then
			when = format("%s %s", day, date("%B", describe))
			age = 5
		else
			when = format("%s %s", date("%A", describe), day)
			age = 4
		end
	end

	return when, age
end

do
	StaticPopupDialogs["UTOPIA_SENDINPUT"] = {
		text = L["Send the selected fights to:"],
		button1 = ACCEPT,
		button2 = CANCEL,
		hasEditBox = 1,
		maxLetters = 24,
		OnAccept = function(self)
			local text = self.editBox:GetText()
			UtopiaUpTimeList:OnConfirmSendFights(text)
		end,
		EditBoxOnEnterPressed = function(self)
			local text = self:GetParent().editBox:GetText()
			UtopiaUpTimeList:OnConfirmSendFights(text)
			self:GetParent():Hide()
		end,
		OnShow = function(self)
			self.editBox:SetFocus()
		end,
		OnHide = function(self)
			local activeWindow = ChatEdit_GetActiveWindow()
			if activeWindow then
				activeWindow:SetFocus()
			end
			self.editBox:SetText("")
		end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	}

	-- mainlist.OnFightAdded
	local function frameOnFightAdded(self, index)
		local sel1 = self.list:GetSelected()
		self:Populate()
		self.list:Click(self.list:KeyExists(sel1) and sel1 or 1)
	end

	-- mainlist.OnShow
	local function mainlistOnShow(self)
		self:Populate()
		self.list:Click(1)
		Utopia.RegisterCallback(self, "Utopia_FightAdded", frameOnFightAdded, self)
	end

	-- mainlist.OnHide
	local function mainlistOnHide(self)
		self.list:Clear()
		self.list2:Clear()
		Utopia.UnregisterCallback(self, "Utopia_FightAdded")
	end

	-- mainlist.ShowStats
	local function mainlistShowStats(self)
		self.stats:SetFormattedText(L["History Size: %d"], db.history and #db.history or 0)
	end

	-- mainlist.ShowOptions
	local function mainlistShowOptions(self)
		local sel = self.list2:GetSelected()
		if (sel) then
			self.open:Enable()
			self.send:Enable()
		else
			self.open:Disable()
			self.send:Disable()
		end
	end

	-- mainlist.ViewFights
	local function mainlistViewFights(self)
		local sel = new(self.list2:GetSelected())
		local count = 1
		for i,key in ipairs(sel) do
			module:OpenView(key, count)
			count = count + 1
		end
		del(sel)
	end

	-- mainlist.DeleteFights
	local function mainlistDeleteFights(self)
		local sel1 = self.list:GetSelected()
		local delete = new(self.list2:GetSelected())

		if (next(delete)) then
			sort(delete)
			for i = #delete,1,-1 do
				Utopia.callbacks:Fire("Utopia_DeleteFight", delete[i])
				deepDel(tremove(db.history, delete[i]))
			end
		else
			for i = #db.history,1,-1 do
				local info = db.history[i]
				local when, age, key
				if (info.received) then
					key = format(L["Received from %s"], info.receivedFrom)
				else
					when, age = module:DescribeDate(info.combatStart)
					key = format("%s: %s", info.player, when)
				end

				if (sel1 == key) then
					Utopia.callbacks:Fire("Utopia_DeleteFight", i)
					deepDel(tremove(db.history, i))
				end
			end
		end
		del(delete)

		self:Populate()
		self.list:Click(self.list:KeyExists(sel1) and sel1 or 1)
	end

	-- SendFights
	local function mainlistSendFights(self)
		StaticPopup_Show("UTOPIA_SENDINPUT")
	end

	-- mainlistOnConfirmSendFights
	local function mainlistOnConfirmSendFights(self, name)
		if (name and name ~= "" and #name > 1) then
			local user = Utopia.users and Utopia.users[name]
			if (user and type(user) == "number" and user < 102) then
				self:Print(L["%s has too old a version of Utopia to receive fight information"], name)
			else
				module:QueueSendFights(name, self.list2:GetSelected())
			end
		end
	end

	-- mainlist.OnScaleChanged
	local function mainlistOnScaleChanged(self, newScale)
		if (not db.scale) then
			db.scale = {}
		end
		db.scale.main = newScale
	end

	-- list.OnClick
	local function mainlistOnClick(self, key)
		local parent = self:GetParent()
		parent:Populate2(key)
	end

	-- list2.OnClick
	local function mainlistOnClick2(self, key)
		local parent = self:GetParent()
		parent:ShowOptions()
	end

	-- list2.OnDoubleClick
	local function mainlistOnDoubleClick2(self, key)
		module:OpenView(key)
	end

	local ageColours = {"|cFF90FF90", "|cFFFFFF80", "|cFFFFA020", "|cFFFF4040", "|cFFB00000"}

	-- Populate
	local function mainlistPopulate(self)
		if (db.history) then
			local temp = new()
			local listItems = new()

			for i = #db.history,1,-1 do
				local info = db.history[i]
				local when, age, colour, key
				if (info.received) then
					key = format(L["Received from %s"], info.receivedFrom)
				else
					when, age = module:DescribeDate(info.combatStart)
					colour = ageColours[age]
					key = format("%s: %s", info.player, when)
				end

				if (not temp[key]) then
					temp[key] = true
					if (info.received) then
						tinsert(listItems, 1, new(format(L["Received from %s"], module:ColourPlayerFromFight(info, info.player)), key))
					else
						tinsert(listItems, new(format("%s: %s%s", module:ColourPlayerFromFight(info, info.player), colour, when), key))
					end
				end
			end
			del(temp)

			self.list:SetItems(listItems)
		end
		self:ShowOptions()
		self:ShowStats()
	end

	-- Populate2
	local function mainlistPopulate2(self, key)
		if (not db.history) then
			return
		end

		local listItems = new()
		self.key = key or self.key

		for i = #db.history,1,-1 do
			local info = db.history[i]
			local when = module:DescribeDate(info.combatStart)
			local display

			if (info.received) then
				display = format(L["Received from %s"], info.receivedFrom)
			else
				display = format("%s: %s", info.player, when)
			end
			if (display == self.key) then
				-- Pick an appropriate mob name to display
				local mobname = module:FightName(info)

				local dur = info.combatEnd - info.combatStart
				if (dur > 60) then
					dur = format(L["%.1f mins"], dur / 60)
				else
					dur = format(L["%d secs"], dur)
				end

				-- Fix logs for 3.2
				-- TODO: Remove this in a month
				if (not info.difficultyRaid) then
					if (info.combatStart >= 1249426800) then		-- 5th August 2009 00:00
						local count = 0
						for id,name in pairs(info.players) do
							count = count + 1
						end
						if (count > 25) then
							if (info.difficulty == 2) then
								info.difficultyRaid = 4
							else
								info.difficultyRaid = 2
							end
							info.difficulty = nil

						elseif (count > 5) then
							if (info.difficulty == 2) then
								info.difficultyRaid = 3
							else
								info.difficultyRaid = 1
							end
							info.difficulty = nil
						end						
					end
				end

				local diff = info.difficultyRaid and _G["RAID_DIFFICULTY"..info.difficultyRaid]
				if (not diff) then
					if (info.difficulty and info.combatStart < 1249426800) then
						diff = info.difficulty == 1 and L["Heroic"]
					else
						diff = info.difficulty and info.difficulty > 1 and _G["DUNGEON_DIFFICULTY"..info.difficulty]
					end
				end
				if (diff) then
					tinsert(listItems, new(format("%s - %s - %s |cFFFF8080%s", date("%H:%M", info.combatStart), dur, mobname or "", diff), i))
				else
					tinsert(listItems, new(format("%s - %s - %s", date("%H:%M", info.combatStart), dur, mobname or ""), i))
				end
			end
		end

		self.list2:SetItems(listItems)
		self:ShowOptions()
	end

	-- CreateMainList
	function module:CreateMainList()
		local frame = CreateFrame("Frame", "UtopiaUpTimeList", UIParent)
		self.mainlist = frame
		frame:Hide()
		frame:SetWidth(512)
		frame:SetHeight(512)
		frame:SetScale(db.scale and db.scale.main or 0.8)

		lzf:ApplyBackground(frame, "Interface\\AddOns\\Utopia\\Textures\\UtopiaCornerIcon")
		lzf:MovableFrame(frame)
		frame.OnPositionChanged = function(self) Utopia:SavePosition(self) end
		Utopia:RestorePosition(frame)

		frame:SetScript("OnHide", mainlistOnHide)
		frame:SetScript("OnShow", mainlistOnShow)

		frame.title:SetFormattedText(L["%s Fight Listing"], Utopia.label)

		frame.list = lzf:CreateListFrame(frame, true)
		frame.list:SetPoint("TOPLEFT", 24, -82)
		frame.list:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 200, 42)
		frame.list.OnClick = mainlistOnClick

		frame.bar = lzf:CreateVerticalBar(frame.list, "RIGHT")

		frame.list2 = lzf:CreateListFrame(frame, true, true)
		frame.list2:SetPoint("TOPLEFT", frame.list.verticalBar, "TOPRIGHT", 0, 0)
		frame.list2:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -40, 42)
		frame.list2.OnClick = mainlistOnClick2
		frame.list2.OnDoubleClick = mainlistOnDoubleClick2
		frame.list2.OnSelectMultiple = mainlistOnClick2

		frame.Populate = mainlistPopulate
		frame.Populate2 = mainlistPopulate2
		frame.ShowOptions = mainlistShowOptions
		frame.ShowStats = mainlistShowStats
		frame.OnConfirmSendFights = mainlistOnConfirmSendFights
		frame.OnScaleChanged = mainlistOnScaleChanged

		frame.delete = lzf:Button(frame.statusbar, frame, DELETE, mainlistDeleteFights, "TOPLEFT")
		frame.send = lzf:Button(frame.statusbar, frame, L["Send"], mainlistSendFights, "TOP")
		frame.open = lzf:Button(frame.statusbar, frame, L["Open"], mainlistViewFights, "TOPRIGHT")

		frame.stats = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		frame.stats:SetPoint("TOPLEFT", 70, -25)
		frame.stats:SetPoint("BOTTOMRIGHT", frame.list2, "TOPRIGHT", 20, 5)
		frame.stats:SetJustifyH("RIGHT")

		return frame
	end
end

-- GetMobNameFromHyperlink
local function GetMobNameFromHyperlink(id)
	local ret
	GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	GameTooltip:SetHyperlink(format("unit:0xF530%06X000000", id))
	if (GameTooltip:IsShown()) then
		ret = GameTooltipTextLeft1:GetText()
	end
	GameTooltip:Hide()
	return ret
end

-- FightName
function module:FightName(fight)
	local mobname
	--if (fight.boss) then
	--	mobname = fight.boss
	--else
		local _
		_, mobname = next(fight.mobs)
		for j,name in pairs(fight.mobs) do
			local bossEventID = bossEventGUIDLookup[j]
			if (bossEventID) then
				if (type(bossEventID) == "string") then
					mobname = bossEventID
					break
				else
					if (unavailableBossNames[bossEventID]) then
						local name = GetMobNameFromHyperlink(bossEventID)
						if (name) then
							mobname = name
						else
							mobname = unavailableBossNames[bossEventID]
						end
						break
					elseif (fight.mobs[bossEventID]) then
						mobname = fight.mobs[bossEventID]
						break
					end
				end
			end

			if (bossid[j]) then
				mobname = name			-- But use a boss' name if there's one
				break
			end
		end
	--end
	return mobname or ""
end

-- Toggle
function module:Toggle()
	if (not self.listFrame) then
		self.listFrame = self:CreateMainList()
	end
	if (self.listFrame:IsShown()) then
		self.listFrame:Hide()
	else
		self.listFrame:Show()
	end
end

-- OnInitialize
function module:OnInitialize()
	local defaults = { 
		profile = {
			bossesOnly = true,
			notifications = true,
			minimumDuration = 30,
			keep = 25,
			coloursExtreme = true,
			mergeAppliers = true,
			smoothDPS = 3,
			ignoreMobIDs = {
				[32904] = "Dark Rune Commoner",				-- Thorim
				[34034] = "Swarming Guardian",				-- Auriaya
				[30643] = "Lava Blaze",						-- Obsidian Sanctum
				[32882] = "Jormungar Behemoth",				-- Start of Thorim event
				[32885] = "Captured Mercenary Soldier",		-- Start of Thorim event
				[32904] = "Dark Rune Commoner",				-- Thorim
				[32908] = "Captured Mercenary Captain",		-- Start of Thorim event
				[33168] = "Strengthened Iron Roots",		-- Freya
				[33170] = "Sun Beam",						-- Freya
				[33768] = "Rubble",							-- Kologarn
				[34004] = "Life Spark",						-- XT-002 Hard Mode
				[34034] = "Swarming Guardian",				-- Auriaya
			}
		}
	}

	-- If we're loading modular, then we'll store our DB associated with the module instead of Utopia proper
	-- Mostly, so I can easily check what the memory usage of this module's data will be like
	if (IsAddOnLoaded("Utopia_UpTime")) then
		self.db = LibStub("AceDB-3.0"):New("UtopiaUpTimeDB", defaults, "Default")
		self:MoveDataFromUtopiaDBtoLocalDB()
	else
		self.db = Utopia.db:RegisterNamespace("UpTime", defaults)
	end

	db = self.db.profile

	for id in pairs(ignoreMobIDs) do
		db.ignoreMobIDs[id] = nil
	end
	db.unavailableBossNames = nil
end

local svList = {"history", "bossesOnly", "notifications", "minimumDuration", "keep"}

-- MoveDataFromUtopiaDBtoLocalDB
function module:MoveDataFromUtopiaDBtoLocalDB()
	if (Utopia.db.sv and Utopia.db.sv.namespaces and Utopia.db.sv.namespaces.UpTime) then
		-- We moved from embeded to modular, move the settings over. (can't go the other way tho)
		local profiles = Utopia.db.sv.namespaces.UpTime.profiles
		local oldIntegratedDB = profiles and profiles.Default
		if (oldIntegratedDB and oldIntegratedDB.history and not self.db.profile.history) then
			for i,key in pairs(svList) do
				self.db.profile[key] = oldIntegratedDB[key]
				oldIntegratedDB[key] = nil
			end
		end
	end
end

-- MoveDataFromLocalDBtoUtopiaDB
function module:MoveDataFromLocalDBtoUtopiaDB()
	local ns = Utopia.db.sv.namespaces
	if (ns) then
		if (not ns.UpTime) then
			ns.UpTime = {profiles = {Default = {}}}
		end

		local newDB = ns.UpTime.profiles.Default

		for i,key in pairs(svList) do
			newDB[key] = self.db.profile[key]
			self.db.profile[key] = nil
		end
	end
end

-- OnProfileChanged
function module:OnProfileChanged(event, database, newProfileKey)
	db = database.profile
end

-- DXEStartBossEncounter
function module:DXEStartBossEncounter()
	self.activeBossEncounter = self.currentBossEncounter
end

-- DXEStopBossEncounter
function module:DXEStopBossEncounter()
	self.activeBossEncounter = nil
end

-- DXESetActiveEncounter
function module:DXESetActiveEncounter(e, ce)
	self.DXECurrentCE = ce
	self.currentBossEncounter = ce and ce.name or nil
end

--function module:BigWigs_TargetSeen(mobname, unit, module)
--	Xmodule = module
--d("BigWigs_TargetSeen(%s, %s, %s)", tostring(mobname), tostring(unit), tostring(module))
--	self.currentBossEncounter = module.name or module.bossname
--end

-- OnEnable
function module:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_LEAVING_WORLD")
	self:RawHook("SetItemRef", true)

	self:RegisterChatCommand("uptime", "Toggle")

	if (DXE) then
		DXE:RegisterCallback("StartEncounter", self.DXEStartBossEncounter, self)
		DXE:RegisterCallback("StopEncounter", self.DXEStopBossEncounter, self)
		DXE:RegisterCallback("SetActiveEncounter", self.DXESetActiveEncounter, self)
	end
	--if (BigWigs) then
	--	self:Hook(BigWigs, "BigWigs_TargetSeen", "BigWigs_TargetSeen")
	--end

	if (InCombatLockdown()) then
		self:StartFighting()
	end

	FRIEND_FLAGS = COMBATLOG_OBJECT_AFFILIATION_MINE + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_RAID
	ENEMY_FLAGS = COMBATLOG_OBJECT_REACTION_HOSTILE + COMBATLOG_OBJECT_REACTION_NEUTRAL
	EXLCUDE_FLAGS = COMBATLOG_OBJECT_TYPE_OBJECT + COMBATLOG_OBJECT_TYPE_PLAYER

	db = self.db.profile
end

-- OnDisable
function module:OnDisable()
	self.record, self.linear, self.combatStart = nil, nil, nil
end
