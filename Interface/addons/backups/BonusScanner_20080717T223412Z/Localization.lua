-- bonus names
BONUSSCANNER_NAMES = {	
--Base Stats
	STR 		= "Strength",
	AGI 		= "Agility",
	STA 		= "Stamina",
	INT 		= "Intellect",
	SPI 		= "Spirit",
	ARMOR 		= "Reinforced Armor",

--Resistances
	ARCANERES 	= "Arcane Resistance",	
	FIRERES 	= "Fire Resistance",
	NATURERES 	= "Nature Resistance",
	FROSTRES 	= "Frost Resistance",
	SHADOWRES 	= "Shadow Resistance",

--SKills
	FISHING 	= "Fishing",
	MINING 		= "Mining",
	HERBALISM 	= "Herbalism",
	SKINNING 	= "Skinning",
	DEFENSE 	= "Defense",

--Weapon Skills
	AXERATING	= "Axe rating",
	SWORDRATING	= "Sword Rating",
	MACERATING	= "Mace Rating",
	DAGGERRATING	= "Dagger Rating",
	BOWRATING	= "Bow Rating",
	XBOWRATING	= "Crossbow Rating",
	GUNRATING	= "Gun Rating",


--Abilities
	BLOCK		= "Block Rating",
	BLOCKVALUE	= "Block value",
	DODGE 		= "Dodge Rating",
	PARRY 		= "Parry Rating",
	RESILIENCE	= "Resilience Rating", --TBC

--Attack Power
	ATTACKPOWER		= "Attack Power",
	RANGEDATTACKPOWER	= "Ranged Attack Power",
--	ATTACKPOWERBEAST	= "Attack Power against Beasts",
	ATTACKPOWERUNDEAD	= "Attack Power against Undead",
	ATTACKPOWERFERAL	= "Attack Power in feral form",
	
--Critical

	CRIT 		= "Crit. Rating",
	SPELLCRIT 	= "Crit. Spell Rating",
	RANGEDCRIT 	= "Crit. Shots",
	HOLYCRIT 	= "Crit. Holy Spell",

--Hit
	TOHIT 		= "Hit Rating",
	RANGEDHIT	= "Ranged Hit Rating",
	SPELLTOHIT 	= "Spell Hit Rating",

--Spell Damage/healing
	DMG 		= "Spell Damage",
	DMGUNDEAD	= "Spell Damage against Undead",
	DMGWEAPON	= "Weapon Damage",
	ARCANEDMG 	= "Arcane Damage",
	FIREDMG 	= "Fire Damage",
	FROSTDMG 	= "Frost Damage",
	HOLYDMG 	= "Holy Damage",
	NATUREDMG 	= "Nature Damage",
	SHADOWDMG 	= "Shadow Damage",
	SPELLPEN 	= "Spell Penetration",
	HEAL 		= "Healing",

--Regen
	HEALTHREG 	= "Life Regeneration",
	MANAREG 	= "Mana Regeneration",

--Health/mana
	HEALTH 		= "Life Points",
	MANA 		= "Mana Points"
};

