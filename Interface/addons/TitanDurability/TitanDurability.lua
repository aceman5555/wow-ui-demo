-- Titan Panel [Durability]
-- Version: 1.24
-- http://www.jthawk.de
-- see changelog.txt for more information

-- TP variables
local TITAN_DURABILITY_ID = "Durability";
local TITAN_DURABILITY_FREQUENCY = 1;

local TITAN_DURABILITY_FORMAT = "%d%%";

-- settings
local TitanDurability_Debug = 0; -- set to 1 for ingame debug messages
local TitanDurability_CalculatationInterval = 5;

-- addon variables
local TitanDurability_PlayerInCombat = 0;

local TitanDurability_totalRepairCost = 0;
local TitanDurability_duraPercent = 100;
local TitanDurability_duraLowestPercent = 100;
local TitanDurability_duraCurr = 0;
local TitanD1urability_duraTotal = 0;
local TitanDurability_itemstats = {};
local TitanDurability_itemstats_inventory = {};

local TitanDurability_inventory_totalRepairCost = 0;
local TitanDurability_inventory_duraPercent = 100;
local TitanDurability_inventory_duraCurr = 0;
local TitanDurability_inventory_duraTotal = 0;

local TitanDurability_totalRepairCost_temp = 0;
local TitanDurability_repaircost_complete = 0;
local TitanDurability_totalRepairCost_temp05 = 0;
local TitanDurability_inventory_totalRepairCost_temp05 = 0;
local TitanDurability_totalRepairCost_temp10 = 0;
local TitanDurability_inventory_totalRepairCost_temp10 = 0;
local TitanDurability_totalRepairCost_temp15 = 0;
local TitanDurability_inventory_totalRepairCost_temp15 = 0;
local TitanDurability_totalRepairCost_temp20 = 0;
local TitanDurability_inventory_totalRepairCost_temp20 = 0;
local TitanDurability_Current_Item_RepairCost_temp = 0;

local L = LibStub("AceLocale-3.0"):GetLocale("Titan", true)

-- onload handler
function TitanPanelDurabilityButton_OnLoad(self)
	_, _, TITAN_DURABILITY_TEXT = string.find(DURABILITY_TEMPLATE, "(.+) %%[^%s]+ / %%[^%s]+");
	TITAN_DURABILITY_TOOLTIP_REPAIR = TITAN_DURABILITY_REPAIR_COST .. "\t";
	TITAN_DURABILITY_TOOLTIP_REPAIR_00 = FACTION_STANDING_LABEL4;
	TITAN_DURABILITY_TOOLTIP_REPAIR_05 = FACTION_STANDING_LABEL5;
	TITAN_DURABILITY_TOOLTIP_REPAIR_10 = FACTION_STANDING_LABEL6;
	TITAN_DURABILITY_TOOLTIP_REPAIR_15 = FACTION_STANDING_LABEL7;
	TITAN_DURABILITY_TOOLTIP_REPAIR_20 = FACTION_STANDING_LABEL8;
	TITAN_DURABILITY_TOOLTIP_DURA = CURRENTLY_EQUIPPED .. ":\t";
	TITAN_DURABILITY_LABEL = TITAN_DURABILITY_TEXT .. ": ";

	self.registry = {
		id = TITAN_DURABILITY_ID,
		menuText = TITAN_DURABILITY_TEXT,
		buttonTextFunction = "TitanPanelDurabilityButton_GetButtonText",
		tooltipTitle = TITAN_DURABILITY_TEXT,
		tooltipTextFunction = "TitanPanelDurabilityButton_GetTooltipText",
		icon = "Interface\\Icons\\Trade_BlackSmithing.blp";
		iconWidth = 16,
		category = "Information",
		version = "1.24",
		controlVariables = {
			ShowIcon = true,
			ShowLabelText = true,
			ShowRegularText = false,
			ShowColoredText = true,
			DisplayOnRightSide = true,
		},
		savedVariables = {
			ShowLabelText = 1,
			ShowColoredText = 1,
			ShowIcon = 1,
			iteminfo = 1,
			iteminfo_inventory = 1,
			iteminfodamaged = false,
			iteminfohideempty = 1;
			inventory = false,
			showinventoryintp = false,
			hideguy = 1,
			showitemnames = 1,
			showlowestitemintp = 1,
			showrepaircostintp = 1,
			showduraintp = 1,
			showlowestduraintp = false,
			showtotalduraintp = false,
			showrepaircost = 1,
			showrepaircost05 = false,
			showrepaircost10 = false,
			showrepaircost15 = false,
			showrepaircost20 = false,
			showallrepaircosts = false,
			displayrepaircostsontt = 1,
			limitcalculations = 1,
		}
	};

	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_LEAVING_WORLD");
	self:RegisterEvent("UPDATE_INVENTORY_ALERTS");
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY");
	self:RegisterEvent("BANKFRAME_CLOSED");
	self:RegisterEvent("MERCHANT_CLOSED");
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
    self:RegisterEvent("PLAYER_MONEY");
	self:RegisterEvent("UNIT_INVENTORY_CHANGED");
end

