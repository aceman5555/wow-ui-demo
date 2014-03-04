--[[
	Name: LibLocalizedEJBosses-1.0
	Revision: $Revision: 2 $
	Author: Caleb (calebzor@gmail.com)
	SVN:  svn://svn.wowace.com/wow/LibLocalizedEJBosses-1-0/mainline/trunk
	Description:  A library to get localized boss names from the Encounter Journal
	Dependencies: LibStub
]]

local MAJOR_VERSION = "LibLocalizedEJBosses-1.0"
local MINOR_VERSION = tonumber(("$Revision: 2 $"):match("%d+"))
local lib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end

local bosses = {}
local descriptions = {}
local icons = {}
local initialized = nil

--[===[@debug@
-- ### debug
lejb = lib
-- this is used for the saved variable so a script can generate the bottom part of this file
local function savedVariableGenerationForScript()
	LEJBbossList = bosses
end
--@end-debug@]===]

local function populateBossList(isRaid)
	local numTiers = 1
	if EJ_GetNumTiers then
		numTiers = EJ_GetNumTiers()
	end
	for tierIndex=1,numTiers do
		if EJ_GetNumTiers then EJ_SelectTier(tierIndex) end -- MoP compact
		local i = 1
		local instanceID = EJ_GetInstanceByIndex(i, isRaid)

		while instanceID do
			EJ_SelectInstance(instanceID)
			if tonumber((select(4, GetBuildInfo()))) < 40300 then
				EJ_SetDifficulty(true, false) -- heroic, 25 man
			else
				if isRaid then
					EJ_SetDifficulty(4) -- heroic, 25 man
				else
					EJ_SetDifficulty(2) -- heroic, 5 man
				end
			end
			local j = 1
			local name, desc, bossId = EJ_GetEncounterInfoByIndex(j)

			while name and j < 25 do
				bosses[bossId] = name
				descriptions[bossId] = desc
				local _, _, _, _, bossImage = EJ_GetCreatureInfo(j, bossId)
				icons[bossId] = bossImage or "Interface\\EncounterJournal\\UI-EJ-BOSS-Default"
				j = j + 1;
				name, desc, bossId = EJ_GetEncounterInfoByIndex(j);
			end
			i = i + 1;
			instanceID = EJ_GetInstanceByIndex(i, isRaid)
		end
		initialized = true
		--[===[@debug@
		-- XXX debug
		savedVariableGenerationForScript()
		--@end-debug@]===]
	end
end

--- Get the localized name of a boss based on the Blizzard EJ bossNames
-- @see lib.enUSbossList for currently supported bosses
-- @return localized boss name, description, icon or nil if it does not exsits in the EJ
function lib:GetEncounterInfoByBossName(bossName)
	if not initialized then populateBossList(true) populateBossList(false) end
	local bossId = nil
	for k, v in pairs(bosses) do
		if v == bossName then
			bossId = k
		end
	end
	if not bossId then return nil end
	return bosses[bossId], descriptions[bossId], icons[bossId]
end

--- Get the localized name of a boss based on the Blizzard EJ bossIds
-- @see lib.enUSbossList for currently supported bosses
-- @return localized boss name, description, icon or nil if it does not exsits in the EJ
function lib:GetEncounterInfoByBossId(bossId)
	if not initialized then populateBossList(true) populateBossList(false) end
	return bosses[bossId], descriptions[bossId], icons[bossId]
end

