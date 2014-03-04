-------------------------------------------------------------------------
-- UPVALUES
-------------------------------------------------------------------------
local GetSpellInfo = GetSpellInfo
local UnitIsUnit = UnitIsUnit
local GetTime = GetTime
local UnitDebuff = UnitDebuff
local UnitName = UnitName
local UnitBuff = UnitBuff
local UnitPower = UnitPower
local UnitIsPlayer = UnitIsPlayer
local GetCurrentMapAreaID = GetCurrentMapAreaID
local SetMapToCurrentZone = SetMapToCurrentZone
local GetMapInfo = GetMapInfo
local GetCurrentMapDungeonLevel = GetCurrentMapDungeonLevel
local GetPlayerMapPosition = GetPlayerMapPosition
local SetMapByID = SetMapByID
local GetMapNameByID = GetMapNameByID
local UnitIsConnected = UnitIsConnected
local UnitExists = UnitExists
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local table = table
local string = string
local pairs = pairs
local ipairs = ipairs
local tonumber = tonumber
local type = type
local next = next
local print = print
local unpack = unpack
local select = select
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local bit = bit
local UnitGUID = UnitGUID
local GetPartyAssignment = GetPartyAssignment
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local EJ_GetSectionInfo = EJ_GetSectionInfo
local IsInInstance = IsInInstance
local GetSpellLink = GetSpellLink
local GetInstanceInfo = GetInstanceInfo
local COMBATLOG_OBJECT_TYPE_GUARDIAN = COMBATLOG_OBJECT_TYPE_GUARDIAN
local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
local COMBATLOG_OBJECT_AFFILIATION_OUTSIDER = COMBATLOG_OBJECT_AFFILIATION_OUTSIDER
local ALTERNATE_POWER_INDEX = ALTERNATE_POWER_INDEX
local GetBuildInfo = GetBuildInfo
-------------------------------------------------------------------------
-- FRAMES
-------------------------------------------------------------------------
local MAJOR, MINOR = "LibFail-MoP", tonumber("64") or 999

assert(LibStub, MAJOR.." requires LibStub")

local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end
--[===[@debug@
-- ### debug
lf = lib
--@end-debug@]===]
lib.callbacks = lib.callbacks or LibStub("CallbackHandler-1.0"):New(lib)
local callbacks = lib.callbacks

lib.frame = lib.frame or CreateFrame("Frame")
local frame = lib.frame

local LEJB = LibStub:GetLibrary("LibLocalizedEJBosses-1.0")
local LGIST = LibStub:GetLibrary("LibGroupInSpecT-1.0")

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

-------------------------------------------------------------------------
-- LOCALES
-------------------------------------------------------------------------
local L = LibStub("AceLocale-3.0"):NewLocale("LibFail-MoP", "enUS", true)

-- ### remember to remove debug events
--L["Caleb's fail"] = true
--L["Holy light lulz"] = true

-- Constraint Names
L["Damage Constraint"] = true
L["Tick Constraint"] = true
L["Time Constraint - Low"] = true
L["Time Constraint - High"] = true

-- Fail Types
L["not moving"] = true
L["moving"] = true
L["not spreading"] = true
L["spreading"] = true
L["dispelling"] = true
L["not dispelling"] = true
L["not being at the wrong place"] = true
L["not casting"] = true
L["not attacking"] = true
L["casting"] = true
L["switching"] = true

-- You can request strings to be added to the common strings in a ticket at the addons page
-- Common strings
L["Fail"] = true
L["Fails"] = true
L["%s fails at %s"] = true
L["%s fails at %s (%s)"] = true
L["'s Fails"] = true
L["'s Failers"] = true
L["'s Fail Events"] = true
L["Tanks Dont Fail"] = true
L["Overkill Only"] = true

local L = LibStub("AceLocale-3.0"):GetLocale("LibFail-MoP")

-- Fail Event Names
-- Naming scheme for fail events:
-- Fail_Zone Name_Boss Name_Ability Name
-- only add non general events to the list
-- ["Fail_Zone Name_Boss Name_Ability Name"] = { { spellId list }, FAIL_TYPE, event name or spellId or ej:sectionId, description or spellId or ej:sectionId, true if tanks do not fail, true for overkill only },
-- Some of these spellids need verification, but are probably right.
local failEvents = {
	-- ### remember to remove debug events
	--["Fail_Glob -'bal_Maat_HL"] = { { 635 }, "FAIL_TYPE_NOTCASTING", 635, L["Holy light lulz"], true },
	--["Fail_Glob -'bal_Ca 'leb_Dismiss Pet"] = { { 2641 }, "FAIL_TYPE_NOTCASTING", L["Caleb's fail"], L["Caleb's fail"] },

	["Fail_Heart of Fear_Blade Lord Ta'yak_Unseen Strike"] = { { 122994, 122949 }, "FAIL_TYPE_NOTSPREADING", 122994, 122994 },
	["Fail_Heart of Fear_Blade Lord Ta'yak_Wind Strike"] = { { 123180 }, "FAIL_TYPE_SPREADING", "ej:6347", "ej:6347" },
	["Fail_Heart of Fear_Garalon_Pheromone Trail"] = { { 123120 }, "FAIL_TYPE_MOVING", 123120, 123120, nil, false },
	["Fail_Heart of Fear_Garalon_Crush"] = { { }, nil, 122774, 122774 },
	["Fail_Heart of Fear_Amber-Shaper Un'sok_Amber Explosion"] = { { 122398, 122402 }, "FAIL_TYPE_NOTCASTING", 122398, 122398 },
	["Fail_Heart of Fear_Grand Empress Shek'zeer_Servant of the Empress"] = { { 123713 }, "FAIL_TYPE_SWITCHING", "ej:6343", "ej:6343" },
	["Fail_Heart of Fear_Imperial Vizier Zor'lok_Force and Verve"] = { { 122718 }, "FAIL_TYPE_WRONGPLACE", "ej:6427", "ej:6427", nil, false },
	["Fail_Heart of Fear_Wind Lord Mel'jarak_Wind Bomb"] = { { }, nil, 131830, 131830 },
	["Fail_Heart of Fear_Wind Lord Mel'jarak_Amber Prison"] = { { 121881, 121885 }, "FAIL_TYPE_SPREADING", 121881, 121881 },
	["Fail_Heart of Fear_Grand Empress Shek'zeer_Consuming Terror"] = { { 124849 }, "FAIL_TYPE_WRONGPLACE", 124849, 124849},

	["Fail_Mogu'shan Vaults_The Stone Guard_Amethyst Pool"] = { { 130774 }, "FAIL_TYPE_MOVING", 130774, 130774, nil, false },
	["Fail_Mogu'shan Vaults_The Stone Guard_Jasper Chains"] = { { 130395, 130404 }, "FAIL_TYPE_MOVING", 130395, 130395 },
	["Fail_Mogu'shan Vaults_Feng the Accursed_Arcane Resonance"] = { { 116417 }, "FAIL_TYPE_SPREADING", 116417, 116417 },
	["Fail_Mogu'shan Vaults_Feng the Accursed_Arcane Velocity"] = { { 116365 }, "FAIL_TYPE_MOVING", 116365, 116365, nil, false },
	["Fail_Mogu'shan Vaults_Feng the Accursed_Lightning Charge"] = { { 116374 }, "FAIL_TYPE_MOVING", 116374, 116374 },
	["Fail_Mogu'shan Vaults_Feng the Accursed_Epicenter"] = { { 116040 }, "FAIL_TYPE_MOVING", 116040, 116040, nil, false },
	["Fail_Mogu'shan Vaults_The Spirit Kings_Massive Attacks"] = { { 117920, 117921 }, "FAIL_TYPE_NOTSPREADING", 117920, 117920},
	["Fail_Mogu'shan Vaults_The Spirit Kings_Impervious Shield"] = { { }, nil, 117961, 117961},
	["Fail_Mogu'shan Vaults_The Spirit Kings_Shield of Darkness"] = { { }, nil, 117697, 117697},
	["Fail_Mogu'shan Vaults_The Spirit Kings_Pillage"] = { { 118048 }, "FAIL_TYPE_MOVING", 118048, 118048 },
	["Fail_Mogu'shan Vaults_The Spirit Kings_Undying Shadows"] = { { 117529 }, "FAIL_TYPE_MOVING", "ej:5853", "ej:5853", nil, false },
	["Fail_Mogu'shan Vaults_Elegon_Total Annihilation"] = { { 117914 }, "FAIL_TYPE_WRONGPLACE", "ej:6186", "ej:6186", true, false },

	["Fail_Terrace of Endless Spring_Protectors of the Endless_Lightning Prison"] = { { 117398 }, "FAIL_TYPE_SPREADING", 117398, 117398 },
	["Fail_Terrace of Endless Spring_Protectors of the Endless_Corrupted Essence"] = { { 117905, 118191 }, "FAIL_TYPE_WRONGPLACE", "ej:5825", "ej:5825" },
	["Fail_Terrace of Endless Spring_Protectors of the Endless_Expelled Corruption"] = { { 117955 }, "FAIL_TYPE_MOVING", 117955, 117955, nil, false },
	["Fail_Terrace of Endless Spring_Tsulong_Sunbeam"] = { { 122789 }, "FAIL_TYPE_MOVING", 122789, 122789, nil, false },
	["Fail_Terrace of Endless Spring_Tsulong_Dread Shadows"] = { { 122768 }, "FAIL_TYPE_MOVING", 122768, 122768, nil, false },
	["Fail_Terrace of Endless Spring_Sha of Fear_Eternal Darkness"] = { { 120394 }, "FAIL_TYPE_CASTING", 120394, 120394, nil, false },
	["Fail_Terrace of Endless Spring_Sha of Fear_Waterspout"] = { { 120521 }, "FAIL_TYPE_MOVING", 120521, 120521, nil, false },

	["Fail_Throne of Thunder_Jin'rokh the Breaker_Static Wound Conduction"] = { { 138375 }, "FAIL_TYPE_MOVING", 138375, 138375, nil, false },
	["Fail_Throne of Thunder_Jin'rokh the Breaker_Focused Lightning"] = { { 137374 }, "FAIL_TYPE_MOVING", 137374, 137374, nil, false }, -- up to date 10 H ptr
	["Fail_Throne of Thunder_Jin'rokh the Breaker_Lightning Fissure"] = { { 139467, 137485 }, "FAIL_TYPE_MOVING", 139467, 139467, nil, false },
	["Fail_Throne of Thunder_Jin'rokh the Breaker_Electrified Waters"] = { { 138006 }, "FAIL_TYPE_MOVING", 138006, 138006, nil, false }, -- up to date 10 H ptr
	["Fail_Throne of Thunder_Jin'rokh the Breaker_Ionization"] = { { 138733 }, "FAIL_TYPE_SPREADING", 138733, 138733, nil, false }, -- up to date 10 H ptr
	["Fail_Throne of Thunder_Jin'rokh the Breaker_Ionization Conduction"] = { { 138732 }, "FAIL_TYPE_NOTDISPELLING", 138743, 138743, nil, false }, -- up to date 10 H ptr
	["Fail_Throne of Thunder_Jin'rokh the Breaker_Lightning Diffusion"] = { { 137905 }, "FAIL_TYPE_MOVING", 137905, 137905, nil, false },
	["Fail_Throne of Thunder_Horridon_Sand Trap"] = { { 136723 }, "FAIL_TYPE_MOVING", 136723, 136723, nil, false },
	["Fail_Throne of Thunder_Horridon_Living Poison"] = { { 136646 }, "FAIL_TYPE_MOVING", 136646, 136646, nil, false },
	["Fail_Throne of Thunder_Horridon_Direhorn Spirit"] = { { }, "FAIL_TYPE_MOVING", "ej:7866", "ej:7866", nil, false },
	["Fail_Throne of Thunder_Council of Elders_Frigid Assault"] = { { 136910 }, "FAIL_TYPE_SWITCHING", 136910, 136910, nil, false },-- up to date 10 H ptr
	["Fail_Throne of Thunder_Council of Elders_Biting Cold"] = { { 136991 }, "FAIL_TYPE_SPREADING", 136991, 136991, nil, false },-- up to date 10 H ptr
	["Fail_Throne of Thunder_Council of Elders_Ensnared"] = { { 136878 }, "FAIL_TYPE_MOVING", 136878, 136878, nil, false },-- up to date 10 H ptr
	["Fail_Throne of Thunder_Council of Elders_Shadowed Soul"] = { { 137650 }, "FAIL_TYPE_CASTING", 137650, 137650, nil, false },
	["Fail_Throne of Thunder_Tortos_Crystal Shell"] = { { 134920 }, "FAIL_TYPE_CASTING", 137633, 137633, true, false },
	["Fail_Throne of Thunder_Megaera_Cinders"] = { { 139836 }, "FAIL_TYPE_MOVING", 139836, 139836, nil, false },
	["Fail_Throne of Thunder_Durumu the Forgotten_Lingering Gaze"] = { { 133793 }, "FAIL_TYPE_MOVING", 133793, 133793, nil, false },-- up to date 10 H ptr
	["Fail_Throne of Thunder_Durumu the Forgotten_Force of Will"] = { { 137663, 137219, 137220, 139949 }, "FAIL_TYPE_MOVING", 136413, 136413, nil, nil }, -- Force of Will is the knockback mechanic (no log entry), Acidic Splash is the instakill when u land
	["Fail_Throne of Thunder_Primordius_Caustic Gas"] = { { 136216 }, "FAIL_TYPE_WRONGPLACE", 136216, 136216, nil, false },-- up to date 10 H ptr
	["Fail_Throne of Thunder_Primordius_Acidic Explosion"] = { { 136220 }, "FAIL_TYPE_SPREADING", 136220, 136220, nil, false },

	-- XXX look into Acidic Explosion aka Acidic Spines -- would need fancy detection with mapdata, implement it later when I have a lot of time
	["Fail_Throne of Thunder_Primordius_Mutate Player"] = { { 136185, 136187, 136183, 136181 }, "FAIL_TYPE_MOVING", "ej:6960", "ej:6960", nil, false },-- up to date 10 H ptr
	["Fail_Throne of Thunder_Iron Qon_Burning Cinder"] = { { 137668 }, "FAIL_TYPE_MOVING", 137668, 137668, nil, false },
	["Fail_Throne of Thunder_Dark Animus_Interrupting Jolt"] = { { 139867, }, "FAIL_TYPE_NOTCASTING", 139867, 139867, nil, false },-- up to date 10 H ptr
	["Fail_Throne of Thunder_Iron Qon_Electrified"] = { { 136615 }, "FAIL_TYPE_MOVING", "ej:6913", "ej:6913", nil, false },
	["Fail_Throne of Thunder_Iron Qon_Frozen Blood"] = { { 137664 }, "FAIL_TYPE_MOVING", 137664, 137664, nil, false },
	["Fail_Throne of Thunder_Twin Consorts_Slumber Spores"] = { { 136722 }, "FAIL_TYPE_MOVING", 136722, 136722, nil, false },
	["Fail_Throne of Thunder_Lei Shen_Diffusion Chain"] = { { 135991 }, "FAIL_TYPE_SPREADING", 135991, 135991, nil, false },
	["Fail_Throne of Thunder_Lei Shen_Overcharge"] = { { 136326 }, "FAIL_TYPE_MOVING", 136295, 136295, false, false },
	["Fail_Throne of Thunder_Lei Shen_Crashing Thunder"] = { { 135150 }, "FAIL_TYPE_MOVING", 135150, 135150, false, false },
	["Fail_Throne of Thunder_Lei Shen_Summon Ball Lightning"] = { { 136543 }, "FAIL_TYPE_SPREADING", 136543, 136543, nil, false },
	["Fail_Throne of Thunder_Ra-den_Anima Sensitivity"] = { { 138295, 139318 }, "FAIL_TYPE_WRONGPLACE", 139318, 139318},
	["Fail_Throne of Thunder_Ra-den_Vita Sensitivity"] = { { 138370 }, "FAIL_TYPE_WRONGPLACE", 138372, 138372},

	["Fail_Siege of Orgrimmar_Immerseus_Sha Bolt"] = { { 143297 }, "FAIL_TYPE_MOVING", "ej:7985", "ej:7985", nil, false },
	["Fail_Siege of Orgrimmar_The Fallen Protectors_Corruption Kick"] = { { 143009 }, "FAIL_TYPE_MOVING", 143009, 143009, nil, false },
	["Fail_Siege of Orgrimmar_The Fallen Protectors_Gouge"] = { { 143301 }, "FAIL_TYPE_MOVING", 143301, 143301, nil, false },
	["Fail_Siege of Orgrimmar_The Fallen Protectors_Dark Meditation"] = { { 143559 }, "FAIL_TYPE_WRONGPLACE", 143559, 143559},
	["Fail_Siege of Orgrimmar_The Fallen Protectors_Sha Sear"] = { { 143424 }, "FAIL_TYPE_MOVING", 143424, 143424, nil, false },
	["Fail_Siege of Orgrimmar_Norushen_Corrupt"] = { { 145052 }, "FAIL_TYPE_MOVING", 145052, "ej:8248", nil, false },
	["Fail_Siege of Orgrimmar_Sha of Pride_Aura of Pride"] = { { 146818 }, "FAIL_TYPE_SPREADING", 146818, 146818, nil, false },
	["Fail_Siege of Orgrimmar_Sha of Pride_Overcome"] = { { 144400 }, "FAIL_TYPE_MOVING", "ej:8270", "ej:8270", nil, false },
	["Fail_Siege of Orgrimmar_Sha of Pride_Wounded Pride"] = { { 144358 }, "FAIL_TYPE_SWITCHING", 144358, 144358, false, false },
	["Fail_Siege of Orgrimmar_Iron Juggernaut_Napalm Oil"] = { { 144498 }, "FAIL_TYPE_MOVING", 144498, 144498, nil, false },
	["Fail_Siege of Orgrimmar_Kor'kron Dark Shaman_Foul Stream"] = { { 144090 }, "FAIL_TYPE_MOVING", 144090, 144090, nil, false },
	["Fail_Siege of Orgrimmar_Kor'kron Dark Shaman_Ashen Wall"] = { { }, "FAIL_TYPE_MOVING", "ej:8133", "ej:8133", nil, false },
	["Fail_Siege of Orgrimmar_General Nazgrim_Defensive Stance"] = { { }, nil, 143593, 143593},
	["Fail_Siege of Orgrimmar_Malkorok_Displaced Energy"] = { { 142928 }, "FAIL_TYPE_MOVING", 142928, 142928, nil, false },
	["Fail_Siege of Orgrimmar_Malkorok_Seismic Slam"] = { { 142849 }, "FAIL_TYPE_SPREADING", 142849, 142849, nil, false },
	["Fail_Siege of Orgrimmar_Spoils of Pandaria_Breath of Fire"] = { { 146226 }, "FAIL_TYPE_MOVING", 146226, 146226, nil, false },
	["Fail_Siege of Orgrimmar_Thok the Bloodthirsty_Chomp"] = { { 143465 }, "FAIL_TYPE_MOVING", 143465, 143465, nil, false },
	["Fail_Siege of Orgrimmar_Thok the Bloodthirsty_Burning Blood"] = { { 143784 }, "FAIL_TYPE_MOVING", 143784, 143784, nil, false },
	["Fail_Siege of Orgrimmar_Paragons of the Klaxxi_Reacton: Red"] = { { 142736 }, "FAIL_TYPE_SPREADING", 142736, 142736, nil, false },
	["Fail_Siege of Orgrimmar_Paragons of the Klaxxi_Noxious Vapor"] = { { 142797 }, "FAIL_TYPE_MOVING", 142797, 142797, nil, false },
	["Fail_Siege of Orgrimmar_Paragons of the Klaxxi_Caustic Amber"] = { { 143735 }, "FAIL_TYPE_MOVING", 143735, 143735, nil, false },
	["Fail_Siege of Orgrimmar_Garrosh Hellscream_Annihilate"] = { { 144969 }, "FAIL_TYPE_MOVING", 144969, 144969, nil, false },
}