-- create TP text
function TitanPanelDurabilityButton_GetButtonText(id)
	local duraRichText = "";
	-- durability of equiped items
	if (not TitanDurability_duraPercent) then
		duraRichText = TITAN_DURABILITY_NUDE;
	elseif (TitanGetVar(TITAN_DURABILITY_ID, "showduraintp")) then
    	duraRichText = TitanPanelDurability_GetColoredText(TitanDurability_duraPercent);
        if (TitanDurability_duraPercent < 100) and (TitanDurability_totalRepairCost) and (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircostintp")) then
            if (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) or (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) then
            	TitanDurability_totalRepairCost_temp = TitanDurability_totalRepairCost * 0.80;
            elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) then
            	TitanDurability_totalRepairCost_temp = TitanDurability_totalRepairCost * 0.85;
            elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) then
                TitanDurability_totalRepairCost_temp = TitanDurability_totalRepairCost * 0.90;
            elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) then
            	TitanDurability_totalRepairCost_temp = TitanDurability_totalRepairCost * 0.95;
            elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost")) then
                TitanDurability_totalRepairCost_temp = TitanDurability_totalRepairCost;
            end
            if (TitanDurability_totalRepairCost_temp < 1) then
            	TitanDurability_totalRepairCost_temp = 1;
            end
            if (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) then
                duraRichText = duraRichText .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_totalRepairCost_temp) .. ")";
            end
        end
	end

	-- lowest durability
    if (TitanGetVar(TITAN_DURABILITY_ID, "showlowestduraintp")) then
		duraRichText = duraRichText .. TitanPanelDurability_GetColoredText(TitanDurability_duraLowestPercent);
		if (TitanDurability_duraLowestPercent < 100) and (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircostintp")) then
			if (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) then
				if (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) or (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) then
					TitanDurability_totalRepairCost_temp = TitanDurability_totalRepairCost * 0.80;
				elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) then
					TitanDurability_totalRepairCost_temp = TitanDurability_totalRepairCost * 0.85;
				elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) then
					TitanDurability_totalRepairCost_temp = TitanDurability_totalRepairCost * 0.90;
				elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) then
					TitanDurability_totalRepairCost_temp = TitanDurability_totalRepairCost * 0.95;
				elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost")) then
					TitanDurability_totalRepairCost_temp = TitanDurability_totalRepairCost;
				end
				if (TitanDurability_totalRepairCost_temp < 1) then
					TitanDurability_totalRepairCost_temp = 1;
				end
				duraRichText = duraRichText .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_totalRepairCost_temp) .. ")";
			end
        end
    end
	
	-- durability of inventory
	if (TitanGetVar(TITAN_DURABILITY_ID, "inventory")) and (TitanGetVar(TITAN_DURABILITY_ID, "showinventoryintp")) and (TitanDurability_inventory_duraPercent) then
		duraRichText = TitanPanelDurability_GetColoredText(TitanDurability_inventory_duraPercent);
        if (TitanDurability_inventory_totalRepairCost > 0) and (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircostintp")) then
    	    if (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) then
            	duraRichText = duraRichText .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_inventory_totalRepairCost) .. ")";
	        end
        end
	end
	
	-- complete durability
	if (TitanGetVar(TITAN_DURABILITY_ID, "showtotalduraintp")) and (TitanDurability_duraPercent) and (TitanDurability_inventory_duraPercent) and (TitanGetVar(TITAN_DURABILITY_ID, "inventory")) then
		TitanDurability_duraPercent_complete = TitanDurability_duraPercent + TitanDurability_inventory_duraPercent;
		TitanDurability_duraPercent_complete = TitanDurability_duraPercent_complete / 2;

		duraRichText = TitanPanelDurability_GetColoredText(TitanDurability_duraPercent_complete);

		if (TitanDurability_duraPercent_complete < 100) and (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircostintp")) then
            if (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) then
            	TitanDurability_repaircost_complete = TitanDurability_totalRepairCost + TitanDurability_inventory_totalRepairCost;
                TitanDurability_repaircost_complete = TitanDurability_repaircost_complete;
                if (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) or (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) then
                	TitanDurability_repaircost_complete = TitanDurability_repaircost_complete * 0.80;
                elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) then
                	TitanDurability_repaircost_complete = TitanDurability_repaircost_complete * 0.85;
                elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) then
                	TitanDurability_repaircost_complete = TitanDurability_repaircost_complete * 0.90;
                elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) then
                    TitanDurability_repaircost_complete = TitanDurability_repaircost_complete * 0.95;
                end
                if (TitanDurability_repaircost_complete < 1) then
            		TitanDurability_repaircost_complete = 1;
            	end
               	duraRichText = duraRichText .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_repaircost_complete) .. ")";
            end
		end
	end
	
	-- durability of the most damaged item
    if (TitanGetVar(TITAN_DURABILITY_ID, "showlowestitemintp")) and (TitanDurability_duraLowestPercent < 100) then
        duraRichText = duraRichText .. "  " .. TitanDurability_duraLowestslotName .. ": " .. TitanPanelDurability_GetColoredText(TitanDurability_duraLowestPercent);
        if (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircostintp")) then
			TitanDurability_duraLowestRepairCost_temp = TitanDurability_duraLowestRepairCost;
			if (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) or (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) then
				TitanDurability_duraLowestRepairCost_temp = TitanDurability_duraLowestRepairCost_temp * 0.80;
			elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) then
				TitanDurability_duraLowestRepairCost_temp = TitanDurability_duraLowestRepairCost_temp * 0.85;
			elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) then
				TitanDurability_duraLowestRepairCost_temp = TitanDurability_duraLowestRepairCost_temp * 0.90;
			elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) then
				TitanDurability_duraLowestRepairCost_temp = TitanDurability_duraLowestRepairCost_temp * 0.95;
			end
			if (TitanDurability_duraLowestRepairCost_temp < 1) then
				TitanDurability_duraLowestRepairCost_temp = 1;
			end
            if (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) then
                duraRichText = duraRichText .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_duraLowestRepairCost_temp) .. ")";
            end
        end
    end

	return TITAN_DURABILITY_LABEL,duraRichText;
end

