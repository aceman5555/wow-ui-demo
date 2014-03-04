if not HCoold then return false end
local L = HCoold:GetLocale()
--[[
GetClassInfo
NotifyInspect
GetNumGroupMembers
GetRaidRosterInfo
CheckInteractDistance
GetTime
CanInspect
GetNumClasses
GetPlayerInfoByGUID
GetTalentInfo
GameTooltip
UIDropDownMenu_AddButton
StaticPopupDialogs
StaticPopup_Show
GetAddOnMetadata
GetCursorPosition
UIParent
ToggleDropDownMenu
UnitBuff
UnitName
GetSpellInfo
GetSpellLink
SendChatMessage
UnitHealth
IsEncounterInProgress
GetInstanceInfo
--]]

function HCoold:CheckGridIntegration()
	if self.grid and HCoold.db.profile.grid_integration then return true end
	return false
end

function HCoold:NumRaidMembers()
	if self.db.profile.raid_only and (not IsInRaid()) then return 0 end
	return GetNumGroupMembers()
end	

local tracking_list = {} -- массив для забивания заклинаний, которые мы отслеживаем (для ускорения процесса)
                         -- формат id.name = true
function HCoold:GetRaidList() --+ get list of raid members with it's cd's
	local out = {}
	tracking_list = {}
	for i = 1, self:NumRaidMembers() do
		local name = GetRaidRosterInfo(i) -- , _, subgroup, _, _, class, _, online, isDead
		if self:IsInRaid(name) then 
			local ins = {
				name = name,
				CDs = self:GetCDs(self:GetSpec(i))
			}
			table.insert(out,ins)
		
			-- теперь пройдемся по массиву CDs и забьем трекинг спеллов в массив tracking_list
			for _, v in next, ins.CDs do
				tracking_list[string.format("%d.%s",v.spellID,name)] = true
				if v.trigger then for _, k in next, v.trigger do tracking_list[string.format("%d.%s",k,name)] = true end end
			end
		end
	end

	return out
end

function HCoold:IsTrackSpell(spellID,name) 
	if tracking_list[string.format("%d.%s",spellID,name)] then 
		-- сначала ищем ручками добавленное заклинание
		local s = self:GetManualSpell(spellID, name)
		if s then return s end
		
		-- теперь заклинания из общего списка
		for _,v in pairs(self.spells) do 
			if v.spellID == spellID then return v end 
			if v.trigger then for _, k in next, v.trigger do if k == spellID then return v end end end
		end
	end
	
	return false
end

function HCoold:IsInRaid(player)
	for i = 1, self:NumRaidMembers() do
		local name, _, subgroup = GetRaidRosterInfo(i)
			if name == player and subgroup <= HCoold.db.profile.group_track then return true end
	end
	return false
end

function HCoold:GetSpec(inc) --+ get player's spec
	local out = {}
	if not tonumber(inc) then 
		for i = 1, self:NumRaidMembers() do
			if select(1,GetRaidRosterInfo(i)) == inc then
				inc = i
			end
		end
	end
	if not tonumber(inc) then return out end
	
	out.name, out.class = select(1,GetRaidRosterInfo(inc)), select(6,GetRaidRosterInfo(inc))
	out.spec = self.db.faction.players[out.name] or 0
	return out
end

function HCoold:CompairSpellID(i, j)
	local iAr, jAr = { i.spellID }, { j.spellID }
	if i.trigger then for _, k in next, i.trigger do table.insert(iAr, k) end end
	if j.trigger then for _, k in next, j.trigger do table.insert(jAr, k) end end
	local test = false
	for _, ii in next, iAr do for _, jj in next, jAr do 
		if ii == jj then test = true 
	end end end
	return test
end

function HCoold:GetCDs(inp) --+ get cd's for current class+spec    ---  inp = {name, class, spec}
	local out, check = {}, {}
	-- сначала добавляем ручками добавленные заклинания
	for _,i in next, self.db.faction.PlayersSpells do 
		local dd = false
		if i.player == inp.name and self.db.profile.trackManualSpells[self:ManualSpellIndex(i)] then dd = true end
		-- check specs first
		if dd then for _,k in next, i.specs do if not (k == inp.spec or k == 0) then dd = false end end end
		if dd then
			table.insert(out,i)
			table.insert(check,i)
		end
	end
	
	-- теперь добавляем таланты не забывая убивать повторы и добавлять в лист проверок
	local tal = self:GetTalentSpell(inp)
	for _, v in next, tal do
		local succ = true
		for _, k in next, check do 
			if self:CompairSpellID(k, v) then succ = false end 
		end
		if succ then
			table.insert(out, v)
			table.insert(check, v)
		end
	end
	
	-- теперь добавляем все заклинания по данному классу/спеку не забывая убивать повторяющиеся
	for _,v in next, self.spells do
		if v.class == inp.class then
			local succ = false
			for _,k in next, v.specs do if k == inp.spec or k == 0 then succ = true end end
			for _,k in next, check do if self:CompairSpellID(k, v) then succ = false end end
			if succ then table.insert(out,v) end
		end
	end
	
	-- ну а теперь надо добавить залинания от симбиоза
	local symb = self:GetSymbiosysSpell(inp)
	for _, v in next, symb do 
		local succ = true
		for _,k in next, check do if self:CompairSpellID(k, v) then succ = false end end
		if succ then table.insert(out,v) end
	end
	wipe(check)
	
	return out
