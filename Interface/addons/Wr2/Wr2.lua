akz_creatures2 = {}; -- [saved] mob info
akz_profile2 = {};   -- [saved] character profile
akz_fishing = {};   -- [saved] fishing data
akz_objects = {};   -- [saved] world object data
akz_prices = {};    -- [saved] auction tracking
akz_merchant2 = {};  -- [saved] merchants 
akz_quests = {}; -- [saved] quest faction changes

akz_uploaded = 0;   -- [saved] track data uploads

akz_kills = {};       -- [not saved] track kill info while running
akz_lastobjtime = 0;  -- [not saved] object tracking
akz_lastobject = "";  -- [not saved] object tracking
akz_lastauctionupdatetime = 0; -- [not saved] auction timing
akz_inworld = 0; -- [not saved] login tracking
akz_lastzonetime = 0; -- [not saved] zoning
akz_laststateupdate = 0;  -- [not saved] state update timer
akz_lastinvupdate = 0;  -- [not saved] inventory update timer
akz_lastquestcompletetime = 0; -- [not saved] last quest completed timer
akz_lastquest = ""; -- [not saved] last quest completed
akz_lastitem = ""; -- [ns] last item used
akz_lastitemtime = 0;  -- [ns] time of use
akz_factions = {}; -- [ns] faction groups

akz_WrVersion = 3.0; -- [not saved] this file version

akz_standalone = 0; -- non-wowreader version

-- array of inventory slot names
akz_slots = {
  "HeadSlot",          -- 1
  "NeckSlot",          -- 2
  "ShoulderSlot",      -- 3
  "ShirtSlot",         -- 4
  "ChestSlot",         -- 5
  "WaistSlot",         -- 6
  "LegsSlot",          -- 7
  "FeetSlot",          -- 8
  "WristSlot",         -- 9
  "HandsSlot",         -- 10
  "Finger0Slot",       -- 11
  "Finger1Slot",       -- 12
  "Trinket0Slot",      -- 13
  "Trinket1Slot",      -- 14
  "BackSlot",          -- 15
  "MainHandSlot",      -- 16
  "SecondaryHandSlot", -- 17
  "RangedSlot",        -- 18
  "TabardSlot",        -- 19
};

function WrFrame_OnLoad()
  this:RegisterEvent("PLAYER_LEAVING_WORLD");
  this:RegisterEvent("PLAYER_ENTERING_WORLD");
  this:RegisterEvent("UNIT_NAME_UPDATE");
  this:RegisterEvent("UNIT_LEVEL");
  this:RegisterEvent("PLAYER_GUILD_UPDATE");
  this:RegisterEvent("UNIT_INVENTORY_CHANGED");
  this:RegisterEvent("ZONE_CHANGED");
  this:RegisterEvent("VARIABLES_LOADED");
  this:RegisterEvent("SKILL_LINES_CHANGED");
  this:RegisterEvent("CHARACTER_POINTS_CHANGED");
  this:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
  this:RegisterEvent("PLAYER_PVP_RANK_CHANGED");
  this:RegisterEvent("PLAYER_MONEY");
  this:RegisterEvent("ZONE_CHANGED_NEW_AREA");
  this:RegisterEvent("UPDATE_WORLD_STATES");
	this:RegisterEvent("BANKFRAME_OPENED");
	this:RegisterEvent("PLAYERBANKSLOTS_CHANGED");
	this:RegisterEvent("BAG_UPDATE");
	this:RegisterEvent("UNIT_QUEST_LOG_CHANGED");
  
  if (akz_standalone == 0) then
	  this:RegisterEvent("LOOT_OPENED");
	  this:RegisterEvent("PLAYER_TARGET_CHANGED");
	  this:RegisterEvent("MERCHANT_UPDATE");
	  this:RegisterEvent("MERCHANT_SHOW");
	  this:RegisterEvent("AUCTION_ITEM_LIST_UPDATE");
		this:RegisterEvent("UNIT_SPELLCAST_SENT");
		this:RegisterEvent("UNIT_SPELLCAST_FAILED");
		this:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");

		this:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE");

		this:RegisterEvent("QUEST_PROGRESS");
		this:RegisterEvent("QUEST_COMPLETE");
		
		this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		this:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");

  	this:RegisterEvent("TRAINER_SHOW");
  end
  
  SLASH_WLOC1 = "/wloc";  -- /wloc command spits out the zone location of the player
  SlashCmdList["WLOC"] = function()
	  akz_PrintLoc("player");
	end
  SLASH_WVER1 = "/wver"; -- /wver shows the version of this file.  Used to verify load.
  SlashCmdList["WVER"] = function(self)
	  akz_ShowVersion(akz_WrVersion);
	end
  
  DEFAULT_CHAT_FRAME:AddMessage("WowReader Loaded");
end

