
--[[
	WoW 2.4 - The new "Parser"
	
	
--]]


SW_IS_BOOT = true;


SW_C_GUID ={


}
--[[ NEVER ever use the numbers in code directly
	They might change withought notice, always do a lookup
	not using most of these with wow2.4
--]]
SW_C_Types ={
	validIDs = nil,
	
	Number = {
		Multi = 1000,
		Damage = 1001,
		Heal = 1002,
		LeechFrom = 1003,
		LeechTo = 1004,
		Honor = 1005,
		Skill = 1006,
		Happy = 1007,
		Attacks = 1008,
		Drain = 1009,
		EnviroDmg = 1010,
		Gain = 1011,
		StackCount = 1012,
	},
	String ={
		Multi = 2000,
		Target = 2001,
		Source = 2002,
		School = 2003,
		Skill = 2004,
		--LeechFrom = 2005, -- removed this one, this will always be String.Target (the guy beeing leeched)
		LeechTo = 2006,
		LeechFromWhat = 2007,
		LeechToWhat = 2008,
		DrainWhat = 2009,
		GainWhat = 2010,
		PVPRank = 2011,
		Effect = 2012, --2.0.3 added for aura removal strings
		Item = 2013, -- 2.0.5 added for Item target on enchants
	},
	Other = {
		Multi = 3000,
		Trailers = 3001,
	},
	Events = {
		-- Note to self: This order also defines event processing order
		-- it's the second order attribute in the dispatcher, prio is first
		
		Core = 10000,
		--[[	not in use atm
		Error = 10110, -- any bad error msgs
		Warning = 10120, -- error msgs that "should be ok" but i have to look at
		Info = 10130, -- general info msgs
		--]]
		-- the following are normal event msgs from a succesfull capture
		All = 11000,
		Dmg = 11100,
		Heal = 11200,
		OtherNumber = 11300, -- any capture with a number but not Dmg Or heal
		OnlyString = 11400, -- Captures without a number
	},
	--[[ Core and SW are in there for a reason, I might use these to preprocces messages
		Please use Extreme and lower for plugins/addons.
		
		Normally this is just dependant on a per addon basis BUT, you could register one function as "Medium"
		Do something in that and register another function at "low" that is dependant on whatever you did in medium
		OR another addon did something in VeryHigh, and your dependent on that, then you can register on High (or lower)
		All in all just do a 
		SW_EventDispatcher:register(SW_Types.Events.WHATINEED,"MY_FUNC");
		and ignore the prios alltogether if you don't have a REALLY good reason to mess with them.
	--]]
	Prio = {
		Core = 29999,
		SW = 28000,
		
		Extreme = 26000,
		VeryHigh = 25000,
		High = 24000,
		Medium = 23000,
		Low = 22000,
		VeryLow = 21000,
	},
	new = function (self, o)
		o = o or {};
		setmetatable(o, self);
		self.__index = self;
		
		
		if not self.validIDs then
			self.validIDs = {};
			for k,v in pairs(self.Number) do
				self.validIDs[v] = "Number."..k;
			end
			for k,v in pairs(self.String) do
				self.validIDs[v] = "String."..k;
			end
			for k,v in pairs(self.Other) do
				self.validIDs[v] = "Other."..k;
			end
			for k,v in pairs(self.Events) do
				self.validIDs[v] = "Events."..k;
			end
		end
		
		return o;
	end,
	
	getTypeStr = function(self, ID)
		if ID == nil then
			return nil;
		end
		return self.validIDs[ID];
	end,
	
};
SW_Types = SW_C_Types:new();

--[[
  from Blizzard_CombatLog.lua
  Seems to be a bit mask, not sure how to use that as a benefit atm:
  because those schools are marked temp i'll just be using the vals directly atm.

-- Temporary
SCHOOL_MASK_NONE	= 0x00;
SCHOOL_MASK_PHYSICAL	= 0x01;
SCHOOL_MASK_HOLY	= 0x02;
SCHOOL_MASK_FIRE	= 0x04;
SCHOOL_MASK_NATURE	= 0x08;
SCHOOL_MASK_FROST	= 0x10;
SCHOOL_MASK_SHADOW	= 0x20;
SCHOOL_MASK_ARCANE	= 0x40;

SCHOOL_STRINGS = {};
SCHOOL_STRINGS[1] = STRING_SCHOOL_PHYSICAL;
SCHOOL_STRINGS[2] = STRING_SCHOOL_HOLY;
SCHOOL_STRINGS[3] = STRING_SCHOOL_FIRE;
SCHOOL_STRINGS[4] = STRING_SCHOOL_NATURE;
SCHOOL_STRINGS[5] = STRING_SCHOOL_FROST;
SCHOOL_STRINGS[6] = STRING_SCHOOL_SHADOW;
SCHOOL_STRINGS[7] = STRING_SCHOOL_ARCANE;

  the interesting thing about CombatLog_String_SchoolString in Blizzard_CombatLog.lua
  it seems to support multiple schools.. why is that?
  for now just mask this to old swstats school workings
--]]  


