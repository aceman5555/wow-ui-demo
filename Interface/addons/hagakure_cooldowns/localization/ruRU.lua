﻿local addon_name = "hagakure_cooldowns"
local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(addon_name, "ruRU")
if not L then return false end

L["Hagakure cooldowns"] = "Hagakure cooldowns"

L["lock frames"] = "Заблокировать"
L["desc lock frames"] = "заблокировать якоря фреймов для перетаскивания"
L["unlock frames"]="Разблокировать"
L["desc unlock frames"]="разблокировать якоря фреймов для перетаскивания"
L["run config"]="Настройки"
L["desc run config"]="запустить настройки аддона"
L["spells"]="Заклинания"
L["desc spells"]="Список спеллов по категориям, которые отслеживаются системой"
L["redraw"]="Перерисовать"
L["desc redraw"]="Перерисовать с использованием новой таблицы спеллов"
L["show/hide all"]="Скрыть/отобразить"
L["desc show/hide all"]="Скрыть (отобразить) все фреймы с отслеживаемыми кулдаунами"

L["debug mode on"] = "Режим настройки"
L["desc debug mode on"] = "Включить режим настройки заклинаний. Чтобы отключить его нажмите |cffff0000Перерисовать|r."

L["|cffff0000Hagakure cooldowns, greet %s! run /hcd"] = "|cffff0000Аддон Hagakure cooldowns успешно загружен, %s!|r Запусти |cff00ffff/hcd|r для конфигурации аддона."

L["class %s specs %s"]="|cff00ff00%s|r |cffff0000%s|r"

L["No spell found"] = "|cffff0000Заклинание не найдено!|r"
 
do -- automatic talent scan
	L["Rescan talents"] = "Принудительное обновление талантов"
	L["auto talents scan"] = "Атоматическое определение талантов"
	L["desc auto talents scan"] = "Включить систему автоматического определения талантов через обследование игроков. |cffff0000Система в разработке|r, имеются проблемы с сканированием всех игроков рейда"
		.. ", некоторые игроки могут в течении достаточно долгого промежутка быть непросканированными, однако вы можете всегда проинспектировать игрока \"ручками\" и система атоматически определит его таланты"
	L["Players list:"] = "Список игроков:"
	L["renew tlist"] = "обновить"
	L["no talents for this player"] = "данный игрок не был просканирован"
	L[" sec"] = " секунд назад"
	
	L["talents list"] = "список талантов"
	L["desc talents list"] = "Если система автоматического определения талантов включена, то эти заклинания будут автоматически добавленны аддоном для отслеживания."
	L["class %s"] = "класс %s"
	
	L["talents tracking"] = "просканированные таланты"
	L["desc talents tracking"] = "Показать список рейдеров и отсканированных аддоном талантов (если система автоматического определения талантов включена)."
	L["Show raid's talents"] = "Показать список талантов рейда"
	
	L["info for auto talent system"] = "Первая колонка - имя игрока, вторая колонка - <последнее время сканирования игрока>/<номер выученного таланта в первом тире>/.../<номер выученного таланта в шестом тире>"..
		"Если кто-то в этом списке непросканирован (или просканирован очень давно и его таланты изменились с того времени), то вы можете ручками проинспектить человечка и система" ..
		" отсканирует таланты.\n Система в разработке и работа над атоматизацией процесса идет."
end

