--------------------------------------------------
-- BonusScanner v2.3
-- by Crowley <crowley@headshot.de>
-- performance improvements by Archarodim
-- Updated for WoW 2.0 by jmlsteele
--
-- get the latest version here:
-- http://wow.curse-gaming.com/en/files/details/5353/bonusscanner2-0/
--------------------------------------------------

BONUSSCANNER_VERSION = "v2.3";


BONUSSCANNER_PATTERN_SETNAME = "^(.*) %(%d/%d%)$";
BONUSSCANNER_PATTERN_GENERIC_PREFIX = "^%+(%d+)%%?(.*)$";
BONUSSCANNER_PATTERN_GENERIC_SUFFIX = "^(.*)%+(%d+)%%?$";
BONUSSCANNER_PATTERN_GENERIC_PREFIX_AND = "^%+(%d+)%%?(.*) and ";
BONUSSCANNER_PATTERN_GENERIC_SUFFIX_AND = "^(.*)%+(%d+)%%? and ";

BonusScanner = {
	bonuses = {};
	bonuses_details = {};

	IsUpdating		= false;-- not sure if this check is needed but who knows with multithreading...
	MinCheckInterval	= 1;	-- Minimum time to wait between each scan
	CheckIntervalCounter	= 0;	-- counter, do not change
	CheckForBonusPlease	= 0;	-- The flag that when set makes BonusScanner scan the equipment and call the update function
	ShowDebug		= false;-- tells when the equipment is scanned
	Verbose			= false;-- Shows a LOT of debug information


	active = nil;
	temp = { 
		sets = {},
		set = "",
		slot = "",
		bonuses = {},
		details = {}
	};

	slots = {
		"Head",
		"Neck",
		"Shoulder",
		"Shirt",
		"Chest",
		"Waist",
		"Legs",
		"Feet",
		"Wrist",
		"Hands",
		"Finger0",
		"Finger1",
		"Trinket0",
		"Trinket1",
		"Back",
		"MainHand",
		"SecondaryHand",
		"Ranged",
		"Tabard",
	};
}

-- Update function to hook into. 
-- Gets called, when Equipment changes (after UNIT_INVENTORY_CHANGED)
function BonusScanner_Update()
end

function BonusScanner:GetBonus(bonus)
	if(BonusScanner.bonuses[bonus]) then
		return BonusScanner.bonuses[bonus];
	end;
	return 0;
end

function BonusScanner:GetSlotBonuses(slotname)
	local i, bonus, details;
	local bonuses = {};
	for bonus, details in pairs(BonusScanner.bonuses_details) do
		if(details[slotname]) then
			bonuses[bonus] = details[slotname];
		end
	end
	return bonuses;
end

function BonusScanner:GetBonusDetails(bonus)
	if(BonusScanner.bonuses_details[bonus]) then
		return BonusScanner.bonuses_details[bonus];
	end;
	return {};
end

function BonusScanner:GetSlotBonus(bonus, slotname)
	if(BonusScanner.bonuses_details[bonus]) then
		if(BonusScanner.bonuses_details[bonus][slotname]) then
			return BonusScanner.bonuses_details[bonus][slotname];
		end;
	end;
	return 0;
end


function BonusScanner:OnLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("PLAYER_LEAVING_WORLD");
end

function BonusScanner:OnEvent()

	BonusScanner:Debug(event);

	if ((event == "UNIT_INVENTORY_CHANGED") and BonusScanner.active) then
		BonusScanner.CheckForBonusPlease = 1;
		return;
	end
	if (event == "PLAYER_ENTERING_WORLD") then
		BonusScanner.active = 1;
		BonusScanner.CheckForBonusPlease = 1;
		this:RegisterEvent("UNIT_INVENTORY_CHANGED");
	return;
	end
	if (event == "PLAYER_LEAVING_WORLD") then
		this:UnregisterEvent("UNIT_INVENTORY_CHANGED");
		return;
	end	
end


