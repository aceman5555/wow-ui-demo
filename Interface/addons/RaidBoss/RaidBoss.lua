------------------------------------------------
-- user configuration                        ---
------------------------------------------------
local texture = [[Interface\TargetingFrame\UI-StatusBar]] -- for bars


------------------------------------------------
-- end of user configuration section         ---
------------------------------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("RaidBoss")
local candy = LibStub("LibCandyBar-3.0")
local talents = LibStub("LibGroupTalents-1.0")
local configboss = LibStub("LibConfigBoss-1.0")
local media = LibStub("LibSharedMedia-3.0")
local c = RaidBoss.constants;
local specs = RaidBoss.constants.specs;
local start = RaidBoss.constants.start;
local finish = RaidBoss.constants.finish;
local spells = RaidBoss.constants.spells
local groups = RaidBoss.constants.groups;
local db;
local dbpc
local localclasses = {}
local skins = {}

local activebars = {}
local activeanchor = {}
local available = {}
-- cooldowns[playername][spellid] = { lastused, available, cooldown }
local cooldowns = {}
local sortedcooldowns = {} -- xref to cooldowns
local GetTime = GetTime

------------------------------------------------
-- build tables                              ---
------------------------------------------------

for k,v in pairs(spells) do
	-- icons and names
	local name, _, icon = GetSpellInfo(k)
	if(not v.name) then -- allow a custom name
		v.name = name;
	end
	if(not v.icon) then -- allow custom icon
		v.icon = icon;
	end
	v.id = k;
	
	-- localise talent names
	if(v.talents) then
		for tid, t in pairs(v.talents) do
			local name = GetSpellInfo(tid);
			if(not t.name) then
				t.name = name;
			end
		end
	end
	
	if(v.glyphs) then
		for gid, g in pairs(v.glyphs) do
			local name = GetSpellInfo(gid)
			if(not g.name) then
				g.name = name
			end
		end
	end
	
	if(v.thetalent) then
		local name = GetSpellInfo(v.thetalent);
		v.thetalentname = name;
	end
	
	-- start and end tables
	
	if(v.start) then 
		if(not start[v.start]) then start[v.start] = {}; end
		start[v.start][k] = v; 
	end
	if(v.finish) then 
		if(not finish[v.finish]) then finish[v.finish] = {}; end
		finish[v.finish][k] = v; 		
	end
	
	
	
end

FillLocalizedClassList(localclasses, false)

-----------------------------------------------
-- bar management                            ---
------------------------------------------------

local function sortBars()
	local refs = {}
	for k,v in pairs(activebars) do
		if(v.expires <= GetTime()) then
			activebars[k] = nil;
		else
			table.insert(refs, {expires = v.expires, key=k});
		end
	end
	table.sort(refs, function(a,b) return a.expires < b.expires end );
	for i=1,getn(refs) do
		local bar = activebars[refs[i].key].bar;
		if(bar) then
			bar:SetPoint("TOP", activeanchor.frame, "BOTTOM", 0, -db.activebarheight*(i-1))
		else
			activebars[refs[i].key] = nil
		end		
		i = i + 1
	end
	refs = nil;
end

------------------------------------------------
-- get cooldown helpers                      ---
------------------------------------------------

-- unpack a color
local function ucolor(c)
	return c.r, c.g, c.b, c.a
end

function formatTime(seconds)

	local minpart = math.floor(seconds/60)
	local secondpart = math.floor(seconds-minpart*60)	
	if secondpart < 10 and minpart > 0 then
		secondpart = "0" .. secondpart
	end
	if minpart > 0 then
		minpart = minpart .. ":"
	else
		minpart = ""
	end

	return minpart .. secondpart


end

-- return the cooldown if available, nil if not available
local function getCooldown(spell, unitName) 

	local cd = spell.cd;
	
	-- check talent availability
	if(spell.talentrequired) then
		local thename = spell.thetalentname or spell.name			
		local points = talents:UnitHasTalent(unitName, thename);
		if(not points or points==0) then
			return nil;
		end
	end
	
	-- check spell role requirement
	if(spell.rolerequired) then
		if(talents:GetUnitRole(unitName) ~= spell.rolerequired) then
			return nil
		end
	end
	
	-- talents to reduce cooldown
	if(spell.talents) then
		for k,v in pairs(spell.talents) do
			local points = talents:UnitHasTalent(unitName, v.name)
			if( points and points > 0 ) then
				if(v.flatreduction) then
					cd = cd - (v.flatreduction * points)
				end
				if(v.percentreduction) then			
					cd = cd * (1 - (v.percentreduction * points));
				end
			end
		end
	end
	
	-- glyph to reduce cooldown
	if(spell.glyphs) then
		for k,v in pairs(spell.glyphs) do
			if(talents:UnitHasGlyph(unitName, v.name)) then
				if(v.flatreduction) then
					cd = cd - (v.flatreduction)
				end
				if(v.percentreduction) then			
					cd = cd * (1 - (v.percentreduction));
				end
			end
		end
	end
	
	return cd;

