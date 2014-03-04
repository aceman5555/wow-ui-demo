if not HCoold then return false end
local AceGUI = LibStub("AceGUI-3.0")
local L = HCoold:GetLocale()
local spells = {} -- spells that we can track by system
local spec_spells = {} -- spells that are uniq for each spec of class
local class_talents = {} -- talents for each class
local list_talents = {}
local sybiosis_gain_druid = {}
local sybiosis_gain_raid = {}

--[[
GetSpellInfo
GetSpellLink
GameTooltip
StaticPopupDialogs
StaticPopup_Show
]]--

do -- generate spells list
	HCoold.class_list = { "PALADIN", "PRIEST", "DRUID", "WARLOCK", "HUNTER", "SHAMAN", "MAGE", "ROGUE", "DEATHKNIGHT", "MONK", "WARRIOR" }

	do -- generate spells
		local type1 = {------ type == 1  аура на -дамаг +хил
			{ -- дымовая шашка
				spellID = 76577,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				class = "ROGUE",
				cast_time = 5,
				quality = 1,
			},
			{ -- воин деморализующее знамя (-10% дамаги)
				spellID = 114203,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				cast_time = 15,
				class = "WARRIOR",
				quality = 1,
			},
			{ -- аура благочестия
				spellID = 31821,
				class = "PALADIN", 
				succ = "SPELL_CAST_SUCCESS", --"SPELL_AURA_APPLIED",
				specs = { 0 },
				CD = 180,
				cast_time = 6,
				quality = 1,
			},
			{ -- купол
				spellID = 62618,
				class = "PRIEST", 
				succ = "SPELL_CAST_SUCCESS", --"SPELL_AURA_APPLIED",
				specs = { 1 },
				CD = 180,
				cast_time = 10,
				quality = 1,
			},
			{ -- тотем шаман  !aproved!!aproved!!aproved!!aproved!!aproved!
				spellID = 98008,
				class = "SHAMAN", 
				succ = "SPELL_CAST_SUCCESS",
				specs = { 3 },
				CD = 180,
				cast_time = 6,
				quality = 3,
			},
			{ -- Ободряющий клич
				spellID = 97462,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				class = "WARRIOR",
				cast_time = 10,
				quality = 1,
			},
			{ -- монах дзен-медитация (-90% урона + 5 кастов на монаха)
				spellID = 115176,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				cast_time = 8,
				class = "MONK",
				quality = 1,
			},
			{ -- монах отведение ударов (-20% урона рейду)
				spellID = 115213,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 180,
				cast_time = 6,
				class = "MONK",
				quality = 1,
			},
		}
		local type2 = {------ type == 2 аое хил
			{ -- божественный гимн holy
				spellID = 64843,
				succ = "SPELL_CAST_SUCCESS",
				CD = 180,
				specs = { 2 },
				class = "PRIEST",
				quality = 3,
				cast_time = 8,
			},
			{ -- колодец света
				spellID = 724,
				succ = "SPELL_SUMMON",
				CD = 180,
				specs = { 2 },
				class = "PRIEST",
				trigger = { 126135 },
				quality = 1,
			},
			{ -- спокойствие дру feral
				spellID = 740,
				succ = "SPELL_CAST_SUCCESS",
				CD = 480,
				specs = { 2, 3, },
				class = "DRUID",
				quality = 1,
				cast_time = 8,
			},
			{ -- спокойствие дру balance
				spellID = 740,
				succ = "SPELL_CAST_SUCCESS",
				CD = 480,
				specs = { 1 },
				class = "DRUID",
				quality = 2,
				cast_time = 8,
			},
			{ -- спокойствие дру restor
				spellID = 740,
				succ = "SPELL_CAST_SUCCESS",
				CD = 180,
				specs = { 4 },
				class = "DRUID",
				quality = 3,
				cast_time = 8,
			},
			{ -- монах Восстановление сил (разовый хил хил всему рейду)
				spellID = 115310,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2 },
				CD = 180,
				class = "MONK",
				quality = 1,
			},
		}
		local type3 = {------ type == 3 на ману
			{ -- гимн надежды
				spellID = 64901, -- 64904 - проки на ману
				succ = "SPELL_CAST_SUCCESS",
				CD = 360,
				specs = { 0 },
				class = "PRIEST",
				quality = 3, 
				cast_time = 8,
			},
			{ -- мана тайд !aproved!!aproved!!aproved!!aproved!!aproved!
				spellID = 16190,
				succ = "SPELL_CAST_SUCCESS",
				CD = 180,
				specs = { 3 },
				class = "SHAMAN",
				quality = 3, 
				cast_time = 16,
			},
			{ -- друид озарение
				spellID = 29166,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				class = "DRUID",
				quality = 1,
			},
		}
		local type4 = {------ type == 4  личный кд
			{ -- Ярость шамана (энх)
				spellID = 30823,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2 },
				CD = 60,
				class = "SHAMAN",
				quality = 1,
				cast_time = 15,
			},
			{ -- бабл прист
				spellID = 47585,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 120,
				class = "PRIEST",
				cast_time = 6,
				quality = 1,
			},
			{ -- Ни шагу назад
				spellID = 12975,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 180,
				class = "WARRIOR",
				cast_time = 20,
				quality = 1,
			},
			{ -- Бой на смерть (парирование 100%) вар
				spellID = 118038,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1, 2 },
				CD = 120,
				cast_time = 8,
				class = "WARRIOR",
				quality = 1,
			},
			{ -- Глухая оборона прот
				spellID = 871,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 120,
				class = "WARRIOR",
				cast_time = 12,
				quality = 1,
			},
			{ -- Глухая оборона
				spellID = 871,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1, 2 },
				CD = 300,
				class = "WARRIOR",
				cast_time = 12,
				quality = 1,
			},
			{ -- плащ теней
				spellID = 31224,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 60,
				class = "ROGUE",
				cast_time = 5,
				quality = 1,
			},
			{ -- ускользание
				spellID = 5277,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				class = "ROGUE",
				cast_time = 15,
				quality = 1,
			},
			{ -- маг леденая глыба
				spellID = 45438,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 300,
				class = "MAGE",
				cast_time = 10,
				quality = 1,
			},
			{ -- друид дубовая кожа
				spellID = 22812,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1, 2, 3, },
				CD = 60,
				class = "DRUID",
				cast_time = 12,
				quality = 1,
			},
			{ -- друид дубовая кожа
				spellID = 22812,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 4 },
				CD = 45,
				class = "DRUID",
				cast_time = 12,
				quality = 1,
			},
			{ -- друид мощь урсока
				spellID = 106922,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				class = "DRUID",
				cast_time = 20,
				quality = 1,
			},
			{ -- друид инстинкты выживания (шв)
				spellID = 61336,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2, 3, },
				CD = 180,
				class = "DRUID",
				cast_time = 12,
				quality = 1,
			},
			{ -- варлок твердая решимость (шв)
				spellID = 104773,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				class = "WARLOCK",
				cast_time = 8,
				quality = 1,
			},
			{ -- паладин ревностный защитник
				spellID = 31850,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2 },
				CD = 180,
				cast_time = 10,
				class = "PALADIN",
				quality = 1,
			},
			{ -- паладин бабл
				spellID = 642,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 300,
				cast_time = 8,
				class = "PALADIN",
				quality = 1,
			},
			{ -- паладин шв
				spellID = 86659,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2 },
				CD = 120,
				cast_time = 12,
				class = "PALADIN",
				quality = 1,
			},
			{ -- монах закон кармы (мили дамаг в него перевод в цель)
				spellID = 122470,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 90,
				cast_time = 10,
				class = "MONK",
				quality = 1,
			},
			{ -- хант сдерживание
				spellID = 19263,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 120,
				cast_time = 5,
				class = "HUNTER",
				quality = 1,
			},
			{ -- монах укрепляющий отвар (барскин+ласт стенд)
				spellID = 115203,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				cast_time = 20,
				cast_time = 4,
				class = "MONK",
				quality = 1,
			},
			{ -- дк мини шв
				spellID = 48792,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				cast_time = 12,
				class = "DEATHKNIGHT",
				quality = 1,
			},
			{ -- дк софт кд -20% дамаги
				spellID = 49222,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 60,
				class = "DEATHKNIGHT",
				quality = 1,
			},
			{ -- дк кровь вампира (+хил/хп)
				spellID = 55233,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 60,
				cast_time = 10,
				class = "DEATHKNIGHT",
				quality = 1,
			},
			{ -- маг Путешествие во времени
				spellID = 108978,
				succ = {"SPELL_CAST_SUCCESS", "SPELL_AURA_REMOVED", },
				specs = { 0 },
				CD = 180,
				--cast_time = 15,
				trigger = { 110909 },
				class = "MAGE",
				quality = 1,
			},
		}
		local type5 = {------ type == 5  точечный кд --------------- !aproved!!aproved!!aproved!!aproved!!aproved!
			{ -- крылья 
				spellID = 47788,
				class = "PRIEST",
				specs = { 2 },
				succ = "SPELL_CAST_SUCCESS",
				CD = 180,
				quality = 3,
				cast_time = 10,
			},
			{ -- пска 
				spellID = 33206,
				class = "PRIEST",
				specs = { 1 },
				succ = "SPELL_CAST_SUCCESS",
				CD = 180,
				quality = 3,
				cast_time = 8,
			},
			{ -- друид железная кора (-дамаг рестор)
				spellID = 102342,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 4 },
				CD = 120,
				class = "DRUID",
				cast_time = 12,
				quality = 1,
			},
			{ -- сакрифайс от не прота 
				spellID = 6940,
				class = "PALADIN",
				specs = { 1, 3 },
				succ = "SPELL_CAST_SUCCESS",
				CD = 120,
				cast_time = 12,
			},
			{ -- сакрифайс от прота 
				spellID = 6940,
				class = "PALADIN",
				specs = { 2 },
				succ = "SPELL_CAST_SUCCESS",
				CD = 120,
				quality = 2,
				cast_time = 12,
			},
			{ -- паладин боп
				spellID = 1022,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 300,
				cast_time = 10,
				class = "PALADIN",
				quality = 1,
			},
			{ -- монах Исцеляющий кокон (директ кд на -х дамага и +хил с хотов)
				spellID = 116849,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2 },
				CD = 120,
				cast_time = 12,
				class = "MONK",
				quality = 1,
			},
			{ -- прист вхождение в бездну
				spellID = 108968,
				class = "PRIEST",
				specs = { 0 },
				succ = "SPELL_CAST_SUCCESS",
				CD = 360,
				quality = 1,
				--cast_time = 10,
			},
		}
		local type6 = {------ type == 6  кд на +дамаг 
			{ -- воин знамя с черепом (+20% крита)
				spellID = 114207,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				cast_time = 10,
				class = "WARRIOR",
				quality = 1,
			},
			{ -- Тотем элема огня !aproved!!aproved!!aproved!!aproved!!aproved!
				spellID = 2894,
				class = "SHAMAN",
				specs = { 0 },
				succ = "SPELL_CAST_SUCCESS",
				CD = 300,
				quality = 1,
				cast_time = 60,
			},
			{ -- Тотем элементаля земли !aproved!!aproved!!aproved!!aproved!!aproved!
				spellID = 2062,
				class = "SHAMAN",
				specs = { 0 },
				succ = "SPELL_CAST_SUCCESS",
				CD = 300,
				quality = 1,
				cast_time = 60,
			},
			{ -- Тотем порыва бури !aproved!!aproved!!aproved!!aproved!!aproved!
				spellID = 120668,
				class = "SHAMAN",
				specs = { 0 },
				succ = "SPELL_CAST_SUCCESS",
				CD = 300,
				quality = 1,
				cast_time = 10,
			},
			{ -- войско мертвых дк
				spellID = 42650,
				class = "DEATHKNIGHT",
				specs = { 0 },
				succ = "SPELL_CAST_SUCCESS",
				CD = 600,
				cast_time = 44,
			},
			{ -- Сокрушительный бросок	
				spellID = 64382,
				CD = 300,
				specs = { 0 },
				succ = {"SPELL_CAST_SUCCESS", "SPELL_DAMAGE", "SPELL_MISSED" },
				class = "WARRIOR",
				quality = 2,
				cast_time = 10,
			},
			{ -- шаман бл  !aproved!!aproved!!aproved!!aproved!!aproved!
				spellID = 2825,  -- за аликов 32182
				CD = 300,
				specs = { 0 },
				succ = "SPELL_CAST_SUCCESS",
				class = "SHAMAN",
				quality = 3,
				cast_time = 40,
				trigger = { 32182, },
			},
			{ -- маг бл
				spellID = 80353,
				CD = 300,
				specs = { 0 },
				succ = "SPELL_CAST_SUCCESS",
				class = "MAGE",
				quality = 3,
				cast_time = 40,
			},
			{ -- варлок призыв инфернала
				spellID = 1122,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 600,
				trigger = { 18540, },
				class = "WARLOCK",
				cast_time = 60,
				quality = 1,
			},
			{ -- дк нечестивое бешенство (бафф от нечестивости)
				spellID = 49016,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 180,
				cast_time = 30,
				class = "DEATHKNIGHT",
				quality = 1,
			},
--[[
			{ -- хантер бл ??????????????????????
				spellID = 90355,
				CD = 360,
				specs = { 0 },
				succ = "SPELL_CAST_SUCCESS",
				class = "HUNTER",
				quality = 3,
				cast_time = 40,
			},
--]]
		}
		local type7 = {------ type == 7  возрождения -- SPELL_RESURRECT  ????
			{ -- возрождение Дру 
				spellID = 20484,
				succ = "SPELL_RESURRECT", -- SPELL_RESURRECT
				specs = { 0 },
				CD = 600,
				class = "DRUID",
				quality = 3,
			},
			{ -- возрождение ДК 
				spellID = 61999,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 600,
				class = "DEATHKNIGHT",
				quality = 2,
			},
			--[[ -- unable to track without oRA
			{ -- перерождение шам ???????????????????
				spellID = 20608,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 1800,
				class = "SHAMAN",
				quality = 1,
			},
			--]]
			{ -- воскрешение камнем души
				spellID = 20707,
				succ = { "SPELL_CAST_START" }, --{ "SPELL_RESURRECT", "SPELL_AURA_APPLIED" }, 
				specs = { 0 },
				CD = 900,
				class = "WARLOCK",
				quality = 1,
			},
		}
		local type8 = {------ type == 8  прочее
			----------------- Шаманы
			{ -- Spirit walk (энх фридом)
				spellID = 58875,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2 },
				CD = 60,
				class = "SHAMAN",
				cast_time = 15,
				quality = 1,
			},
			{ -- благосклонность предков (касты на ходу у шамана)
				spellID = 79206,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 120,
				class = "SHAMAN",
				cast_time = 15,
				quality = 1,
			},
			{ -- очищение духа (не рестор шаман)
				spellID = 51886,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1, 2 },
				CD = 8,
				class = "SHAMAN",
				quality = 1,
			},
			{ -- очищение духа (рестор шаман)
				spellID = 77130,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 8,
				class = "SHAMAN",
				quality = 1,
			},
			{ -- пронизывающий ветер (сбитие каста шаман)
				spellID = 57994,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 12,
				class = "SHAMAN",
				quality = 1,
			},
			{ -- сглаз (лягушка шаман)
				spellID = 51514,
				succ = {"SPELL_AURA_REFRESH", "SPELL_AURA_APPLIED", },
				specs = { 0 },
				CD = 45,
				class = "SHAMAN",
				quality = 1,
			},
			{ -- тотем трепета шаман
				spellID = 8143,
				succ =  "SPELL_CAST_SUCCESS",
				specs = { 0 },
				CD = 60,
				class = "SHAMAN",
				cast_time = 6,
				quality = 1,
			},
			{ -- Тотем заземления !aproved!!aproved!!aproved!!aproved!!aproved!
				spellID = 8177,
				class = "SHAMAN",
				specs = { 0 },
				succ = "SPELL_CAST_SUCCESS",
				CD = 25,
				quality = 1,
				cast_time = 15,
			},
			{ -- гром и молния элем
				spellID = 51490,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 45,
				class = "SHAMAN",
				quality = 1,
			},
			
			----------------- Присты
			{ -- духовое рвение (тянулка прист)
				spellID = 73325,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 90,
				class = "PRIEST",
				quality = 1,
			},
			{ -- защита от страха
				spellID = 6346,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				class = "PRIEST",
				quality = 1,
			},
			{ -- исчадие тьмы
				spellID = 34433,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				class = "PRIEST",
				quality = 1,
				cast_time = 12,
			},
			{ -- масс диспел
				spellID = 32375,
				succ = "SPELL_CAST_START", 
				specs = { 0 },
				CD = 15,
				class = "PRIEST",
				quality = 1,
			},
			{ -- диспел
				spellID = 527,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1, 2 },
				CD = 8,
				class = "PRIEST",
				quality = 1,
			},
			{ -- уход в тень
				spellID = 586,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 30,
				class = "PRIEST",
				cast_time = 10,
				quality = 1,
			},
			{ -- архангел диск
				spellID = 81700,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 30,
				class = "PRIEST",
				cast_time = 18,
				quality = 1,
			},
			{ -- внутреннее сосредоточение
				spellID = 89485,
				succ = "SPELL_AURA_REMOVED", 
				specs = { 1 },
				CD = 45,
				class = "PRIEST",
				quality = 1,
			},
			{ -- щит души диск
				spellID = 109964,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 60,
				class = "PRIEST",
				cast_time = 15,
				quality = 1,
			},
			{ -- объятие вампира
				spellID = 15286,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 180,
				class = "PRIEST",
				cast_time = 15,
				quality = 1,
			},
			
			----------------- Вары
			{ -- воин издевательское знамя (таунтит мобов на вара)
				spellID = 114192,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				cast_time = 30,
				class = "WARRIOR",
				quality = 1,
			},
			{ -- Героический прыжок
				spellID = 52174,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 45,
				class = "WARRIOR",
				quality = 1,
			},
			{ -- Зуботычина
				spellID = 6552,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 15,
				class = "WARRIOR",
				quality = 1,
			},
			{ -- Обезоруживание
				spellID = 676,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 60,
				class = "WARRIOR",
				quality = 1,
			},
			{ -- Отражение заклинаний
				spellID = 23920,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 25,
				class = "WARRIOR",
				cast_time = 5,
				quality = 1,
			},
			{ -- Рывок
				spellID = 100,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 20,
				class = "WARRIOR",
				quality = 1,
			},
			{ -- Смертельное спокойствие
				spellID = 85730,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 60,
				class = "WARRIOR",
				quality = 1,
			},
			{ -- Деморализующий крик
				spellID = 1160,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 60,
				class = "WARRIOR",
				cast_time = 10,
				quality = 1,
			},
			
			----------------- Роги
			{ -- долой оружие
				spellID = 51722,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 60,
				class = "ROGUE",
				cast_time = 10,
				quality = 1,
			},
			{ -- исчезновение
				spellID = 1856,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				class = "ROGUE",
				quality = 1,
			},
			{ -- маленькие хитрости 
				spellID = 57934,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 30,
				class = "ROGUE",
				cast_time = 6,
				quality = 1,
			},
			{ -- пинок
				spellID = 1766,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 15,
				class = "ROGUE",
				quality = 1,
			},
			{ -- спринт
				spellID = 2983,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 60,
				class = "ROGUE",
				cast_time = 8,
				quality = 1,
			},
		
			----------------- Маги
			{ -- маг антимагия (сало)
				spellID = 2139,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 24,
				class = "MAGE",
				quality = 1,
			},
			{ -- маг глубокая заморозка
				spellID = 44572,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 30,
				class = "MAGE",
				quality = 1,
			},
			{ -- маг зеркальное изображение
				spellID = 55342,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				class = "MAGE",
				cast_time = 30,
				quality = 1,
			},
			{ -- маг невидимость
				spellID = 66,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 300,
				class = "MAGE",
				cast_time = 23,
				quality = 1,
			},
			{ -- маг прилив сил
				spellID = 12051,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 120,
				class = "MAGE",
				quality = 1,
			},
			{ -- маг скачок
				spellID = 1953,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 15,
				class = "MAGE",
				quality = 1,
			},
			{ -- маг диспел
				spellID = 475,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 8,
				class = "MAGE",
				quality = 1,
			},
			--[[
			{ -- маг столик
				spellID = 43987,
				succ = "SPELL_CAST_START", 
				specs = { 0 },
				CD = 60,
				class = "MAGE",
				quality = 1,
			},--]]
			{ -- маг дыхание дракона
				spellID = 31661,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2 },
				CD = 20,
				class = "MAGE",
				quality = 1,
			},
			{ -- маг призыв пета фростом
				spellID = 31687,
				succ = "SPELL_SUMMON", 
				specs = { 3 },
				CD = 60,
				class = "MAGE",
				quality = 1,
			},
			{ -- маг леденая сфера
				spellID = 84714,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 60,
				cast_time = 10,
				class = "MAGE",
				quality = 1,
			},
			
			----------------- Друид
			{ -- друид порыв
				spellID = 1850,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				class = "DRUID",
				cast_time = 15,
				quality = 1,
			},
			{ -- друид хватка природы
				spellID = 16689,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 60,
				class = "DRUID",
				quality = 1,
			},
			{ -- друид тревожный рев
				spellID = 77764,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 120,
				class = "DRUID",
				trigger = { 106898, },
				cast_time = 8,
				quality = 1,
			},
			{ -- друид звездопад баланс
				spellID = 48505,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 90,
				class = "DRUID",
				quality = 1,
			},
			{ -- друид снятие порчи (не рестор)
				spellID = 2782,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1, 2, 3, },
				CD = 8,
				class = "DRUID",
				quality = 1,
			},
			{ -- друид столп солнечного света (сбитие каста)
				spellID = 78675,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 60,
				class = "DRUID",
				cast_time = 8,
				quality = 1,
			},
			{ -- друид берсерк (котэ+мэдвед)
				spellID = 106951,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2, 3, },
				CD = 180,
				trigger = { 50334, },
				class = "DRUID",
				cast_time = 15,
				quality = 1,
			},
			{ -- друид ферал сбитие каста
				spellID = 80965,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2, 3, },
				CD = 15,
				class = "DRUID",
				trigger = { 80964, },
				quality = 1,
			},
			{ -- друид танк иступление
				spellID = 5229,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 60,
				class = "DRUID",
				quality = 1,
			},
			{ -- друид диспел рестор
				spellID = 88423,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 4 },
				CD = 8,
				class = "DRUID",
				quality = 1,
			},
			
			----------------- Варлок
			{ -- варлок телепортация
				spellID = 48020,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 30,
				class = "WARLOCK",
				quality = 1,
			},
			{ -- варлок занавес сумерек
				spellID = 6229,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 30,
				class = "WARLOCK",
				quality = 1,
			},
			{ -- варлок раскол души
				spellID = 29858,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 120,
				class = "WARLOCK",
				quality = 1,
			},
			{ -- варлок ритуал призыва
				spellID = 698,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 120,
				class = "WARLOCK",
				quality = 1,
			},
			{ -- варлок создание источника душ
				spellID = 29893,
				succ = "SPELL_CREATE", 
				specs = { 0 },
				CD = 120,
				class = "WARLOCK",
				quality = 1,
			},
			{ -- варлок дестро воскрешение пета инста
				spellID = 120451,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 60,
				class = "WARLOCK",
				quality = 1,
			},
			
			----------------- Паладин
			{ -- паладин божественная защита (-40% магии)
				spellID = 498,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 60,
				cast_time = 10,
				class = "PALADIN",
				quality = 1,
			},
			{ -- паладин божественно покровительство (20% хасты хпалу)
				spellID = 31842,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 180,
				cast_time = 20,
				class = "PALADIN",
				quality = 1,
			},
			{ -- паладин лох
				spellID = 633,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 600,
				class = "PALADIN",
				quality = 1,
			},
			{ -- паладин фридом
				spellID = 1044,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 25,
				cast_time = 6,
				class = "PALADIN",
				quality = 1,
			},
			{ -- паладин сальва
				spellID = 1038,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 120,
				class = "PALADIN",
				quality = 1,
			},
			{ -- паладин дефки холик
				spellID = 86669,
				succ = "SPELL_SUMMON", 
				specs = { 1 },
				CD = 300,
				cast_time = 30,
				class = "PALADIN",
				quality = 1,
			},
			{ -- паладин диспел
				spellID = 4987,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 8,
				class = "PALADIN",
				quality = 1,
			},
			{ -- паладин клятва
				spellID = 54428,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 120,
				cast_time = 9,
				class = "PALADIN",
				quality = 1,
			},
			{ -- паладин укор (сбитие каста)
				spellID = 96231,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 15,
				class = "PALADIN",
				quality = 1,
			},
		
			----------------- хантер
			{ -- хант замораживающая ловушка
				spellID = 1499,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1, 2 },
				CD = 30,
				trigger = { 82941, 13809, 60192 },
				class = "HUNTER",
				quality = 1,
			},
			{ -- хант замораживающая ловушка сурв
				spellID = 1499,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 24,
				trigger = { 82941, 13809, 60192 },
				class = "HUNTER",
				quality = 1,
			},
			{ -- хант осветилеьный выстрел
				spellID = 1543,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 20,
				class = "HUNTER",
				quality = 1,
			},
			{ -- хант отрыв
				spellID = 781,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 25,
				class = "HUNTER",
				quality = 1,
			},
			{ -- хант перенаправление
				spellID = 34477,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 30,
				class = "HUNTER",
				quality = 1,
			},
			{ -- хант приказ хозяина (фридом себе)
				spellID = 53271,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 45,
				cast_time = 4,
				class = "HUNTER",
				quality = 1,
			},
		
			------------------ монах
			{ -- монах дизарм :::::::::-------------------------????????
				spellID = 117368,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 60,
				class = "MONK",
				quality = 1,
			},
			{ -- монах встроенная тринка
				spellID = 137562,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1, 3 },
				CD = 120,
				cast_time = 6,
				class = "MONK",
				quality = 1,
			},
			{ -- монах диспел
				spellID = 115450,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 8,
				class = "MONK",
				quality = 1,
			},
			{ -- монах рука-копье (сбитие каста)
				spellID = 116705,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 15,
				class = "MONK",
				quality = 1,
			},
			{ -- монах удар летящего змея
				spellID = 101545,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 25,
				class = "MONK",
				quality = 1,
			},
			{ -- монах chi wave
				spellID = 115098,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 15,
				class = "MONK",
				quality = 1,
			},
			{ -- монах chi burst
				spellID = 123986,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 30,
				class = "MONK",
				quality = 1,
			},
			
			------------------ дк
			{ -- дк антимагический панцирь
				spellID = 48707,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 45,
				cast_time = 5,
				class = "DEATHKNIGHT",
				quality = 1,
			},
			{ -- дк сбитие каста
				spellID = 47528,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 15,
				class = "DEATHKNIGHT",
				quality = 1,
			},
			{ -- дк хваталка
				spellID = 49576,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 25,
				class = "DEATHKNIGHT",
				quality = 1,
			},
			{ -- дк призыв горгульи
				spellID = 49206,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 180,
				cast_time = 30,
				class = "DEATHKNIGHT",
				quality = 1,
			},
			
		}
		local type9 = {--  type == 9  пвп кулдауны на контроль
			{ -- ментальный крик прист фир
				spellID = 8122,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 30,
				class = "PRIEST",
				quality = 1,
			},
			{ -- паладин слепящий свет
				spellID = 115750,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 120,
				class = "PALADIN",
				quality = 1,
			},
			{ -- стан прист
				spellID = 64044,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 45,
				class = "PRIEST",
				quality = 1,
			},
			{ -- сало прист
				spellID = 15487,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 45,
				class = "PRIEST",
				quality = 1,
				cast_time = 5,
			},
			{ -- Устрашающий крик (фир вара)
				spellID = 5246,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 90,
				class = "WARRIOR",
				quality = 1,
			},
			{ -- ослепление
				spellID = 2094,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 120,
				class = "ROGUE",
				quality = 1,
			},
			{ -- маг возгорание
				spellID = 11129,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2 },
				CD = 45,
				class = "MAGE",
				quality = 1,
			},
			{ -- маг кольцо льда
				spellID = 122,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 25,
				class = "MAGE",
				quality = 1,
			},
			{ -- друид танк стан
				spellID = 102795,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 60,
				class = "DRUID",
				quality = 1,
			},
			{ -- друид ферал циклон
				spellID = 33786,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2, 3 },
				CD = 20,
				class = "DRUID",
				quality = 1,
			},
			
			{ -- хант дизориентирующий выстрел
				spellID = 19503,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 30,
				class = "HUNTER",
				quality = 1,
			},
			{ -- хант стан петом бм
				spellID = 19577,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 60,
				class = "HUNTER",
				quality = 1,
			},
			{ -- дк сало
				spellID = 47476,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 60,
				class = "DEATHKNIGHT",
				quality = 1,
			},
			{ -- паладин стан
				spellID = 853,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 60,
				class = "PALADIN",
				quality = 1,
			},
		}
		local type10 = {-- type == 10 кулдауны личные на +дамаг
			{ -- хант, собаки
				spellID = 121818,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 300,
				cast_time = 20,
				class = "HUNTER",
				quality = 1,
			},
			{ -- Дух дикого волка энх
				spellID = 51533,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2 },
				CD = 120,
				cast_time = 15,
				class = "SHAMAN",
				quality = 1,
			},
			{ -- Ярость берсерка
				spellID = 18499,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 30,
				class = "WARRIOR",
				cast_time = 6,
				quality = 1,
			},
			{ -- Безрассудство
				spellID = 1719,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 300,
				class = "WARRIOR",
				cast_time = 12,
				quality = 1,
			},
			{ -- Вендетта
				spellID = 79140,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 120,
				class = "ROGUE",
				cast_time = 20,
				quality = 1,
			},
			{ -- Выброс адреналина
				spellID = 13750,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2 },
				CD = 180,
				class = "ROGUE",
				cast_time = 15,
				quality = 1,
			},
			{ -- теневые клинки
				spellID = 121471,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				class = "ROGUE",
				cast_time = 12,
				quality = 1,
			},
			{ -- Череда убийств
				spellID = 51690,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2 },
				CD = 120,
				class = "ROGUE",
				quality = 1,
			},
			{ -- маг мощь тайной магии
				spellID = 12042,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 90,
				class = "MAGE",
				cast_time = 15,
				quality = 1,
			},
			{ -- маг стылая кровь фрост
				spellID = 12472,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				cast_time = 20,
				class = "MAGE",
				quality = 1,
			},
			{ -- друид парад планет (+dmg)
				spellID = 112071,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 180,
				class = "DRUID",
				cast_time = 15,
				quality = 1,
			},
			{ -- варлок афли +30% хасты
				spellID = 113860,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 120,
				cast_time = 20,
				class = "WARLOCK",
				quality = 1,
			},
			{ -- варлок демон +искусность
				spellID = 113861,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2 },
				CD = 120,
				cast_time = 20,
				class = "WARLOCK",
				quality = 1,
			},
			{ -- паладин дефки ретрик
				spellID = 86698,
				succ = "SPELL_SUMMON", 
				specs = { 3 },
				CD = 300,
				cast_time = 30,
				class = "PALADIN",
				quality = 1,
			},
			{ -- варлок дестро +крит
				spellID = 113858,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 120,
				cast_time = 20,
				class = "WARLOCK",
				quality = 1,
			},
			{ -- паладин крылья
				spellID = 31884,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1, 2 },
				CD = 180,
				cast_time = 20,
				class = "PALADIN",
				quality = 1,
			},
			{ -- паладин крылья
				spellID = 31884,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 3 },
				CD = 120,
				cast_time = 20,
				class = "PALADIN",
				quality = 1,
			},
			{ -- хант быстрая стрельба
				spellID = 3045,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				cast_time = 15,
				class = "HUNTER",
				quality = 1,
			},
			{ -- хант готовность
				spellID = 23989,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 300,
				class = "HUNTER",
				quality = 1,
			},
			{ -- хант бм+дамаг
				spellID = 19574,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 1 },
				CD = 60,
				cast_time = 10,
				class = "HUNTER",
				quality = 1,
			},
			{ -- дк Ледяной столп (+сила фросту)
				spellID = 51271,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 2 },
				CD = 60,
				cast_time = 20,
				class = "DEATHKNIGHT",
				quality = 1,
			},
			{ -- шаман Перерождение 
				spellID = 114049,
				succ = "SPELL_CAST_SUCCESS", 
				specs = { 0 },
				CD = 180,
				cast_time = 15,
				trigger = { 114050, 114051, 114052 },
				class = "SHAMAN",
				quality = 1,
			},
			
		}
		local type11 = { -- type == 11 просто рандомный бред
		}

		local shok = { -- для отладки Шок небес
			spellID = 25914, -- ID спелла
			class = "PALADIN", -- класс, которому принадлежит спелл
			CD = 6, -- кулдаун в секундах у спела
			specs = { 1 },
			succ = "SPELL_HEAL", -- тип ивента, который означает удачное применение , возможен вариант массива { "SPELL_HEAL", "SPELL_AURA_APPLIED" }
			type = 1,  --[[ тип спелла: 
					1 - аура на -дамаг (купол, мастер аур и тд) 
					2 - аое хил (гимн пристов, транквил) 
					3 - на ману (иннеры, гимн на ману, мана тайд) 
					4 - личный кд (айс блок, шв, бабл, отражение) 
					5 - точечный кд (пс, крылья, придание сил)
					6 - кд на +дамаг (варовский -армор, бл)
					7 - возрождения (друид, шаман, дк, лок)
					8 - прочие кд
					9 - кулдауны на контроль (приоритет на пвп)
					10 - кулдауны личные на +дамаг
				]]
			trigger = { 19750, }, -- дополнительные ид с которых триггерится ивент
			cast_time = 5, -- время действия спелла
			quality = 3, -- качество спелла при сортировке 1/nil - плохое 2 - хорошее 3 - лучшее
		}

		for _, i in next, type1 do i.type = 1; table.insert(spells,i) end
		for _, i in next, type2 do i.type = 2; table.insert(spells,i) end
		for _, i in next, type3 do i.type = 3; table.insert(spells,i) end
		for _, i in next, type4 do i.type = 4; table.insert(spells,i) end
		for _, i in next, type5 do i.type = 5; table.insert(spells,i) end
		for _, i in next, type6 do i.type = 6; table.insert(spells,i) end
		for _, i in next, type7 do i.type = 7; table.insert(spells,i) end
		for _, i in next, type8 do i.type = 8; table.insert(spells,i) end
		for _, i in next, type9 do i.type = 9; table.insert(spells,i) end
		for _, i in next, type10 do i.type = 10; table.insert(spells,i) end
		HCoold.config.types_amount = 10
		
		if HCoold.debug then table.insert(spells,shok) end
	end 
		
	do -- generate list_talents
		local list_paladin = {
			-- paladin
			[85499] = { -- скорость света
				spellID = 85499,
				class = "PALADIN",
				CD = 45,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				cast_time = 8,
				quality = 1,
			},
			[105593] = { -- кулак правосудия
				spellID = 105593,
				class = "PALADIN",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				trigger = { 853 },
				quality = 1,
			},
			[20925] = { -- щит небес
				spellID = 20925,
				class = "PALADIN",
				CD = 6,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[114039] = { -- длань очищения
				turn_on = true,
				spellID = 114039,
				class = "PALADIN",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 5,
				-- trigger = {},
				cast_time = 6,
				quality = 1,
			},
			[105809] = { -- святой каратель
				spellID = 105809,
				class = "PALADIN",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 10,
				-- trigger = {},
				cast_time = 18,
				quality = 1,
			},
			[20066] = { -- покаяние
				spellID = 20066,
				class = "PALADIN",
				CD = 15,
				succ = "SPELL_AURA_APPLIED",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[114165] = { -- божественная призма
				spellID = 114165,
				class = "PALADIN",
				CD = 20,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[114158] = { -- молот света
				spellID = 114158,
				class = "PALADIN",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[114157] = { -- смертный приговор
				spellID = 114157,
				class = "PALADIN",
				CD = 60,
				succ = "SPELL_AURA_APPLIED",
				cast_time = 10,
				type = 8,
				trigger = { 114917, 114916 },
				quality = 1,
			},
		}
		local list_druid = { 
			[102280] = { -- астральный скачок
				spellID = 102280,
				class = "DRUID",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[132158] = { -- природная стремительность
				spellID = 132158,
				class = "DRUID",
				CD = 60,
				succ = "SPELL_AURA_REMOVED",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[102359] = { -- Массовое оплетение
				spellID = 102359,
				class = "DRUID",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				-- trigger = {},
				quality = 1,
			},
			[106731] = { -- Перевоплощение
				spellID = 102560,
				class = "DRUID",
				CD = 180,
				cast_time = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 10,
				trigger = { 102543, 102558, 33891 },
				quality = 1,
			},
			[99] = { -- дезориентирующий рык
				spellID = 99,
				class = "DRUID",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				-- trigger = {},
				quality = 1,
			},
			[108238] = { -- обновление
				spellID = 108238,
				class = "DRUID",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[132469] = { -- тайфун
				spellID = 132469,
				class = "DRUID",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				trigger = { 61391 },
				quality = 1,
			},
			[114107] = { -- силы природы
				spellID = 33831,
				class = "DRUID",
				CD = 60,
				cast_time = 15,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				trigger = {102693, 102703, 102706},
				quality = 1,
			},
			[102793] = { -- вихрь урсола
				spellID = 102793,
				class = "DRUID",
				CD = 60,
				cast_time = 10,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				-- trigger = {},
				quality = 1,
			},
			[5211] = { -- мощное оглушение
				spellID = 5211,
				class = "DRUID",
				CD = 50,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				-- trigger = {},
				quality = 1,
			},
			[102351] = { -- щит кенария
				spellID = 102351,
				class = "DRUID",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[102401] = { -- стремительный рывок
				spellID = 102401,
				class = "DRUID",
				CD = 15,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				trigger = {16979, 49376, 102417, 102383, 102416},
				quality = 1,
			},
			[108288] = { -- сердце дикой природы
				spellID = 108288,
				class = "DRUID",
				CD = 360,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				trigger = { 108291, 108292, 108293, 108294 },
				cast_time = 45,
				quality = 1,
			},
			[124974] = { -- природная чуткость
				spellID = 124974,
				class = "DRUID",
				CD = 90,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				trigger = { },
				cast_time = 30,
				quality = 1,
			},
		}
		local list_priest = { 
			[108920] = { -- щупальца бездны
				spellID = 108920,
				class = "PRIEST",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				-- trigger = {},
				quality = 1,
			},
			[121536] = { -- божественно перышко
				spellID = 121536,
				class = "PRIEST",
				CD = 10,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[123040] = { -- подчиняющий разум (пет) 
				spellID = 123040,
				class = "PRIEST",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				trigger = { 34433 },
				quality = 1,
			},
			[19236] = { -- молитва отчаяния
				spellID = 19236,
				class = "PRIEST",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[10060] = { -- придание сил
				spellID = 10060,
				class = "PRIEST",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 10,
				-- trigger = {},
				cast_time = 20,
				quality = 1,
			},
			[108921] = { -- ментальный демон
				spellID = 108921,
				class = "PRIEST",
				CD = 45,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				-- trigger = {},
				quality = 1,
			},
			[112833] = { -- призрачный облик
				spellID = 112833,
				class = "PRIEST",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				cast_time = 6,
				quality = 1,
			},
			[605] = { -- господство над разумом
				spellID = 605,
				class = "PRIEST",
				CD = 30,
				succ = "SPELL_AURA_APPLIED",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[108945] = { -- пассивка божественный оплот
				spellID = 108945,
				class = "PRIEST",
				CD = 90,
				succ = "SPELL_AURA_APPLIED",
				type = 8,
				trigger = { 114214 },
				quality = 1,
			},
			[121135] = { -- каскад 
				spellID = 121135,
				class = "PRIEST",
				CD = 25,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[110744] = { -- божественная звезда  
				spellID = 110744,
				class = "PRIEST",
				CD = 15,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[120517] = { -- сияние 
				spellID = 120517,
				class = "PRIEST",
				CD = 40,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
		}
		local list_warlock = { 
			[108359] = { -- темное восстановление (хил и +хил аура)
				spellID = 108359,
				class = "WARLOCK",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				-- trigger = {},
				cast_time = 12,
				quality = 1,
			},
			[5484] = { -- вой ужаса
				spellID = 5484,
				class = "WARLOCK",
				CD = 40,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				-- trigger = {},
				quality = 1,
			},
			[108416] = { -- жертвенный приговор
				spellID = 108416,
				class = "WARLOCK",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				-- trigger = {},
				cast_time = 10,
				quality = 1,
			},
			[108482] = { -- Свободная воля
				spellID = 108482,
				class = "WARLOCK",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[108501] = { -- гримуар служения
				spellID = 108501,
				class = "WARLOCK",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				trigger = { 111859, 111895, 111896, 111897 },
				cast_time = 20,
				quality = 1,
			},
			[6789] = { -- лик тлена
				spellID = 6789,
				class = "WARLOCK",
				CD = 45,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[110913] = { -- темная сделка
				spellID = 110913,
				class = "WARLOCK",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				-- trigger = {},
				cast_time = 16,
				quality = 1,
			},
			[108503] = { -- гримуар жертвоприношения
				spellID = 108503,
				class = "WARLOCK",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				quality = 1,
			},
			[30283] = { -- неистовство тьмы
				spellID = 30283,
				class = "WARLOCK",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				-- trigger = {},
				quality = 1,
			},
			[108505] = { -- месть архимонда 
				spellID = 108505,
				class = "WARLOCK",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				cast_time = 8,
				quality = 1,
			},
--[[
			[119049] = { -- коварство килджедена 
				spellID = 119049,
				class = "WARLOCK",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- trigger = {},
				cast_time = 6,
				quality = 1,
			},
--]]
		}
		local list_dk = {
			[115989] = { -- нечестивая порча
				spellID = 115989,
				class = "DEATHKNIGHT",
				CD = 90,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				cast_time = 10,
				-- trigger = {},
				quality = 1,
			},
			[49039] = { -- перерождение
				spellID = 49039,
				class = "DEATHKNIGHT",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				cast_time = 10,
				-- trigger = {},
				quality = 1,
			},
			[96268] = { -- поступь смерти
				spellID = 96268,
				class = "DEATHKNIGHT",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			[48743] = { -- смертельный союз
				spellID = 48743,
				class = "DEATHKNIGHT",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				-- cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			[51052] = { -- зона антимагии
				spellID = 51052,
				class = "DEATHKNIGHT",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 1,
				cast_time = 10,
				-- trigger = {},
				quality = 1,
			},
			[108194] = { -- афиксия
				spellID = 108194,
				class = "DEATHKNIGHT",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				cast_time = 5,
				-- trigger = {},
				quality = 1,
			},
			[114556] = { -- очищение
				spellID = 114556,
				class = "DEATHKNIGHT",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				cast_time = 3,
				trigger = { 116888, 123981 },
				quality = 1,
			},
			[108199] = { -- хватка Кровожада
				spellID = 108199,
				class = "DEATHKNIGHT",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				--cast_time = 3,
				--trigger = {  },
				quality = 1,
			},
			[108200] = { -- беспощадность зимы
				spellID = 108200,
				class = "DEATHKNIGHT",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				cast_time = 8,
				--trigger = {  },
				quality = 1,
			},
			[108201] = { -- оскверненная земля
				spellID = 108201,
				class = "DEATHKNIGHT",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				cast_time = 10,
				--trigger = {  },
				quality = 1,
			},
		}
		local list_monk = { --?????????
			[116841] = { -- тигриное рвение
				spellID = 116841,
				class = "MONK",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			[119392] = { -- несущийся бык
				spellID = 119392,
				class = "MONK",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				-- cast_time = 100,
				-- trigger = {},
				quality = 1,
			},
			[122278] = { -- смягчение удара
				spellID = 122278,
				class = "MONK",
				CD = 90,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				-- cast_time = 100,
				-- trigger = {},
				quality = 1,
			},
			[119381] = { -- круговой удар ногой
				spellID = 119381,
				class = "MONK",
				CD = 45,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				-- cast_time = 100,
				-- trigger = {},
				quality = 1,
			},
			[122783] = { -- расыление магии
				spellID = 122783,
				class = "MONK",
				CD = 90,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			[123904] = { -- призыв сюзня, белого тигра ??????????
				spellID = 123904,
				class = "MONK",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 6,
				cast_time = 45,
				-- trigger = {},
				quality = 1,
			},
			[116844] = { -- круг мира (сало на 3 при касте, дизарм + нельзя автоатаки)
				spellID = 116844,
				class = "MONK",
				CD = 45,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				cast_time = 8,
				-- trigger = {},
				quality = 1,
			},
		}
		local list_hunter = { --???????
			[34490] = { -- глушаший выстрел
				spellID = 34490,
				class = "HUNTER",
				CD = 24,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[109304] = { -- живость
				spellID = 109304,
				class = "HUNTER",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			[82726] = { -- рвение
				spellID = 82726,
				class = "HUNTER",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 10,
				cast_time = 10,
				-- trigger = {},
				quality = 1,
			},
			[131894] = { -- стая воронов
				spellID = 131894,
				class = "HUNTER",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 10,
				cast_time = 30,
				-- trigger = {},
				quality = 1,
			},
			[19386] = { -- укус виверны
				spellID = 19386,
				class = "HUNTER",
				CD = 45,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				-- cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			[120679] = { -- ужасный зверь
				spellID = 120679,
				class = "HUNTER",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 10,
				cast_time = 15,
				trigger = { 122802 },
				quality = 1,
			},
			[120697] = { -- ярость рыси
				spellID = 120697,
				class = "HUNTER",
				CD = 90,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			[109248] = { -- связующий выстрел
				spellID = 109248,
				class = "HUNTER",
				CD = 45,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				-- cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			[109259] = { -- мощный выстрел ??????????
				spellID = 109259,
				class = "HUNTER",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			[120360] = { -- шквал ??????????????
				spellID = 120360,
				class = "HUNTER",
				CD = 45,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
		}
		local list_shaman = {
			[30884] = { -- страж природы +
				spellID = 30884,
				class = "SHAMAN",
				CD = 30,
				succ = "SPELL_AURA_APPLIED",
				type = 8,
				cast_time = 10,
				trigger = { 31616 },
				quality = 1,
			},
			[108270] = { -- тотем каменной преграды +
				spellID = 108270,
				class = "SHAMAN",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[108271] = { -- астральный сдвиг
				spellID = 108271,
				class = "SHAMAN",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			[51485] = { -- тотем хватки земли +
				spellID = 51485,
				class = "SHAMAN",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
			[108273] = { -- тотем ветроступа +
				spellID = 108273,
				class = "SHAMAN",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			[108285] = { -- зов стихий +
				spellID = 108285,
				class = "SHAMAN",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[16166] = { -- покорение стихий +
				spellID = 16166,
				class = "SHAMAN",
				CD = 90,
				succ = "SPELL_CAST_SUCCESS",
				type = 10,
				cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
			[16188] = { -- стремительность предков +
				spellID = 16188,
				class = "SHAMAN",
				CD = 60,
				succ = "SPELL_AURA_REMOVED",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[108280] = { -- тотем целительного прилива +
				turn_on = true,
				spellID = 108280,
				class = "SHAMAN",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 2,
				cast_time = 10,
				-- trigger = {},
				quality = 1,
			},
			[108281] = { -- наставления предков +
				spellID = 108281,
				class = "SHAMAN",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				cast_time = 10,
				-- trigger = {},
				quality = 1,
			},
		}
		local list_mage = { 
			[12043] = { -- величие разума
				spellID = 12043,
				class = "MAGE",
				CD = 90,
				succ = "SPELL_AURA_REMOVED",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[115610] = { -- барьер времени
				spellID = 115610,
				class = "MAGE",
				CD = 25,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				cast_time = 4,
				-- trigger = {},
				quality = 1,
			},
			[113724] = { -- кольцо мороза
				spellID = 113724,
				class = "MAGE",
				CD = 45,
				succ = "SPELL_SUMMON",
				type = 9,
				cast_time = 10,
				-- trigger = {},
				quality = 1,
			},
			[108839] = { -- плавучая льдина
				spellID = 108839,
				class = "MAGE",
				CD = 45,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[108843] = { -- молниеносность
				spellID = 108843,
				class = "MAGE",
				CD = 25,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[111264] = { -- ледяной заслон
				spellID = 111264,
				class = "MAGE",
				CD = 20,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[11426] = { -- леденая преграда
				spellID = 11426,
				class = "MAGE",
				CD = 25,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[102051] = { -- леденая хватка
				spellID = 102051,
				class = "MAGE",
				CD = 20,
				succ = "SPELL_AURA_APPLIED",
				type = 9,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[110959] = { -- великая неведимость
				spellID = 110959,
				class = "MAGE",
				CD = 90,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				cast_time = 23,
				trigger = { 110960, 66 },
				quality = 1,
			},
			[86949] = { -- прижигание
				spellID = 86949,
				class = "MAGE",
				CD = 120,
				succ = "SPELL_AURA_APPLIED",
				type = 4,
				-- cast_time = 3,
				trigger = { 87024, 87023 },
				quality = 1,
			},
			[11958] = { -- холодная хватка
				spellID = 11958,
				class = "MAGE",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[1463] = { -- щит заклинателя
				spellID = 1463,
				class = "MAGE",
				CD = 25,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
		}
		local list_rogue = { 
			[74001] = { -- боевая готовность
				spellID = 74001,
				class = "ROGUE",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
			[31230] = { -- обман смерти
				spellID = 31230,
				class = "ROGUE",
				CD = 90,
				succ = "SPELL_AURA_APPLIED",
				type = 4,
				-- cast_time = 3,
				trigger = { 45182 },
				quality = 1,
			},
			[14185] = { -- подготовка
				spellID = 14185,
				class = "ROGUE",
				CD = 300,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[36554] = { -- шаг сквозь тень
				spellID = 36554,
				class = "ROGUE",
				CD = 24,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
		}
		local list_warrior = {
			[103826] = { -- неудержимость +
				spellID = 100,
				class = "WARRIOR",
				CD = 12,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[55694] = { -- безудержное восстановление +
				spellID = 55694,
				class = "WARRIOR",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[103840] = { -- верная победа +
				spellID = 103840,
				class = "WARRIOR",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[107566] = { -- ошеломляющий крик +
				spellID = 107566,
				class = "WARRIOR",
				CD = 40,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				cast_time = 5,
				-- trigger = {},
				quality = 1,
			},
			[102060] = { -- разрушительный крик +
				spellID = 102060,
				class = "WARRIOR",
				CD = 40,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				cast_time = 4,
				-- trigger = {},
				quality = 1,
			},
			[46924] = { -- вихрь клинков +
				spellID = 46924,
				class = "WARRIOR",
				CD = 90,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = { 50622 },
				quality = 1,
			},
			[46968] = { -- ударная волна +
				spellID = 46968,
				class = "WARRIOR",
				CD = 20,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				cast_time = 4,
				-- trigger = {},
				quality = 1,
			},
			[118000] = { -- рев дракона +
				spellID = 118000,
				class = "WARRIOR",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[114028] = { -- Массовое отражение заклинания +
				spellID = 114028,
				class = "WARRIOR",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				-- cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			[114029] = { -- охрана
				spellID = 114029,
				class = "WARRIOR",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 5,
				cast_time = 6,
				trigger = { 3411 },
				quality = 1,
			},
			[114030] = { -- бдительность
				spellID = 114030,
				class = "WARRIOR",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 5,
				cast_time = 12,
				-- trigger = {},
				quality = 1,
			},
			[107574] = { -- аватара 
				spellID = 107574,
				class = "WARRIOR",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 10,
				cast_time = 24,
				-- trigger = {},
				quality = 1,
			},
			[12292] = { -- кровавая бойня
				spellID = 12292,
				class = "WARRIOR",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 10,
				cast_time = 12,
				-- trigger = {},
				quality = 1,
			},
			[107570] = { -- удар громовержца
				spellID = 107570,
				class = "WARRIOR",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
		}
		
		for k, i in next, list_paladin do list_talents[k] =  i end
		for k, i in next, list_druid do list_talents[k] =  i end
		for k, i in next, list_priest do list_talents[k] =  i end
		for k, i in next, list_warlock do list_talents[k] =  i end
		for k, i in next, list_dk do list_talents[k] =  i end
		for k, i in next, list_monk do list_talents[k] =  i end
		for k, i in next, list_hunter do list_talents[k] =  i end
		for k, i in next, list_shaman do list_talents[k] =  i end
		for k, i in next, list_mage do list_talents[k] =  i end
		for k, i in next, list_rogue do list_talents[k] =  i end
		for k, i in next, list_warrior do list_talents[k] =  i end
		
		for _, i in next, list_talents do i.talent = true end
	end

	do -- generate spec_spells
		table.insert(spec_spells, { -- паладин 1 holy 2 prot 3 retri
			class = "PALADIN",
			specs = {
				[1] = { -- holy
					{ id = 82326, }, -- божественный свет
					{ id = 31842, }, -- божественное покровительство
					{ id = 86273, }, -- озаряющее исцеление
					{ id = 86669, }, -- защитник древних королей
					{ id = 2812, }, -- обличение
					{ id = 54149, }, -- прилив света
					{ id = 85222, }, -- свет зари
					{ id = 635, }, -- свет небес
					{ id = 54428, }, -- святая клятва
					{ id = 82327, }, -- святое сияние
					{ id = 88819, }, -- рассвет ?
					{ id = 53563, }, -- частица
					{ id = 25914, }, -- шок небес
				},
				[2] = { -- prot
					{ id = 119072, }, -- гнев небес
					{ id = 26573, }, -- освящение
					{ id = 31850, }, -- ревностный защитник
					{ id = 31935, }, -- щит мстителя
					{ id = 53600, }, -- щит праведника
					{ id = 132403, }, -- щит праведника
					{ id = 114637, }, -- бастион славы
					{ id = 98057, }, -- великий воин света
				},
				[3] = { -- retri
					{ id = 84963, }, -- дознание
					{ id = 53385, }, -- божественная буря
					{ id = 85256, }, -- вердикт храмовника
					{ id = 121783, }, -- освобождение
					{ id = 20164, }, -- печать справедливости
					{ id = 20170, }, -- печать справедливости
					{ id = 879, }, -- экзорцизм
					{ id = 96172, }, -- искусность
					{ id = 59578, }, -- искусство войны
					{ id = 81326, }, -- уязвимость
					{ id = 86698, }, -- дефки
					{ id = 86700, }, -- дефки
					{ id = 86704, }, -- дефки
				},
			},
		})
		table.insert(spec_spells, { -- прист 1 disc 2 holy 3 shadow
			class = "PRIEST",
			specs = {
				[1] = { -- disc
					{ id = 47537, }, -- вознесение??????
					{ id = 62618, }, -- слово силы: барьер
					{ id = 33206, }, -- подавление боли
					{ id = 59889, }, -- лишнее время
					{ id = 47753, }, -- божественное покровительство
					{ id = 47750, }, -- исповедь
					{ id = 47666, }, -- исповедь
					{ id = 89485, }, -- внутреннее сосредоточение
					{ id = 81661, }, -- приверженность
					{ id = 81751, }, -- искупление вины
					{ id = 94472, }, -- искупление вины
					{ id = 77613, }, -- милость
					{ id = 81700, }, -- архангел
					{ id = 109964, }, -- щит души
				},
				[2] = { -- holy 
					{ id = 47788, }, -- оберегающий дух
					{ id = 34861, }, -- круг исцеления
					{ id = 88625, }, -- слово света воздояние
					{ id = 63735, }, -- прозорливость
					{ id = 724, }, -- колодец света
					{ id = 81209, }, -- чакра: воздаяние
					{ id = 81208, }, -- чакра: безмятежность
					{ id = 81206, }, -- чакра: святилище
					{ id = 77489, }, -- отблеск света
					{ id = 88685, }, -- слово света святилище
					{ id = 88686, }, -- святилище тики
					{ id = 88684, }, -- слово света: безмятежность
					{ id = 63544, }, -- мгновенное обновление
				},
				[3] = { -- shadow
					{ id = 15473, }, -- облик тьмы
					{ id = 15407, }, -- пытка разума
					{ id = 15487, }, -- безмолвие
					{ id = 80902, }, -- взрыв разума
					{ id = 73510, }, -- пронзание разума
					{ id = 34914, }, -- прикосновение вампира
					{ id = 34919, }, -- прикосновение вампира
					{ id = 124465, }, -- прикосновение вампира
					{ id = 47585, }, -- слияние с тьмой
					{ id = 2944, }, -- всепожирающая чума
					{ id = 127626, }, -- всепожирающая чума
					{ id = 124467, }, -- всепожирающая чума
					{ id = 64044, }, -- глубинный ужас
					{ id = 15286, }, -- объятья вампира
					{ id = 15290, }, -- объятья вампира
					{ id = 87426, }, -- сумеречный призрак
				},
			},
		})
		table.insert(spec_spells, { -- варлок  1 афли 2 демон 3 дестро -- не полностью демонолог
			class = "WARLOCK",
			specs = {
				[1] = {
					{id = 30108,}, -- нестабильное колдоство
					{id = 48181,}, -- Блуждающий дух
					{id = 980,}, -- агония
					{id = 103103,}, -- гибельная хватка
					{id = 74434,}, -- горящая душа
					{id = 114790,}, -- семя порчи под горящей душой
					{id = 27243,}, -- семя порчи
					{id = 27285,}, -- семя порчи
					{id = 119678,}, -- Обмен душ
					{id = 86121,}, -- Обмен душ
					{id = 1120,}, -- похищение дущи
					{id = 18223,}, -- проклятье изнеможения
					{id = 113860,}, -- Черная душа:страдание
					{id = 60947,}, -- ночной кошмар
				},
				[2] = {
					{id = 114925,}, -- демонический зов
					{id = 1949,}, -- адское пламя
					{id = 103958,}, -- метаморфоза
					{id = 109151,}, -- демонический прыжок
					{id = 6353,}, -- ожог души
					{id = 104027,}, -- ожог души
					{id = 104317,}, -- бес
					{id = 105174,}, -- рука гулдана
					{id = 47960,}, -- пламя тьмы?
					{id = 122355,}, -- огненые недра
					{id = 603,}, -- рок
					{id = 103988,}, -- ближний бой
					{id = 124916,}, -- волна хаоса
					{id = 103988,}, -- фигня какая-то
					{id = 30146,}, -- призыв стража скверны
					{id = 113861,}, -- черная душа знание
				},
				[3] = {
					{id = 348,}, -- жертвенный огонь
					{id = 108683,}, -- огонь и сера
					{id = 17877,}, -- ожог тьмы
					{id = 120451,}, -- пламя зорота
					{id = 17962,}, -- поджигание
					{id = 116858,}, -- стрела хаоса
					{id = 114635,}, -- углеотвод
					{id = 113858,}, -- черная душа разрушение
					{id = 80240,}, -- хаос
					{id = 117828,}, -- обратный поток
				},
			},
		})
		table.insert(spec_spells, { -- хантер 1 повелитель зверей 2 стрельба 3 выживание
			class = "HUNTER",
			specs = {
				[1] = {
					{id = 34471,}, -- зверь внутри
					{id = 19574,}, -- звериный гнев
					{id = 34026,}, -- взять
					{id = 82692,}, -- сконцентрированный огонь
					{id = 19577,}, -- устрашение
					{id = 83468,}, -- сконцентрированный огонь прок
					{id = 53398,}, -- окрыление
					{id = 53257,}, -- бросок кобры
				},
				[2] = {
					{id = 53209,}, -- Выстрел химеры
					{id = 53353,}, -- выстрел химеры
					{id = 76663,}, -- шальная стрела
					{id = 19434,}, -- прицельный встрел
					{id = 63468,}, -- пронзающие стрелы
					{id = 54227,}, -- быстрая концентрация
					{id = 35101,}, -- контузящий залп
					{id = 82926,}, -- огонь
					{id = 82925,}, -- готовься целься пли
					{id = 53220,}, -- устойчивая концентрация
				},
				[3] = {
					{id = 53301,}, -- разрывной выстрел
					{id = 3674,}, -- Черная стрела
					{id = 83077,}, -- смертельный укус змеи
					{id = 118974,}, -- змеиный яд
					{id = 56453,}, -- на изготовку
					{id = 64803,}, -- западня
				},
			},
		})
		table.insert(spec_spells, { -- шаман 1 elem 2 ench 3 restor 
			class = "SHAMAN",
			specs = {
				[1] = {
					{id = 51490,}, -- гром и молния
					{id = 61882,}, -- землетрясение
					{id = 77762,}, -- волна лавы???
					{id = 88765,}, -- громовые раскаты
					{id = 51470,}, -- клятва стихий
					-- {id = ,}, -- сверкание?
					{id = 16246,}, -- ясность мысли   
					{id = 77451,}, -- прок искусности 
					{id = 45297,}, -- прок искусности
					{id = 45284,}, -- прок искусности
				},
				[2] = {
					{id = 60103,}, -- вскипание лавы
					{id = 53817,}, -- оружие водоворота
					{id = 63375,}, -- изначальная мудрость
					{id = 51533,}, -- дух дикого волка
					{id = 1535,}, -- кольцо огня
					{id = 58875,}, -- поступь духа
					{id = 30823,}, -- ярость шамана
					{id = 30808,}, -- высвобожденная ярость
					{id = 77661,}, -- жгучее пламя
					{id = 26364,}, -- статический шок???
					{id = 16278,}, -- шквал       
					{id = 17364,}, -- удар бури
					{id = 32175,}, -- удар бури
					{id = 32176,}, -- удар бури
				},
				[3] = {
					{id = 61295,}, -- быстрина
					{id = 105284,}, -- стойкость предков
					{id = 77472,}, -- великая волна исцеления
					{id = 331,}, -- волна исцеления
					{id = 77130,}, -- Очищение духа???
					{id = 974,}, -- щит земли
					{id = 53390,}, -- приливные волны
					{id = 52752,}, -- пробуждение предков
					{id = 101033,}, -- упоение
					{id = 16190,}, -- тотем прилива маны
					{id = 98008,}, -- тотем духовой связи  --]]
				},
			},
		})
		table.insert(spec_spells, { -- друид 1 balance 2 cat 3 bear 4 resto 
			class = "DRUID",
			specs = {
				[1] = {
					{id = 16886,}, -- Милость природы
					{id = 81070,}, -- затмение
					{id = 112071,}, -- парад планет
					{id = 81283,}, -- микоз
					{id = 88751,}, -- дикий гриб взрыв
					{id = 89265,}, -- энергия затмения
					{id = 24858,}, -- облик лунного совуха
					{id = 24907,}, -- облик лунного совуха
					{id = 48518,}, -- лунное затмение
					{id = 127663,}, -- астральное соединение
					{id = 48517,}, -- солнечное затмение
					{id = 2912,}, -- звездный огонь
					{id = 78674,}, -- звездный поток
					{id = 48505,}, -- звездопад
					{id = 50288,}, -- звездопад
					{id = 81192,}, -- лунный поток
					{id = 93402,}, -- солнечный огонь
					{id = 93400,}, -- падающие звезды
					{id = 78675,}, -- столп солнечного света
				},
				[2] = {
					{id = 5221,}, -- полоснуть
					{id = 52610,}, -- дикий рев
					{id = 5217,}, -- тигриное неистоство
					{id = 69369,}, -- стремительность хищника
				},
				[3] = {
					{id = 132402,}, -- Дикая защита
					{id = 62606,}, -- Дикая защита
					{id = 5229,}, -- иступление
					{id = 102795,}, -- Медвежьи объятья
				},
				[4] = {
					{id = 48438,}, -- буйный рост
					{id = 8936,}, -- восстановление
					{id = 100977,}, -- гармония
					{id = 48504,}, -- семя жизни
					{id = 81269,}, -- быстрое восстановление
					{id = 102791,}, -- дикий гриб лечение
					{id = 102342,}, -- Железная кора
					{id = 33763,}, -- жизнецвет
					{id = 50464,}, -- покровительство природы
					{id = 88423,}, -- природный целитель
				},
			},
		})
		table.insert(spec_spells, { -- маг 1 arcan 2 fire 3 frost
			class = "MAGE",
			specs = {
				[1] = {
					{id = 30451,}, -- чародейская вспышка
					{id = 36032,}, -- чародейский заряд
					{id = 79683,}, -- чародейские стрелы
					{id = 7268,}, -- чародейские стрелы
					{id = 44425,}, -- чародейский обстрел
					{id = 31589,}, -- замедление
					{id = 12042,}, -- мощь тайной магии
				},
				[2] = {
					{id = 11129,}, -- возгорание
					{id = 118271,}, -- возгорание
					{id = 31661,}, -- дыхание дракона
					{id = 11366,}, -- огненая глыба
					{id = 12654,}, -- воспламенение
					{id = 133,}, -- огненый шар
					{id = 108853,}, -- пламенный взрыв
					{id = 48107,}, -- разогрев
				},
				[3] = {
					{id = 12472,}, -- стылая кровь
					{id = 116,}, -- леденая стрела
					{id = 84714,}, -- леденая сфера
					{id = 44544,}, -- ледяные пальцы
					{id = 31687,}, -- пет
					{id = 57761,}, -- заморозка мозгов
				},
			},
		})
		table.insert(spec_spells, { -- рога  1 мути 2 комбат 3 субт
			class = "ROGUE",
			specs = {
				[1] = {
					{id = 93068,}, -- Мастер ядоварения
					{id = 79140,}, -- Вендетта
					{id = 32645,}, -- отравление
					{id = 27576,}, -- Расправа
					{id = 1329,}, -- Расправа
					{id = 5374,}, -- Расправа
					{id = 111240,}, -- Устранение
					{id = 121153,}, -- Слепая зона
				},
				[2] = {
					{id = 57841,}, -- Череда убийств
					{id = 57842,}, -- Череда убийств
					{id = 51690,}, -- Череда убийств
					{id = 84745,}, -- Поверхностное понимание
					{id = 84746,}, -- Умеренное понимание
					{id = 84747,}, -- Глубокое понимание
					{id = 13877,}, -- Шквал клинков
					{id = 86392,}, -- Искусность Правой, левой
					{id = 84617,}, -- Пробивающий удар
					{id = 35546,}, -- Боевой потенциал
					{id = 13750,}, -- Выброс адреналина
				},
				[3] = {
					{id = 91021,}, -- Поиск слабости?
					{id = 51713,}, -- Танец теней
					{id = 14183,}, -- Умысел
					{id = 16511,}, -- Кровоизлияние
					{id = 89775,}, -- Кровоизлияние
					{id = 53,}, -- Удар в спину
				},
			},
		})
		table.insert(spec_spells, { -- дк 1 blood 2 frost 3 unholy
			class = "DEATHKNIGHT",
			specs = {
				[1] = {
					{id = 55050,}, -- удар в сердце
					{id = 81256,}, -- танцующее руническое оружие
					{id = 49028,}, -- танцующее руническое оружие
					{id = 48982,}, -- захват рун
					{id = 49222,}, -- костяной щит
					{id = 55233,}, -- кровь вампира
					{id = 56222,}, -- темная власть
					{id = 50421,}, -- запах крови
					{id = 77535,}, -- щит крови
					{id = 50452,}, -- кровавы паразит
				},
				[2] = {
					{id = 49184,}, -- воющий ветер
					{id = 49143,}, -- ледяной удар
					{id = 51124,}, -- машина для убийств
					{id = 59052,}, -- морозная дымка
					{id = 51271,}, -- ледяной столп
					{id = 49020,}, -- уничтожение
				},
				[3] = {
					{id = 55090,}, -- удар плети
					{id = 49206,}, -- призыв горгули +
					{id = 81340,}, -- неумолимый рок
					{id = 49016,}, -- нечестивое бешенство
					{id = 85948,}, -- удар разложения
					{id = 63560,}, -- темное превращение
					{id = 91342,}, -- вливание тьмы
				},
			},
		})
		table.insert(spec_spells, { -- воин 1 arms, 2 fury 3 prot
			class = "WARRIOR",
			specs = {
				[1] = {
					{id = 125831,}, -- Вкус крови
					{id = 12328,}, -- Размащистые удары
					{id = 12294,}, -- Смертельный удар
					{id = 52437,}, -- Внезапная смерть
					{id = 1464,}, -- Мощный удар
					{id = 7384,}, -- Превосходство
					{id = 76858,}, -- Дополнительный выпад
				},
				[2] = {
					{id = 85739,}, -- Кровавый фарш
					{id = 46916,}, -- Прилив крови
					{id = 23881,}, -- кровожадность
					{id = 12968,}, -- Шквал
					{id = 100130,}, -- зверский удар
					{id = 117313,}, -- кровожадное исцеление
					{id = 96103,}, -- Яростный выпад
					{id = 131116,}, -- Яростный выпад
					{id = 85384,}, -- Яростный выпад
					{id = 85288,}, -- Яростный выпад
				},
				[3] = {
					{id = 23922,}, -- Мощный удар щитом
					{id = 2565,}, -- блок щитом
					{id = 132404,}, -- блок щитом
					{id = 1160,}, -- деморализующий крик
					{id = 122510,}, -- ультиматум
					{id = 112048,}, -- непроницаемый щит
					{id = 12975,}, -- ни шагу назад
					{id = 20243,}, -- Сокрушение
					{id = 50227,}, -- Щит и меч
				},
			},
		})
		table.insert(spec_spells, { -- монах 1 хмелевар (танк) 2 Ткач туманов (лекарь) 3 танцующий с ветром (мили)
			class = "MONK",
			specs = {
				[1] = {
					{id = 115069,}, -- стойка быка
					{id = 115295,}, -- зашита
					{id = 128939,}, -- отвар неуловимости
					{id = 115308,}, -- отвар неуловимости
					{id = 115213,}, -- отведение ударов
					{id = 115181,}, -- пламенное дыхание
					{id = 115315,}, -- статуя быка
					{id = 124506,}, -- дар быка
					{id = 122057,}, -- столкновение
					{id = 121253,}, -- удар кружкой
					{id = 115180,}, -- хмельная дымка
					{id = 116330,}, -- хмельная дымка
					{id = 118636,}, -- мощная защита
				},
				[2] = {
					{id = 115070,}, -- стойка мудрой змеи
					{id = 116694,}, -- Благотворный туман
					{id = 116695,}, -- Благотворный туман
					{id = 115310,}, -- Восстановление сил
					{id = 116680,}, -- Громовой чай
					{id = 115151,}, -- Заживляющий туман
					{id = 119611,}, -- Заживляющий туман
					{id = 119607,}, -- Заживляющий туман
					{id = 116670,}, -- Духовный подъем
					{id = 116849,}, -- Исцеляющий кокон
					{id = 132120,}, -- окутывающий туман
					{id = 124682,}, -- окутывающий туман
					{id = 115867,}, -- маначай
					{id = 115294,}, -- маначай
					{id = 115175,}, -- успокаювающий туман
					{id = 125953,}, -- успокаювающий туман
					{id = 116335,}, -- успокаювающий туман
					{id = 117895,}, -- величие статуя
					{id = 126890,}, -- величие
				},
				[3] = {
					{id = 115288,}, -- будоражащий отвар
					{id = 122470,}, -- закон кармы
					{id = 116781,}, -- наследие белого тигра
					{id = 117418,}, -- неистовые кулаки
					{id = 113656,}, -- неистовые кулаки
					{id = 120086,}, -- неистовые кулаки
					{id = 115073,}, -- огненый цветок
					{id = 116740,}, -- отвар тигриной силы
					{id = 125195,}, -- отвар тигриной силы
					{id = 101545,}, -- удар летящего змея
					{id = 130320,}, -- удар восходящего солнца
					{id = 128531,}, -- дот после нокаутирующего удара
					{id = 116768,}, -- прок нокаута
					{id = 118864,}, -- лапа тигра прок
				},
			},
		})
	end

	do -- generate class_talents
		table.insert(class_talents,{ -- паладин
			class = "PALADIN",
			talents = {
				[1] = {
					[1] = 85499,
					[2] = nil,
					[3] = nil,
				},
				[2] = {
					[1] = 105593,
					[2] = 20066,
					[3] = nil,
				},
				[3] = {
					[1] = nil,
					[2] = nil,
					[3] = 20925,
				},
				[4] = {
					[1] = 114039,
					[2] = nil,
					[3] = nil,
				},
				[5] = {
					[1] = 105809,
					[2] = nil,
					[3] = nil,
				},
				[6] = {
					[1] = 114165,
					[2] = 114158,
					[3] = 114157,
				},
			},
		})
		table.insert(class_talents,{ -- прист
			class = "PRIEST",
			talents = {
				[1] = {
					[1] = 108920,
					[2] = 108921,
					[3] = 605,
				},
				[2] = {
					[1] = nil,
					[2] = nil,
					[3] = nil,
				},
				[3] = {
					[1] = nil,
					[2] = 123040,
					[3] = nil,
				},
				[4] = {
					[1] = 19236,
					[2] = 112833,
					[3] = 108945,
				},
				[5] = {
					[1] = nil,
					[2] = 10060,
					[3] = nil,
				},
				[6] = {
					[1] = 121135,
					[2] = 110744,
					[3] = 120517,
				},
			},
		})
		table.insert(class_talents,{ -- друид
			class = "DRUID",
			talents = {
				[1] = {
					[1] = nil,
					[2] = 102280,
					[3] = 102401,
				},
				[2] = {
					[1] = 132158,
					[2] = 108238,
					[3] = 102351,
				},
				[3] = {
					[1] = nil,
					[2] = 102359,
					[3] = 132469,
				},
				[4] = {
					[1] = nil,
					[2] = 106731,
					[3] = 114107,
				},
				[5] = {
					[1] = 99,
					[2] = 102793,
					[3] = 5211,
				},
				[6] = {
					[1] = 108288,
					[2] = nil,
					[3] = 124974,
				},
			},
		})
		table.insert(class_talents,{ -- варлок
			class = "WARLOCK",
			talents = {
				[1] = {
					[1] = 108359,
					[2] = nil,
					[3] = nil,
				},
				[2] = {
					[1] = 5484,
					[2] = 6789,
					[3] = 30283,
				},
				[3] = {
					[1] = nil,
					[2] = 108416,
					[3] = 110913,
				},
				[4] = {
					[1] = nil,
					[2] = nil,
					[3] = 108482,
				},
				[5] = {
					[1] = nil,
					[2] = 108501,
					[3] = 108503,
				},
				[6] = {
					[1] = 108505,
					[2] = nil,
					[3] = nil,
				},
			},
		})
		table.insert(class_talents,{ -- хантер
			class = "HUNTER",
			talents = {
				[1] = {
					[1] = nil,
					[2] = nil,
					[3] = nil,
				},
				[2] = {
					[1] = 34490,
					[2] = 19386,
					[3] = 109248,
				},
				[3] = {
					[1] = 109304,
					[2] = nil,
					[3] = nil,
				},
				[4] = {
					[1] = 82726,
					[2] = 120679,
					[3] = nil,
				},
				[5] = {
					[1] = 131894,
					[2] = nil,
					[3] = 120697,
				},
				[6] = {
					[1] = nil,
					[2] = 109259,
					[3] = 120360,
				},
			},
		})
		table.insert(class_talents,{ -- шаман
			class = "SHAMAN",
			talents = {
				[1] = {
					[1] = 30884,
					[2] = 108270,
					[3] = 108271,
				},
				[2] = {
					[1] = nil,
					[2] = 51485,
					[3] = 108273,
				},
				[3] = {
					[1] = 108285,
					[2] = nil,
					[3] = nil,
				},
				[4] = {
					[1] = 16166,
					[2] = 16188,
					[3] = nil,
				},
				[5] = {
					[1] = 108280,
					[2] = 108281,
					[3] = nil,
				},
				[6] = {
					[1] = nil,
					[2] = nil,
					[3] = nil,
				},
			},
		})
		table.insert(class_talents,{ -- маг
			class = "MAGE",
			talents = {
				[1] = {
					[1] = 12043,
					[2] = nil,
					[3] = 108839,
				},
				[2] = {
					[1] = 115610,
					[2] = 108843,
					[3] = 11426,
				},
				[3] = {
					[1] = 113724,
					[2] = 111264,
					[3] = 102051,
				},
				[4] = {
					[1] = 110959,
					[2] = 86949,
					[3] = 11958,
				},
				[5] = {
					[1] = nil,
					[2] = nil,
					[3] = nil,
				},
				[6] = {
					[1] = nil,
					[2] = nil,
					[3] = 1463,
				},
			},
		})
		table.insert(class_talents,{ -- рога
			class = "ROGUE",
			talents = {
				[1] = {
					[1] = nil,
					[2] = nil,
					[3] = nil,
				},
				[2] = {
					[1] = nil,
					[2] = nil,
					[3] = 74001,
				},
				[3] = {
					[1] = 31230,
					[2] = nil,
					[3] = nil,
				},
				[4] = {
					[1] = 14185,
					[2] = 36554,
					[3] = nil,
				},
				[5] = {
					[1] = nil,
					[2] = nil,
					[3] = nil,
				},
				[6] = {
					[1] = nil,
					[2] = nil,
					[3] = nil,
				},
			},
		})
		table.insert(class_talents,{ -- дк
			class = "DEATHKNIGHT",
			talents = {
				[1] = {
					[1] = nil,
					[2] = nil,
					[3] = 115989,
				},
				[2] = {
					[1] = 49039,
					[2] = 51052,
					[3] = 114556,
				},
				[3] = {
					[1] = 96268,
					[2] = nil,
					[3] = 108194,
				},
				[4] = {
					[1] = 48743,
					[2] = nil,
					[3] = nil,
				},
				[5] = {
					[1] = nil,
					[2] = nil,
					[3] = nil,
				},
				[6] = {
					[1] = 108199,
					[2] = 108200,
					[3] = 108201,
				},
			},
		})
		table.insert(class_talents,{ -- монах
			class = "MONK",
			talents = {
				[1] = {
					[1] = nil,
					[2] = 116841,
					[3] = nil,
				},
				[2] = {
					[1] = nil,
					[2] = nil,
					[3] = nil,
				},
				[3] = {
					[1] = nil,
					[2] = nil,
					[3] = nil,
				},
				[4] = {
					[1] = 116844,
					[2] = 119392,
					[3] = 119381,
				},
				[5] = {
					[1] = nil,
					[2] = 122278,
					[3] = 122783,
				},
				[6] = {
					[1] = nil,
					[2] = 123904,
					[3] = nil,
				},
			},
		})
		table.insert(class_talents,{ -- воин
			class = "WARRIOR",
			talents = {
				[1] = {
					[1] = 103826,
					[2] = nil,
					[3] = nil,
				},
				[2] = {
					[1] = 55694,
					[2] = nil,
					[3] = 103840,
				},
				[3] = {
					[1] = 107566,
					[2] = nil,
					[3] = 102060,
				},
				[4] = {
					[1] = 46924,
					[2] = 46968,
					[3] = 118000,
				},
				[5] = {
					[1] = 114028,
					[2] = 114029,
					[3] = 114030,
				},
				[6] = {
					[1] = 107574,
					[2] = 12292,
					[3] = 107570,
				},
			},
		})
	end
	
	do -- sybiosis generate
		sybiosis_gain_druid = {
			{ -- антимагический панцирь от дк баланс друиду
				spellID = 110570,
				class = "DEATHKNIGHT",
				CD = 45,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 1 },
				cast_time = 5,
				-- trigger = {},
				quality = 1,
			},
			{ -- костяной щит от дк танку друиду
				turn_on = true,
				spellID = 122285,
				class = "DEATHKNIGHT",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				specs = { 3 },
				-- cast_time = 5,
				-- trigger = {},
				quality = 1,
			},
			{ -- незыблемость льда от дк рестор друиду
				spellID = 110575,
				class = "DEATHKNIGHT",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				specs = { 4 },
				cast_time = 12,
				-- trigger = {},
				quality = 1,
			},
			{ -- хант - друид | мисдирект баланс
				spellID = 110588,
				class = "HUNTER",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 1 },
				-- cast_time = 12,
				-- trigger = {},
				quality = 1,
			},
			{ -- хант - друид | фд кот
				spellID = 110597,
				class = "HUNTER",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 2 },
				-- cast_time = 12,
				-- trigger = {},
				quality = 1,
			},
			{ -- хант - друид | ловушка медвед
				spellID = 110600,
				class = "HUNTER",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 3 },
				-- cast_time = 12,
				-- trigger = {},
				quality = 1,
			},
			{ -- хант - друид | сдерживание рестор
				spellID = 110617,
				class = "HUNTER",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				specs = { 4 },
				cast_time = 5,
				-- trigger = {},
				quality = 1,
			},
			{ -- маг - друид | копии баланс
				spellID = 110621,
				class = "MAGE",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 10,
				specs = { 1 },
				cast_time = 30,
				-- trigger = {},
				quality = 1,
			},
			{ -- маг - друид | фрост нова коту
				spellID = 110693,
				class = "MAGE",
				CD = 25,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				specs = { 2 },
				--cast_time = 5,
				-- trigger = {},
				quality = 1,
			},
			{ -- маг - друид | айс блок рестору
				spellID = 110696,
				class = "MAGE",
				CD = 300,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				specs = { 4 },
				cast_time = 10,
				-- trigger = {},
				quality = 1,
			},
			{ -- монах - друид | дизарм балансу
				spellID = 126458,
				class = "MONK",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 1 },
				cast_time = 10,
				-- trigger = {},
				quality = 1,
			},
			{ -- монах - друид | бред типа чарджа коту
				spellID = 126449,
				class = "MONK",
				CD = 35,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 2 },
				-- cast_time = 10,
				-- trigger = {},
				quality = 1,
			},
			{ -- монах - друид | +10% доджа медведю
				spellID = 126453,
				class = "MONK",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 3 },
				cast_time = 8,
				-- trigger = {},
				quality = 1,
			},
			{ -- монах - друид | -дамаг рестору
				spellID = 126456,
				class = "MONK",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				specs = { 4 },
				cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
			{ -- паладин - друид | стан балансу
				spellID = 110698,
				class = "PALADIN",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				specs = { 1 },
				--cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
			{ -- паладин - друид | бабл фералу
				spellID = 110700,
				class = "PALADIN",
				CD = 300,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				specs = { 2 },
				cast_time = 8,
				-- trigger = {},
				quality = 1,
			},
			{ -- паладин - друид | лужа проту
				spellID = 110701,
				class = "PALADIN",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 3 },
				--cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
			{ -- паладин - друид | диспел яд/болезнь рестору
				spellID = 122288,
				class = "PALADIN",
				CD = 8,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 4 },
				--cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
			{ -- прист - друид | масс диспел сове
				spellID = 110707,
				class = "PRIEST",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 1 },
				--cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
			{ -- прист - друид | бабл коту
				spellID = 110715,
				class = "PRIEST",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 2 },
				cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			{ -- прист - друид | защита от страха медведю
				spellID = 110717,
				class = "PRIEST",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 3 },
				--cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
			{ -- прист - друид | тянулка рестору
				spellID = 110718,
				class = "PRIEST",
				CD = 90,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 4 },
				--cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
			{ -- рога - друид | кош балансу
				spellID = 110788,
				class = "ROGUE",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				specs = { 1 },
				cast_time = 5,
				-- trigger = {},
				quality = 1,
			},
			{ -- рога - друид | додж рестору
				spellID = 110791,
				class = "ROGUE",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 4 },
				cast_time = 15,
				-- trigger = {},
				quality = 1,
			},
			{ -- шаман - друид | волки коту
				spellID = 110807,
				class = "SHAMAN",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 2 },
				cast_time = 30,
				-- trigger = {},
				quality = 1,
			},
			{ -- шаман - друид | касты на ходу рестору
				spellID = 110806,
				class = "SHAMAN",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 4 },
				cast_time = 15,
				-- trigger = {},
				quality = 1,
			},
			{ -- варлок - друид | шв балансу
				spellID = 122291,
				class = "WARLOCK",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				specs = { 1 },
				cast_time = 12,
				-- trigger = {},
				quality = 1,
			},
			{ -- варлок - друид | телепортация в круг рестору
				spellID = 112970,
				class = "WARLOCK",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 4 },
				--cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
			{ -- воин - друид | интервейн балансом О_о
				spellID = 122292,
				class = "WARRIOR",
				CD = 30,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 1 },
				--cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
			{ -- воин - друид | раскол брони коту
				spellID = 112997,
				class = "WARRIOR",
				CD = 300,
				succ = {"SPELL_CAST_SUCCESS", "SPELL_DAMAGE", "SPELL_MISSED" },
				type = 6,
				specs = { 2 },
				cast_time = 10,
				-- trigger = {},
				quality = 1,
				turn_on = true,
			},
			{ -- воин - друид | отражение залинаний медведю
				spellID = 113002,
				class = "WARRIOR",
				CD = 120,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 3 },
				cast_time = 5,
				-- trigger = {},
				quality = 1,
			},
			{ -- воин - друид | фир рестору
				spellID = 113004,
				class = "WARRIOR",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type =9,
				specs = { 4 },
				--cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
		}

		local old_symb = {
		}
		
		sybiosis_gain_raid = {
			{ -- дикий гриб чума не блад дк
				spellID = 113516,
				class = "DEATHKNIGHT",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 2, 3 },
				cast_time = 30,
				-- trigger = {},
				quality = 1,
			},
			{ -- хантер порыв
				spellID = 113073,
				class = "HUNTER",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 0 },
				cast_time = 15,
				-- trigger = {},
				quality = 1,
			},
			{ -- монк стан дд
				spellID = 127361,
				class = "MONK",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 9,
				specs = { 2 },
				cast_time = 3,
				-- trigger = {},
				quality = 1,
			},
			{ -- паладин возрождение холик
				spellID = 113269,
				class = "PALADIN",
				CD = 600,
				succ = "SPELL_RESURRECT",
				turn_on = true,
				type = 7,
				specs = { 1 },
				-- cast_time = 15,
				-- trigger = {},
				quality = 1,
			},
			{ -- шп транквил
				spellID = 113277,
				class = "PRIEST",
				CD = 480,
				turn_on = true,
				succ = "SPELL_CAST_SUCCESS",
				type = 2,
				specs = { 3 },
				cast_time = 8,
				-- trigger = {},
				quality = 1,
			},
			{ -- рога медвед+таунт
				spellID = 113613,
				class = "ROGUE",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 0 },
				cast_time = 30,
				-- trigger = {},
				quality = 1,
			},
			{ -- элем+энх столп света
				spellID = 113286,
				class = "SHAMAN",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 1, 2 },
				cast_time = 10,
				-- trigger = {},
				quality = 1,
			},
			{ -- вар тревожный рык (на скорость бега)
				spellID = 122294,
				class = "WARRIOR",
				CD = 300,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 1, 2 },
				cast_time = 8,
				-- trigger = {},
				quality = 1,
			},
			----------------
			{ -- монк Танк сейв
				spellID = 113306,
				class = "MONK",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				specs = { 1 },
				turn_on = true,
				cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			{ -- вар прот - юз на додж
				spellID = 122286,
				class = "WARRIOR",
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 8,
				specs = { 3 },
				cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			{ -- мощь урсока блад дк
				spellID = 113072,
				class = "DEATHKNIGHT",
				CD = 180,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				turn_on = true,
				specs = { 1 },
				cast_time = 20,
				-- trigger = {},
				quality = 1,
			},
			{ -- паладин дубовая кожа прот
				spellID = 113075,
				class = "PALADIN",
				turn_on = true,
				CD = 60,
				succ = "SPELL_CAST_SUCCESS",
				type = 4,
				specs = { 2 },
				cast_time = 6,
				-- trigger = {},
				quality = 1,
			},
			
		}
	
		HCoold.symbiosys_spells_id = { -- массив с ид симбиозов 
			[110309] = true,  -- друид 
			[110478] = true,  -- дк
			[110479] = true,  -- хант
			[110482] = true,  -- маг
			[110484] = true,  -- пал
			[110483] = true,  -- монк
			[110485] = true,  -- прист
			[110486] = true,  -- рога
			[110488] = true,  -- шам
			[110490] = true,  -- варлок
			[110491] = true,  -- вар
		}
	
		for _, i in next, sybiosis_gain_druid do i.symb = "druid" end
		for _, i in next, sybiosis_gain_raid do i.symb = "raid" end
	end
end

function HCoold:MakeSpellList() -- in future - making self.spells that contains spells, that will be tracking by system by user configuration
	self.spells = {}
	for _,i in next, spells do
		local out = tostring(i.spellID)
		for _,j in next, i.specs do
			out = string.format("%s.%d",out,j)
		end
		if self.db.profile.trackSpells[out] == nil then self.db.profile.trackSpells[out] = true end
		if self.db.profile.trackSpells[out] then 
			table.insert(self.spells,i) 
		end
	end
end

function HCoold:GetSpecBySpell(spellID) -- return spec of class if it used this spell (check if spell is spec uniq)
	for _,i in next, spec_spells do
		for spec,j in next, i.specs do
			for _,p in next, j do
				if p.id == spellID then return spec end
			end
		end
	end
	return 0
end

function HCoold:GenerateSpellList()
	local out = {}
	local order = 1
	local t_ = {}
	local out2 = {}
	for _, i in next, spells do
		local t = tostring(i.type)
		if not out[t] then -- create group if it's not exists
			out[t] = {
				type = "group",
				cmdHidden = true,
				name = L["type"..t],
				desc = L["desc type"..t],
				order = i.type+30,
				args = {},
			}
			out2[t] = {}
			t_[t] = true
		end
		do -- spell add
			local spname = select(1, GetSpellInfo(i.spellID)) or L["No spell found"]
			local splink = select(1, GetSpellLink(i.spellID))
			local specs = ""
			local tmp = ""
			for _, j in next, i.specs do 
				specs = string.format("%s%s%s",specs,tmp,j)
				tmp = ", "
			end
			local desc = function(self)
				GameTooltip:ClearLines()
				if splink then
					GameTooltip:SetHyperlink(splink)
				end
				GameTooltip:AppendText("\n")
				GameTooltip:AppendText(string.format(L["class %s specs %s"],L[i.class],L[i.class .. specs]))
				GameTooltip:AppendText("\n")
				return nil
			end
			local tt = tostring(i.spellID)
			for _,j in next, i.specs do
				tt = string.format("%s.%d",tt,j)
			end
			local s = {
				type = "toggle",
				name = spname,
				desc = desc,
				descStyle = "Toggle",
				set = function(tmp,key)
					self.db.profile.trackSpells[tt] = key
				end,
				get = function() 
					return self.db.profile.trackSpells[tt]
				end,
				--order = order,
			}
			--out[t].args[tostring(order)] = s
			--order = order+1
			if not out2[t][i.class] then out2[t][i.class] = {} end
			table.insert(out2[t][i.class],s)
		end
	end
	for t, ss in next, out2 do
		out[t].args.turnoff = {
			type = "execute",
			name = L["turn all off"],
			desc = L["desc turn all off"],
			func = function() for _, i in next, out[t].args do if i.type == "toggle" then i.set(nil,false) end end end,
			order = 1,
		}
		out[t].args.turnon = {
			type = "execute",
			name = L["turn all on"],
			desc = L["desc turn all on"],
			func = function() for _, i in next, out[t].args do if i.type == "toggle" then i.set(nil,true) end end end,
			order = 2,
		}
		local count = 5
		for class, tt in next, ss do
			out[t].args[tostring(count)] = {
				type = "header",
				name = L[class],
				order = count,
			}
			count = count + 1
			for _,i in next, tt do
				i.order = count
				out[t].args[tostring(count)] = i
				count = count + 1
			end
		end
	end
	
	local sm = {}
	for i,j in next, self.sort_methods do sm[i] = j.desc end
	for i in next, t_ do
		local k_ = (tonumber(i) or 1)
		local k = k_ + 5
		-- self:Printf("%s",k)
		--self:Printf("%s %s %s","width" .. i,k,self.db.profile.types[k].w)
		out["header" .. i] = {
			type = "header",
			cmdHidden = true,
			name = L["header" .. i],
			order = k * 10 + 1
		}
		out["width" .. i] = {
			type = "input",
			cmdHidden = true,
			name = L["type width"..i],
			desc = L["desc type width"..i],
			order = k * 10 + 2,
			width = "half",
			set = function(a1,val)
				val = tonumber(val) or 100
				self.db.profile.types[k_].w = val
				if self.types[k_] then self.types[k_]:SetWidth(val) end
			end,
			get = function()
				return tostring(self.db.profile.types[k_].w)
			end,
		}
		
		out["sort" .. i] = {
			type = "select",
			-- width = "half",
			name = L["sort method" .. i],
			desc = L["desc sort method" .. i],
			order = k * 10 + 3,
			cmdHidden = true,
			values = sm,
			get = function() 
				return self.db.profile.types[k_].sm 
			end,
			set = function(tmp, val) 
				self.db.profile.types[k_].sm = val
				if self.types[k_] then self.types[k_]:SetSortMethod(val) end
			end,
		}

		out["enable" .. i] = {
			type = "toggle",
			name = L["enable" .. i],
			desc = L["desc enable" .. i],
			order = k*10 + 4,
			cmdHidden = true,
			set = function(t, val)
				self.db.profile.types[k_].enable = val
				if self.types[k_] then self.types[k_]:Enable(val) end
			end,
			get = function() return self.db.profile.types[k_].enable end,
		}
	end
	
	do -- symbiosys raid
		out["symb_raid"] = {
			type = "group",
			cmdHidden = true,
			name = L["symbiosis raid"],
			desc = L["Track spells for raid"],
			order = 13 + 30,
			args = {},
		}
		local t = out["symb_raid"].args
		for _, i in next, sybiosis_gain_raid do
			local tt = self:SymbiosysSpellIndex(i)
			local spname = select(1, GetSpellInfo(i.spellID)) or L["No spell found"]
			local splink = select(1, GetSpellLink(i.spellID))
			local specs = ""
			local tmp = ""
			for _, j in next, i.specs do 
				specs = string.format("%s%s%s",specs,tmp,j)
				tmp = ", "
			end
			local desc = function(self)
				GameTooltip:ClearLines()
				if splink then
					GameTooltip:SetHyperlink(splink)
				end
				GameTooltip:AppendText("\n")
				GameTooltip:AppendText(string.format(L["class %s specs %s"],L[i.class],L[i.class .. specs]))
				GameTooltip:AppendText(string.format(L["\ntype is %s"],L["type" .. i.type]))
				GameTooltip:AppendText("\n")
				return nil
			end
			t[tt] = {
				type = "toggle",
				name = spname,
				desc = desc,
				descStyle = "Toggle",
				set = function(tmp,key)
					self.db.profile.trackSpells[tt] = key
				end,
				get = function() 
					return self.db.profile.trackSpells[tt]
				end,
				--order = order,
			}
		end
		t.turnoff = {
			type = "execute",
			name = L["turn all off"],
			desc = L["desc turn all off"],
			func = function() for _, i in next, t do if i.type == "toggle" then i.set(nil,false) end end end,
			order = 1,
		}
		t.turnon = {
			type = "execute",
			name = L["turn all on"],
			desc = L["desc turn all on"],
			func = function() for _, i in next, t do if i.type == "toggle" then i.set(nil,true) end end end,
			order = 2,
		}
		t["header"] = {
			type = "header",
			cmdHidden = true,
			name = "",
			order = 3
		}
	end

	do -- symbiosys druid
		out["symb_druid"] = {
			type = "group",
			cmdHidden = true,
			name = L["symbiosis druid"],
			desc = L["Track spells for druid"],
			order = 14 + 30,
			args = {},
		}
		local t = out["symb_druid"].args
		local order = {
			-- ["DRUID"] = 0,
			["PALADIN"] = 1,
			["PRIEST"] = 2,
			["WARLOCK"] = 3,
			["DEATHKNIGHT"] = 4,
			["MONK"] = 5,
			["HUNTER"] = 6,
			["SHAMAN"] = 7,
			["MAGE"] = 8,
			["WARRIOR"] = 9,
			["ROGUE"] = 10,
		}
		for _, i in next, sybiosis_gain_druid do
			local tt = self:SymbiosysSpellIndex(i)
			local spname = select(1, GetSpellInfo(i.spellID)) or L["No spell found"]
			local splink = select(1, GetSpellLink(i.spellID))
			local specs = ""
			local tmp = ""
			for _, j in next, i.specs do 
				specs = string.format("%s%s%s",specs,tmp,j)
				tmp = ", "
			end
			local desc = function(self)
				GameTooltip:ClearLines()
				if splink then
					GameTooltip:SetHyperlink(splink)
				end
				GameTooltip:AppendText("\n")
				GameTooltip:AppendText(string.format(L["class %s specs %s"],L[i.class],L["DRUID" .. specs]))
				GameTooltip:AppendText(string.format(L["\ntype is %s"],L["type" .. i.type]))
				GameTooltip:AppendText("\n")
				return nil
			end
			t[tt] = {
				type = "toggle",
				name = spname,
				desc = desc,
				descStyle = "Toggle",
				set = function(tmp,key)
					self.db.profile.trackSpells[tt] = key
				end,
				get = function() 
					return self.db.profile.trackSpells[tt]
				end,
				order = order[i.class] * 20 + 5,
			}
		end
		t.turnoff = {
			type = "execute",
			name = L["turn all off"],
			desc = L["desc turn all off"],
			func = function() for _, i in next, t do if i.type == "toggle" then i.set(nil,false) end end end,
			order = 1,
		}
		t.turnon = {
			type = "execute",
			name = L["turn all on"],
			desc = L["desc turn all on"],
			func = function() for _, i in next, t do if i.type == "toggle" then i.set(nil,true) end end end,
			order = 2,
		}
		for class, ord in next, order do
			t["header" .. class] = {
				type = "header",
				cmdHidden = true,
				name = L[class],
				order = ord * 20 + 3,
			}
		end
	end
	
	do -- talent section
		out["auto_talent"] = {
			type = "group",
			cmdHidden = true,
			name = L["talents list"],
			desc = L["desc talents list"],
			order = 20 + 30,
			args = {},
		}
		local order = {
			["DRUID"] = 0,
			["PALADIN"] = 1,
			["PRIEST"] = 2,
			["WARLOCK"] = 3,
			["DEATHKNIGHT"] = 4,
			["MONK"] = 5,
			["HUNTER"] = 6,
			["SHAMAN"] = 7,
			["MAGE"] = 8,
			["WARRIOR"] = 9,
			["ROGUE"] = 10,
		}
		local t = out["auto_talent"].args
		t.turnoff = {
			type = "execute",
			name = L["turn all off"],
			desc = L["desc turn all off"],
			func = function() for _, i in next, t do if i.type == "toggle" then i.set(nil,false) end end end,
			order = 1,
		}
		t.turnon = {
			type = "execute",
			name = L["turn all on"],
			desc = L["desc turn all on"],
			func = function() for _, i in next, t do if i.type == "toggle" then i.set(nil,true) end end end,
			order = 2,
		}
		for class, ord in next, order do
			t["header" .. class] = {
				type = "header",
				cmdHidden = true,
				name = L[class],
				order = ord * 30 + 3,
			}
		end
		for k, i in next, list_talents do
			local tt = HCoold:TalentIndex(i)
			
			local spname = select(1, GetSpellInfo(i.spellID)) or L["No spell found"]
			local splink = select(1, GetSpellLink(i.spellID))
			local desc = function(self)
				GameTooltip:ClearLines()
				if splink then
					GameTooltip:SetHyperlink(splink)
				end
				-- GameTooltip:AppendText("\n")
				-- GameTooltip:AppendText(string.format(L["class %s"],L[i.class])) 
				GameTooltip:AppendText(string.format(L["\ntype is %s"],L["type" .. i.type]))
				GameTooltip:AppendText("\n")
				return nil
			end
			t[tt] = {
				type = "toggle",
				name = spname,
				desc = desc,
				descStyle = "Toggle",
				set = function(tmp,key)
					self.db.profile.trackSpells[tt] = key
				end,
				get = function() 
					local tmp = self.db.profile.trackSpells[tt]
					if tmp == nil then self.db.profile.trackSpells[tt] = i.turn_on end
					return self.db.profile.trackSpells[tt]
				end,
				order = order[i.class] * 30 + 5,
			}
			
		end
	end
	
	return out
end

function HCoold:RunPersonalSpellConfig() -- expert configuration
	local pspells = self.db.faction.PlayersSpells
	
	local f = AceGUI:Create("Frame")
	local s = AceGUI:Create("ScrollFrame")
	local AddLine = nil
	local ann_res = false
	do -- frame creation
		f:SetLayout("Fill")
		f.state = true
		f:SetCallback("OnClose",function(widget) 
			f.state = false
			AceGUI:Release(widget) 
	
			if ann_res then
				StaticPopupDialogs["HCooldRedoLayout"]= {
					text = string.format(L["Don't forget to redraw layout to aply settings."]), 
					button1 = ACCEPT,
					timeout = 30, 
					whileDead = 0, 
					hideOnEscape = 1, 
				}
				StaticPopup_Show("HCooldRedoLayout")
			end
			
			HCoold:RunConfig()
		end)
		f:SetTitle(L["Manual spell settings"])

		s:SetLayout("List") -- probably?
		f:AddChild(s)
	end
	
	do -- create tools to create spell info
		local types, types2 = {}, {}
		for _, i in next, spells do
			if not types[i.type] then
				types[i.type] = L["type" .. i.type]
				types2[i.type] = L["type" .. i.type]
			end
		end
		types[13] = L["talents"]
		--table.sort(types)
	
		local sg1 = AceGUI:Create("InlineGroup")
		local csg1 = AceGUI:Create("SimpleGroup")
		do -- sg1
			sg1:SetTitle(L["Add new spell options for current player."])
			sg1:SetFullWidth(true)
			sg1:SetLayout("Flow")
			sg1:SetAutoAdjustHeight(true)
			s:AddChild(sg1)
			csg1:SetFullWidth(true)
			csg1:SetLayout("Flow")
			csg1:SetAutoAdjustHeight(true)
		end
		
		local dd1 = AceGUI:Create("Dropdown") -- types of spell
		local dd2 = AceGUI:Create("Dropdown") -- spell list in this category
		local dd5 = AceGUI:Create("Dropdown") -- type of new spell
		local inp1 = AceGUI:Create("EditBox") -- player name
		local inp2 = AceGUI:Create("EditBox") -- CD in sec
		local inp3 = AceGUI:Create("MultiLineEditBox") -- id of spell
		local inp4 = AceGUI:Create("EditBox") -- casting time
		local inp5 = AceGUI:Create("EditBox") -- trigger event
		local dd3 = AceGUI:Create("Dropdown") -- quality of spell
		local dd4 = AceGUI:Create("Dropdown") -- spec of player to track spell
		local doit = AceGUI:Create("Button") -- button to add spell
		local values = {}
		local splist = {}
		local lines = {}
		local function onValueChanged()
			inp2:SetText()
			inp4:SetText()
			inp5:SetText()
			inp5:Fire("OnEnterPressed")
		end
		do --dd1
			-- sg1:AddChild(dd1)
			dd1:SetList(types)
			dd1:SetWidth(HCoold.config.dropdownwidth)
			dd1:SetCallback("OnValueChanged",function(_,_,key)
				splist = {}
				values = {}
				key = key or 8
				if key ~= 13 then dd5:SetValue(key) end
				dd2:SetValue()
				inp3:SetText("")
				for _, i in next, spells do
					if i.type == key then
						values[i.spellID] = select(1,GetSpellInfo(i.spellID))
						splist[i.spellID] = i
					end
				end
				if key == 13 then
					for _, i in next, list_talents do
						values[i.spellID] = select(1,GetSpellInfo(i.spellID))
						splist[i.spellID] = i
					end
				end
				dd2:SetList(values)
				onValueChanged()
			end)
			dd1:SetCallback("OnEnter",function() 
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(dd1.frame, "ANCHOR_TOP", 0, 0)
				GameTooltip:AddLine(L["Choose category of spell from existsing"])
				GameTooltip:Show()
			end)
			dd1:SetCallback("OnLeave",function() GameTooltip:Hide() end)
			dd1:SetValue(8)
			dd1:Fire("OnValueChanged")
		end
		do -- dd5
			sg1:AddChild(dd5)
			dd5:SetList(types2)
			dd5:SetWidth(HCoold.config.dropdownwidth)
			dd5:SetCallback("OnEnter",function() 
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(dd5.frame, "ANCHOR_TOP", 0, 0)
				GameTooltip:AddLine(L["Choose spell category"])
				GameTooltip:Show()
			end)
			dd5:SetCallback("OnLeave",function() GameTooltip:Hide() end)
			dd5:SetValue(8)
		end
		sg1:AddChild(csg1)
		do --inp3
			inp3:SetWidth(HCoold.config.editboxwidth)
			csg1:AddChild(inp3)
			inp3:SetCallback("OnEnter",function() 
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(inp3.frame, "ANCHOR_TOP", 0, 0)
				GameTooltip:AddLine(L["Enter id of spell"])
				GameTooltip:Show()
			end)
			inp3:SetCallback("OnLeave",function() GameTooltip:Hide() end)
			inp3:SetCallback("OnEnterPressed",function()
				--onValueChanged()
				lines = {}
				local tmp = ""
				local first = ""
				for i in string.gmatch(inp3:GetText(), "%d+") do
					table.insert(lines,tonumber(i))
					tmp = string.format("%s%s%d",tmp,first,i)
					first = "\n"
				end
				inp3:SetText(tmp)
				--HCoold:Print(inp3:GetText())
			end)
		end
		do --dd2 --------- дописать изъятие кд и прочих вещей из БД
			dd2:SetWidth(HCoold.config.dropdownwidth)
			csg1:AddChild(dd1)
			csg1:AddChild(dd2)
			dd2:SetCallback("OnValueChanged",function(_,_,key)
				onValueChanged()
				local spid = key
				if splist[key].trigger then for _, k in next, splist[key].trigger do spid = string.format("%s\n%d",spid,k) end end
				inp3:SetText(spid)
				dd5:SetValue(splist[key].type)
				inp4:SetText(splist[key].cast_time or 0)
				inp2:SetText(splist[key].CD or 0)
				inp5:SetText(splist[key].succ or "SPELL_CAST_SUCCESS")
			end)
			dd2:SetCallback("OnEnter",function() 
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(dd2.frame, "ANCHOR_TOP", 0, 0)
				GameTooltip:AddLine(L["Choose spell id from existsing"])
				GameTooltip:Show()
			end)
			dd2:SetCallback("OnLeave",function() GameTooltip:Hide() end)
		end
		do --inp1
			inp1:SetWidth(HCoold.config.editboxwidth)
			sg1:AddChild(inp1)
			inp1:SetCallback("OnEnter",function() 
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(inp1.frame, "ANCHOR_TOP", 0, 0)
				GameTooltip:AddLine(L["Enter player name"])
				GameTooltip:Show()
			end)
			inp1:SetCallback("OnLeave",function() GameTooltip:Hide() end)
		end
		do --inp2
			inp2:SetWidth(HCoold.config.editboxwidth)
			sg1:AddChild(inp2)
			inp2:SetCallback("OnEnter",function() 
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(inp2.frame, "ANCHOR_TOP", 0, 0)
				GameTooltip:AddLine(L["Enter CD of spell in sec"])
				GameTooltip:Show()
			end)
			inp2:SetCallback("OnLeave",function() GameTooltip:Hide() end)
			inp2:SetCallback("OnEnterPressed",function() inp2:SetText(math.max(0,math.ceil(tonumber(inp2:GetText()) or 0))) end)
		end
		do --inp4
			inp4:SetWidth(HCoold.config.editboxwidth)
			sg1:AddChild(inp4)
			inp4:SetCallback("OnEnter",function() 
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(inp4.frame, "ANCHOR_TOP", 0, 0)
				GameTooltip:AddLine(L["Enter casting time of spell"])
				GameTooltip:Show()
			end)
			inp4:SetCallback("OnLeave",function() GameTooltip:Hide() end)
			inp4:SetCallback("OnEnterPressed",function()
				local v = inp4:GetText()
				v = math.max(0,tonumber(v) or 0)
				inp4:SetText(v)
			end)
		end
		do --dd3
			sg1:AddChild(dd3)
			dd3:SetWidth(HCoold.config.dropdownwidth)
			dd3:SetList({1, 2, 3})
			dd3:SetValue(1)
			dd3:SetCallback("OnEnter",function() 
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(dd3.frame, "ANCHOR_TOP", 0, 0)
				GameTooltip:AddLine(L["Enter quality of spell"])
				GameTooltip:Show()
			end)
			dd3:SetCallback("OnLeave",function() GameTooltip:Hide() end)
		end
		local spec_list = {"0","1","2","3","1,2","1,3","2,3","1,2,3","1,2,4","1,3,4","2,3,4"}
		do --dd4
			sg1:AddChild(dd4)
			dd4:SetList(spec_list)
			dd4:SetWidth(HCoold.config.dropdownwidth)
			dd4:SetCallback("OnValueChanged",function(_,_,key)
			end)
			dd4:SetCallback("OnEnter",function(self)
				GameTooltip:SetOwner(self.frame, "ANCHOR_TOPLEFT", 0, 0)
				GameTooltip:AddLine(L["Spec list by class"])
				GameTooltip:Show()
			end)
			dd4:SetCallback("OnLeave",function() GameTooltip:Hide() end)
		end
		do --inp5
			inp5:SetWidth(HCoold.config.editboxwidth)
			sg1:AddChild(inp5)
			inp5:SetCallback("OnEnter",function() 
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(inp5.frame, "ANCHOR_TOP", 0, 0)
				GameTooltip:AddLine(L["Enter trigger event from combat log"])
				GameTooltip:Show()
			end)
			inp5:SetCallback("OnLeave",function() GameTooltip:Hide() end)
			inp5:SetCallback("OnEnterPressed",function() if inp5:GetText() == "" then inp5:SetText("SPELL_CAST_SUCCESS") end end)
			inp5:Fire("OnEnterPressed")
		end
		do --doit 
			doit:SetWidth(HCoold.config.addbuttonwidth)
			doit:SetText(L["Add spell"])
			sg1:AddChild(doit)
			doit:SetCallback("OnEnter",function(self)
				inp3:Fire("OnEnterPressed")
				local splink = GetSpellLink(lines[1] or 0)
				if not splink then return end
				GameTooltip:SetOwner(self.frame, "ANCHOR_TOPLEFT", 0, 0)
				GameTooltip:SetHyperlink(splink)
				GameTooltip:Show()
			end)
			doit:SetCallback("OnLeave",function() GameTooltip:Hide() end)
		end
		doit:SetCallback("OnClick",function()
			inp2:Fire("OnEnterPressed")
			inp1:Fire("OnEnterPressed")
			inp4:Fire("OnEnterPressed")
			inp5:Fire("OnEnterPressed")
			inp3:Fire("OnEnterPressed")
			local spid, name, cd, casttime, sptype, trigger, quality = lines[1], inp1:GetText(), tonumber(inp2:GetText()) or 0, tonumber(inp4:GetText()) or 0, dd5:GetValue(),inp5:GetText(),dd3:GetValue()
			if cd > 0 and string.len(name) > 0 and spid > 0 and GetSpellInfo(spid) ~= nil then
				local spec_spec = {
					["0"] = { 0 },
					["1"] = { 1 },
					["2"] = { 2 },
					["3"] = { 3 },
					["1,2"] = { 1, 2 },
					["1,3"] = { 1, 3 },
					["2,3"] = { 2, 3 },
					["1,2,3"] = { 1, 2, 3 },
					["1,2,4"] = { 1, 2, 4 },
					["2,3,4"] = { 2, 3, 4 },
					["1,3,4"] = { 1, 3, 4 },
				}
				local i = {
					spellID = spid,
					succ = trigger,
					player = name,
					CD = cd,
					type = sptype,
					cast_time = casttime,
					specs = spec_spec[spec_list[dd4:GetValue() or 1]],
					quality = quality,
				}
				local trigg = {}
				for k = 2, #lines do
					table.insert(trigg,lines[k])
				end
				if #trigg > 0 then i.trigger = trigg end
				table.insert(pspells,i)
				ann_res = true
				AddLine(i)
				f:SetStatusText(L["Cooldown successfully added!"])
			else
				f:SetStatusText(L["You should enter spell id, player name and cooldown of spell."])
			end
		end)
	end
	
	do -- add List of spells
		function DeleteFromMemory(i)
			for k, j in next, pspells do
				if j == i then 
					table.remove(pspells,k)
					f:SetStatusText(L["Cooldown successfulle deleted!"])
				end
			end
		end
		
		AddLine = function(i)
			if not i then return end
			local sg2 = AceGUI:Create("InlineGroup")
			sg2:SetLayout("Flow")
			sg2:SetFullWidth(true)
			s:AddChild(sg2)
			
			local spname,_, spicon = GetSpellInfo(i.spellID)
			if not spname then spname = L["Spell was deleted"] end
			local splink = GetSpellLink(i.spellID) or L["Spell was deleted"]
			
			local label = AceGUI:Create("InteractiveLabel")
			label:SetImageSize(21,21)
			label:SetFullWidth(true)
			label:SetImage(spicon)
			local specs = ""
			local first = nil
			if i.specs then for _, k in next, i.specs do 
				if not first then first = ""
				else first = ", " end
				specs = string.format("%s%s%d",specs,first,k)
			end end
			local out = string.format(L["Spell %s(id=%d, type=%s, quality=%d, specs=%s) for player %s has CD %d sec cast time %.1f and trigger from %s."],
				splink,i.spellID,L["type" .. i.type],i.quality,specs,i.player,i.CD,i.cast_time or 0,i.succ)
			if i.trigger then
				local first, tmp = "", ""
				for _,i in next, i.trigger do
					tmp = string.format("%s%s%d",tmp,first,i)
					first = ", "
				end
				out = out .. string.format(L["another triggers are %s."], tmp)
			end
			label:SetText(out)
			label:SetCallback("OnEnter",function(self)
				GameTooltip:SetOwner(self.frame, "ANCHOR_TOPLEFT", 0, 0)
				if splink ~= L["Spell was deleted"] then GameTooltip:SetHyperlink(splink)
				else
					GameTooltip:AddLine(L["Spell was deleted desc"])
				end
				GameTooltip:Show()
			end)
			label:SetCallback("OnLeave",function() GameTooltip:Hide() end)
			sg2:AddChild(label)
			
			local cb = AceGUI:Create("CheckBox")
			sg2:AddChild(cb)
			cb:SetValue(self.db.profile.trackManualSpells[self:ManualSpellIndex(i)])
			cb:SetWidth(HCoold.config.checkboxwidth)
			cb:SetLabel(L["Track spell"])
			cb:SetCallback("OnValueChanged",function() 
				self.db.profile.trackManualSpells[self:ManualSpellIndex(i)] = cb:GetValue() 
				ann_res = true
			end)
			
			sg2:SetTitle(string.format(L["Configuration for %s spell"],spname))
			local k = AceGUI:Create("Button")
			k:SetWidth(HCoold.config.deletebuttonwidth)
			k:SetText(L["Delete"])
			sg2:AddChild(k)
			k:SetCallback("OnClick",function()
				StaticPopupDialogs["HCooldAcceptDeleteSpell"]= {
					text = string.format(L["You realy want to delete spell %s?"],spname), 
					button1 = ACCEPT,
					button2 = CANCEL,
					timeout = 30, 
					whileDead = 0, 
					hideOnEscape = 1, 
					OnAccept = function() 
						k:SetDisabled(true)
						k:SetText(L["Deleted"])
						DeleteFromMemory(i)
						ann_res = true
					end,
				}
				StaticPopup_Show("HCooldAcceptDeleteSpell")
			end)
		end
		
		for _, i in next, pspells do AddLine(i) end
	end
	
	return f
end

function HCoold:RunTalentsSpellSelection() -- talents configuration
	local f = AceGUI:Create("Frame")
	local s = AceGUI:Create("ScrollFrame")
	local ann_res = false
	local talents = nil
	do -- frame creation
		f:SetLayout("Fill")
		f.state = true
		f:SetCallback("OnClose",function(widget) 
			f.state = false
			AceGUI:Release(widget) 
	
			if ann_res then
				StaticPopupDialogs["HCooldRedoLayout"]= {
					text = string.format(L["Don't forget to redraw layout to aply settings."]), 
					button1 = ACCEPT,
					timeout = 30, 
					whileDead = 0, 
					hideOnEscape = 1, 
				}
				StaticPopup_Show("HCooldRedoLayout")
			end
			
			HCoold:RunConfig()
		end)
		f:SetTitle(L["Manual talent settings"])

		s:SetLayout("List") -- probably?
		f:AddChild(s)
	end
	
	do -- add 6 rows with 3 columns for each class
		local sg0 = AceGUI:Create("SimpleGroup")
		sg0:SetLayout("Flow")
		sg0:SetFullWidth(true)
		s:AddChild(sg0)
		
		local dd1 = AceGUI:Create("Dropdown") -- list of classes
		local dd4 = AceGUI:Create("Dropdown") -- spec of player to track spell
		local inp = AceGUI:Create("EditBox") -- player name
		local button = AceGUI:Create("Button") -- button to apply tracking
		button:SetDisabled(true)
		sg0:AddChild(dd1)
		sg0:AddChild(inp)
		sg0:AddChild(dd4)
		local spec_list = {"0","1","2","3","1,2","1,3","2,3","1,2,3","1,2,4","1,3,4","2,3,4"}
		local spec_spec = {
			["0"] = { 0 },
			["1"] = { 1 },
			["2"] = { 2 },
			["3"] = { 3 },
			["1,2"] = { 1, 2 },
			["1,3"] = { 1, 3 },
			["2,3"] = { 2, 3 },
			["1,2,3"] = { 1, 2, 3 },
			["1,2,4"] = { 1, 2, 4 },
			["2,3,4"] = { 2, 3, 4 },
			["1,3,4"] = { 1, 3, 4 },
		}
		do --dd4
			dd4:SetList(spec_list)
			dd4:SetWidth(HCoold.config.dropdownwidth)
			dd4:SetCallback("OnEnter",function(self)
				GameTooltip:SetOwner(self.frame, "ANCHOR_TOPLEFT", 0, 0)
				GameTooltip:AddLine(L["Spec list by class"])
				GameTooltip:Show()
			end)
			dd4:SetCallback("OnLeave",function() GameTooltip:Hide() end)
		end
		local list = {}
		do -- form list+dropdown for classes
			local tmp = {}
			for _, i in next, class_talents do
				table.insert(list,i.class)
				table.insert(tmp,L[i.class])
			end
			dd1:SetList(tmp)
			dd1:SetCallback("OnEnter",function() 
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(dd1.frame, "ANCHOR_TOP", 0, 0)
				GameTooltip:AddLine(L["Enter player class"])
				GameTooltip:Show()
			end)
			dd1:SetCallback("OnLeave",function() GameTooltip:Hide() end)
		end
		
		do --inp
			inp:SetWidth(HCoold.config.editboxwidth)
			inp:SetCallback("OnEnter",function() 
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(inp.frame, "ANCHOR_TOP", 0, 0)
				GameTooltip:AddLine(L["Enter player name talent"])
				GameTooltip:Show()
			end)
			inp:SetCallback("OnLeave",function() GameTooltip:Hide() end)
		end
		
		local arr = {}
		for i = 1, 6 do
			if not arr[i] then arr[i] = {} end
			local sg = AceGUI:Create("SimpleGroup")
			sg:SetLayout("Flow")
			sg:SetFullWidth(true)
			s:AddChild(sg)
			
			for j = 1, 3 do
				local spid = 62618
				local spname,_, spicon = GetSpellInfo(spid)
				if not spname then spname = L["Spell was deleted"] end
				local splink = GetSpellLink(spid) or L["Spell was deleted"]

				local txt = AceGUI:Create("CheckBox")
				txt:SetLabel(L["no input"])
				txt:SetWidth(HCoold.config.checkboxwidth)
				txt:SetValue(nil)
				txt:SetDisabled(true)
				
				local label = AceGUI:Create("InteractiveLabel")
				label:SetImageSize(40,40)
				label:SetWidth(40)
				label:SetImage(spicon)
				label:SetCallback("OnLeave",function() GameTooltip:Hide() end)

				sg:AddChild(label)
				sg:AddChild(txt)
				
				arr[i][j] = {
					txt = txt,
					img = label,
				}
			end
			
			do -- additional possibilities for checkboxes
				arr[i][1].txt:SetCallback("OnValueChanged",function(_,_,key)
					if key then 
						arr[i][2].txt:SetValue(false)
						arr[i][3].txt:SetValue(false)
					end
				end)
				arr[i][2].txt:SetCallback("OnValueChanged",function(_,_,key)
					if key then 
						arr[i][1].txt:SetValue(false)
						arr[i][3].txt:SetValue(false)
					end
				end)
				arr[i][3].txt:SetCallback("OnValueChanged",function(_,_,key)
					if key then 
						arr[i][1].txt:SetValue(false)
						arr[i][2].txt:SetValue(false)
					end
				end)
			end
		end
		
		dd1:SetCallback("OnValueChanged",function(_,_,key)
			button:SetDisabled(false)
			for _, i in next, class_talents do
				if i.class == list[key] then talents = i.talents end
			end
			f:SetStatusText("")
			
			for j = 1, 3 do
				for i = 1, 6 do
					local spid = talents[i][j]
					arr[i][j].txt:SetValue(false)
					if spid then
						local spname,_, spicon = GetSpellInfo(spid)
						if not spname then spname = L["Spell was deleted"] end
						local splink = GetSpellLink(spid) or L["Spell was deleted"]
						arr[i][j].img:SetCallback("OnEnter",function() 
							GameTooltip:ClearLines()
							GameTooltip:SetOwner(arr[i][j].img.frame, "ANCHOR_TOP", 0, 0)
							if splink ~= L["Spell was deleted"] then GameTooltip:SetHyperlink(splink)
							else
								GameTooltip:AddLine(L["Spell was deleted desc"])
							end
							GameTooltip:Show()
						end)
						arr[i][j].txt:SetDisabled(false)
						arr[i][j].txt:SetLabel(spname)
						arr[i][j].img:SetImage(spicon)
					else
						arr[i][j].txt:SetLabel("")
						arr[i][j].img:SetImage(nil)
						arr[i][j].img:SetCallback("OnEnter",function() end)
						arr[i][j].txt:SetDisabled(true)
					end
				end
			end
		end)
		
		do
			local sg1 = AceGUI:Create("SimpleGroup")
			sg1:SetLayout("Flow")
			sg1:SetFullWidth(true)
			s:AddChild(sg1)
			sg1:AddChild(button)
			
			button:SetText(L["Save tracking for this cooldowns"])
			button:SetCallback("OnEnter",function() 
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(button.frame, "ANCHOR_TOP", 0, 0)
				GameTooltip:AddLine(L["Save tracking for this cooldowns desc"])
				GameTooltip:Show()
			end)
			button:SetCallback("OnLeave",function() GameTooltip:Hide()	end)
			
			local text = AceGUI:Create("Label")
			text:SetFullWidth(true)
			text:SetText(L["desc tracking interface"])
			s:AddChild(text)
		end
		button:SetCallback("OnClick",function() 
			if not talents then return end
			if string.len(inp:GetText()) == 0 then 
				f:SetStatusText(L["Fill name talent"])
				return 
			end
			button:SetDisabled(true)
			
			local count = 0
			for i = 1, 6 do
				for j = 1, 3 do
					if arr[i][j].txt:GetValue() then 
						local sp_id = talents[i][j]
						local spell_ = list_talents[sp_id]
						if spell_ then
							local new_sp = {
								spellID = spell_.spellID,
								class = spell_.class,
								CD = spell_.CD,
								specs = spec_spec[spec_list[dd4:GetValue() or 1]],
								player = inp:GetText(),
								succ = spell_.succ,
								type = spell_.type,
								trigger = spell_.trigger,
								cast_time = spell_.cast_time,
								quality = spell_.quality,
							}
							--HCoold:Print(HCoold:ManualSpellIndex(new_sp))
							table.insert(HCoold.db.faction.PlayersSpells,new_sp)
							HCoold.db.profile.trackManualSpells[HCoold:ManualSpellIndex(new_sp)] = true
							count = count + 1
						end
					end
				end
			end
			f:SetStatusText(string.format(L["Was added: %d spells."],count))
			if count > 0 then ann_res = true end
		end)
	end
end

function HCoold:GetSymbiosysSpell(inp) ---  inp = {name, class, spec}
	local out = {}
	local druids_arr = self.db.profile.druids_arr
	
	if type(inp) == "string" then inp = self:GetSpec(inp) end

	if druids_arr[inp.name] then
		-- если это друид, который кастанул на кого-то симбиоз. 
		-- тогда мы берем класс игрока на которого кастанут симбиоз, спек друида
		-- и не забываем проверить добавили для трекинга ли данный спелл
		
		-- для начала получим инфу об игроке на которого кастанули спелл
		local pl_n = self:GetSpec(druids_arr[inp.name])
		
		-- теперь проходимся по базе
		for _, spell in next, sybiosis_gain_druid do
			if pl_n.class == spell.class then
				local check = false
				for _, k in next, spell.specs do
					if k == 0 then check = true end
					if k == inp.spec then check = true end
				end
				if not self.db.profile.trackSpells[self:SymbiosysSpellIndex(spell)] then check = false end -- это проверка трекинга данного заклинания
				if check then table.insert(out, spell) end
			end
		end
	else
		for _, j in next, druids_arr do
			if j == inp.name then
				-- и так, это игрок на которого кастанул друид заклинание, так что мы берем его класс
				-- и добавляем соотв заклинание
				for _, spell in next, sybiosis_gain_raid do
					if inp.class == spell.class then
						-- проверить спек!!!
						local check = false
						for _, k in next, spell.specs do
							if k == 0 then check = true end
							if k == inp.spec then check = true end
						end
						if not self.db.profile.trackSpells[self:SymbiosysSpellIndex(spell)] then check = false end -- это проверка трекинга данного заклинания
						if check then table.insert(out,spell) end
					end
				end
			end
		end
	end
	
	return out
end

function HCoold:GetTalentSpell(inp)
	local out = {}
	if not self.db.profile.auto_scan_talents then return out end
	if type(inp) == "string" then inp = self:GetSpec(inp) end
	
	-- и так у нас есть имя игрока, его класс
	-- нам надо взять таланты из памяти
	-- проверить изучил ли он их или нет
	-- включено ли отслеживание аддоном и выдать в массиве
	local t = self.db.faction.AutoTalents[inp.name]
	if t then -- у нас есть таланты по данному игроку
		local ct = nil
		for _, k in next, class_talents do
			if k.class == inp.class then ct = k end
		end
		-- проходимся по всем талантам
		for i = 1, 6 do
			if ct.talents[i][t.talents[i]] then -- у нас есть в базе данных этот талант
				local spell = list_talents[ct.talents[i][t.talents[i]]] -- спелл который следует добавить/не добавить
				if self.db.profile.trackSpells[self:TalentIndex(spell)] then
					-- и так, спелл отслеживается и у нашего парня есть ->
					table.insert(out,spell)
				end
			end
		end
	end
	
	return out
end

function HCoold:GetTalentSpellForGridIntegration(inp, spCheck)
	local out = false
	if not self.db.profile.auto_scan_talents then return out end
	if type(inp) == "string" then inp = self:GetSpec(inp) end
	
	-- и так у нас есть имя игрока, его класс
	-- нам надо взять таланты из памяти
	-- проверить изучил ли он их или нет
	-- включено ли отслеживание аддоном и выдать в массиве
	local t = self.db.faction.AutoTalents[inp.name]
	if t then -- у нас есть таланты по данному игроку
		local ct = nil
		for _, k in next, class_talents do
			if k.class == inp.class then ct = k end
		end
		-- проходимся по всем талантам
		for i = 1, 6 do
			if ct.talents[i][t.talents[i]] then -- у нас есть в базе данных этот талант
				local spell = list_talents[ct.talents[i][t.talents[i]]] -- спелл который следует добавить/не добавить
				
				-- вот тут надо зарубить проверку совпадают ли триггеры этих спеллов или нет и если совпадают выдать true
				if self:CompairSpellID(spell, spCheck) then return true end
			end
		end
	end
	
	return out
end

function HCoold:GetSpecsForClass(class)
	for _, i in next, spec_spells do
		if i.class == class then
			local out = { 0 }
			for i, _ in next, i.specs do table.insert(out, i) end
			table.sort(out)
			return out
		end
	end
end

function HCoold:GetSpellsForSpec(class, spec)
	local out = {}
	-- проверяем общие спеллы по классу
	for _, spell in next, spells do
		if spell.class == class then
			local to_add = false
			for _, i in next, spell.specs do
				if i == 0 then to_add = true end
				if i == spec then to_add = true end
			end
			if to_add then table.insert(out, spell) end
		end
	end
	-- потом добавляем симбиоз
	if class == "DRUID" then
		for _, spell in next, sybiosis_gain_druid do
			local to_add = false
			for _, i in next, spell.specs do
				if i == 0 then to_add = true end
				if i == spec then to_add = true end
			end
			if to_add then table.insert(out, spell) end
		end
	else
		for _, spell in next, sybiosis_gain_raid do
			if spell.class == class then
				local to_add = false
				for _, i in next, spell.specs do
					if i == 0 then to_add = true end
					if i == spec then to_add = true end
				end
				if to_add then table.insert(out, spell) end
			end
		end
	end
	-- потом добавляем таланты
	for _, spell in next, list_talents do
		if spell.class == class then table.insert(out, spell) end
	end
	
	return out
end