-- A little debug function
function BonusScanner:Debug(Message)
	if (BonusScanner.ShowDebug) then
		DEFAULT_CHAT_FRAME:AddMessage("BonusScanner Debug: " .. Message, 0.5, 0.8, 1);
	end	
end

-- The use of the <OnUpdate></OnUpdate> *feature* avoid freezes and lags caused by the useless repeated call of BonusScanner:ScanEquipment()...
function BonusScanner:OnUpdate (elapsed)

	if (BonusScanner.IsUpdating) then
		return;
	end

	BonusScanner.IsUpdating = true;

	-- if the equipment has changed then check if we are allowed to test for bonuses
	if (BonusScanner.CheckForBonusPlease == 1) then
		BonusScanner.CheckIntervalCounter = BonusScanner.CheckIntervalCounter + elapsed;

		-- if we have waited long enough then proceed...
		if (BonusScanner.CheckIntervalCounter > BonusScanner.MinCheckInterval) then
			BonusScanner.CheckForBonusPlease = 2; -- means we are currently checking
			BonusScanner.bonuses, BonusScanner.bonuses_details = BonusScanner:ScanEquipment("player"); -- scan the equiped items
			BonusScanner_Update(); -- call the update function (for the mods using this library)
			if (BonusScanner.CheckForBonusPlease ~= 1) then -- if no other update has been requested
				BonusScanner.CheckForBonusPlease = 0;
			end
			BonusScanner.CheckIntervalCounter = 0;
		end
	end

	BonusScanner.IsUpdating = false;
end

function BonusScanner:ScanEquipment(target)
	local slotid, slotname, hasItem, i;

	BonusScannerTooltip:SetOwner(UIParent, "ANCHOR_NONE");

	BonusScanner:Debug("Scanning Equipment has requested");

	BonusScanner.temp.bonuses = {};
	BonusScanner.temp.details = {};
	BonusScanner.temp.sets = {};
	BonusScanner.temp.set = "";

	for i, slotname in pairs(BonusScanner.slots) do
		slotid, _ = GetInventorySlotInfo(slotname.. "Slot");
		hasItem = BonusScannerTooltip:SetInventoryItem(target, slotid);
	
		if ( hasItem ) then

			BonusScanner.temp.slot = slotname;
			BonusScanner:ScanTooltip();
			-- if set item, mark set as already scanned
			if(BonusScanner.temp.set ~= "") then
				BonusScanner.temp.sets[BonusScanner.temp.set] = 1;
			end;
		end
	end

	return BonusScanner.temp.bonuses, BonusScanner.temp.details
end

function BonusScanner:ScanItem(itemlink)
	local name = GetItemInfo(itemlink);
	if(name) then
		BonusScanner.temp.bonuses = {};
		BonusScanner.temp.sets = {};
		BonusScanner.temp.set = "";
		BonusScanner.temp.slot = "";
		BonusScannerTooltip:ClearLines();
		BonusScannerTooltip:SetHyperlink(itemlink);
		BonusScanner:ScanTooltip();
		return BonusScanner.temp.bonuses;
	end
	return false;
end

function BonusScanner:ScanTooltip()
	local tmpTxt, line;
	local lines = BonusScannerTooltip:NumLines();

	for i=2, lines, 1 do
		tmpText = getglobal("BonusScannerTooltipTextLeft"..i);
		val = nil;
		if (tmpText:GetText()) then
			line = tmpText:GetText();
			local color = {tmpText:GetTextColor()};
			BonusScanner:ScanLine(line,color);
		end
	end
end

