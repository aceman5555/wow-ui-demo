--[[
	A "Unified" Combat log - sortable, and able to apply special filters combined with regualr expressions.
	Can't find what you want to know in the log ... now you can.
	
	wow 2.4 for now just changed colors to default blizz, but this could be done a lot better through the 
	internal wow buffer and wow filters
--]]
-- default settings
SW_UL_Settings = {
	FontSize = 8,
	SelectedActions = {},
	NarrowData = true,
};
--Maximum amount of stored comabt log messages
SW_UL_MAX_BUFFER = 10000;

SW_UL_GroupedColor = "|cffc0ffc0%s|r";
--SW_UL_HealMsgOH= "|cff40ff40%s|r(OH:%s)";
SW_UL_HealMsg= "|cff40ff40%s|r";
SW_UL_DmgMsg = "|cffff0000%s|r";
SW_UL_LineCount = 1;
SW_UL_LeechInfo = "%s %d~>%s %d => %s";
SW_UL_Timer = SW_C_Timer:new();

SW_UL_ActionList = SW_UL_FilterCollection.Actions;
SW_UL_ActionList.rev = {};
SW_UL_ActionList.init = function (self)
	for k,t in pairs(self) do
		if type(t) == "table" and t.id then
			self.rev[t.id] = t;
			if SW_UL_Settings.SelectedActions[t.id] == nil then
				SW_UL_Settings.SelectedActions[t.id] = true;
			end
		end
	end
end


SW_UL_SCHOOL_STR = {
	[1] = "|cffdddddd%s|r", --phys light grey
	[2] = "|cffFF59F5%s|r", -- holy hmm pinkish
	[4] = "|cffFF4949%s|r", -- fire red
	[8] = "|cff00C000%s|r", -- nature green
	[16] = "|cff8487FE%s|r", -- frost blue
	[32] = "|cffB0B0B0%s|r", -- shadow darker grey
	[64] = "|cffFFFF40%s|r", -- arcane yellow
	[200] = "|cffffffff%s|r", -- non school white
	[300] = "|cff87ffba%s|r", -- environmental dmg
	
	--temp update on entering world to blizz default
	setToBlizz = function(self)
		self[1] = "|c"..CombatLog_Color_FloatToText(COMBATLOG_DEFAULT_COLORS.schoolColoring[1]).."%s|r"; --phys
		self[2] = "|c"..CombatLog_Color_FloatToText(COMBATLOG_DEFAULT_COLORS.schoolColoring[2]).."%s|r"; -- holy 
		self[4] = "|c"..CombatLog_Color_FloatToText(COMBATLOG_DEFAULT_COLORS.schoolColoring[4]).."%s|r"; -- fire 
		self[8] = "|c"..CombatLog_Color_FloatToText(COMBATLOG_DEFAULT_COLORS.schoolColoring[8]).."%s|r"; -- nature 
		self[16] = "|c"..CombatLog_Color_FloatToText(COMBATLOG_DEFAULT_COLORS.schoolColoring[16]).."%s|r"; -- frost 
		self[32] = "|c"..CombatLog_Color_FloatToText(COMBATLOG_DEFAULT_COLORS.schoolColoring[32]).."%s|r"; -- shadow 
		self[64] = "|c"..CombatLog_Color_FloatToText(COMBATLOG_DEFAULT_COLORS.schoolColoring[64]).."%s|r"; -- arcane 
	end, 
}

function SW_UL_OnEvent()
	if (event == "ADDON_LOADED") then
		if arg1 ~= "SW_UniLog" then return; end
		SW_UL_ActionList:init();
		-- apply the sw stats visuals to our frame
		SW_StartupCheck_Visuals();
		
		SW_UL_ScrollSlider:SetMinMaxValues(1, 1);
		SW_UL_ScrollSlider:SetValue(1);
		SW_UL_ScrollSlider:SetValueStep(1) 
		SW_UL_UpdateColumns(SW_UL_Settings.FontSize);
		
		SW_EventDispatcher:register(SW_Types.Events.All,"SW_UL_CheckMsg");
		if SW_UL_Settings.ShowOnStart == nil then
			SW_UL_Settings.ShowOnStart = true;
		end
		if SW_UL_Settings.ShowOnStart then
			SW_UniLogFrame:Show();
		end
		SW_UL_ScrollSliderHigh:SetText("");
		SW_UL_ScrollSliderLow:SetText("");
		SW_UL_CreateFilters();
		if SW_UL_Settings.NarrowData == nil then
			-- decided to go false first because people dont tend to get what it's about
			-- and if they see the messages in a city .. will its obvious
			SW_UL_Settings.NarrowData = false;
		end
		SW_UL_Chk_NarrowData:SetChecked(SW_UL_Settings.NarrowData);
		if SW_UL_Settings.SortOrder then
			SW_UL_Buffer:switchSorting();
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		SW_UL_SCHOOL_STR:setToBlizz();
		SW_UL_UpdateLineAmount();
	end