end


------------------------------------------------
-- available cooldown display                ---
------------------------------------------------

local function getMastery(unit)
	local _, t1, t2, t3 = talents:GetUnitTalentSpec(unit);
	if(not t1 and not t2 and not t3) then
		return nil
	end
	if(t1 > t2) then
		if(t1 > t3) then
			return 1;
		else
			return 3
		end
	else
		if(t2 > t3) then
			return 2
		else
			return 3
		end
	end
			
end

local function getNumGroupMembers() 
	local raidN = GetNumRaidMembers();
	local partyN = GetNumPartyMembers();
	if(raidN > 0) then
		return raidN;
	elseif(partyN > 0) then
		return partyN+1;
	else
		return 1
	end
end

-- generic get unit info for solo/party/raid
local function getGroupUnitInfo(index)
	local raidN = GetNumRaidMembers();
	local partyN = GetNumPartyMembers()
	local doReturnSelf = false;
	if(raidN > 0) then
		local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(index);
		return name, class, online, isDead, subgroup;
	elseif(partyN > 0) then
		if(index==1) then
			doReturnSelf = true;
		else
			local unitid = "party" .. (index-1);
			local name = UnitName(unitid);
			local class = UnitClass(unitid);
			local online = UnitExists(unitid)
			local isDead = UnitIsDeadOrGhost(unitid);
			return name, class, online, isDead, 1
		end
	else
		doReturnSelf=true;
	end	
	if(doReturnSelf) then
		local name = UnitName("player");
		local class = UnitClass("player");
		local online = true;
		local isDead = UnitIsDeadOrGhost("player");
		return name, class, online, isDead, 1
	end
end


local function getInstanceTypeString()
	local type = "";
    local name, instanceType, difficulty, _, maxPlayers = GetInstanceInfo()
    if(instanceType == "none") then 
    	return "solo";
    elseif(instanceType == "party") then
    	return "party"
    elseif(instanceType == "pvp") then
    	return "pvp" .. maxPlayers;
	elseif(instanceType == "raid") then    
	    if IsPartyLFG() and IsInLFGDungeon() and instanceType == "raid" and maxPlayers == 25 then
	         type = "lfr"
	    elseif difficulty == 3 or difficulty == 4 then
	        type = "heroic"
	    end
	    return "raid" .. maxPlayers .. type
	end
	return "unknown"    
end

local function updateRoster()
	local total = getNumGroupMembers();
	if(total == 1) then -- clear when leaving party
		local count = 0;
		for k,v in pairs(cooldowns) do
			count = count + 1
		end
		if(count > 1) then
			cooldowns = {};
			sortedcooldowns = {}
		end
	end
	for k,v in pairs(cooldowns) do -- disable availability by default todo: this is an ugly way of achieving what i want
		for k2,v2 in pairs(v) do
			if(v2.available) then
				v2.available = false;
			end
		end
	end
	for i=1, total do
		local name, class, online, isDead, subgroup = getGroupUnitInfo(i);
		if(name and (db.subgroups["group"..subgroup] == 1)) then
			if(not cooldowns[name]) then
				cooldowns[name] = {}
				cooldowns[name].name = name;
			end
			local _, classnolocale = UnitClass(name);
			local mastery = getMastery(name);
			local icons = {}
			icons[1], icons[2], icons[3] = talents:GetTreeIcons(classnolocale);
			cooldowns[name].classicon = icons[mastery];
			for k,v in pairs(spells) do
				if(v.class == classnolocale and dbpc.spellvisibility[v.id] == 1) then
					local cd = getCooldown(v, name);
					local available
					if(not cd or isDead or (not online)) then
						available = false
					else
						available = true;
					end
					if(not cooldowns[name][v.id]) then
						cooldowns[name][v.id] = {lastused=-999999, available=available, cd=cd};
						table.insert(sortedcooldowns, {root=cooldowns[name] ,spellid = v.id,info=cooldowns[name][v.id] }); -- using a ref here, so should stay up to date!
					else
						cooldowns[name][v.id].available = available;
						cooldowns[name][v.id].cd = cd;
					end				
				end
			end
		end
	end
	
	table.sort(sortedcooldowns, function (a,b)
		if(a.spellid < b.spellid) then
			return true;
		elseif(a.spellid == b.spellid) then
			return a.root.name < b.root.name;
		else
			return false
		end
	end)
	