end

function HCoold:GetSpellBySpec(id,spec) -- return link to spell by spec and id
	for _,i in next, self.spells do
		local do_ = false
		if i.spellID == id then do_ = true end
		if i.trigger then for _, k in next, i.trigger do if k == id then do_ = true end end end
		if do_ then for _,j in next, i.specs do if j == spec or j == 0 then return i end end end
	end
	return nil
end

function HCoold:DeleteSpells() --+ delete spells if player change spec etc...
	local raid = self:GetRaidList()
	
	for _, i in next, self.types do
		-- for each type of spells
		for k = # i.spells, 1, -1 do
			local j = i.spells[k]
			-- for each spell check, if it's in CDs of raid
			local find = false
			for _,p in next, raid do
				if p.name == j.player then
					for _,s in next, p.CDs do
						if s.spellID == j.id then find = true end
					end
				end
			end
			if not find then
				j:Hide()
				table.remove(i.spells,k)
			end
		end
		i:SortSpells()
	end
end

do --+ frame renew actions
	function HCoold:RenewStatus() --+ renew status of frames
		-- for each raid cd's type run own Update() function
		for _, i in next, self.types do i:Update() end
		-- обновляем грид
		if self.grid then
			self.grid:UpdateAllUnits()
		end
	end

	function HCoold:StartCD(...) --+ start cd for player's spell
		--[[
			... = 
				player
				spell
		]]
		local player, spell = ...
		
		local curr = self:GetSpell(player, spell.spellID)
		if curr == nil then return end
		curr:StartCD()
		self:AnnounceCDStart(curr)
		self:SaveSessionCDs(curr)
	end
	
	function HCoold:AnnounceCDStart(spell)
		local spName, _, icon = GetSpellInfo(spell.id)
		local spname = spName
		local spLink = GetSpellLink(spell.id)
		if spLink ~= nil then spName = spLink end

		local out = string.format(L["%s casted %s."],spell.player,spName)
		if self.db.profile.ann.s_self then self:Chat(out) end
		--[[
		if self:CheckGridIntegration() and self.grid then
			-- self:Print("ann start grid")
			self.grid:SetCD(spell.guid, icon, spname, GetTime(), HCoold:GetDiff(spell.state_cd_end))
		end
		--]]
	end

	function HCoold:AnnounceCDEnd(spell) -- announce end CD of spell
		local conf = self.db.profile.ann
		
		local spName, _, icon = GetSpellInfo(spell.id)
		local spname = spName
		local spLink = GetSpellLink(spell.id)
		if spLink ~= nil then spName = spLink end
		if spName == nil then self:Printf("Empty return of GetSpellInfo() and GetSpellLink() HCoold:AnnounceCDEnd(spell)"); return end
		local player = spell.player
		
		local out = string.format(L["Spell %s of %s is ready!"],spName,player)
		
		local has_ass = false
		local our_name = UnitName("player")
		for i = 1, self:NumRaidMembers() do
			local name, rank = GetRaidRosterInfo(i)
			if name == our_name then has_ass = true end
		end
		
		self:AnnounceCDEndAddons(out,icon)
		
		if conf.self then self:Chat(out) end
		
		if conf.only_rl and (not has_ass) then return end -- if don't have accistance
		
		if conf.rw then SendChatMessage(out,"RAID_WARNING") end
		if conf.raid then SendChatMessage(out,"RAID") end
		if conf.party then SendChatMessage(out,"PARTY") end
		if conf.say then SendChatMessage(out,"SAY") end
		if conf.yell then SendChatMessage(out,"YELL") end
	end

	function HCoold:AnnounceCDEndAddons(out,icon) -- announce end CD of spell
		self:RegisterBossMods()
		local conf = self.db.profile.ann.addons
		if self.bw and conf.bw then
			self.bw:SendMessage("BigWigs_Message", nil, nil, out, "Positive", true, "BigWigs: Info", nil, icon)
		end
		if self.dxe and conf.dxe then
			self.dxe:Simple(out,5,"ALERT10","GREEN", nil, icon)
		end
		if self.dbm and conf.dbm then
			local na = self.dbm:NewAnnounce("%s", 1, icon)
			na:Show(out)
		end
	end
end

