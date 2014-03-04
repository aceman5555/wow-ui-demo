
--[[ 
	1.5 added pausing and unpausing of data collection
	so changed the event definition here and split it into 2 parts
	events that have to be on always, and events that can be switched
	
	2.0 just removed old chat and added CHAT_MSG_ADDON
--]]
SW_EventCollection = {
	SW_EventsMandatory = {
		"PLAYER_TARGET_CHANGED",
		-- 2.0 RC1 changed to get correct memory consumption
		--"VARIABLES_LOADED",
		"ADDON_LOADED",
		"UNIT_PET",
		"PARTY_MEMBERS_CHANGED",
		"PARTY_LEADER_CHANGED",
		"RAID_ROSTER_UPDATE",
		"PLAYER_ENTERING_WORLD",
		
		-- 2.0.5 
		"PLAYER_LEAVING_WORLD",
		
		-- for sync
		"CHAT_MSG_ADDON",
		
		
		
	},
	SW_EventsSwitched = {
		
		--wow 2.4 combat log
		"COMBAT_LOG_EVENT_UNFILTERED",
		"PLAYER_REGEN_DISABLED",
		"PLAYER_REGEN_ENABLED",
		
		 -- new cast tracking for WoW 2.0
		"UNIT_SPELLCAST_SENT",
		"UNIT_SPELLCAST_SUCCEEDED",
		
		-- added 1.4 for death count
		"CHAT_MSG_COMBAT_FRIENDLY_DEATH",
		"CHAT_MSG_COMBAT_HOSTILE_DEATH",
	},
	
}
function SW_UnpauseEvents()
	local coreFrame = getglobal("SW_CoreFrame");
	for i, val in ipairs(SW_EventCollection.SW_EventsSwitched) do
		coreFrame:RegisterEvent(val);
	end
	
end
function SW_PauseEvents()
	local coreFrame = getglobal("SW_CoreFrame");
	for i, val in ipairs(SW_EventCollection.SW_EventsSwitched) do
		coreFrame:UnregisterEvent(val);
	end
end
function SW_RegisterEvents()
	local coreFrame = getglobal("SW_CoreFrame");
	for i, val in ipairs(SW_EventCollection.SW_EventsMandatory) do
		coreFrame:RegisterEvent(val);
	end
end