-- equip and set bonus prefixes:
BONUSSCANNER_PREFIX_EQUIP = "Equip: ";
BONUSSCANNER_PREFIX_SET = "Set: ";
BONUSSCANNER_PREFIX_SOCKET = "Socket Bonus: ";
-- passive bonus patterns. checked against lines which start with above prefixes
BONUSSCANNER_PATTERNS_PASSIVE = {
--Base Stats
	{ pattern = "Increases defense rating by (%d+)%.", effect = "DEFENSE" },


--Weapon Skills
	{ pattern = "Increases axe skill rating by (%d+)%.", effect = "AXERATING" },
	{ pattern = "Increases sword skill rating by (%d+)%.", effect = "SWORDRATING" },
	{ pattern = "Increases mace skill rating by (%d+)%.", effect = "MACERATING" },
	{ pattern = "Increases dagger skill rating by (%d+)%.", effect = "DAGGERRATING" },
	{ pattern = "Increases Bow skill rating by (%d+)%.", effect = "BOWRATING" },
	{ pattern = "Increases Crossbow skill rating by (%d+)%.", effect = "XBOWRATING" },
	{ pattern = "Increases Gun skill rating by (%d+)%.", effect = "GUNRATING" },

-- Abilities
	{ pattern = "Increases your block rating by (%d+)%.", effect = "BLOCK" },
	{ pattern = "Increases the block value of your shield by (%d+)%.", effect = "BLOCKVALUE" },
	{ pattern = "Increases your dodge rating by (%d+)%.", effect = "DODGE" },
	{ pattern = "Increases your parry rating by (%d+)%.", effect = "PARRY" },
	{ pattern = "Improves your resilience rating by (%d+)%.", effect = "RESILIENCE" },


--Crit
	{ pattern = "Increases your critical strike rating by (%d+)%.", effect = "CRIT" },
	{ pattern = "Improves critical strike rating by (%d+)%.", effect = "CRIT" },
	{ pattern = "Increases your spell critical strike rating by (%d+)%.", effect = "SPELLCRIT" },

--Damage/Heal
	{ pattern = "Increases damage done by Arcane spells and effects by up to (%d+)%.", effect = "ARCANEDMG" },
	{ pattern = "Increases damage done by Fire spells and effects by up to (%d+)%.", effect = "FIREDMG" },
	{ pattern = "Increases damage done by Frost spells and effects by up to (%d+)%.", effect = "FROSTDMG" },
	{ pattern = "Increases damage done by Holy spells and effects by up to (%d+)%.", effect = "HOLYDMG" },
	{ pattern = "Increases damage done by Nature spells and effects by up to (%d+)%.", effect = "NATUREDMG" },
	{ pattern = "Increases damage done by Shadow spells and effects by up to (%d+)%.", effect = "SHADOWDMG" },
	{ pattern = "Increases healing done by spells and effects by up to (%d+)%.", effect = "HEAL" },
	{ pattern = "Increases damage and healing done by magical spells and effects by up to (%d+)%.", effect = {"HEAL", "DMG"} },
	{ pattern = "Increases damage done to Undead by magical spells and effects by up to (%d+)", effect = "DMGUNDEAD" },
--Attack power
	{ pattern = "Increases attack power by (%d+)%.", effect = "ATTACKPOWER" },
	{ pattern = "Increases ranged attack power by (%d+)%.", effect = "RANGEDATTACKPOWER" },
	{ pattern = "Increases attack power by (%d+) in Cat, Bear, Dire Bear, and Moonkin forms only%.", effect = "ATTACKPOWERFERAL" },
	{ pattern = "Increases attack power by (%d+) when fighting Undead%.", effect = "ATTACKPOWERUNDEAD" },
--Regen
	{ pattern = "Restores (%d+) health per 5 sec%.", effect = "HEALTHREG" }, 
	{ pattern = "Restores (%d+) health every 5 sec%.", effect = "HEALTHREG" },  -- both versions ('per' and 'every') seem to be used
	{ pattern = "Restores (%d+) mana per 5 sec%.", effect = "MANAREG" },
	{ pattern = "Restores (%d+) mana every 5 sec%.", effect = "MANAREG" },
--Hit
	{ pattern = "Increases your hit rating by (%d+)%.", effect = "TOHIT" },
	{ pattern = "Improves hit rating by (%d+)%.", effect = "TOHIT" },
	{ pattern = "Increases your spell hit rating by (%d+)%.", effect = "SPELLTOHIT" },

--Penetration
	{ pattern = "Increases your spell penetration by (%d+)%.", effect = "SPELLPEN" },

-- Atiesh patterns
	{ pattern = "Increases healing done by magical spells and effects of all party members within %d+ yards by up to (%d+)%.", effect = "HEAL" }, --Priest
	{ pattern = "Increases your spell damage by up to (%d+) and your healing by up to (%d+)%.", effect = {"DMG","HEAL"} }, --Priest
	{ pattern = "Increases damage and healing done by magical spells and effects of all party members within %d+ yards by up to (%d+)%.", effect = {"HEAL", "DMG"} }, --Warlock
	{ pattern = "Restores (%d+) mana per 5 seconds to all party members within %d+ yards%.", effect = "MANAREG" }, -- Druid
	{ pattern = "Increases the spell critical strike rating of all party members within %d+ yards by (%d+)%.", effect = "SPELLCRIT" }, -- Mage
};

-- generic patterns have the form "+xx bonus" or "bonus +xx" with an optional % sign after the value.