do -- symbiosys tracking
	L["symbiosys tracking"] = "Список симбиозов"
	L["desc symbiosys tracking"] = "Показать окно со списком отслеживаемых в текущий момент симбиозов."
	L["Tracking symbiosys"] = "Отслеживаемые в данный момент симбиозы"
	L["currently no players in raid"] = "В текущий момент аддон не работает."
	L["druids list:"] = "Список друидов рейда:"
	L["no symbiosys for this druid"] = "|cffff0000друид не кастанул симбиоз|r"
	
	L["DRUIDcolor"] = "|cffFF7D0A%s|r"
	L["PALADINcolor"] = "|cffF58CBA%s|r"
	L["WARRIORcolor"] = "|cffC79C6E%s|r"
	L["PRIESTcolor"] = "|cffFFFFFF%s|r"
	L["SHAMANcolor"] = "|cff0070DE%s|r"
	L["DEATHKNIGHTcolor"] = "|cffC41F3B%s|r"
	L["HUNTERcolor"] = "|cffABD473%s|r"
	L["ROGUEcolor"] = "|cffFFF569%s|r"
	L["MAGEcolor"] = "|cff69CCF0%s|r"
	L["WARLOCKcolor"] = "|cff9482C9%s|r"
	L["MONKcolor"] = "|cff00FF96%s|r" 
	
	L["renew symbiosys"] = "обновить список"
end

do -- menu
	L["addon name"] = "Hagakure cooldowns"
	L["HCoold menu"] = "Меню HCD"
	L["Show druids' symbiosys"] = "Список симбиозов"
	L["Addon version"] = "Версия аддона"
	L["Your current version is %s."] = "Ваша текущая версия - %s."
	L["Toggle off minimap icon"] = "Отключить иконку на миникарте"
	L["toggle minimap"] = "включить иконку"
	L["desc toggle minimap"] = "Включить/отключить показывание иконки на миникарте"
	
	L["Middle click to open addon configuration"] = "Средняя кнопка открывает конфигурацию аддона"
	L["Right click to open menu"] = "Правая кнопка открывает меню аддона"