-- ["Fail_Zone Name_Boss Name_Ability Name"] = { { spellId list }, FAIL_TYPE, event name or spellId, description or spellId, true if tanks do not fail, true if its only overkill (false to default off, nil for no option) },
-- Don't forget to add damageConstraint at the globals section if necesary
local generalDamageFail = {
	["Fail_Heart of Fear_Blade Lord Ta'yak_Tempest Slash"] = { { 122853 }, "FAIL_TYPE_MOVING", "ej:6345", "ej:6345", nil, false },
	["Fail_Heart of Fear_Blade Lord Ta'yak_Blade Tempest"] = { { 125312 }, "FAIL_TYPE_MOVING", 125312, 125312 },
	["Fail_Heart of Fear_Imperial Vizier Zor'lok_Sonic Rings"] = { { 122336 }, "FAIL_TYPE_MOVING", 122336, 122336, nil, false },
	["Fail_Heart of Fear_Imperial Vizier Zor'lok_Sonic Pulse"] = { { 124673 }, "FAIL_TYPE_MOVING", 124673, 124673, nil, false },
	["Fail_Heart of Fear_Garalon_Furious Swipe"] = { { 122735 }, "FAIL_TYPE_WRONGPLACE", 122735, 122735, true, false },
	["Fail_Heart of Fear_Wind Lord Mel'jarak_Corrosive Resin Pool"] = { { 122125 }, "FAIL_TYPE_MOVING", 122125, 122125, true, false },
	["Fail_Heart of Fear_Wind Lord Mel'jarak_Whirling Blade"] = { { 121898 }, "FAIL_TYPE_MOVING", 121898, 121898, nil, false },
	["Fail_Heart of Fear_Amber-Shaper Un'sok_Burning Amber"] = { { 122504 }, "FAIL_TYPE_MOVING", 123020, 123020 },
	["Fail_Heart of Fear_Grand Empress Shek'zeer_Toxic Slime"] = { { 124807 }, "FAIL_TYPE_WRONGPLACE", 124807, 124807, true, false },
	["Fail_Heart of Fear_Grand Empress Shek'zeer_Sonic Blade"] = { { 125888 }, "FAIL_TYPE_MOVING", 125888, 125888, true, false },
	["Fail_Heart of Fear_Grand Empress Shek'zeer_Sha Corruption"] = { { 125283 }, "FAIL_TYPE_WRONGPLACE", 125283, 125283, nil, false },

	["Fail_Mogu'shan Vaults_The Stone Guard_Cobalt Mine"] = { { 116281 }, "FAIL_TYPE_MOVING", 116281, 116281, nil, false },
	["Fail_Mogu'shan Vaults_Feng the Accursed_Wildfire"] = { { 116793 }, "FAIL_TYPE_MOVING", "ej:5886", "ej:5886", nil, false },
	["Fail_Mogu'shan Vaults_The Spirit Kings_Flanking Orders"] = { { 117918 }, "FAIL_TYPE_MOVING", 117910, 117910, nil, false},
	["Fail_Mogu'shan Vaults_The Spirit Kings_Annihilate"] = { { 119521, 117948 }, "FAIL_TYPE_MOVING", "ej:5844", "ej:5844"},
	["Fail_Mogu'shan Vaults_The Spirit Kings_Coalescing Shadows"] = { { 117558 }, "FAIL_TYPE_MOVING", "ej:5855", "ej:5855", nil, false },
	["Fail_Mogu'shan Vaults_Elegon_Celestial Breath"] = { { 124947 }, "FAIL_TYPE_WRONGPLACE", 124947, 124947, true, false },
	["Fail_Mogu'shan Vaults_Elegon_Energy Conduit"] = { { 116661 }, "FAIL_TYPE_MOVING", "ej:6194", "ej:6194", nil, false },
	["Fail_Mogu'shan Vaults_Elegon_Energy Cascade"] = { { 119722 }, "FAIL_TYPE_MOVING", "ej:6197", "ej:6197", nil, false },
	["Fail_Mogu'shan Vaults_Elegon_Stability Flux"] = { { 117912 }, "FAIL_TYPE_MOVING", 117912, 117912, nil, false },
	["Fail_Mogu'shan Vaults_Elegon_Obliteration"] = { { 132275 }, "FAIL_TYPE_MOVING", 132275, 132275, nil, nil },
	["Fail_Mogu'shan Vaults_Will of the Emperor_Energy of Creation"] = { { 116805 }, "FAIL_TYPE_MOVING", 116805, 116805, nil, true },
	["Fail_Mogu'shan Vaults_Will of the Emperor_Opportunistic Strike"] = { { 116968, 116971, 116972, 132425, 116969, 116835 }, "FAIL_TYPE_MOVING", "ej:5727", "ej:5727", nil, false }, -- left, right, center, stomp1, stomp2, devastating arc (probably not all spellIds are needed)

	["Fail_Terrace of Endless Spring_Protectors of the Endless_Lightning Storm"] = { { 118003, 118004, 118005 }, "FAIL_TYPE_MOVING", 118003, 118003, nil, false },
	["Fail_Terrace of Endless Spring_Protectors of the Endless_Defiled Ground"] = { { 117988 }, "FAIL_TYPE_MOVING", 117988, 117988, nil, false },
	["Fail_Terrace of Endless Spring_Tsulong_Nightmares"] = { { 122777 }, "FAIL_TYPE_MOVING", 122777, 122777, nil, false },
	["Fail_Terrace of Endless Spring_Tsulong_Shadow Breath"] = { { 122752 }, "FAIL_TYPE_WRONGPLACE", "ej:6313", "ej:6313", true, false },
	["Fail_Terrace of Endless Spring_Lei Shi_Get Away!"] = { { 123467 }, "FAIL_TYPE_MOVING", 123467, 123467, nil, false },
	["Fail_Terrace of Endless Spring_Sha of Fear_Breath of Fear"] = { { 119414 }, "FAIL_TYPE_MOVING", 119414, 119414, nil, false },
	["Fail_Terrace of Endless Spring_Sha of Fear_Death Blossom"] = { { 119887 }, "FAIL_TYPE_MOVING", 119887, 119887, true, false },
	["Fail_Terrace of Endless Spring_Sha of Fear_Emerge"] = { { 120458 }, "FAIL_TYPE_MOVING", 120458, 120458, nil, false },
	["Fail_Terrace of Endless Spring_Sha of Fear_Implacable Strike"] = { { 120672 }, "FAIL_TYPE_WRONGPLACE", 120672, 120672, nil, false },

	["Fail_Throne of Thunder_Jin'rokh the Breaker_Violent Detonation"] = { { 138990 }, "FAIL_TYPE_MOVING", 138990, 138990, nil, false },
	["Fail_Throne of Thunder_Jin'rokh the Breaker_Thundering Throw"] = { { 137167 }, "FAIL_TYPE_WRONGPLACE", 137167, 137167, true, false },
	["Fail_Throne of Thunder_Jin'rokh the Breaker_Lightning Strike"] = { { 137647 }, "FAIL_TYPE_MOVING", 137647, 137647, nil, false },
	["Fail_Throne of Thunder_Horridon_Double Swipe"] = { { 136739, 136740 }, "FAIL_TYPE_WRONGPLACE", 136740, 136740, nil, false },
	["Fail_Throne of Thunder_Horridon_Frozen Bolt"] = { { 136573 }, "FAIL_TYPE_MOVING", 136573, 136573, nil, false },
	["Fail_Throne of Thunder_Horridon_Swipe"] = { { 136463 }, "FAIL_TYPE_WRONGPLACE", 136463, 136463, true, false },
	["Fail_Throne of Thunder_Horridon_Chain Lightning"] = { { 136480 }, "FAIL_TYPE_SPREADING", 136480, 136480, nil, false },
	["Fail_Throne of Thunder_Horridon_Lightning Nova"] = { { 136490 }, "FAIL_TYPE_WRONGPLACE", 136490, 136490, nil, false },
	["Fail_Throne of Thunder_Council of Elders_Reckless Charge"] = { { 137133 }, "FAIL_TYPE_MOVING", 137133, 137133, nil, false },
	["Fail_Throne of Thunder_Tortos_Rockfall"] = { { 134539 }, "FAIL_TYPE_MOVING", 134539, 134539, nil, false },
	["Fail_Throne of Thunder_Tortos_Spinning Shell"] = { { 134011 }, "FAIL_TYPE_MOVING", 134011, 134011, nil, false },
	["Fail_Throne of Thunder_Megaera_Ignite Flesh"] = { { 137730 }, "FAIL_TYPE_WRONGPLACE", 137730, 137730, true, false },
	["Fail_Throne of Thunder_Megaera_Arctic Freeze"] = { { 139842 }, "FAIL_TYPE_WRONGPLACE", 139842, 139842, true, false },
	["Fail_Throne of Thunder_Megaera_Icy Ground"] = { { 139909 }, "FAIL_TYPE_MOVING", 139909, 139909, false, false },
	["Fail_Throne of Thunder_Megaera_Rot Armor"] = { { 139839 }, "FAIL_TYPE_WRONGPLACE", 139839, 139839, true, false },
	["Fail_Throne of Thunder_Megaera_Acid Rain"] = { { 139850 }, "FAIL_TYPE_MOVING", 139850, 139850, nil, false },
	["Fail_Throne of Thunder_Megaera_Diffusion"] = { { 139992 }, "FAIL_TYPE_WRONGPLACE", 139992, 139992, true, false },
	["Fail_Throne of Thunder_Durumu the Forgotten_Eye Sore"] = { { 140502 }, "FAIL_TYPE_MOVING", 140502, 140502, nil, false },
	["Fail_Throne of Thunder_Primordius_Primordial Strike"] = { { 136037 }, "FAIL_TYPE_WRONGPLACE", 136037, 136037, true, false },
	["Fail_Throne of Thunder_Primordius_Volatile Mutation"] = { { 140508 }, "FAIL_TYPE_MOVING", 140508, 140508, nil, false },
	["Fail_Throne of Thunder_Dark Animus_Crimson Wake"] = { { 138485 }, "FAIL_TYPE_MOVING", 138485, 138485, true, false },-- up to date 10 H ptr
	["Fail_Throne of Thunder_Dark Animus_Explosive Slam"] = { { 138569 }, "FAIL_TYPE_MOVING", 138569, 138569, true, false },-- up to date 10 H ptr
	["Fail_Throne of Thunder_Dark Animus_Anima Font"] = { { 138707 }, "FAIL_TYPE_MOVING", 138707, 138707, nil, false },
	["Fail_Throne of Thunder_Iron Qon_Rushing Winds"] = { { 137654 }, "FAIL_TYPE_MOVING", 137654, 137654, nil, false },
	["Fail_Throne of Thunder_Lei Shen_Decapitate"] = { { 134916 }, "FAIL_TYPE_MOVING", 134916, 134916, nil, false },
	["Fail_Throne of Thunder_Lei Shen_Thunderstruck"] = { { 135096 }, "FAIL_TYPE_MOVING", 135096, 135096, nil, false },
	["Fail_Throne of Thunder_Lei Shen_Lightning Whip"] = { { 136850 }, "FAIL_TYPE_MOVING", 136850, 136850, nil, false },
	["Fail_Throne of Thunder_Lei Shen_Lightning Bolt"] = { { 136853 }, "FAIL_TYPE_MOVING", 136853, 136853, nil, false },

	["Fail_Siege of Orgrimmar_Immerseus_Swirl"] = { { 143412, 143413 }, "FAIL_TYPE_MOVING", 143413, 143413, nil, false }, -- 143412 knockback, 143413 knock up
	["Fail_Siege of Orgrimmar_Immerseus_Corrosive Blast"] = { { 143436 }, "FAIL_TYPE_WRONGPLACE", 143436, 143436, true, false },
	["Fail_Siege of Orgrimmar_Immerseus_Seeping Sha"] = { { 143286 }, "FAIL_TYPE_MOVING", "ej:7991", "ej:7991", nil, false },
	["Fail_Siege of Orgrimmar_The Fallen Protectors_Defiled Ground"] = { { 144357 }, "FAIL_TYPE_MOVING", 144357, 144357, nil, false },
	["Fail_Siege of Orgrimmar_The Fallen Protectors_Corruption Shock"] = { { 144018 }, "FAIL_TYPE_MOVING", 144018, 144018, nil, false },
	["Fail_Siege of Orgrimmar_The Fallen Protectors_Vengeful Strike"] = { { 144397 }, "FAIL_TYPE_WRONGPLACE", 144397, 144397, true, false },
	["Fail_Siege of Orgrimmar_The Fallen Protectors_Corrupted Brew"] = { { 143023 }, "FAIL_TYPE_MOVING", 143023, 143023, nil, false },
	["Fail_Siege of Orgrimmar_The Fallen Protectors_Noxious Poison"] = { { 144367 }, "FAIL_TYPE_MOVING", 144367, 144367, nil, false },
	["Fail_Siege of Orgrimmar_Norushen_Blind Hatred"] = { { 145227 }, "FAIL_TYPE_MOVING", 145227, 145227, nil, false },
	["Fail_Siege of Orgrimmar_Sha of Pride_Bursting Pride"] = { { 144911 }, "FAIL_TYPE_MOVING", 144911, 144911, nil, false },
	["Fail_Siege of Orgrimmar_Sha of Pride_Self-Reflection"] = { { 144788 }, "FAIL_TYPE_MOVING", 144788, 144788, nil, false },
	["Fail_Siege of Orgrimmar_Sha of Pride_Corrupted Prison"] = { { 144615 }, "FAIL_TYPE_WRONGPLACE", 144615, 144615, nil, false },
	["Fail_Siege of Orgrimmar_Galakras_Muzzle Spray"] = { { 147824 }, "FAIL_TYPE_MOVING", 147824, 147824, true, false },
	["Fail_Siege of Orgrimmar_Galakras_Arcing Smash"] = { { 147688 }, "FAIL_TYPE_MOVING", 147688, 147688, nil, false },
	["Fail_Siege of Orgrimmar_Galakras_Skull Cracker"] = { { 146848 }, "FAIL_TYPE_MOVING", 146848, 146848, nil, false },
	["Fail_Siege of Orgrimmar_Galakras_Shattering Cleave"] = { { 146849 }, "FAIL_TYPE_WRONGPLACE", 146849, 146849, true, false },
	["Fail_Siege of Orgrimmar_Galakras_Poison Cloud"] = { { 147705 }, "FAIL_TYPE_MOVING", 147705, 147705, nil, false },
	["Fail_Siege of Orgrimmar_Galakras_Flame Arrows"] = { { 146764 }, "FAIL_TYPE_MOVING", 146764, 146764, nil, false },
	["Fail_Siege of Orgrimmar_Iron Juggernaut_Borer Drill"] = { { 144218 }, "FAIL_TYPE_MOVING", 144218, 144218, nil, false },
	["Fail_Siege of Orgrimmar_Iron Juggernaut_Mortar Blast"] = { { 144316 }, "FAIL_TYPE_MOVING", 144316, 144316, nil, false },
	["Fail_Siege of Orgrimmar_Iron Juggernaut_Flame Vents"] = { { 144464 }, "FAIL_TYPE_WRONGPLACE", 144464, 144464, true, false },
	["Fail_Siege of Orgrimmar_Iron Juggernaut_Cutter Laser"] = { { 144918 }, "FAIL_TYPE_MOVING", 144918, 144918, nil, false },
	["Fail_Siege of Orgrimmar_Kor'kron Dark Shaman_Swipe"] = { { 144303 }, "FAIL_TYPE_WRONGPLACE", 144303, 144303, true, false },
	["Fail_Siege of Orgrimmar_Kor'kron Dark Shaman_Toxic Storm"] = { { 144017 }, "FAIL_TYPE_MOVING", 144017, 144017, nil, false },
	["Fail_Siege of Orgrimmar_Kor'kron Dark Shaman_Toxic Tornado"] = { { 144030 }, "FAIL_TYPE_MOVING", 144030, 144030, nil, false },
	["Fail_Siege of Orgrimmar_Kor'kron Dark Shaman_Foulness"] = { { 144066 }, "FAIL_TYPE_MOVING", 144066, 144066, nil, false },
	["Fail_Siege of Orgrimmar_Kor'kron Dark Shaman_Iron Tomb"] = { { 144334 }, "FAIL_TYPE_MOVING", 144334, 144334, nil, false },
	["Fail_Siege of Orgrimmar_Kor'kron Dark Shaman_Falling Ash"] = { { 143987 }, "FAIL_TYPE_MOVING", 143987, 143987, nil, false },
	["Fail_Siege of Orgrimmar_General Nazgrim_Aftershock"] = { { 143712 }, "FAIL_TYPE_MOVING", 143712, 143712, nil, false },
	["Fail_Siege of Orgrimmar_General Nazgrim_Ravager"] = { { 143873 }, "FAIL_TYPE_MOVING", 143873, 143873, nil, false },
	["Fail_Siege of Orgrimmar_General Nazgrim_Ironstorm"] = { { 143421 }, "FAIL_TYPE_MOVING", 143421, 143421, nil, false },
	["Fail_Siege of Orgrimmar_General Nazgrim_Backstab"] = { { 143481 }, "FAIL_TYPE_MOVING", 143481, 143481, nil, false },
	["Fail_Siege of Orgrimmar_Malkorok_Arcing Smash"] = { { 142815 }, "FAIL_TYPE_MOVING", 142815, 142815, nil, false },
	["Fail_Siege of Orgrimmar_Malkorok_Breath of Y'Shaarj"] = { { 142816 }, "FAIL_TYPE_MOVING", 142816, 142816, nil, false },
	["Fail_Siege of Orgrimmar_Spoils of Pandaria_Set to Blow"] = { { 146387 }, "FAIL_TYPE_MOVING", 146387, 146387, nil, false },
	["Fail_Siege of Orgrimmar_Spoils of Pandaria_Pulse"] = { { 142759 }, "FAIL_TYPE_MOVING", 142759, 142759, nil, false },
	["Fail_Siege of Orgrimmar_Spoils of Pandaria_Nova"] = { { 142775 }, "FAIL_TYPE_MOVING", 142775, 142775, nil, false },
	["Fail_Siege of Orgrimmar_Spoils of Pandaria_Blazing Charge"] = { { 145716 }, "FAIL_TYPE_MOVING", 145716, 145716, nil, false },
	["Fail_Siege of Orgrimmar_Spoils of Pandaria_Bubbling Amber"] = { { 145748 }, "FAIL_TYPE_MOVING", 145748, 145748, nil, false },
	["Fail_Siege of Orgrimmar_Spoils of Pandaria_Path of Blossoms"] = { { 146257 }, "FAIL_TYPE_MOVING", 146257, 146257, nil, false },
	["Fail_Siege of Orgrimmar_Thok the Bloodthirsty_Tail Lash"] = { { 143428 }, "FAIL_TYPE_WRONGPLACE", 143428, 143428, nil, false },
	["Fail_Siege of Orgrimmar_Thok the Bloodthirsty_Fearsome Roar"] = { { 143426 }, "FAIL_TYPE_WRONGPLACE", 143426, 143426, true, false },
	["Fail_Siege of Orgrimmar_Thok the Bloodthirsty_Acid Breath"] = { { 143780 }, "FAIL_TYPE_WRONGPLACE", 143780, 143780, true, false },
	["Fail_Siege of Orgrimmar_Thok the Bloodthirsty_Freezing Breath"] = { { 143773 }, "FAIL_TYPE_WRONGPLACE", 143773, 143773, true, false },
	["Fail_Siege of Orgrimmar_Thok the Bloodthirsty_Scorching Breath"] = { { 143767 }, "FAIL_TYPE_WRONGPLACE", 143767, 143767, true, false },
	["Fail_Siege of Orgrimmar_Siegecrafter Blackfuse_Serrated Slash"] = { { 143327 }, "FAIL_TYPE_MOVING", 143327, 143327, false, false }, -- maybe tanks should not fial?
	["Fail_Siege of Orgrimmar_Siegecrafter Blackfuse_Death From Above"] = { { 144210 }, "FAIL_TYPE_MOVING", 144210, 144210, false, false }, -- maybe tanks should not fial?
	["Fail_Siege of Orgrimmar_Siegecrafter Blackfuse_Matter Purification Beam"] = { { 144335 }, "FAIL_TYPE_MOVING", 144335, 144335, nil, false },
	["Fail_Siege of Orgrimmar_Siegecrafter Blackfuse_Shockwave Missile"] = { { 143641, 144658, 144660, 144661, 144662, 144663, 144664 }, "FAIL_TYPE_MOVING", 143641, 143641, nil, false },
	["Fail_Siege of Orgrimmar_Siegecrafter Blackfuse_Superheated"] = { { 143856 }, "FAIL_TYPE_MOVING", 143856, 143856, nil, false },
	["Fail_Siege of Orgrimmar_Siegecrafter Blackfuse_Detonate!"] = { { 143002 }, "FAIL_TYPE_MOVING", 143002, 143002, nil, false },
	["Fail_Siege of Orgrimmar_Paragons of the Klaxxi_Impact"] = { { 142232 }, "FAIL_TYPE_MOVING", 142232, 142232, nil, false },
	["Fail_Siege of Orgrimmar_Paragons of the Klaxxi_Vicious Assault"] = { { 143980, 143981, 143982, 143984, 143985 }, "FAIL_TYPE_MOVING", 143980, 143980, true, false },
	["Fail_Siege of Orgrimmar_Garrosh Hellscream_Desecrate"] = { { 144762 }, "FAIL_TYPE_MOVING", 144762, 144762, nil, false },
	["Fail_Siege of Orgrimmar_Garrosh Hellscream_Iron Star Impact"] = { { 144650 }, "FAIL_TYPE_MOVING", 144650, 144650, nil, false },
	["Fail_Siege of Orgrimmar_Garrosh Hellscream_Exploding Iron Star"] = { { 144798 }, "FAIL_TYPE_MOVING", 144798, 144798, nil, false },
	["Fail_Siege of Orgrimmar_Garrosh Hellscream_Whirling Corruption"] = { { 144989 }, "FAIL_TYPE_MOVING", 144989, 144989, true, false },
	-- add ember parasite - feed
}