end
SW_UL_TimerRedoLayout = 0;
SW_UL_TimerScrollUpdate = 0;
function SW_UL_OnUpdate()
	if SW_UL_TimerScrollUpdate > 0.1 then
		-- do it like this so we dont keep rebuilding the list
		-- while the user keeps clicking in the dropdown
		if SW_UL_ActionFilterDDSelectChanged then
			if (not DropDownList1) or (not DropDownList1:IsShown()) then
				SW_UL_ActionFilterDDApplyChanges();
			end
		end
		-- and the other point to put it on a timer is if your
		-- scrolling through large lists this can seriously kill your fps 
		-- without that 0.1 seconds pause
		if SW_UL_Buffer.updateDisplay then
			SW_UL_ScrollUpdate();
			SW_UL_Buffer.updateDisplay = false;
		end
		SW_UL_TimerScrollUpdate = 0;
	else
		SW_UL_TimerScrollUpdate = SW_UL_TimerScrollUpdate + arg1;
	end
	if SW_UniLogFrame.isResizing then
		if SW_UL_TimerRedoLayout > 0.5 then
			SW_UL_UpdateLineAmount();
			SW_UL_ScrollUpdate();
			SW_UL_TimerRedoLayout = 0;
		else
			SW_UL_TimerRedoLayout = SW_UL_TimerRedoLayout + arg1;
		end
	elseif SW_UL_TimerRedoLayout ~= 0 then 
		SW_UL_TimerRedoLayout = 0;
		SW_UL_UpdateLineAmount();
		SW_UL_ScrollUpdate();
	end
end
local SW_UL_EventSink = CreateFrame("Frame");
SW_UL_EventSink:SetScript("OnEvent", SW_UL_OnEvent);
SW_UL_EventSink:SetScript("OnUpdate", SW_UL_OnUpdate);
SW_UL_EventSink:RegisterEvent("ADDON_LOADED");
SW_UL_EventSink:RegisterEvent("PLAYER_ENTERING_WORLD");

function SW_UL_CheckMsg(oMsg)
	local v = oMsg:getBasicData();
	if not v then return end;

	if not SW_UL_Settings.NarrowData or (v.CurrGroupInfo or oMsg.IsDeath or oMsg.IsDestruction) then		
		SW_UL_Buffer:addMsg(oMsg);
	end
end