function BonusScanner:AddValue(effect, value)
	local i,e;
	if(type(effect) == "string") then
		if (BonusScanner.Verbose) then
			BonusScanner:Debug("Adding Effect: " .. effect .. " Value: " .. value);
		end
		if(BonusScanner.temp.bonuses[effect]) then
			BonusScanner.temp.bonuses[effect] = BonusScanner.temp.bonuses[effect] + value;
		else
			BonusScanner.temp.bonuses[effect] = value;
		end
		
		if(BonusScanner.temp.slot) then
			if(BonusScanner.temp.details[effect]) then
				if(BonusScanner.temp.details[effect][BonusScanner.temp.slot]) then
					BonusScanner.temp.details[effect][BonusScanner.temp.slot] = BonusScanner.temp.details[effect][BonusScanner.temp.slot] + value;
				else
					BonusScanner.temp.details[effect][BonusScanner.temp.slot] = value;
				end
			else
				BonusScanner.temp.details[effect] = {};
				BonusScanner.temp.details[effect][BonusScanner.temp.slot] = value;
			end
		end;
	else 
	-- list of effects
		if(type(value) == "table") then
			for i,e in pairs(effect) do
				BonusScanner:AddValue(e, value[i]);
			end
		else
			for i,e in pairs(effect) do
				BonusScanner:AddValue(e, value);
			end
		end
	end
end;

function BonusScanner:ScanLine(line,color)
	local tmpStr, found;
	BonusScanner:Debug(line .. " (".. string.len(line) .. ")")

	-- Check for "Equip: "
	if(string.sub(line,0,string.len(BONUSSCANNER_PREFIX_EQUIP)) == BONUSSCANNER_PREFIX_EQUIP) then

		tmpStr = string.sub(line,string.len(BONUSSCANNER_PREFIX_EQUIP)+1);
		BonusScanner:CheckPassive(tmpStr);

	-- Check for "Set: "
	elseif(string.sub(line,0,string.len(BONUSSCANNER_PREFIX_SET)) == BONUSSCANNER_PREFIX_SET
			and BonusScanner.temp.set ~= "" 
			and not BonusScanner.temp.sets[BonusScanner.temp.set]) then

		tmpStr = string.sub(line,string.len(BONUSSCANNER_PREFIX_SET)+1);
		BonusScanner.temp.slot = "Set";
		BonusScanner:CheckPassive(tmpStr);
	--Socket Bonus:
	elseif(string.sub(line,0,string.len(BONUSSCANNER_PREFIX_SOCKET)) == BONUSSCANNER_PREFIX_SOCKET) then
		--See if the line is green
		if (color[1] < 0.1 and color[2] > 0.99 and color[3] < 0.1 and color[4] > 0.99) then
			tmpStr = string.sub(line,string.len(BONUSSCANNER_PREFIX_SOCKET)+1);
			BonusScanner:CheckPassive(tmpStr);
		end

	-- any other line (standard stats, enchantment, set name, etc.)
	else
		-- Check for set name
		_, _, tmpStr = string.find(line, BONUSSCANNER_PATTERN_SETNAME);
		if(tmpStr) then
			BonusScanner.temp.set = tmpStr;
		else
			found = BonusScanner:CheckGeneric(line);
			if(not found) then
				BonusScanner:CheckOther(line);
			end;
		end
	end
end;


-- Scans passive bonuses like "Set: " and "Equip: "
function BonusScanner:CheckPassive(line)
	local i, p, results, resultCount, found;

	found = nil;
	for i,p in pairs(BONUSSCANNER_PATTERNS_PASSIVE) do
		results = {string.find(line, "^" .. p.pattern)};
		resultCount = table.getn(results);
		if(resultCount == 3) then
			BonusScanner:AddValue(p.effect, results[3])
			found = 1;
			break; -- prevent duplicated patterns to cause bonuses to be counted several times
		elseif (resultCount > 3) then
			local values = {};
			for i=3,resultCount do
				table.insert(values,results[i]);
			end
			BonusScanner:AddValue(p.effect,values);
			found = 1;
			break; -- prevent duplicated patterns to cause bonuses to be counted several times
		end

	end
	if(not found) then
		BonusScanner:CheckGeneric(line);
	end
end


