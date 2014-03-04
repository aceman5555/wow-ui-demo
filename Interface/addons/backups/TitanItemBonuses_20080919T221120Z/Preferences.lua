TITAN_ITEMBONUSES_SETNAME_PATTERN = "^(.*) %(%d/%d%)$";

TITAN_ITEMBONUSES_PREFIX_PATTERN = "^%+(%d+)%%?(.*)$";
TITAN_ITEMBONUSES_SUFFIX_PATTERN = "^(.*)%+(%d+)%%?$";

-- Extra globals, localized
TITAN_ITEMBONUSES_RATING_CONVERSION = "Display Ratings as points/percentage";
TITAN_ITEMBONUSES_SHOWGEMS = "Display number of gem colors";
if (GetLocale() == "deDE") then
TITAN_ITEMBONUSES_RATING_CONVERSION = "Zeigen Sie Bewertungen als Punkte/Prozentsatz";
TITAN_ITEMBONUSES_SHOWGEMS = "Anzeige Zahl der Edelsteinfarben";
end

TitanItemBonuses_colors = {
	X = 'FFD200',  -- attributes
	Y = '20FF20',  -- skills
	M = '999999',  -- melee
	R = '00C0C0',  -- ranged
	C = 'FFFF00',  -- spells
	A = 'FF60FF',  -- arcane
	I = 'FF3600',  -- fire
	F = '00C0FF',  -- frost
	H = 'FFA400',  -- holy
	N = '00FF60',  -- nature
	S = 'AA12AC',  -- shadow
	L = '20FF20',  -- life
	P = '6060FF',  -- mana
};