end

local function talentUpdate( ... )
	updateRoster();
end
talents.RegisterCallback(RaidBoss, "LibGroupTalents_Update", talentUpdate)

local function registerAbilityUse(unitname, spell, timeused)
	if(cooldowns and cooldowns[unitname] and cooldowns[unitname][spell.id]) then
		cooldowns[unitname][spell.id].lastused = timeused;
	end
end

for k,v in pairs(groups) do
	v.spellframes = {}
	v.rows = 0;
end

function updateGroupFrameRow(f, group, index)
	f.spellicon:SetWidth(db.barheight)
	f.spellicon:SetHeight(db.barheight)
	f.spelltext:SetPoint("LEFT",db.barheight,0)
	f.spelltext:SetFont(db.font, db.fontsize, db.fontstyle)
	f.classicon:SetWidth(db.barheight)
	f.classicon:SetHeight(db.barheight)
	f.classicon:SetPoint("LEFT", db.totalspellwidth/2 , 0)	
	f.nametext:SetPoint("LEFT",db.totalspellwidth/2 + db.barheight,0)
	f.nametext:SetFont(db.font, db.fontsize, db.fontstyle)
	f.time:SetFont(db.font, db.fontsize, db.fontstyle)
	f.frame:SetWidth(db.totalspellwidth)
	f.frame:SetHeight(db.barheight)
	f.frame:SetPoint("TOP", group.frame, "BOTTOM", 0, -(index-1)*db.barheight);	
	f.frame:SetBackdropColor(ucolor(db.availablebarcolor))
	f.spelltext:SetTextColor(ucolor(db.availablefontcolor))	
	f.nametext:SetTextColor(ucolor(db.availablefontcolor))	
	f.time:SetTextColor(ucolor(db.availabletimerfontcolor))	
end

function updateGroupFrame(group)
	-- anchor
	group.frame:SetWidth(db.totalspellwidth)
	group.frame:SetHeight(db.barheight)	
	if(dbpc.hideanchors==0) then
		group.text:SetFont(db.font, db.fontsize, db.fontstyle)
		group.text:SetTextColor(ucolor(db.grouptitlefontcolor))
		group.frame:SetBackdropColor(ucolor(db.grouptitlebarcolor))
		group.text:SetText(group.title)
	else
		group.text:SetFont(db.font, db.fontsize, db.fontstyle)	
		group.text:SetText("");
		group.frame:SetBackdropColor(0,0,0,0)
	end
	local movable = (dbpc.lock == 0)
	group.frame:SetMovable(movable)
	group.frame:EnableMouse(movable)

	-- rows
	for i=1, group.rows do
		updateGroupFrameRow(group.spellframes[i], group, i);
	end
end

function updateAllFrames()
	local hideall = false;
	local grouptype = getInstanceTypeString();
	if((db.raidtype[grouptype]==nil and db.raidtype.unknown==0) or (db.raidtype[grouptype]~= nil and db.raidtype[grouptype]==0)) then
		hideall = true;
	end
	for k,group in pairs(groups) do
		if(dbpc.groupvisibility[k]==0 or hideall) then
			group.frame:Hide();
		else
			updateGroupFrame(group)
			group.frame:Show();
		end
	end
	if(dbpc.activevisible==0 or hideall) then
		activeanchor.frame:Hide()
	else
		activeanchor.frame:Show();
	end	
	
	-- update active cooldown anchor
	activeanchor.text:SetFont(db.font, db.activefontsize, db.fontstyle)
	if( dbpc.hideanchors==0) then		
		activeanchor.text:SetText(L["Active Cooldowns"]);	
		activeanchor.text:SetTextColor(ucolor(db.activetitlefontcolor))
		activeanchor.frame:SetBackdropColor(ucolor(db.activetitlebarcolor))				
	else
		activeanchor.text:SetText("");
		activeanchor.frame:SetBackdropColor(0,0,0,0) -- transparent
	end
	local movable = (dbpc.lock == 0)
	activeanchor.frame:SetMovable(movable)
	activeanchor.frame:EnableMouse(movable)
	activeanchor.frame:SetWidth(db.barwidth)	
	activeanchor.frame:SetHeight(db.activebarheight)	
	