-- Scans generic bonuses like "+3 Intellect" or "Arcane Resistance +4"
-- Changes for TBC (multi value gems)
function BonusScanner:CheckGeneric(line)
	local value, token, pos, tmpStr, found;

	found = false;
	while(string.len(line) > 0) do

		-- split line at "/" for enchants with multiple effects
		pos = string.find(line, "/", 1, true);
		if(pos) then
			tmpStr = string.sub(line,1,pos-1);
			line = string.sub(line,pos+1);
		else
			tmpStr = line;
			line = "";
		end

		-- trim line
		tmpStr = string.gsub( tmpStr, "^%s+", "" );
		tmpStr = string.gsub( tmpStr, "%s+$", "" );
		tmpStr = string.gsub( tmpStr, "%.$", "" );


		--Check Prefix with and (+20 Strength and )
		_, pos, value, token = string.find(tmpStr, BONUSSCANNER_PATTERN_GENERIC_PREFIX_AND);
		if (value) then
			line = string.sub(tmpStr,pos+1);
		end

		--Check Suffix with and (Strength +20 and )
		if(not value) then
			_, pos, token, value = string.find(tmpStr, BONUSSCANNER_PATTERN_GENERIC_SUFFIX_AND);
			if (value) then
				line = string.sub(tmpStr,pos+1);
			end
		end


		--Check Prefix (+20 Strength)
		if(not value) then
			_, _, value, token = string.find(tmpStr, BONUSSCANNER_PATTERN_GENERIC_PREFIX);
		end

		--Check Suffix (Strength +20)
		if(not value) then
			_, _, token, value = string.find(tmpStr, BONUSSCANNER_PATTERN_GENERIC_SUFFIX);
		end

		if(token and value) then
			-- trim token
			token = string.gsub( token, "^%s+", "" );
			token = string.gsub( token, "%s+$", "" );
			token = string.gsub( token, "%.$", "" );
	
			if(BonusScanner:CheckToken(token,value)) then
				found = true;
			end
		end
	end
	return found;
end


-- Identifies simple tokens like "Intellect" and composite tokens like "Fire damage" and 
-- add the value to the respective bonus. 
-- returns true if some bonus is found
function BonusScanner:CheckToken(token, value)
	local i, p, s1, s2;
	
	if(BONUSSCANNER_PATTERNS_GENERIC_LOOKUP[token]) then
		BonusScanner:AddValue(BONUSSCANNER_PATTERNS_GENERIC_LOOKUP[token], value);
		return true;
	else
		s1 = nil;
		s2 = nil;
		for i,p in pairs(BONUSSCANNER_PATTERNS_GENERIC_STAGE1) do
			if(string.find(token,p.pattern,1,1)) then
				s1 = p.effect;
			end
		end	
		for i,p in pairs(BONUSSCANNER_PATTERNS_GENERIC_STAGE2) do
			if(string.find(token,p.pattern,1,1)) then
				s2 = p.effect;
			end
		end	
		if(s1 and s2) then
			BonusScanner:AddValue(s1..s2, value);
			return true;
		end 
	end
	return false;
end

-- Last fallback for non generic enchants, like "Mana Regen x per 5 sec."
function BonusScanner:CheckOther(line)
	local i, p, value, start, found;

	for i,p in pairs(BONUSSCANNER_PATTERNS_OTHER) do
		start, _, value = string.find(line, "^" .. p.pattern);
		if(start) then
			BonusScanner:Debug("Special match found: \"" .. p.effect .. "\"");

			if(p.value) then
				BonusScanner:AddValue(p.effect, p.value)
			elseif(value) then
				BonusScanner:AddValue(p.effect, value)
			end
			return true;
		end
	end
	return false;
end



-- Slash Command functions