end

 do -- types of spells
	L["turn all off"] = "все отключить"
	L["desc turn all off"] = "Отключить отслеживание всех заклинаний этой группы"
	L["turn all on"] = "отслеживать все"
	L["desc turn all on"] = "Включить отслеживание всех заклинаний это группы"
	
	L["type1"]="-дамаг +хилл"
	L["desc type1"]="Заклинания, кастуемые на весь рейд, увеличивающие +хил по целям, либо понижающие входящий дамаг"
	L["header1"] = "Настройка фрейма с кулдаунами на -дамаг + хил"
	L["type width1"]="Ширина"
	L["desc type width1"]="Ширина фрейма с кулдаунами на -дамаг +хил"
	L["sort method1"] = "Направление роста"
	L["desc sort method1"] = "Направление роста фрейма с кулдаунами на -дамаг +хил"
	L["enable1"] = "Отображать"
	L["desc enable1"] = "Отображать фрейм с кулдаунами на -дамаг +хил"

	L["type2"]="аое хил"
	L["desc type2"]="Заклинания массового исцеления"
	L["header2"] = "Настройка фрейма с кулдаунами на аое хил"
	L["type width2"]="Ширина"
	L["desc type width2"]="Ширина фрейма с кулдаунами на аое хил"
	L["sort method2"] = "Направление роста"
	L["desc sort method2"] = "Направление роста фрейма с кулдаунами на аое хил"
	L["enable2"] = "Отображать"
	L["desc enable2"] = "Отображать фрейм с кулдаунами на аое хил"

	L["type3"]="на ману"
	L["desc type3"]="Заклинания увеличивающие ману рейда/рейдеру"
	L["header3"] = "Настройка фрейма с кулдаунами на ману"
	L["type width3"]="Ширина"
	L["desc type width3"]="Ширина фрейма с кулдаунами на ману"
	L["sort method3"] = "Направление роста"
	L["desc sort method3"] = "Направление роста фрейма с кулдаунами на ману"
	L["enable3"] = "Отображать"
	L["desc enable3"] = "Отображать фрейм с кулдаунами на ману"
	
	L["type4"]="личные кд"
	L["desc type4"]="Заклинания, понижающие входящий в игрока дамаг"
	L["header4"] = "Настройка фрейма с личными кулдаунами"
	L["type width4"]="Ширина"
	L["desc type width4"]="Ширина фрейма с личными кулдаунами"
	L["sort method4"] = "Направление роста"
	L["desc sort method4"] = "Направление роста фрейма с личными кулдаунами"
	L["enable4"] = "Отображать"
	L["desc enable4"] = "Отображать фрейм с личными кулдаунами"

	L["type5"]="точечные кд"
	L["desc type5"]="Заклинания, которые могут кидаться на другого игрока."
	L["header5"] = "Настройка фрейма с точечными кулдаунами"
	L["type width5"]="Ширина"
	L["desc type width5"]="Ширина фрейма с точечными кулдаунами"
	L["sort method5"] = "Направление роста"
	L["desc sort method5"] = "Направление роста фрейма с точечными кулдаунами"
	L["enable5"] = "Отображать"
	L["desc enable5"] = "Отображать фрейм с точечными кулдаунами"

	L["type6"]="кд на +дамаг"
	L["desc type6"]="Заклинания, увеличивающие дпс рейда"
	L["header6"] = "Настройка фрейма с кулдаунами на +дамаг"
	L["type width6"]="Ширина"
	L["desc type width6"]="Ширина фрейма с кулдаунами на +дамаг"
	L["sort method6"] = "Направление роста"
	L["desc sort method6"] = "Направление роста фрейма с кулдаунами на +дамаг"
	L["enable6"] = "Отображать"
	L["desc enable6"] = "Отображать фрейм с кулдаунами на +дамаг"

	L["type7"]="возрождения"
	L["desc type7"]="Заклинания, возрождающие мертвых союзников"
	L["header7"] = "Настройка фрейма с кулдаунами на возрождения"
	L["type width7"]="Ширина"
	L["desc type width7"]="Ширина фрейма с кулдаунами на возрождения"
	L["sort method7"] = "Направление роста"
	L["desc sort method7"] = "Направление роста фрейма с кулдаунами на возрождения"
	L["enable7"] = "Отображать"
	L["desc enable7"] = "Отображать фрейм с кулдаунами на возрождения"

	L["type8"]="прочее"
	L["desc type8"]="Заклинания, которые не попали в другие категории"
	L["header8"] = "Настройка фрейма с прочими кулдаунами"
	L["type width8"]="Ширина"
	L["desc type width8"]="Ширина фрейма с прочими кулдаунами"
	L["sort method8"] = "Направление роста"
	L["desc sort method8"] = "Направление роста фрейма с прочими кулдаунами"
	L["enable8"] = "Отображать"
	L["desc enable8"] = "Отображать фрейм с прочими кулдаунами"

	L["type9"]="контроль"
	L["desc type9"]="Заклинания, позволяющие ограничивать дейсвтвия противника"
	L["header9"] = "Настройка фрейма с заклинаниями контроля"
	L["type width9"]="Ширина"
	L["desc type width9"]="Ширина фрейма с заклинаниями контроля"
	L["sort method9"] = "Направление роста"
	L["desc sort method9"] = "Направление роста фрейма с заклинаниями контроля"
	L["enable9"] = "Отображать"
	L["desc enable9"] = "Отображать фрейм с заклинаниями контроля"

	L["type10"]="личный +дамаг"
	L["desc type10"]="Заклинания, увеличивающие личный дамаг игрока"
	L["header10"] = "Настройка фрейма с личными кд на +дамаг"
	L["type width10"]="Ширина"
	L["desc type width10"]="Ширина фрейма с личными кд на +дамаг"
	L["sort method10"] = "Направление роста"
	L["desc sort method10"] = "Направление роста фрейма с личными кд на +дамаг"
	L["enable10"] = "Отображать"
	L["desc enable10"] = "Отображать фрейм с личными кд на +дамаг"
end

do -- description of sort methods
	L["from top to bottom"] = "Сверху вниз"
	L["from left to right"] = "Слева направо"
	L["from right to left"] = "Справо налево"
	L["from bottom to top"] = "Снизу вверх"
end

