-- french localization by the_nuru

if (LOCALE_frFR) then 
-- bonus names


BONUSSCANNER_NAMES = {	
	STR 		= "Force",
	AGI 		= "Agilit\195\169",
	STA 		= "Endurance",
	INT 		= "Intelligence",
	SPI 		= "Esprit",
	ARMOR 		= "Bonus d'Armure",

	ARCANERES 	= "Arcane",
	FIRERES 	= "Feu",
	NATURERES 	= "Nature",
	FROSTRES 	= "Givre",
	SHADOWRES 	= "Ombre",

	FISHING 	= "P\195\170che",
	MINING 		= "Minage",
	HERBALISM 	= "Herborisme",
	SKINNING 	= "Depe\195\170age",
	DEFENSE 	= "D\195\169fense",

	BLOCK 		= "Blocage",
	DODGE 		= "Esquive",
	PARRY 		= "Parade",
	ATTACKPOWER = "Puissance d'attaque",
	CRIT 		= "Coups Critiques",
	RANGEDATTACKPOWER = "Puissance d'attaque \195\160 distance",
	RANGEDCRIT 	= "Tirs Crit.",
	TOHIT 		= "Chances de toucher",

	DMG 		= "D\195\169gats",
	ARCANEDMG 	= "D\195\169gats d'Arcanes",
	FIREDMG 	= "D\195\169gats de Feu",
	FROSTDMG 	= "D\195\169gats de Froid",
	HOLYDMG 	= "D\195\169gats Sacr\195\169s",
	NATUREDMG 	= "D\195\169gats de Nature",
	SHADOWDMG 	= "D\195\169gats des Ombres",
	SPELLCRIT 	= "Critiques",
	HEAL 		= "Soins",
	HOLYCRIT 	= "Soins Crit.",
	SPELLTOHIT	= "Chance de toucher avec les sorts",

	HEALTHREG 	= "R\195\169generation Vie",
	MANAREG 	= "R\195\169generation Mana",
	HEALTH 		= "Points de Vie",
	MANA 		= "Points de Mana",
};
-- equip and set bonus patterns:
BONUSSCANNER_PREFIX_EQUIP = "Equip\195\169 : ";
BONUSSCANNER_PREFIX_SET = "Complet : ";

BONUSSCANNER_PATTERNS_PASSIVE = {
	{ pattern = "+(%d+) \195\160 la puissance d'attaque%.", effect = "ATTACKPOWER" },
	{ pattern = "+(%d+) \195\160 la puissance des attaques \195\160 distance%.", effect = "RANGEDATTACKPOWER" },
	{ pattern = "Augmente vos chances de bloquer une attaque de (%d+)%%%.", effect = "BLOCK" },
	{ pattern = "Augmente vos chances d'esquiver une attaque de (%d+)%%%.", effect = "DODGE" },
	{ pattern = "Augmente vos chances de parer une attaque par (%d+)%%%.", effect = "PARRY" },
	{ pattern = "Augmente vos chances d'infliger des coups critiques avec vos sorts de (%d+)%%%.", effect = "SPELLCRIT" },
	{ pattern = "Augmente vos chances d'infliger un coup critique de (%d+)%%%.", effect = "CRIT" },
	{ pattern = "Augmente vos chances d'infliger un coup critique avec une arme \195\160 feu par (%d+)%%%.", effect = "RANGEDCRIT" },
	{ pattern = "Augmente vos chances de lancer un soin critique par (%d+)%%%.", effect = "HEALCRIT" },
	{ pattern = "Augmente les d\195\169g\195\162ts inflig\195\169s par les effets et les sorts des Arcanes de (%d+)% au maximum.", effect = "ARCANEDMG" },
	{ pattern = "Augmente les d\195\169g\195\162ts inflig\195\169s par vos sorts et effets de Feu de (%d+)% au maximum.", effect = "FIREDMG" },
	{ pattern = "Augmente les d\195\169g\195\162ts inflig\195\169s par les sorts et effets de givre de (%d+)% au maximum.", effect = "FROSTDMG" },
	{ pattern = "Augmente les dommages realises par les sorts Sacr\195\169s de (%d+)%.", effect = "HOLYDMG" },
	{ pattern = "Augmente les d\195\169g\195\162ts inflig\195\169s par les sorts et effets de Nature (%d+)% au maximum.", effect = "NATUREDMG" },
	{ pattern = "Augmente les d\195\169g\195\162ts inflig\195\169s par les sorts et effets d'Ombre de (%d+)% au maximum.", effect = "SHADOWDMG" },
	{ pattern = "(%d+)% aux d\195\169g\195\162ts des sorts d'ombres.", effect = "SHADOWDMG" },
	{ pattern = "Augmente les effets des sorts de soins de (%d+)% au maximum.", effect = "HEAL" },
	{ pattern = "Augmente les soins prodigu\195\169s par les sorts et effets de (%d+)% au maximum.", effect = "HEAL"},
	{ pattern = "Augmente les d\195\169g\195\162ts et les soins prodigu\195\169s par les sortsfalseles effets magiques de (%d+)% au maximum.", effect = "HEAL" },
	-- { pattern = "Augmente les d\195\169g\195\162ts et les soins produits par les sorts et effets magiques de (%d+)% au maximum.", effect = "DMG" },
	{ pattern = "Augmente les d\195\169g\195\162ts et les soins produits par les sorts et effets magiques de (%d+)% au maximum.", effect = {"HEAL", "DMG" }},
	{ pattern = "Rend (%d+) points de vie toutes les 5 sec.", effect = "HEALTHREG" },
	{ pattern = "Rend (%d+) points de mana toutes les 5 secondes.", effect = "MANAREG" },
	{ pattern = "Augmente vos chances de toucher de (%d+)%%%.", effect = "TOHIT" },
	{ pattern = "Augmente vos chances de toucher avec des sorts de (%d+)%%%.", effect = "SPELLTOHIT" },
	{ pattern = "P\195\170che augment\195\169e de (%d+)%.", effect = "FISHING" },
	{ pattern = "D\195\169fense augment\195\169e de (%d+)%.", effect = "DEFENSE"}
};