SW_UL_C_Entry = {
	
	From = -1, -- id in str table
	To = -1, -- id in str table
	What = -1, -- id or str
	UseLookup = false; -- is What id ?
	Action = nil, -- 'pointer' SW_UL_ActionList.xxx
	ms = 0,
	timestamp = 0,
	FullMsg = "",
	
	new = function (self, o)
		o = o or {};
		setmetatable(o, self);
		self.__index = self;
		
		return o;
	end,
	
	newFromMsg = function (self, oMsg)
		local o = {};
		setmetatable(o, self);
		self.__index = self;
		self.initFromMsg(o, oMsg);
		return o;
	end,
	reset = function (self)
		self.From = -1;
		self.To = -1;
		self.What = -1;
		self.UseLookup = false; 
		self.Action = nil;
		self.timestamp = 0;
		self.FullMsg = "";
	end,
	initFromMsg = function (self, oMsg)
		local v = oMsg:getBasicData();
		
		if not v then return end;
		local tmpStr;
		
		if self.timestamp ~= 0 then
			self:reset();
		end
		self.timestamp = oMsg.timestamp;
		self.ms = oMsg.ms;
		self.srcGUID = oMsg.srcGUID;
		
		self.FullMsg = arg2;
		if v.Source ~= SW_WORLD then
			self.From = SW_StrTable:getID(v.Source);
		end
		if v.Target ~= SW_WORLD then
			self.To = SW_StrTable:getID(v.Target);
		end
		
		if v.Damage then
			if v.IsCrit then
				tmpStr = "**";
			else
				tmpStr = "";
			end
			if v.Trailer then
				local t = v.Trailer;
				
				if t.Glancing == 1 then
					tmpStr = tmpStr.." <<";
				elseif t.Crushing == 1 then
					tmpStr = tmpStr.." >>";
				end
				-- an yes 1 message can have more than 1 trailer
				local num = t.Absorb + t.Block + t.Resist;
				if num > 0 then
					tmpStr = tmpStr.." << "..num;
				end
			end
			if v.Skill then
				tmpStr = tmpStr.." ["..v.Skill.."]";
			elseif oMsg.IsEnviro then
				tmpStr = tmpStr.." ["..SW_STR_ENVIRO.."]";
			end
			if v.SchoolID and SW_UL_SCHOOL_STR[v.SchoolID] then
				self.What = string.format(SW_UL_SCHOOL_STR[v.SchoolID],v.Damage..tmpStr);
			else 
				self.What = v.Damage..tmpStr;
			end
			if v.ScrapDamage then
				self.Action = SW_UL_ActionList.GRDamage
			elseif oMsg.IsPeriodic then
				self.Action = SW_UL_ActionList.DOT;
			else
				self.Action = SW_UL_ActionList.Damage;
			end
			
			--return true;
		elseif v.Heal then
			if v.IsCrit then
				tmpStr = "**";
			else
				tmpStr = "";
			end
			
			if v.Overheal > 0 then
				tmpStr = string.format(SW_UL_HealMsg,v.Heal..tmpStr).." (OH:"..v.Overheal..")";
			else
				tmpStr = string.format(SW_UL_HealMsg,v.Heal..tmpStr);
			end
			if v.Skill then
				tmpStr = tmpStr..string.format(SW_UL_HealMsg," ["..v.Skill.."]");
			end
			
			self.What = tmpStr;
			if oMsg.IsPeriodic then
				self.Action = SW_UL_ActionList.HOT;
			else
				self.Action = SW_UL_ActionList.Heal;
			end
			--return true;
		elseif oMsg.IsLeech or oMsg.IsDrain then
			self.Action = SW_UL_ActionList.Leech;
			local pt = SW_PowerTypes:getStr(oMsg.powerType);
			local ea = oMsg.extraAmount;
			ea = ea or "";
			
			self.What = oMsg.amount.." "..pt.." "..ea;
		elseif oMsg.IsSpellSteal then
			self.Action = SW_UL_ActionList.Leech;
			if v.Skill then
				self.What = SW_StrTable:getID(v.Skill);
				self.UseLookup = true; 
			else
				self.What = "";
			end
		elseif oMsg.IsEffectGot then
			if v.IsHarmfulEffect then
				self.Action = SW_UL_ActionList.NegEffectGot;
			elseif v.IsHelpfulEffect then
				self.Action = SW_UL_ActionList.PosEffectGot;
			else
				self.Action = SW_UL_ActionList.UnknownEffectGot;
			end
			
			if v.Effect then
				self.What = SW_StrTable:getID(v.Effect);
				self.UseLookup = true; 
			else
				self.What = "????";
			end
			
			--return true;
		elseif oMsg.IsEffectLost then
			if v.IsHarmfulEffect then
				self.Action = SW_UL_ActionList.NegEffectLost;
			elseif v.IsHelpfulEffect then
				self.Action = SW_UL_ActionList.PosEffectLost;
			else
				self.Action = SW_UL_ActionList.UnknownEffectLost;
			end
			
			if v.Effect then
				self.What = SW_StrTable:getID(v.Effect);
				self.UseLookup = true; 
			else
				self.What = "????";
			end
			--return true;
		
		elseif oMsg.IsCast then
			self.Action = SW_UL_ActionList.Cast;
			
			if oMsg.IsEnchant then 
				local ei = oMsg:getData(SW_Types.String.Item);
				if ei then
					if v.Skill then
						self.What = v.Skill.." ++ "..ei;
					else
						self.What = ei;
					end
				else
					if v.Skill then
						self.What = v.Skill;
					else
						self.What = "";
					end
				end
			elseif v.Skill and not string.find(v.Skill, "'s") then
				self.What = SW_StrTable:getID(v.Skill);
				self.UseLookup = true; 
			else
				if v.Skill then
					self.What = v.Skill;
				else
					self.What = "";
				end
			end
		elseif oMsg.IsDeath or oMsg.IsDestruction then
			self.Action = SW_UL_ActionList.Death;
			self.What = "";
			--return true;
		elseif oMsg.IsSlayInfo then
			self.Action = SW_UL_ActionList.Slay;
			self.What = "";
			--return true;
		elseif oMsg.IsDmgNullify then
			self.Action = SW_UL_ActionList.NullDmg;
			local mt = getglobal(oMsg.missType);
			mt = mt or "";
			
			if v.Skill then
				self.What = mt.." ["..v.Skill.."]";
				
			else
				
				self.What = mt;
			end
		elseif oMsg.IsGain then
			self.Action = SW_UL_ActionList.Gain;
			local gw,gn;
			
			gw = SW_PowerTypes:getStr(oMsg.gainType);
			
			gn = oMsg.gainAmount;
			if not gn then gn = 0; end
			self.What = gw.." + "..gn;
			if v.Skill then
				self.What = self.What.." ["..v.Skill.."]";
			end
		elseif oMsg.IsExtraAttack then
			self.Action = SW_UL_ActionList.ExtraAttacks;
			--SW_Types.Number.Attacks,SW_Types.String.Skill
			local ea = oMsg:getData(SW_Types.Number.Attacks);
			if not ea then ea = 0; end
			if v.Skill then
				self.What = ea.." ["..v.Skill.."]";
			else
				self.What = ea;
			end
		elseif oMsg.IsInterrupt then
			self.Action = SW_UL_ActionList.Interrupt;
			
			self.What = oMsg.spellName.." >> "..oMsg.exSpellName;
		else
			self.Action = SW_UL_ActionList.NoSpecial;
			self.What = "";
		end
		-- don't think this can eval to true 
		if v.IsCrit and not (v.Damage or v.Heal)then
			self.What = self.What.."**";
		end
		
	end,
	
	matchesFilter = function(self)
		local str;
		
		if not SW_UL_Settings.SelectedActions[self.Action.id] then
			return false;
		end
		if SW_UL_Settings.SotMode then
			if self.From == -1 then
				if self.To == -1 then
					return false;
				end
				str = SW_StrTable:getStr(self.To);
				if not SW_UL_Filters.FilterSource:checkStr(str) then
					return false;
				end
			else
				str = SW_StrTable:getStr(self.From);
				if not SW_UL_Filters.FilterSource:checkStr(str) then
					if self.To == -1 then
						return false;
					end
					str = SW_StrTable:getStr(self.To);
					if not SW_UL_Filters.FilterSource:checkStr(str) then
						return false;
					end
				end
			end
		else
			if SW_UL_Settings.FilterSource then
				if self.From == -1 then
					return false;
				end
				str = SW_StrTable:getStr(self.From);
				if not SW_UL_Filters.FilterSource:checkStr(str) then
					return false;
				end
			end
			if SW_UL_Settings.FilterTarget then
				if self.To == -1 then
					return false;
				end
				str = SW_StrTable:getStr(self.To);
				if not SW_UL_Filters.FilterTarget:checkStr(str) then
					return false;
				end
			end
		end
		if SW_UL_Settings.FilterWhat then
			if self.UseLookup then
				str = SW_StrTable:getStr(self.What);
			else
				str = self.What;
			end
			
			if not SW_UL_Filters.FilterWhat:checkStr(str) then
				return false;
			end
		
		end
		return true;
	end,

}