do -- spec list
	L["PALADIN"]="паладин"
	L["PALADIN0"]="все спеки"
	L["PALADIN1"]="холи спек"
	L["PALADIN2"]="прот спек"
	L["PALADIN3"]="ретри спек"
	L["PALADIN1, 3"]="холи и ретри спеки"
	L["PALADIN1, 2"]="холи и прот спеки"
	L["PALADIN2, 3"]="прот и ретри спеки"

	L["WARRIOR"]="воин"
	L["WARRIOR0"]="все спеки"
	L["WARRIOR1"]="армс спек"
	L["WARRIOR2"]="фури спек"
	L["WARRIOR3"]="прот спек"
	L["WARRIOR1, 2"]="армс, фури спеки"
	L["WARRIOR1, 3"]="армс, прот спеки"
	L["WARRIOR2, 3"]="фури, прот спеки"

	L["PRIEST"]="жрец"
	L["PRIEST0"]="все спеки"
	L["PRIEST1"]="диск спек"
	L["PRIEST2"]="холи спек"
	L["PRIEST3"]="шп спек"
	L["PRIEST1, 3"]="диск и шп спеки"
	L["PRIEST1, 2"]="диск и холи спеки"
	L["PRIEST2, 3"]="холи и шп спеки"

	L["SHAMAN"]="шаман"
	L["SHAMAN0"]="все спеки"
	L["SHAMAN1"]="элем спек"
	L["SHAMAN2"]="энх спек"
	L["SHAMAN3"]="рестор спек"
	L["SHAMAN1, 2"]="элем и энх спеки"
	L["SHAMAN1, 3"]="элем и рестор спеки"
	L["SHAMAN2, 3"]="энх и рестор спеки"

	L["DEATHKNIGHT"]="рыцарь смерти"
	L["DEATHKNIGHT0"]="все спеки"
	L["DEATHKNIGHT1"]="блад спек"
	L["DEATHKNIGHT2"]="фрост спек"
	L["DEATHKNIGHT3"]="анхоли спек"
	L["DEATHKNIGHT1, 3"]="блад и анхоли спеки"
	L["DEATHKNIGHT2, 3"]="фрост и анхоли спеки"
	L["DEATHKNIGHT1, 2"]="блад и фрост спеки"

	L["DRUID"]="друид"
	L["DRUID0"]="все спеки"
	L["DRUID1"]="баланс спек"
	L["DRUID2"]="котэ спек"
	L["DRUID3"]="медведо спек"
	L["DRUID4"]="рестор спек"
	L["DRUID1, 2"]="баланс и кото спеки"
	L["DRUID1, 3"]="баланс и медведо спеки"
	L["DRUID1, 4"]="баланс и рестор спеки"
	L["DRUID2, 3"]="кото и медведо спеки"
	L["DRUID2, 4"]="кото и рестор спеки"
	L["DRUID3, 4"]="медведл и рестор спеки"
	L["DRUID1, 2, 3"]="баланс, котэ и медведо спеки"
	L["DRUID1, 2, 4"]="баланс, котэ и рестор спеки"
	L["DRUID1, 3, 4"]="баланс, медведо и рестор спеки"
	L["DRUID2, 3, 4"]="котэ, медведо и рестор спеки"

	L["HUNTER"]="охотник"
	L["HUNTER0"]="все спеки"
	L["HUNTER1"]="бм спек"
	L["HUNTER2"]="мм спек"
	L["HUNTER3"]="сурв спек"
	L["HUNTER1, 3"]="бм и сурв спеки"
	L["HUNTER2, 3"]="мм и сурв спеки"
	L["HUNTER1, 2"]="бм и мм спеки"

	L["ROGUE"]="разбойник"
	L["ROGUE0"]="все спеки"
	L["ROGUE1"]="мути спек"
	L["ROGUE2"]="комбат спек"
	L["ROGUE3"]="скрытность спек"
	L["ROGUE1, 3"]="мути и скрытность спеки"
	L["ROGUE2, 3"]="комбат и скрытность спеки"
	L["ROGUE1, 2"]="мути и комбат спеки"

	L["MAGE"]="маг"
	L["MAGE0"]="все спеки"
	L["MAGE1"]="аркан спек"
	L["MAGE2"]="огненый спек"
	L["MAGE3"]="фрост спек"
	L["MAGE1, 3"]="аркан и фрост спеки"
	L["MAGE2, 3"]="огненый и фрост спеки"
	L["MAGE1, 2"]="аркан и файер спеки"

	L["WARLOCK"]="чернокнижник"
	L["WARLOCK0"]="все спеки"
	L["WARLOCK1"]="афли спек"
	L["WARLOCK2"]="демон спек"
	L["WARLOCK3"]="дестро спек"
	L["WARLOCK1, 3"]="афли и дестро спеки"
	L["WARLOCK2, 3"]="демон и дестро спеки"
	L["WARLOCK1, 2"]="афли и демон спеки"
	
	L["MONK"]="монах"
	L["MONK0"]="все спеки"
	L["MONK1"]="хмелевар спек"
	L["MONK2"]="ткач туманов спек"
	L["MONK3"]="танцующий с ветром спек"
	L["MONK1, 2"]="хмелевар и ткач туманов спеки"
	L["MONK1, 3"]="хмелевар и танцующий с ветром спеки"
	L["MONK2, 3"]="ткач туманов и танцующий с ветром спеки"
