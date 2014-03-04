-- German localization by Haldamir of Gorgonnash
if (GetLocale() == "deDE") then

-- Namen der Boni
BONUSSCANNER_NAMES = {	
--Base Stats
	STR 		= "Stärke",
	AGI 		= "Beweglichkeit",
	STA 		= "Ausdauer",
	INT 		= "Intelligenz",
	SPI 		= "Willenskraft",
	ARMOR 		= "Verstärkte Rüstung",

--Resistances
	ARCANERES 	= "Arkanwiderstand",	
	FIRERES 	= "Feuerwiderstand",
	NATURERES 	= "Naturwiderstand",
	FROSTRES 	= "Frostwiderstand",
	SHADOWRES 	= "Schattenwiderstand",

--SKills
	FISHING 	= "Angeln",
	MINING 		= "Bergbau",
	HERBALISM 	= "Kräuterkunde",
	SKINNING 	= "Kürschnerei",
	DEFENSE 	= "Verteidigungswertung",

--Weapon Skills
	AXERATING	= "Axe rating", --TRANSLATE
	SWORDRATING	= "Sword Rating", --TRANSLATE
	MACERATING	= "Mace Rating", --TRANSLATE
	DAGGERRATING	= "Dagger Rating", --TRANSLATE
	BOWRATING	= "Bow Rating", --TRANSLATE
	XBOWRATING	= "Crossbow Rating", --TRANSLATE
	GUNRATING	= "Gun Rating", --TRANSLATE


--Abilities
	BLOCK		= "Blockrate",
	BLOCKVALUE	= "Blockwert",
	DODGE 		= "Ausweichrate",
	PARRY 		= "Parierrate",
	RESILIENCE	= "Resilience Rating", --TRANSLATE

--Attack Power
	ATTACKPOWER	= "Angriffskraft",
	RANGEDATTACKPOWER = "Distanzangriffskraft",
--	ATTACKPOWERBEAST	= "Angriffskraft gegen Wildtiere",
	ATTACKPOWERUNDEAD	= "Angriffskraft gegen Untote",
	ATTACKPOWERFERAL	= "Angriffskraft in feral form",
	
--Critical

	CRIT 		= "Kritische Trefferwertung",
	SPELLCRIT 	= "Krit. Zaubertrefferwertung",
	RANGEDCRIT 	= "Krit. Schüsse",
	HOLYCRIT 	= "Krit. Heiligzauber",

--Hit
	TOHIT 		= "Trefferwertung",
	RANGEDHIT	= "Distanztrefferwertung",
	SPELLTOHIT 	= "Zaubertrefferwertung",

--Spell Damage/healing
	DMG 		= "Zauberschaden",
	DMGUNDEAD	= "Zauberschaden gegen Untote",
	DMGWEAPON	= "Weapon Damage", --TRANSLATE
	ARCANEDMG 	= "Arkanschaden",
	FIREDMG 	= "Feuerschaden",
	FROSTDMG 	= "Frostschaden",
	HOLYDMG 	= "Heiligschaden",
	NATUREDMG 	= "Naturschaden",
	SHADOWDMG 	= "Schattenschaden",
	SPELLPEN 	= "Zauberdurchschlag",
	HEAL 		= "Heilung",

--Regen
	HEALTHREG 	= "Lebensregeneration",
	MANAREG 	= "Manaregeneration",

--Health/mana
	HEALTH 		= "Lebenspunkte",
	MANA 		= "Manapunkte",	
};