-- Populate failEvents with simple fails so we don't have to add them more than once
-- ... in case we decide to add more general fail types
local function PopulateFailEvents(...)
	for i=1, select("#", ...) do
		for k, v in pairs(select(i, ...)) do
			failEvents[k] = v
		end
	end
end
PopulateFailEvents(generalDamageFail)

local function TableLookup(item, table)
	for i=1, #table do
		if table[i] == item then return i end
	end
	return false
end

local zoneList, bossList, zoneBosses = {}, {}, {}
for k, v in pairs(failEvents) do
	local s = k:match("_.*_"):match("[^_].*[^_]")
	local z = s:match(".*_"):gsub("_","")
	local b = s:match("_.*"):gsub("_","")

	if not zoneList[z] then zoneList[z] = {} end
	table.insert(zoneList[z], k)

	if not bossList[b] then bossList[b] = {} end
	table.insert(bossList[b], k)

	if not zoneBosses[z] then zoneBosses[z] = {} end
	if not TableLookup(b, zoneBosses[z]) then table.insert(zoneBosses[z], b) end
end

local debuffs = {
	(GetSpellInfo(123713)), -- Servant of the Empress
	(GetSpellInfo(116417)), -- Arcane Resonance
	(GetSpellInfo(122706)), -- Noise Cancelling
	(GetSpellInfo(124863)), -- Visions of Demise
	(GetSpellInfo(120629)), -- Huddle in Terror
	(GetSpellInfo(136992)), -- Biting Cold
	(GetSpellInfo(137669)), -- Storm Cloud
	(GetSpellInfo(138002)), -- Fluidity
	(GetSpellInfo(143564)), -- Meditative Field
	(GetSpellInfo(143423)), -- Sha Sear
	(GetSpellInfo(144358)), -- Wounded Pride
	(GetSpellInfo(146217)), -- Keg Toss
}

