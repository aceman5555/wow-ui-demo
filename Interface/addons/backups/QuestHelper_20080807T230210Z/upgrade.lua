QuestHelper_File = {}
QuestHelper_File["upgrade.lua"] = "0.47.19-abc40e6"

QuestHelper_Zones =
  {{[0]="Kalimdor",
    [1]="Ashenvale",
    [2]="Azshara",
    [3]="Azuremyst Isle",
    [4]="Bloodmyst Isle",
    [5]="Darkshore",
    [6]="Darnassus",
    [7]="Desolace",
    [8]="Durotar",
    [9]="Dustwallow Marsh",
    [10]="Felwood",
    [11]="Feralas",
    [12]="Moonglade",
    [13]="Mulgore",
    [14]="Orgrimmar",
    [15]="Silithus",
    [16]="Stonetalon Mountains",
    [17]="Tanaris",
    [18]="Teldrassil",
    [19]="The Barrens",
    [20]="The Exodar",
    [21]="Thousand Needles",
    [22]="Thunder Bluff",
    [23]="Un'Goro Crater",
    [24]="Winterspring"},
   {[0]="Eastern Kingdoms",
    [1]="Alterac Mountains",
    [2]="Arathi Highlands",
    [3]="Badlands",
    [4]="Blasted Lands",
    [5]="Burning Steppes",
    [6]="Deadwind Pass",
    [7]="Dun Morogh",
    [8]="Duskwood",
    [9]="Eastern Plaguelands",
    [10]="Elwynn Forest",
    [11]="Eversong Woods",
    [12]="Ghostlands",
    [13]="Hillsbrad Foothills",
    [14]="Ironforge",
    [15]="Isle of Quel'Danas",
    [16]="Loch Modan",
    [17]="Redridge Mountains",
    [18]="Searing Gorge",
    [19]="Silvermoon City",
    [20]="Silverpine Forest",
    [21]="Stormwind City",
    [22]="Stranglethorn Vale",
    [23]="Swamp of Sorrows",
    [24]="The Hinterlands",
    [25]="Tirisfal Glades",
    [26]="Undercity",
    [27]="Western Plaguelands",
    [28]="Westfall",
    [29]="Wetlands"},
   {[0]="Outland",
    [1]="Blade's Edge Mountains",
    [2]="Hellfire Peninsula",
    [3]="Nagrand",
    [4]="Netherstorm",
    [5]="Shadowmoon Valley",
    [6]="Shattrath City",
    [7]="Terokkar Forest",
    [8]="Zangarmarsh"}}

-- This will be translated to [LOCALE_NAME] = INDEX by QuestHelper_BuildZoneLookup.
-- Additionally, [CONT_INDEX][ZONE_INDEX] = INDEX will also be added.
QuestHelper_IndexLookup =
 {["Hinterlands"] = {42, 2, 24},
  ["Moonglade"] = {20, 1, 12},
  ["ThousandNeedles"] = {14, 1, 21},
  ["Winterspring"] = {19, 1, 24},
  ["BloodmystIsle"] = {9, 1, 4},
  ["TerokkarForest"] = {55, 3, 7},
  ["Arathi"] = {39, 2, 2},
  ["EversongWoods"] = {41, 2, 11},
  ["Dustwallow"] = {10, 1, 9},
  ["Badlands"] = {27, 2, 3},
  ["Darkshore"] = {16, 1, 5},
  ["Ogrimmar"] = {1, 1, 14},
  ["BladesEdgeMountains"] = {54, 3, 1},
  ["Undercity"] = {45, 2, 26},
  ["Desolace"] = {4, 1, 7},
  ["Netherstorm"] = {59, 3, 4},
  ["Barrens"] = {11, 1, 19},
  ["Tanaris"] = {8, 1, 17},
  ["Stormwind"] = {36, 2, 21},
  ["Zangarmarsh"] = {57, 3, 8},
  ["Durotar"] = {7, 1, 8},
  ["Hellfire"] = {56, 3, 2},
  ["Silithus"] = {5, 1, 15},
  ["ShattrathCity"] = {60, 3, 6},
  ["ShadowmoonValley"] = {53, 3, 5},
  ["SwampOfSorrows"] = {46, 2, 23},
  ["SilvermoonCity"] = {52, 2, 19},
  ["Darnassis"] = {21, 1, 6},
  ["AzuremystIsle"] = {3, 1, 3},
  ["Elwynn"] = {37, 2, 10},
  ["Stranglethorn"] = {38, 2, 22},
  ["EasternPlaguelands"] = {34, 2, 9},
  ["Duskwood"] = {31, 2, 8},
  ["WesternPlaguelands"] = {50, 2, 27},
  ["Westfall"] = {49, 2, 28},
  ["Ashenvale"] = {2, 1, 1},
  ["Teldrassil"] = {24, 1, 18},
  ["Redridge"] = {30, 2, 17},
  ["UngoroCrater"] = {18, 1, 23},
  ["Mulgore"] = {22, 1, 13},
  ["Ironforge"] = {25, 2, 14},
  ["Felwood"] = {13, 1, 10},
  ["Hilsbrad"] = {48, 2, 13},
  ["DeadwindPass"] = {47, 2, 6},
  ["BurningSteppes"] = {40, 2, 5},
  ["Ghostlands"] = {44, 2, 12},
  ["Tirisfal"] = {43, 2, 25},
  ["TheExodar"] = {12, 1, 20},
  ["Wetlands"] = {51, 2, 29},
  ["SearingGorge"] = {32, 2, 18},
  ["BlastedLands"] = {33, 2, 4},
  ["Silverpine"] = {35, 2, 20},
  ["LochModan"] = {29, 2, 16},
  ["Feralas"] = {17, 1, 11},
  ["DunMorogh"] = {28, 2, 7},
  ["Alterac"] = {26, 2, 1},
  ["ThunderBluff"] = {23, 1, 22},
  ["Aszhara"] = {15, 1, 2},
  ["StonetalonMountains"] = {6, 1, 16},
  ["Nagrand"] = {58, 3, 3},
  ["Kalimdor"] = {61, 1, 0},
  ["Azeroth"] = {62, 2, 0},
  ["Expansion01"] = {63, 3, 0},
  ["Sunwell"] = {64, 2, 15}}