SW_Schools = {
	nameToID = {},
	IDToName = {},
	
	init = function (self)
		
		--wow 2.4 
		
		self.nameToID[STRING_SCHOOL_UNKNOWN] = 0;
		self.IDToName[0] = STRING_SCHOOL_UNKNOWN;
		
		self.nameToID[STRING_SCHOOL_PHYSICAL] = 1;
		self.IDToName[1] = STRING_SCHOOL_PHYSICAL;
		
		self.nameToID[STRING_SCHOOL_HOLY] = 2;
		self.IDToName[2] = STRING_SCHOOL_HOLY;
		
		self.nameToID[STRING_SCHOOL_FIRE] = 4;
		self.IDToName[4] = STRING_SCHOOL_FIRE;
		
		self.nameToID[STRING_SCHOOL_NATURE] = 8;
		self.IDToName[8] = STRING_SCHOOL_NATURE;
		
		self.nameToID[STRING_SCHOOL_FROST] = 16;
		self.IDToName[16] = STRING_SCHOOL_FROST;
		
		self.nameToID[STRING_SCHOOL_SHADOW] = 32;
		self.IDToName[32] = STRING_SCHOOL_SHADOW;
		
		self.nameToID[STRING_SCHOOL_ARCANE] = 64;
		self.IDToName[64] = STRING_SCHOOL_ARCANE;
		
		-- old stuff to keep
		self.nameToID[SPELL_SCHOOLALL] = 100;
		self.IDToName[100] = SPELL_SCHOOLALL;
		
		self.nameToID[SPELL_SCHOOLMAGICAL] = 101;
		self.IDToName[101] = SPELL_SCHOOLMAGICAL;
		
		self.IDToName[200] = SW_PRINT_ITEM_NON_SCHOOL;
		self.nameToID[SW_PRINT_ITEM_NON_SCHOOL] = 200;
		
		self.IDToName[300] = SW_STR_ENVIRO;
		self.nameToID[SW_STR_ENVIRO] = 300;
	end,	
	
	getID = function (self, str)
		return self.nameToID[str];
	end,
	
	getStr = function(self, ID)
		return self.IDToName[ID];
	end,
}

--SPELL_POWER_MANA = 0;
--SPELL_POWER_RAGE = 1;
--SPELL_POWER_FOCUS = 2;
--SPELL_POWER_ENERGY = 3;
--SPELL_POWER_HAPPINESS = 4;
--SPELL_POWER_RUNES = 5;
-- seems not done on the ptr
SW_PowerTypes = {
	IDToName = {},
	
	init = function(self)
		local tempStr;
		
		if STRING_POWER_MANA then 
			tempStr = STRING_POWER_MANA; 
		else 
			tempStr = MANA;
		end;
		self.IDToName[SPELL_POWER_MANA] = tempStr;
		
		if STRING_POWER_RAGE then 
			tempStr = STRING_POWER_RAGE; 
		else 
			tempStr = RAGE;
		end;
		self.IDToName[SPELL_POWER_RAGE] = tempStr;
		
		if STRING_POWER_FOCUS then 
			tempStr = STRING_POWER_FOCUS; 
		else 
			tempStr = FOCUS;
		end;
		self.IDToName[SPELL_POWER_FOCUS] = tempStr;
		
		if STRING_POWER_ENERGY then 
			tempStr = STRING_POWER_ENERGY; 
		else 
			tempStr = ENERGY;
		end;
		self.IDToName[SPELL_POWER_ENERGY] = tempStr;
		
		if STRING_POWER_HAPPINESS then 
			tempStr = STRING_POWER_HAPPINESS; 
		else 
			tempStr = HAPPINESS;
		end;
		self.IDToName[SPELL_POWER_HAPPINESS] = tempStr;
		
		if STRING_POWER_RUNES then 
			tempStr = STRING_POWER_RUNES; 
		else 
			tempStr = RUNES;
		end;
		self.IDToName[SPELL_POWER_RUNES] = tempStr;
		
	end, 
	getStr = function(self, ID)
		if not ID then return ""; end
		return self.IDToName[ID];
	end,
}