local buffs = {
	(GetSpellInfo(117961)), -- Impervious Shield
	(GetSpellInfo(117697)), -- Shield of Darkness
	(GetSpellInfo(115911)), -- Shroud of Reversal
	(GetSpellInfo(120268)), -- Champion of the light
	(GetSpellInfo(143593)), -- Defensive Stance
}

local barrierSpellIdExceptions = {
	[26364] = true, -- Lightning Shield
	[93068] = true, -- Master Poisoner
	[32592] = true, -- Mass Dispel
	[64382] = true, -- Shattering Throw
	[131894] = true, -- A Murder of Crows
}

local deepCorruptionSpellIdExceptions = {
	[633]   = true,	--"Lay on Hands"
	[6262]  = true,	--"Healthstone"
	[81269] = true,	--"Efflorescence"
	[52042] = true,	--"Healing Stream Totem"
	[98021] = true,	--"Spirit Link"
	[53652] = true,	--"Beacon of Light"
	[85673] = true,	--"Word of Glory"
	[77489] = true,	--"Echo of Light"
	[33110] = true,	--"Prayer of Mending"
	[34299] = true,	--"Leader of the Pack"
	[53353] = true,	--"Chimera Shot"
	[15290] = true,	--"Vampiric Embrace"
	[73651] = true,	--"Recuperate"
	[96379] = true,	--"Fel Armor"
}

-- /print "[\""..GetMapNameByID(GetCurrentMapAreaID()).."\"] = "..GetCurrentMapAreaID()
local usedZoneIDs = {
	["Heart of Fear"] = 897,
	["Mogu'shan Vaults"] = 896,
	["Terrace of Endless Spring"] = 886,
	["Throne of Thunder"] = 930,
	["Siege of Orgrimmar"] = 953,
}

local mapData = {
	HeartofFear = {
		{ 700.0, 466.666748046875 },
		{ 1440.0043802261353, 960.0029296875 },
	},
	ThunderKingRaid = {
		{ 1285.0,856.6669921875 },
		{ 1550.009765625,1033.33984375 },
		{ 1030.0,686.6669921875 },
		{ 591.280029296875,394.18701171875 },
		{ 1030.0,686.6669921875 },
		{ 910.0,606.6669921875 },
		{ 810.0,540.0 },
		{ 617.5,411.6669921875 },
	},
	OrgrimmarRaid = {
		{ 950.01501464844,633.34326171875 },
		{ 562.5,375 },
		{ 1141.669921875,761.11322021484 },
		{ 1739.384765625,1159.5899658203 },
		{ 362.08984375,241.39318847656 },
		{ 600,400 },
		{ 885,590 },
		{ 1210,806.66674804688 },
		{ 645,430.00012207031 },
		{ 885,590 },
		{ 472.5,315 },
		{ 830.005859375,553.33703613281 },
		{ 345,230 },
		{ 262.5,175 },
	},
}

-- Tank Fail Position in failEvents
local TFP = 5
-- overkill only position in failEvents
local OKP = 6

-------------------------------------------------------------------------
-- API CALLS
-------------------------------------------------------------------------

--- Get a list of supported events.
-- @see failEvents page
-- @return a table of event names which can be fired
function lib:GetSupportedEvents()
	local t = {}
	for k, v in pairs(failEvents) do
		table.insert(t, k)
	end
	return t
end

--- Get a list of supported events in the given zone
-- @see failEvents page
-- @return a table of event names which can be fired in the zone
function lib:GetSupportedZoneEvents(zone) return zoneList[zone] end

--- Get a list of supported events at the given boss
-- @see failEvents page
-- @return a table of event names which can be fired at the boss
function lib:GetSupportedBossEvents(boss) return bossList[boss] end

--- Get a List of Bosses at the given zone for the supported events
-- @see failEvents page
-- @return a table of boss names at the given zone for the supported events
function lib:GetSupportedZoneBosses(zone) return zoneBosses[zone] end

--- Get a List of supported Zones
-- @see failEvents page
-- @return a table of zone names that are supported
function lib:GetSupportedZones()
	local t = {}
	for k, v in pairs(zoneList) do
		table.insert(t, k)
	end
	return t
end

--- Get a fail events localized name
-- @see failEvents page
-- @param event the event name
-- @return a fail events localized name
function lib:GetEventName(event)
        local v = event and failEvents[event]
	if not v then
	  	return nil
	elseif type(v[3]) == "number" then
		return (GetSpellInfo(v[3])) or "Localization not found"
	else
		if v[3]:match("ej:") then
			return (EJ_GetSectionInfo(v[3]:sub(4))) or "Localization not found"
		else
			return v[3] or "Localization not found"
		end
	end
end

--- Get a fail events localized name, including a spell link when possible
-- @see failEvents page
-- @param event the event name
-- @return a fail events fancy name
function lib:GetEventFancyName(event)
        local v = event and failEvents[event]
	if not v then
	  	return nil
	elseif type(v[3]) == "number" then
		return (GetSpellLink(v[3])) or "Localization not found"
	else
		if v[3]:match("ej:") then
			return (select(9, EJ_GetSectionInfo(v[3]:sub(4)))) or "Localization not found"
		else
			return v[3] or "Localization not found"
		end
	end
end

--- Get a fail events description
-- @see failEvents in the code
-- @param event the event name
-- @return a description somewhat related to the fail event
function lib:GetEventDescription(event)
        local v = event and failEvents[event]
	if not v then
	  	return nil
	elseif type(v[4]) == "number" then
		return lib:getSpellDescription(v[4]) or "Localization not found"
	else
		if v[4]:match("ej:") then
			return (select(2, EJ_GetSectionInfo(v[4]:sub(4)))) or "Localization not found"
		else
			return v[4] or "Localization not found"
		end
	end
end

--- Get a tabe of constraints with their default values for the event
-- @see lib.CONSTRAINTS
-- @param event the event name
-- @return a table with ["Constraint Name"] = value pairs or returns nil if no constraints
function lib:GetEventConstraints(event)
	return event and lib.CONSTRAINTS[event]
end

--- Returns true if there is an option for tanks not failing on the event
-- @see lib.TANKS_DONT_FAIL_LIST
-- @param event the event name
-- @return true if there is an option for tanks not failing on the event
function lib:GetTanksDontFailOption(event)
        local v = event and failEvents[event]
	if not v then
	  	return nil
	elseif v[TFP] then
		return true
	else
		return false
	end
end

--- Returns true if there is an option for overkill only
-- @see lib.OVERKILL_ONLY_LIST
-- @param event the event name
-- @return true if there is an option for overkill only on the event
function lib:GetOverkillOnlyOption(event)
        local v = event and lib.OVERKILL_ONLY_LIST[event]
	if v or v == false then
	  	return true
	else
		return false
	end
end

local function OverkillOnly(event)
  local v = event and lib.OVERKILL_ONLY_LIST[event]
  if v or (v == false and lib.OVERKILL_ONLY_LIST.ovkoverride) then
    return true
  else
    return false
  end
end

--- Returns the localized zone name from a supported zone
-- @see localization strings
-- @param zone the zone name to get localized zone for
-- @return the localized zone name
function lib:GetLocalizedZone(zone)
 	if not zone then return nil end
	if not zoneList[zone] then
		return "Localization not found"
	else
		return GetMapNameByID(usedZoneIDs[zone]) or "Localization not found"
	end
end

--- Returns the localized boss name for a supported boss
-- @see localization strings or the encounter journal
-- @param boss the boss to get localized boss for
-- @return the localized boss name
function lib:GetLocalizedBoss(boss)
 	if not boss then return nil end
	if not bossList[boss] then
		return "Localization not found"
	else
		local name = LEJB:GetEncounterInfoByBossName(boss)
		return name or "Localization not found"
	end
end

--- Returns the localized constraint name of the given constraint in the given fail event
-- @see lib.CONSTRAINTS
-- @param event, constraint the fail event and the constraint
-- @return the localized constraint name in the given fail event
function lib:GetLocalizedConstraint(event, constraint)
	if not event or not constraint then return nil end
	local v = lib.CONSTRAINTS[event]
	if v and v[constraint] then
		return L[constraint]
	else
		return nil
	end
end

-------------------------------------------------------------------------
-- UTILITY
-------------------------------------------------------------------------

function lib:IsHeroic()
	local _, _, diff = GetInstanceInfo()
	return diff == 5 or diff == 6
end

do
	local cache = {}
	local scanner = CreateFrame("GameTooltip")
	scanner:SetOwner(WorldFrame, "ANCHOR_NONE")
	local lCache, rCache = {}, {}
	for i = 1, 4 do
		lCache[i], rCache[i] = scanner:CreateFontString(), scanner:CreateFontString()
		lCache[i]:SetFontObject(GameFontNormal); rCache[i]:SetFontObject(GameFontNormal)
		scanner:AddFontStrings(lCache[i], rCache[i])
	end
	function lib:getSpellDescription(spellId)
		if cache[spellId] then return cache[spellId] end
		scanner:ClearLines()
		scanner:SetHyperlink("spell:"..spellId)
		for i = scanner:NumLines(), 1, -1  do
			local desc = lCache[i] and lCache[i]:GetText()
			if desc then
				cache[spellId] = desc
				return desc
			end
		end
	end
end

function lib:IsRaidPet(unit)
	for i=1, 25 do
		if UnitExists(("raid%dpet"):format(i)) and UnitExists(unit) then
			if UnitIsUnit(("raid%dpet"):format(i),unit) then
				-- if its a raid pet return the owner
				return UnitName(("raid%d"):format(i))
			end
		end
	end
	return false