-- "copies" the layout width of the headers to the columns
-- fs is an optional param to set the font size
function SW_UL_UpdateColumns(fs)
	local line;
	for line=1,SW_UL_LineCount do
		SW_UL_UpdateOneItem(line, fs)
	end
end
function SW_UL_UpdateOneItem(line, fs)
	local tmpTxt;
	local tmpScale;
	
	tmpTxt = getglobal("SW_UniLogFrame_Item"..line.."_When_Text");
	tmpTxt:SetPoint("TOPLEFT", "SW_UniLogFrame_Item"..line, "TOPLEFT", 0,0);
	tmpTxt:SetWidth(SW_UL_F_When:GetWidth());
	if fs then
		tmpTxt:SetTextHeight(fs);
		tmpTxt:SetHeight(fs + 2);
	end
	
	tmpTxt = getglobal("SW_UniLogFrame_Item"..line.."_Source_Text");
	tmpTxt:SetPoint("TOPLEFT", "SW_UniLogFrame_Item"..line.."_When_Text", "TOPRIGHT", 2,0);
	tmpTxt:SetWidth(SW_UL_F_Source:GetWidth());
	if fs then
		tmpTxt:SetTextHeight(fs);
		tmpTxt:SetHeight(fs + 2);
	end
	
	tmpTxt = getglobal("SW_UniLogFrame_Item"..line.."_Action_Text");
	tmpTxt:SetPoint("TOPLEFT", "SW_UniLogFrame_Item"..line.."_Source_Text", "TOPRIGHT", 2,0);
	tmpTxt:SetWidth(SW_UL_F_Action:GetWidth());
	if fs then
		tmpTxt:SetTextHeight(fs);
		tmpTxt:SetHeight(fs + 2);
	end
	
	tmpTxt = getglobal("SW_UniLogFrame_Item"..line.."_Target_Text");
	tmpTxt:SetPoint("TOPLEFT", "SW_UniLogFrame_Item"..line.."_Action_Text", "TOPRIGHT", 2,0);
	tmpTxt:SetWidth(SW_UL_F_Target:GetWidth());
	if fs then
		tmpTxt:SetTextHeight(fs);
		tmpTxt:SetHeight(fs + 2);
	end
	
	tmpTxt = getglobal("SW_UniLogFrame_Item"..line.."_What_Text");
	tmpTxt:SetPoint("TOPLEFT", "SW_UniLogFrame_Item"..line.."_Target_Text", "TOPRIGHT", 2,0);
	tmpTxt:SetWidth(SW_UL_F_What:GetWidth());
	if fs then
		tmpTxt:SetTextHeight(fs);
		tmpTxt:SetHeight(fs + 2);
		-- fix distorted text
		tmpTxt = getglobal("SW_UniLogFrame_Item"..line);
		tmpScale = tmpTxt:GetScale();
		tmpTxt:SetScale(tmpScale + 0.01);
		tmpTxt:SetScale(tmpScale);
		tmpTxt:SetHeight(fs + 2);
	end
	
	
end
function SW_UL_SetScrollEntry(tmpEnt, line)
	local tmpLine;
	local tmpTxt;
	local tmpUnitName;
	tmpLine = getglobal("SW_UniLogFrame_Item"..line);
	
	if tmpEnt then
		tmpTxt = getglobal("SW_UniLogFrame_Item"..line.."_When_Text");
		tmpTxt:SetText(date("%H:%M:%S", tmpEnt.timestamp));
			
		tmpTxt = getglobal("SW_UniLogFrame_Item"..line.."_Source_Text");
		if tmpEnt.From == -1 then
			tmpTxt:SetText("");
		else
			tmpUnitName = SW_StrTable:getStr(tmpEnt.From);
			if tmpUnitName == SW_SELF_STRING then
				tmpUnitName = string.format(SW_UL_GroupedColor, tmpUnitName);
			end
			
			tmpTxt:SetText(tmpUnitName);
		end
		tmpTxt = getglobal("SW_UniLogFrame_Item"..line.."_Action_Text");
		tmpTxt:SetText(tmpEnt.Action.str);
		tmpTxt = getglobal("SW_UniLogFrame_Item"..line.."_Target_Text");
		
		if tmpEnt.To == -1 then
			tmpTxt:SetText("");
		else
			tmpUnitName = SW_StrTable:getStr(tmpEnt.To);
			if tmpUnitName == SW_SELF_STRING then
				tmpUnitName = string.format(SW_UL_GroupedColor, tmpUnitName);
			end
			tmpTxt:SetText(tmpUnitName);
		end
		
		tmpTxt = getglobal("SW_UniLogFrame_Item"..line.."_What_Text");
		if tmpEnt.UseLookup then
			tmpTxt:SetText(SW_StrTable:getStr(tmpEnt.What));
		else
			tmpTxt:SetText(tmpEnt.What);
		end
		tmpLine.EventData = tmpEnt;
		tmpLine:Show();
	else
		tmpLine:Hide();
	end
	