-- Pr�fixe f�r passive und Set-Boni:
BONUSSCANNER_PREFIX_EQUIP = "Anlegen: ";
BONUSSCANNER_PREFIX_SET = "Set: ";
BONUSSCANNER_PREFIX_SOCKET = "Socket Bonus: "; --TRANSLATE
-- Suchmuster f�r passive Boni. Wird auf Zeilen angewandt, die mit obigen Pr�fixen beginnen.
BONUSSCANNER_PATTERNS_PASSIVE = {
--Base Stats
	{ pattern = "Erhöht Verteidigungswertung um (%d+)%.", effect = "DEFENSE" },

--Weapon Skills
--TRANSLATE	{ pattern = "Increases axe skill rating by (%d+)%.", effect = "AXERATING" },
--TRANSLATE	{ pattern = "Increases sword skill rating by (%d+)%.", effect = "SWORDRATING" },
--TRANSLATE	{ pattern = "Increases mace skill rating by (%d+)%.", effect = "MACERATING" },
--TRANSLATE	{ pattern = "Increases dagger skill rating by (%d+)%.", effect = "DAGGERRATING" },
--TRANSLATE	{ pattern = "Increases Bow skill rating by (%d+)%.", effect = "BOWRATING" },
--TRANSLATE	{ pattern = "Increases Crossbow skill rating by (%d+)%.", effect = "XBOWRATING" },
--TRANSLATE	{ pattern = "Increases Gun skill rating by (%d+)%.", effect = "GUNRATING" },

-- Abilities
	{ pattern = "Erhöht Eure Blockwertung um (%d+)%.", effect = "BLOCK" },
	{ pattern = "Erhöht den Blockwert eures Schildes um (%d+)%.", effect = "BLOCKVALUE" },
	{ pattern = "Erhöht Eure Ausweichwertung um (%d+)%.", effect = "DODGE" },
	{ pattern = "Erhöht Eure Parierwertung um (%d+)%.", effect = "PARRY" },
--TRANSLATE	{ pattern = "Improves your resilience rating by (%d+)%.", effect = "RESILIENCE" },


--Crit
	{ pattern = "Erhöht Eure kritische Trefferwertung um (%d+)%.", effect = "CRIT" },
--TRANSLATE	{ pattern = "Improves critical strike rating by (%d+)%.", effect = "CRIT" },
	{ pattern = "Erhöht Eure kritische Zaubertrefferwertung um (%d+)%.", effect = "SPELLCRIT" },

--Damage/Heal
	{ pattern = "Erhöht durch Arkanzauber und Arkaneffekte zugefügten Schaden um bis zu (%d+)%.", effect = "ARCANEDMG" },
	{ pattern = "Erhöht durch Feuerzauber und Feuereffekte zugefügten Schaden um bis zu (%d+)%.", effect = "FIREDMG" },
	{ pattern = "Erhöht durch Frostzauber und Frosteffekte zugefügten Schaden um bis zu (%d+)%.", effect = "FROSTDMG" },
	{ pattern = "Erhöht durch Heiligzauber und Heiligeffekte zugefügten Schaden um bis zu (%d+)%.", effect = "HOLYDMG" },
	{ pattern = "Erhöht durch Naturzauber und Natureffekte zugefügten Schaden um bis zu (%d+)%.", effect = "NATUREDMG" },
	{ pattern = "Erhöht durch Schattenzauber und Schatteneffekte zugefügten Schaden um bis zu (%d+)%.", effect = "SHADOWDMG" },
	{ pattern = "Erhöht durch Zauber und Effekte verursachte Heilung um bis zu (%d+)%.", effect = "HEAL" },
	{ pattern = "Erhöht durch Zauber und magische Effekte zugefügten Schaden und Heilung um bis zu (%d+)%.", effect = {"HEAL","DMG"} },
	{ pattern = "Erhöht durch Zauber und magische Effekte zugefügten Schaden gegen Untote um bis zu (%d+)", effect = "DMGUNDEAD" },
--Attack power
	{ pattern = "Erhöht die Angriffskraft um (%d+)%.", effect = "ATTACKPOWER" },
	{ pattern = "Erhöht die Distanzangriffskraft um (%d+)%.", effect = "RANGEDATTACKPOWER" },
	{ pattern = "Erhöht die Angriffskraft in Katzengestalt, Bärengestalt, Terrorbärengestalt oder Mondkingestalt um (%d+)%.", effect = "ATTACKPOWERFERAL" },
	{ pattern = "Erhöht die Angriffskraft im Kampf gegen Untote um (%d+)%.", effect = "ATTACKPOWERUNDEAD" },
--Regen

	{ pattern = "Stellt alle 5 Sek%. (%d+) Gesundheit wieder her%.", effect = "HEALTHREG" },

	{ pattern = "Stellt alle 5 Sek%. (%d+) Mana wieder her%.", effect = "MANAREG" },
--Hit
	{ pattern = "Erhöht Eure Trefferwertung um (%d+)%.", effect = "TOHIT" },
--TRANSLATE { pattern = "Improves hit rating by (%d+)%.", effect = "TOHIT" },
	{ pattern = "Erhöht Eure Zaubertrefferwertung um (%d+)%.", effect = "SPELLTOHIT" },

--Penetration
	{ pattern = "Verringert den Widerstand des Ziels gegen Eure Zauber um (%d+).", effect = "SPELLPEN" }

-- Atiesh patterns
--TRANSLATE	{ pattern = "Increases healing done by magical spells and effects of all party members within %d+ yards by up to (%d+)%.", effect = "HEAL" }, --Priest
--TRANSLATE	{ pattern = "Increases your spell damage by up to (%d+) and your healing by up to (%d+)%.", effect = {"DMG","HEAL"} }, --Priest
--TRANSLATE	{ pattern = "Increases damage and healing done by magical spells and effects of all party members within %d+ yards by up to (%d+)%.", effect = {"HEAL", "DMG"} }, --Warlock
--TRANSLATE	{ pattern = "Restores (%d+) mana per 5 seconds to all party members within %d+ yards%.", effect = "MANAREG" }, -- Druid
--TRANSLATE	{ pattern = "Increases the spell critical strike rating of all party members within %d+ yards by (%d+)%.", effect = "SPELLCRIT" }, -- Mage
};