end

do -- font+color config
	L["color setup"] = "Настройки цветов"
	L["font name"] = "Шрифт"
	L["desc font name"] = "Шрифт, который используется при прорисовки фреймов"
	L["font size"] = "Размер"
	L["desc font size"] = "Размер шрифта, который используется при прорисовке фреймов"
	L["icon size"] = "Иконка"
	L["desc icon size"] = "Размер иконки заклинаний в обычных контейнерах"
	
	L["server names"] = "Убрать название серверов"
	L["server names desc"] = "При попадание в кроссерверные рейды убрать названия серверов из имени игроков при отображении кулдаунов"

	L["tooltip spells"] = "Подсказки для заклинаний"
	L["tooltip spells desc"] = "Показывать подсказки для заклинаний при наведении в главном интерфейсе"
	L["tooltip active spells"] = "Подсказки для каст закл"
	L["tooltip active spells desc"] = "Показывать подсказки для заклинаний в фрейме \"активных\" заклинаний"
	
	L["exl spell color"] = "Отличные"
	L["desc exl spell color"] = "Цвет, которым будут подкрашиваться отличные кулдауны"
	L["good spell color"] = "Хорошие"
	L["desc good spell color"] = "Цвет, которым будут подкрашиваться хорошие кулдауны"
	L["bad spell color"] = "Плохие"
	L["desc bad spell color"] = "Цвет, которым будут подкрашиваться плохие кулдауны"
	L["off spell color"] = "Оффлайн"
	L["desc off spell color"] = "Цвет, которым будут подкрашиваться кулдауны игроков, ушедших в оффлайн" 
	L["dead spell color"] = "Мертвый"
	L["desc dead spell color"] = "Цвет, которым будут подкрашиваться кулданы умерших игроков"
	L["cd spell color"] = "На кулдауне"
	L["desc cd spell color"] = "Цвет, которым будут отображаться запущенный таймер восстановления спеллов"
end

do -- active spells frame
	L["active spells"] = "Настройки контейнера для заклинаний, имеющих время каста."
	L["active spell frame"] = "Активные спеллы"
	L["actspell width"] = "размер"
	L["desc actspell width"] = "Ширина/высота иконки активного заклинания"
	L["actspell sort method"] = "Направление роста"
	L["actspell desc sort method"] = "Направление роста при добавлении нового заклинания в фрейм"
	L["actspell enable"] = "включить"
	L["actspell desc enable"] = "Включить/выключить дополнительное отображение заклинаний, кастующихся в данный момент."
	L["ac names enable"] = "Показывать имена"
	L["desc ac names enable"] = "Показывать имена при прорисовке активных заклинаний"
	
	L["ac cancel by click"] = "отменить по нажатию"
	L["desc ac cancel by click"] = "Отменить прорисовку заклинания в контейнере активных заклинаний по клику мышки."
end