--[[
	A wrapper arround timing
	If added to saved variables (and inited again)
	will retain cross session seconds ( and milliseconds)
	
	to save it accross sessions add myTimer to SavedVariables AND IN
	VARIABLES_LOADED: myTimer = SW_C_Timer:new(myTimer);
	
--]]
SW_C_Timer = {
	-- epoch time at init
	epochInit = time(),
	-- system up time at init
	upTimeInit = GetTime(),
	
	new = function (self, o)
		o = o or {};
		setmetatable(o, self);
		self.__index = self;
		
		if o.epochTS ~= nil then
			o.uTS = (o.epochTS + o.msO) - self.epochInit ;
		else
			self.setToNow(o);
		end
		return o;
	end,
		
	setToNow = function(self)
		self.epochTS = time();
		self.uTS = GetTime() - self.upTimeInit;
		-- store the millisecond offset
		self.msO = self.uTS - (self.epochTS - self.epochInit);
	end,
	
	-- now return value is not to be used cross session (don't save it)
	now = function(self)
		return GetTime() - self.upTimeInit;
	end,
	
	elapsed = function(self)
		return self.msRound((GetTime() - self.upTimeInit) - self.uTS);	
	end,
	
	--2.0.4
	epochMS = function(self)
		local ms = (GetTime() - self.upTimeInit) - self.uTS;
		local secs = math.floor(ms);
		ms = math.floor((ms - secs)*100);
		SW_printStr(date("%c", self.epochInit + secs)..":"..ms);
		
	end,
	-- one must be a timer object, the other value may be a number
	-- only numbers recieved through :now() make sense
	__sub = function(lh, rh)
		if type(rh) == "number" then
			return lh.uTS - rh;
		elseif type(lh) == "number" then
			return lh - rh.uTS;
		else
			return lh.msRound(lh.uTS - rh.uTS);
		end
	end,
	
	msRound = function(val)
		return math.floor((val) * 1000 + 0.5)/1000;
	end,
	absDiff = function(self, rh)
		local ret = self - rh;
		if ret < 0 then ret = -ret; end
		return ret; 
	end,
	
	-- seconds since startup
	SSS = function(self)
		return GetTime() - self.upTimeInit;
	end,
	
	dump = function(self)
		SW_DumpTable(self);
	end,
}
-- stuff to do 2.0 WoW stuff
if string.gmatch then
	SW_gmatch = string.gmatch;
else
	SW_gmatch = string.gfind;
	
end
function SW_setn(table, size)
	if not table then return; end
	while #table > size do
		table[#table] = nil;
	end
end
function SW_DC (table)
	if table ==nil then return; end
	if type(table) ~= "table" then return; end
	
	local ret = {};
	for k, v in pairs (table) do
		if type(v) == "table" then
			ret[k] = SW_DC(v);
		else
			ret[k] = v;
		end
	end
	return ret;
end

-- other dev stuff
function SW_DEV_FFN(func)
	if func == nil then return; end
	if type(func) ~= "function" then
		return "Not a function";
	end
	local ret = "??";
	local vars = getfenv();
	for k,v in pairs(vars) do
		if type(v) == "function" then
			if func == v then
				return k;
			end
		end
	end
	return ret;
end
function SW_DEV_FindVar(str, chkVal)
	local vars = getfenv();
	local sLen =string.len(str);
	SW_printStr( "------ "..str.." ------");
	for k,v in pairs(vars) do
		if chkVal then
			if type(v) == "string" then
				if string.find(v, str) then
			
					SW_DBG(k.." ==> "..v);
				end
			end
		else
			
			if string.find(k, str) then
				if type(v) == "string" or type(v) == "number" then
					SW_DBG(k.." ==> "..v);
				else
					SW_printStr(k.." ("..type(v)..")");
				end
			end
		end
	end
end


-------------------------- Dump Functions mostly for dev --------------------

function SW_DumpMetaFor(name)
	local sID, sIDPet;
	
	SW_printStr("|cffff0000--All metaInfo for:"..name);
	SW_printStr("|cffffffffStringID in table:");
	sID = SW_StrTable:hasID(name);
	SW_printStr(sID);
	SW_printStr("|cffffffffPet StringID in table:");
	sIDPet = SW_StrTable:hasID(SW_PET..name);
	SW_printStr(sIDPet);
	SW_printStr("|cffffffffcurrentGroup:");
	SW_DumpTable(SW_C_DCMeta.currentGroup[name]);
	SW_printStr("|cffffffffcurrentPets:");
	SW_printStr(SW_C_DCMeta.currentPets[name]);
	
	if sID then
		SW_printStr("|cffffffffrootMeta sID: ");
		SW_DumpTable (SW_DataCollection.meta[sID]);
		SW_printStr("|cffffffffeverGroup lookup sID:");
		SW_printStr(SW_C_DCMeta.everGroup[sID]);
	end
	if sIDPet then
		SW_printStr("|cffffffffrootMeta sIDPet: ");
		SW_DumpTable (SW_DataCollection.meta[sIDPet]);
		SW_printStr("|cffffffffeverGroup lookup sIDPet:");
		SW_printStr(SW_C_DCMeta.everGroup[sIDPet]);
	end
	
	
end
function SW_printStr(str, toChannelNR, store)
	local chNR =1;
	local pre;
	--local store = true;
	if store then
		pre = "["..date("%c").."] "
		--pre = "";
	end
	--str = str.gsub(str," ", "_");
	if toChannelNR ~= nil then chNR = toChannelNR; end
	local con = getglobal("SW_FrameConsole_Text"..chNR.."_MsgFrame");
	if con ~= nil then
		if str == nil then
			con:AddMessage("NIL");
			if store then
				table.insert(SW_DBG_Log, pre.."NIL");
			end
		elseif type(str) == "boolean" then
			local v2 = "Bool:false";
			if str then
				v2 = "Bool:true";
			end
			con:AddMessage(v2);
			if store then
				table.insert(SW_DBG_Log, pre..v2);
			end
		else
			con:AddMessage(str);
			if store then
				table.insert(SW_DBG_Log, pre..str);
			end
		end
	end
	
end
function SW_DBG(str)
	SW_printStr(str, 1, SW_DBG_STORE);
end
function SW_DumpKeys(table)
	if table ==nil then return; end
	if type(table) ~= "table" then return; end
	SW_printStr("-- KEYS -- ");
	for k, v in pairs (table) do 
		SW_printStr(k);
		
	end
end
function SW_DumpTable(table, ds, ch, hideKey)
	if ch == nil then ch = 1; end
	if ds == nil then 
		ds="" 
		SW_printStr("----------------------");
	end
	if table ==nil then return "table is nil"; end
	
	for k, v in pairs (table) do 
		if type(k) == "table" then
			k = tostring(k);
		end
		if type(v) ~= "table" then
			if v == nil then
				if hideKey then
					SW_printStr (ds.."NIL", ch);
				else
					SW_printStr (ds.."["..k.."]=NIL", ch);
				end
			elseif type(v) == "boolean" then
				local v2 = "Bool:false";
				if v then
					v2 = "Bool:true";
				end
				if hideKey then
					SW_printStr (ds..v2, ch);
				else
					SW_printStr (ds.."["..k.."]="..v2, ch);
				end
			elseif type(v) == "function" then
				if hideKey then
					SW_printStr (ds.."function", ch);
				else
					SW_printStr (ds.."["..k.."]=function", ch);
				end
			else
				if hideKey then
					SW_printStr (ds..v, ch);
				else
					SW_printStr (ds.."["..k.."]="..v, ch);
				end
			end
		else
		
			if not hideKey then
				SW_printStr (ds.."["..k.."]=", ch);
			end 
			SW_DumpTable(v, ds.."       ");
		end
	end
end
function SW_DumpMessageTable(table, ds, ch, hideKey)
	if ch == nil then ch = 1; end
	if table ==nil then return "table is nil"; end
	if ds == nil then 
		ds="" 
		SW_printStr("---------Message-------------");
	end
	local ts,kt,vt;
	
	for k, v in pairs (table) do 
		if type(v) ~= "table" then
			if v == nil then
				if hideKey then
					SW_printStr (ds.."NIL", ch);
				else
					SW_printStr (ds.."["..k.."]=NIL", ch);
				end
			elseif type(v) == "boolean" then
				local v2 = "Bool:false";
				if v then
					v2 = "Bool:true";
				end
				if hideKey then
					SW_printStr (ds..v2, ch);
				else
					SW_printStr (ds.."["..k.."]="..v2, ch);
				end
			elseif type(v) == "function" then
				if hideKey then
					SW_printStr (ds.."function", ch);
				else
					SW_printStr (ds.."["..k.."]=function", ch);
				end
			else
				if hideKey then
					SW_printStr (ds..v, ch);
				else
					ts = SW_Types:getTypeStr(k);
					if ts then kt = ts; else kt = k; end 
					ts = SW_Types:getTypeStr(v);
					if ts then vt = ts; else vt = v; end 
					SW_printStr (ds.."["..kt.."]="..vt, ch);
				end
			end
		else
		
			if not hideKey then
				SW_printStr (ds.."["..k.."]=", ch);
			end 
			SW_DumpMessageTable(v, ds.."       ");
		end
	end
end

-- anything after this can safly be deleted if there is something here i was testing something and fergot to remove it with the release version

function TestCharUTF8 (str)
	local fc = string.byte (str);
	local numBytes = 1;
	
	if bit.band(128,fc) == 128 then
		for i=2,8 do 
			numBytes = numBytes + 1;
			if bit.band(128, bit.lshift(fc, i)) == 0 then
				break;
			end
		end
	end
	return numBytes;
end

function TSL(num)
	local tmpName;
	for i=1, 10000 do
		tmpName = SpellIdToName(i);
		if tmpName then 
			SW_printStr(i..": "..tmpName);
		end 
	end 
end

function SpellIdToName(id)
	local tmpLink = GetSpellLink(id);
	if tmpLink then 
		return select(3, string.find(tmpLink, "%[(.+)%]"));
	end
	
end

-- interesting the guid compare is faster ... 
-- redef more locals
function SW_TestSpeed()
	local me= 0x551;
	local defaultFoe = 0x10a48;
	local petFoe = 0x11248; --10001001001001000
	local t ={};
	t.meS1 = "0x0000000000aaaaaa";
	local meS2 = "0x0000000000aaaaaa";
	local ts;
	local count = 0;
	local COMBATLOG_FILTER_ME = COMBATLOG_FILTER_ME;
	
	ts = GetTime(); 
	for i=1, 100000 do 
		if bit.band( me, COMBATLOG_FILTER_ME) == COMBATLOG_FILTER_ME then
			count = count +1; 
		end
	end 
	SW_printStr(GetTime() - ts);
	
	count = 0;
	
	ts = GetTime(); 
	for i=1, 100000 do 
		
		if meS2 == t.meS1 then
			count = count +1; 
		end
	end 
	SW_printStr(GetTime() - ts);
end 

SW_Whatis = {
	-- Affiliation
	COMBATLOG_OBJECT_AFFILIATION_MINE		= 0x00000001,
	COMBATLOG_OBJECT_AFFILIATION_PARTY		= 0x00000002,
	COMBATLOG_OBJECT_AFFILIATION_RAID		= 0x00000004,
	COMBATLOG_OBJECT_AFFILIATION_OUTSIDER		= 0x00000008,
	--COMBATLOG_OBJECT_AFFILIATION_MASK		= 0x0000000F,
	-- Reaction
	COMBATLOG_OBJECT_REACTION_FRIENDLY		= 0x00000010,
	COMBATLOG_OBJECT_REACTION_NEUTRAL		= 0x00000020,
	COMBATLOG_OBJECT_REACTION_HOSTILE		= 0x00000040,
	--COMBATLOG_OBJECT_REACTION_MASK			= 0x000000F0,
	-- Ownership
	COMBATLOG_OBJECT_CONTROL_PLAYER			= 0x00000100,
	COMBATLOG_OBJECT_CONTROL_NPC			= 0x00000200,
	--COMBATLOG_OBJECT_CONTROL_MASK			= 0x00000300,
	-- Unit type
	COMBATLOG_OBJECT_TYPE_PLAYER			= 0x00000400,
	COMBATLOG_OBJECT_TYPE_NPC			= 0x00000800,
	COMBATLOG_OBJECT_TYPE_PET			= 0x00001000,
	COMBATLOG_OBJECT_TYPE_GUARDIAN			= 0x00002000,
	COMBATLOG_OBJECT_TYPE_OBJECT			= 0x00004000,
	--COMBATLOG_OBJECT_TYPE_MASK			= 0x0000FC00,

	-- Special cases (non-exclusive)
	COMBATLOG_OBJECT_TARGET				= 0x00010000,
	COMBATLOG_OBJECT_FOCUS				= 0x00020000,
	COMBATLOG_OBJECT_MAINTANK			= 0x00040000,
	COMBATLOG_OBJECT_MAINASSIST			= 0x00080000,
	COMBATLOG_OBJECT_RAIDTARGET1			= 0x00100000,
	COMBATLOG_OBJECT_RAIDTARGET2			= 0x00200000,
	COMBATLOG_OBJECT_RAIDTARGET3			= 0x00400000,
	COMBATLOG_OBJECT_RAIDTARGET4			= 0x00800000,
	COMBATLOG_OBJECT_RAIDTARGET5			= 0x01000000,
	COMBATLOG_OBJECT_RAIDTARGET6			= 0x02000000,
	COMBATLOG_OBJECT_RAIDTARGET7			= 0x04000000,
	COMBATLOG_OBJECT_RAIDTARGET8			= 0x08000000,
	COMBATLOG_OBJECT_NONE				= 0x80000000,
	--COMBATLOG_OBJECT_SPECIAL_MASK			= 0xFFFF0000,

}

function SW_WT(num)
	SW_printStr(string.format("%x ----------", num));
	
	for k,v in pairs(SW_Whatis) do
		if bit.band(num, v) == v then
			SW_printStr(k);
		end
	end 
	
	--pet merging if its
	--friendly
	--player controlled
	 --and not a player ... hmmm mc'd players in pvp ?
	 
end 