BONUSSCANNER_PATTERNS_GENERIC_LOOKUP = {
	["Toutes les caract\195\169ristiques"] = {"STR", "AGI", "STA", "INT", "SPI"},
	["Force"] = "STR",
	["Agilit\195\169"] = "AGI",
	["Endurance"] = "STA",
	["Intelligence"] = "INT",
	["Esprit"] = "SPI",
	["\195\160 toutes les r\195\169sistances"] = { "ARCANERES", "FIRERES", "FROSTRES", "NATURERES", "SHADOWRES"},
	["P\195\170che"] = "FISHING",
	["Minage"] = "MINING",
	["Herborisme"] = "HERBALISM",
	["D\195\169pecage"] = "SKINNING",
	["D\195\169fense"] = "DEFENSE",
	["puissance d'Attaque"] = "ATTACKPOWER",
	["Esquive"] = "DODGE",
	["Blocage"] = "BLOCK",
	["Blocage"] = "BLOCK",
	["Pouvoir d'Attaque \195\160 distance"] = "RANGEDATTACKPOWER",
	["Soins chaque 5 sec."] = "HEALTHREG",
	["Sorts de Soins"] = "HEAL",
	["Mana chaque 5 sec."] = "MANAREG",
	["Sorts de Dommages"] = "DMG",
	["d\195\169g\195\162ts des sorts"] = "DMG",
	["d\195\169g\195\162ts et les effets des sorts"] = "DMG",
	["D\195\169g\195\162ts et soins "] = {"HEAL", "DMG"},
	["Coup Critique"] = "CRIT",
	["Dommage"] = "DMG",
	["Soins"] = "HEALTH",
	["Mana"] = "MANA",
	["Armure :"] = "ARMOR",
	["Armure "] = "ARMOR",
	["Armure renforc\195\169e"] = "ARMOR",
};
	
BONUSSCANNER_PATTERNS_GENERIC_STAGE1 = {
	{ pattern = "Arcane", effect = "ARCANE" },
	{ pattern = "Feu", effect = "FIRE" },
	{ pattern = "Givre", effect = "FROST" },
	{ pattern = "Sacr\195\169", effect = "HOLY" },
	{ pattern = "Ombre", effect = "SHADOW" },
	{ pattern = "Nature", effect = "NATURE" },
	{ pattern = "arcanes", effect = "ARCANE" },
	{ pattern = "feu", effect = "FIRE" },
	{ pattern = "givre", effect = "FROST" },
	{ pattern = "ombre", effect = "SHADOW" },
	{ pattern = "nature", effect = "NATURE" }
};

BONUSSCANNER_PATTERNS_GENERIC_STAGE2 = {
	{ pattern = "\195\169sistance", effect = "RES" },
	{ pattern = "d\195\169g\195\162ts", effect = "DMG" },
	{ pattern = "effets", effect = "DMG" }
};


BONUSSCANNER_PATTERNS_OTHER = {
};

end 