end
-- the slider update does not go through the timer
function SW_UL_SliderUpdate()
	--if not SW_UL_Settings.ShowOnStart then return; end
	
	local min, max, scale = SW_UL_Buffer.filteredLookup:getMinMaxScale();
	SW_UL_ScrollSlider:SetMinMaxValues(min, max);
	SW_UL_ScrollSlider:SetValueStep(scale);
	
	-- auto scroll top or bottom
	if SW_UL_Buffer.newestTop then
		if SW_UL_ScrollSlider:GetValue() <= min + scale then
			SW_UL_ScrollSlider:SetValue(min)
		end
	else
		if SW_UL_ScrollSlider:GetValue() >= max - scale then
			SW_UL_ScrollSlider:SetValue(max)
		end
	end
end

function SW_UL_ScrollUpdate()
	local line;
	local buffer = SW_UL_Buffer.filteredLookup;
	local min, max, scale = buffer:getMinMaxScale();
	SW_UL_ScrollSlider:SetMinMaxValues(min, max);
	SW_UL_ScrollSlider:SetValueStep(scale);
	
	local thresh = SW_UL_ScrollSlider:GetValue();
	if SW_UL_Buffer.newestTop then
		if thresh > min then
			--UIFrameFlash(SW_UL_ScrollSlider,0.5,0.5,1,true,0,0);
			buffer:goToIndex(max - thresh);
		else
			buffer:goToEnd();
		end
		for line=1, SW_UL_LineCount do
			tmpEnt = buffer:getPrev();
			SW_UL_SetScrollEntry(tmpEnt, line);
		end
	else
		if thresh < max then
			--UIFrameFlash(SW_UL_ScrollSlider,0.5,0.5,1,true,0,0);
			buffer:goToIndex(thresh);
		else
			buffer:goToEnd();
		end
		
		for line=SW_UL_LineCount, 1, -1 do
			tmpEnt = buffer:getPrev();
			SW_UL_SetScrollEntry(tmpEnt, line);
		end
	end
end

--[[ used to store table refs that may be nil
 allowing for gaps in the index numbering (and keeping an asc sort)
 these are ONLY references so no table overhead when setting to nil
 dont use as direct storage
 Why do all this hooplah ?
 we have a buffer reusing its tabels and a "sub buffer" pointing to a subset of those tables
 if a reused table changes its info and doesnt fit the old filtering.. w/o this we would be screwed
 (well we could use a table.remove but doing that at position 1 on a 10k entry table..nah)
 traversing this getNext getPrev dont work as one would think
 only use them exclusivly after a goToXXX or be sure to handle the double returns of one item
 
 --]]
SW_UL_C_NilTableBuffer = {
	new = function (self, o)
		o = o or {};
		setmetatable(o, self);
		self.__index = self;
		o.rvl = {}; -- a lookup table to index here
		o.minValidIndex = 1;
		o.maxValidIndex = 0;
		o.tablesHeld = 0;
		o.jumpToNextIndex = {}; -- a lookup to avoid long loops with large gaps
		o.jumpToPrevIndex = {}; -- a lookup to avoid long loops with large gaps
		o.currentGetIndex = 0;
		return o;
	end,
	add = function (self, table)
		if not table then return end;
		
		self:remove(table);
		self.maxValidIndex = self.maxValidIndex + 1;
		self[self.maxValidIndex] = table;
		self.rvl[table] = self.maxValidIndex;
		self.tablesHeld = self.tablesHeld + 1;
	end,
	remove = function (self, table)
		if not table then return end;
		local tmp = self.rvl[table];
		if tmp then
			self:_removeIndex(tmp);
			self.rvl[table] = nil;
		end
	end,
	
	_removeIndex = function (self, index)
		if not self[index] then return end;
		
		local newIndex;
		self.tablesHeld = self.tablesHeld - 1;
		self[index] = nil;
		if index <= self.minValidIndex then
			newIndex = index;
			while not self[newIndex] do
				if newIndex > self.maxValidIndex then
					-- no valid entries left;
					break;
				end
				newIndex = newIndex + 1;
			end
			self.minValidIndex = newIndex;
		end
		
	end,
	
	goToStart = function (self, offset)
		self.currentGetIndex = self.minValidIndex;
	end,
	goToEnd = function (self, offset)
		self.currentGetIndex = self.maxValidIndex;
	end,
	goToIndex = function (self, index)
		if index < self.minValidIndex then
			index = self.minValidIndex;
		elseif index > self.maxValidIndex then
			index = self.maxValidIndex 
		end
		self.currentGetIndex = index;
		return index;
	end,
	getNext = function (self)
		local startedAt = self.currentGetIndex;
		local ret;
		while self.currentGetIndex <= self.maxValidIndex do
			
			if self[self.currentGetIndex] then
				if startedAt < self.currentGetIndex - 1 then
					self.jumpToNextIndex[startedAt] = self.currentGetIndex;
				end
				ret = self[self.currentGetIndex];
			end
			if self.jumpToNextIndex[self.currentGetIndex] then
				self.currentGetIndex = self.jumpToNextIndex[self.currentGetIndex]
			else
				self.currentGetIndex = self.currentGetIndex  + 1;
			end
			if ret then
				return ret;
			end
		end
		
		return nil;
	end,
	getPrev = function (self)
		local startedAt = self.currentGetIndex;
		local ret;
		while self.currentGetIndex >= self.minValidIndex do
			
			if self[self.currentGetIndex] then
				if startedAt > self.currentGetIndex + 1 then
					self.jumpToPrevIndex[startedAt] = self.currentGetIndex;
				end
				ret = self[self.currentGetIndex];
			end
			if self.jumpToNextIndex[self.currentGetIndex] then
				self.currentGetIndex = self.jumpToPrevIndex[self.currentGetIndex]
			else
				self.currentGetIndex = self.currentGetIndex  - 1;
			end
			if ret then
				return ret;
			end
		end
		
		return nil;
	end,
	isEmpty = function (self) 
		return (self.minValidIndex > self.maxValidIndex);
	end,
	getMinMaxScale = function (self)
		if self.tablesHeld == 0 then
			return 1,1,1;
		end
		local i = math.floor((self.maxValidIndex - self.minValidIndex) / self.tablesHeld);
		if i < 1 then 
			i = 1;
		end
		return self.minValidIndex, self.maxValidIndex, i;
	end,
	dump = function (self)
		SW_printStr(self.minValidIndex);
		SW_printStr(self.maxValidIndex);
		SW_printStr(self.tablesHeld);
		SW_DumpTable(self.jumpToNextIndex);
		SW_DumpTable(self.jumpToPrevIndex);
		SW_printStr(self.currentGetIndex);
	end,
}