-- create TP tooltip
function TitanPanelDurabilityButton_GetTooltipText()
	local retstr = "\n";
	local itemsinlist = false;
	-- durability for equiped items
	if (not TitanDurability_duraPercent) then
		retstr = retstr .. TITAN_DURABILITY_TOOLTIP_DURA .. TITAN_DURABILITY_NUDE;
	else
		retstr = retstr .. TITAN_DURABILITY_TOOLTIP_DURA .. TitanPanelDurability_GetColoredText(TitanDurability_duraPercent);
        if (TitanDurability_duraPercent < 100) then
        	TitanDurability_totalRepairCost_temp20 = TitanDurability_totalRepairCost * 0.80;
            TitanDurability_totalRepairCost_temp15 = TitanDurability_totalRepairCost * 0.85;
            TitanDurability_totalRepairCost_temp10 = TitanDurability_totalRepairCost * 0.90;
            TitanDurability_totalRepairCost_temp05 = TitanDurability_totalRepairCost * 0.95;
            if (TitanGetVar(TITAN_DURABILITY_ID, "displayrepaircostsontt")) then
                if (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) or (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) then
                    TitanDurability_totalRepairCost_20 = TitanDurability_totalRepairCost * 0.80;
                    if (TitanDurability_totalRepairCost_20 < 1) then
                        TitanDurability_totalRepairCost_20 = 1;
                    end
                    retstr = retstr .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_totalRepairCost_20) .. ")";
                elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) then
                    TitanDurability_totalRepairCost_15 = TitanDurability_totalRepairCost * 0.85;
                    if (TitanDurability_totalRepairCost_15 < 1) then
                        TitanDurability_totalRepairCost_15 = 1;
                    end
                    retstr = retstr .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_totalRepairCost_15) .. ")";
                elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) then
                    TitanDurability_totalRepairCost_10 = TitanDurability_totalRepairCost * 0.90;
                    if (TitanDurability_totalRepairCost_10 < 1) then
                        TitanDurability_totalRepairCost_10 = 1;
                    end
                    retstr = retstr .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_totalRepairCost_10) .. ")";
                elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) then
                    TitanDurability_totalRepairCost_05 = TitanDurability_totalRepairCost * 0.95;
                    if (TitanDurability_totalRepairCost_05 < 1) then
                        TitanDurability_totalRepairCost_05 = 1;
                    end
                    retstr = retstr .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_totalRepairCost_05) .. ")";
                elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost")) then
                    retstr = retstr .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_totalRepairCost) .. ")";
                end
            end
			-- fix values for round failures to match with repair costs provided by wow itself
            if (TitanDurability_totalRepairCost_temp20 < 1) then
            	TitanDurability_totalRepairCost_temp20 = 1;
            end
            if (TitanDurability_totalRepairCost_temp15 < 1) then
            	TitanDurability_totalRepairCost_temp15 = 1;
            end
            if (TitanDurability_totalRepairCost_temp10 < 1) then
            	TitanDurability_totalRepairCost_temp10 = 1;
            end
            if (TitanDurability_totalRepairCost_temp05 < 1) then
            	TitanDurability_totalRepairCost_temp05 = 1;
            end
        end
	end

    retstr = retstr .. "\n ";
	-- itemdetails for equipped items
	if (TitanGetVar(TITAN_DURABILITY_ID, "iteminfo")) and (TitanDurability_duraPercent) then
		if (TitanDurability_duraPercent < 100) or (not TitanGetVar(TITAN_DURABILITY_ID, "iteminfodamaged")) then
            local slots = {
                {"Head", HEADSLOT},
                {"Shoulder", SHOULDERSLOT},
                {"Chest", CHESTSLOT},
                {"Wrist", WRISTSLOT},
                {"Hands", HANDSSLOT},
                {"Waist", WAISTSLOT},
                {"Legs", LEGSSLOT},
                {"Feet", FEETSLOT},
                {"MainHand", MAINHANDSLOT},
                {"SecondaryHand", SECONDARYHANDSLOT},
            };
            for i, arr in pairs(slots) do
                local stats = TitanDurability_itemstats[arr[1]];
				local ItemName = UNKNOWN;
				if (arr[2]) then
					ItemName = arr[2];
				end
                if (stats) then
                	if (TitanGetVar(TITAN_DURABILITY_ID, "showitemnames")) then
                		if (stats[3]) and (stats[3] ~= GSC_NONE) and (stats[4]) and (stats[4] ~= GSC_NONE) then
                			ItemName = "|c" .. stats[4] .. stats[3] .. "|r";
                		end
                	end
                    if (stats[1] == GSC_NONE) then
                        if (not TitanGetVar(TITAN_DURABILITY_ID, "iteminfodamaged")) and (not TitanGetVar(TITAN_DURABILITY_ID, "iteminfohideempty")) then
                            retstr = retstr .. "\n" .. ItemName .. ":\t" .. stats[1];
                            itemsinlist = true;
                        end
                    else
                        if (not TitanGetVar(TITAN_DURABILITY_ID, "iteminfodamaged")) or (stats[1] < 100) then
                            if (TitanGetVar(TITAN_DURABILITY_ID, "ShowColoredText")) then
                                retstr = retstr .. "\n" .. ItemName .. ":\t" .. TitanPanelDurability_GetColoredText(stats[1]);
                            else
                                local duraText = TitanUtils_GetHighlightText(format(TITAN_DURABILITY_FORMAT, stats[1]));
                                retstr = retstr .. "\n" .. ItemName .. ":\t" .. duraText;
                            end
                            if (TitanGetVar(TITAN_DURABILITY_ID, "displayrepaircostsontt")) then
                                if (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) then
                                    if (stats[2] ~= GSC_NONE) then
                                        retstr = retstr .. " (" .. stats[2] .. ")";
                                    end
                                end
                            end
                            itemsinlist = true;
                        end
                    end
                end
            end
        end
	end
	
	-- inventory durability
	if (TitanGetVar(TITAN_DURABILITY_ID, "inventory")) then
        if (TitanGetVar(TITAN_DURABILITY_ID, "iteminfo")) and (TitanDurability_duraPercent) and (itemsinlist == true) then
        	retstr = retstr .. "\n ";
        end
		-- total inventory
        if (not TitanDurability_inventory_duraPercent) then
            retstr = retstr .. "\n" .. INVENTORY_TOOLTIP .. ":\t" .. GSC_NONE .. "\n";
        else
            retstr = retstr .. "\n" .. INVENTORY_TOOLTIP .. ":\t" .. TitanPanelDurability_GetColoredText(TitanDurability_inventory_duraPercent);
            if (TitanDurability_inventory_duraPercent < 100) then
                TitanDurability_inventory_totalRepairCost_temp20 = TitanDurability_inventory_totalRepairCost * 0.80;
                TitanDurability_inventory_totalRepairCost_temp15 = TitanDurability_inventory_totalRepairCost * 0.85;
                TitanDurability_inventory_totalRepairCost_temp10 = TitanDurability_inventory_totalRepairCost * 0.90;
                TitanDurability_inventory_totalRepairCost_temp05 = TitanDurability_inventory_totalRepairCost * 0.95;
                if (TitanGetVar(TITAN_DURABILITY_ID, "displayrepaircostsontt")) then
                    if (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) or (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) then
                        TitanDurability_inventory_totalRepairCost_20 = TitanDurability_inventory_totalRepairCost * 0.80;
                        if (TitanDurability_inventory_totalRepairCost_20 < 1) then
                            TitanDurability_inventory_totalRepairCost_20 = 1;
                        end
                        retstr = retstr .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_inventory_totalRepairCost_20) .. ")";
                    elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) then
                        TitanDurability_inventory_totalRepairCost_15 = TitanDurability_inventory_totalRepairCost * 0.85;
                        if (TitanDurability_inventory_totalRepairCost_15 < 1) then
                            TitanDurability_inventory_totalRepairCost_15 = 1;
                        end
                        retstr = retstr .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_inventory_totalRepairCost_15) .. ")";
                    elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) then
                        TitanDurability_inventory_totalRepairCost_10 = TitanDurability_inventory_totalRepairCost * 0.90;
                        if (TitanDurability_inventory_totalRepairCost_10 < 1) then
                            TitanDurability_inventory_totalRepairCost_10 = 1;
                        end
                        retstr = retstr .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_inventory_totalRepairCost_10) .. ")";
                    elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) then
                        TitanDurability_inventory_totalRepairCost_05 = TitanDurability_inventory_totalRepairCost * 0.95;
                        if (TitanDurability_inventory_totalRepairCost_05 < 1) then
                            TitanDurability_inventory_totalRepairCost_05 = 1;
                        end
                        retstr = retstr .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_inventory_totalRepairCost_05) .. ")";
                    elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost")) then
                        retstr = retstr .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_inventory_totalRepairCost) .. ")";
                    end
                end
                -- fix values for round failures to match with repair costs provided by wow itself
                if (TitanDurability_inventory_totalRepairCost_temp20 < 1) then
                    TitanDurability_inventory_totalRepairCost_temp20 = 1;
                end
                if (TitanDurability_inventory_totalRepairCost_temp15 < 1) then
                    TitanDurability_inventory_totalRepairCost_temp15 = 1;
                end
                if (TitanDurability_inventory_totalRepairCost_temp10 < 1) then
                    TitanDurability_inventory_totalRepairCost_temp10 = 1;
                end
                if (TitanDurability_inventory_totalRepairCost_temp05 < 1) then
                    TitanDurability_inventory_totalRepairCost_temp05 = 1;
                end
            end
			-- itemdetails for inventory
            if (TitanGetVar(TITAN_DURABILITY_ID, "iteminfo")) and (TitanGetVar(TITAN_DURABILITY_ID, "iteminfo_inventory")) and (TitanDurability_inventory_duraPercent) then
            	if (TitanDurability_inventory_duraPercent < 100) or (not TitanGetVar(TITAN_DURABILITY_ID, "iteminfodamaged")) then
                	retstr = retstr .. "\n ";
                end
                for i, arr in pairs(TitanDurability_itemstats_inventory) do
                    local stats = TitanDurability_itemstats_inventory[i];
					local ItemName = UNKNOWN;
					if (arr[3]) then
						ItemName = arr[3];
					end
					if (stats) then
						if (stats[3]) and (stats[3] ~= GSC_NONE) and (stats[4]) and (stats[4] ~= GSC_NONE) then
							ItemName = "|c" .. stats[4] .. stats[3] .. "|r";
						end
						if (stats[1] == GSC_NONE) then
							if (not TitanGetVar(TITAN_DURABILITY_ID, "iteminfodamaged")) and (not TitanGetVar(TITAN_DURABILITY_ID, "iteminfohideempty")) then
								retstr = retstr .. "\n" .. ItemName .. ":\t" .. stats[1];
							end
						else
							if (not TitanGetVar(TITAN_DURABILITY_ID, "iteminfodamaged")) or (stats[1] < 100) then
								if (TitanGetVar(TITAN_DURABILITY_ID, "ShowColoredText")) then
									retstr = retstr .. "\n" .. ItemName .. ":\t" .. TitanPanelDurability_GetColoredText(stats[1]);
								else
									local duraText = TitanUtils_GetHighlightText(format(TITAN_DURABILITY_FORMAT, stats[1]));
									retstr = retstr .. "\n" .. ItemName .. ":\t" .. duraText;
								end
								if (TitanGetVar(TITAN_DURABILITY_ID, "displayrepaircostsontt")) then
									if (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) then
										if (stats[2] ~= GSC_NONE) then
											retstr = retstr .. " (" .. stats[2] .. ")";
										end
									end
								end
							end
						end
					end
                end
            end
        end
	end
	
	-- total durability
	if (TitanDurability_duraPercent) and (TitanDurability_inventory_duraPercent) then
		if (TitanGetVar(TITAN_DURABILITY_ID, "inventory")) then
			TitanDurability_duraPercent_complete = TitanDurability_duraPercent + TitanDurability_inventory_duraPercent;
			TitanDurability_duraPercent_complete = TitanDurability_duraPercent_complete / 2;
			retstr = retstr .. "\n \n" .. TITAN_DURABILITY_MENU_TOTAL ..":\t" .. TitanPanelDurability_GetColoredText(TitanDurability_duraPercent_complete);
		else
			TitanDurability_duraPercent_complete = TitanDurability_duraPercent;
		end

		if (TitanDurability_duraPercent_complete < 100) and (TitanGetVar(TITAN_DURABILITY_ID, "displayrepaircostsontt")) then
            if (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) then
            	TitanDurability_repaircost_complete = TitanDurability_totalRepairCost + TitanDurability_inventory_totalRepairCost;
                TitanDurability_totalRepairCost_complete_temp20 = TitanDurability_repaircost_complete * 0.80;
                TitanDurability_totalRepairCost_complete_temp15 = TitanDurability_repaircost_complete * 0.85;
                TitanDurability_totalRepairCost_complete_temp10 = TitanDurability_repaircost_complete * 0.90;
                TitanDurability_totalRepairCost_complete_temp05 = TitanDurability_repaircost_complete * 0.95;
                retstr = retstr .. "\n \n" .. TITAN_DURABILITY_TOOLTIP_REPAIR_00 .. ":\t" .. TitanPanelDurability_GetTextGSC(TitanDurability_repaircost_complete);
                retstr = retstr .. "\n" .. TITAN_DURABILITY_TOOLTIP_REPAIR_05 .. ":\t" .. TitanPanelDurability_GetTextGSC(TitanDurability_totalRepairCost_complete_temp05);
                retstr = retstr .. "\n" .. TITAN_DURABILITY_TOOLTIP_REPAIR_10 .. ":\t" .. TitanPanelDurability_GetTextGSC(TitanDurability_totalRepairCost_complete_temp10);
                retstr = retstr .. "\n" .. TITAN_DURABILITY_TOOLTIP_REPAIR_15 .. ":\t" .. TitanPanelDurability_GetTextGSC(TitanDurability_totalRepairCost_complete_temp15);
                retstr = retstr .. "\n" .. TITAN_DURABILITY_TOOLTIP_REPAIR_20 .. ":\t" .. TitanPanelDurability_GetTextGSC(TitanDurability_totalRepairCost_complete_temp20);
                if (TitanDurability_totalRepairCost_complete_temp20 < 1) then
                    TitanDurability_totalRepairCost_complete_temp20 = 1;
                end
                if (TitanDurability_totalRepairCost_complete_temp15 < 1) then
                    TitanDurability_totalRepairCost_complete_temp15 = 1;
                end
                if (TitanDurability_totalRepairCost_complete_temp10 < 1) then
                    TitanDurability_totalRepairCost_complete_temp10 = 1;
                end
                if (TitanDurability_totalRepairCost_complete_temp05 < 1) then
                    TitanDurability_totalRepairCost_complete_temp05 = 1;
                end
            elseif (TitanGetVar(TITAN_DURABILITY_ID, "inventory")) and ( (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) or (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) ) then
                TitanDurability_repaircost_complete = TitanDurability_totalRepairCost + TitanDurability_inventory_totalRepairCost;
                TitanDurability_repaircost_complete = TitanDurability_repaircost_complete;
                if (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) then
                    TitanDurability_repaircost_complete = TitanDurability_repaircost_complete * 0.80;
                elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) then
                    TitanDurability_repaircost_complete = TitanDurability_repaircost_complete * 0.85;
                elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) then
                    TitanDurability_repaircost_complete = TitanDurability_repaircost_complete * 0.90;
                elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) then
                    TitanDurability_repaircost_complete = TitanDurability_repaircost_complete * 0.95;
                end
                if (TitanDurability_repaircost_complete < 1) then
                    TitanDurability_repaircost_complete = 1;
                end
               	retstr = retstr .. " (" .. TitanPanelDurability_GetTextGSC(TitanDurability_repaircost_complete) .. ")";
            end
		end
	end

	return retstr;