do --+ actions with time
	local max_diff = -1
	local count = 0
	local max_count = 100
	local function hundr()
		if count < max_count then
			local tmp = time() - GetTime()
			if max_diff == -1 then max_diff = tmp end
			max_diff = math.max(max_diff,tmp)
			count = count+1
		end
	end
	
	function HCoold:GetEndTime(delay) -- return timestamp+delay
		hundr()
		return GetTime() + max_diff + delay
	end
	
	function HCoold:GetTime()
		hundr()
		return GetTime() + max_diff
	end

	function HCoold:GetDiff(end_time) -- return time - end_time
		hundr()
		return end_time - (GetTime() + max_diff)
	end

	function HCoold:GetTextDiff(end_time) -- return time - end_time in "mm:ss" format
		local tt = self:GetDiff(end_time)
		local diff = math.floor(tt)
		local hundr = tt - diff
		if diff < self.db.profile.timer_min_diff then return string.format("%.1f",tt) end
		if diff < 60 and diff >= self.db.profile.timer_min_diff then return string.format("%d",diff) end
		if diff >= 60 then
			local min_ = math.floor(diff / 60)
			local sec = diff - min_*60
			if sec < 0 then 
				min_ = min_ - 1
				sec = sec + min_ * 60
			end
			if sec < 10 then sec = "0" .. sec end
			return string.format("%d:%s",min_,sec)
		end
	end

	function HCoold:GetColor(...) -- return color, quality of spell
		--[[
			1 - supergood
			2 - good
			3 - bad
			4 - dead
			5 - offline
			6 - casting
			7 - cooldown
		]]
		local spellID, player = ...
		local quality = nil
		for i = 1, self:NumRaidMembers() do if select(1,GetRaidRosterInfo(i)) == player then
			local isDead = select(9,GetRaidRosterInfo(i))
			local online = select(8,GetRaidRosterInfo(i))
			if not online then quality = 5 end
			if isDead then quality = 4 end
		end end
		
		local spec = HCoold:GetSpec(player)
		local spell = HCoold:GetSpellBySpec(spellID,spec.spec)
		spell = self:GetManualSpell(spellID, player) or spell
		if spell then 
			quality = quality or spell.quality 
		end
		
		quality = quality or 1
		local color = HCoold:GetColorByQuality(quality)
		
		return color, quality
	end

	function HCoold:GetColorByQuality(q) -- return color by quality of color
		local color = ""
		if q == 1 then color = self.db.profile.color.bad
		elseif q == 2 then color = self.db.profile.color.good
		elseif q == 3 then color = self.db.profile.color.supergood
		elseif q == 4 then color = self.db.profile.color.dead
		elseif q == 5 then color = self.db.profile.color.offline
		elseif q == 6 then color = self.db.profile.color.active
		elseif q == 7 then color = self.db.profile.color.cd
		end
		return color
	end
end

function HCoold:GetSpell(...) --+ get frame of spell by id and player name
	local player, spellID = ...
	for _,v in next, self.types do -- for each type of cd 
		for _,i in next, v.spells do -- for each spell run spell:IsSpell
			if i:IsSpell(spellID,player) then
				return i
			end
		end
	end
	
	return nil
end

do -- lock/unlock frames
	function HCoold:UnlockFrames()
		for _,i in next, self.types do i.cont:Show() end
		if self.activeSpells then self.activeSpells.anchor:Show() end
	end
	
	function HCoold:LockFrames()
		for _,i in next, self.types do i.cont:Hide() end
		if self.activeSpells then self.activeSpells.anchor:Hide() end
	end

	function HCoold:WIPE()
		if not self.types then return end
		for _,i in next, self.types do
			i:Hide()
		end
		if self.activeSpells then self.activeSpells.anchor:Hide() end
	end
	
	function HCoold:DrawNew()
		self:SymbiosysManage()
		self:MakeSpellList() -- making spells for tracking from setup
		self:MakeSpellGroups() -- making frames for align spells
		self:CheckPlayersCDs()
		self:ClearSessionCD()
	end
end

function HCoold:GetManualSpell(id, player)
	for _,i in next, self.db.faction.PlayersSpells do 
		local is_id = false
		if i.trigger then for _, k in next, i.trigger do if k == id then is_id = true end end end
		if i.spellID == id then is_id = true end
		if is_id and i.player == player and self.db.profile.trackManualSpells[self:ManualSpellIndex(i)] then 
			-- check spec first
			local spec = self:GetSpec(player)
			for _, j in next, i.specs do
				if spec.spec == j or j == 0 then
					return i 
				end
			end
		end
	end
	
	-- теперь выдадим заклинания от симбиоза
	local symb = self:GetSymbiosysSpell(player)
	for _, i in next, symb do
		local is_id = false
		if i.trigger then for _, k in next, i.trigger do if k == id then is_id = true end end end
		if i.spellID == id then is_id = true end
		if is_id and self.db.profile.trackSpells[self:SymbiosysSpellIndex(i)] then return i end
	end
	
	-- ну а теперь заклинания от автоопределения талантов
	local tal = self:GetTalentSpell(player)
	for _, i in next, tal do
		local is_id = false
		if i.trigger then for _, k in next, i.trigger do if k == id then is_id = true end end end
		if i.spellID == id then is_id = true end
		if is_id and self.db.profile.trackSpells[self:TalentIndex(i)] then return i end
	end
	
	return nil