end

function lib:IsTank(unit)
	-- 1. new specialization check introduced in MoP
	-- 2. check blizzard tanks first
	-- 3. check blizzard roles second
	local info = LGIST:GetCachedInfo(UnitGUID(unit))
	if info and info.spec_role and info.spec_role == "TANK" then
		return true
	end
	if GetPartyAssignment("MAINTANK", unit, 1) then
		return true
	end
	if UnitGroupRolesAssigned(unit) == "TANK" then
		return true
	end

	return false
end

function lib:IsDebuffed(target, debuffSpellId)
	if debuffSpellId then
		if UnitDebuff(target, (GetSpellInfo(debuffSpellId))) then return true end
	end
	for _, debuff in ipairs(debuffs) do
		if debuff == UnitDebuff(target, debuff) then return true end
	end
	return false
end

function lib:IsBuffed(target)
	for _, buff in ipairs(buffs) do
		if buff == UnitBuff(target, buff) then return buff end
	end
	return false
end

function lib:GetMobId(GUID)
	if not GUID then return end
	return tonumber(GUID:sub(6, 10), 16)
end

function lib:findTargetByGUID(id)
	local idType = type(id)
	for i, unit in next, lib.targetlist do
		if UnitExists(unit) and not UnitIsPlayer(unit) then
			local unitId = UnitGUID(unit)
			if idType == "number" then unitId = tonumber(unitId:sub(6, 10), 16) end
			if unitId == id then return unit end
		end
	end
end

do
	frame:Hide()
	frame:SetScript("OnUpdate", function(self, elapsed)
		for name, timer in pairs(lib.timers) do
			timer.elapsed = timer.elapsed + elapsed
			if timer.elapsed > timer.delay then
				timer.func()
				lib:CancelTimer(name)
			end
		end
	end)
end

function lib:ScheduleTimer(name, func, delay)
	if not self.timers then self.timers = {} end
	self.timers[name] = {
		elapsed = 0,
		func = func,
		delay = delay,
	}

	if not frame:IsShown() then frame:Show() end
end

function lib:CancelTimer(name)
	if not name then
		self.timers = {}
		return frame:Hide()
	end

	self.timers[name] = nil
	if not next(self.timers) then self:CancelTimer() end
end

function lib:IsTimerRunning(name)
	return (self.timers and self.timers[name]) and true or false
end

-- param spellId, table
function lib:SpellIdCheck(spellId, table)
        if not table.index then
	  local index = {}
	  for k, v in pairs(table) do
		for i=1, #v[1] do
		  local id = v[1][i]
		  if index[id] then
		    print("ERROR duplicate spellid: "..id)
		  else
		    index[id] = k
		  end
		end
	  end
	  table.index = index
	end
	local k = table.index[spellId]
	if k then
	  return k, unpack(table[k], 2)
	else
	  return false
	end
end

-- range check
function lib:RangeCheck(player)
	local num = GetNumGroupMembers()
	local diff = select(3,GetInstanceInfo())
	for i=1, num do
		local name, _, subgroup = GetRaidRosterInfo(i)
		if name == player then
			if diff == 4 or diff == 6 or diff == 7 then
				if subgroup > 5 then return false end
			else
				if subgroup > 2 then return false end
			end
		end
	end
	return true
end

-- returns true if it handled an event
function lib:GeneralDamageFail(spellId, destName, damage, overkill, timestamp)
	local failName, failType = lib:SpellIdCheck(spellId, generalDamageFail)
	if not failName then
		return false
	end

	if overkill > 0 then -- if its an overkill
		self:Antispam(true, 5, nil, failName, destName, failType, timestamp) -- thats a fail either way
	end
	if OverkillOnly(failName) then return true end -- if its only overkill we can stop here
	if failName and self.CONSTRAINTS[failName] then -- the fail has a damage constraint
		if damage > self.CONSTRAINTS[failName]["Damage Constraint"] then -- if damage is higher than constraint value
			self:Antispam(true, 5, nil, failName, destName, failType, timestamp, damage)
		end
	else -- if it has no damage constraint
		if damage > 0 then
			self:Antispam(true, 5, nil, failName, destName, failType, timestamp)
		end
	end
	return true
end

function lib:Antispam(type, min, max, failName, destName, failType, timestamp, ...)
	local deltaT = timestamp - (self.LastEvent[failName][destName] or 0)
	if type then -- Initial damage allowed
		if deltaT and min and (deltaT > min) then -- min time has to pass between two fails
			self:FailEvent(failName, destName, self[failType], ...)
		end
	else -- Initial damage not allowed
		 -- at leat min time has to pass between fails but cant be more than max
		if deltaT and min and max and (deltaT > min) and (deltaT < max) then
			self:FailEvent(failName, destName, self[failType], ...)
		end
	end
	self.LastEvent[failName][destName] = timestamp
	return
end

function lib:GetDistanceBetweenUnits(unit1, unit2)
	if not UnitExists(unit1) or not UnitExists(unit2) then return end
	if UnitIsDeadOrGhost(unit1) or UnitIsDeadOrGhost(unit2) or not UnitIsConnected(unit1) or not UnitIsConnected(unit2) then return end
	local oldmapid = GetCurrentMapAreaID()
	SetMapToCurrentZone()
	local floors = mapData[(GetMapInfo())]
	local currentFloor = GetCurrentMapDungeonLevel()
	if currentFloor == 0 then currentFloor = 1 end
	local id = floors[currentFloor]
	if id then
		local srcX, srcY = GetPlayerMapPosition(unit1)
		local dstX, dstY = GetPlayerMapPosition(unit2)
		local x = (dstX - srcX) * id[1]
		local y = (dstY - srcY) * id[2]
		SetMapByID(oldmapid)
		return (x*x + y*y) ^ 0.5
	end
	SetMapByID(oldmapid)
end

-------------------------------------------------------------------------
-- Initialization
-------------------------------------------------------------------------

function lib:InitVariables()
	if not self.active then return end

	self.RaidTable = {}
	self.RaidTable2 = {}

	self:InitRaidTable()

	self.LastEvent = {}

	self.targetlist = {"target", "targettarget", "focus", "focustarget", "mouseover", "mouseovertarget"}
	for i = 1, 4 do table.insert(self.targetlist, string.format("boss%d", i)) end
	for i = 1, 4 do table.insert(self.targetlist, string.format("party%dtarget", i)) end
	for i = 1, 40 do table.insert(self.targetlist, string.format("raid%dtarget", i)) end

	-- Last whatever
	for k, v in pairs(failEvents) do
		self.LastEvent[k] = {}
	end

end

function lib:InitRaidTable(raidTable)
	--if next(lib.RaidTable) then return end -- WTF WAS THIS?
	local diff = select(3, GetInstanceInfo())

	for raidindex = 1, GetNumGroupMembers() do
		local name, _, group, _, _, _, _, online = GetRaidRosterInfo(raidindex)
		if (diff == 3 or diff == 5) and group <= 2 and online then -- 10 man
			if not raidTable then
				lib.RaidTable[name] = false
				lib.RaidTable2[name] = false
			elseif raidTable == 1 then
				lib.RaidTable[name] = false
			elseif raidTable == 2 then
				lib.RaidTable2[name] = false
			end
		elseif (diff == 4 or diff == 6 or diff == 7) and group <= 5 and online then -- 25 man
			if not raidTable then
				lib.RaidTable[name] = false
				lib.RaidTable2[name] = false
			elseif raidTable == 1 then
				lib.RaidTable[name] = false
			elseif raidTable == 2 then
				lib.RaidTable2[name] = false
			end
		end
	end
end

-------------------------------------------------------------------------
-- Globals
-------------------------------------------------------------------------

lib.FAIL_TYPE_NOTMOVING		= L["not moving"] -- fails at not moving with probably something on him that triggers on movement
lib.FAIL_TYPE_MOVING		= L["moving"] -- fails at moving out of shit
lib.FAIL_TYPE_NOTSPREADING	= L["not spreading"] -- fails at standing together (think auriaya)
lib.FAIL_TYPE_SPREADING		= L["spreading"] -- fails at not having enough distance between people
lib.FAIL_TYPE_DISPELLING	= L["dispelling"] -- fails at not dispelling something you should be dispelling (not very usable yes, but for completeness)
lib.FAIL_TYPE_NOTDISPELLING	= L["not dispelling"] -- fails at dispelling something you should NOT be dispelling
lib.FAIL_TYPE_WRONGPLACE	= L["not being at the wrong place"] -- fails at not being in the wrong place in the wrong time (cleave, etc)
lib.FAIL_TYPE_NOTCASTING	= L["not casting"] -- casting spells when you shouldnt have
lib.FAIL_TYPE_NOTATTACKING	= L["not attacking"] -- attacking when you shouldnt have
lib.FAIL_TYPE_CASTING		= L["casting"] -- not casting spells when you should have (think malygos phase3, or bloodqueen not biting when you should)
lib.FAIL_TYPE_SWITCHING		= L["switching"] -- not taunting/switching tanks when you're supposed to

-- ### Make sure when you add a new constraint type that it has a localization entry
-- ### remember to remove debug events
--- Default constraints
-- @class table
-- @name lib.CONSTRAINTS
-- @field Description the table holding ["Constraint Type"] = value pairs for failEvents
lib.CONSTRAINTS = {
	--["Fail_Glob -'bal_Maat_HL"] = { ["Damage Constraint"] = 10, ["Tick Constraint"] = 5 },
	["Fail_Heart of Fear_Imperial Vizier Zor'lok_Force and Verve"] = { ["Damage Constraint"] = 90000 },
	["Fail_Heart of Fear_Garalon_Pheromone Trail"] = { ["Time Constraint - Low"] = 2, ["Time Constraint - High"] = 5},
	["Fail_Mogu'shan Vaults_The Stone Guard_Jasper Chains"] = { ["Damage Constraint"] = 35000, ["Time Constraint - High"] = 5 },
	["Fail_Mogu'shan Vaults_The Stone Guard_Cobalt Mine"] = { ["Damage Constraint"] = 300000 },
	["Fail_Mogu'shan Vaults_Feng the Accursed_Epicenter"] = { ["Damage Constraint"] = 100000 },
	["Fail_Mogu'shan Vaults_Feng the Accursed_Arcane Velocity"] = { ["Damage Constraint"] = 110000 },
	["Fail_Mogu'shan Vaults_Feng the Accursed_Arcane Resonance"] = { ["Time Constraint - High"] = 5 },
	["Fail_Mogu'shan Vaults_Elegon_Stability Flux"] = { ["Damage Constraint"] = 60000 },
	["Fail_Terrace of Endless Spring_Tsulong_Sunbeam"] = { ["Time Constraint - High"] = 4 },
	["Fail_Terrace of Endless Spring_Lei Shi_Get Away!"] = { ["Damage Constraint"] = 80000 },
	["Fail_Terrace of Endless Spring_Sha of Fear_Breath of Fear"] = { ["Damage Constraint"] = 100000 },
	["Fail_Terrace of Endless Spring_Tsulong_Dread Shadows"] = { ["Tick Constraint"] = 10, ["Time Constraint - Low"] = 4 },
	["Fail_Throne of Thunder_Council of Elders_Ensnared"] = { ["Tick Constraint"] = 4 },
	["Fail_Throne of Thunder_Iron Qon_Burning Cinder"] = { ["Tick Constraint"] = 5 },
	["Fail_Throne of Thunder_Iron Qon_Frozen Blood"] = { ["Tick Constraint"] = 5 },
	["Fail_Throne of Thunder_Lei Shen_Decapitate"] = { ["Damage Constraint"] = 200000 },
	["Fail_Throne of Thunder_Lei Shen_Thunderstruck"] = { ["Damage Constraint"] = 200000 },
	["Fail_Throne of Thunder_Megaera_Acid Rain"] = { ["Damage Constraint"] = 150000 },
	["Fail_Throne of Thunder_Jin'rokh the Breaker_Lightning Diffusion"] = { ["Time Constraint - High"] = 2 },
	["Fail_Throne of Thunder_Council of Elders_Shadowed Soul"] = { ["Tick Constraint"] = 20 },
	["Fail_Siege of Orgrimmar_Garrosh Hellscream_Exploding Iron Star"] = { ["Damage Constraint"] = 350000 },
	["Fail_Siege of Orgrimmar_Garrosh Hellscream_Whirling Corruption"] = { ["Damage Constraint"] = 100000 },
	["Fail_Siege of Orgrimmar_Kor'kron Dark Shaman_Falling Ash"] = { ["Damage Constraint"] = 600000 },
}

--- Default tanks dont fail list
-- @class table
-- @name lib.TANKS_DONT_FAIL_LIST
-- @see lib:GetTanksDontFailOption()
-- @field Description the table holding [event] = tanks-dont-fail setting pairs for failEvents. The value is true to suppress fails on tanks for supported events
lib.TANKS_DONT_FAIL_LIST = {}
for k, v in pairs(failEvents) do
	 if v[TFP] then
		lib.TANKS_DONT_FAIL_LIST[k] = true
	end
end

--- Default overkill only list
-- @class table
-- @name lib.OVERKILL_ONLY_LIST
-- @see lib:GetOverkillOnlyOption()
-- @field Description the table holding [event] = overkill-only setting pairs for failEvents. The value is true to only report supported events when they are a killing blow.
lib.OVERKILL_ONLY_LIST = {}
for k, v in pairs(failEvents) do
	if v[OKP] then
		lib.OVERKILL_ONLY_LIST[k] = true
	elseif v[OKP] == false then
		lib.OVERKILL_ONLY_LIST[k] = false
	end