-- generic patterns have the form "+xx bonus" or "bonus +xx" with an optional % sign after the value.

-- Zuerst wird versucht den "Bonus"-String in der folgenden Tabelle nachzuschlagen
BONUSSCANNER_PATTERNS_GENERIC_LOOKUP = {
	["Alle Werte"] 			= {"STR", "AGI", "STA", "INT", "SPI"},
	["Stärke"]			= "STR",
	["Beweglichkeit"]		= "AGI",
	["Ausdauer"]			= "STA",
	["Intelligenz"]			= "INT",
	["Willenskraft"] 		= "SPI",

	["Alle Widerstandsarten"] 	= { "ARCANERES", "FIRERES", "FROSTRES", "NATURERES", "SHADOWRES"},

	["Angeln"]			= "FISHING",
	["Angelköder"]			= "FISHING",
	["Increased Fishing"]		= "FISHING",
	["Bergbau"]			= "MINING",
	["Kräuterkunde"]		= "HERBALISM",
	["Kürschnerei"]		= "SKINNING",
	["Verteidigung"]		= "DEFENSE",
	["Verteidigungsfertigkeit"] 	= "DEFENSE",

	["Angriffskraft"] 		= "ATTACKPOWER",
--	["Angriffskraft im Kampf gegen Untote"] 		= "ATTACKPOWERUNDEAD",
	["Angriffskraft in Katzengestalt, Bärengestalt und Terrorbärengestalt"] = "ATTACKPOWERFERAL",

	["Ausweichen"] 			= "DODGE",
	["Blocken"]			= "BLOCK",
	["Blockung"]			= "BLOCK",
	["Blockwert"]			= "BLOCKVALUE",

	["Trefferchance"]		= "TOHIT",
--TRANSLATE	["Hit Rating"] 		= "TOHIT",
	["Zaubertrefferchance"]		= "SPELLTOHIT",

	["Distanzangriffskraft"] 	= "RANGEDATTACKPOWER",
	["Gesundheit alle 5 Sek"]	= "HEALTHREG",
	["Heilzauber"] 			= "HEAL",
	["Erhöht Heilung"] 		= "HEAL",
	["Heilung und Zauberschaden"]	= {"HEAL", "DMG"},
	["Schaden and Heilzauber"]	= {"HEAL", "DMG"},
	["Zauberschaden und Heilung"]	= {"HEAL", "DMG"},	
	["Mana alle 5 Sek"] 		= "MANAREG",
	["Manaregeneration"]		= "MANAREG",
	["Zauberschaden"]		= {"HEAL", "DMG"},

	["Kritisch"]			= "CRIT",
	["Kritischer Treffer"]		= "CRIT",
--TRANSLATE	["Critical Strike Rating"]	="CRIT",	--Inscribed Flame Spessarite

	["Schaden"]			= "DMG",
	["Gesundheit"]			= "HEALTH",
	["HP"]				= "HEALTH",
	["Mana"]			= "MANA",
	["Rüstung"]			= "ARMOR",
	["Verstärkte Rüstung"]	= "ARMOR",
	["Heilung"]			= "HEAL",
};	