function WrFrame_OnEvent()
--	DEFAULT_CHAT_FRAME:AddMessage(event);

  if (event == "TRAINER_SHOW") then
    if (IsTradeskillTrainer()) then
      akz_DoTradeskillTrainer();
    end
  end
  
  if (event == "UNIT_QUEST_LOG_CHANGED" and arg1 == "player") then
    akz_UpdateQuests();
  end
  
  if ( event == "QUEST_PROGRESS" ) then
		local qstr = getuqstr(GetTitleText());
    if (qstr) then
      if (not akz_quests[qstr]) then
        akz_quests[qstr] = {};
      end
			akz_quests[qstr]["progress"] = string.gsub(GetProgressText(), UnitName("player"), "<name>");
		end
  end

  if ( event == "QUEST_COMPLETE" ) then
		local qstr = getuqstr(GetTitleText());
    if (qstr) then
      if (not akz_quests[qstr]) then
        akz_quests[qstr] = {};
      end
			akz_quests[qstr]["complete"] = string.gsub(GetRewardText(), UnitName("player"), "<name>");
			akz_quests[qstr]["end"] = akz_GetMobID("NPC");
		end
	end
	  
  if ( event == "LOOT_OPENED" ) then
    akz_HandleLoot();
    return;
  end
  
  if (event == "UPDATE_WORLD_STATES") then
    local pname = UnitName("player");
    if ((pname == nil) or (pname == UNKNOWNOBJECT) or (pname == UKNOWNBEING)) then
    	return;
    else
      if ((akz_laststateupdate == 0) or ((GetTime() - 5) < akz_laststateupdate)) then
	    	akz_laststateupdate = GetTime();
	      akz_UpdatePlayerInfo();    
  	    akz_GetSkills();
    	  akz_UpdateInventory();
      	akz_UpdateHonor(1);
      end
    end
    return;
  end

  if ((event == "PLAYER_ENTERING_WORLD") or (event == "UNIT_NAME_UPDATE" and arg1 == 'player')) then
    local pname = UnitName("player");
    if ((pname == nil) or (pname == UNKNOWNOBJECT) or (pname == UKNOWNBEING)) then
      akz_inworld = 0;
    else
      local pkey = UnitName("player") .. "|" .. GetCVar("realmName");

      akz_inworld = 1;

      akz_profile2[pkey] = {};
      akz_UpdatePlayerInfo();    
      akz_GetSkills();
      akz_UpdateInventory();
      akz_UpdateHonor(1);
     	akz_profile2[pkey]["coin"] = GetMoney();
     	akz_kills = {};
      akz_lastzonetime = GetTime();
    end
    return;
  end
  
  if ( event == "UNIT_INVENTORY_CHANGED" ) then
    if ((akz_lastinvupdate == 0) or ((GetTime() - 10) < akz_lastinvupdate)) then
	    akz_lastinvupdate = GetTime();
  		akz_UpdateInventory();
    	akz_UpdatePlayerInfo();    
    end
   	return;
  end
    
  if ( event == "UNIT_LEVEL" ) then
    if ( arg1 == "player" ) then
       akz_UpdatePlayerInfo();
    end
    return;
  end

  if ( event == "PLAYER_GUILD_UPDATE" ) then
    if (akz_inworld == 1) then
      local pkey = UnitName("player") .. "|" .. GetCVar("realmName");
      if (akz_profile2[pkey]) then
        akz_profile2[pkey]["guild"], akz_profile2[pkey]["gtitle"], akz_profile2[pkey]["grank"] = GetGuildInfo("player");
      end
    end
    return;
  end

  if ( event == "PLAYER_LEAVING_WORLD" ) then
    akz_inworld = 0;
    return;
  end
  
  if ( event == "PLAYER_TARGET_CHANGED" ) then
    if (akz_inworld == 0) then
      return;
    end
    
    if ((akz_lastzonetime > 0) and ((GetTime() - 30) < akz_lastzonetime)) then
      return;
		end

    if ( UnitExists("target") ) then
      if ( not UnitIsPlayer("target") and not UnitIsDeadOrGhost("target") and not UnitPlayerControlled("target")) then
        local mobid = akz_GetMobID("target");
        if (mobid) then
	        local un = mobid .. "|" .. akz_GetInstanceDifficulty();
	        akz_AddCreature(un);
	        akz_AddLoc(un, akz_GetCurZoneLoc("player"));
	        akz_AddLevel(un, UnitLevel("target"));
	        akz_AddFaction(un);
	      end
      end
    end
    return;
  end
  
  if ( (event == "MERCHANT_UPDATE") or (event == "MERCHANT_SHOW") ) then
    akz_DoMerchant();
    return;
  end

  if ( (event == "SKILL_LINES_CHANGED") or (event == "CHARACTER_POINTS_CHANGED") ) then
    akz_GetSkills();
    akz_UpdateTalents();
    return;
  end

  if ( event == "UNIT_SPELLCAST_SENT" ) then
		if ( arg2 ) then
	    --DEFAULT_CHAT_FRAME:AddMessage("UNIT_SPELLCAST_SENT: arg1: " .. arg1 .. ",arg2: " .. arg2 .. ", arg3: " .. arg3 .. ", arg4: " .. arg4);
		  if ( arg2 == "Opening" or arg2 == "Opening - No Text" or arg2 == "Mining" or arg2 == "Herb Gathering") then
				akz_lastobject = arg4;
				akz_lastobjtime = GetTime();
			end
 		end
 		return;
  end

  if ( ((event == "UNIT_SPELLCAST_FAILED") or (event == "UNIT_SPELLCAST_INTERRUPTED")) and akz_lastobjtime > 0 ) then
		--DEFAULT_CHAT_FRAME:AddMessage("debug: canceling " .. akz_lastobject .. " at " .. akz_lastobjtime);
		akz_lastobject = "";
		akz_lastobjtime = 0;
		return;
  end

 
  if (event == "ZONE_CHANGED_NEW_AREA") then
    akz_lastzonetime = GetTime();
  end
  
  if ( (event == "AUCTION_ITEM_LIST_UPDATE") ) then
    akz_GetCurrentBids();
    return;
  end
  
  if ( event == "PLAYER_PVP_KILLS_CHANGED" or event == "PLAYER_PVP_RANK_CHANGED") then
    akz_UpdateHonor();
    return;
  end
  
  if ( event == "PLAYER_MONEY" ) then
    if (akz_inworld == 1) then
      local pkey = UnitName("player") .. "|" .. GetCVar("realmName");

      local cn = GetMoney();
      if ((cn > 0) and (cn < 100000000)) then
      	akz_profile2[pkey]["coin"] = GetMoney();
      else
      	akz_profile2[pkey]["coin"] = 0;
      end
    end
    return;
  end

	if ((event == "BANKFRAME_OPENED") or (event == "PLAYERBANKSLOTS_CHANGED" and arg1 == nil) or (event == "BAG_UPDATE" and arg1 >= 5 and arg1 <= 10)) then
		akz_UpdateBank()
	end
	
	if (event == "CHAT_MSG_COMBAT_FACTION_CHANGE") then
		if ((UnitRace("player") ~= "Human") and (GetLocale() == "enUS")) then
			local fd1 = "Reputation with (.-) decreased by (%d+)%."
			local fi1 = "Reputation with (.-) increased by (%d+)%."
			
			for faction,amount in string.gmatch(arg1, fd1) do
				akz_Faction(0, faction, amount);
			end
			for faction,amount in string.gmatch(arg1, fi1) do
				akz_Faction(1, faction, amount);
			end
		end
	end
	
	if (event == "CHAT_MSG_COMBAT_XP_GAIN") then
    local xp1 = "You gain (%d+) experience."
		for amount in string.gmatch(arg1, xp1) do
			akz_Exp(amount);
		end
	end
	
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
	  if (arg2 == "SPELL_CAST_START" or arg2 == "SPELL_CAST_SUCCESS") then
	    local filter = bit.bor(COMBATLOG_OBJECT_AFFILIATION_OUTSIDER, COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_NPC);
		  
		  if (bit.band(arg5, filter) == filter) then
				local un = tonumber(string.sub(arg3, 6, 12), 16) .. "|" .. akz_GetInstanceDifficulty();
				if (arg9) then
		      akz_AddCreature(un);
					akz_AddSpell(un, arg9);
				end
		  end
		end
	end
  
  if ( event == "VARIABLES_LOADED" ) then
    if (akz_uploaded == 1) then
      akz_creatures2 = {};
      akz_fishing = {};
      akz_objects = {};
      akz_prices = {};
      akz_profile2 = {};
			akz_quests = {};
      akz_uploaded = 0;
    end
		akz_merchant2 = {}; 
    akz_prices = {};
  end