end

-------------------------------------------------------------------------
-- EVENT HANDLING
-------------------------------------------------------------------------

do
	local _, etype, f

	frame:SetScript("OnEvent", function (self, event, ...)
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			_, etype = ...
			if etype == "SPELL_MISSED" then  -- lets hack the misses onto the damage event
				local timestamp, _, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, missType,  amountMissed, blocked, absorbed = ...
				local damage, overkill = 0, 0

				lib.SPELL_DAMAGE(lib, timestamp, etype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, damage, overkill, missType, amountMissed, blocked, absorbed)

				return
			end

			f = lib[etype]

			if f then
				f(lib, ...)
			end

			return
		end

		f = lib[event]

		if f then
			f(lib, ...)
		end

	end)
end

function lib:FailEvent(event, playerName, failType, ...)
	if lib.TANKS_DONT_FAIL_LIST[event] and lib:IsTank(playerName) then return end
	if not lib:RangeCheck(playerName) then return end
	-- Don't fire if one of the arguments are missing
	if not playerName or playerName=="" or not failType or failType=="" or not event or event=="" then return end
	callbacks:Fire(event, playerName, failType, ...)
	callbacks:Fire("AnyFail", event, playerName, failType, ...)
end

function lib:GoActive()
	if self.active then return end

	frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	frame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:InitVariables()

	self.active = true

	callbacks:Fire("Fail_Active")
end

function lib:GoInactive()
	if not self.active then return end

	self:InitVariables()

	self.active = nil

	frame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	frame:UnregisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	frame:UnregisterEvent("PLAYER_REGEN_ENABLED")
	frame:UnregisterEvent("CHAT_MSG_MONSTER_EMOTE")

	callbacks:Fire("Fail_Inactive")
end

function lib:checkActive()
	local _,t = IsInInstance()
	if (t == "raid" or t == "party") then
		local oldmapid = GetCurrentMapAreaID()
		SetMapToCurrentZone()
		local mapid = GetCurrentMapAreaID()
		SetMapByID(oldmapid)
		for _,id in pairs(usedZoneIDs) do
		  if mapid == id then
			lib:GoActive()
			return
		  end
		end
	end
	lib:GoInactive()
end

lib.active = true
lib:GoInactive()
lib:checkActive()

function lib:PLAYER_ENTERING_WORLD()
	self:checkActive()
end

function lib:ZONE_CHANGED_NEW_AREA()
	self:checkActive()
end

function lib:PLAYER_REGEN_ENABLED()
	self:InitVariables()
end

function lib:CHAT_MSG_RAID_BOSS_EMOTE(message, sourceName, language, channelName, destName, ...)
--"<262.6 14:52:23> [CHAT_MSG_RAID_BOSS_EMOTE] CHAT_MSG_RAID_BOSS_EMOTE#|TInterface\\Icons\\spell_shaman_earthquake.blp:20|t Garalon senses the passage of Pheromones and begins to cast |cFFFF0000|Hspell:122774|h[Crush]|h|r!#Garalon###Trdksvina##0#0##0#5774##0#false#false", -- [109]
--"<91.7> [CHAT_MSG_RAID_BOSS_EMOTE] CHAT_MSG_RAID_BOSS_EMOTE#|TInterface\\Icons\\spell_shaman_earthquake.blp:20|t Garalon prepares to |cFFFF0000|Hspell:122774|h[Crush]|h|r his opponents!#Garalon###Garalon##0#0##0#701##0#false#false", -- [82]
--"<199.0> [CHAT_MSG_RAID_BOSS_EMOTE] CHAT_MSG_RAID_BOSS_EMOTE#|TInterface\\Icons\\spell_shaman_earthquake.blp:20|t Garalon detects Brylah under him and begins to cast |cFFFF0000|Hspell:122774|h[Crush]|h|r!#Garalon###Brylah##0#0##0#761##0#false#false", -- [295]
	if lib.OVERKILL_ONLY_LIST.ovkoverride then return end
	if message:find("122774") and sourceName ~= destName and not message:find((GetSpellInfo(128573))) then
		self:FailEvent("Fail_Heart of Fear_Garalon_Crush",destName,self["FAIL_TYPE_WRONGPLACE"])
	end
end

function lib:CHAT_MSG_MONSTER_EMOTE(message, sourceName, language, channelName, destName, ...)
--"<385.9> [CHAT_MSG_MONSTER_EMOTE] CHAT_MSG_MONSTER_EMOTE#Legomanxd detonated a Wind Bomb!#Wind Bomb###Legomanxd##0#0##0#244##0#false#false", -- [302]
	if lib.OVERKILL_ONLY_LIST.ovkoverride then return end
	if sourceName == (GetSpellInfo(131830)) then -- Wind Bomb
		self:FailEvent("Fail_Heart of Fear_Wind Lord Mel'jarak_Wind Bomb",destName,self["FAIL_TYPE_MOVING"])
	end
end

function lib:SPELL_DAMAGE(timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, damage, overkill, missType, amountMissed, blocked, absorbed)
	if bit.band(sourceFlags or 0, COMBATLOG_OBJECT_TYPE_GUARDIAN) > 0 or bit.band(destFlags or 0, COMBATLOG_OBJECT_TYPE_GUARDIAN) > 0 or not spellId then return end
	-- Guardian activities ignored after this point
	local isPlayerEvent = bit.band(destFlags or 0, COMBATLOG_OBJECT_TYPE_PLAYER) > 0
	damage = damage ~= "ABSORB" and damage or 0
	overkill = overkill or 0

	if isPlayerEvent and lib:GeneralDamageFail(spellId, destName, damage, overkill, timestamp) then return end

	local failName, failType = lib:SpellIdCheck(spellId, failEvents)
	if failName and isPlayerEvent then
		if OverkillOnly(failName) and overkill <= 0 then
		  return
		end
		if failName == "Fail_Heart of Fear_Blade Lord Ta'yak_Unseen Strike" then
			self.RaidTable2[destName] = GetTime() -- because we use SUCCEDED and that has no timestamp arg
		elseif failName == "Fail_Heart of Fear_Garalon_Pheromone Trail" then
			lib:Antispam(false, self.CONSTRAINTS[failName]["Time Constraint - Low"] , self.CONSTRAINTS[failName]["Time Constraint - High"] , failName, destName, failType, timestamp)
			return
		elseif failName == "Fail_Heart of Fear_Amber-Shaper Un'sok_Amber Explosion" then
			local castedByPlayer = bit.band(sourceFlags or 0, COMBATLOG_OBJECT_TYPE_PLAYER) > 0
			if castedByPlayer then
				lib:Antispam(true, 5, nil, failName, sourceName, failType, timestamp)
			else
				for i=1, GetNumGroupMembers() do
					local name = GetRaidRosterInfo(i)
					if UnitDebuff(name, (GetSpellInfo(122784))) then -- reshape life
						lib:Antispam(true, 5, nil, failName, name, failType, timestamp, sourceName)
					end
				end
			end
			return
		elseif failName == "Fail_Mogu'shan Vaults_The Stone Guard_Jasper Chains" then
			if not self.LastEvent[failName][destName] then return end
			if timestamp - self.LastEvent[failName][destName] > self.CONSTRAINTS[failName]["Time Constraint - High"] and damage > self.CONSTRAINTS[failName]["Damage Constraint"] then
				lib:Antispam(true, 5, nil, failName, destName, failType, timestamp)
				return
			end
		elseif failName == "Fail_Mogu'shan Vaults_The Spirit Kings_Massive Attacks" then
			self.RaidTable[destName] = timestamp
		elseif failName == "Fail_Terrace of Endless Spring_Protectors of the Endless_Lightning Prison" then
			if not UnitIsUnit(destName, sourceName) then
				lib:Antispam(true, 5, nil, failName, sourceName, failType, timestamp)
			end
		elseif failName == "Fail_Mogu'shan Vaults_Feng the Accursed_Arcane Velocity" and damage > self.CONSTRAINTS[failName]["Damage Constraint"] then
			if lib:IsDebuffed(destName) then return end
			lib:Antispam(true, 5, nil, failName, destName, failType, timestamp)
			return
		elseif failName == "Fail_Heart of Fear_Imperial Vizier Zor'lok_Force and Verve" and not lib:IsDebuffed(destName) and damage > self.CONSTRAINTS[failName]["Damage Constraint"] then
			lib:Antispam(true, 5, nil, failName, destName, failType, timestamp)
		elseif failName == "Fail_Mogu'shan Vaults_Feng the Accursed_Epicenter" and damage > self.CONSTRAINTS[failName]["Damage Constraint"] then
			if not self.LastEvent[failName] then
				self:ScheduleTimer("Feng the Accursed_Epicenter", function(timestamp, destName)
					if not self.LastEvent[failName] then
						lib:Antispam(true, 10, nil, failName, destName, failType, timestamp)
					end
				end, 2)
			else
				if timestamp - self.LastEvent[failName] > 7 then
					self:ScheduleTimer("Feng the Accursed_Epicenter", function(timestamp, destName)
						if timestamp then
							if timestamp - self.LastEvent[failName] > 7 then
								lib:Antispam(true, 10, nil, failName, destName, failType, timestamp)
							end
						end
					end, 2)
				end
			end
		elseif failName == "Fail_Mogu'shan Vaults_Elegon_Total Annihilation" and not lib:IsHeroic() then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Mogu'shan Vaults_The Spirit Kings_Undying Shadows" then
			lib:Antispam(false, 2, 10, failName, destName, failType, timestamp)
		elseif failName == "Fail_Heart of Fear_Grand Empress Shek'zeer_Consuming Terror" and not self:IsDebuffed(destName) then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Terrace of Endless Spring_Sha of Fear_Waterspout" and not self:IsDebuffed(destName) and not self:IsBuffed(destName) then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Terrace of Endless Spring_Protectors of the Endless_Expelled Corruption" then
			lib:Antispam(false, 3, 10, failName, destName, failType, timestamp)
		elseif failName == "Fail_Throne of Thunder_Jin'rokh the Breaker_Static Wound Conduction" then
			lib:Antispam(true, 5, nil, failName, sourceName, failType, timestamp)
		elseif failName == "Fail_Throne of Thunder_Jin'rokh the Breaker_Focused Lightning" then
			lib:Antispam(false, 2, 5, failName, destName, failType, timestamp)
		elseif failName == "Fail_Throne of Thunder_Jin'rokh the Breaker_Lightning Fissure" then
			lib:Antispam(false, 2, 5, failName, destName, failType, timestamp)
		elseif failName == "Fail_Throne of Thunder_Horridon_Sand Trap" then
			lib:Antispam(false, 2, 5, failName, destName, failType, timestamp)
		elseif failName == "Fail_Throne of Thunder_Horridon_Living Poison" then
			lib:Antispam(false, 2, 5, failName, destName, failType, timestamp)
		elseif failName == "Fail_Throne of Thunder_Council of Elders_Biting Cold" and not self:IsDebuffed(destName) then
			lib:Antispam(true, 4, nil, failName, destName, failType, timestamp)
		elseif failName == "Fail_Throne of Thunder_Lei Shen_Diffusion Chain" then
			self.RaidTable[destName] = true
			self:ScheduleTimer("Lei Shen_Diffusion Chain", function()
				local counter = 0
				for _, v in pairs(self.RaidTable) do
					if v == true then counter = counter + 1 end
				end
				if counter > 1 then
					for player, v in pairs(self.RaidTable) do
						if v == true then
							self:FailEvent(failName,player,self[failType])
						end
					end
				end
				lib:InitRaidTable(1)
			end, 1)
		elseif failName == "Fail_Throne of Thunder_Lei Shen_Crashing Thunder" then
			lib:Antispam(false, 2, 5, failName, destName, failType, timestamp)
		elseif failName == "Fail_Throne of Thunder_Lei Shen_Summon Ball Lightning" then
			if not self.RaidTable2[destName] then
				self.RaidTable2[destName] = 1
			else
				self.RaidTable2[destName] = self.RaidTable2[destName] + 1
			end
			self:ScheduleTimer("Lei Shen_Summon Ball Lightning", function()
				for player, v in pairs(self.RaidTable2) do
					if type(v) == "number" then
						if v > 1 then
							self:FailEvent(failName,player,self[failType], v)
						end
					end
				end
				lib:InitRaidTable(2)
			end, 2)
		elseif failName == "Fail_Throne of Thunder_Jin'rokh the Breaker_Ionization" then
			if self.LastEvent[failName][destName] then -- aka hit more than once
				lib:Antispam(true, 5, nil, failName, destName, failType, timestamp)
			end
			self.LastEvent[failName][destName] = timestamp
		elseif failName == "Fail_Throne of Thunder_Durumu the Forgotten_Lingering Gaze" then
			lib:Antispam(false, 1, 5, failName, destName, failType, timestamp)
		elseif failName == "Fail_Throne of Thunder_Primordius_Caustic Gas" then
			self.RaidTable[destName] = timestamp
		elseif failName == "Fail_Throne of Thunder_Jin'rokh the Breaker_Lightning Diffusion" then
			lib:Antispam(true, self.CONSTRAINTS[failName]["Time Constraint - High"], nil, failName, destName, failType, timestamp)
		elseif failName == "Fail_Throne of Thunder_Tortos_Crystal Shell" and lib:IsHeroic() and (not absorbed or absorbed == 0) then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Throne of Thunder_Megaera_Cinders" then
			lib:Antispam(false, 2, 5, failName, destName, failType, timestamp)
		elseif failName == "Fail_Throne of Thunder_Primordius_Acidic Explosion" then
			local diff = select(3,GetInstanceInfo())
			for i=1, GetNumGroupMembers() do
				local name, _, subgroup = GetRaidRosterInfo(i)
				if UnitIsUnit(destName, name) then return end
				if diff == 4 or diff == 6 or diff == 7 then
					if subgroup > 5 then return end
				elseif diff == 3 or diff == 5 then
					if subgroup > 2 then return end
				end
				local distance = lib:GetDistanceBetweenUnits(destName, name)
				if type(distance) ~= "number" then return end
				if distance <= 5 then
					lib:Antispam(true, 5, nil, failName, destName, failType, timestamp, name, distance)
				end
			end
		elseif failName == "Fail_Throne of Thunder_Ra-den_Anima Sensitivity" then
			if self.LastEvent[failName][destName] and ((timestamp - self.LastEvent[failName][destName]) > 2) then -- sometimes debuff is applied then damage is taken
				self:FailEvent(failName,destName,self[failType])
			end
		elseif failName == "Fail_Throne of Thunder_Ra-den_Vita Sensitivity" and self:IsDebuffed(destName, 138372) then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Siege of Orgrimmar_The Fallen Protectors_Corruption Kick" then
			lib:Antispam(false, 2, 5, failName, destName, failType, timestamp)
		elseif failName == "Fail_Siege of Orgrimmar_The Fallen Protectors_Dark Meditation" and not self:IsDebuffed(destName) then
			lib:Antispam(true, 5, nil, failName, destName, failType, timestamp)
		elseif failName == "Fail_Siege of Orgrimmar_The Fallen Protectors_Sha Sear" and not self:IsDebuffed(destName) then
			lib:Antispam(true, 5, nil, failName, destName, failType, timestamp)
		elseif failName == "Fail_Siege of Orgrimmar_Kor'kron Dark Shaman_Foul Stream" then
			lib:Antispam(false, 1, 5, failName, destName, failType, timestamp)
		elseif failName == "Fail_Siege of Orgrimmar_Malkorok_Displaced Energy" then
			lib:Antispam(true, 5, nil, failName, sourceName, failType, timestamp)
		elseif failName == "Fail_Siege of Orgrimmar_Malkorok_Seismic Slam" then
			local diff = select(3,GetInstanceInfo())
			for i=1, GetNumGroupMembers() do
				local name, _, subgroup = GetRaidRosterInfo(i)
				if UnitIsUnit(destName, name) then return end
				if diff == 4 or diff == 6 or diff == 7 then
					if subgroup > 5 then return end
				elseif diff == 3 or diff == 5 then
					if subgroup > 2 then return end
				end
				local distance = lib:GetDistanceBetweenUnits(destName, name)
				if type(distance) ~= "number" then return end
				if distance <= 5 then
					lib:Antispam(true, 5, nil, failName, destName, failType, timestamp, name, distance)
				end
			end
		elseif failName == "Fail_Siege of Orgrimmar_Paragons of the Klaxxi_Reacton: Red" then
			if self:IsDebuffed(destName, 142533) then
				-- hit more than once
				if not self.LastEvent[failName][destName] then
					self.LastEvent[failName][destName] = timestamp
				elseif (timestamp - self.LastEvent[failName][destName]) < 2 then
					self.LastEvent[failName][destName] = nil
					lib:Antispam(true, 5, nil, failName, destName, failType, timestamp)
				else
					self.LastEvent[failName][destName] = timestamp
				end
			else
				lib:Antispam(true, 5, nil, failName, destName, failType, timestamp)
			end
		elseif failName == "Fail_Siege of Orgrimmar_Sha of Pride_Aura of Pride" and bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_OUTSIDER) == 8 and bit.band(destFlags, COMBATLOG_OBJECT_AFFILIATION_OUTSIDER) ~= 8 then
			lib:Antispam(true, 5, nil, failName, sourceName, failType, timestamp)
		elseif failName == "Fail_Siege of Orgrimmar_Iron Juggernaut_Napalm Oil" then
			lib:Antispam(false, 2, 5, failName, destName, failType, timestamp)
		elseif failName == "Fail_Siege of Orgrimmar_Spoils of Pandaria_Breath of Fire" and self:IsDebuffed(destName) then
			lib:Antispam(true, 5, nil, failName, destName, failType, timestamp)
		elseif failName == "Fail_Siege of Orgrimmar_Thok the Bloodthirsty_Burning Blood" then
			lib:Antispam(false, 2, 5, failName, destName, failType, timestamp)
		elseif failName == "Fail_Siege of Orgrimmar_Garrosh Hellscream_Annihilate" and overkill > 0 and (damage + overkill) > 300000 then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Siege of Orgrimmar_Immerseus_Sha Bolt" then
			lib:Antispam(false, 2, 5, failName, destName, failType, timestamp)
		end
	end

	local destUnitID = lib:findTargetByGUID(destGUID)
	if destUnitID and not barrierSpellIdExceptions[spellId] then
		local buff = lib:IsBuffed(destUnitID)
		if UnitIsUnit("boss1",destUnitID) or UnitIsUnit("boss2",destUnitID) or UnitIsUnit("boss3",destUnitID) or UnitIsUnit("boss4",destUnitID) or UnitIsUnit("boss5",destUnitID) then
			if lib:IsRaidPet(sourceName) then
				-- pets don't trigger it
				--if buff == (GetSpellInfo(117961)) then -- Impervious Shield
				--	lib:Antispam(true, 5, nil, "Fail_Mogu'shan Vaults_The Spirit Kings_Impervious Shield", lib:IsRaidPet(sourceName), "FAIL_TYPE_NOTATTACKING", timestamp, sourceName.." - "..spellName)
				--elseif buff == (GetSpellInfo(117697)) then -- Shield of Darkness
				--	lib:Antispam(true, 5, nil, "Fail_Mogu'shan Vaults_The Spirit Kings_Shield of Darkness", lib:IsRaidPet(sourceName), "FAIL_TYPE_NOTATTACKING", timestamp, sourceName.." - "..spellName)
				--end
			else
				if buff == (GetSpellInfo(117961)) then -- Impervious Shield
					lib:Antispam(true, 5, nil, "Fail_Mogu'shan Vaults_The Spirit Kings_Impervious Shield", sourceName, "FAIL_TYPE_NOTATTACKING", timestamp, spellName)
				elseif buff == (GetSpellInfo(117697)) then -- Shield of Darkness
					lib:Antispam(true, 5, nil, "Fail_Mogu'shan Vaults_The Spirit Kings_Shield of Darkness", sourceName, "FAIL_TYPE_NOTATTACKING", timestamp, spellName)
				elseif buff == (GetSpellInfo(143593)) and not UnitDebuff(sourceName, (GetSpellInfo(143494))) then -- Defensive Stance, -- Sundering Blow
					local diff = select(3,GetInstanceInfo())
					if diff ~= 5 and diff ~= 6 then -- you probably can hit him in heroic
						lib:Antispam(true, 5, nil, "Fail_Siege of Orgrimmar_General Nazgrim_Defensive Stance", sourceName, "FAIL_TYPE_NOTATTACKING", timestamp, spellName)
					end
				end
			end
		end
	end