do -- Expert settings
	L["test mod"] = "Режим проверки"
	L["desc test mod"] = "Включить/выключить режим проверки настроек"
	L["expert"] = "Эксперт"
	L["desc expert"] = "Настроить дополнительные настройки к аддону"
	L["track groups"]="Группы"
	L["desc track groups"]="Отслеживает кулдауны игроков только этих первых группы"
	
	L["fast timer"]="Быстрый тик"
	L["desc fast timer"]="Время между тиками таймера обновления спеллов при окончании кулдауна (невозможно установить меньше 1/11 - по умолчанию AceTimer)"
	L["slow timer"]="Медленный тик"
	L["desc slow timer"]="Время между тиками таймера в обычном режиме"
	L["min time"]="Порог кулдауна"
	L["desc min time"]="Порог до окончания кулдауна, на котором происходит ускорение таймера"
	
	L["announce CDs"]="Оповещение окончания кулдаунов"
	
	L["ann rw"] = "Оповещение рейда"
	L["desc ann rw"] = "После окончания кулдауна оповестить его окончание через канал оповещения рейда."
	L["ann raid"] = "Канал рейда"
	L["desc ann raid"] = "После окончания кулдауна оповестить его окончание через канал рейда."
	L["ann say"] = "Сказать"
	L["desc ann say"] = "После окончания кулдауна оповестить его окончание через /say."
	L["ann yell"] = "Крикнуть"
	L["desc ann yell"] = "После окончания кулдауна оповестить его окончание через /yell."
	L["ann self"] = "Сообщение в чат"
	L["desc ann self"] = "После окончания кулдауна оповестить его окончание в личный чат."
	L["ann only rl"] = "Только статус помощник"
	L["desc ann only rl"] = "Оповещать в публичные каналы (/rw /raid /yell /say) только со статусом помощника."
	L["ann party"] = "Группа"
	L["desc ann party"] = "После окончания кулдауна оповестить его окончание через канал группы."
	
	L["announce CDs start"] = "Оповещение произнесения заклинаний"
	L["ann self start"] = "оповестить начало"
	L["desc ann self start"] = "Оповестить в чат о произнесении кулдауна игроком."
	
	L["addon announce"] = "Оповещение через рейд аддоны"
	L["ann DBM"] = "DBM"
	L["desc ann DBM"] = "Оповещать об окончании кулдаунов через аддон DBM"
	L["ann DXE"] = "DXE"
	L["desc ann DXE"] = "Оповещать об окончании кулдаунов через аддон DXE"
	L["ann BigWigs"] = "BigWigs"
	L["desc ann BigWigs"] = "Оповещать об окончании кулдаунов через аддон BigWigs"
	
	L["Spell %s of %s is ready!"] = "Спелл %s %s готов!"
	L["%s casted %s."] = "%s произнес заклинание %s."
	
	L["Spell was deleted"] = "|cffff0000Заклинание не существует|r"
	L["Spell was deleted desc"] = "Заклинание было удалено из игры, либо вы неправильно указали ID заклинания."
	L["raid only"] = "Влючен только в рейде"
	L["desc raid only"] = "Включать аддон только в рейде (при выключенной опции аддон будет работать и при попадании в обычную партию)."
	
	L["Track spells for raid"] = "Вкл/откл отслеживание заклинаний, которые получает член рейда от симбиоза с друидом"
	L["Track spells for druid"] = "Вкл/откл отслеживание заклинаний, которые получает друид от симбиоза с другим рейдером"

	L["symbiosis raid"] = "симбиоз рейд"
	L["\ntype is %s"] = "\nкатегория %s"
	L["symbiosis druid"] = "симбиоз друид"
end