SW_EventDispatcher = {
	
	eventHooks = {},
	
	dispatch = function (self, oMsg)
		-- don't dispatch anything during init
		if SW_IS_BOOT then return; end
		
		local ev = SW_Types.Events;
		
		for k,t in ipairs(self.eventHooks) do
			if t[2] == ev.Core then
				t[3](oMsg);
			elseif t[2] == ev.All then
				t[3](oMsg);
			elseif t[2] == ev.Dmg then
				if oMsg.IsDmg then
					t[3](oMsg);
				end
			elseif t[2] == ev.Heal then
				if oMsg.IsHeal then
					t[3](oMsg);
				end
			elseif t[2] == ev.OtherNumber then
				if not oMsg.OnlyStrings then
					t[3](oMsg);
				end
			elseif t[2] == ev.OnlyString then
				if oMsg.OnlyStrings then
					t[3](oMsg);
				end
			end
		end
	end,
	
	register = function (self, listenToType, funcName, prio)
		func = getglobal(funcName);
		-- if this happens recheck load order of your addon
		assert(func, "SW_EventDispatcher:register function 'pointer' is invalid\r\n"..debugstack(2,1,0));
		local evSort = function (a,b)
			if a[1] == b[1] then
				return a[2] < b[2];
			end
			return a[1] < b[1];
		end
		if prio == nil then
			prio = SW_Types.Prio.Medium;
		end
		table.insert(self.eventHooks, {prio, listenToType, func} );
		table.sort(self.eventHooks, evSort);
	end,
};


function SW_AddToDC(oMsg)
	SW_DataCollection:addMsg(oMsg);
end
SW_EventDispatcher:register(SW_Types.Events.All,"SW_AddToDC",SW_Types.Prio.SW);

function SW_DoLocalDPS(oMsg)
	local v = oMsg:getBasicData();
	if not (v and v.Source) or v.Source ~= SW_SELF_STRING  or not v.Damage then return end;
	if SW_CombatTimeInfo.awaitingStart then
		SW_CombatTimeInfo.awaitingEnd = true;
		SW_CombatTimeInfo.awaitingStart = false;
	end
	SW_DPS_Dmg = SW_DPS_Dmg + v.Damage;
end
SW_EventDispatcher:register(SW_Types.Events.Dmg,"SW_DoLocalDPS",SW_Types.Prio.SW - 10);

function SW_DebugPrecheck(oMsg)
	--if oMsg.IsDeath then 
		--SW_printStr("  Death");
	--end
	--if oMsg.IsSlayInfo then 
		--SW_printStr("  IsSlayInfo");
	--end
end
if SW_DBG_PARSER then
	SW_EventDispatcher:register(SW_Types.Events.All,"SW_DebugPrecheck",SW_Types.Prio.Core);
end

--[[
	Masking New wow2.4 to old sw stats trailers
--]] 

SW_C_TrailerInfo = {
	
	lastData = {
		Resist = 0,
		Block = 0,
		Absorb = 0,
		Glancing = 0,
		Crushing = 0,
	},
	
	new = function (self, o)
		o = o or {};
		setmetatable(o, self);
		self.__index = self;
		
		return o;
	end,
	
	checkTrailer = function (self, resisted, blocked, absorbed, glancing, crushing)	
		
		if resisted or blocked or absorbed or glancing or crushing then
			local ld = self.lastData;
			ld.Resist = resisted or 0;
			ld.Block = blocked or 0;
			ld.Absorb = absorbed or 0;
			ld.Glancing = glancing or 0;
			ld.Crushing = crushing or 0;
			return (ld.Resist + ld.Block + ld.Absorb + ld.Glancing + ld.Crushing > 0)
			
		end
		
		return false;
	end,
}
SW_TrailerBuffer = SW_C_TrailerInfo:new();