end

function lib:SWING_DAMAGE(timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, damage, overkill)
	local isPlayerEvent = bit.band(destFlags or 0, COMBATLOG_OBJECT_TYPE_PLAYER) > 0
	damage = damage ~= "ABSORB" and damage or 0
	overkill = overkill or 0

	local destUnitID = lib:findTargetByGUID(destGUID)
	if destUnitID then
		local buff = lib:IsBuffed(destUnitID)
		if UnitIsUnit("boss1",destUnitID) or UnitIsUnit("boss2",destUnitID) or UnitIsUnit("boss3",destUnitID) or UnitIsUnit("boss4",destUnitID) or UnitIsUnit("boss5",destUnitID) then
			if lib:IsRaidPet(sourceName) then
				--if buff == (GetSpellInfo(117961)) then -- Impervious Shield
				--	lib:Antispam(true, 5, nil, "Fail_Mogu'shan Vaults_The Spirit Kings_Impervious Shield", lib:IsRaidPet(sourceName), "FAIL_TYPE_NOTATTACKING", timestamp, sourceName.." - "..lib.FAIL_TYPE_NOTATTACKING)
				--elseif buff == (GetSpellInfo(117697)) then -- Shield of Darkness
				--	lib:Antispam(true, 5, nil, "Fail_Mogu'shan Vaults_The Spirit Kings_Shield of Darkness", lib:IsRaidPet(sourceName), "FAIL_TYPE_NOTATTACKING", timestamp, sourceName.." - "..lib.FAIL_TYPE_NOTATTACKING)
				--end
			else
				if buff == (GetSpellInfo(117961)) then -- Impervious Shield
					lib:Antispam(true, 5, nil, "Fail_Mogu'shan Vaults_The Spirit Kings_Impervious Shield", sourceName, "FAIL_TYPE_NOTATTACKING", timestamp, lib.FAIL_TYPE_NOTATTACKING)
				elseif buff == (GetSpellInfo(117697)) then -- Shield of Darkness
					lib:Antispam(true, 5, nil, "Fail_Mogu'shan Vaults_The Spirit Kings_Shield of Darkness", sourceName, "FAIL_TYPE_NOTATTACKING", timestamp, lib.FAIL_TYPE_NOTATTACKING)
				elseif buff == (GetSpellInfo(143593)) and not UnitDebuff(sourceName, (GetSpellInfo(143494))) then -- Defensive Stance, -- Sundering Blow
					local diff = select(3,GetInstanceInfo())
					if diff ~= 5 and diff ~= 6 then -- you probably can hit him in heroic
						lib:Antispam(true, 5, nil, "Fail_Siege of Orgrimmar_General Nazgrim_Defensive Stance", sourceName, "FAIL_TYPE_NOTATTACKING", timestamp, lib.FAIL_TYPE_NOTATTACKING)
					end
				end
			end
		end
	end
	if lib:GetMobId(sourceGUID) == 70688 then
		self:FailEvent("Fail_Throne of Thunder_Horridon_Direhorn Spirit",destName,self["FAIL_TYPE_MOVING"])
	elseif lib:GetMobId(sourceGUID) == 71827 and isPlayerEvent then
		self:Antispam(true, 5, nil, "Fail_Siege of Orgrimmar_Kor'kron Dark Shaman_Ashen Wall",destName,self["FAIL_TYPE_MOVING"], timestamp)
	end
	if lib:IsDebuffed(destName) then
		local num = GetNumGroupMembers()
		local diff = select(3,GetInstanceInfo())
		for i=1, num do
			local name, _, subgroup = GetRaidRosterInfo(i)
			if diff == 4 or diff == 6 or diff == 7 then -- XXX this might need to be able to handle flex raid
				if subgroup > 5 then return end
			elseif diff == 3 or diff == 5 then
				if subgroup > 2 then return end
			end
			if lib:IsTank(name) and not UnitIsUnit(name, destName) and lib:GetMobId(sourceGUID) == 71734 then
				self:FailEvent("Fail_Siege of Orgrimmar_Sha of Pride_Wounded Pride",name,self["FAIL_TYPE_SWITCHING"])
			end
		end
	end
end

--function lib:SWING_MISSED(timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags)
--	local isPlayerEvent = bit.band(destFlags or 0, COMBATLOG_OBJECT_TYPE_PLAYER) > 0
--
--
--end

function lib:SPELL_INTERRUPT(timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, interruptedSpellId, interruptedSpellName, interruptedSpellSchool)
	local isPlayerEvent = bit.band(destFlags or 0, COMBATLOG_OBJECT_TYPE_PLAYER) > 0

	if lib.OVERKILL_ONLY_LIST.ovkoverride then return end
	local failName, failType = lib:SpellIdCheck(spellId, failEvents)
	if failName and isPlayerEvent then
		if failName == "Fail_Throne of Thunder_Dark Animus_Interrupting Jolt" then
			self:FailEvent(failName,destName,self[failType], interruptedSpellName)
		end
	end
end

function lib:SPELL_CAST_START(timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool)
	if spellId == 138732 then -- Ionization
		self.LastEvent["Fail_Throne of Thunder_Jin'rokh the Breaker_Ionization"] = {}
	end
end

function lib:SPELL_INSTAKILL(timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool)
	local isPlayerEvent = bit.band(destFlags or 0, COMBATLOG_OBJECT_TYPE_PLAYER) > 0

	local failName, failType = lib:SpellIdCheck(spellId, failEvents)
	if failName and isPlayerEvent then
		if failName == "Fail_Terrace of Endless Spring_Sha of Fear_Eternal Darkness" then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Throne of Thunder_Durumu the Forgotten_Force of Will" then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Siege of Orgrimmar_Thok the Bloodthirsty_Chomp" then
			self:FailEvent(failName,destName,self[failType])
		end
	end
end