end

function HCoold:ManualSpellIndex(i)
	local specs, spellID, first = "", tostring(i.spellID), ""
	if i.specs then for _, k in next, i.specs do 
		specs = string.format("%s%s%d",specs,first,k)
		first = ","
	end end
	if i.trigger then
		for _, k in next, i.trigger do
			spellID = string.format("%s%s%d",spellID, "-", k)
		end
	end
	local index = string.format("%s.%s.%d.%s.%s.%d.%.1f.%s",spellID,i.type,i.quality,specs,i.player,i.CD,i.cast_time or 0,i.succ)
	return index
end

do -- actions with symbiosys spell
	function HCoold:SymbiosysApplied(druid_name, player_name) -- применение симбиоза
		local druids_arr = self.db.profile.druids_arr

		-- если на игроке висел симбиоз, то его надо удалить
		for i, j in next, druids_arr do if j == player_name then druids_arr[i] = nil end end

		-- теперь надо данному друиду забить имя этого игрока
		druids_arr[druid_name] = player_name
		
		-- ну а теперь обновить фреймы
		self:CheckPlayersCDs()
	end

	function HCoold:SymbiosysRemoved(druid_name) -- пропал симбиоз
		local druids_arr = HCoold.db.profile.druids_arr
		if druids_arr[druid_name] then 
			druids_arr[druid_name] = nil 
			self:CheckPlayersCDs()
		end
	end
	
	function HCoold:CheckSymbiosys(inp) -- проверка запускаемая из анализа лога для симбиоза
			--[[
			... :
				2 - timestamp
				3 - event
				6 - sourceName
				10 - destName
					SPELL:
						13 - spellID
						14 - spellName
						15 - spellSchool
					_AURA_APPLIED
					_AURA_REMOVED
						16 - auraType  // BUFF DEBUFF
					_HEAL
					_CAST_START
					_CAST_SUCCESS
					_MISS
					_RESURRECT
					UNIT_DIED
				110484 paladin
		]]
		
		if not HCoold.symbiosys_spells_id[inp[13]] then return end
		if inp[3] == "SPELL_AURA_APPLIED" and inp[6] ~= inp[10] then self:SymbiosysApplied(inp[6], inp[10]) end
		if inp[3] == "SPELL_AURA_REMOVED" then self:SymbiosysRemoved(inp[6]) end
	end

	function HCoold:SymbiosysSpellIndex(i) -- выдать по заклинанию текстовое ид
		local tt = ""
		if i.symb == "raid" then tt = "syb.raid." .. tostring(i.spellID) end -- raid
		if i.symb == "druid" then tt = "syb.druid." .. tostring(i.spellID) end -- druid
		for _,j in next, i.specs do tt = string.format("%s.%d",tt,j) end
		return tt
	end

	function HCoold:SymbiosysManage() -- удаляет симбиоз при пропадании/появлении рейдеров из рейда
		local druids_arr = HCoold.db.profile.druids_arr
		local names = {}
		for i = 1, self:NumRaidMembers() do
			local name = GetRaidRosterInfo(i)
			names[name] = true
		end
		
		for i, j in next, druids_arr do if not (names[i] and names[j]) then druids_arr[i] = nil end end
	end

	function HCoold:SymbiosysTrakingList() -- открывает окошко кто на кого повешал симбиоз
		local AceGUI = LibStub("AceGUI-3.0")
		local LSM = LibStub("LibSharedMedia-3.0")
		local druids_arr = HCoold.db.profile.druids_arr
		
		local f = AceGUI:Create("Frame")
		local s = AceGUI:Create("ScrollFrame")
		local main_label = AceGUI:Create("InteractiveLabel")
		do -- frame creation
			f:SetLayout("Fill")
			f.state = true
			f:SetCallback("OnClose",function(widget) 
				AceGUI:Release(widget) 
			end)
			f:SetTitle(L["Tracking symbiosys"])

			s:SetLayout("List") -- probably?
			f:AddChild(s)
			f:SetPoint("RIGHT")
			f:SetWidth(self.db.profile.text.big_w * 2 + 50)
			
			s:AddChild(main_label)
			main_label:SetFont(LSM:Fetch("font",self.db.profile.font.name),self.db.profile.font.big_size)
			main_label:SetRelativeWidth(0.95)
		end
		
		local check = false
		local list = {} -- массив по имени друида выдающий объект label, содержащий имя человека на которого кастанули спелл
		for i = 1, self:NumRaidMembers() do -- добавляем список друидов и симбиозов на них
			if not check then check = true end
			local inp = self:GetSpec(i)
			if inp.class == "DRUID" then
				local sg0 = AceGUI:Create("SimpleGroup")
				sg0:SetLayout("Flow")
				sg0:SetFullWidth(true)
				s:AddChild(sg0)
				
				local label = AceGUI:Create("InteractiveLabel") -- имя друида
				sg0:AddChild(label)
				label:SetText(string.format(L["DRUIDcolor"],inp.name))
				label:SetWidth(self.db.profile.text.big_w)
				
				local label2 = AceGUI:Create("InteractiveLabel") -- имя того, на кого кастанули симбиоз
				list[inp.name] = label2
				sg0:AddChild(label2)
				label2:SetWidth(self.db.profile.text.big_w)
				--[[ старая часть
				if druids_arr[inp.name] then 
					pl = self:GetSpec(druids_arr[inp.name])
					label2:SetText(string.format(L[pl.class .. "color"],pl.name))
				else label2:SetText(L["no symbiosys for this druid"]) end
				--]]
			end
		end
		
		local function check_list() -- функция для забивания симбиозов в список
			if not check then return end
			HCoold:CheckSymbiosysBuffs()
			for druid, label in next, list do -- добавляем список друидов и симбиозов на них
				if druids_arr[druid] then 
					pl = self:GetSpec(druids_arr[druid])
					label:SetText(string.format(L[pl.class .. "color"],pl.name))
				else label:SetText(L["no symbiosys for this druid"]) end
			end
		end
		
		check_list()
		
		do -- добавляем кнопку для обновления
			local butt = AceGUI:Create("Button")
			s:AddChild(butt)
			butt:SetText(L["renew symbiosys"])
			butt:SetCallback("OnClick", check_list)
		end
		
		if check then main_label:SetText(L["druids list:"])
		else main_label:SetText(L["currently no players in raid"]) end
	end

	function HCoold:CheckSymbiosysBuffs()
		local list = {}
		for i = 1, self:NumRaidMembers() do
			-- ищем бафф симбиоза
			local doing, k, name, search = true, 1, select(1, GetRaidRosterInfo(i)), false
			while doing do
				local _, _, _, _, _, _, expirationTime, unitCaster, _, _, spellId = UnitBuff(name, k) -- name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId
				if spellId then 
					if unitCaster == nil then break end
					local caster = UnitName(unitCaster)
					if not (self:IsInRaid(caster) and self:IsInRaid(name)) then return end
					
					if self.symbiosys_spells_id[spellId] then
						-- итак, мы нашли бафф симбиоз и мы знаем кто его кастанул
						local diff = (expirationTime-GetTime()) / 60 -- время до окончания симбиоза
						
						if caster ~= name then --  and diff > 15
							--self:Chat("detected symbiosys", caster, name, diff)
							self:SymbiosysApplied(caster, name)
							search = true
							list[caster] = name
						end
					end
					
					--self:Chat(expirationTime, spellId, UnitName(unitCaster))
				else doing = false end
				k = k + 1
				
				if k == 300 then doing = false end
				if search then doing = false end
			end
			
			
		end
	end