end

local function addSpellFrame(group, index) 
	group.spellframes[index] = {}
	local f = group.spellframes[index];
	f.frame = CreateFrame("Frame", "RaidBossSpellFrame"..group.name..index, group.frame)
	f.frame:SetFrameStrata("MEDIUM")

	f.frame:SetBackdrop(
	    {bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	    edgeFile = "", tile = true, tilesize = 16, edgeSize = 0, 
	    insets = { left = 0, right = 0, top = 0, bottom = 0 }})	
	    
	f.spellicon = CreateFrame("Frame", "RaidBossSpellFrameSpellIcon"..group.name..index, f.frame)
	f.spellicon:SetFrameStrata("MEDIUM")
	f.spellicon:SetBackdropColor(1,1,1,0.3)	
	f.spellicon:SetPoint("LEFT", 0, 0)
	f.spellicon:Show()
	
	f.classicon = CreateFrame("Frame", "RaidBossSpellFrameClassIcon"..group.name..index, f.frame)
	f.classicon:SetFrameStrata("MEDIUM")
	f.classicon:SetBackdropColor(1,1,1,0.3)	
	f.classicon:Show()

	f.spelltext = f.frame:CreateFontString("RaidBossSpellText"..group.name..index,"OVERLAY")

	f.spelltext:SetJustifyH("LEFT")
	f.spelltext:Show()	
	
	f.nametext = f.frame:CreateFontString("RaidBossNameText"..group.name..index,"OVERLAY")

	f.nametext:SetJustifyH("LEFT")
	f.nametext:Show()	
	
	f.time = f.frame:CreateFontString("RaidBossTimeText"..group.name..index, "OVERLAY")
	f.time:SetPoint("RIGHT",0,0)
	f.time:SetJustifyH("RIGHT")
	f.time:Show()			

	f.frame:Hide();
	
	updateGroupFrameRow(f, group, index);
	return f;
end


local function setSpellFrame(group, index, spell, classicon, playername, length, remaining)
	local f;
	if(not group.spellframes[index]) then
		f = addSpellFrame(group,index)
	else
		f = group.spellframes[index];
	end
	
	if(playername:len() > db.maxnamelen) then
		playername = playername:sub(1,db.maxnamelen);
	end
	
	local sname;
	if(spell.name:len() > db.maxspellnamelen) then
		sname=spell.name:sub(1,db.maxspellnamelen);
	else
		sname = spell.name
	end
	
	-- code
	f.spelltext:SetText(spell.name);
	f.nametext:SetText(playername);
	if(remaining==0) then
		f.time:SetText(formatTime(length));
		f.frame:SetBackdropColor(ucolor(db.availablebarcolor));
		f.spelltext:SetTextColor(ucolor(db.availablefontcolor))	
		f.time:SetTextColor(ucolor(db.availabletimerfontcolor))
		f.nametext:SetTextColor(ucolor(db.availablefontcolor))		
	else
		f.time:SetText(formatTime(remaining));
		f.frame:SetBackdropColor(ucolor(db.unavailablebarcolor));
		f.spelltext:SetTextColor(ucolor(db.unavailablefontcolor))	
		f.time:SetTextColor(ucolor(db.unavailabletimerfontcolor))
		f.nametext:SetTextColor(ucolor(db.unavailablefontcolor))
	end
	
	f.spelltext:SetText(sname);
	f.nametext:SetText(playername);
	f.classicon:SetBackdrop(
	    {bgFile = classicon,
	    edgeFile = "", tile = true, tilesize = 16, edgeSize = 0, 
	    insets = { left = 0, right = 0, top = 0, bottom = 0 }})	
	f.spellicon:SetBackdrop(
	    {bgFile = spell.icon,
	    edgeFile = "", tile = true, tilesize = 16, edgeSize = 0, 
	    insets = { left = 0, right = 0, top = 0, bottom = 0 }})	
	f.frame:Show();
end