function lib:SPELL_PERIODIC_DAMAGE(timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, damage, overkill)
	local isPlayerEvent = bit.band(destFlags or 0, COMBATLOG_OBJECT_TYPE_PLAYER) > 0
	damage = damage ~= "ABSORB" and damage or 0
	overkill = overkill or 0

	if isPlayerEvent and lib:GeneralDamageFail(spellId, destName, damage, overkill, timestamp) then return end

    local failName, failType = lib:SpellIdCheck(spellId, failEvents)
	if failName and isPlayerEvent then
		if OverkillOnly(failName) and overkill <= 0 then
	  	  return
	  	end
		if failName == "Fail_Mogu'shan Vaults_The Stone Guard_Amethyst Pool" then
			lib:Antispam(false, 2, 5, failName, destName, failType, timestamp)
			return
		elseif failName == "Fail_Throne of Thunder_Jin'rokh the Breaker_Electrified Waters" then
			lib:Antispam(true, 5, nil, failName, destName, failType, timestamp)
			return
		elseif failName == "Fail_Siege of Orgrimmar_Paragons of the Klaxxi_Noxious Vapor" then
			lib:Antispam(false, 2, 5, failName, destName, failType, timestamp)
			return
		elseif failName == "Fail_Siege of Orgrimmar_Paragons of the Klaxxi_Caustic Amber" then
			lib:Antispam(false, 2, 5, failName, destName, failType, timestamp)
			return
		end
	end

end

function lib:SPELL_AURA_APPLIED(timestamp, auratype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, auraType)
	local isPlayerEvent = bit.band(destFlags or 0, COMBATLOG_OBJECT_TYPE_PLAYER) > 0

	if lib.OVERKILL_ONLY_LIST.ovkoverride then return end
	if spellId == 115811 then -- Nullification Barrier casted by a tank
		self.LastEvent["Fail_Mogu'shan Vaults_Feng the Accursed_Epicenter"] = timestamp
	end

	local failName, failType = lib:SpellIdCheck(spellId, failEvents)
	if failName and isPlayerEvent then
		if failName == "Fail_Heart of Fear_Blade Lord Ta'yak_Wind Strike" then
			self.RaidTable[destName] = timestamp
			if not self.LastEvent[failName] or type(self.LastEvent[failName]) == "table" then
				self.LastEvent[failName] = 1
			else
				self.LastEvent[failName] = self.LastEvent[failName] + 1
			end
			self:ScheduleTimer("Blade Lord Ta'yak_Wind Strike", function()
				if self.LastEvent[failName] > 1 then
					for name, lastTime in pairs(lib.RaidTable) do
						if type(lastTime) == "number" and not UnitIsDeadOrGhost(name) then
							self:FailEvent(failName,name,self[failType])
						end
					end
				end
				self.LastEvent[failName] = 0
				lib:InitRaidTable(1)
			end, 1)
			return
		elseif failName == "Fail_Heart of Fear_Grand Empress Shek'zeer_Servant of the Empress" then
			local num = GetNumGroupMembers()
			local diff = select(3,GetInstanceInfo())
			for i=1, num do
				local name, _, subgroup = GetRaidRosterInfo(i)
				if diff == 4 or diff == 6 or diff == 7 then
					if subgroup > 5 then return end
				elseif diff == 3 or diff == 5 then
					if subgroup > 2 then return end
				end
				if lib:IsTank(name) and not self:IsDebuffed(name) then
					self:FailEvent(failName,name,self[failType])
				end
			end
		elseif failName == "Fail_Mogu'shan Vaults_The Stone Guard_Jasper Chains" then
			self.LastEvent[failName][destName] = timestamp
		elseif failName == "Fail_Mogu'shan Vaults_Feng the Accursed_Arcane Resonance" then
			self.LastEvent[failName][destName] = timestamp
		elseif failName == "Fail_Mogu'shan Vaults_The Spirit Kings_Pillage" then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Terrace of Endless Spring_Tsulong_Sunbeam" then
			self.LastEvent[failName][destName] = timestamp
		elseif failName == "Fail_Mogu'shan Vaults_Feng the Accursed_Lightning Charge" and not self:IsBuffed(destName) then
			self.LastEvent[failName][destName] = timestamp
		elseif failName == "Fail_Heart of Fear_Wind Lord Mel'jarak_Amber Prison" then
			-- XXX this could get lot more sophisticated
			if spellId == 121881 then  -- initial aura
				lib.RaidTable[destName] = true
			elseif spellId == 121885 and not lib.RaidTable[destName] then -- actual prison
				self:FailEvent(failName,destName,self[failType])
			end
		elseif failName == "Fail_Throne of Thunder_Lei Shen_Overcharge" then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Throne of Thunder_Primordius_Mutate Player" then
			lib:Antispam(true, 5, nil, failName, destName, failType, timestamp)
		elseif failName == "Fail_Throne of Thunder_Twin Consorts_Slumber Spores" then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Throne of Thunder_Ra-den_Anima Sensitivity" then
			self.LastEvent[failName][destName] = timestamp
		elseif failName == "Fail_Siege of Orgrimmar_The Fallen Protectors_Gouge" then
			self.LastEvent[failName][destName] = timestamp
		end
	end

end

function lib:SPELL_AURA_APPLIED_DOSE(timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, auraType, stack)
	local isPlayerEvent = bit.band(destFlags or 0, COMBATLOG_OBJECT_TYPE_PLAYER) > 0

	if lib.OVERKILL_ONLY_LIST.ovkoverride then return end
	local failName, failType = lib:SpellIdCheck(spellId, failEvents)
	if failName and isPlayerEvent then
		if failName == "Fail_Mogu'shan Vaults_Feng the Accursed_Arcane Resonance" then
			if not self.LastEvent[failName][destName] then return end
			if timestamp - self.LastEvent[failName][destName] > self.CONSTRAINTS[failName]["Time Constraint - High"] then
				self:FailEvent(failName,destName,self[failType],stack)
			end
		elseif failName == "Fail_Terrace of Endless Spring_Protectors of the Endless_Corrupted Essence" and stack == 10 then
			self:FailEvent(failName,destName,self[failType],stack)
		elseif failName == "Fail_Terrace of Endless Spring_Tsulong_Dread Shadows" and stack >= self.CONSTRAINTS[failName]["Tick Constraint"] and stack % self.CONSTRAINTS[failName]["Time Constraint - Low"] == 0 then
			self:FailEvent(failName,destName,self[failType],stack)
		elseif failName == "Fail_Throne of Thunder_Council of Elders_Ensnared" and stack >= self.CONSTRAINTS[failName]["Tick Constraint"] then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Throne of Thunder_Council of Elders_Frigid Assault" then
			for i=1, GetNumGroupMembers() do
				local name = GetRaidRosterInfo(i)
				if self:RangeCheck(name) and self:IsTank(name) and name ~= destName then
					self:FailEvent(failName,destName,self[failType])
				end
			end
		elseif failName == "Fail_Throne of Thunder_Iron Qon_Burning Cinder" and stack >= self.CONSTRAINTS[failName]["Tick Constraint"] then
			lib:Antispam(true, nil, 5, failName, destName, failType, timestamp, stack)
		elseif failName == "Fail_Throne of Thunder_Iron Qon_Electrified" and not self:IsDebuffed(destName) then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Throne of Thunder_Iron Qon_Frozen Blood" and stack >= self.CONSTRAINTS[failName]["Tick Constraint"] then
			lib:Antispam(true, nil, 5, failName, destName, failType, timestamp, stack)
		elseif failName == "Fail_Throne of Thunder_Primordius_Mutate Player" and self:IsDebuffed(destName) then
			self:FailEvent(failName,destName,self[failType])
		elseif failName == "Fail_Throne of Thunder_Council of Elders_Shadowed Soul" and stack >= self.CONSTRAINTS[failName]["Tick Constraint"] then
			lib:Antispam(true, nil, 10, failName, destName, failType, timestamp, stack)
		end
	end

end

function lib:UNIT_SPELLCAST_SUCCEEDED(unitId, spellName, rank, lineId, spellId)
	if lib.OVERKILL_ONLY_LIST.ovkoverride then return end
	local failName, failType = lib:SpellIdCheck(spellId, failEvents)
	if failName then
		if failName == "Fail_Heart of Fear_Blade Lord Ta'yak_Unseen Strike" then
			self:ScheduleTimer("Blade Lord Ta'yak_Unseen Strike", function()
				for name, lastTime in pairs(lib.RaidTable2) do
					if type(lastTime) == "number" and not UnitIsDeadOrGhost(name) then
						if (GetTime() - lastTime) > 4 then
							self:FailEvent(failName,name,self[failType])
						end
					elseif type(lastTime) == "boolean" and not UnitIsDeadOrGhost(name) then
						self:FailEvent(failName,name,self[failType])
					end
				end
				lib:InitRaidTable(2)
			end, 7)
			return
		end
	end
end

function lib:SPELL_CAST_SUCCESS(timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool)

	if lib.OVERKILL_ONLY_LIST.ovkoverride then return end
	local failName, failType = lib:SpellIdCheck(spellId, failEvents)
	if failName then
		if failName == "Fail_Mogu'shan Vaults_The Spirit Kings_Massive Attacks" then
			self:ScheduleTimer("The Spirit Kings_Massive Attacks", function()
				for name, lastTime in pairs(lib.RaidTable) do
					if type(lastTime) == "number" and not UnitIsDeadOrGhost(name) then
						if (timestamp - lastTime) > 2 then
							self:FailEvent(failName,name,self[failType])
						end
					elseif type(lastTime) == "boolean" and not UnitIsDeadOrGhost(name) then
						self:FailEvent(failName,name,self[failType])
					end
				end
				lib:InitRaidTable()
			end, 3)
			return
		elseif failName == "Fail_Throne of Thunder_Primordius_Caustic Gas" then
			self:ScheduleTimer("Primordius_Caustic Gas", function()
				for name, lastTime in pairs(lib.RaidTable) do
					if type(lastTime) == "number" and not UnitIsDeadOrGhost(name) then
						if (timestamp - lastTime) > 2 then
							self:FailEvent(failName,name,self[failType])
						end
					elseif type(lastTime) == "boolean" and not UnitIsDeadOrGhost(name) then
						self:FailEvent(failName,name,self[failType])
					end
				end
				lib:InitRaidTable()
			end, 3)
			return
		elseif failName == "Fail_Siege of Orgrimmar_Sha of Pride_Overcome" then
			local unit, power
			for i=1, GetNumGroupMembers() do
				unit = GetRaidRosterInfo(i)
				power = UnitPower(unit, ALTERNATE_POWER_INDEX)
				if power == 100 then
					self:FailEvent(failName,unit,self[failType])
				end
			end
		end
	end

end

--function lib:SPELL_PERIODIC_HEAL(timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, overhealing, absorbed, critical)
--	local isPlayerEvent = bit.band(destFlags or 0, COMBATLOG_OBJECT_TYPE_PLAYER) > 0
--	if self.RaidTable[destName] and not deepCorruptionSpellIdExceptions[spellId] then
----		lib:Antispam(true, 3, nil, "Fail_Dragon Soul_Yor'sahj the Unsleeping_Deep Corruption", sourceName, lib.FAIL_TYPE_NOTCASTING, timestamp, spellName)
--		return
--	end
--end

--function lib:SPELL_HEAL(timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, overhealing, absorbed, critical)
--	local isPlayerEvent = bit.band(destFlags or 0, COMBATLOG_OBJECT_TYPE_PLAYER) > 0
--
--end
--
function lib:SPELL_ENERGIZE(timestamp, etype, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, amount, powerType)
	local isPlayerEvent = bit.band(destFlags or 0, COMBATLOG_OBJECT_TYPE_PLAYER) > 0

	local failName, failType = lib:SpellIdCheck(spellId, failEvents)
	if failName then
		if failName == "Fail_Siege of Orgrimmar_Norushen_Corrupt" then
			-- more than one guy gets hit, actually not fail for one of them, but we can't know which one was the stupposed to be
			-- maybe could assume tanks never fail
			if type(self.LastEvent[failName]) == "number" and ((timestamp - self.LastEvent[failName]) < 1) then
				self:FailEvent(failName,destName,self[failType])
			end
			self.LastEvent[failName] = timestamp
		end
	end
end

function lib:SPELL_DISPEL(timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, extraSpellId, extraSpellName)
	local failName, failType = lib:SpellIdCheck(spellId, failEvents)
	if failName then
		if failName == "Fail_Throne of Thunder_Jin'rokh the Breaker_Ionization Conduction" and self:IsDebuffed(destName) then
			self:FailEvent(failName,sourceName,self[failType])
		end
	end
end

function lib:SPELL_AURA_REMOVED(timestamp, type, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool)
	local isPlayerEvent = bit.band(destFlags or 0, COMBATLOG_OBJECT_TYPE_PLAYER) > 0

	local failName, failType = lib:SpellIdCheck(spellId, failEvents)
	if failName and isPlayerEvent then
		if failName == "Fail_Terrace of Endless Spring_Tsulong_Sunbeam" then
			if not self.LastEvent[failName][destName] then return end
			if timestamp - self.LastEvent[failName][destName] > self.CONSTRAINTS[failName]["Time Constraint - High"] then
				self:FailEvent(failName,destName,self[failType])
			end
		end
	elseif failName == "Fail_Heart of Fear_Wind Lord Mel'jarak_Amber Prison" then
		if spellId == 121885 then
			lib.RaidTable[destName] = false
		end
	elseif failName == "Fail_Throne of Thunder_Ra-den_Anima Sensitivity" then
		self.LastEvent[failName][destName] = false
	end
end