end

-- look up quest in log by name and get level|name|desc string to identify it in an almost-always-unique way
function getuqstr(title)
  local pkey = UnitName("player") .. "|" .. GetCVar("realmName");

  for index,qstr in pairs(akz_profile2[pkey]["quests"]) do
		for level,name,desc in string.gmatch(qstr, "(.-)|(.-)|(.-)") do
			if (name == title) then
				return qstr;
			end
		end
	end
end

function akz_UCI(bag, slot, ...)
  if (not MerchantFrame:IsShown() and bag and slot) then
  	for i = 2, GameTooltip:NumLines() do
  		local text = getglobal("GameTooltipTextLeft" .. i):GetText();
  		if (text == ITEM_OPENABLE) then
				itemid = akz_GetItemInfoFromLink(GetContainerItemLink(bag, slot));
				akz_lastitem = itemid;
				akz_lastitemtime = GetTime();
				--DEFAULT_CHAT_FRAME:AddMessage("use item on: " .. akz_lastitem);
  		end
  	end
  end
end
hooksecurefunc("UseContainerItem", akz_UCI);

local akz_orig_GetQuestReward = GetQuestReward;
function akz_GetQuestReward(...)
	local target = UnitName("npc");
	local title = GetTitleText();
 	
 	if (title and target) then
 	  local qstr = getuqstr(title);
 	  if (qstr) then 
			akz_lastquest = qstr;
			akz_lastquestcompletetime = GetTime();
 	  end
	end
	
	akz_orig_GetQuestReward(...);
end
GetQuestReward = akz_GetQuestReward;

function akz_Exp(amount)
  if ( (GetTime() - 1 < akz_lastquestcompletetime) and (akz_lastquest ~= "") ) then
  	if (not akz_quests[akz_lastquest]) then
			akz_quests[akz_lastquest] = {};
		end
		
		akz_quests[akz_lastquest]["exp"] = amount;
	end
end

function akz_Faction(increase, faction, amount)
  if ( (GetTime() - 1 < akz_lastquestcompletetime) and (akz_lastquest ~= "") ) then
  	if (not akz_quests[akz_lastquest]) then
			akz_quests[akz_lastquest] = {};
		end
		if (not akz_quests[akz_lastquest]["faction"]) then
			akz_quests[akz_lastquest]["faction"] = {};
		end
		local fs = faction .. "|" .. amount .. "|";
		if (increase == 1) then
			fs = fs .. "+";
		else
			fs = fs .. "-";
		end
		
		table.insert(akz_quests[akz_lastquest]["faction"], fs);
	end
end