local function updateCooldownFrame() 
	for k,v in pairs(groups) do
		v.i = 1;
		v.rows = 0;
	end
	for k,v in pairs(sortedcooldowns) do
		local spell = spells[v.spellid];
		local groupindex = 1;
		local group = groups[spell["group1"]];
		while(group) do
			if(dbpc.groupvisibility[group.name]) then
				-- check group role requirement
				local rolefit = true;
				if(group.rolerequired) then
					if(talents:GetUnitRole(v.root.name) ~= group.rolerequired) then
						rolefit = false;
					end
				end				
				if(v.info.available and rolefit) then
					local offcd = v.info.lastused + v.info.cd <= GetTime();
					if(offcd and (db.showonlyoffcd==0)) then								
						group.rows = group.i;
						setSpellFrame(group, group.i, spell, v.root.classicon, v.root.name, v.info.cd, 0)
						group.i = group.i + 1
					elseif(not offcd) then
						group.rows = group.i;
						local remaining = v.info.cd - (GetTime() - v.info.lastused);
						setSpellFrame(group, group.i, spell, v.root.classicon, v.root.name, v.info.cd, remaining)
						group.i = group.i + 1;				
					end
				end
			end
			groupindex = groupindex + 1;
			group = groups[spell["group"..groupindex]];
		end
	end
	
	-- hide extra frames
	for k,group in pairs(groups) do
		while(group.spellframes[group.i]) do
			group.spellframes[group.i].frame:Hide();
			group.i=group.i+1;
		end
	end
	
	-- for science
	-- setSpellFrame(groups.raidheal, 1, spells[64843], nil, "Jonathonson-Edre'lthrelaskj", 120, 0)
	--setSpellFrame(groups.raidmana, 1, spells[64843], nil, "Jonathonson-Edre'lthrelaskj", 120, 69.95491)
end



------------------------------------------------
-- frame updater                             ---
------------------------------------------------

local totalelapsed = 0;
local function onUpdate(self, elapsed, ...)
    totalelapsed = totalelapsed + elapsed;
    if(totalelapsed >= 0.3) then
        totalelapsed = 0;
        updateCooldownFrame();
    end
end


------------------------------------------------
-- bars for active cooldowns                 ---
------------------------------------------------

local function spellUsed(spell, sourceGUID, targetGUID, sourceName, targetName, duration)	
	registerAbilityUse(sourceName, spell, GetTime());
	
	if(dbpc.activevisible==0) then
		return
	end
	if(not cooldowns[sourceName] or not cooldowns[sourceName][spell.id] or not cooldowns[sourceName][spell.id].available) then
		return
	end
	
	
	local duration = duration or spell.len
	local descriptor = spell.id .. sourceGUID;
	if(activebars[descriptor]) then -- prevent double firings for whatever reason
		return;
	end
	local bar = candy:New(texture, db.barwidth, db.activebarheight)
	local label;
	if(spell.mt) then
		label = spell.name .. " (" .. sourceName .. ")"
	else
		label = spell.name .. " (" .. sourceName .. " -> " .. targetName .. ")"
	end
	bar:SetLabel(label)	
	bar:SetIcon(spell.icon);
	bar:SetDuration(duration)
	bar:SetColor(ucolor(db.activebarcolor))
	bar.candyBarLabel:SetFont(db.font, db.activefontsize);
	bar.candyBarDuration:SetFont(db.font, db.activefontsize);
	bar:Start()
	local descriptor = spell.id .. sourceGUID;
	activebars[descriptor] = {expires = GetTime() + duration, bar = bar};
	sortBars();
end

local function spellFinish(spell, sourceGUID, targetGUID, sourceName, targetName)
	local descriptor = spell.id .. sourceGUID;
	if(activebars[descriptor]) then
		if(activebars[descriptor].expires > GetTime()) then
			activebars[descriptor].bar:Stop();
		end
		activebars[descriptor] = nil;
		sortBars();
	end
end

------------------------------------------------
-- specific combat log handling              ---
------------------------------------------------

local combatevents = {}

combatevents["UNIT_DIED"] = 
	function(...)
		updateRoster();
	end


combatevents["SPELL_CAST_SUCCESS"] = 
	function(...)
		local event, sourceGUID, targetGUID, sourceName, targetName, spellId = select(2, ...), select(4, ...), select(8, ...), select(5, ...), select(9, ...), select(12,...);
		if(start[event] and start[event][spellId]) then
			local spell = start[event][spellId];
			if((not spell.mt) or event=="SPELL_CAST_SUCCESS" or (spell.mt and targetGUID == sourceGUID)) then -- make this more efficient
				local spellname, _, _, _, _, endTime = UnitChannelInfo(sourceName); -- get channeling info (if available) todo: disable this check using spell flags for efficiency
				local duration
				if(spellname) then
					duration = endTime/1000.0 - GetTime();
				end
				spellUsed(spell, sourceGUID, targetGUID, sourceName, targetName, duration)			
			end
		end
	end
	
combatevents["SPELL_AURA_APPLIED"] =  combatevents["SPELL_CAST_SUCCESS"];
combatevents["SPELL_RESURRECT"] = combatevents["SPELL_CAST_SUCCESS"];