function BonusScanner_Cmd(cmd)
	local _, _, itemlink, itemid = string.find(cmd, "|c%x+|H(item:(%-?%d+):%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+:%-?%d+)|h%[.-%]|h|r");

	if(itemid) then
		local name = GetItemInfo(itemid);
		if(name) then
			DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. "Item bonuses of: " .. HIGHLIGHT_FONT_COLOR_CODE .. name);
			local bonuses = BonusScanner:ScanItem(itemlink);
			if(not bonuses) then
				DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. "error scanning item (probably not cached)");
			else
				BonusScanner:PrintInfo(bonuses);
			end
		end
		return;
	end
	if(string.lower(cmd) == "show") then
		DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. "Current equipment bonuses:");
		BonusScanner:PrintInfo(BonusScanner.bonuses);
		return;
	end
	if(string.lower(cmd) == "details") then
		DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. "Current equipment bonus details:");
		BonusScanner:PrintInfoDetailed();
		return;
	end
	if (string.lower(cmd) == "target") then
		local name  = GetUnitName("target");
		if (name) then
			local bonuses, details = BonusScanner:ScanEquipment("target"); -- scan the equiped items
			
			--Todo:  Figure out whether bonuses is empty
			if (bonuses) then
				DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. "Bonuses for "..LIGHTYELLOW_FONT_COLOR_CODE .. GetUnitName("target") .. GREEN_FONT_COLOR_CODE .. ":");
				BonusScanner:PrintInfo(bonuses);
			else
				DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. GetUnitName("target") .. " is out of range.");
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. "Please select a target first.");
		end
		return;
	end
	for i, slotname in pairs(BonusScanner.slots) do
		if(string.lower(cmd) == string.lower(slotname)) then
			DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. "Bonuses of '"..LIGHTYELLOW_FONT_COLOR_CODE .. slotname .. GREEN_FONT_COLOR_CODE .. "' slot:");
			local bonuses = BonusScanner:GetSlotBonuses(slotname);
			BonusScanner:PrintInfo(bonuses);
			return
		end;
	end
	DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. "BonusScanner " .. BONUSSCANNER_VERSION .. " by Crowley");
	DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. "/bscan show - shows all bonus of the current equipment");
	DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. "/bscan details - shows bonuses with slot distribution");
	DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. "/bscan <itemlink> - shows bonuses of linked item (insert link with Shift-Click)");
	DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. "/bscan <slotname> - shows bonuses of given equipment slot");
end

SLASH_BONUSSCANNER1 = "/bonusscanner";
SLASH_BONUSSCANNER2 = "/bscan";
SlashCmdList["BONUSSCANNER"] = BonusScanner_Cmd;


function BonusScanner:PrintInfoDetailed()
	local bonus, name, i, j, slot, first, s;
	for bonus, name in pairs(BONUSSCANNER_NAMES) do
		if(BonusScanner.bonuses[bonus]) then
			first = true;
			s = "(";
			for j, slot in pairs(BonusScanner.slots) do 
				if(BonusScanner.bonuses_details[bonus][slot]) then
					if(not first) then
						s = s .. ", ";
					else
						first = false;
					end
					s = s .. 	LIGHTYELLOW_FONT_COLOR_CODE .. slot .. 
								HIGHLIGHT_FONT_COLOR_CODE .. ": " .. BonusScanner.bonuses_details[bonus][slot];
				end
			end;
			if(BonusScanner.bonuses_details[bonus]["Set"]) then
				if(not first) then
					s = s .. ", ";
				end
				s = s .. 	LIGHTYELLOW_FONT_COLOR_CODE .. "Set" .. 
							HIGHLIGHT_FONT_COLOR_CODE .. ": " .. BonusScanner.bonuses_details[bonus]["Set"];
				end
			s = s .. ")";
			DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. name .. ": " .. HIGHLIGHT_FONT_COLOR_CODE .. BonusScanner.bonuses[bonus] .. " " .. s);
		end
	end
end

function BonusScanner:PrintInfo(bonuses)
	local bonus, name;
	for bonus, name in pairs(BONUSSCANNER_NAMES) do
		if(bonuses[bonus]) then
			DEFAULT_CHAT_FRAME:AddMessage(GREEN_FONT_COLOR_CODE .. name .. ": " .. HIGHLIGHT_FONT_COLOR_CODE .. bonuses[bonus]);
		end
	end
end