local next_index = 1
for i, j in pairs(QuestHelper_IndexLookup) do next_index = math.max(next_index, j[1]+1) end

-- Maps zone names and indexes to a two element array, containing zone index a continent/zone
QuestHelper_ZoneLookup = {}

-- Maps indexes to zone names.
QuestHelper_NameLookup = {}

local built = false

function QuestHelper_BuildZoneLookup()
  if built then return end
  built = true
  
  if GetMapContinents and GetMapZones then
    -- Called from inside the WoW client.
    
    local original_lookup, original_zones = QuestHelper_IndexLookup, QuestHelper_Zones
    QuestHelper_IndexLookup = {}
    QuestHelper_Zones = {}
    
    for c, cname in pairs({GetMapContinents()}) do
      QuestHelper_Zones[c] = {}
      for z, zname in pairs({[0] = cname, GetMapZones(c)}) do
        SetMapZoom(c, z)
        local base_name = GetMapInfo()
        
        local index = original_lookup[base_name] and original_lookup[base_name][1]
        
        local altered_index = "!!! QuestHelper_IndexLookup entry needs update: [%q] = {%s, %s, %s}"
        local altered_zone = "!!! QuestHelper_Zones entry needs update: [%s][%s] = %q -- was %s"
        
        if not index then
          QuestHelper:TextOut(altered_index:format(base_name, next_index, c, z))
          next_index = next_index + 1
        else
          if QuestHelper_Locale == "enUS" then
            if original_lookup[base_name][2] ~= c or original_lookup[base_name][3] ~= z then
              QuestHelper:TextOut(altered_index:format(base_name, index, c, z))
            end
            
            if original_zones[c][z] ~= zname then
              QuestHelper:TextOut(altered_zone:format(c, z, zname, original_zones[c][z] or "missing"))
            end
          end
          
          local pair = {c, z}
          if not QuestHelper_IndexLookup[c] then QuestHelper_IndexLookup[c] = {} end
          QuestHelper_IndexLookup[c][z] = index
          QuestHelper_IndexLookup[zname] = index
          
          QuestHelper_NameLookup[index] = zname
          
          QuestHelper_ZoneLookup[zname] = pair
          QuestHelper_ZoneLookup[index] = pair
          
          QuestHelper_Zones[c][z] = zname
        end
      end
    end
  else
    -- Called from some lua script.
    local original_lookup = QuestHelper_IndexLookup
    QuestHelper_IndexLookup = {}
    
    for base_name, i in pairs(original_lookup) do
      local index = i[1]
      local pair = {i[2], i[3]}
      local name = QuestHelper_Zones[pair[1]][pair[2]]
      
      --[[ assert(index and name) ]]
      
      if not QuestHelper_IndexLookup[pair[1]] then QuestHelper_IndexLookup[pair[1]] = {} end
      QuestHelper_IndexLookup[pair[1]][pair[2]] = index
      QuestHelper_IndexLookup[name] = index
      
      QuestHelper_NameLookup[index] = name
      
      QuestHelper_ZoneLookup[name] = pair
      QuestHelper_ZoneLookup[index] = pair
    end
  end
end