end

do -- save/restor cds between sessions
	function HCoold:SaveSessionCDs(curr)
		local out={
			id = curr.id,
			player = curr.player,
			state_cd_end = curr.state_cd_end,
		}
		if not self.db.faction.LSCDs then self.db.faction.LSCDs = {} end
		table.insert(self.db.faction.LSCDs, out)
	end
	
	function HCoold:ClearSessionCD()
		if not self.db.faction.LSCDs then self.db.faction.LSCDs = {} end
		local s = self.db.faction.LSCDs
		for k = # s, 1, -1 do if self:GetDiff(s[k].state_cd_end) < 0 then table.remove(s,k) end end
	end
	
	function HCoold:GetLastSessionCD(id,player)
		if not self.db.faction.LSCDs then return -1 end
		local out = -1
		for _,j in next, self.db.faction.LSCDs do if j.id == id and j.player == player then out = j.state_cd_end end end
		if self:GetDiff(out) <= 0 then out = -1 end
		return out 
	end
end

do -- minimap
	local LDB = LibStub("LibDataBroker-1.1", true) -- Загрузка няшного значка на миникарте ^^
	local LDBIcon = LibStub("LibDBIcon-1.0", true) -- все еще няшный значок
	local DS = LDB:NewDataObject(HCoold.name, {type = "data source", icon = "Interface\\AddOns\\hagakure_cooldowns\\icon", text="n/a",	}) -- это наш значок на миникарте
	do -- minimap
		function HCoold:RegisterMinimap()
			LDBIcon:Register(self.name, DS, self.db.char.minimap)
		end

		function DS:OnEnter()
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
			GameTooltip:ClearLines()
			GameTooltip:AddLine(L["addon name"], 0, 1, 1)
			GameTooltip:AddLine(L["Middle click to open addon configuration"], 0, 1, 0)
			GameTooltip:AddLine(L["Right click to open menu"], 0, 1, 0)
			
			GameTooltip:Show()
		end

		function DS:OnLeave()
			GameTooltip:Hide()
		end

		function DS:OpenMenu()
				if not self.menU then
					self.menU = CreateFrame("Frame","")
				end
				local menu=self.menU
				
				menu.displayMode = "MENU"
				local info = {}
				menu.initialize = function (self, level)
					if not level then return end
					wipe(info)
					if level==1 then
						info.isTitle=1
						info.notCheckable = 1
						info.text = L["HCoold menu"]
						UIDropDownMenu_AddButton(info, level)

						wipe(info)
						info.disabled = 1
						info.notCheckable = 1
						UIDropDownMenu_AddButton(info, level)
						
						wipe(info)
						info.text = L["Show druids' symbiosys"]
						info.notCheckable = 1
						info.func = function () HCoold:SymbiosysTrakingList() end
						UIDropDownMenu_AddButton(info, level)
						
						wipe(info)
						info.text = L["Show raid's talents"]
						info.notCheckable = 1
						info.func = function () HCoold:ShowScanedTalents() end
						UIDropDownMenu_AddButton(info, level)
						
						--[[
						wipe(info)
						info.text = L["Rescan talents"]
						info.notCheckable = 1
						info.func = function() HCoold:RescanTalents() end
						UIDropDownMenu_AddButton(info, level)
						--]]
						
						wipe(info)
						info.text = L["Addon version"]
						info.notCheckable = 1
						info.func = function ()
							if not StaticPopupDialogs["Version"] then
								StaticPopupDialogs["Version"]= {
									text = string.format(L["Your current version is %s."],GetAddOnMetadata(HCoold.name,"Version")), 
									button1 = ACCEPT, 
									timeout = 30, 
									whileDead = 0, 
									hideOnEscape = 1, 
									OnAccept = function() end,
								}
							end
							StaticPopup_Show("Version")
						end
						UIDropDownMenu_AddButton(info, level)

						wipe(info)
						info.disabled = 1
						info.notCheckable = 1
						UIDropDownMenu_AddButton(info, level)
									
						wipe(info)
						info.text = L["Toggle off minimap icon"]
						info.notCheckable = 1
						info.func = function () HCoold:MinimapOn(false) end
						--info.colorCode="|cffff0000"
						UIDropDownMenu_AddButton(info, level)
						
						wipe(info)
						info.text         = CLOSE
						info.func         = function() CloseDropDownMenus() end
						info.checked      = nil
						info.notCheckable = 1
						UIDropDownMenu_AddButton(info, level)
					end
				end
				
				local x,y = GetCursorPosition(UIParent);
				ToggleDropDownMenu(1, nil, menu, "UIParent", x / UIParent:GetEffectiveScale() , y / UIParent:GetEffectiveScale())
		end
		
		function DS:OnClick(button)
			if button == "LeftButton" then
			elseif button == "RightButton" then
				DS:OpenMenu()
			elseif button == "MiddleButton" then
				HCoold:RunConfig()
			end
		end

		function HCoold:Minimap(state)
			if state then LDBIcon:Show(self.name) else LDBIcon:Hide(self.name) end
		end
		
		function HCoold:MinimapOn(res)
			self.db.char.minimap.hide = not res
			self:Minimap(not self.db.char.minimap.hide)
		end
	end