combatevents["SPELL_AURA_REMOVED"] =  
	function(...)
		local event, sourceGUID, targetGUID, sourceName, targetName, spellId, spellName = select(2, ...), select(4, ...), select(8, ...), select(5, ...), select(9, ...), select(12,...);
		if(finish[event] and finish[event][spellId]) then
			local spell = finish[event][spellId];
			if(not spell.mt or (spell.mt and targetGUID == sourceGUID)) then
				spellFinish(spell, sourceGUID, targetGUID, sourceName, targetName)
			end
		end	
	end

------------------------------------------------
-- config panel and frame setup              ---
------------------------------------------------

-- to populate the dropdown
local function getfonts()
	local x = {}
	for _,v in pairs(media:List("font")) do
		x[v] = media:Fetch("font", v);
	end
	return  x
end

local function getfontstyles()
	local x = { ["OUTLINE"]="OUTLINE", 
				["THICKOUTLINE"]="THICKOUTLINE", 
				["OUTLINE, MONOCHROME"]="OUTLINE, MONOCHROME", 
				["THICKOUTLINE, MONOCHROME"]="THICKOUTLINE, MONOCHROME",
				["NONE"]="" }
	return x;
end

local function startMoveAndSave(self)
  	if(dbpc.lock==0) then
  		self:StartMoving(); 
  	end
end

local function stopMoveAndSave(self)
	if(dbpc.lock==0) then 
  		self:StopMovingOrSizing(); 
  		local tab = dbpc.position[self:GetName()];
  		tab.point, tab.relativeTo, tab.relativePoint, tab.x, tab.y = self:GetPoint(1)
	end
end

local function initFramePosition(frame)
	if (not dbpc.position[frame:GetName()]) then
		dbpc.position[frame:GetName()] = {}
		local tab = dbpc.position[frame:GetName()];
		tab.x = 0
		tab.y = 0
		tab.point = "CENTER"
		tab.relativeTo = nil
		tab.relativePoint = nil
	end
	frame:ClearAllPoints();
	local tab = dbpc.position[frame:GetName()];
	frame:SetPoint(tab.point, tab.relativeTo, tab.relativePoint, tab.x, tab.y)	
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetScript("OnMouseDown", startMoveAndSave)
	frame:SetScript("OnMouseUp",stopMoveAndSave)
end
	