end

-- event handler
function TitanPanelDurabilityButton_OnEvent(self, event, ...)
	if (event == "PLAYER_REGEN_ENABLED") then
		TitanDurability_PlayerInCombat = 0;
	elseif (event == "PLAYER_REGEN_DISABLED") then
		TitanDurability_PlayerInCombat = 1;
	end

	if (event == "PLAYER_ENTERING_WORLD") or (event == "UPDATE_INVENTORY_ALERTS") or (event == "BANKFRAME_CLOSED") or (event == "PLAYER_REGEN_ENABLED") or (event == "PLAYER_MONEY") or ( (event == "UNIT_INVENTORY_CHANGED") and (arg1 == "player") ) then
		if (TitanDurability_PlayerInCombat == 0) then
			TitanPanelDurability_CalcValues();
		end
	end

    if (event == "PLAYER_ENTERING_WORLD") then
        self:RegisterEvent("UPDATE_INVENTORY_ALERTS");
        self:RegisterEvent("BANKFRAME_CLOSED");
        self:RegisterEvent("MERCHANT_CLOSED");
        self:RegisterEvent("PLAYER_REGEN_ENABLED");
        self:RegisterEvent("PLAYER_REGEN_DISABLED");
        self:RegisterEvent("PLAYER_MONEY");
        self:RegisterEvent("UNIT_INVENTORY_CHANGED");
        return;
    end

    if (event == "PLAYER_LEAVING_WORLD") then
		self:UnregisterEvent("UPDATE_INVENTORY_ALERTS");
		self:UnregisterEvent("BANKFRAME_CLOSED");
		self:UnregisterEvent("MERCHANT_CLOSED");
        self:UnregisterEvent("PLAYER_REGEN_ENABLED");
        self:UnregisterEvent("PLAYER_REGEN_DISABLED");
        self:UnregisterEvent("PLAYER_MONEY");
        self:UnregisterEvent("UNIT_INVENTORY_CHANGED");
		return;
    end
