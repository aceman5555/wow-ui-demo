--- for all languages ---
	TITAN_DURABILITY_REPAIR_COST = string.gsub(REPAIR_COST, ":", "");

--- enUS english by tekkub / jth ---
    TITAN_DURABILITY_MENU_ITEMS = "List items";
	TITAN_DURABILITY_MENU_ITEMS_INVENTORY = "List items in your inventory";
    TITAN_DURABILITY_MENU_ITEMS_DAMAGED = "Damaged items only";
    TITAN_DURABILITY_MENU_HIDE_EMPTY_SLOTS = "Hide empty slots";
    TITAN_DURABILITY_MENU_GUY = "Hide default durability frame";
    TITAN_DURABILITY_MENU_INVENTORY = "Calculate inventory durability";
    TITAN_DURABILITY_MENU_INVENTORYINTP = "Inventory durability (average)";
	TITAN_DURABILITY_MENU_EQUIPPEDDURABILITY = "Equipped durability (average)";
	TITAN_DURABILITY_MENU_LOWESTEQUIPPEDDURABILITY = "Equipped durability (lowest)";
    TITAN_DURABILITY_MENU_DISPLAY_OF_REPAIR_COST = "Display of " .. TITAN_DURABILITY_REPAIR_COST .. ":";
    TITAN_DURABILITY_MENU_DISPLAY_ONTP = "Display on Titan Panel:";
    TITAN_DURABILITY_MENU_DISPLAY_ONTT = "Display on tooltip:";
    TITAN_DURABILITY_NUDE = "You are naked!";
    TITAN_DURABILITY_AND = "and";
    TITAN_DURABILITY_OR = "or";
    TITAN_DURABILITY_ITEMNAMES = "Show item names instead of slots";
	TITAN_DURABILITY_LIMIT_CALCULATIONS = "Calculate only once every 5 seconds";
	
	TITAN_DURABILITY_MENU_TOTAL = "Total";
    TITAN_DURABILITY_MENU_DURABILITY = "durability";
	TITAN_DURABILITY_MENU_TOTALDURABILITY = "Total durability (average)";
    TITAN_DURABILITY_MENU_REPAIRCOSTLOWESTINTP = "Most damaged item";
	
    TITAN_DURABILITY_MENU_REPAIRCOST05 = "5% discount";
    TITAN_DURABILITY_MENU_REPAIRCOST10 = "10% discount";
    TITAN_DURABILITY_MENU_REPAIRCOST15 = "15% discount";
    TITAN_DURABILITY_MENU_REPAIRCOST20 = "20% discount";

--- deDE german/deutsch by jth ---
    if ( GetLocale() == "deDE" ) then
        TITAN_DURABILITY_MENU_ITEMS = "Gegenst\195\164nde auflisten";
        TITAN_DURABILITY_MENU_ITEMS_INVENTORY = "Gegenst\195\164nde im Inventar auflisten";
        TITAN_DURABILITY_MENU_ITEMS_DAMAGED = "Nur besch\195\164digte Gegenst\195\164nde";
        TITAN_DURABILITY_MENU_HIDE_EMPTY_SLOTS = "Leere Pl\195\164tze ausblenden";
        TITAN_DURABILITY_MENU_GUY = "Verstecke normale Haltbarkeitsanzeige";
        TITAN_DURABILITY_MENU_INVENTORY = "Berechne Haltbarkeit des Inventars";
        TITAN_DURABILITY_MENU_INVENTORYINTP = "Haltbarkeit des Inventars (Durchschnitt)";
		TITAN_DURABILITY_MENU_EQUIPPEDDURABILITY = "Haltbarkeit angelegter Gegenst\195\164nde (Durchschnitt)";
		TITAN_DURABILITY_MENU_LOWESTEQUIPPEDDURABILITY = "Haltbarkeit angelegter Gegenst\195\164nde (niedrigste)";
        TITAN_DURABILITY_MENU_DISPLAY_OF_REPAIR_COST = "Anzeige der " .. TITAN_DURABILITY_REPAIR_COST .. ":";
        TITAN_DURABILITY_MENU_DISPLAY_ONTP = "Zeige im Titan Panel:";
        TITAN_DURABILITY_MENU_DISPLAY_ONTT = "Zeige im Tooltip:";
        TITAN_DURABILITY_NUDE = "Du bist nackt!";
        TITAN_DURABILITY_AND = "und";
        TITAN_DURABILITY_OR = "oder";
        TITAN_DURABILITY_ITEMNAMES = "Zeige Gegenstandsnamen anstatt Platzenamen";
		TITAN_DURABILITY_LIMIT_CALCULATIONS = "Nur einmal alle 5 Sek berechnen";

		TITAN_DURABILITY_MENU_TOTAL = "Gesamt";
        TITAN_DURABILITY_MENU_DURABILITY = "Haltbarkeit";
		TITAN_DURABILITY_MENU_TOTALDURABILITY = "Gesamte Haltbarkeit (Durchschnitt)";
        TITAN_DURABILITY_MENU_REPAIRCOSTLOWESTINTP = "Meist besch\195\164digter Gegenstand";
        TITAN_DURABILITY_MENU_REPAIRCOST05 = "5% Rabatt";
        TITAN_DURABILITY_MENU_REPAIRCOST10 = "10% Rabatt";
        TITAN_DURABILITY_MENU_REPAIRCOST15 = "15% Rabatt";
        TITAN_DURABILITY_MENU_REPAIRCOST20 = "20% Rabatt";
    end