-- a guid to name lookup
-- currently only filled with petowner names
SW_GUID_Name = {

}
--maps one guid to another 
-- used for pets totems etc to get the owner
SW_GUID_Mapper = {
	grInfo = {},
	
	-- update guid info through group/raid
	-- the guid seems to count up when summoning your own pets
	-- there might be a relationschip between old pet guid and new pet guid
	-- this works - recheck maybe for optimization
	-- this keeps all guid lookups per session and after hours of playing will carry a lot of "junk" for pets
	-- see if this is problematic
	updateGroupInfo = function (self)
		local petGUID;
		local ownerGUID;
		local grInfo = self.grInfo;
		
		--SW_printStr("SW_GUID_Mapper:updateGroupInfo");
		
		petGUID = UnitGUID("pet");
		if petGUID then
			ownerGUID = UnitGUID("player"); 
			grInfo[petGUID] = ownerGUID;
			SW_GUID_Name[ownerGUID] = UnitName("player");
		end 
		if GetNumRaidMembers() > 0 then
			for i=1, 40 do
				
				petGUID = UnitGUID("raidpet"..i);
				if petGUID then
					ownerGUID = UnitGUID("raid"..i);
					grInfo[petGUID] = ownerGUID; 
					SW_GUID_Name[ownerGUID] = UnitName("raid"..i);
				end 
			
			end
		elseif GetNumPartyMembers() > 0 then
			for i=1, 4 do
				petGUID = UnitGUID("partypet"..i);
				if petGUID then
					ownerGUID = UnitGUID("party"..i);
					grInfo[petGUID] = ownerGUID; 
					SW_GUID_Name[ownerGUID] = UnitName("party"..i);
				end 
			end
		end
	end,
	addByPetEvent = function (self, unitId)
		--self.grInfo[UnitGUID(unitId)] = UnitGUID(unitId..pet);
		
	end,
	--SPELL_SUMMON 
	--SPELL_CREATE 
	addByEvent = function (self, timestamp, event, ownerGUID, ownerName, ownerFlags, petGUID, petName, petFlags, spellId, spellName, ...)
		
		local pre, suf;
		
		if spellId == 2894 then --fire ele totem
			pre = string.sub(petGUID,1,5).."0003C4E";
			suf = string.format("%06X",tonumber(string.sub(petGUID,13),16) + 1);
			
			self.grInfo[pre..suf] = ownerGUID;
			SW_GUID_Name[ownerGUID] = ownerName;
		
		elseif spellId == 2062 then -- earth ele totem 
			pre = string.sub(petGUID,1,5).."0003BF8";
			suf = string.format("%06X",tonumber(string.sub(petGUID,13),16) + 1);
			
			self.grInfo[pre..suf] = ownerGUID;
			SW_GUID_Name[ownerGUID] = ownerName;
		else
			self.grInfo[petGUID] = ownerGUID;
			SW_GUID_Name[ownerGUID] = ownerName;
		end  
		
		
	end, 
	-- allow for owner chains - so this is recursive
	getOwnerGUID = function (self, GUID)
		if self.grInfo[GUID] then
			return self:getOwnerGUID(self.grInfo[GUID]);
		end 
		return GUID;
	end, 
	
}

--[[
	Masking  the new stuff to old sw stats Message object
	also added new guid etc stuff for later usage
]]