end

-- create addon menu
function TitanPanelRightClickMenu_PrepareDurabilityMenu()
	local id = "Durability";
	local info = {};

	TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_DURABILITY_ID].menuText);
	TitanPanelRightClickMenu_AddSpacer();

	info = {};
	info.text = TITAN_DURABILITY_MENU_INVENTORY;
	info.value = "inventory";
	info.func = TitanPanelDurability_Toggle;
	info.checked = TitanGetVar(TITAN_DURABILITY_ID, "inventory");
	info.keepShownOnClick = 1;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_DURABILITY_ITEMNAMES;
	info.value = "showitemnames";
	info.func = TitanPanelDurability_Toggle;
	info.checked = TitanGetVar(TITAN_DURABILITY_ID, "showitemnames");
	info.keepShownOnClick = 1;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_DURABILITY_MENU_GUY;
	info.value = "hideguy";
	info.func = TitanPanelDurability_Toggle;
	info.checked = TitanGetVar(TITAN_DURABILITY_ID, "hideguy");
	info.keepShownOnClick = 1;
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_DURABILITY_LIMIT_CALCULATIONS;
	info.value = "limitcalculations";
	info.func = TitanPanelDurability_Toggle;
	info.checked = TitanGetVar(TITAN_DURABILITY_ID, "limitcalculations");
	info.keepShownOnClick = 1;
	UIDropDownMenu_AddButton(info);
	
	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddTitle(TITAN_DURABILITY_MENU_DISPLAY_ONTT);
	TitanPanelRightClickMenu_AddSpacer();

	info = {};
	info.text = TITAN_DURABILITY_MENU_ITEMS;
	info.value = "iteminfo";
	info.func = TitanPanelDurability_Toggle;
	info.checked = TitanGetVar(TITAN_DURABILITY_ID, "iteminfo");
	UIDropDownMenu_AddButton(info);

	if (TitanGetVar(TITAN_DURABILITY_ID, "iteminfo")) then
        info = {};
        info.text = TITAN_DURABILITY_MENU_ITEMS_INVENTORY;
        info.value = "iteminfo_inventory";
        info.func = TitanPanelDurability_Toggle;
        info.checked = TitanGetVar(TITAN_DURABILITY_ID, "iteminfo_inventory");
        UIDropDownMenu_AddButton(info);

        info = {};
        info.text = TITAN_DURABILITY_MENU_HIDE_EMPTY_SLOTS;
        info.value = "iteminfohideempty";
        info.func = TitanPanelDurability_Toggle;
        info.checked = TitanGetVar(TITAN_DURABILITY_ID, "iteminfohideempty");
        info.keepShownOnClick = 1;
        UIDropDownMenu_AddButton(info);

        info = {};
        info.text = TITAN_DURABILITY_MENU_ITEMS_DAMAGED;
        info.value = "iteminfodamaged";
        info.func = TitanPanelDurability_Toggle;
        info.checked = TitanGetVar(TITAN_DURABILITY_ID, "iteminfodamaged");
        info.keepShownOnClick = 1;
        UIDropDownMenu_AddButton(info);
	end

	info = {};
	info.text = TITAN_DURABILITY_REPAIR_COST;
	info.value = "displayrepaircostsontt";
	info.func = TitanPanelDurability_Toggle;
	info.checked = TitanGetVar(TITAN_DURABILITY_ID, "displayrepaircostsontt");
	info.keepShownOnClick = 1;
	UIDropDownMenu_AddButton(info);

	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddTitle(TITAN_DURABILITY_MENU_DISPLAY_ONTP);
	TitanPanelRightClickMenu_AddSpacer();

    info = {};
    info.text = TITAN_DURABILITY_MENU_EQUIPPEDDURABILITY;
    info.value = "showduraintp";
    info.func = TitanPanelDurability_Toggle;
    info.checked = TitanGetVar(TITAN_DURABILITY_ID, "showduraintp");
    UIDropDownMenu_AddButton(info);
	
    info = {};
    info.text = TITAN_DURABILITY_MENU_LOWESTEQUIPPEDDURABILITY;
    info.value = "showlowestduraintp";
    info.func = TitanPanelDurability_Toggle;
    info.checked = TitanGetVar(TITAN_DURABILITY_ID, "showlowestduraintp");
    UIDropDownMenu_AddButton(info);

	if (TitanGetVar(TITAN_DURABILITY_ID, "inventory")) then
        info = {};
        info.text = TITAN_DURABILITY_MENU_INVENTORYINTP;
        info.value = "showinventoryintp";
        info.func = TitanPanelDurability_Toggle;
        info.checked = TitanGetVar(TITAN_DURABILITY_ID, "showinventoryintp");
        UIDropDownMenu_AddButton(info);

        info = {};
        info.text = TITAN_DURABILITY_MENU_TOTALDURABILITY;
        info.value = "showtotalduraintp";
        info.func = TitanPanelDurability_Toggle;
        info.checked = TitanGetVar(TITAN_DURABILITY_ID, "showtotalduraintp");
        UIDropDownMenu_AddButton(info);
	end

    info = {};
    info.text = TITAN_DURABILITY_MENU_REPAIRCOSTLOWESTINTP;
    info.value = "showlowestitemintp";
    info.func = TitanPanelDurability_Toggle;
    info.checked = TitanGetVar(TITAN_DURABILITY_ID, "showlowestitemintp");
    info.keepShownOnClick = 1;
    UIDropDownMenu_AddButton(info);

    info = {};
    info.text = TITAN_DURABILITY_REPAIR_COST;
    info.value = "showrepaircostintp";
    info.func = TitanPanelDurability_Toggle;
    info.checked = TitanGetVar(TITAN_DURABILITY_ID, "showrepaircostintp");
    info.keepShownOnClick = 1;
    UIDropDownMenu_AddButton(info);

	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddTitle(TITAN_DURABILITY_MENU_DISPLAY_OF_REPAIR_COST);
	TitanPanelRightClickMenu_AddSpacer();

	info = {};
	info.text = "Normal " .. TITAN_DURABILITY_REPAIR_COST .. " (" .. TITAN_DURABILITY_TOOLTIP_REPAIR_00 .. ")";
	info.value = "showrepaircost";
	info.func = TitanPanelDurability_Set;
	info.checked = TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost");
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_DURABILITY_MENU_REPAIRCOST05 .. " (" .. TITAN_DURABILITY_TOOLTIP_REPAIR_05 .. ")";
	info.value = "showrepaircost05";
	info.func = TitanPanelDurability_Set;
	info.checked = TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05");
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_DURABILITY_MENU_REPAIRCOST10 .. " (" .. TITAN_DURABILITY_TOOLTIP_REPAIR_10 .. ")";
	info.value = "showrepaircost10";
	info.func = TitanPanelDurability_Set;
	info.checked = TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10");
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_DURABILITY_MENU_REPAIRCOST15 .. " (" .. TITAN_DURABILITY_TOOLTIP_REPAIR_15 .. ")";
	info.value = "showrepaircost15";
	info.func = TitanPanelDurability_Set;
	info.checked = TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15");
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = TITAN_DURABILITY_MENU_REPAIRCOST20 .. " (" .. TITAN_DURABILITY_TOOLTIP_REPAIR_20 .. "/Goblin)";
	info.value = "showrepaircost20";
	info.func = TitanPanelDurability_Set;
	info.checked = TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20");
	UIDropDownMenu_AddButton(info);

	info = {};
	info.text = "Show all";
	info.value = "showallrepaircosts";
	info.func = TitanPanelDurability_Set;
	info.checked = TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts");
	UIDropDownMenu_AddButton(info);

	TitanPanelRightClickMenu_AddSpacer();

	TitanPanelRightClickMenu_AddToggleIcon(TITAN_DURABILITY_ID);
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_DURABILITY_ID);
	TitanPanelRightClickMenu_AddToggleColoredText(TITAN_DURABILITY_ID);
	TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], id, TITAN_PANEL_MENU_FUNC_HIDE);