local function setup()

	------------------------------------------------
	-- db init                                   ---
	------------------------------------------------

	
	
	if(RaidBossDBase == nil) then
		RaidBossDBase = {};
	end
	if(RaidBossDBasePC == nil) then
		RaidBossDBasePC = {}
	end
	local dbasetables = { "subgroups", "raidtype" }
	local dbasepctables = { "spellvisibility", "groupvisibility", "position" }
	for _,v in pairs(dbasetables) do
		if(RaidBossDBase[v] == nil) then
			RaidBossDBase[v] = {}
		end
	end
	for _,v in pairs(dbasepctables) do
		if(RaidBossDBasePC[v] == nil) then
			RaidBossDBasePC[v] = {}
		end
	end
	
	db = RaidBossDBase;
	dbpc = RaidBossDBasePC;
	
	
	-- begin configuration setup
	
	local page = configboss:NewConfig("raidbossmain", L["RaidBoss"]);
	page:SetColumnWidths(300, 200);
	page:AddToBlizzardOptions();
	
	page:AddText(1, "anchorstext", L["Anchors"]);
	
	page:AddCheckbox(1, "lock", L["Lock Frames"], 0, dbpc, updateAllFrames)
	page:AddCheckbox(1, "hideanchors", L["Hide Anchors"], 0, dbpc, updateAllFrames)
	page:AddSpace(1, 10);
	
	page:AddText(1, "text1", L["Spell Group Visibility"])
	
	for key,group in pairs(groups) do	
		page:AddCheckbox(1, group.name, group.title, 1, dbpc.groupvisibility, updateAllFrames)
	end
	
	page:AddSpace(1, 10);
	page:AddText(1, "text2", L["Active Cooldowns Visibility"])
	page:AddCheckbox(1, "activevisible", L["Active Cooldowns Visibility"], 1, dbpc, updateAllFrames)
	
	page:AddSpace(1, 10)
	page:AddText(1, "text5", L["Toggle Raid Subgroup Display"])
	for i=1, 8 do
		page:AddCheckbox(1, "group"..i, L["Group"] .. i, 1, db.subgroups, updateRoster)
	end
	
	page:AddSpace(1, 10)
	page:AddText(1, "textraidtype", L["Raid Size / Difficulty"])
	page:AddCheckbox(1, "unknown", L["Unknown"], 1, db.raidtype, updateAllFrames)
	page:AddCheckbox(1, "solo", L["Solo"], 1, db.raidtype, updateAllFrames)
	page:AddCheckbox(1, "party5", L["Party"], 1, db.raidtype, updateAllFrames)
	page:AddCheckbox(1, "raid10", L["10 Man Normal"], 1, db.raidtype, updateAllFrames)
	page:AddCheckbox(1, "raid25", L["25 Man Normal"], 1, db.raidtype, updateAllFrames)
	page:AddCheckbox(1, "raid40", L["40 Man Normal"], 1, db.raidtype, updateAllFrames)
	page:AddCheckbox(1, "raid10heroic", L["10 Man Heroic"], 1, db.raidtype, updateAllFrames)
	page:AddCheckbox(1, "raid25heroic", L["25 Man Heroic"], 1, db.raidtype, updateAllFrames)
	page:AddCheckbox(1, "raid25lfr", L["25 Man Raid Finder"], 1, db.raidtype, updateAllFrames)
	page:AddCheckbox(1, "pvp10", L["10 Man PvP"], 1, db.raidtype, updateAllFrames)
	page:AddCheckbox(1, "pvp15", L["15 Man PvP"], 1, db.raidtype, updateAllFrames)
	page:AddCheckbox(1, "pvp40", L["40 Man PvP"], 1, db.raidtype, updateAllFrames)
		
	page:AddSpace(1, 10);
	page:AddText(1, "text3", L["Configure Sizes"])	
	page:AddSlider(1, "barwidth", L["Active Bar Width"], 300, db, updateAllFrames, 100, 1000 )
	page:AddSlider(1, "activebarheight", L["Active Bar Height"], 18, db, updateAllFrames, 5, 50 )

	page:AddSlider(1, "totalspellwidth", L["Available Bar Width"], 250, db, updateAllFrames, 100, 1000 )
	page:AddSlider(1, "barheight", L["Available Bar Height"], 18, db, updateAllFrames, 5, 50 )

	page:AddSlider(1, "maxnamelen", L["Maximum Player Name Length"], 9, db, updateAllFrames, 0, 30 )
	page:AddSlider(1, "maxspellnamelen", L["Maximum Spell Name Length"], 15, db, updateAllFrames, 0, 30 )					
	
	page:AddDropDown(1, "font", L["Font"], "Fonts\\FRIZQT__.TTF", db, updateAllFrames, getfonts)
	page:AddDropDown(1, "fontstyle", L["Font Style"], "OUTLINE", db, updateAllFrames, getfontstyles)
	page:AddSlider(1, "fontsize", L["Available Bar Font Size"], 12, db, updateAllFrames, 6, 30 )
	page:AddSlider(1, "activefontsize", L["Active Bar Font Size"], 12, db, updateAllFrames, 6, 30 )		
	local yellow = {r=1,g=1,b=0.5,a=1};
	local grey = {r=0.5, g=0.5, b=0.5, a=1};
	local transparentgrey = {r=0.5, g=0.5, b=0.5, a=0.2}
	local white = { r=1, g=1, b=1, a=0.5 }
	local blue = { r=0, g=0, b=1, a=1 }
	local black = { r=0, g=0, b=0, a=0.5 }
	local green = { r=0.5,g=1,b=0.5,a=0.5 }
	local red = { r=1, g=0.2,b=0.2,a=1 }
	page:AddColorPicker(1, "availablefontcolor", L["Available Font Color"], yellow, db, updateAllFrames)
	page:AddColorPicker(1, "unavailablefontcolor", L["Unavailable Font Color"], grey, db, updateAllFrames)	
	page:AddColorPicker(1, "grouptitlefontcolor", L["Group Title Font Color"], yellow, db, updateAllFrames)		
	page:AddColorPicker(1, "activetitlefontcolor", L["Active Title Font Color"], yellow, db, updateAllFrames)
	page:AddColorPicker(1, "activebarfontcolor", L["Active Bar Font Color"], yellow, db, updateAllFrames)
	page:AddColorPicker(1, "availabletimerfontcolor", L["Available Timer Font Color"], green, db, updateAllFrames)
	page:AddColorPicker(1, "unavailabletimerfontcolor", L["Unavailable Timer Font Color"], red, db, updateAllFrames)
	page:AddColorPicker(1, "grouptitlebarcolor", L["Group Title Bar Color"], white, db, updateAllFrames)
	page:AddColorPicker(1, "activebarcolor", L["Active Bar Color"], blue, db, updateAllFrames)
	page:AddColorPicker(1, "activetitlebarcolor", L["Active Title Bar Color"], white, db, updateAllFrames)
	page:AddColorPicker(1, "availablebarcolor", L["Available Bar Color"], black, db, updateAllFrames)
	page:AddColorPicker(1, "unavailablebarcolor", L["Unavailable Bar Color"], transparentgrey, db, updateAllFrames)
	
	-- spell enablers
	
	page:AddText(2, "text4", L["Spells"])
	page:AddSpace(2,10)
	page:AddCheckbox(2, "showonlyoffcd", L["Show Unavailable Cooldowns Only"], 0, db);
	for nlclass, lclass in pairs(localclasses) do
		page:AddSpace(2, 10)
		page:AddText(2, "class" .. nlclass, lclass)
		for key,spell in pairs(spells) do
			if(nlclass == spell.class) then
				page:AddCheckbox(2, key, spell.name, 1, dbpc.spellvisibility, updateRoster)
			end
		end
	end

	-- end configuration setup		

	-- create bar anchor
	activeanchor.frame = CreateFrame("Frame", "RaidBossActiveAnchor", UIParent)
	initFramePosition(activeanchor.frame)
	activeanchor.frame:SetFrameStrata("MEDIUM")
	activeanchor.frame:Show()
	
	activeanchor.text = activeanchor.frame:CreateFontString("RaidBossActiveAnchorText","OVERLAY")
	activeanchor.text:SetTextColor(1,1,0.5,1)
	activeanchor.text:SetPoint("CENTER",activeanchor.frame,"CENTER",0,0)
	activeanchor.text:Show()
	
	activeanchor.frame:SetBackdropColor(0.2,0.2,0.2,1)
	activeanchor.frame:SetBackdrop(
	    {bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	    edgeFile = "", tile = true, tilesize = 16, edgeSize = 0, 
	    insets = { left = 0, right = 0, top = 0, bottom = 0 }})
	
	-- create available cooldown frame
	for k,v in pairs(groups) do
		v.frame = CreateFrame("Frame", "RaidBossAnchorFrame_"..v.name, UIParent)
		initFramePosition(v.frame)
		v.frame:SetFrameStrata("MEDIUM")
		v.frame:Show()
	
		v.text = v.frame:CreateFontString("RaidBossAnchorFrameText_"..v.name,"OVERLAY")
		v.text:SetTextColor(1,1,0.5,1)
		v.text:SetPoint("CENTER",v.frame,"CENTER",0,0)
		v.text:Show()
		
		v.frame:SetBackdropColor(0.2,0.2,0.2,1)
		v.frame:SetBackdrop(
		    {bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		    edgeFile = "", tile = true, tilesize = 16, edgeSize = 0, 
		    insets = { left = 0, right = 0, top = 0, bottom = 0 }})		
	end	

	updateAllFrames();
	updateRoster();
	