do -- manual configuration section
	L["Manual spell settings"] = "Ручные настройки кулдаунов"
	L["Personal spells"] = "Ручная настройка"
	L["desc presonal spells"] = "Создание/изменение существующих заклинаний"
	L["Add spell"] = "Добавить"
	
	L["Enter player name"] = "Введите имя игрока\nдля которого настраивается спелл"
	L["Enter CD of spell in sec"] = "Введите кулдаун заклинания\nв секундах"
	L["Add new spell options for current player."] = "Добавить новые настройки кулдауна для определенного игрока."
	L["Enter casting time of spell"] = "Введите время действия спелла\nесли заклинание вешает положительный эффект\nкоторый длится некоторое время,\nто это время можно указать здесь."
	L["Enter trigger event from combat log"] = "Введите событие из комбат лога\nкоторое запускает кулдаун заклинания"
	L["Enter quality of spell"] = "Введите качество заклинания\nданный параметр при сортировке\nбудет ставить это заклинание выше других."
	
	L["Configuration for %s spell"] = "Настройка спелла %s"
	L["Delete"] = "Удалить"
	L["Deleted"] = "Удалено"
	L["You realy want to delete spell %s?"] = "Подтвердить удаление заклинания %s."
	
	L["Spell %s(id=%d, type=%s, quality=%d, specs=%s) for player %s has CD %d sec cast time %.1f and trigger from %s."] = 
		"Заклинание %s (id=%s, тип=\"%s\", качество=%d, специализации=\"%s\") для игрока |cffff0000%s|r имеет время восстановления |cffff0000%d|r секунд (время действия %.1f сек) и запускается от ивента %s."
	
	L["Track spell"] = "Отслеживать"
	
	L["Spec list by class"] = "Спеки, для которых остлеживается данное заклинание\n" ..
		"|cff00ff00Воин|r 1 - оружие 2 - неистоство 3 - защита\n|cff00ff00Друид|r 1 - баланс 2 - сила зверя (кот) 3 - сила зверя (танк) 4 - исцеление\n|cff00ff00Жрец|r 1 - послушание 2 - свет 3 - темная магия\n" ..
		"|cff00ff00Маг|r 1 - тайная магия 2 - огонь 3 - лёд\n|cff00ff00Охотник|r 1 - повелитель зверей 2 - стрельба 3 - выживание\n|cff00ff00Паладин|r 1 - свет 2 - защита 3 - воздаяние\n|cff00ff00Разбойник|r 1 - ликвидация 2 - бой 3 - скрытность\n" ..
		"|cff00ff00Рыцарь смерти|r 1 - кровь 2 - лед 3 - нечистивость\n|cff00ff00Чернокнижник|r 1 - колдоство 2 - демонология 3 - разрушение\n" .. 
		"|cff00ff00Монах|r 1 - хмелевар 2 - ткач туманов 3 - танцующий с ветром\n" .. 
		"|cff00ff00Шаман|r 1 - стихии 2 - совершенствование 3 - исцеление\n|cffff00000 - для всех спеков|r"
	L["Cooldown successfully added!"] = "Заклинание успешно добавлено!"
	L["You should enter spell id, player name and cooldown of spell."] = "|cffff0000Необходимо указать ID заклинания, имя игрока и кулдаун заклинания!|r"
	L["Cooldown successfulle deleted!"] = "Заклинание успешно удалено!"
	L["Don't forget to redraw layout to aply settings."] = "Не забудьте перерисовать контейнеры, чтобы изменения вступили в силу."
end