--- frFR french/français by Halrik / jth / Sasmira ---
    if ( GetLocale() == "frFR" ) then
        TITAN_DURABILITY_MENU_ITEMS = "Montrez les d\195\169tails D\'\195\169quipement";
        TITAN_DURABILITY_MENU_GUY = "Cachez la fen\195\170tre de durabilit\195\169";
        TITAN_DURABILITY_NUDE = "Vous \195\170tes tout nu!";
        TITAN_DURABILITY_AND = "et";
        TITAN_DURABILITY_OR = "ou";
        TITAN_DURABILITY_MENU_DURABILITY = "Durabilit\195\169";
        TITAN_DURABILITY_MENU_REPAIRCOST05 = "Estimation \195\160 5%";
        TITAN_DURABILITY_MENU_REPAIRCOST10 = "Estimation \195\160 10%";
        TITAN_DURABILITY_MENU_REPAIRCOST15 = "Estimation \195\160 15%";
        TITAN_DURABILITY_MENU_REPAIRCOST20 = "Estimation \195\160 20%";
    end

--- esES spanish/español by jth ---
    if ( GetLocale() == "esES" ) then
        TITAN_DURABILITY_AND = "y";
        TITAN_DURABILITY_OR = "o";
        TITAN_DURABILITY_MENU_INVENTORY = "Calcular Durabilidad de Inventario";
        TITAN_DURABILITY_MENU_INVENTORYINTP = "Durabilidad de Inventario";
        TITAN_DURABILITY_MENU_DURABILITY = "Durabilidad";
        TITAN_DURABILITY_MENU_REPAIRCOST05 = "5% descuento";
        TITAN_DURABILITY_MENU_REPAIRCOST10 = "10% descuento";
        TITAN_DURABILITY_MENU_REPAIRCOST15 = "15% descuento";
        TITAN_DURABILITY_MENU_REPAIRCOST20 = "20% descuento";
    end


--- zhCN Chinese by yeachan @CWDG ---
    if ( GetLocale() == "zhCN" ) then
    TITAN_DURABILITY_MENU_ITEMS = "显示所有物品";
    TITAN_DURABILITY_MENU_ITEMS_DAMAGED = "只显示损失耐久的装备隐藏未装备位置";
    TITAN_DURABILITY_MENU_HIDE_EMPTY_SLOTS = "隐藏未装备位置";
    TITAN_DURABILITY_MENU_GUY = "隐藏默认的耐久度框";
    TITAN_DURABILITY_MENU_INVENTORY = "同时计算背包里的装备";
    TITAN_DURABILITY_MENU_INVENTORYINTP = "背包装备耐久度";
    TITAN_DURABILITY_MENU_DISPLAY_OF_REPAIR_COST = "显示 " .. TITAN_DURABILITY_REPAIR_COST .. ":";
    TITAN_DURABILITY_MENU_DISPLAY_ONTP = "显示在 Titan 面板:";
    TITAN_DURABILITY_MENU_DISPLAY_ONTT = "显示在Tip上:";
    TITAN_DURABILITY_NUDE = "你在裸奔!";
    TITAN_DURABILITY_AND = "和";
    TITAN_DURABILITY_OR = "或";
    TITAN_DURABILITY_ITEMNAMES = "不显示位置只显示装备名称";

    TITAN_DURABILITY_MENU_DURABILITY = "耐久度";
    TITAN_DURABILITY_MENU_REPAIRCOSTLOWESTINTP = "损坏最严重的装备";
    TITAN_DURABILITY_MENU_REPAIRCOST05 = "5% 折扣";
    TITAN_DURABILITY_MENU_REPAIRCOST10 = "10% 折扣";
    TITAN_DURABILITY_MENU_REPAIRCOST15 = "15% 折扣";
    TITAN_DURABILITY_MENU_REPAIRCOST20 = "20% 折扣";
    end

--- koKR and zhTW - nothing here yet ---
    if ( GetLocale() == "koKR" ) then
    end

    if ( GetLocale() == "zhTW" ) then
    end