end

-- set function for addon settings
function TitanPanelDurability_Set(self)
	TitanSetVar(TITAN_DURABILITY_ID, self.value, 1);

    if (self.value == "showrepaircost") then
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost20", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost15", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost10", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost05", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showallrepaircosts", false);
    end

    if (self.value == "showrepaircost20") then
    	TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost15", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost10", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost05", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showallrepaircosts", false);
    end

    if (self.value == "showrepaircost15") then
    	TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost20", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost10", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost05", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showallrepaircosts", false);
    end

    if (self.value == "showrepaircost10") then
    	TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost20", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost15", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost05", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showallrepaircosts", false);
    end

    if (self.value == "showrepaircost05") then
    	TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost20", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost15", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost10", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showallrepaircosts", false);
    end

    if (self.value == "showallrepaircosts") then
    	TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost20", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost15", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost10", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost05", false);
    end

    TitanPanelDurability_CalcValues();

    TitanPanelButton_UpdateButton(TITAN_DURABILITY_ID);
end

-- toggle function for addon settings
function TitanPanelDurability_Toggle(self)
	TitanToggleVar(TITAN_DURABILITY_ID, self.value);

    if (self.value == "showduraintp") then
        TitanSetVar(TITAN_DURABILITY_ID, "showtotalduraintp", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showinventoryintp", false);
		TitanSetVar(TITAN_DURABILITY_ID, "showlowestduraintp", false);
    end

    if (self.value == "showtotalduraintp") then
        TitanSetVar(TITAN_DURABILITY_ID, "showduraintp", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showinventoryintp", false);
		TitanSetVar(TITAN_DURABILITY_ID, "showlowestduraintp", false);
    end

    if (self.value == "showinventoryintp") then
        TitanSetVar(TITAN_DURABILITY_ID, "showduraintp", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showtotalduraintp", false);
		TitanSetVar(TITAN_DURABILITY_ID, "showlowestduraintp", false);
    end

    if (self.value == "showlowestduraintp") then
        TitanSetVar(TITAN_DURABILITY_ID, "showduraintp", false);
        TitanSetVar(TITAN_DURABILITY_ID, "showtotalduraintp", false);
		TitanSetVar(TITAN_DURABILITY_ID, "showinventoryintp", false);
    end
	
	if (self.value == "showduraintp") or (self.value == "showtotalduraintp") or (self.value == "showinventoryintp") or (self.value == "showlowestduraintp") then
		if (not TitanGetVar(TITAN_DURABILITY_ID, "showduraintp")) and (not TitanGetVar(TITAN_DURABILITY_ID, "showtotalduraintp")) and (not TitanGetVar(TITAN_DURABILITY_ID, "showinventoryintp")) and (not TitanGetVar(TITAN_DURABILITY_ID, "showlowestduraintp")) then
			TitanToggleVar(TITAN_DURABILITY_ID, self.value);
		end
	end

	if (self.value == "inventory") then
		if (TitanGetVar(TITAN_DURABILITY_ID, "showtotalduraintp")) then
			TitanToggleVar(TITAN_DURABILITY_ID, "showduraintp");
			TitanSetVar(TITAN_DURABILITY_ID, "showtotalduraintp", false);
		end
	end

	if (self.value == "hideguy") or (self.value == "inventory") or (self.value == "showitemnames") or (self.value == "ShowColoredText") then
    	TitanPanelDurability_CalcValues();
	end

	TitanPanelButton_UpdateButton(TITAN_DURABILITY_ID);
end

-- percent values formatting 0.0 - 1.0
function TitanDurability_GetStatusPercent(val, max)
	if (val) then
		if (max > 0) then
			return (val / max);
		end
	end
	return 1.0;
end

-- check bag slot for item and durability
function TitanDurability_GetStatus(bag, slot)
	local val = 0;
	local max = 0;
	local cost = 0;
	local hasItem, repairCost;

	TPDurTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");

	if (bag) then
		local _, lRepairCost = TPDurTooltip:SetBagItem(bag, slot);
		repairCost = lRepairCost;
		hasItem = 1;
	else
		local slotName = REPAIR_ITEM_STATUS[slot].slot .. "Slot";

		local id = GetInventorySlotInfo(slotName);
		local lHasItem, _, lRepairCost = TPDurTooltip:SetInventoryItem("player", id);
		hasItem = lHasItem;
		repairCost = lRepairCost;
	end

	if (hasItem) then
        local TitanPanelDurability_Current_Item_Color = GSC_NONE;
        local TitanPanelDurability_Current_Item_Name = GSC_NONE;
        local TitanPanelDurability_Current_Item_Percent = GSC_NONE;
        
		if (repairCost) then
			cost = repairCost;
		end
		
		val, max = GetContainerItemDurability(bag, slot);
		
		if (TitanGetVar(TITAN_DURABILITY_ID, "iteminfo")) and (TitanGetVar(TITAN_DURABILITY_ID, "iteminfo_inventory")) and (val) then
			TitanPanelDurability_Current_Item_Percent = math.floor(val / max * 100);
			-- getting item details
            local TitanPanelDurability_itemLink = GetContainerItemLink(bag, slot);
            if (TitanPanelDurability_itemLink) then
                _, _, TitanPanelDurability_Current_Item_Color, TitanPanelDurability_Current_Item_Name = string.find(TitanPanelDurability_itemLink, "^|c(%x+)|H(.+)|h%[.+%]");
                if (TitanPanelDurability_Current_Item_Name) and (TitanPanelDurability_Current_Item_Name ~= GSC_NONE) then
                    TitanPanelDurability_Current_Item_Name = GetItemInfo(TitanPanelDurability_Current_Item_Name);
                end
            end
			-- filling inventory item details table
			table.insert(TitanDurability_itemstats_inventory,{
                TitanPanelDurability_Current_Item_Percent,
                TitanPanelDurability_GetTextGSC(repairCost),
                TitanPanelDurability_Current_Item_Name,
                TitanPanelDurability_Current_Item_Color,
            })

            if (TitanDurability_Debug == 1) then
                ChatFrame1:AddMessage("Titan Durability: Bag: " .. bag .. " Slot: " .. slot .. " Item: " .. "|c" .. TitanPanelDurability_Current_Item_Color .. TitanPanelDurability_Current_Item_Name .. "|r" .. " (" .. val .. "/" .. max .. ") " .. TitanPanelDurability_Current_Item_Percent .. "%", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
            end
        end

		TPDurTooltip:Hide();
		return TitanDurability_GetStatusPercent(val, max), val, max, cost;
	end
end

-- calculate durability
function TitanPanelDurability_CalcValues()
	-- debug message for calculation speed / lag
	if (TitanDurability_Debug == 1) and (event) then
		if (not update_count) then
			update_count = 0
		end
		update_count = update_count + 1
		ChatFrame1:AddMessage("Titan Durability: Event " .. event .. " | Total count: " .. update_count, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
	end
	if ((not last_update_time) or (last_update_time < (GetTime() - TitanDurability_CalculatationInterval))) or (not TitanGetVar(TITAN_DURABILITY_ID, "limitcalculations")) then
	
		-- to prevent an empty titan panel entry
		if (event == "PLAYER_ENTERING_WORLD") then
			if (not TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost")) and (not TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) and (not TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) and (not TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) and (not TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) then
				TitanSetVar(TITAN_DURABILITY_ID, "showrepaircost", 1);
			end
			if (not TitanGetVar(TITAN_DURABILITY_ID, "showduraintp")) and (not TitanGetVar(TITAN_DURABILITY_ID, "showtotalduraintp")) and (not TitanGetVar(TITAN_DURABILITY_ID, "showinventoryintp")) and (not TitanGetVar(TITAN_DURABILITY_ID, "showlowestduraintp")) then
				TitanSetVar(TITAN_DURABILITY_ID, "showduraintp", 1);
			end
		end

		if (TitanDurability_Debug == 1) then
			ChatFrame1:AddMessage("Titan Durability: Calculating equipped durability ..", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		end

		-- hide Durability "guy"
		if (TitanGetVar(TITAN_DURABILITY_ID, "hideguy")) then
			if (DurabilityFrame:IsVisible()) then
				DurabilityFrame:Hide();
			end
		end
		-- calculate equipped durability
		local slotnames = {
			"Head",
			"Shoulder",
			"Chest",
			"Wrist",
			"Hands",
			"Waist",
			"Legs",
			"Feet",
			"MainHand",
			"SecondaryHand",
		};

		local id, hasItem, repairCost;
		local itemName, durability, tmpText, midpt, lval, rval;

		TitanDurability_totalRepairCost = 0;
		TitanDurability_duraPercent = 0;
		TitanDurability_duraCurr = 0;
		TitanDurability_duraTotal = 0;
		TitanDurability_inventory_totalRepairCost = 0;
		TitanDurability_inventory_duraPercent = 0;
		TitanDurability_inventory_duraCurr = 0;
		TitanDurability_inventory_duraTotal = 0;
		TitanDurability_duraLowestPercent = 100;
		TitanDurability_duraLowestRepairCost = 0;
		TitanDurability_duraLowestslotName = GSC_NONE;

		if (TitanDurability_Debug == 1) then
			scan_equip_starttime = GetTime();
		end

		for i, slotName in pairs(slotnames) do
			id, _ = GetInventorySlotInfo(slotName .. "Slot");
			TPDurTooltip:Hide()
			TPDurTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
			hasItem, _, Current_Item_RepairCost = TPDurTooltip:SetInventoryItem("player", id);

			TitanDurability_Current_Item_RepairCost_temp = Current_Item_RepairCost;

			if (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost20")) or (TitanGetVar(TITAN_DURABILITY_ID, "showallrepaircosts")) then
				TitanDurability_Current_Item_RepairCost_temp = TitanDurability_Current_Item_RepairCost_temp * 0.80;
			elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost15")) then
				TitanDurability_Current_Item_RepairCost_temp = TitanDurability_Current_Item_RepairCost_temp * 0.85;
			elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost10")) then
				TitanDurability_Current_Item_RepairCost_temp = TitanDurability_Current_Item_RepairCost_temp * 0.90;
			elseif (TitanGetVar(TITAN_DURABILITY_ID, "showrepaircost05")) then
				TitanDurability_Current_Item_RepairCost_temp = TitanDurability_Current_Item_RepairCost_temp * 0.95;
			end

			if (not hasItem) then
				TPDurTooltip:ClearLines();
			else
				lval, rval = GetInventoryItemDurability(id);
			end

			if (lval and rval) then
				local TitanPanelDurability_Current_Item_Color = GSC_NONE;
				local TitanPanelDurability_Current_Item_Name = GSC_NONE;
				local TitanPanelDurability_Current_Item_Percent = GSC_NONE;
				-- get item details
				local TitanPanelDurability_itemLink = GetInventoryItemLink("player", id);
				if (TitanPanelDurability_itemLink) then
					_, _, TitanPanelDurability_Current_Item_Color, TitanPanelDurability_Current_Item_Name = string.find(TitanPanelDurability_itemLink, "^|c(%x+)|H(.+)|h%[.+%]");
					if (TitanPanelDurability_Current_Item_Name) and (TitanPanelDurability_Current_Item_Name ~= GSC_NONE) then
						TitanPanelDurability_Current_Item_Name = GetItemInfo(TitanPanelDurability_Current_Item_Name);
					end
				end

				if (rval ~= 0) then
					TitanPanelDurability_Current_Item_Percent = math.floor(lval / rval * 100);
					if (TitanPanelDurability_Current_Item_Percent < TitanDurability_duraLowestPercent) then
						TitanDurability_duraLowestPercent = TitanPanelDurability_Current_Item_Percent;
						TitanDurability_duraLowestRepairCost = TitanDurability_Current_Item_RepairCost_temp;
						if (TitanGetVar(TITAN_DURABILITY_ID, "showitemnames")) and (TitanPanelDurability_Current_Item_Name) then
							TitanDurability_duraLowestslotName = "|c" .. TitanPanelDurability_Current_Item_Color .. TitanPanelDurability_Current_Item_Name .. "|r";
						else
							TitanDurability_duraLowestslotName = slotName;
						end
					end
					if (TitanPanelDurability_Current_Item_Percent < 100) and (TitanDurability_Current_Item_RepairCost_temp < 1) then
						TitanDurability_Current_Item_RepairCost_temp = 1;
					end
				end

				TitanDurability_itemstats[slotName] = {
					TitanPanelDurability_Current_Item_Percent,
					TitanPanelDurability_GetTextGSC(TitanDurability_Current_Item_RepairCost_temp),
					TitanPanelDurability_Current_Item_Name,
					TitanPanelDurability_Current_Item_Color,
				};
				TitanDurability_duraCurr = TitanDurability_duraCurr + lval;
				TitanDurability_duraTotal = TitanDurability_duraTotal + rval;
				TitanDurability_totalRepairCost = TitanDurability_totalRepairCost + Current_Item_RepairCost;
				
				if (TitanDurability_Debug == 1) then
					ChatFrame1:AddMessage("Titan Durability: Slot: " .. slotName .. " Item: " .. "|c" .. TitanPanelDurability_Current_Item_Color .. TitanPanelDurability_Current_Item_Name .. "|r" .. " ( " .. lval .. "/" .. rval .. ") " .. TitanPanelDurability_Current_Item_Percent .. "%", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
				end
				
				lval = 0;
				rval = 0;
			else
				TitanDurability_itemstats[slotName] = {
					GSC_NONE,
					GSC_NONE,
					GSC_NONE,
					GSC_NONE,
				};
			end
		end

		if (TitanDurability_Debug == 1) then
			scan_equip_endtime = GetTime();
			scan_equip_time = string.format("%f", scan_equip_endtime - scan_equip_starttime);
			if (scan_equip_time) then
				ChatFrame1:AddMessage("Titan Durability: Update of equipment took " .. scan_equip_time .. " seconds.", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
			end
		end
		-- calculate inventory durability
		if (TitanGetVar(TITAN_DURABILITY_ID, "inventory")) then
			if (TitanDurability_Debug == 1) and (event) then
				ChatFrame1:AddMessage("Titan Durability: Calculating inventory durability ..", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
			end
			TitanDurability_itemstats_inventory = {};
			if (TitanDurability_Debug == 1) then -- calculating update time
				scan_inventory_starttime = GetTime();
			end
			for bag = 0, 4 do
				for slot = 1, GetContainerNumSlots(bag) do
					local _, lval, rval, repairCost = TitanDurability_GetStatus(bag, slot);
					if (lval) then
						TitanDurability_inventory_duraCurr = TitanDurability_inventory_duraCurr + lval;
						TitanDurability_inventory_duraTotal = TitanDurability_inventory_duraTotal + rval;
						TitanDurability_inventory_totalRepairCost = TitanDurability_inventory_totalRepairCost + repairCost;
					end
				end
			end
			if (TitanDurability_Debug == 1) then
				scan_inventory_endtime = GetTime();
				scan_inventory_time = string.format("%f", scan_inventory_endtime - scan_inventory_starttime); -- calculating update time
				if (scan_inventory_time) then
					ChatFrame1:AddMessage("Titan Durability: Update of inventory took " .. scan_inventory_time .. " seconds.", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
				end
			end
		end

		TPDurTooltip:Hide()

		if (TitanGetVar(TITAN_DURABILITY_ID, "inventory")) then
			if (TitanDurability_inventory_duraTotal == 0) then
				TitanDurability_inventory_duraPercent = 100;
			else
				TitanDurability_inventory_duraPercent = math.floor(TitanDurability_inventory_duraCurr / TitanDurability_inventory_duraTotal * 100);
			end
		end

		if (TitanDurability_duraTotal == 0) then
			TitanDurability_duraPercent = 100;
		else
			TitanDurability_duraPercent = math.floor(TitanDurability_duraCurr / TitanDurability_duraTotal * 100);
		end

		if (TitanDurability_duraLowestPercent < 100) and (TitanDurability_duraLowestRepairCost < 1) then
			TitanDurability_duraLowestRepairCost = 1;
		end

		if (TitanDurability_inventory_duraPercent < 100) and (TitanDurability_inventory_totalRepairCost < 1) then
			TitanDurability_inventory_totalRepairCost = 1;
		end

		TitanPanelButton_UpdateButton(TITAN_DURABILITY_ID);
		last_update_time = GetTime();
	else
		if (TitanDurability_Debug == 1) then
			ChatFrame1:AddMessage("Titan Durability: not calculated since last calculation was done less than " .. TitanDurability_CalculatationInterval .. " seconds ago", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		end
	end
end

-- formatting gold values
function TitanPanelDurability_GetGSC(money)
	local neg = false;
	if (money == nil) then money = 0; end
	if (money < 0) then
		neg = true;
		money = money * -1;
	end
	local g = math.floor(money / 10000);
	local s = math.floor((money - (g * 10000)) / 100);
	local c = math.floor(money - (g * 10000) - (s * 100));
	return g, s, c, neg;
end

GSC_GOLD = "ffd100";
GSC_SILVER = "e6e6e6";
GSC_COPPER = "c8602c";
GSC_START = "|cff%s%d|r";
GSC_PART = ".|cff%s%02d|r";
GSC_NONE = "|cffa0a0a0" .. NONE .. "|r";

function TitanPanelDurability_GetTextGSC(money)
    local g, s, c, neg = TitanPanelDurability_GetGSC(money);
    local gsc = "";
    if (g > 0) then
        gsc = format(GSC_START, GSC_GOLD, g);
        gsc = gsc .. format(GSC_PART, GSC_SILVER, s);
        gsc = gsc .. format(GSC_PART, GSC_COPPER, c);
    elseif (s > 0) then
        gsc = format(GSC_START, GSC_SILVER, s);
        gsc = gsc .. format(GSC_PART, GSC_COPPER, c);
    elseif (c > 0) then
        gsc = gsc .. format(GSC_START, GSC_COPPER, c);
    else
        gsc = GSC_NONE;
    end

    if (neg) then gsc = "(" .. gsc .. ")"; end

    return gsc;
end

function TitanPanelDurability_GetColoredText(percent)
	if (TitanGetVar(TITAN_DURABILITY_ID, "ShowColoredText")) then
        local green = GREEN_FONT_COLOR;     -- 0.1, 1.00, 0.1
        local yellow = NORMAL_FONT_COLOR;   -- 1.0, 0.82, 0.0
        local red = RED_FONT_COLOR;         -- 1.0, 0.10, 0.1

        percent = percent / 100;
        local color = {};

        if (percent == 1.0) then
            color = green;
        elseif (percent == 0.5) then
            color = yellow;
        elseif (percent == 0.0) then
            color = red;
        elseif (percent > 0.5) then
            local pct = (1.0 - percent) * 2;
            color.r = (yellow.r - green.r) * pct + green.r;
            color.g = (yellow.g - green.g) * pct + green.g;
            color.b = (yellow.b - green.b) * pct + green.b;
        elseif (percent < 0.5) then
            local pct = (0.5 - percent) * 2;
            color.r = (red.r - yellow.r) * pct + yellow.r;
            color.g = (red.g - yellow.g) * pct + yellow.g;
            color.b = (red.b - yellow.b) * pct + yellow.b;
        end

        local txt = format(TITAN_DURABILITY_FORMAT, percent * 100);
        local colortxt = TitanUtils_GetColoredText(txt, color);

        return colortxt;
    else
    	return TitanUtils_GetHighlightText(format(TITAN_DURABILITY_FORMAT, percent));
    end
end