do -- configuration for talents
	L["Talent selection"] = "Добавить таланты"
	L["desc talent selection"] = "Добавить таланты игроков для отслеживания аддоном (добавленные заклинания будут видны в |cffff0000ручных настройках кулдаунов|r)"
	L["Manual talent settings"] = "Добавить отслеживание талантов."
	
	L["Enter player class"] = "Выберете класс игрока"
	L["Enter player name talent"] = "Введите имя игрока"
	L["no input"] = "Выберете класс игрока!"
	L["Save tracking for this cooldowns"] = "Добавить на отслеживание"
	L["Save tracking for this cooldowns desc"] = "Добавить для отслеживания выбранные таланты для данного игрока."
	
	L["desc tracking interface"] = "\nНе выбирайте все таланты, которые имеет игрок (тк они будут добавлены в систему для отслеживания). Все добавленные заклинания вы увидете в интерфейсе |cffff0000ручной настройки кулдаунов|r, " ..
		"где вы сможете включить/выключить отслеживание этих заклинаний или удалить их. Если вы имеете хорошую идею по увеличению возможностей/удобству аддона, не стесняйтесь связаться со мной через e-mail, который вы можете найти на curse.com."
	
	L["Choose spell id from existsing"] = "Выбрать заклинание из уже существующих, чтобы модифицировать под данного игрока"
	L["Choose spell category"] = "Выберете категорию для заклинания, в которой оно будет отображаться"
	L["Enter id of spell"] = "Введите ID заклинания\nВы можете ввести больше, чем один триггер\n(к примеру если в разных спеках заклинание имеет разные ID\nТакого рода информацию вы можете найти на ru.wowhead.com (либо других подобных сайтах)"
	L["another triggers are %s."] = " Дополнительные триггеры: %s."

	L["Fill name talent"] = "Введите имя игрока!"
	L["Was added: %d spells."] = "Было добавлено заклинаний: %d."
	
	L["talents"] = "таланты"
	L["Choose category of spell from existsing"] = "Выберете категорию из уже существующих (в базе аддона) заклинания, чтобы модифицировать его"
end

do -- Bar's settings
	L["Bar settings"] = "Настройки bars"
	L["bars enable"] = "включить bars"
	L["desc bars enable"] = "Включить bars (да, я хз как это по-русски сказать!) при прорисовке кулдаунов"
	L["bar background enable"] = "включить фон"
	L["desc bar background enable"] = "Включить фон контейнера с заклинанием"
	
	L["bar bg color"] = "цвет фона"
	L["desc bar bg color"] = "Цвет, которым будет раскрашен фон"
	L["bar casting spell color"] = "цвет активного"
	L["desc bar casting spell color"] = "Цвет, который будет использоваться при прорисовке bars, когда заклинание активно"
	L["bar cd spell color"] = "цвет восстановления"
	L["desc bar cd spell color"] = "Цвет, который будет использоваться при прорисовке bars, когда заклинание на восстановлении"
	L["bar texture"] = "текстура"
	L["desc bar texture"] = "Текстура, которая используется при прорисовке bars и фона."
end

do -- Grid integration
	L["Amount of turned on statuses"] = "Количество статусов"
	L["desc amount of turned on statuses"] = "Количество статусов, которое будет создано в гриде"
	L["Enable hcd %d"] = "Включить HCD статус №%d"
	L["Hagakure cooldown slot %d"] = "HCD статус %d"
	
	L["add"] = "+"
	L["Add one more rule for tracking"] = "Еще одно правило для отслеживания для этого класса"
	L["select spec for %s"] = "выберите спек"
	L["Select spell for tracking"] = "Выберете заклинание для отслеживания для данного спека"
	L["Select spec for tracking spell"] = "Выберите спек для которого данное заклинание будет отображаться"
	L["delete spell from tracking"] = "Удалить данное правило"
	L["select spell for %d"] = "Выберите заклинание" 
	
	L["delete"] = "-"
	L["Priority"] = "Приоритет"
	L["Select priority for tracking spell"] = "Выберите приоритет для заклинания (если вы добавите больше двух заклинаний для одного статуса/класса/спека, то покажется то, у которого выше приоритет, к примеру добавите манатайд с приоритетом 70 для рестор спека и тотем трепета с приоритетом 30 для всех спеков, то покажется манатайд. Таланты/заклинания от симбиоза не будут показаны если не выучены/нет симбиоза на человеке)"
	
	L["grid integration"] = "grid интеграция"
	L["turn on grid integration"] = "Включить интеграцию с аддоном grid" .. "\nВсе настройки по данной возможности ищите в своем аддоне grid"
	L["To apply setting need to reload interface, press ACCEPT to do this now"] = "Чтобы применить изменения необходимо перезагрузить интерфейс, чтобы сделать это сейчас нажмите ПРИНЯТЬ."
end