SW_UL_C_Buffer = {
	maxEntries = SW_UL_MAX_BUFFER,
	bufferLowIndex = 1,
	currentIndex = 0,
	
	newestTop = false,
	-- the internal filtered buffer
	-- just using references to the real tables
	--filteredLookup,
	
	new = function (self, o)
		o = o or {};
		setmetatable(o, self);
		self.__index = self;
		o.filteredLookup = SW_UL_C_NilTableBuffer:new();
		return o;
	end,
	
	addMsg = function (self, oMsg)
		if not oMsg then return; end
		self.currentIndex = self.currentIndex + 1;
		if self.currentIndex <= self.maxEntries then
			self[self.currentIndex] = SW_UL_C_Entry:newFromMsg(oMsg);
		end
		if self.currentIndex > self.maxEntries then
			self[self.currentIndex] = self[self.currentIndex - self.maxEntries];
			self[self.currentIndex - self.maxEntries] = nil;
			self[self.currentIndex]:initFromMsg(oMsg);
		end
		if self[self.currentIndex]:matchesFilter() then
			self.filteredLookup:add(self[self.currentIndex]);
		else
			self.filteredLookup:remove(self[self.currentIndex]);
		end
		self.bufferLowIndex = self.currentIndex - self.maxEntries + 1;
		if self.bufferLowIndex < 1 then
			self.bufferLowIndex = 1;
		end
		
		SW_UL_SliderUpdate();
		self.updateDisplay = true;
		return self[self.currentIndex];
	end,
	rebuildFiltered = function (self)
		-- this new is acceptable, only kills a few tables on user interaction.. not 10k like in the first beta
		self.filteredLookup = SW_UL_C_NilTableBuffer:new();
		for i=self.bufferLowIndex, self.currentIndex do
			if self[i]:matchesFilter() then
				self.filteredLookup:add(self[i]);
			end
		end
	end,

	switchSorting = function (self)
		local min, max, scale = self.filteredLookup:getMinMaxScale();
		self.newestTop = not self.newestTop;
		SW_UL_Settings.SortOrder = self.newestTop;
		if self.newestTop then
			getglobal("SW_UL_F_WhenArrow"):SetTexCoord(0, 0.5625, 1.0, 0);
			
			SW_UL_ScrollSlider:SetValue(min);
		else
			getglobal("SW_UL_F_WhenArrow"):SetTexCoord(0, 0.5625, 0, 1.0);
			SW_UL_ScrollSlider:SetValue(max);
		end
		self.updateDisplay = true;
	end,
}
SW_UL_Buffer = SW_UL_C_Buffer:new();

function SW_UL_UpdateLineAmount()
	local itemHeight = SW_UniLogFrame_Item1:GetHeight();
	local tmpLine;
	local newFrame;
	local currLine = 1;
	
	-- create/show new lines as needed
	tmpLine = SW_UniLogFrame_Item1;
	tmpLine:SetBackdropColor(0,0,0,0);
	if not (tmpLine:GetBottom() and SW_UniLogFrame:GetBottom() and itemHeight) then return end
	while SW_UniLogFrame:GetBottom() < tmpLine:GetBottom() - itemHeight - 5 do
		currLine = currLine + 1;
		tmpLine = getglobal("SW_UniLogFrame_Item"..currLine);
		if tmpLine then
			SW_UL_UpdateOneItem(currLine, SW_UL_Settings.FontSize);
			tmpLine:Show();
		else
			newFrame = CreateFrame("Button", "SW_UniLogFrame_Item"..currLine, SW_UniLogFrame, "SW_UL_Item");
			newFrame:SetPoint("TOPLEFT", "SW_UniLogFrame_Item"..currLine - 1, "BOTTOMLEFT");
			newFrame:SetPoint("TOPRIGHT", "SW_UniLogFrame_Item"..currLine - 1, "BOTTOMRIGHT");
			newFrame:SetBackdropColor(0,0,0,0);
			SW_UL_UpdateOneItem(currLine, SW_UL_Settings.FontSize);
			tmpLine = newFrame;
		end
	end
	SW_UL_LineCount = currLine;
	-- hide old lines as needed
	currLine = currLine + 1;
	tmpLine = getglobal("SW_UniLogFrame_Item"..currLine);
	while tmpLine do
		tmpLine:Hide();
		currLine = currLine + 1;
		tmpLine = getglobal("SW_UniLogFrame_Item"..currLine);
	end
	SW_UL_Buffer.updateDisplay = true;