local convert_lookup =
 {{2, 15, 3, 9, 16, 21, 4, 7, 10, 13, 17, 20, 22, 1, 5, 6, 8, 24, 11, 12, 14, 23, 18, 19},
  {26, 39, 27, 33, 40, 47, 28, 31, 34, 37, 41, 44, 48, 25, 29, 30, 32, 52, 35, 36, 38, 46, 42, 43, 45, 50, 49, 51},
  {54, 56, 58, 59, 53, 60, 55, 57}}

function QuestHelper_ValidPosition(c, z, x, y)
  return type(x) == "number" and type(y) == "number" and x > -0.1 and y > -0.1 and x < 1.1 and y < 1.1 and c and convert_lookup[c] and z and convert_lookup[c][z] and true
end

function QuestHelper_PrunePositionList(list)
  if type(list) ~= "table" then
    return nil
  end
  
  local i = 1
  while i <= #list do
    local pos = list[i]
    if QuestHelper_ValidPosition(unpack(list[i])) and type(pos[5]) == "number" and pos[5] >= 1 then
      i = i + 1
    else
      local rem = table.remove(list, i)
    end
  end
  
  return #list > 0 and list or nil
end

local function QuestHelper_ConvertPosition(pos)
  pos[2] = convert_lookup[pos[1]][pos[2]]
  table.remove(pos, 1)
end

local function QuestHelper_ConvertPositionList(list)
  if list then
    for i, pos in pairs(list) do
      QuestHelper_ConvertPosition(pos)
    end
  end
end

local function QuestHelper_ConvertFaction(locale, faction)
  if faction == 1 or faction == "Alliance" or faction == FACTION_ALLIANCE then return 1
  elseif faction == 2 or faction == "Horde" or faction == FACTION_HORDE then return 2
  else
    if locale == "enUS" then
      if faction == "Alliance" then return 1
      elseif faction == "Horde" then return 2 end
    elseif locale == "frFR" then
      if faction == "Alliance" then return 1
      elseif faction == "Horde" then return 2 end
    elseif locale == "deDE" then
      if faction == "Alliance" then return 1
      elseif faction == "Horde" then return 2 end
    end
    
    --[[ assert(false, "Unknown faction: "..locale.."/'"..faction.."'") ]]
  end
end