function akz_UpdatePlayerInfo()
  if (akz_inworld == 0) then
    return;
  end
  
  local pkey = UnitName("player") .. "|" .. GetCVar("realmName");

  akz_profile2[pkey]["race"] = UnitRace("player");
  akz_profile2[pkey]["race"] = UnitRace("player");
  akz_profile2[pkey]["class"] = UnitClass("player");
  akz_profile2[pkey]["level"] = UnitLevel("player");
  akz_profile2[pkey]["guild"],  akz_profile2[pkey]["gtitle"], akz_profile2[pkey]["grank"] = GetGuildInfo("player");
  akz_profile2[pkey]["talentpts"], akz_profile2[pkey]["skillpts"] = UnitCharacterPoints("player");
    
  akz_profile2[pkey]["str"] = akz_GetBaseStat(1);
  akz_profile2[pkey]["agi"] = akz_GetBaseStat(2);
  akz_profile2[pkey]["sta"] = akz_GetBaseStat(3);
  akz_profile2[pkey]["intel"] = akz_GetBaseStat(4);
  akz_profile2[pkey]["spirit"] = akz_GetBaseStat(5);
   
  akz_profile2[pkey]["arcane_resist"] = UnitResistance("player",6);
  akz_profile2[pkey]["fire_resist"] = UnitResistance("player",2);
  akz_profile2[pkey]["nature_resist"] = UnitResistance("player",3);
  akz_profile2[pkey]["frost_resist"] = UnitResistance("player",4);
  akz_profile2[pkey]["shadow_resist"] = UnitResistance("player",5);

  akz_profile2[pkey]["health2"] = akz_CalcBaseHp();
  akz_profile2[pkey]["mana2"] = akz_CalcBaseMana();
  akz_profile2[pkey]["attack"] = UnitAttackBothHands("player");

  local RangeSpeeed, RangeMinDMG,RangeMaxDMG = UnitRangedDamage("player");
  akz_profile2[pkey]["ranged_damage"] = max(floor(RangeMinDMG),1) .. ":" .. max(ceil(RangeMaxDMG),1);
  local base, pos, neg = UnitRangedAttackPower("player");
  akz_profile2[pkey]["ranged_power"] = base;
  local base, pos, neg = UnitRangedAttack("player");
  akz_profile2[pkey]["ranged"] = base;

  local minDamage;
  local maxDamage; 
  local minOffHandDamage;
  local maxOffHandDamage; 
  local physicalBonusPos;
  local physicalBonusNeg;
  local percent;
  
  minDamage, maxDamage, minOffHandDamage, maxOffHandDamage, physicalBonusPos, physicalBonusNeg, percent = UnitDamage("player");
    
  local baseDamage = (minDamage + maxDamage) * 0.5;
  local fullDamage = (baseDamage + physicalBonusPos + physicalBonusNeg) * percent;
  
  local totalBonus = (fullDamage - baseDamage);
  local displayMin = max(floor(minDamage + totalBonus),1);
  local displayMax = max(ceil(maxDamage + totalBonus),1);
  
  local baseArm, effectiveArmor, armor, positiveArm, negativeArm = UnitArmor("player");
  
  akz_profile2[pkey]["damagerange"] = displayMin .. ":" .. displayMax;
  akz_profile2[pkey]["atk_power"] = UnitAttackPower("player");
  akz_profile2[pkey]["defense"] = UnitDefense("player");
  akz_profile2[pkey]["armour"] = effectiveArmor;
  
  akz_UpdateTalents();
  akz_UpdateRepInfo();
  akz_UpdateQuests();
end

function akz_UpdateRepInfo()
  if (akz_inworld == 0) then
    return;
  end

  local pkey = UnitName("player") .. "|" .. GetCVar("realmName");
  akz_profile2[pkey]["rep"] = {};

  local numF = GetNumFactions();
  local collapsed = {};
  for i=1, numF, 1 do
    local  name, desc, standingColor, Min, Max, value, atWar, ToggleAtWar, isHeader, isCollapsed = GetFactionInfo(i);
    if (isCollapsed) then
      collapsed[name] = 1;
    end
  end
  ExpandFactionHeader(0);
  local numF = GetNumFactions();
  for i=1, numF, 1 do
    local  name, desc, standingColor, Min, Max, value, atWar, ToggleAtWar, isHeader, isCollapsed = GetFactionInfo(i);
    --    DEFAULT_CHAT_FRAME:AddMessage("Fac:" .. i .. " " .. name .. " : " .. value );
    if (name) then
      if ( isHeader ) then
        -- do nothing
      else
        if (atWar) then
        else       
          atWar = 0;
        end
			  table.insert(akz_profile2[pkey]["rep"], name .. ":" ..  value .. ":" .. atWar );
			  akz_factions[name] = 1;
      end
    end
  end
  for i=1, numF, 1 do
    local  name, desc, standingColor, Min, Max, value, atWar, ToggleAtWar, isHeader, isCollapsed = GetFactionInfo(i);
    if (collapsed[name]) then
      CollapseFactionHeader(i);
    end
  end
end

function akz_UpdateQuests()
  if (akz_inworld == 0) then
    return;
  end
--  DEFAULT_CHAT_FRAME:AddMessage("akz_UpdateQuests()");
  
  local pkey = UnitName("player") .. "|" .. GetCVar("realmName");
 	akz_profile2[pkey]["quests"] = {};

	local collapsed = {};
  local numEntries, numQuests = GetNumQuestLogEntries();
	for i=1, numEntries, 1 do
		local questLogTitleText, level, questTag, suggestedGroup, isHeader, isCollapsed = GetQuestLogTitle(i);
		if (isCollapsed) then
			collapsed[questLogTitleText] = 1;
		end
	end
	
	ExpandQuestHeader(0);

	numEntries, numQuests = GetNumQuestLogEntries();
	for i=1, numEntries, 1 do
		local questLogTitleText, level, questTag, suggestedGroup, isHeader, isCollapsed = GetQuestLogTitle(i);
		if (questLogTitleText and not isHeader) then
			SelectQuestLogEntry(i);
			local questDescription, questObjectives = GetQuestLogQuestText();

			if (questObjectives) then
				if (string.len(questObjectives) > 10) then
					table.insert(akz_profile2[pkey]["quests"], level .. "|" .. questLogTitleText .. "|" .. string.sub(questObjectives, 0, 10));
			  else
			  	table.insert(akz_profile2[pkey]["quests"], level .. "|" .. questLogTitleText .. "|" .. questObjectives);
			  end
		  end
		end
	end
	
	numEntries, numQuests = GetNumQuestLogEntries();
	for i=1, numEntries, 1 do
		local questLogTitleText, level, questTag, suggestedGroup, isHeader, isCollapsed = GetQuestLogTitle(i);
		if (collapsed[questLogTitleText]) then 
			CollapseQuestHeader(i);
		end
	end

end

function akz_UpdateHonor(updateAll)
  if (akz_inworld == 0) then
    return;
  end

  local pkey = UnitName("player") .. "|" .. GetCVar("realmName");

	akz_profile2[pkey]["l_hk"], akz_profile2[pkey]["l_highestRank"] = GetPVPLifetimeStats();
	akz_profile2[pkey]["w_hk"], akz_profile2[pkey]["t_honor"] = GetPVPSessionStats();
	akz_profile2[pkey]["y_hk"], akz_profile2[pkey]["y_honor"] = GetPVPYesterdayStats();

	akz_profile2[pkey]["honor"] = GetHonorCurrency();
	akz_profile2[pkey]["arena"] = GetArenaCurrency();
	
	akz_profile2[pkey]["h_rankname"], akz_profile2[pkey]["h_ranknum"] = GetPVPRankInfo(UnitPVPRank("player"));
	akz_profile2[pkey]["l_rankname"], akz_profile2[pkey]["l_ranknum"] = GetPVPRankInfo(akz_profile2[pkey]["l_highestRank"]);