end

do -- actions with automatic talent inspect
	local last_rescan = {}
	local rescan_q = {}
	local last_inspect = GetTime()
	local inspect_delay = 2
	local inspect_timer_delay = 0.15
	local inspect_usual_timer = 7
	local total_rescan_max_time = 15
	local max_insp_att = 3
	
	function HCoold:RescanIteration()
		local all = 0
		for i = 1, self:NumRaidMembers() do
			local name = GetRaidRosterInfo(i)
			if (not last_rescan[name]) and (not rescan_q[name]) then
				-- self:Print("1--- " .. name)
				if self:IsInRaid(name) then
					all = all + 1
					-- self:Print("2---  ".. last_inspect .. " " .. GetTime())
					if self:CanBeInspected(name) then
						if GetTime() - last_inspect > inspect_delay then
							-- self:Print("run inspect " .. name)
							NotifyInspect(name)
							rescan_q[name] = true
							last_inspect = GetTime()
						end
					end
				end
			end
		end
		return all
	end

	local attempts = {}
	function HCoold:SlowInspectTimerActions() -- медленное обновление всех подряд
		if self:IsInCombat() then return end
		local to_rescan = {} -- массив который будет отсортирован по приоритетам
		for i = 1, self:NumRaidMembers() do
			local info = {}
			info.name = GetRaidRosterInfo(i)
			if info.name then
				attempts[info.name] = attempts[info.name] or 0
				info.last_scan = last_rescan[info.name] or -1
				info.att = attempts[info.name]
				if self:IsInRaid(info.name) then
					table.insert(to_rescan, info)
				end
			end
		end
		--[[
		table.sort(to_rescan, function (a1, a2) ------------------------------------ дописать корректно
			if type(a1) ~= "table" then return true end
			if type(a2) ~= "table" then return false end
			if a1.att < a2.att then return true end
			if a1.last_scan < a2.last_scan then return true end
		end)
		--]]
		
		do -- resort to_rescan
			local narr = {}
			local to_stop, stop = 10000000, 0
			while #to_rescan > 0 do
				local min_, s_ = nil, nil
				for s, i in next, to_rescan do
					if min_ == nil then min_ = i; s_ = s end
					if i.att < min_.att then min_ = i; s_ = s end
					if i.last_scan < min_.last_scan then min_ = i; s_ = s end
				end
				table.insert(narr, min_)
				to_rescan[s_] = nil
				stop = stop + 1
				if stop > to_stop then error"Manual stop sorting function, too many actions!"; break end
			end
			to_rescan = narr
		end
		
		local count = 1
		local succ = false
		for _, i in next, to_rescan do
			-- self:Print("-3: rescan " .. i.att .. " " .. i.name .. " " .. i.last_scan .. " c="..count)
			if self:CanBeInspected(i.name) and (not succ) then 
				NotifyInspect(i.name) 
				succ = true
				-- self:Print("|cffff0000"..i.name.."|r run inspect")
				attempts[i.name] = attempts[i.name] + 1
			end
			count = count + 1
		end
	end
	
	local timer_id = nil
	local rescan_start = -1
	function HCoold:RescanTalents() -- force talent check
		self:Print("Run rescan")
		wipe(last_rescan)
		wipe(rescan_q)
		rescan_start = GetTime()
		if self.InspectTimer then
			self:CancelTimer(self.InspectTimer)
			self.InspectTimer = nil
		end
		timer_id = self:ScheduleRepeatingTimer(function()
			local left = HCoold:RescanIteration()
			local scan = false
			if left == 0 then scan = true
			elseif (GetTime() - rescan_start > total_rescan_max_time)  then
					scan = true
			end
			if scan then
				HCoold:CancelTimer(timer_id)
				timer_id = nil
				if not HCoold.InspectTimer then
					HCoold:StartRescanTalents()
				end
			end
		end, inspect_timer_delay)
	end
	
	function HCoold:StartRescanTalents()
		if not self.InspectTimer and (not timer_id) then
			attempts = {}
			self.InspectTimer = self:ScheduleRepeatingTimer(function() HCoold:SlowInspectTimerActions() end,inspect_usual_timer)
		end
	end
	
	function HCoold:CanBeInspected(name)
		if CanInspect(name) then
			if CheckInteractDistance(name, 1) then
				return true
			end
		end
		return false
	end
	
	function HCoold:InspectTalents(guid)
		last_inspect = -1
		local classes = {}
		for class_id = 1, GetNumClasses () do
			local _, class = GetClassInfo(class_id)
			classes[class] = class_id
		end
		local locClass, engClass, locRace, engRace, gender, nameP, realm = GetPlayerInfoByGUID(guid)
		-- local spec = GetSpecialization(nameP) -- выдает сразу текущий спек типа холи/прот/ретри для класса
		if realm and realm ~= "" then nameP = nameP .. "-" .. realm end
		-- self:Print("1--- " .. nameP)
		local talents = {
			[1] = 0,
			[2] = 0,
			[3] = 0,
			[4] = 0,
			[5] = 0,
			[6] = 0,
		}
		for i = 1, 18 do
			local name, texture, tier, column, selected, available = GetTalentInfo(i,1,nil, nameP, classes[engClass]) --GetInspectTalent
			if name then 
				if selected then 
					--self:Print(name .. "  learned t=" .. tier .. " c=" .. column) 
					talents[tier] = column
				end
			end
		end
		
		self:UpdatePlayer(nameP, talents)
		
		-- self:UpdateSpec(nameP, spec)
		-- self:Print("1--"..nameP.."  "..realm)
		last_rescan[nameP] = GetTime()
		rescan_q[nameP] = nil
	end

	function HCoold:UpdatePlayer(name, talents) -- check if talents are tracking and add them for tracking...
		local ch = false
		if self.db.faction.AutoTalents[name] then
			local tmp = self.db.faction.AutoTalents[name].talents
			for i = 1, 6 do
				if tmp[i] ~= talents[i] then ch = true end
			end
		else
			ch = true
		end
		self.db.faction.AutoTalents[name] = {
			talents = talents,
			name = name,
			last_scan = GetTime(),
		}
		if ch then 
			self:CheckPlayersCDs() 
			-- self:Print("Update talents for " .. name)
		end
	end
	
	function HCoold:ShowScanedTalents()
		local AceGUI = LibStub("AceGUI-3.0")
		local LSM = LibStub("LibSharedMedia-3.0")
		
		local f = AceGUI:Create("Frame")
		local s = AceGUI:Create("ScrollFrame")
		local main_label = AceGUI:Create("InteractiveLabel")
		do -- frame creation
			f:SetLayout("Fill")
			f.state = true
			f:SetCallback("OnClose",function(widget) 
				AceGUI:Release(widget) 
			end)
			f:SetTitle(L["auto talents scan"])

			s:SetLayout("List") -- probably?
			f:AddChild(s)
			f:SetPoint("RIGHT")
			f:SetWidth(self.db.profile.text.big_w * 2 + 70)
			
			s:AddChild(main_label)
			main_label:SetFont(LSM:Fetch("font",self.db.profile.font.name),self.db.profile.font.big_size)
			main_label:SetRelativeWidth(0.95)
		end
		
		local check = false
		local list = {} -- массив по имени друида выдающий объект label, содержащий имя человека на которого кастанули спелл
		for i = 1, self:NumRaidMembers() do -- добавляем список друидов и симбиозов на них
			if not check then check = true end
			local inp = self:GetSpec(i)
			local sg0 = AceGUI:Create("SimpleGroup")
			sg0:SetLayout("Flow")
			sg0:SetFullWidth(true)
			s:AddChild(sg0)
			
			local label = AceGUI:Create("InteractiveLabel") -- имя игрока
			sg0:AddChild(label)
			label:SetText(string.format(L[inp.class .. "color"],inp.name))
			label:SetWidth(self.db.profile.text.big_w)
			
			local label2 = AceGUI:Create("InteractiveLabel") -- здесь его таланты
			list[inp.name] = label2
			sg0:AddChild(label2)
			label2:SetWidth(self.db.profile.text.big_w)
		end
		
		local function check_list() -- функция для забивания симбиозов в список
			if not check then return end
			for name, label in next, list do -- добавляем список друидов и симбиозов на них
				local t = HCoold.db.faction.AutoTalents[name]
				if t then 
					local s = math.floor(GetTime() - t.last_scan) .. L[" sec"]
					for i=1, 6 do s = string.format("%s/%d",s,t.talents[i]) end
					label:SetText(s)
				else label:SetText(L["no talents for this player"]) end
			end
		end
		
		check_list()
		
		do -- добавляем кнопку для обновления и подсказку
			local butt = AceGUI:Create("Button")
			s:AddChild(butt)
			butt:SetText(L["renew tlist"])
			butt:SetCallback("OnClick", check_list)
			
			local label = AceGUI:Create("InteractiveLabel") 
			s:AddChild(label)
			label:SetText(L["info for auto talent system"])
			label:SetWidth(self.db.profile.text.big_w)
		end
		
		if check then main_label:SetText(L["Players list:"])
		else main_label:SetText(L["currently no players in raid"]) end
	end
	
	function HCoold:TalentIndex(i) -- выдать по заклинанию текстовое ид
		local tt =  "autoTalent." .. tostring(i.spellID) 
		if i.trigger then
			for _, k in next, i.trigger do
				tt = string.format("%s.%d", tt, k)
			end
		end
		return tt
	end
end

do -- reset long CDs functions
	function HCoold:ResetLongCDs()
		for _,v in next, self.types do -- for each type of cd 
			for _,i in next, v.spells do -- for each spell
				local spec = HCoold:GetSpec(i.player)
				local spell = HCoold:GetSpellBySpec(i.id,spec.spec)
				spell = HCoold:GetManualSpell(i.id, i.player) or spell
				if spell then
					if spell.CD >= self.config.max_CD_for_reset then 
						i.state_cd_end = -1
						i.state_casting_end = -1
						i:Update()
					end
				end
			end
		end
	end
	
	function HCoold:BossStatus()
		local hasBoss = UnitHealth("boss1") > 100 or UnitHealth("boss2") > 100 or UnitHealth("boss3") > 100 or UnitHealth("boss4") > 100 or UnitHealth("boss5") > 100
		local is_prog = IsEncounterInProgress()
		local _, _, diff = GetInstanceInfo()
		
		--if hasBoss then self:Print("Boss exists!!") else self:Print("no boss") end
		--if is_prog then self:Print("Fight in progress") else self:Print("No enc in progress") end
		--self:Printf("Diff=%d",diff)
		if hasBoss and is_prog and (diff > 2) and (diff < 8) then return true end
	end
end