SW_C_Message = {	
	lastData = {},
	
	IsDmg = false,
	IsHeal = false,
	IsDrain = false,
	IsLeech = false,
	IsEnviro = false,
	IsGain = false,
	IsExtraAttack = false, 
	OnlyStrings = false,
	myGUID = nil,
		
	new = function (self, o)
		
		o = o or {};
		setmetatable(o, self);
		self.__index = self;
		
		return o;
	end,


	
	getBasicData= function (self)
		local v = self.lastData;
		local sID;
		local sInG, tInG;
		
		if self.BasicDirty then
			v.Source = self:getSource();
			v.Target = self:getTarget();
			v.Damage = self.Damage or false;
			v.Heal = self.Heal or false; --self:getHeal();
			v.Skill = self:getSkill();
			v.SchoolID = self:getSchoolID();
			v.IsCrit = self.IsCrit;
			v.FromSelf = self.FromSelf;
			v.ToSelf = self.ToSelf;
			v.IsDmgNullify = self.IsDmgNullify;
			
			if self.LastHadTrailer then
				v.Trailer = SW_TrailerBuffer.lastData;
			else
				v.Trailer = false;
			end
			
			-- this starts the timer
			if v.Damage and not self.IsEnviro 
				and (SW_DataCollection.meta.currentGroup[v.Source] 
					or SW_DataCollection.meta.currentPets[v.Source]) then
				SW_RPS:validEvent();
			--if we are already in a fight allow Damage taken to reset the timer
			elseif SW_RPS.isRunning and v.Damage 
					and (SW_DataCollection.meta.currentGroup[v.Target] 
						or SW_DataCollection.meta.currentPets[v.Target]) then
				SW_RPS:validEvent();
			end
			
			-- are we in a fight ?
			if SW_RPS.isRunning then
				v.inF = true;
			else
				v.inF = false;
			end
			if v.Heal then
				self:setHealInfo(v);
			else
				v.EffectiveHeal = 0;
				v.Overheal = 0;
			end
			
			v.IsDecurse = (self.IsDispel and (self.exType=="DEBUFF"));
			
			if self.IsPeriodic then
				v.IsPeriodic = true;
			else
				v.IsPeriodic = false;
			end
			-- 2.0.5 EverGroup/CurrentGroup and ScrapDmg
			v.EverGroupInfo = false;
			v.CurrGroupInfo = false;
			sInG = false;
			tInG = false;
			
			if SW_DataCollection.meta.currentPets[v.Source] then
				sInG = true;
			end 
			if SW_DataCollection.meta.currentPets[v.Target] then
				tInG = true;
			end
			if SW_DataCollection.meta.currentGroup[v.Source] then
				sInG = true;
			end 
			if SW_DataCollection.meta.currentGroup[v.Target] then
				tInG = true;
			end
			v.CurrGroupInfo = (sInG or tInG);
			v.EverGroupInfo = v.CurrGroupInfo;
			
			if not v.EverGroupInfo then
				sID = SW_StrTable:hasID(v.Source);
				if sID and SW_DataCollection.meta.everGroup[sID] then
					v.EverGroupInfo = true;
				end
				if not v.EverGroupInfo then
					sID = SW_StrTable:hasID(v.Target);
					if sID and SW_DataCollection.meta.everGroup[sID] then
						v.EverGroupInfo = true;
					end
				end
			end
			-- hmm this could have some odd effects with MC'd mobs
			-- priest MC's a mob and and group kills another mob with the same name
			-- all in all i guess thats better than accounting bombs, shatter etc to the player
			v.ScrapDamage = (v.Damage and sInG and tInG);
			if v.Damage and not v.ScrapDamage then
				-- still check this one
				if v.Source == v.Target then
					v.ScrapDamage = true;
				end
			end
			-- 2.0.5 added effects to basic data
			v.IsHarmfulEffect = false;
			v.IsHelpfulEffect = false;
			v.Effect = false;
			if self.IsEffectGot or self.IsEffectLost then
				v.Effect = self:getSkill();
				if v.Effect then
					if self.auraType == "DEBUFF" then
						v.IsHarmfulEffect = true;
					elseif self.auraType == "BUFF" then
						v.IsHelpfulEffect = true;
					end
				end
			end
			self.BasicDirty = false;
		end
		return v;
	end,
	setHealInfo = function (self, v, isRetry)
		local uID = SW_DataCollection.meta:getUnitID(v.Target);
		
		if uID then
			if (UnitName(uID)) ~= v.Target then
				if isRetry then
					SW_DBG("This shouldn't happen: setHealInfo "..(UnitName(uID)).." ~= "..v.Target);
					v.Overheal = 0;
					v.EffectiveHeal = v.Heal;
				else
					SW_DBG("Rebuilding Meta info in setHealInfo");
					SW_DataCollection.meta:updateGroupRaid();
					self:setHealInfo(v, true);
				end
			else
				local num = UnitHealthMax(uID) - UnitHealth(uID) - v.Heal;
				if num < 0 then
					num = num * (-1);
					v.Overheal = num;
					v.EffectiveHeal = v.Heal - num;
				else
					v.Overheal = 0;
					v.EffectiveHeal = v.Heal;
				end
			end
		else
			v.Overheal = 0;
			v.EffectiveHeal = v.Heal;
		end
	end,
	
	getSource = function (self)
		if self.srcName then
			return self.srcName;
		end
		
		if self.FromSelf then
			return SW_SELF_STRING;
		end
		
		return SW_WORLD;
	end,
	getTarget = function (self)
		if self.dstName then
			return self.dstName;
		end
		
		if self.ToSelf then
			return SW_SELF_STRING;	
		end
		
		return SW_WORLD;
	end,
	getSkill = function (self)
		--if self.spellName then
			--return self.spellName;
		--elseif self.MapToSkill then
			--return self.MapToSkill;
		--end
		--return false;
		if self.IsRemapped and self.spellName then
			return self.origRemappedName.." - "..self.spellName;
			--self.origRemappedName
		elseif self.IsRemapped then
			return self.origRemappedName;
		elseif self.spellName then
			return self.spellName;
		elseif self.MapToSkill then
			return self.MapToSkill; -- not used in wow 2.4
		end 
		
	end,
	getSchoolID = function (self)
		if self.IsEnviro then
			return 300;
		elseif self.SchoolID then
			return self.SchoolID; 
		elseif self.Damage then
			return 200;
		end
		return false;
	end,
	
	dump = function (self)
		SW_DumpTable(self);
	end,
	dumpLastCap = function (self)
		--local to = self.CaptureAmount;
		--if self.CanHaveTrailer then
			--to = to - 1;
		--end
		--for i=1, to do
			--SW_Event_Channel:AddMessage("|cffffffaa"..SW_Types:getTypeStr(self.CaptureTypes[i])..":|r "..self.LastCapture[i]);
		--end
		--if self.CanHaveTrailer and self.LastHadTrailer then
			--for k,v in pairs(self.oTrailer.lastData) do
				--if v > 0 then
					--SW_Event_Channel:AddMessage(k.." "..v);
				--end
			--end
		--end
		--SW_Event_Channel:AddMessage("|cffffffaaSource:|r "..self:getSource());
		
	end,

	
	getEventStr = function (self, ...)
		local message = string.format("[%s.%s] %s, %s, %s, 0x%x, %s, %s, 0x%x",
				       date("%H:%M:%S", self.timestamp), self.ms,
				       self.event,
				       self.srcGUID, self.srcName or "nil", self.srcFlags,
				       self.dstGUID, self.dstName or "nil", self.dstFlags);
			
		for i = 9, select("#", ...) do
			message = message..", "..(select(i, ...) or "nil");
		end
		return message;
	end,
	handleBase = function(self, timestamp, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, ...)
		
		self.IsRemapped = false;
		
		local ms = select(3,string.find(tostring(timestamp), "%.(%d+)$"));
		ms = ms or "0";
		self.ms = tonumber(ms);
				
		self.timestamp = timestamp;
		self.event = event;
		self.srcGUID = srcGUID;
		self.srcName = srcName;
		self.srcFlags = srcFlags;
		self.dstGUID = dstGUID;
		self.dstName = dstName;
		self.dstFlags = dstFlags;
		
		-- remap pets to owner
		local ownerGUID = SW_GUID_Mapper:getOwnerGUID(srcGUID);
		if ownerGUID ~= srcGUID then 
			self.origRemappedName = self.srcName;
			self.origRemappedGUID = self.srcGUID;
			self.srcGUID = ownerGUID;
			self.srcName = SW_GUID_Name[ownerGUID];
			self.IsRemapped = true;
		end 
		
		
		if not SW_C_Message.myGUID then
			--if bit.band( srcFlags, COMBATLOG_FILTER_ME) == COMBATLOG_FILTER_ME then
				--SW_C_Message.myGUID = srcGUID;
			--elseif bit.band( dstFlags, COMBATLOG_FILTER_ME) == COMBATLOG_FILTER_ME then
				--SW_C_Message.myGUID = dstGUID; 
			--end 
			-- nice addition :)
			SW_C_Message.myGUID = UnitGUID("player");
		end
		
		self.FromSelf = (self.myGUID == srcGUID);
		self.ToSelf = (self.myGUID == dstGUID);
		
	end,
	
	preNOP = function(self, ...)
		self.continueAt = 9;
	end,
	preEnviro = function(self, ...)
		self.enviroType = select(9, ...);
		self.continueAt = 10;
	end,
	preSpell = function(self, ...)
		self.spellId, self.spellName, self.SchoolID = select(9, ...);
		self.continueAt = 12;
	end, 
	tyNOP = function(self, ...)
		self.BasicDirty = true; 
	end, 
	tyDamage = function(self, ...)
		local amount, school, resisted, blocked, absorbed, critical, glancing, crushing = select(self.continueAt, ...);
		self.LastHadTrailer = SW_TrailerBuffer:checkTrailer(resisted, blocked, absorbed, glancing, crushing);
		self.Damage = amount;
		
		--override first school, this one is more specific eg. wand shoot shows physical on the first
		-- but the correct school on the second, TODO check this could be problematic with resist calcs
		self.SchoolID = school;
		 
		if critical then self.IsCrit = true; else self.IsCrit = false; end
		
		--SW_printStr(amount);
		self.BasicDirty = true;
	end,
	
	tyMissed = function(self, ...)
		self.missType = select(self.continueAt, ...);
		self.BasicDirty = true;
	end, 
	
	tyHeal = function(self, ...)
		local amount, critical = select(self.continueAt, ...);
		self.Heal = amount;
		if critical then self.IsCrit = true; else self.IsCrit = false; end
		self.BasicDirty = true;
	end, 
	
	tyAura = function(self,...)
		self.auraType = select(self.continueAt, ...);
		self.BasicDirty = true;
	end, 
	tyAuraDose = function(self,...)
		self.auraType, self.auraDose = select(self.continueAt, ...);
		self.BasicDirty = true;
	end,
	
	tyEnergize = function(self, ...)
		self.gainAmount, self.gainType = select(self.continueAt, ...);
		self.BasicDirty = true;
	end, 
	
	tyLeech = function(self, ...)
		--guessing amount what then leecher got extraamount what then lechee lost.. hmm drain?
		--with drain the last arg seems to be nil
		self.amount, self.powerType, self.extraAmount = select(self.continueAt, ...);
		
		self.BasicDirty = true;
	end,
	
	tyExtraSpell = function(self, ...)
		self.exSpellID, self.exSpellName, self.exSchoolID, self.exType = select(self.continueAt, ...);
		self.BasicDirty = true;
	end,  
	

};