end

function akz_UpdateTalents() 
  if (akz_inworld == 0) then
    return;
  end

  local pkey = UnitName("player") .. "|" .. GetCVar("realmName");

  akz_profile2[pkey]["talents"] = {};
  MAXTREES = 3;
  MAXPERTREE = 25;
  for i = 1, MAXTREES do
    akz_profile2[pkey]["talents"][i] = {};
    for j = 1, MAXPERTREE do
      local name, iconTexture, tier, column, rank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(i, j);
      if (name) then
         table.insert(akz_profile2[pkey]["talents"][i], rank);
      else 
         akz_profile2[pkey]["talents"][i][j] = nil;
      end
    end
  end
end

function akz_UpdateInventory()
  local itemid, enchant, subid, itemname, link,socket1,socket2,socket3,socket4;
  local bagid, numslots, slotid;
  local bagstr = "";

  if (akz_inworld == 0) then
    return;
  end

  local pkey = UnitName("player") .. "|" .. GetCVar("realmName");
  
  for index,slot in pairs(akz_slots) do
    link = GetInventoryItemLink("player", index)
    itemid, enchant,subid,itemnane,socket1,socket2,socket3,socket4 = akz_GetItemInfoFromLink(link);
    if (itemid) then
    	akz_profile2[pkey][slot] = itemid .. ":" .. subid .. ":" .. enchant .. ":" .. socket1 .. ":" ..socket2 .. ":" .. socket3 .. ":" .. socket4;
    else
    	akz_profile2[pkey][slot] = nil;
    end
  end
  
  
  for bbag = -3, 0, 1 do
    link = GetContainerItemLink(0, bbag);
    itemid, enchant, subid, itemnane,socket1,socket2,socket3,socket4 = akz_GetItemInfoFromLink(link);
    if (itemid) then
    	bagstr = bagstr .. itemid .. ":" .. subid .. ":" .. enchant .. ":1:" .. socket1 ..":".. socket2 ..":".. socket3 ..":".. socket4 .. ";";
    else
      bagstr = bagstr .. "0:0:0:0:0:0:0:0;";
    end
  end
  bagstr = bagstr .. "|";
  
  
  for bagid = 0, 4, 1 do
    numslots = GetContainerNumSlots(bagid);
    if (numslots) then
      for slotid = 1, numslots do
        link = GetContainerItemLink(bagid, slotid);
        itemid, enchant, subid, itemnane,socket1,socket2,socket3,socket4 = akz_GetItemInfoFromLink(link);
        if (itemid) then
          local texture, count, locked, quality, readable = GetContainerItemInfo(bagid, slotid);
					if ((not count) or (count < 1)) then
						count = 1;
					end
          bagstr = bagstr .. itemid .. ":" .. subid .. ":" .. enchant .. ":" .. count  ..":".. socket1  ..":".. socket2  ..":".. socket3 ..":".. socket4 .. ";";
        else
          bagstr = bagstr .. "0:0:0:0:0:0:0:0;";
        end
      end
    end
    bagstr = bagstr .. "|";
  end

  akz_profile2[pkey]["bags"] = bagstr;
end

function akz_UpdateBank()
	local numslots, link;
	local bagstr = "";
	
  if (akz_inworld == 0) then
    return;
  end
	if (not BankFrame:IsVisible()) then
		return;
	end

  local pkey = UnitName("player") .. "|" .. GetCVar("realmName");
  
  numslots = GetContainerNumSlots(BANK_CONTAINER);
  if (numslots) then
    for slotid = 1, numslots do
    	link = GetContainerItemLink(BANK_CONTAINER, slotid);
      itemid, enchant, subid, itemnane,socket1,socket2,socket3,socket4 = akz_GetItemInfoFromLink(link);
      if (itemid) then
        local texture, count, locked, quality, readable = GetContainerItemInfo(BANK_CONTAINER, slotid);
				if ((not count) or (count < 1)) then
					count = 1;
				end
        bagstr = bagstr .. itemid .. ":" .. subid .. ":" .. enchant .. ":" .. count  ..":".. socket1  ..":".. socket2  ..":".. socket3 ..":".. socket4 .. ";";
      else
        bagstr = bagstr .. "0:0:0:0:0:0:0:0;";
      end
		end  
  end
  bagstr = bagstr .. "|";
  
  for bagid = 5, 10 do
		numslots = GetContainerNumSlots(bagid);
	  if (numslots) then
	    for slotid = 1, numslots do
	    	link = GetContainerItemLink(bagid, slotid);
        itemid, enchant, subid, itemnane,socket1,socket2,socket3,socket4 = akz_GetItemInfoFromLink(link);
        if (itemid) then
	        local texture, count, locked, quality, readable = GetContainerItemInfo(bagid, slotid);
					if ((not count) or (count < 1)) then
						count = 1;
					end
	        bagstr = bagstr .. itemid .. ":" .. subid .. ":" .. enchant .. ":" .. count  ..":".. socket1  ..":".. socket2  ..":".. socket3 ..":".. socket4 .. ";";
	      else
	        bagstr = bagstr .. "0:0:0:0:0:0:0:0;";
	      end
			end  
	  end
    bagstr = bagstr .. "|";
  end

	akz_profile2[pkey]["bank"] = bagstr;
end