end

function SW_UL_ChangeFontSize(fs)
	SW_UL_Settings.FontSize = fs;
	SW_UL_UpdateColumns(fs);
	SW_UL_UpdateLineAmount();
end

function SW_UL_ActionFilterDD_Initialize()
	local tmpButton = {};
	for i, t in ipairs(SW_UL_ActionList.rev) do
		tmpButton.text = t.str;
		tmpButton.func = SW_UL_ActionFilterDDSelect;
		tmpButton.arg1 = i; -- infoNumber
		tmpButton.keepShownOnClick = true;
		tmpButton.checked = SW_UL_Settings.SelectedActions[i];
		if t.Explain then
			tmpButton.tooltipTitle = t.str;
			tmpButton.tooltipText = t.Explain;
		end
		UIDropDownMenu_AddButton(tmpButton);
	end
end

SW_UL_ActionFilterDDSelectChanged = false;
function SW_UL_ActionFilterDDSelect(id)
	SW_UL_ActionFilterDDSelectChanged = true;
	SW_UL_Settings.SelectedActions[id] = not SW_UL_Settings.SelectedActions[id];
	
end
function SW_UL_ActionFilterDDApplyChanges()
	SW_UL_ActionFilterDDSelectChanged = false;
	SW_UL_Buffer:rebuildFiltered();
	local min, max, scale = SW_UL_Buffer.filteredLookup:getMinMaxScale();
	SW_UL_ScrollSlider:SetMinMaxValues(min, max);
	SW_UL_ScrollSlider:SetValueStep(scale);
	if SW_UL_Buffer.newestTop then
		SW_UL_ScrollSlider:SetValue(min);
	else
		SW_UL_ScrollSlider:SetValue(max);
	end
	SW_UL_Buffer.updateDisplay = true;
end
SW_UL_C_Filter = {
	new = function (self, o)
		o = o or {};
		setmetatable(o, self);
		self.__index = self;
		if not o.FilterCol then
			o.FilterCol = {};
		end
		return o;
	end,
	newFromStr = function (self, str)
		o = {};
		setmetatable(o, self);
		self.__index = self;
		o.FilterCol = {};
		
		o:updateFilter(str);
		return o;
	end,
	
	updateFilter = function (self, str)
		self.ErrMsg = nil;
		self.FilterStr = str;
		for k in pairs(self.FilterCol) do
			self.FilterCol[k] = nil;
		end
		
		if not str then return; end
		if SW_UL_Settings.SotMode then
			str = gsub(str, "/sot", "");
		end
		if string.find(str, "|") then
			if not string.find(str, "|$") then
				str = str.."|";
			end
			for w in string.gmatch(str, "(.-)|") do
				self:addOneFilter(w);
			end 
		else
			self:addOneFilter(str);
		end
		
	end,
	addOneFilter = function (self, str)
		local tmp;
		-- if it's a slash command spaces are not allowed
		if string.find(str, "/") then
			tmp = string.gsub(str, " ", "");
		else
			if strlen(gsub(str, " ", "")) == 0 then
				return;
			end
			tmp = str;
		end
		
		if string.find(str, "/eg") then
			self.FilterCol[str] = self.everGroup;
		elseif string.find(str, "/cg") then
			self.FilterCol[str] = self.currentGroup;
		elseif string.find(str, "/pet") then
			self.FilterCol[str] = self.isPet;
		elseif string.find(str, "/c=") then
			if strlen(string.gsub(tmp, "/c=", "")) > 0 then
				self.FilterCol[tmp] = self.isClass;
			else
				self.ErrMsg = "Usage: /c=Class Class is missing"
			end
		else
			self.FilterCol[str] = self.findStr;
		end
	end,
	
	-- does the passed str fit any of our filters?
	checkStr = function(self, str)
		-- is this an empty filter?
		if not self.FilterStr then
			return true;
		end
		-- don't apply a faulty filter
		if self.ErrMsg then
			return true;
		end
		for var,func in pairs(self.FilterCol) do
			if func(self, str, var) then
				return true;
			end
		end
		return false;
	end,
	checkClassMeta = function(self, meta, filter)
		if meta and meta.classE then
			if string.find(meta.classE, filter) then
				return true;
			end
			if string.find(SW_ClassNames[meta.classE], filter) then
				return true;
			end
		end
		return false;
	end,
	currentGroup = function (self, str, filter)
		local meta = SW_DataCollection.meta.currentGroup[str];
		if meta then
			if string.find(filter, "=") then
				filter = string.gsub(filter, "/cg=", "");
				meta = SW_DataCollection.meta[meta.sID]
				if self:checkClassMeta(meta, filter) then
					return true;
				end
			else
				return true;
			end
		end
		return false;
	end,
	
	everGroup = function (self, str, filter)
		local sID = SW_StrTable:hasID(str);
		if sID and SW_DataCollection.meta.everGroup[sID] then
			if string.find(filter, "=") then
				filter = string.gsub(filter, "/eg=", "");
				if self:checkClassMeta(SW_DataCollection.meta[sID], filter) then
					return true;
				end
			else
				return true;
			end
		end
		return false;
	end,
	isPet = function (self, str, filter)
		if SW_DataCollection.meta.currentPets[str] then
			local sID = SW_StrTable:hasID(SW_PET..str);
			if sID and SW_DataCollection.meta[sID] then
				if string.find(filter, "=") then
					filter = string.gsub(filter, "/pet=", "");
					if self:checkClassMeta(SW_DataCollection.meta[sID], filter) then
						return true;
					end
				else
					return true;
				end
			else
				return true;
			end
		end
		return false;
	end,
	isClass = function (self, str, filter)
		filter = string.gsub(filter, "/c=", "");
		local tmp = SW_StrTable:hasID(str);
		if tmp then
			tmp = SW_DataCollection.meta[tmp];
			return self:checkClassMeta(tmp, filter);
		end
		return false;
	end,
	findStr = function (self, str, regEx)
		if string.find(str,regEx) then
			return true;
		end
		return false;
	end,
}
function SW_UL_CreateFilters()
	SW_UL_Filters = {};
	SW_UL_Filters.FilterTarget = SW_UL_C_Filter:newFromStr(SW_UL_Settings.FilterTarget);
	SW_UL_Filters.FilterSource = SW_UL_C_Filter:newFromStr(SW_UL_Settings.FilterSource);
	SW_UL_Filters.FilterWhat = SW_UL_C_Filter:newFromStr(SW_UL_Settings.FilterWhat);	