-- DO NOT ADD ANYTHING BELOW THIS POINT
-- START enUS boss list for script --
lib.enUSbossList = {
	[127] = "Isiset, Construct of Magic",
	[158] = "Ascendant Council",
	[190] = "Hex Lord Malacrass",
	[631] = "Zuramat the Obliterator",
	[380] = "Hurley Blackbreath",
	[632] = "Cyanigosa",
	[317] = "Hagara the Stormbinder",
	[381] = "Phalanx",
	[445] = "Timmy the Cruel",
	[191] = "Daakara",
	[318] = "Spine of Deathwing",
	[382] = "Ribbly Screwspigot",
	[446] = "Willey Hopebreaker",
	[636] = "Argent Confessor Paletress",
	[637] = "The Black Knight",
	[383] = "Plugger Spazzring",
	[112] = "Ozruk",
	[128] = "Ammunae, Construct of Life",
	[638] = "Prince Keleseth",
	[192] = "Beth'tilac",
	[639] = "Skarvald & Dalronn",
	[384] = "Ambassador Flamelash",
	[448] = "Instructor Galford",
	[640] = "Ingvar the Plunderer",
	[641] = "Svala Sorrowgrave",
	[385] = "The Seven",
	[449] = "Balnazzar",
	[129] = "Setesh, Construct of Destruction",
	[642] = "Gortok Palehoof",
	[193] = "Lord Rhyolith",
	[643] = "Skadi the Ruthless",
	[386] = "Magmus",
	[450] = "The Unforgiven",
	[644] = "King Ymiron",
	[323] = "Echo of Sylvanas",
	[387] = "Emperor Dagran Thaurissan",
	[451] = "Baroness Anastari",
	[130] = "Rajh, Construct of Sun",
	[194] = "Alysrazor",
	[324] = "Warlord Zon'ozz",
	[388] = "Highlord Omokk",
	[452] = "Nerub'enkan",
	[325] = "Yor'sahj the Unsleeping",
	[389] = "Shadow Hunter Vosh'gajin",
	[453] = "Maleki the Pallid",
	[131] = "General Umbriss",
	[195] = "Shannox",
	[523] = "Shirrak the Dead Watcher",
	[390] = "War Master Voone",
	[454] = "Magistrate Barthilas",
	[524] = "Exarch Maladaar",
	[391] = "Mother Smolderweb",
	[455] = "Ramstein the Gorger",
	[132] = "Forgemaster Throngus",
	[654] = "Armsmaster Harlan",
	[196] = "Baleroc, the Gatekeeper",
	[527] = "Watchkeeper Gargolmar",
	[655] = "Saboteur Kip'tilak",
	[392] = "Urok Doomhowl",
	[456] = "Lord Aurius Rivendare",
	[528] = "Omor the Unscarred",
	[656] = "Flameweaver Koegler",
	[529] = "Vazruden the Herald",
	[657] = "Master Snowdrift",
	[393] = "Quartermaster Zigris",
	[457] = "Avatar of Hakkar",
	[530] = "Selin Fireheart",
	[658] = "Liu Flameheart",
	[197] = "Majordomo Staghelm",
	[531] = "Vexallus",
	[659] = "Instructor Chillheart",
	[394] = "Halycon",
	[458] = "Jammal'an the Prophet",
	[532] = "Priestess Delrissa",
	[660] = "Houndmaster Braun",
	[533] = "Kael'thas Sunstrider",
	[331] = "Ultraxion",
	[395] = "Gizrul the Slavener",
	[459] = "Wardens of the Dream",
	[534] = "Pandemonius",
	[198] = "Ragnaros",
	[535] = "Tavarok",
	[663] = "Jandice Barov",
	[396] = "Overlord Wyrmthalak",
	[536] = "Yor",
	[664] = "Lorewalker Stonestep",
	[537] = "Nexus-Prince Shaffar",
	[665] = "Rattlegore",
	[397] = "Pyroguard Emberseer",
	[538] = "Lieutenant Drake",
	[167] = "Cho'gall",
	[539] = "Captain Skarloc",
	[398] = "Solakar Flamewreath",
	[540] = "Epoch Hunter",
	[668] = "Ook-Ook",
	[541] = "Darkweaver Syth",
	[669] = "Hoptallus",
	[399] = "Warchief Rend Blackhand",
	[463] = "Shade of Eranikus",
	[542] = "Anzu",
	[168] = "Sinestra",
	[543] = "Talon King Ikiss",
	[671] = "Brother Korloff",
	[400] = "The Beast",
	[464] = "Hogger",
	[544] = "Ambassador Hellmaw",
	[672] = "Wise Mari",
	[545] = "Blackheart the Inciter",
	[673] = "Gu Cloudstrike",
	[401] = "General Drakkisath",
	[465] = "Lord Overheat",
	[546] = "Grandmaster Vorpil",
	[674] = "High Inquisitor Whitemane",
	[547] = "Murmur",
	[675] = "Striker Ga'dok",
	[402] = "Zevrim Thornhoof",
	[466] = "Randolph Moloch",
	[548] = "Zereketh the Unbound",
	[676] = "Commander Ri'mok",
	[549] = "Dalliah the Doomsayer",
	[677] = "Will of the Emperor",
	[403] = "Hydrospawn",
	[467] = "Revelosh",
	[550] = "Wrath-Scryer Soccothrates",
	[170] = "Magmaw",
	[551] = "Harbinger Skyriss",
	[679] = "The Stone Guard",
	[404] = "Lethtendris",
	[468] = "The Lost Dwarves",
	[552] = "Chrono Lord Deja",
	[553] = "Temporus",
	[341] = "Archbishop Benedictus",
	[405] = "Alzzin the Wildshaper",
	[469] = "Ironaya",
	[554] = "Aeonus",
	[682] = "Gara'jal the Spiritbinder",
	[555] = "The Maker",
	[683] = "Protectors of the Endless",
	[406] = "Tendris Warpwood",
	[470] = "Ancient Stone Keeper",
	[556] = "Broggok",
	[684] = "Darkmaster Gandling",
	[557] = "Keli'dan the Breaker",
	[685] = "Sha of Violence",
	[407] = "Illyanna Ravenoak",
	[471] = "Galgann Firehammer",
	[558] = "Commander Sarannis",
	[172] = "Chimaeron",
	[814] = "Nalak, The Storm Lord",
	[559] = "High Botanist Freywinn",
	[687] = "The Spirit Kings",
	[408] = "Magister Kalendris",
	[472] = "Grimlok",
	[560] = "Thorngrin the Tender",
	[688] = "Thalnos the Soulrender",
	[816] = "Council of Elders",
	[561] = "Laj",
	[689] = "Feng the Accursed",
	[409] = "Immol'thar",
	[473] = "Archaedas",
	[562] = "Warp Splinter",
	[173] = "Maloriak",
	[818] = "Durumu the Forgotten",
	[563] = "Mechano-Lord Capacitus",
	[691] = "Sha of Anger",
	[410] = "Prince Tortheldrin",
	[474] = "Lady Anacondra",
	[564] = "Nethermancer Sepethrea",
	[692] = "General Pa'valak",
	[820] = "Primordius",
	[565] = "Pathaleon the Calculator",
	[693] = "Vizier Jin'bak",
	[411] = "Guard Mol'dar",
	[475] = "Lord Cobrahn",
	[566] = "Grand Warlock Nethekurse",
	[694] = "Adarogg",
	[695] = "Dark Shaman Koranthal",
	[412] = "Stomper Kreeg",
	[476] = "Lord Pythas",
	[568] = "Warbringer O'mrogg",
	[696] = "Slagmaw",
	[824] = "Dark Animus",
	[569] = "Warchief Kargath Bladefist",
	[697] = "Lava Guard Gordoth",
	[413] = "Guard Fengus",
	[477] = "Kresh",
	[570] = "Mennu the Betrayer",
	[175] = "High Priest Venoxis",
	[826] = "Oondasta",
	[571] = "Rokmar the Crackler",
	[414] = "Guard Slip'kik",
	[478] = "Skum",
	[572] = "Quagmirran",
	[828] = "Ji-Kun",
	[573] = "Hydromancer Thespia",
	[415] = "Captain Kromcrush",
	[479] = "Lord Serpentis",
	[574] = "Mekgineer Steamrigger",
	[176] = "Bloodlord Mandokir",
	[335] = "Sha of Doubt",
	[670] = "Yan-Zhu the Uncasked",
	[575] = "Warlord Kalithresh",
	[322] = "Arcurion",
	[831] = "Ra-den",
	[480] = "Verdan the Everliving",
	[576] = "Hungarfen",
	[738] = "Commander Vo'jak",
	[832] = "Lei Shen",
	[686] = "Taran Zhu",
	[577] = "Ghaz'an",
	[698] = "Xin the Weaponmaster",
	[417] = "King Gordok",
	[481] = "Mutanus the Devourer",
	[578] = "Swamplord Musel'ek",
	[177] = "Cache of Madness - Gri'lek",
	[834] = "Grand Champions",
	[690] = "Gekkan",
	[579] = "The Black Stalker",
	[649] = "Raigonn",
	[418] = "Crowd Pummeler 9-60",
	[482] = "Hydromancer Velratha",
	[580] = "Elder Nadox",
	[708] = "Trial of the King",
	[635] = "Eadric the Pure",
	[93] = "\"Captain\" Cookie",
	[581] = "Prince Taldaram",
	[709] = "Sha of Fear",
	[419] = "Grubbis",
	[483] = "Gahz'rilla",
	[582] = "Jedoga Shadowseeker",
	[178] = "Cache of Madness - Hazza'rah",
	[99] = "Lord Walden",
	[101] = "Lady Naz'jar",
	[583] = "Amanitar",
	[186] = "Akil'zon",
	[420] = "Viscous Fallout",
	[484] = "Antu'sul",
	[584] = "Herald Volazj",
	[332] = "Warmaster Blackhorn",
	[425] = "Tinkerer Gizlock",
	[618] = "Grand Magus Telestra",
	[585] = "Krik'thir the Gatewatcher",
	[713] = "Garalon",
	[421] = "Electrocutioner 6000",
	[485] = "Theka the Martyr",
	[586] = "Hadronox",
	[179] = "Cache of Madness - Renataki",
	[292] = "Mannoroth and Varo'then",
	[291] = "Queen Azshara",
	[587] = "Anub'arak",
	[290] = "Peroth'arn",
	[422] = "Mekgineer Thermaplugg",
	[486] = "Witch Doctor Zum'rah",
	[588] = "Trollgore",
	[104] = "Ozumat",
	[103] = "Mindbender Ghur'sha",
	[102] = "Commander Ulthok, the Festering Prince",
	[589] = "Novos the Summoner",
	[90] = "Helix Gearbreaker",
	[423] = "Noxxion",
	[487] = "Nekrum & Sezz'ziz",
	[590] = "King Dred",
	[180] = "Cache of Madness - Wushoolay",
	[846] = "Malkorok",
	[116] = "Asaad, Caliph of Zephyrs",
	[591] = "The Prophet Tharon'ja",
	[115] = "Altairus",
	[424] = "Razorlash",
	[114] = "Grand Vizier Ertan",
	[592] = "Slad'ran",
	[113] = "High Priestess Azil",
	[111] = "Slabhide",
	[110] = "Corborus",
	[593] = "Drakkari Colossus",
	[100] = "Lord Godfrey",
	[849] = "The Fallen Protectors",
	[489] = "Chief Ukorz Sandscalp",
	[594] = "Moorabi",
	[181] = "High Priestess Kilnara",
	[850] = "General Nazgrim",
	[98] = "Commander Springvale",
	[595] = "Eck the Ferocious",
	[97] = "Baron Silverlaine",
	[851] = "Thok the Bloodthirsty",
	[96] = "Baron Ashbury",
	[596] = "Gal'darah",
	[122] = "Siamat",
	[852] = "Immerseus",
	[119] = "High Prophet Barim",
	[597] = "General Bjarngrim",
	[725] = "Salyis's Warband",
	[853] = "Paragons of the Klaxxi",
	[118] = "Lockmaw",
	[598] = "Volkhan",
	[726] = "Elegon",
	[117] = "General Husam",
	[342] = "Asira Dawnslayer",
	[599] = "Ionar",
	[727] = "Wing Leader Ner'onok",
	[428] = "Celebras the Cursed",
	[375] = "Warder Stilgiss",
	[600] = "Loken",
	[728] = "Blood Guard Porung",
	[856] = "Kor'kron Dark Shaman",
	[626] = "Erekem",
	[601] = "Falric",
	[729] = "Lei Shi",
	[429] = "Landslide",
	[95] = "Vanessa VanCleef",
	[602] = "Marwyn",
	[134] = "Erudax, the Duke of Below",
	[858] = "Yu'lon, The Jade Serpent",
	[133] = "Drahga Shadowburner",
	[603] = "Escape from Arthas",
	[289] = "Murozond",
	[859] = "Niuzao, The Black Ox",
	[283] = "Echo of Tyrande",
	[604] = "Krystallus",
	[285] = "Echo of Jaina",
	[860] = "Xuen, The White Tiger",
	[340] = "Echo of Baine",
	[605] = "Maiden of Grief",
	[92] = "Admiral Ripsnarl",
	[861] = "Ordos, Fire-God of the Yaungol",
	[124] = "Temple Guardian Anhuur",
	[606] = "Tribunal of Ages",
	[184] = "Zanzil",
	[91] = "Foe Reaper 5000",
	[89] = "Glubtok",
	[607] = "Sjonnir the Ironshaper",
	[109] = "Ascendant Lord Obsidius",
	[432] = "Tuten'kash",
	[108] = "Beauty",
	[608] = "Forgemaster Garfrost",
	[107] = "Karsh Steelbender",
	[864] = "Iron Juggernaut",
	[106] = "Corla, Herald of Twilight",
	[609] = "Ick & Krick",
	[737] = "Amber-Shaper Un'sok",
	[865] = "Siegecrafter Blackfuse",
	[105] = "Rom'ogg Bonecrusher",
	[610] = "Scourgelord Tyrannus",
	[185] = "Jin'do the Godbreaker",
	[866] = "Norushen",
	[630] = "Lavanthor",
	[611] = "Meathook",
	[370] = "Lord Roccor",
	[867] = "Sha of Pride",
	[434] = "Glutton",
	[612] = "Salramm the Fleshcrafter",
	[829] = "Twin Consorts",
	[868] = "Galakras",
	[857] = "Chi-Ji, The Red Crane",
	[613] = "Chrono-Lord Epoch",
	[741] = "Wind Lord Mel'jarak",
	[869] = "Garrosh Hellscream",
	[125] = "Earthrager Ptah",
	[154] = "The Conclave of Wind",
	[742] = "Tsulong",
	[870] = "Spoils of Pandaria",
	[819] = "Horridon",
	[615] = "Bronjahm",
	[372] = "Ring of Law",
	[431] = "Princess Theradras",
	[174] = "Nefarian's End",
	[616] = "Devourer of Souls",
	[744] = "Blade Lord Ta'yak",
	[622] = "Drakos the Interrogator",
	[621] = "Keristrasza",
	[617] = "Commander Stoutbeard",
	[745] = "Imperial Vizier Zor'lok",
	[373] = "Pyromancer Loregrain",
	[139] = "Argaloth",
	[155] = "Al'Akir",
	[187] = "Nalorakk",
	[614] = "Mal'Ganis",
	[743] = "Grand Empress Shek'zeer",
	[619] = "Anomalus",
	[374] = "Lord Incendius",
	[438] = "Death Speaker Jargba",
	[171] = "Atramedes",
	[620] = "Ormorok the Tree-Shaper",
	[748] = "Obsidian Sentinel",
	[427] = "Lord Vyletongue",
	[140] = "Occu'thar",
	[311] = "Morchok",
	[749] = "Commander Malor",
	[439] = "Aggem Thorncurse",
	[126] = "Anraphet",
	[156] = "Halfus Wyrmbreaker",
	[188] = "Jan'alai",
	[369] = "High Interrogator Gerstahn",
	[821] = "Megaera",
	[623] = "Varos Cloudstrider",
	[376] = "Fineous Darkvire",
	[440] = "Overlord Ramtusk",
	[817] = "Iron Qon",
	[624] = "Mage-Lord Urom",
	[666] = "Lilian Voss",
	[433] = "Mordresh Fire Eye",
	[430] = "Rotgrip",
	[625] = "Ley-Guardian Eregos",
	[377] = "Bael'Gar",
	[441] = "Agathelos the Raging",
	[339] = "Alizabal, Mistress of Hate",
	[157] = "Theralion and Valiona",
	[189] = "Halazzi",
	[333] = "Madness of Deathwing",
	[825] = "Tortos",
	[627] = "Moragg",
	[378] = "General Angerforge",
	[442] = "Charlga Razorflank",
	[827] = "Jin'rokh the Breaker",
	[628] = "Ichoron",
	[416] = "Cho'Rush the Observer",
	[435] = "Amnennar the Coldbringer",
	[169] = "Omnotron Defense System",
	[629] = "Xevozz",
	[379] = "Golem Lord Argelmach",
	[443] = "Hearthsinger Forresten",
	[371] = "Houndmaster Grebmar",
}
-- END enUS boss list for script --