SW_DefaultMessage = SW_C_Message:new();

SW_C_Parser = {
	
	eventMessages = {},
	
	new = function (self, o)
		o = o or {};
		setmetatable(o, self);
		self.__index = self;
		
		o:initMessages();
		return o;
	end,
	
	handleEvent = function(self, ...)
		
		local event = select(2, ...);
		local mo;
		
		--SPELL_SUMMON 
		--SPELL_CREATE not sure about this one.. assuming
		if event == "SPELL_SUMMON" or event == "SPELL_CREATE" then
			SW_GUID_Mapper:addByEvent(...); 
			
			-- tmp just used for the output later
			mo = SW_DefaultMessage;
			mo:handleBase(...);
		else
			mo = self.eventMessages[event];
			if mo then 
				mo:handleBase(...);
				mo:handlePrefix(...);
				mo:handleType(...);
			
				SW_EventDispatcher:dispatch(mo);
			end
		end 
		
		
		if not SW_EI_ALLOFF then
			if SW_Settings.EI_ShowMatch then
				if event=="SPELL_CAST_START" or event=="SPELL_CAST_SUCCESS" then
					return;
				end 
			end 
			if SW_Settings.EI_ShowRegEx then
				if mo and mo.IsRemapped then
					SW_Event_Channel:AddMessage("REMAPPED origSrcGUID, origSrcName: "..mo.origRemappedGUID..", "..mo.origRemappedName);
				end 
			end
			if SW_Settings.EI_ShowOrigStr then
				if mo then
					SW_Event_Channel:AddMessage(mo:getEventStr(...));
					--SW_DBG(mo:getEventStr(...));
				end 
			end
			if SW_Settings.EI_ShowEvent then
				if not mo then 
					mo = SW_DefaultMessage;
					mo:handleBase(...);
					local msg = "[UNHANDLED]"..mo:getEventStr(...);
					SW_Event_Channel:AddMessage(msg);
					--SW_DBG(msg);
				end 
			end
			
		end
	end,
	
	initMessages = function(self)
		local tmpMsg;
	  --"ENVIRONMENTAL_DAMAGE",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDmg = true;
		tmpMsg.IsEnviro = true;
		tmpMsg.handlePrefix = tmpMsg.preEnviro;
		tmpMsg.handleType = tmpMsg.tyDamage;
		self.eventMessages["ENVIRONMENTAL_DAMAGE"] = tmpMsg;
		
	  --"SWING_DAMAGE",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDmg = true;
		tmpMsg.handlePrefix = tmpMsg.preNOP;
		tmpMsg.handleType = tmpMsg.tyDamage;
		self.eventMessages["SWING_DAMAGE"] = tmpMsg;
      
      --"SWING_MISSED",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDmgNullify = true;
		tmpMsg.handlePrefix = tmpMsg.preNOP;
		tmpMsg.handleType = tmpMsg.tyMissed;
		self.eventMessages["SWING_MISSED"] = tmpMsg;
		
      --"RANGE_DAMAGE",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDmg = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyDamage;
		self.eventMessages["RANGE_DAMAGE"] = tmpMsg;
		
      --"RANGE_MISSED",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDmgNullify = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyMissed;
		self.eventMessages["RANGE_MISSED"] = tmpMsg;
		
      --"SPELL_CAST_START",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsCast = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyNOP;
		self.eventMessages["SPELL_CAST_START"] = tmpMsg;
		
      --"SPELL_CAST_SUCCESS",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsCast = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyNOP;
		self.eventMessages["SPELL_CAST_SUCCESS"] = tmpMsg;
		
      --"SPELL_CAST_FAILED",
      
      --"SPELL_MISSED",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDmgNullify = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyMissed;
		self.eventMessages["SPELL_MISSED"] = tmpMsg;
		
      --"SPELL_DAMAGE",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDmg = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyDamage;
		self.eventMessages["SPELL_DAMAGE"] = tmpMsg;
		
      --"SPELL_HEAL",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsHeal = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyHeal;
		self.eventMessages["SPELL_HEAL"] = tmpMsg;
		
      --"SPELL_ENERGIZE",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsGain = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyEnergize;
		self.eventMessages["SPELL_ENERGIZE"] = tmpMsg;
		
      --"SPELL_DRAIN",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDrain = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyLeech;
		self.eventMessages["SPELL_DRAIN"] = tmpMsg;
		
      --"SPELL_LEECH",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsLeech = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyLeech;
		self.eventMessages["SPELL_LEECH"] = tmpMsg;
		
      --"SPELL_INSTAKILL", e.g. deamonic sacrifice
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsSlayInfo = true;
		tmpMsg.handlePrefix = tmpMsg.preNOP;
		tmpMsg.handleType = tmpMsg.tyNOP;
		self.eventMessages["SPELL_INSTAKILL"] = tmpMsg;
		
      --"SPELL_INTERRUPT",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsInterrupt = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyExtraSpell;
		self.eventMessages["SPELL_INTERRUPT"] = tmpMsg;
		
      --"SPELL_EXTRA_ATTACKS",
      --"SPELL_DURABILITY_DAMAGE",
      --"SPELL_DURABILITY_DAMAGE_ALL",
      
      --"SPELL_AURA_APPLIED",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsEffectGot = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyAura;
		self.eventMessages["SPELL_AURA_APPLIED"] = tmpMsg;
		
      --"SPELL_AURA_APPLIED_DOSE",
		self.eventMessages["SPELL_AURA_APPLIED_DOSE"] = self.eventMessages["SPELL_AURA_APPLIED"]; -- check later for dose stuff
		
      --"SPELL_AURA_REMOVED",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsEffectLost = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyAura;
		self.eventMessages["SPELL_AURA_REMOVED"] = tmpMsg;
		
      --"SPELL_AURA_REMOVED_DOSE",
		self.eventMessages["SPELL_AURA_REMOVED_DOSE"] = self.eventMessages["SPELL_AURA_REMOVED"]; -- check later for dose stuff
		
      --"SPELL_AURA_DISPELLED",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDispel = true; 
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyExtraSpell;
		self.eventMessages["SPELL_AURA_DISPELLED"] = tmpMsg;
		
      --"SPELL_AURA_STOLEN",
      --"ENCHANT_APPLIED", -- found windfury here (aktivated enchant not totem)
      --"ENCHANT_REMOVED",
      
      --"SPELL_PERIODIC_MISSED",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDmgNullify = true;
		tmpMsg.IsPeriodic = true; 
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyMissed;
		self.eventMessages["SPELL_PERIODIC_MISSED"] = tmpMsg;
		
      --"SPELL_PERIODIC_DAMAGE",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDmg = true;
		tmpMsg.IsPeriodic = true; 
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyDamage;
		self.eventMessages["SPELL_PERIODIC_DAMAGE"] = tmpMsg;
		
      --"SPELL_PERIODIC_HEAL",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsHeal = true;
		tmpMsg.IsPeriodic = true; 
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyHeal;
		self.eventMessages["SPELL_PERIODIC_HEAL"] = tmpMsg;
		
      --"SPELL_PERIODIC_ENERGIZE",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsGain = true;
		tmpMsg.IsPeriodic = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyEnergize;
		self.eventMessages["SPELL_PERIODIC_ENERGIZE"] = tmpMsg;
		
      --"SPELL_PERIODIC_DRAIN",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDrain = true;
		tmpMsg.IsPeriodic = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyLeech;
		self.eventMessages["SPELL_PERIODIC_DRAIN"] = tmpMsg;
		
      --"SPELL_PERIODIC_LEECH",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsLeech = true;
		tmpMsg.IsPeriodic = true;
		tmpMsg.handlePrefix = tmpMsg.preSpell;
		tmpMsg.handleType = tmpMsg.tyLeech;
		self.eventMessages["SPELL_PERIODIC_LEECH"] = tmpMsg;
      
      --"SPELL_DISPEL_FAILED",
		self.eventMessages["SPELL_DISPEL_FAILED"] = self.eventMessages["SPELL_AURA_DISPELLED"];
      
      --"DAMAGE_SHIELD",
		self.eventMessages["DAMAGE_SHIELD"] = self.eventMessages["SPELL_DAMAGE"]; -- for now ... check if we need the remap again
			-- actually for later dont remap as it seems.. its nice for the unilog to filter them out
		
      --"DAMAGE_SHIELD_MISSED",
		self.eventMessages["DAMAGE_SHIELD_MISSED"] = self.eventMessages["SPELL_MISSED"]; -- also check for remap
		
      --"DAMAGE_SPLIT",
		self.eventMessages["DAMAGE_SPLIT"] = self.eventMessages["SPELL_DAMAGE"]; -- whatever this is seems the same as spell dmg
		
      --"PARTY_KILL",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsSlayInfo = true;
		tmpMsg.handlePrefix = tmpMsg.preNOP;
		tmpMsg.handleType = tmpMsg.tyNOP;
		self.eventMessages["PARTY_KILL"] = tmpMsg;
		
      --"UNIT_DIED",
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDeath = true;
		tmpMsg.handlePrefix = tmpMsg.preNOP;
		tmpMsg.handleType = tmpMsg.tyNOP;
		self.eventMessages["UNIT_DIED"] = tmpMsg;
		
      --"UNIT_DESTROYED"
		tmpMsg = SW_C_Message:new();
		tmpMsg.IsDestruction = true;
		tmpMsg.handlePrefix = tmpMsg.preNOP;
		tmpMsg.handleType = tmpMsg.tyNOP;
		self.eventMessages["UNIT_DESTROYED"] = tmpMsg;
		
		
	end,
	
	
}