end
function SW_UL_HandleEdit(editBox, dataName)
	local txt = editBox:GetText();
	if strlen(gsub(txt, " ", "")) == 0 then
		txt = nil;
	end
	
	if dataName == "FilterSource" then
		if txt and string.find(txt, "/sot") then
			SW_UL_Settings.SotMode = true;
		else
			SW_UL_Settings.SotMode = false;
		end
	end
	SW_UL_Settings[dataName] = txt;
	if not SW_UL_Filters[dataName] then
		SW_UL_Filters[dataName] = SW_UL_C_Filter:newFromStr(txt)
	else
		SW_UL_Filters[dataName]:updateFilter(txt);
	end
	SW_UL_Buffer:rebuildFiltered();
	local min, max, scale = SW_UL_Buffer.filteredLookup:getMinMaxScale();
	SW_UL_ScrollSlider:SetMinMaxValues(min, max);
	SW_UL_ScrollSlider:SetValueStep(scale);
	
	if SW_UL_Buffer.newestTop then
		SW_UL_ScrollSlider:SetValue(min);
	else
		SW_UL_ScrollSlider:SetValue(max);
	end
	SW_UL_Buffer.updateDisplay = true;
end

function SW_UL_HandleFilterBox(box)
	local dataName = gsub(box:GetName(), "SW_UL_", "");
	if box:IsVisible() then
		box:Hide();
		SW_UL_HandleEdit(box, dataName);
	else
		if SW_UL_Settings[dataName] then
			box:SetText(SW_UL_Settings[dataName]);
		end
		box:Show();
		box:SetFocus();
	end
end


-- because we are using the string table nuking invalidates our strings
-- maybe add an event for nuking to sw stats - ok for now.
local SW_UL_OldNuke = SW_NukeDataCollection;
function SW_UL_NukeDataCollection()
	SW_UL_Buffer = SW_UL_C_Buffer:new();
	SW_UL_SliderUpdate();
	SW_UL_Buffer.updateDisplay = true;
	SW_UL_OldNuke();
end
SW_NukeDataCollection = SW_UL_NukeDataCollection;

function SW_UL_SlashHandler(msg)
	if msg == nil then return; end
	
	local _,_, c, v = string.find(msg, "([^ ]+) (.+)");
	if c == nil then
		c = string.gsub(msg, " ", "");
	end
	
	if c == "" then
		if SW_UniLogFrame:IsVisible() then
			SW_UniLogFrame:Hide();
		else
			SW_UniLogFrame:Show();
		end	
	elseif c == SW_UL_L.Cmd.FontSize then
		if tonumber(v) then
			SW_UL_ChangeFontSize(tonumber(v));
		end
	else
		
		for k, v in pairs (SW_UL_L.Cmd) do
			DEFAULT_CHAT_FRAME:AddMessage(string.format(SW_UL_L.CommandListItem, v, SW_UL_L.CmpExplain[k]));
		end
	end
	
end
-- setup the slash handlers
SlashCmdList["SW_UNILOG"] = SW_UL_SlashHandler;
SLASH_SW_UNILOG1 = "/swunilog";
SLASH_SW_UNILOG2 = "/swl";

function SW_UL_CopyToCopyBox(entry)
	local str = SW_StrTable:getStr(entry.To);
	if not str then
		return;
	end
	str = "/target "..str;
	--[[ doesnt work :/ cant queue them up like that
	local action;
	if entry.UseLookup then
		action = SW_StrTable:getStr(entry.What);
		if action then
			str = str.." /cast "..action;
		end
	end
	--]]
	SW_UL_CopyBox:SetText(str);
	SW_UL_CopyBox:Show();
	SW_UL_CopyBox:HighlightText();
end