--- Bosses.
--@description The list of supported bosses: bossId, bossName
--@class table
--@name lib.enUSbossList
--@field 89 Glubtok
--@field 90 Helix Gearbreaker
--@field 91 Foe Reaper 5000
--@field 92 Admiral Ripsnarl
--@field 93 "Captain" Cookie
--@field 95 Vanessa VanCleef
--@field 96 Baron Ashbury
--@field 97 Baron Silverlaine
--@field 98 Commander Springvale
--@field 99 Lord Walden
--@field 100 Lord Godfrey
--@field 101 Lady Naz'jar
--@field 102 Commander Ulthok, the Festering Prince
--@field 103 Mindbender Ghur'sha
--@field 104 Ozumat
--@field 105 Rom'ogg Bonecrusher
--@field 106 Corla, Herald of Twilight
--@field 107 Karsh Steelbender
--@field 108 Beauty
--@field 109 Ascendant Lord Obsidius
--@field 110 Corborus
--@field 111 Slabhide
--@field 112 Ozruk
--@field 113 High Priestess Azil
--@field 114 Grand Vizier Ertan
--@field 115 Altairus
--@field 116 Asaad, Caliph of Zephyrs
--@field 117 General Husam
--@field 118 Lockmaw
--@field 119 High Prophet Barim
--@field 122 Siamat
--@field 124 Temple Guardian Anhuur
--@field 125 Earthrager Ptah
--@field 126 Anraphet
--@field 127 Isiset, Construct of Magic
--@field 128 Ammunae, Construct of Life
--@field 129 Setesh, Construct of Destruction
--@field 130 Rajh, Construct of Sun
--@field 131 General Umbriss
--@field 132 Forgemaster Throngus
--@field 133 Drahga Shadowburner
--@field 134 Erudax, the Duke of Below
--@field 139 Argaloth
--@field 140 Occu'thar
--@field 154 The Conclave of Wind
--@field 155 Al'Akir
--@field 156 Halfus Wyrmbreaker
--@field 157 Theralion and Valiona
--@field 158 Ascendant Council
--@field 167 Cho'gall
--@field 168 Sinestra
--@field 169 Omnotron Defense System
--@field 170 Magmaw
--@field 171 Atramedes
--@field 172 Chimaeron
--@field 173 Maloriak
--@field 174 Nefarian's End
--@field 175 High Priest Venoxis
--@field 176 Bloodlord Mandokir
--@field 177 Cache of Madness - Gri'lek
--@field 178 Cache of Madness - Hazza'rah
--@field 179 Cache of Madness - Renataki
--@field 180 Cache of Madness - Wushoolay
--@field 181 High Priestess Kilnara
--@field 184 Zanzil
--@field 185 Jin'do the Godbreaker
--@field 186 Akil'zon
--@field 187 Nalorakk
--@field 188 Jan'alai
--@field 189 Halazzi
--@field 190 Hex Lord Malacrass
--@field 191 Daakara
--@field 192 Beth'tilac
--@field 193 Lord Rhyolith
--@field 194 Alysrazor
--@field 195 Shannox
--@field 196 Baleroc, the Gatekeeper
--@field 197 Majordomo Staghelm
--@field 198 Ragnaros
--@field 283 Echo of Tyrande
--@field 285 Echo of Jaina
--@field 289 Murozond
--@field 290 Peroth'arn
--@field 291 Queen Azshara
--@field 292 Mannoroth and Varo'then
--@field 311 Morchok
--@field 317 Hagara the Stormbinder
--@field 318 Spine of Deathwing
--@field 322 Arcurion
--@field 323 Echo of Sylvanas
--@field 324 Warlord Zon'ozz
--@field 325 Yor'sahj the Unsleeping
--@field 331 Ultraxion
--@field 332 Warmaster Blackhorn
--@field 333 Madness of Deathwing
--@field 335 Sha of Doubt
--@field 339 Alizabal, Mistress of Hate
--@field 340 Echo of Baine
--@field 341 Archbishop Benedictus
--@field 342 Asira Dawnslayer
--@field 369 High Interrogator Gerstahn
--@field 370 Lord Roccor
--@field 371 Houndmaster Grebmar
--@field 372 Ring of Law
--@field 373 Pyromancer Loregrain
--@field 374 Lord Incendius
--@field 375 Warder Stilgiss
--@field 376 Fineous Darkvire
--@field 377 Bael'Gar
--@field 378 General Angerforge
--@field 379 Golem Lord Argelmach
--@field 380 Hurley Blackbreath
--@field 381 Phalanx
--@field 382 Ribbly Screwspigot
--@field 383 Plugger Spazzring
--@field 384 Ambassador Flamelash
--@field 385 The Seven
--@field 386 Magmus
--@field 387 Emperor Dagran Thaurissan
--@field 388 Highlord Omokk
--@field 389 Shadow Hunter Vosh'gajin
--@field 390 War Master Voone
--@field 391 Mother Smolderweb
--@field 392 Urok Doomhowl
--@field 393 Quartermaster Zigris
--@field 394 Halycon
--@field 395 Gizrul the Slavener
--@field 396 Overlord Wyrmthalak
--@field 397 Pyroguard Emberseer
--@field 398 Solakar Flamewreath
--@field 399 Warchief Rend Blackhand
--@field 400 The Beast
--@field 401 General Drakkisath
--@field 402 Zevrim Thornhoof
--@field 403 Hydrospawn
--@field 404 Lethtendris
--@field 405 Alzzin the Wildshaper
--@field 406 Tendris Warpwood
--@field 407 Illyanna Ravenoak
--@field 408 Magister Kalendris
--@field 409 Immol'thar
--@field 410 Prince Tortheldrin
--@field 411 Guard Mol'dar
--@field 412 Stomper Kreeg
--@field 413 Guard Fengus
--@field 414 Guard Slip'kik
--@field 415 Captain Kromcrush
--@field 416 Cho'Rush the Observer
--@field 417 King Gordok
--@field 418 Crowd Pummeler 9-60
--@field 419 Grubbis
--@field 420 Viscous Fallout
--@field 421 Electrocutioner 6000
--@field 422 Mekgineer Thermaplugg
--@field 423 Noxxion
--@field 424 Razorlash
--@field 425 Tinkerer Gizlock
--@field 427 Lord Vyletongue
--@field 428 Celebras the Cursed
--@field 429 Landslide
--@field 430 Rotgrip
--@field 431 Princess Theradras
--@field 432 Tuten'kash
--@field 433 Mordresh Fire Eye
--@field 434 Glutton
--@field 435 Amnennar the Coldbringer
--@field 438 Death Speaker Jargba
--@field 439 Aggem Thorncurse
--@field 440 Overlord Ramtusk
--@field 441 Agathelos the Raging
--@field 442 Charlga Razorflank
--@field 443 Hearthsinger Forresten
--@field 445 Timmy the Cruel
--@field 446 Willey Hopebreaker
--@field 448 Instructor Galford
--@field 449 Balnazzar
--@field 450 The Unforgiven
--@field 451 Baroness Anastari
--@field 452 Nerub'enkan
--@field 453 Maleki the Pallid
--@field 454 Magistrate Barthilas
--@field 455 Ramstein the Gorger
--@field 456 Lord Aurius Rivendare
--@field 457 Avatar of Hakkar
--@field 458 Jammal'an the Prophet
--@field 459 Wardens of the Dream
--@field 463 Shade of Eranikus
--@field 464 Hogger
--@field 465 Lord Overheat
--@field 466 Randolph Moloch
--@field 467 Revelosh
--@field 468 The Lost Dwarves
--@field 469 Ironaya
--@field 470 Ancient Stone Keeper
--@field 471 Galgann Firehammer
--@field 472 Grimlok
--@field 473 Archaedas
--@field 474 Lady Anacondra
--@field 475 Lord Cobrahn
--@field 476 Lord Pythas
--@field 477 Kresh
--@field 478 Skum
--@field 479 Lord Serpentis
--@field 480 Verdan the Everliving
--@field 481 Mutanus the Devourer
--@field 482 Hydromancer Velratha
--@field 483 Gahz'rilla
--@field 484 Antu'sul
--@field 485 Theka the Martyr
--@field 486 Witch Doctor Zum'rah
--@field 487 Nekrum & Sezz'ziz
--@field 489 Chief Ukorz Sandscalp
--@field 523 Shirrak the Dead Watcher
--@field 524 Exarch Maladaar
--@field 527 Watchkeeper Gargolmar
--@field 528 Omor the Unscarred
--@field 529 Vazruden the Herald
--@field 530 Selin Fireheart
--@field 531 Vexallus
--@field 532 Priestess Delrissa
--@field 533 Kael'thas Sunstrider
--@field 534 Pandemonius
--@field 535 Tavarok
--@field 536 Yor
--@field 537 Nexus-Prince Shaffar
--@field 538 Lieutenant Drake
--@field 539 Captain Skarloc
--@field 540 Epoch Hunter
--@field 541 Darkweaver Syth
--@field 542 Anzu
--@field 543 Talon King Ikiss
--@field 544 Ambassador Hellmaw
--@field 545 Blackheart the Inciter
--@field 546 Grandmaster Vorpil
--@field 547 Murmur
--@field 548 Zereketh the Unbound
--@field 549 Dalliah the Doomsayer
--@field 550 Wrath-Scryer Soccothrates
--@field 551 Harbinger Skyriss
--@field 552 Chrono Lord Deja
--@field 553 Temporus
--@field 554 Aeonus
--@field 555 The Maker
--@field 556 Broggok
--@field 557 Keli'dan the Breaker
--@field 558 Commander Sarannis
--@field 559 High Botanist Freywinn
--@field 560 Thorngrin the Tender
--@field 561 Laj
--@field 562 Warp Splinter
--@field 563 Mechano-Lord Capacitus
--@field 564 Nethermancer Sepethrea
--@field 565 Pathaleon the Calculator
--@field 566 Grand Warlock Nethekurse
--@field 568 Warbringer O'mrogg
--@field 569 Warchief Kargath Bladefist
--@field 570 Mennu the Betrayer
--@field 571 Rokmar the Crackler
--@field 572 Quagmirran
--@field 573 Hydromancer Thespia
--@field 574 Mekgineer Steamrigger
--@field 575 Warlord Kalithresh
--@field 576 Hungarfen
--@field 577 Ghaz'an
--@field 578 Swamplord Musel'ek
--@field 579 The Black Stalker
--@field 580 Elder Nadox
--@field 581 Prince Taldaram
--@field 582 Jedoga Shadowseeker
--@field 583 Amanitar
--@field 584 Herald Volazj
--@field 585 Krik'thir the Gatewatcher
--@field 586 Hadronox
--@field 587 Anub'arak
--@field 588 Trollgore
--@field 589 Novos the Summoner
--@field 590 King Dred
--@field 591 The Prophet Tharon'ja
--@field 592 Slad'ran
--@field 593 Drakkari Colossus
--@field 594 Moorabi
--@field 595 Eck the Ferocious
--@field 596 Gal'darah
--@field 597 General Bjarngrim
--@field 598 Volkhan
--@field 599 Ionar
--@field 600 Loken
--@field 601 Falric
--@field 602 Marwyn
--@field 603 Escape from Arthas
--@field 604 Krystallus
--@field 605 Maiden of Grief
--@field 606 Tribunal of Ages
--@field 607 Sjonnir the Ironshaper
--@field 608 Forgemaster Garfrost
--@field 609 Ick & Krick
--@field 610 Scourgelord Tyrannus
--@field 611 Meathook
--@field 612 Salramm the Fleshcrafter
--@field 613 Chrono-Lord Epoch
--@field 614 Mal'Ganis
--@field 615 Bronjahm
--@field 616 Devourer of Souls
--@field 617 Commander Stoutbeard
--@field 618 Grand Magus Telestra
--@field 619 Anomalus
--@field 620 Ormorok the Tree-Shaper
--@field 621 Keristrasza
--@field 622 Drakos the Interrogator
--@field 623 Varos Cloudstrider
--@field 624 Mage-Lord Urom
--@field 625 Ley-Guardian Eregos
--@field 626 Erekem
--@field 627 Moragg
--@field 628 Ichoron
--@field 629 Xevozz
--@field 630 Lavanthor
--@field 631 Zuramat the Obliterator
--@field 632 Cyanigosa
--@field 635 Eadric the Pure
--@field 636 Argent Confessor Paletress
--@field 637 The Black Knight
--@field 638 Prince Keleseth
--@field 639 Skarvald & Dalronn
--@field 640 Ingvar the Plunderer
--@field 641 Svala Sorrowgrave
--@field 642 Gortok Palehoof
--@field 643 Skadi the Ruthless
--@field 644 King Ymiron
--@field 649 Raigonn
--@field 654 Armsmaster Harlan
--@field 655 Saboteur Kip'tilak
--@field 656 Flameweaver Koegler
--@field 657 Master Snowdrift
--@field 658 Liu Flameheart
--@field 659 Instructor Chillheart
--@field 660 Houndmaster Braun
--@field 663 Jandice Barov
--@field 664 Lorewalker Stonestep
--@field 665 Rattlegore
--@field 666 Lilian Voss
--@field 668 Ook-Ook
--@field 669 Hoptallus
--@field 670 Yan-Zhu the Uncasked
--@field 671 Brother Korloff
--@field 672 Wise Mari
--@field 673 Gu Cloudstrike
--@field 674 High Inquisitor Whitemane
--@field 675 Striker Ga'dok
--@field 676 Commander Ri'mok
--@field 677 Will of the Emperor
--@field 679 The Stone Guard
--@field 682 Gara'jal the Spiritbinder
--@field 683 Protectors of the Endless
--@field 684 Darkmaster Gandling
--@field 685 Sha of Violence
--@field 686 Taran Zhu
--@field 687 The Spirit Kings
--@field 688 Thalnos the Soulrender
--@field 689 Feng the Accursed
--@field 690 Gekkan
--@field 691 Sha of Anger
--@field 692 General Pa'valak
--@field 693 Vizier Jin'bak
--@field 694 Adarogg
--@field 695 Dark Shaman Koranthal
--@field 696 Slagmaw
--@field 697 Lava Guard Gordoth
--@field 698 Xin the Weaponmaster
--@field 708 Trial of the King
--@field 709 Sha of Fear
--@field 713 Garalon
--@field 725 Salyis's Warband
--@field 726 Elegon
--@field 727 Wing Leader Ner'onok
--@field 728 Blood Guard Porung
--@field 729 Lei Shi
--@field 737 Amber-Shaper Un'sok
--@field 738 Commander Vo'jak
--@field 741 Wind Lord Mel'jarak
--@field 742 Tsulong
--@field 743 Grand Empress Shek'zeer
--@field 744 Blade Lord Ta'yak
--@field 745 Imperial Vizier Zor'lok
--@field 748 Obsidian Sentinel
--@field 749 Commander Malor
--@field 814 Nalak, The Storm Lord
--@field 816 Council of Elders
--@field 817 Iron Qon
--@field 818 Durumu the Forgotten
--@field 819 Horridon
--@field 820 Primordius
--@field 821 Megaera
--@field 824 Dark Animus
--@field 825 Tortos
--@field 826 Oondasta
--@field 827 Jin'rokh the Breaker
--@field 828 Ji-Kun
--@field 829 Twin Consorts
--@field 831 Ra-den
--@field 832 Lei Shen
--@field 834 Grand Champions
--@field 846 Malkorok
--@field 849 The Fallen Protectors
--@field 850 General Nazgrim
--@field 851 Thok the Bloodthirsty
--@field 852 Immerseus
--@field 853 Paragons of the Klaxxi
--@field 856 Kor'kron Dark Shaman
--@field 857 Chi-Ji, The Red Crane
--@field 858 Yu'lon, The Jade Serpent
--@field 859 Niuzao, The Black Ox
--@field 860 Xuen, The White Tiger
--@field 861 Ordos, Fire-God of the Yaungol
--@field 864 Iron Juggernaut
--@field 865 Siegecrafter Blackfuse
--@field 866 Norushen
--@field 867 Sha of Pride
--@field 868 Galakras
--@field 869 Garrosh Hellscream
--@field 870 Spoils of Pandaria