function akz_GetSkills ()
  if (akz_inworld == 0) then
    return;
  end

  local pkey = UnitName("player") .. "|" .. GetCVar("realmName");
  akz_profile2[pkey]["skills"] = {};
  for i = 1,GetNumSkillLines() ,1 do
    local skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType = GetSkillLineInfo(i);
    if (skillName) then
       table.insert(akz_profile2[pkey]["skills"],skillName .. "^" .. skillRank .. "^" .. skillMaxRank);
    else
       akz_profile2[pkey]["skills"][i] = nil;
    end
  end
end

function akz_AddCreature(name)
  if (not akz_creatures2[name]) then
    akz_creatures2[name] = { };
    akz_creatures2[name]["lvlmin"] = 0;
    akz_creatures2[name]["lvlmax"] = 0;
    akz_creatures2[name]["kills"] = 0;
  end
end

function akz_AddObject(name)
  if (not akz_objects[name]) then
    akz_objects[name] = { };
    akz_objects[name]["opened"] = 1;
  else
    akz_objects[name]["opened"] = akz_objects[name]["opened"] + 1;
  end
end

function akz_AddSpell(name, spellid)
  if (not akz_creatures2[name]) then
    return;
  end
  
  if (not akz_creatures2[name]["spells"]) then
    akz_creatures2[name]["spells"] = { };
  end
  for index,spell in pairs(akz_creatures2[name]["spells"]) do
    if (spellid==spell) then
      return;
    end
  end
	table.insert(akz_creatures2[name]["spells"], spellid);
end

function akz_AddLoc(name, thiszone, locx, locy)
  if (not akz_creatures2[name]) then
    return;
  end
  
  local tx, ty = akz_RoundLoc(locx, locy);
  if (((locx == 0) and (locy == 0)) or (thiszone == 0) or (thiszone == 1000) or (thiszone == 2000))  then
    local zt = GetZoneText();
    
    if (not zt) then
      return
    end
    
    if (not akz_creatures2[name]["instances"]) then
      akz_creatures2[name]["instances"] = { };
    end
    for index,inst in pairs(akz_creatures2[name]["instances"]) do
      if (inst==zt) then
        return;
      end
    end
    table.insert(akz_creatures2[name]["instances"], zt);
    return;
  end
  
  if (not akz_creatures2[name]["locs"]) then
    akz_creatures2[name]["locs"] = { };
  end
  
  for index,locinfo in pairs(akz_creatures2[name]["locs"]) do
    if ( (locinfo["zone"]==thiszone) and (locinfo["x"]==tx) and (locinfo["y"]==ty) ) then
      return;
    end
  end
  
  local addloc = { ["x"]=tx, ["y"]=ty, ["zone"]=thiszone };
  table.insert(akz_creatures2[name]["locs"], addloc);
end

function akz_AddObjLoc(name, thiszone, locx, locy)
  if (not akz_objects[name]) then
    return;
  end
  
  local tx, ty = akz_RoundLoc(locx, locy);
  if (((locx == 0) and (locy == 0)) or (thiszone == 0) or (thiszone == 1000) or (thiszone == 2000))  then
    local zt = GetZoneText();
    
    if (not zt) then
      return
    end
    
    if (not akz_objects[name]["instances"]) then
      akz_objects[name]["instances"] = { };
    end
    for index,inst in pairs(akz_objects[name]["instances"]) do
      if (inst==zt) then
        return;
      end
    end
    table.insert(akz_objects[name]["instances"], zt);
    return;
  end
  
  if (not akz_objects[name]["locs"]) then
    akz_objects[name]["locs"] = { };
  end
  
  for index,locinfo in pairs(akz_objects[name]["locs"]) do
    if ( (locinfo["zone"]==thiszone) and (locinfo["x"]==tx) and (locinfo["y"]==ty) ) then
      return;
    end
  end
  
  local addloc = { ["x"]=tx, ["y"]=ty, ["zone"]=thiszone };
  table.insert(akz_objects[name]["locs"], addloc);
end


function akz_AddObjLoot(name, itemid)
  if (not akz_objects[name]) then
    return;
  end

  if (not akz_objects[name]["items"]) then
    akz_objects[name]["items"] = { };
  end

  if (not akz_objects[name]["items"][itemid]) then
    akz_objects[name]["items"][itemid] = 1;
  else 
    akz_objects[name]["items"][itemid] = akz_objects[name]["items"][itemid] + 1;
  end
end

function akz_AddLevel(name, level)
  if (not akz_creatures2[name]) then
    return;
  end
  
  if (level > akz_creatures2[name]["lvlmax"]) then
    akz_creatures2[name]["lvlmax"] = level;
  end
  
  if ((level < akz_creatures2[name]["lvlmin"]) or (akz_creatures2[name]["lvlmin"] == 0)) then
    akz_creatures2[name]["lvlmin"] = level;
  end
end

function akz_AddFaction(name)
	GameTooltip:SetUnit("target");
	for i = 2, GameTooltip:NumLines() do
		local text = getglobal("GameTooltipTextLeft" .. i):GetText();
		if (akz_factions[text]) then
			akz_creatures2[name]["faction"] = text;
		end
	end
end

function akz_CheckKill(name, corpseguid)
  if (not akz_creatures2[name]) then
    return;
  end
  
  zn = GetZoneText();
  local thiskill = { ["guid"]=corpseguid };
  
  if (not akz_kills[name]) then
    akz_kills[name] = { };
    table.insert(akz_kills[name], thiskill);
    akz_creatures2[name]["kills"] = akz_creatures2[name]["kills"] + 1;
    return true;
  end

  for index,killinfo in pairs(akz_kills[name]) do
    if (killinfo["guid"]==corpseguid) then
      return false;
    end
  end

  table.insert(akz_kills[name], thiskill);
  akz_creatures2[name]["kills"] = akz_creatures2[name]["kills"] + 1;

  return true;
end