end

------------------------------------------------
-- event handling                            ---
------------------------------------------------

local eventcatcher, events = CreateFrame("Frame"), {};

function events:COMBAT_LOG_EVENT_UNFILTERED(...)
    local event = select(2, ...);
    if(combatevents[event]) then
    	combatevents[event](...);
    end
end
function events:RAID_ROSTER_UPDATE(...)
	updateRoster();
end
function events:PARTY_MEMBERS_CHANGED(...)
	updateRoster();
end
function events:PARTY_CONVERTED_TO_RAID(...)
	updateAllFrames();
	updateRoster();
end
function events:PARTY_MEMBER_DISABLE(...)
	updateRoster();
end
function events:PARTY_MEMBER_ENABLE(...)
	updateRoster();
end
function events:PLAYER_ENTERING_WORLD(...)
	updateAllFrames();
	updateRoster();
end
function events:ZONE_CHANGED_NEW_AREA(...)
	updateAllFrames();
	updateRoster();
end
function events:ADDON_LOADED(addonName)
	if(addonName == "RaidBoss") then
		setup();
	end
end
eventcatcher:SetScript("OnEvent", function(self, event, ...)
 events[event](self, ...);
end);
eventcatcher:SetScript("OnUpdate", function(...)
	onUpdate(...);
end);
for k, v in pairs(events) do
 eventcatcher:RegisterEvent(k); -- Register all events for which handlers have been defined
end