TITAN_ITEMBONUSES_EFFECTS = {
	{ effect = "STR",				name = TITAN_ITEMBONUSES_STR,	 			format = "%d",		short = "XSTR",	cat = "ATT" },
	{ effect = "AGI",				name = TITAN_ITEMBONUSES_AGI, 				format = "%d",		short = "XAGI",	cat = "ATT" },
	{ effect = "STA",				name = TITAN_ITEMBONUSES_STA, 				format = "%d",		short = "XSTA",	cat = "ATT" },
	{ effect = "INT",				name = TITAN_ITEMBONUSES_INT, 				format = "%d",		short = "XINT",	cat = "ATT" },
	{ effect = "SPI",				name = TITAN_ITEMBONUSES_SPI,	 			format = "%d",		short = "XSPI",	cat = "ATT" },
	{ effect = "ARMOR",				name = TITAN_ITEMBONUSES_ARMOR,	 			format = "%d",		short = "XARM",	cat = "ATT" },

	{ effect = "ARCANERES",			name = TITAN_ITEMBONUSES_ARCANERES,			format = "%d",		short = "AR",	cat = "RES" },
	{ effect = "FIRERES",			name = TITAN_ITEMBONUSES_FIRERES, 			format = "%d",		short = "IR",	cat = "RES" },
	{ effect = "NATURERES", 		name = TITAN_ITEMBONUSES_NATURERES, 		format = "%d",		short = "NR",	cat = "RES" },
	{ effect = "FROSTRES",			name = TITAN_ITEMBONUSES_FROSTRES, 			format = "%d",		short = "FR",	cat = "RES" },
	{ effect = "SHADOWRES",			name = TITAN_ITEMBONUSES_SHADOWRES,			format = "%d",		short = "SR",	cat = "RES" },

	{ effect = "DEFENSE",			name = TITAN_ITEMBONUSES_DEFENSE, 			format = "%d",	pformat="%d pt",	short = "YDEF",	cat = "SKILL" },
	{ effect = "EXPERTISE",			name = TITAN_ITEMBONUSES_EXPERTISE, 			format = "%d",	pformat="%d pt",	short = "YEXPR",	cat = "SKILL" },
	{ effect = "FISHING",			name = TITAN_ITEMBONUSES_FISHING,			format = "%d",		short = "YFIS",	cat = "SKILL" },
	{ effect = "HERBALISM",			name = TITAN_ITEMBONUSES_HERBALISM, 		format = "%d",		short = "YHER",	cat = "SKILL" },
	{ effect = "MINING",			name = TITAN_ITEMBONUSES_MINING,			format = "%d",		short = "YMIN",	cat = "SKILL" },
	{ effect = "SKINNING", 			name = TITAN_ITEMBONUSES_SKINNING, 			format = "%d",		short = "YSKI",	cat = "SKILL" },
  
	{ effect = "ATTACKPOWER", 		name = TITAN_ITEMBONUSES_ATTACKPOWER, 		format = "%d",		short = "MAP",	cat = "BON" },
	{ effect = "ATTACKPOWERUNDEAD", 		name = TITAN_ITEMBONUSES_ATTACKPOWERUNDEAD, 		format = "%d",		short = "MAPUD",	cat = "BON" },
	{ effect = "ATTACKPOWERFERAL", 		name = TITAN_ITEMBONUSES_ATTACKPOWERFERAL, 		format = "%d",		short = "MAPFER",	cat = "BON" },
	{ effect = "ARMORPEN",		name = TITAN_ITEMBONUSES_APEN,		format = "%d",		short = "MAPEN",	cat = "BON" },
	{ effect = "BLOCK",				name = TITAN_ITEMBONUSES_BLOCK, 			format = "%d",	pformat="%.2f%%",	short = "MBLOCK",	cat = "BON" },
  { effect = "BLOCKVALUE",	name = TITAN_ITEMBONUSES_BLOCKVALUE, 			format = "%d",		short = "MBLOCKV",	cat = "BON" },
  { effect = "CRIT",				name = TITAN_ITEMBONUSES_CRIT, 				format = "%d",	pformat="%.2f%%",	short = "MCRIT",	cat = "BON" },
  { effect = "DODGE",				name = TITAN_ITEMBONUSES_DODGE, 			format = "%d", pformat="%.2f%%",		short = "MDODGE",	cat = "BON" },
	{ effect = "HASTE",		name = TITAN_ITEMBONUSES_HASTE,		format = "%d", pformat="%.2f%%",	short = "MHASTE",	cat = "BON" },
	{ effect = "TOHIT", 			name = TITAN_ITEMBONUSES_TOHIT, 			format = "%d",	pformat="%.2f%%",	short = "MHIT",	cat = "BON" },
	{ effect = "PARRY", 			name = TITAN_ITEMBONUSES_PARRY, 			format = "%d", pformat="%.2f%%", short = "MPARRY",	cat = "BON" },
	{ effect = "RANGEDATTACKPOWER", name = TITAN_ITEMBONUSES_RANGEDATTACKPOWER, format = "%d",	short = "RRAP",	cat = "BON" },
  { effect = "RANGEDCRIT",		name = TITAN_ITEMBONUSES_RANGEDCRIT,		format = "%d",	pformat="%.2f%%",	short = "RRCRIT",	cat = "BON" },
  { effect = "RANGEDDMG",		name = TITAN_ITEMBONUSES_RANGEDDMG,		format = "%d",		short = "RRDMG",	cat = "BON" },
	{ effect = "RESILIENCE",		name = TITAN_ITEMBONUSES_RESILIENCE,		format = "%d",	pformat="%.2f%%",	short = "MRLS",	cat = "BON" },
	{ effect = "DMGWPN",		name = TITAN_ITEMBONUSES_DMGWPN,		format = "%d",		short = "MWPN",	cat = "BON" },
	
	
	{ effect = "DMG",				name = TITAN_ITEMBONUSES_DMG, 				format = "%d",		short = "CSDMG",	cat = "SBON" },
	{ effect = "DMGUNDEAD",				name = TITAN_ITEMBONUSES_DMGUNDEAD, 				format = "%d",		short = "CDUD",	cat = "SBON" },
	{ effect = "HEAL",				name = TITAN_ITEMBONUSES_HEAL, 				format = "%d",		short = "CHEAL",	cat = "SBON"},
  { effect = "HOLYCRIT", 			name = TITAN_ITEMBONUSES_HOLYCRIT,			format = "%d", pformat="%.2f%%",	short = "CHC",	cat = "SBON" },
	{ effect = "SPELLCRIT", 		name = TITAN_ITEMBONUSES_SPELLCRIT,			format = "%d", pformat="%.2f%%",	short = "CSC",	cat = "SBON" },
	{ effect = "SPELLTOHIT", 		name = TITAN_ITEMBONUSES_SPELLTOHIT,		format = "%d",	pformat="%.2f%%",	short = "CSH",	cat = "SBON" },
	{ effect = "SPELLPEN", 		name = TITAN_ITEMBONUSES_SPELLPEN,		format = "%d",		short = "CSPEN",	cat = "SBON" },
	{ effect = "SPELLH",		name = TITAN_ITEMBONUSES_SPELLH,		format = "%d",	pformat="%.2f%%",	short = "CSPELLH",	cat = "SBON" },
	{ effect = "ARCANEDMG", 		name = TITAN_ITEMBONUSES_ARCANEDMG, 		format = "%d",		short = "AD",	cat = "SBON" },
	{ effect = "FIREDMG", 			name = TITAN_ITEMBONUSES_FIREDMG, 			format = "%d",		short = "ID",	cat = "SBON" },
	{ effect = "FROSTDMG",			name = TITAN_ITEMBONUSES_FROSTDMG, 			format = "%d",		short = "FD",	cat = "SBON" },
	{ effect = "HOLYDMG",			name = TITAN_ITEMBONUSES_HOLYDMG, 			format = "%d",		short = "HD",	cat = "SBON" },
	{ effect = "NATUREDMG",			name = TITAN_ITEMBONUSES_NATUREDMG, 		format = "%d",		short = "ND",	cat = "SBON" },
	{ effect = "SHADOWDMG",			name = TITAN_ITEMBONUSES_SHADOWDMG, 		format = "%d",		short = "SD",	cat = "SBON" },

	{ effect = "HEALTH",			name = TITAN_ITEMBONUSES_HEALTH,			format = "%d",		short = "LP",	cat = "OBON" },
	{ effect = "HEALTHREG",			name = TITAN_ITEMBONUSES_HEALTHREG,			format = "%d HP/5s",short = "LR",	cat = "OBON" },
	{ effect = "MANA",				name = TITAN_ITEMBONUSES_MANA, 				format = "%d",		short = "PP",	cat = "OBON" },
	{ effect = "MANAREG",			name = TITAN_ITEMBONUSES_MANAREG, 			format = "%d MP/5s",short = "PR",	cat = "OBON" },
	
	{ effect = "THREATREDUCTION",	name = TITAN_ITEMBONUSES_THREATR, format = "%d", short = "YTHREATR", cat = "EBON" },
	{ effect = "THREATINCREASE",	name = TITAN_ITEMBONUSES_THREATI, format = "%d", short = "YTHREATI", cat = "EBON" },
	{ effect = "INCRCRITDMG",	 name = TITAN_ITEMBONUSES_INCCRIT, format = "%d", short = "CINCCRIT", cat = "EBON" },
	{ effect = "SPELLREFLECT", name = TITAN_ITEMBONUSES_SPELLREFL, format = "%d", short = "CSPELLREFL", cat = "EBON" },
	{ effect = "SNARERESIST",	name = TITAN_ITEMBONUSES_SNARERES, format = "%d", short = "YSNARERES", cat = "EBON" },
	{ effect = "STUNRESIST",	name = TITAN_ITEMBONUSES_STUNRES, format = "%d", short = "YSTUNRES", cat = "EBON" },
	{ effect = "PERCINT",	name = TITAN_ITEMBONUSES_PERCINT, format = "%d", short = "XPERCINT", cat = "EBON" },
	{ effect = "PERCBLOCKVALUE",	name = TITAN_ITEMBONUSES_PERCBLOCK, format = "%d", short = "XPERCBLOCK", cat = "EBON" },
};

TITAN_ITEMBONUSES_CATEGORIES = {'ATT', 'BON', 'SBON', 'RES', 'SKILL', 'OBON', 'EBON'};