function QuestHelper_UpgradeDatabase(data)
  if data.QuestHelper_SaveVersion == 1 then
    
    -- Reputation objectives weren't parsed correctly before.
    if data.QuestHelper_Objectives["reputation"] then
      for faction, objective in pairs(data.QuestHelper_Objectives["reputation"]) do
        local real_faction = string.find(faction, "%s*(.+)%s*:%s*") or faction
        if faction ~= real_faction then
          data.QuestHelper_Objectives["reputation"][real_faction] = data.QuestHelper_Objectives["reputation"][faction]
          data.QuestHelper_Objectives["reputation"][faction] = nil
        end
      end
    end
    
    -- Items that wern't in the local cache when I read the quest log ended up with empty names.
    if data.QuestHelper_Objectives["item"] then
      data.QuestHelper_Objectives["item"][" "] = nil
    end
    
    data.QuestHelper_SaveVersion = 2
  end
  
  if data.QuestHelper_SaveVersion == 2 then
    
    -- The hashes for the quests were wrong. Damnit!
    for faction, level_list in pairs(data.QuestHelper_Quests) do
      for level, quest_list in pairs(level_list) do
        for quest_name, quest_data in pairs(quest_list) do
          quest_data.hash = nil
          quest_data.alt = nil
        end
      end
    end
    
    -- None of the information I collected about quest items previously can be trusted.
    -- I also didn't properly mark quest items as such, so I'll have to remove the information for non
    -- quest items also.
    
    if data.QuestHelper_Objectives["item"] then
      for item, item_data in pairs(data.QuestHelper_Objectives["item"]) do
        -- I'll remerge the bad data later if I find out its not used solely for quests.
        item_data.bad_pos = item_data.bad_pos or item_data.pos
        item_data.bad_drop = item_data.bad_drop or item_data.drop
        item_data.pos = nil
        item_data.drop = nil
        
        -- In the future i'll delete the bad_x data.
        -- When I do, either just delete it, or of all the monsters or positions match the monsters and positions of the
        -- quest, merge them into that.
      end
    end
    
    data.QuestHelper_SaveVersion = 3
  end
  
  if data.QuestHelper_SaveVersion == 3 then
    -- We'll go through this and make sure all the position lists are correct.
    for faction, level_list in pairs(data.QuestHelper_Quests) do
      for level, quest_list in pairs(level_list) do
        for quest_name, quest_data in pairs(quest_list) do
          quest_data.pos = QuestHelper_PrunePositionList(quest_data.pos)
          if quest_data.item then for name, data in pairs(quest_data.item) do
            data.pos = QuestHelper_PrunePositionList(data.pos)
          end end
          if quest_data.alt then for hash, data in pairs(quest_data.alt) do
            data.pos = QuestHelper_PrunePositionList(data.pos)
            if data.item then for name, data in pairs(data.item) do
              data.pos = QuestHelper_PrunePositionList(data.pos)
            end end
          end end
        end
      end
    end
    
    for cat, list in pairs(data.QuestHelper_Objectives) do
      for name, data in pairs(list) do
        data.pos = QuestHelper_PrunePositionList(data.pos)
      end
    end
    
    if data.QuestHelper_ZoneTransition then
      for c, z1list in pairs(data.QuestHelper_ZoneTransition) do
        for z1, z2list in pairs(z1list) do
          for z2, poslist in pairs(z2list) do
            z2list[z2] = QuestHelper_PrunePositionList(poslist)
          end
        end
      end
    end
    
    data.QuestHelper_SaveVersion = 4
  end
  
  if data.QuestHelper_SaveVersion == 4 then
    -- Zone transitions have been obsoleted by a bug.
    data.QuestHelper_ZoneTransition = nil
    data.QuestHelper_SaveVersion = 5
  end
  
  if data.QuestHelper_SaveVersion == 5 then
    -- For version 6, I'm converting area positions from a continent/zone index pair to a single index.
    
    if data.QuestHelper_FlightRoutes then
      local old_routes = data.QuestHelper_FlightRoutes
      data.QuestHelper_FlightRoutes = {}
      for c, value in pairs(old_routes) do
        data.QuestHelper_FlightRoutes[QuestHelper_IndexLookup[c][0]] = value
      end
    end
    
    for faction, level_list in pairs(data.QuestHelper_Quests) do
      for level, quest_list in pairs(level_list) do
        for quest_name, quest_data in pairs(quest_list) do
          QuestHelper_ConvertPositionList(quest_data.pos)
          if quest_data.item then for name, data in pairs(quest_data.item) do
            QuestHelper_ConvertPositionList(data.pos)
          end end
          if quest_data.alt then for hash, data in pairs(quest_data.alt) do
            QuestHelper_ConvertPositionList(data.pos)
            if data.item then for name, data in pairs(data.item) do
              QuestHelper_ConvertPositionList(data.pos)
            end end
          end end
        end
      end
    end
    
    for cat, list in pairs(data.QuestHelper_Objectives) do
      for name, data in pairs(list) do
        QuestHelper_ConvertPositionList(data.pos)
      end
    end
    
    data.QuestHelper_SaveVersion = 6
  end
  
  if data.QuestHelper_SaveVersion == 6 then
    -- Redoing how flightpaths work, previously collected flightpath data is now obsolete.
    data.QuestHelper_FlightRoutes = {}
    
    -- FlightInstructors table should be fine, will leave it.
    -- Upgrading per-character data is handled in main.lua.
    
    -- Also converting factions to numbers, 1 for Alliance, 2 for Horde.
    local replacement = {}
    for faction, dat in pairs(data.QuestHelper_Quests) do
      replacement[QuestHelper_ConvertFaction(data.QuestHelper_Locale, faction)] = dat
    end
    data.QuestHelper_Quests = replacement
    
    replacement = {}
    if data.QuestHelper_FlightInstructors then for faction, dat in pairs(data.QuestHelper_FlightInstructors) do
      replacement[QuestHelper_ConvertFaction(data.QuestHelper_Locale, faction)] = dat
    end end
    data.QuestHelper_FlightInstructors = replacement
    
    for cat, list in pairs(data.QuestHelper_Objectives) do
      for name, obj in pairs(list) do
        if obj.faction then
          obj.faction = QuestHelper_ConvertFaction(data.QuestHelper_Locale, obj.faction)
        end
      end
    end
    
    data.QuestHelper_SaveVersion = 7
  end
  
  if data.QuestHelper_SaveVersion == 7 then
    -- It sure took me long enough to discover that I broke vendor objectives.
    -- their factions were strings and didn't match the number value of QuestHelper.faction
    
    for cat, list in pairs(data.QuestHelper_Objectives) do
      for name, obj in pairs(list) do
        if type(obj.faction) == "string" then
          obj.faction = (obj.faction == "Alliance" and 1) or (obj.faction == "Horde" and 2) or nil
        end
      end
    end
    
    data.QuestHelper_SaveVersion = 8
  end
end

function QuestHelper_UpgradeComplete()
  -- This function deletes everything related to upgrading, as it isn't going to be needed again.
  built = nil
  next_index = nil
  convert_lookup = nil
  QuestHelper_BuildZoneLookup = nil
  QuestHelper_ValidPosition = nil
  QuestHelper_PrunePositionList = nil
  QuestHelper_ConvertPosition = nil
  QuestHelper_ConvertPositionList = nil
  QuestHelper_ConvertFaction = nil
  QuestHelper_UpgradeDatabase = nil
  QuestHelper_UpgradeComplete = nil
end