-- first the generic bonus string is looked up in the following table
BONUSSCANNER_PATTERNS_GENERIC_LOOKUP = {
	["All Stats"] 			= {"STR", "AGI", "STA", "INT", "SPI"},
	["Strength"]			= "STR",
	["Agility"]			= "AGI",
	["Stamina"]			= "STA",
	["Intellect"]			= "INT",
	["Spirit"] 			= "SPI",

	["All Resistances"] 	= { "ARCANERES", "FIRERES", "FROSTRES", "NATURERES", "SHADOWRES"},

	["Fishing"]		= "FISHING",
	["Fishing Lure"]	= "FISHING",
	["Increased Fishing"]	= "FISHING",
	["Mining"]		= "MINING",
	["Herbalism"]		= "HERBALISM",
	["Skinning"]		= "SKINNING",
	["Defense"]		= "DEFENSE",
	["Increased Defense"]	= "DEFENSE",

	["Attack Power"] 	= "ATTACKPOWER",
--	["Attack Power when fighting Undead"] 		= "ATTACKPOWERUNDEAD",
	["Attack Power in Cat, Bear, and Dire Bear forms only"] = "ATTACKPOWERFERAL",

	["Dodge"] 		= "DODGE",
	["Block"]		= "BLOCK",
	["Block Value"]		= "BLOCKVALUE",
	
	["Hit"] 		= "TOHIT",
	["Hit Rating"] 		= "TOHIT",
	["Spell Hit"]		= "SPELLTOHIT",
	
	["Blocking"]		= "BLOCK",

	["Ranged Attack Power"]	= "RANGEDATTACKPOWER",
	["health every 5 sec"]	= "HEALTHREG",
	["Healing Spells"] 	= "HEAL",
	["Increases Healing"] 	= "HEAL",
	["Healing and Spell Damage"]	= {"HEAL", "DMG"},
	["Damage and Healing Spells"]	= {"HEAL", "DMG"},
	["Spell Damage and Healing"]	= {"HEAL", "DMG"},	
	["mana every 5 sec"] 	= "MANAREG",
	["Mana Regen"]		= "MANAREG",
	["Spell Damage"]	= {"HEAL", "DMG"},

	["Critical"]		= "CRIT",
	["Critical Hit"]	= "CRIT",
	["Critical Strike Rating"]	="CRIT",	--Inscribed Flame Spessarite

	["Damage"]		= "DMG",
	["Health"]		= "HEALTH",
	["HP"]			= "HEALTH",
	["Mana"]		= "MANA",
	["Armor"]		= "ARMOR",
	["Reinforced Armor"]	= "ARMOR",
	["Healing"]		= "HEAL", -- +Healing Enchants (Tristanian)
};	

-- next we try to match against one pattern of stage 1 and one pattern of stage 2 and concatenate the effect strings
BONUSSCANNER_PATTERNS_GENERIC_STAGE1 = {
	{ pattern = "Arcane", 	effect = "ARCANE" },	
	{ pattern = "Fire", 	effect = "FIRE" },	
	{ pattern = "Frost", 	effect = "FROST" },	
	{ pattern = "Holy", 	effect = "HOLY" },	
	{ pattern = "Shadow",	effect = "SHADOW" },	
	{ pattern = "Nature", 	effect = "NATURE" }
}; 	

BONUSSCANNER_PATTERNS_GENERIC_STAGE2 = {
	{ pattern = "Resist", 	effect = "RES" },	
	{ pattern = "Damage", 	effect = "DMG" },
	{ pattern = "Effects", 	effect = "DMG" },
}; 	

-- finally if we got no match, we match against some special enchantment patterns.
BONUSSCANNER_PATTERNS_OTHER = {
	{ pattern = "Mana Regen (%d+) per 5 sec%.", effect = "MANAREG" },
	
	{ pattern = "Minor Wizard Oil", effect = {"DMG", "HEAL"}, value = 8 },
	{ pattern = "Lesser Wizard Oil", effect = {"DMG", "HEAL"}, value = 16 },
	{ pattern = "Wizard Oil", effect = {"DMG", "HEAL"}, value = 24 },
	{ pattern = "Brilliant Wizard Oil", effect = {"DMG", "HEAL", "SPELLCRIT"}, value = {36, 36, 1} },

	{ pattern = "Minor Mana Oil", effect = "MANAREG", value = 4 },
	{ pattern = "Lesser Mana Oil", effect = "MANAREG", value = 8 },
	{ pattern = "Brilliant Mana Oil", effect = { "MANAREG", "HEAL"}, value = {12, 25} },
	
	{ pattern = "Eternium Line", effect = "FISHING", value = 5 }, 
--Handled by new multi effect pattern checking
--	{ pattern = "Healing %+31 and 5 mana per 5 sec%.", effect = { "MANAREG", "HEAL"}, value = {5, 31} },
--	{ pattern = "Stamina %+16 and Armor %+100", effect = { "STA", "ARMOR"}, value = {16, 100} },
--	{ pattern = "Attack Power %+26 and %+1%% Critical Strike", effect = { "ATTACKPOWER", "CRIT"}, value = {26, 1} },
--	{ pattern = "Spell Damage %+15 and %+1%% Spell Critical Strike", effect = { "DMG", "HEAL", "SPELLCRIT"}, value = {15, 15, 1} },

};