function akz_HandleLoot()
  local itemid;
  local enchant;
  local subid;
  local itemname;

  if (IsFishingLoot()) then
    for index = 1, GetNumLootItems(), 1 do
      if (LootSlotIsItem(index)) then
        itemid = akz_GetItemInfoFromLink(GetLootSlotLink(index));
        if (itemid) then
	        akz_AddFishLoot(GetMinimapZoneText(), itemid);
	      end
      end
    end
    return
  end

  if (not UnitName("target") and not UnitIsDead("target")) then
    if (GetTime() - 7 < akz_lastobjtime) then
    	if (akz_lastobject) then
	      akz_AddObject(akz_lastobject);
	      akz_AddObjLoc(akz_lastobject, akz_GetCurZoneLoc("player"));
	
	      for index = 1, GetNumLootItems(), 1 do
	        if (LootSlotIsItem(index)) then
	          itemid = akz_GetItemInfoFromLink(GetLootSlotLink(index));
	          if (itemid) then
	          	akz_AddObjLoot(akz_lastobject, itemid);
	          end
	        end
	      end
	    else
	    	akz_lastobject = "";
	    	akz_lastobjtime = 0;
			end
    end
    
    if (GetTime() - 5 < akz_lastitemtime) then
      if (akz_lastitem) then
	      akz_AddObject("item:" .. akz_lastitem);
	
	      for index = 1, GetNumLootItems(), 1 do
	        if (LootSlotIsItem(index)) then
	          itemid = akz_GetItemInfoFromLink(GetLootSlotLink(index));
	          if (itemid) then
	          	akz_AddObjLoot("item:" .. akz_lastitem, itemid);
	          end
	        end
	      end
      else
        akz_lastitem = "";
        akz_lastitemtime = 0;
      end
    end
  end

  if (not UnitName("target")) then
    return
  end

  if (not UnitIsDead("target")) then
    return
  end

  if (UnitIsPlayer("target")) then
    return
  end

  local mobid = akz_GetMobID("target");
  if (not mobid) then
    return
  end
  
	local corpseguid = UnitGUID("target");
	
	local un = mobid .. "|" .. akz_GetInstanceDifficulty();
  if (akz_CheckKill(un, corpseguid)) then
    for index = 1, GetNumLootItems(), 1 do
      if (LootSlotIsItem(index)) then
        itemid = akz_GetItemInfoFromLink(GetLootSlotLink(index));
        if (itemid) then
	        akz_AddLoot(un, itemid);
	      end
      end
    end
  end
end

function akz_GetInstanceDifficulty()
	local thiszone, locx, locy = akz_GetCurZoneLoc("player");
  if (((locx == 0) and (locy == 0)) or (thiszone == 0) or (thiszone == 1000) or (thiszone == 2000))  then
		return GetInstanceDifficulty();
	else
		return 1;
	end
end

function akz_AddFishLoot(fishzone, itemid)
  if (akz_fishing[fishzone]) then

	  for index,id in pairs(akz_fishing[fishzone]) do
      if (id == itemid) then
        return
      end
    end
    table.insert(akz_fishing[fishzone], itemid);
  else
    akz_fishing[fishzone] = {};
    table.insert(akz_fishing[fishzone], itemid);
  end
end

function akz_AddLoot(name, itemid)
  if (not akz_creatures2[name]) then
    return;
  end

  if (not akz_creatures2[name]["items"]) then
    akz_creatures2[name]["items"] = { };
  end

  if (not akz_creatures2[name]["items"][itemid]) then
    akz_creatures2[name]["items"][itemid] = 1;
  else 
    akz_creatures2[name]["items"][itemid] = akz_creatures2[name]["items"][itemid] + 1;
  end
end

function akz_DoMerchant()
	local itemid;
	local itab = {};
	local mname = akz_GetMobID("NPC");
	if (not mname) then
		return;
	end
	mname = tostring(mname);

	for index = 1, GetMerchantNumItems(), 1 do
		local mlink = GetMerchantItemLink(index);
		local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(index);
		local itemid = akz_GetItemInfoFromLink(mlink);

		if (itemid) then
			itab[itemid] = {};
			itab[itemid]["cnt"] = quantity ..":".. numAvailable;

			if (extendedCost) then
				local honorPoints, arenaPoints, itemCount = GetMerchantItemCostInfo(index);
				itab[itemid]["pts"] =  honorPoints .. ":" .. arenaPoints;
				itab[itemid]["icost"] = {};
				if (itemCount > 0 ) then
					for i =1 , itemCount, 1 do
						local itemTexture, itemValue, exlink = GetMerchantItemCostItem(index, i);
						local rid = 0;
						if (exlink) then
						  rid = akz_GetItemInfoFromLink(exlink);
						end
						table.insert(itab[itemid]["icost"],rid ..":" .. itemValue);
					end
				end
			end

			akz_merchant2[mname] = itab;
		end
	end
end 

-- debugging
function WrFrame_Show()
  local field = getglobal("WR_edit1");
  local text = "";

  if (field) then
--[[
    for zone,items in akz_fishing do
      for index,item in items do
        text = text .. string.format("\n fishing: %s - %d", zone, item);
      end
    end

    field:SetText(text);
    field:SetFocus();
]]--
  end
end


-- utils
function akz_GetItemInfoFromLink(link)
	if (link == nil) then
	  -- DEFAULT_CHAT_FRAME:AddMessage("nil link in akz_GetItemInfoFromLink");
	  return;
	end

  for itemid, enchant,socket1,socket2,socket3,socketbonus,subid,itemname in string.gmatch(link, "|c%x+|Hitem:(%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):(%-?%d+):%-?%d+:%d+|h%[(.+)%]|h|r") do
    return itemid, enchant, subid, itemname, socket1, socket2, socket3, socketbonus;
  end
end

function akz_RoundLoc(locx, locy)
  local x, y;
  x = string.format("%d", locx * 100);
  y = string.format("%d", locy * 100);
  x = x + 0;
  y = y + 0;
  return x, y;