-- Jetzt wird versucht ob eines der Stage 1 und eines der Stage 2 Muster passt und daraus ein Effect-String zusammengesetzt.
BONUSSCANNER_PATTERNS_GENERIC_STAGE1 = {
	{ pattern = "Arkan", 	effect = "ARCANE" },	
	{ pattern = "Feuer", 	effect = "FIRE" },	
	{ pattern = "Frost", 	effect = "FROST" },	
	{ pattern = "Heilig", 	effect = "HOLY" },	
	{ pattern = "Schatten", effect = "SHADOW" },	
	{ pattern = "Natur", 	effect = "NATURE" }
}; 	

BONUSSCANNER_PATTERNS_GENERIC_STAGE2 = {
	{ pattern = "widerst", 	effect = "RES" },	
	{ pattern = "schaden", 	effect = "DMG" },
	{ pattern = "effekte", 	effect = "DMG" }
}; 	

-- Zuletzt, falls immer noch kein Treffer vorliegt wird noch auf einige spezielle Verzauberungen �berpr�ft.
BONUSSCANNER_PATTERNS_OTHER = {
	{ pattern = "Manaregeneration (%d+) pro 5 Sek%.", effect = "MANAREG" },	

	{ pattern = "Schwaches Zauberöl", effect = {"DMG", "HEAL"}, value = 8 },
	{ pattern = "Geringes Zauberöl", effect = {"DMG", "HEAL"}, value = 16 },
	{ pattern = "Zauberöl", effect = {"DMG", "HEAL"}, value = 24 },
	{ pattern = "Hervorragendes Zauberöl", effect = {"DMG", "HEAL", "SPELLCRIT"}, value = {36, 36, 14} },

	{ pattern = "Schwaches Manaöl", effect = "MANAREG", value = 4 },
	{ pattern = "Geringes Manaöl", effect = "MANAREG", value = 8 },
	{ pattern = "Hervorragendes Manaöl", effect = { "MANAREG", "HEAL"}, value = {12, 25} },
	
	{ pattern = "Eterniumangelschnur", effect = "FISHING", value = 5 }, 
	
--	{ pattern = "Heilung %+31 und 5 Mana pro 5 Sek%.", effect = { "MANAREG", "HEAL"}, value = {5, 31} },
--	{ pattern = "Ausdauer %+16 und Armor %+100", effect = { "STA", "ARMOR"}, value = {16, 100} },
--	{ pattern = "Attack Power %+26 and %+1%% Critical Strike", effect = { "ATTACKPOWER", "CRIT"}, value = {26, 1} },
--	{ pattern = "Spell Damage %+15 and %+1%% Spell Critical Strike", effect = { "DMG", "HEAL", "SPELLCRIT"}, value = {15, 15, 1} },

};
end