end

function akz_GetBaseStat(i)
  local stat;
  local effectiveStat;
  local posBuff;
  local negBuff;
  stat, effectiveStat, posBuff, negBuff = UnitStat("player", i);
  return stat - posBuff - negBuff;
end

function akz_CalcBaseHp()
  local pkey = UnitName("player") .. "|" .. GetCVar("realmName");
  local stat, effectiveStat, posBuff, negBuff = UnitStat("player", 3); -- sta
  local bhp = UnitHealthMax("player");
  
  local stafrombuff = posBuff + negBuff;
  local hpfrombuff = stafrombuff * 10;
  
  if (UnitRace("player") == "Tauren") then  -- tauren racial 5% bonus
    hpfrombuff = string.format("%d", hpfrombuff * 1.05);
  end
   
  return bhp - hpfrombuff;
end

function akz_CalcBaseMana()
  local pkey = UnitName("player") .. "|" .. GetCVar("realmName");
  local stat, effectiveStat, posBuff, negBuff = UnitStat("player", 4); -- int
  local bm = UnitManaMax("player");
  
  local intfrombuff = posBuff + negBuff;
  local manafrombuff = intfrombuff * 15;
  
  if (UnitClass("player") == "Priest") then -- priest talent 2-10% bonus
    if (akz_profile2[pkey]["talents"]) then
      if (akz_profile2[pkey]["talents"][1][10]) then
        if (akz_profile2[pkey]["talents"][1][10] > 0) then
          manafrombuff = string.format("%d", manafrombuff * (((akz_profile2[pkey]["talents"][1][10] * 2) * 0.01) + 1));
        end
      end
    end
  end
  
  if (UnitClass("player") == "Shaman") then -- shaman 1-5% bonus
    if (akz_profile2[pkey]["talents"]) then
      if (akz_profile2[pkey]["talents"][2][1]) then
        if (akz_profile2[pkey]["talents"][2][1] > 0) then
          manafrombuff = string.format("%d", manafrombuff * ((akz_profile2[pkey]["talents"][2][1] * 0.01) + 1));
        end
      end
    end
  end
  
  return bm - manafrombuff;
end

function akz_GetCurZoneLoc(t)
  if (GetRealZoneText() == "Plaguelands: The Scarlet Enclave") then
    zone = 4099;
  elseif (GetRealZoneText() == "Icecrown") then
    zone = 4007;
  else
    SetMapToCurrentZone();
    local cont = GetCurrentMapContinent();
    local zone = GetCurrentMapZone();
    
    cont = cont * 1000;
    zone = zone + cont;
  end
  return zone, GetPlayerMapPosition(t);
end

function akz_PrintLoc (t)
   local x,y = GetPlayerMapPosition(t)
   x,y = akz_RoundLoc(x,y);
   if (x == 0 and y == 0) then
      DEFAULT_CHAT_FRAME:AddMessage("Unknown Position: 0,0");
   else
      DEFAULT_CHAT_FRAME:AddMessage("X: " .. x .. " Y:" .. y);
   end
end

function akz_ShowVersion(v)
   if (DEFAULT_CHAT_FRAME) then
      DEFAULT_CHAT_FRAME:AddMessage("WowReader version " .. v .. " loaded.");
   else 
      message("WowReader version "  .. v .. " loaded.");
   end
end

function akz_GetCurrentBids()
  local CurTime = GetTime();
  local price;
  
  if (CurTime - akz_lastauctionupdatetime < 2) then
    -- do nothing,  this prevents repeated calls to update
  else 
    akz_lastauctionupdatetime = CurTime;
    local MAX = 50;
    local numtoloop = 0;
    
    local numBatchAuctions, totalAuctions = GetNumAuctionItems("list");
    if (totalAuctions > MAX) then 
      numtoloop = MAX;
    else
      numtoloop = totalAuctions;
    end

    for i = 1, numtoloop  do
      local name, texture, count, quality, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highBidder =  GetAuctionItemInfo("list",i);
      local itemid,enchant,subid,itemname;
      if (name and (buyoutPrice > 0)) then
      	local itemid,enchant,subid,itemnane,socket1,socket2,socket3,socket4 = akz_GetItemInfoFromLink(GetAuctionItemLink("list",i));
      	if (itemid) then
	        local item = itemid .. ":" .. subid;
	        if (count > 1) then
	          price = string.format("%d", buyoutPrice / count);
	        else 
	          price = string.format("%d", buyoutPrice);
	        end
	        akz_prices[item] = {};
	      	table.insert(akz_prices[item],price);
	      end
      end 
    end
  end 
end


function akz_GetMobID(unit)
  local targetguid = UnitGUID(unit);
  if (targetguid) then
	  if (bit.band(tonumber(string.sub(targetguid, 3, 6), 16), 0x30) == 0x30) then
	    return tonumber(string.sub(targetguid, 6, 12), 16);
		end
	end
end

function akz_DoTradeskillTrainer()
  local mobid = akz_GetMobID("npc");
  local un = mobid .. "|" .. akz_GetInstanceDifficulty();
  if (not akz_creatures2[un]) then
    return;
  end

  akz_creatures2[un]["ts"] = {};
  
  local i, name, rank, category;
  for i=1,GetNumTrainerServices() do
    name, rank, category = GetTrainerServiceInfo(i);
    if (name == nil) then
      break;
    end
    rank = rank or "";
    
    if (category == "available" or category == "unavailable" or category == "used") then
      local reqLevel = GetTrainerServiceLevelReq(i);
      local skill, srank = GetTrainerServiceSkillReq(i);

      reqLevel = reqLevel or 0;
      skill = skill or "";
      srank = srank or 0;
            
      local trstr = name .. ":" .. rank .. ":" .. reqLevel .. ":" .. skill .. ":" .. srank;

      table.insert(akz_creatures2[un]["ts"], trstr);
    end
  end
end
