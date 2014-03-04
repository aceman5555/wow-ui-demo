if not HCoold then return false end
local L = HCoold:GetLocale()
local LSM = LibStub("LibSharedMedia-3.0")

--[[
CreateFrame
GameTooltip
UIParent
--]]

local sp = {}
local fc = {}
local cd = {}

------ metatable for spells
do -- actions with sp
	sp.data = {
		__eq = function (a1,a2)
			local res = false
			if a1.player == a2.player and a1.id == a2.id then res = true end
			return res
		end,
	}

	function sp.empty()
		local out = {
			id = 1, -- id of spell
			player = "noname", -- player name
			screen_name = "noname", -- screen name for player
			guid = nil,
			state = 1, -- spell state  1 - ready 2 - casting 3 - cd
			state_casting_end = -1, -- end of casting spell
			state_cd_end = -1, -- time when end cd
			color = "|cff00ff00", -- color of spell when drawing
			type = 1, -- type of spell  1 - bad 2 - good 3 - super good 4 - dead 5 - offline 6 - casting 7 - cd

			cont = nil,
		}	
		
		do -- function section
			function out:GetState()
				return self.state
			end
				
			function out:SetState(state)
				self.state = state
			end
			
			function out:RunParentSetPoint()
				self.cont.frame:SetHeight(math.max(self.cont.font:GetHeight(),self.cont.icon:GetHeight()))
				if self.parent then 
					self.parent:SortSpells()
				end
			end
			
			function out:SetParent(parent)
				if getmetatable(parent) ~= fc.data then
					error"Wrong metatable for SetParent()"
					return false
				end
				self.parent = parent
			end
			
			function out:SetPoint(frame, point1, point2)
				self.cont.frame:ClearAllPoints()
				if frame == nil then error"Nil spell metatable" end
				if getmetatable(frame) == sp.data then
					point1 = point1 or "TOPLEFT"
					point2 = point2 or "BOTTOMLEFT"
					self.cont.frame:SetPoint(point1, frame.cont.frame, point2)
					return true
				end
				if getmetatable(frame) == fc.data then
					point1 = point1 or "TOPLEFT"
					point2 = point2 or "TOPLEFT"
					self.cont.frame:SetPoint(point1, frame.cont, point2)
					return true
				end
				error"not spell/container metatable!"
			end
			
			function out:IsSpell(id,player)
				if id == self.id and player == self.player then return true
				else return false end
			end
			
			function out:SetWidth(width)
				width = width or HCoold.db.profile.spell.w
				self.cont.font:SetWidth(width - HCoold.db.profile.icon.w)
				self.cont.frame:SetWidth(self.cont.font:GetWidth() + self.cont.icon:GetWidth())
				self.cont.frame:SetHeight(math.max(self.cont.font:GetHeight(),self.cont.icon:GetHeight()))
			end
			
			function out:Hide()
				self.cont.icon:Hide()
				self.cont.bar:Hide()
				self.cont.frame:Hide()
			end
			
			function out:Show()
				self.cont.icon:Show()
				self.cont.bar:Show()
				self.cont.font:Show()
				--self:Update()
			end
		end
			
		do -- function sections
			function out:UpdateState()
				if HCoold:GetDiff(self.state_casting_end) > 0 then 
					self.state = 2
				elseif HCoold:GetDiff(self.state_cd_end) > 0 then 
					self.state = 3
					self.state_casting_end = -1
				else 
					self.state = 1 
					self.state_casting_end = -1
					self.state_cd_end = -1
				end
			end
			
			function out:StartCD()
				local spec = HCoold:GetSpec(self.player)
				local spell = HCoold:GetSpellBySpec(self.id,spec.spec)
				spell = HCoold:GetManualSpell(self.id, self.player) or spell
				if not spell then return false end
				self.state_cd_end = HCoold:GetEndTime(spell.CD)
				if spell.cast_time then 
					self.state_casting_end = HCoold:GetEndTime(spell.cast_time)
				end
				self:Update()
				local mv = HCoold:GetDiff(self.state_cd_end)
				self.cont.bar:SetMinMaxValues(0, mv)
				self.cont.bar:SetValue(mv)
				if self.parent then
					self.parent:AddCDTrack(self)
				end
			end
				
			function out:Update()
				--HCoold:Printf("Update spell %s",self.id)
				self:UpdateState()
				local t = select(2,HCoold:GetColor(self.id,self.player))
				local diff = nil
				if HCoold:GetDiff(self.state_cd_end) > 0 then  diff = HCoold:GetTextDiff(self.state_cd_end) end
				if HCoold:GetDiff(self.state_casting_end) > 0 then diff = HCoold:GetTextDiff(self.state_casting_end) end
				if t < 4 then
					if self.state == 2 then  t = 6 end
					if self.state == 3 then  t = 7 end
				end
				diff = diff or ""
				local bconf = HCoold.db.profile.bars
				if self.state == 2 then self.cont.bar:SetStatusBarColor(bconf.cast_color.r,bconf.cast_color.g,bconf.cast_color.b,bconf.cast_color.a) 
				elseif self.state == 3 then self.cont.bar:SetStatusBarColor(bconf.cd_color.r,bconf.cd_color.g,bconf.cd_color.b,bconf.cd_color.a) end
				self.cont.font:SetText(string.format("%s%s %s|r",diff,HCoold:GetColorByQuality(t),self.screen_name,t,self.state)) -----------------------------------
				self.cont.font:UpdateHeight()
				self.cont.bar:SetValue(HCoold:GetDiff(self.state_cd_end))
				if t ~= self.type then
					self.type = t
					self:RunParentSetPoint(self)
				end
			end
		end
			
		return out
	end

	function sp.create_cont(id,color,name,cont)
		local icon = cont:CreateTexture(nil, "OVERLAY")
		local frame = CreateFrame("Frame",nil,cont) -- frame for aligns
		local mybar = CreateFrame("StatusBar", nil, cont)
		local font = mybar:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall") -- container for spell info

		local icon_ = select(3, GetSpellInfo(id))
		icon:SetWidth(HCoold.db.profile.icon.w)
		icon:SetHeight(HCoold.db.profile.icon.w)
		icon:SetTexture(icon_)
		icon:SetPoint("TOPLEFT",frame,"TOPLEFT")

		font:SetText(string.format("%s%s|r",color,name))
		font:SetWidth(HCoold.db.profile.spell.w)
		font:SetPoint("TOPLEFT",icon,"TOPRIGHT")
		font:SetJustifyH("LEFT")
		font:SetJustifyV("TOP")
		font:SetFont(LSM:Fetch("font",HCoold.db.profile.font.name),HCoold.db.profile.font.size)
		function font:UpdateHeight()
			frame:SetHeight(math.max(HCoold.db.profile.icon.w, font:GetHeight()))
		end
		
		frame:SetWidth(HCoold.db.profile.spell.w + HCoold.db.profile.icon.w)
		icon:SetPoint("TOPLEFT",frame,"TOPLEFT")
		font:UpdateHeight()
		--frame:SetPoint("TOPRIGHT",font,"TOPRIGHT", -HCoold.db.profile.icon.w, 0)
		--frame:SetPoint("BOTTOMRIGHT",font,"BOTTOMRIGHT")
		
		local bconf = HCoold.db.profile.bars
		mybar:SetPoint("TOPLEFT",font,"TOPLEFT")
		mybar:SetPoint("BOTTOMRIGHT",font,"BOTTOMRIGHT")
		local textures = LSM:Fetch("statusbar",bconf.texture)
		if bconf.enable then mybar:SetStatusBarTexture(textures) end
		mybar:SetMinMaxValues(0,1)
		mybar:SetValue(0)
		
		local bg = mybar:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints()
		if bconf.bgenable then
			bg:SetTexture(textures)
			bg:SetVertexColor(bconf.bg_color.r, bconf.bg_color.g, bconf.bg_color.b, bconf.bg_color.a)
		end

		if HCoold.db.profile.tooltip_spells then
			frame:SetScript("OnEnter",function()
				GameTooltip:SetOwner(frame, "ANCHOR_RIGHT", 0, 0)
				local splink = select(1, GetSpellLink(id))
				if splink then GameTooltip:SetHyperlink(splink) end
				GameTooltip:Show()
			end)
			frame:SetScript("OnLeave",function()
				GameTooltip:Hide()
			end)
		end

		--[[
		frame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "", --"Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = false,
			tileSize = 32,
			edgeSize = 0,
			insets = {
				left = 0,
				right = 0,
				top = 0,
				bottom = 0,
			},
		})
		-- ]]
		
		local out = {
			icon = icon,
			font = font,
			frame = frame,
			bar = mybar,
		}
		
		return out
	end

	function sp.new(sp_id,name,cont)
		cont = cont or UIParent
		local t = sp.empty()
		setmetatable(t, sp.data)
		t.state_cd_end = HCoold:GetLastSessionCD(sp_id,name)
		
		t.id = sp_id -- id of spell
		t.player = name -- player name
		t.screen_name = name -- player name without server
		t.guid = UnitGUID(name)
		
		local is_to = string.find(name, "-")
		if is_to and HCoold.db.profile.server_names then
			t.screen_name = string.sub(name, 1, is_to-1)
			--HCoold:Printf("%s %s %s",name, is_to,t.screen_name)
		end
		
		t.color, t.type = HCoold:GetColor(sp_id,name) -- color of spell when drawing + type of spell

		t.cont = sp.create_cont(sp_id,t.color,name,cont)
		if t.state_cd_end > 0 then t.cont.bar:SetMinMaxValues(0,HCoold:GetDiff(t.state_cd_end)) end
		
		return t
	end
end

------- metatable for container for spells
do -- actions with fc
	fc.data = {}

	function fc.new(t)
		local f = {}
		setmetatable(f,fc.data)
		
		f.type = t -- type of cd
		
		do -- frame for anchor
			f.width = HCoold.db.profile.types[t].w or 100
			f.height = HCoold.db.profile.group.h
			f.status = {
				top = 0,
				left = 0,
				point = "BOTTOMLEFT",
			}
			
			local frame = CreateFrame("Frame", nil, UIParent)
			frame:SetWidth(f.width)
			frame:SetHeight(f.height)
			frame:SetPoint("BOTTOMLEFT")
			frame:Hide()
			frame:EnableMouse()
			frame:SetClampedToScreen(true)
			frame:SetMovable(true)
			frame:SetScript("OnMouseDown",function() frame:StartMoving() end )
			frame:SetScript("OnMouseUp",function() 
				frame:StopMovingOrSizing() 
				f.status.top = frame:GetTop()
				f.status.left = frame:GetLeft()
				f.SavePoint("BOTTOMLEFT",frame:GetLeft(),frame:GetTop())
			end)
			
			local font = frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
			font:SetText(string.format(L["type" .. f.type]))
			font:SetWidth(HCoold.db.profile.spell.w)
			font:SetAllPoints(frame)
			font:SetJustifyH("CENTER")
			font:SetJustifyV("CENTER")
			font:SetFont(LSM:Fetch("font",HCoold.db.profile.font.name),HCoold.db.profile.font.size)
			
			-- [[
			frame:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "", --"Interface\\DialogFrame\\UI-DialogBox-Border",
				tile = false,
				tileSize = 32,
				edgeSize = 0,
				insets = {
					left = 0,
					right = 0,
					top = 0,
					bottom = 0,
				},
			})
			--frame:SetBackdropColor(1,0,0,1)
			--]]
			
			f.cont = frame -- frame anchor for align
		end
		
		f.spells = {} -- table, that contains spells with type of container
		f.trackCD = nil -- table, that contains links to spells that are CDs
		f.AtrackCD = nil -- link to container with Active spells
		f.sort_method = HCoold.db.profile.types[t].sm or 1 -- method of sorting spells
		f.enable = true -- enable/disable type of spells

		do -- function section
			f.SavePoint = nil
			
			function f:AddSpell(spell) -- add spell in spell list
				if getmetatable(spell) ~= sp.data then error"Not a spell metatable!"; return false end
				table.insert(self.spells, spell)
				spell:SetParent(self)
				spell:SetWidth(self.width)
				self:SortSpells()
				-- and now we need to check if spell is on CD, if it's so, then we need to add it to cd list and run timer
				spell:Update()
				if spell.state > 1 then self:AddCDTrack(spell) end
				if not f.enable then spell:Hide() end
			end
			
			function f:SetWidth(width)
				self.width = width
				self.cont:SetWidth(width)
				for _, i in next, self.spells do i:SetWidth(self.width) end
			end
			
			function f:SetSortMethod(i)
				self.sort_method = i
				HCoold.db.profile.types[self.type].sm = i
				self:SortSpells()
			end
			
			function f:Update() -- full update of container with spells
				for _,i in next, self.spells do i:Update() end
			end
			
			function f:SortSpells() -- realign spells on screen
				if # f.spells == 0 then return false end
				table.sort(self.spells,function (a1,a2)
						-- sort table with spells by spell type
						-- 1 - bad 2 - good 3 - supergood 4 - dead 5 - offline 6 - casting 7 - cooldown
						local t1,t2 = a1.type, a2.type
						if t1 == 3 then t1 = -1 end
						if t2 == 3 then t2 = -1 end
						if t2 == 1 then t2 = 2.5 end
						if t1 == 1 then t1 = 2.5 end
						if t1 == 4 or t1 == 5 then t1 = t1 + 4 end
						if t1 == 6 then t1 = -3 end
						if t2 == 4 or t2 == 5 then t2 = t2 + 4 end
						if t2 == 6 then t2 = -3 end
						if t1 < t2 then return true end
						if t1 == t2 then 
							if a1.player ~= a2.player then return a1.player < a2.player end
							return a1.id < a2.id
						end
						return false
					end)
				-- now first one points to frame, and then others
				local sm = HCoold.sort_methods[self.sort_method]
				self.spells[1]:SetPoint(self,sm.fpoint1,sm.fpoint2)
				for i = 2, # self.spells do
					self.spells[i]:SetPoint(self.spells[i-1],sm.point1,sm.point2)
				end
			end
		
			function f:SetPoint(x,y,point) -- setpoint of align frame
				point = point or "BOTTOMLEFT"
				x = x or 0
				y = y or 0
				self.status.top = y
				self.status.left = x
				self.status.point = point
				self.cont:SetPoint(point,x,y)
				if self.SavePoint then
					self.SavePoint(point,x,y)
				end
			end
			
			function f:SetFuncSavePoint(func)
				self.SavePoint = func
			end
			
			function f:AddCDTrack(spell) -- add spell in array for traking cd
				if not self.enable then return end
				if not self.trackCD then error"u should set parent trackCD array!" end
				if getmetatable(spell) ~= sp.data then error"need spell metatable!" end
				table.insert(self.trackCD,spell)
				HCoold:StartTimer()
				if self.AtrackCD then self.AtrackCD:TrackActiveSpell(spell) end
			end
			
			function f:Hide()
				self.cont:Hide()
				for _, i in next, self.spells do i:Hide() end
			end
			
			function f:Show()
				for _, i in next, self.spells do i:Show() end
			end
			
			function f:SetTrackCDs(arr,Aarr) -- set parent's array, that contains spells with cd
				self.trackCD = arr
				self.AtrackCD = Aarr
			end
			
			function f:Enable(state)
				if state == nil then return self.enable end
				if state then self.enable = true else self.enable = false end
				if self.enable then self:Show(); self:Update()
				else self:Hide() end
			end
			
			function f:IsCD()
				return # self.trackCD > 0
			end
		end
		
		return f
	end
end
------- container for current casting CDs
local cdnewspell, cdempty = {}, {}
local function CDnewSpell(spell)
	if getmetatable(spell) ~= sp.data then error"wrong spell metatable" end
	local f = {}
	setmetatable(f,cdnewspell)
	local conf = HCoold.db.profile.active_spells
	f.spell = spell
	f.state = true
	
	do -- frame
		local frame = CreateFrame("Frame",nil,UIParent)
		frame:SetWidth(conf.w)
		frame:SetPoint("CENTER")
		if HCoold.db.profile.tooltip_active_spells then
			frame:SetScript("OnEnter",function()
				GameTooltip:SetOwner(frame, "ANCHOR_TOP", 0, 0)
				local splink = GetSpellLink(spell.id)
				if splink then GameTooltip:SetHyperlink(splink) end
				GameTooltip:Show()
			end)
			frame:SetScript("OnLeave",function()
				GameTooltip:Hide()
			end)
		end
		--[[
		frame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "", --"Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = false,
			tileSize = 32,
			edgeSize = 0,
			insets = {
				left = 0,
				right = 0,
				top = 0,
				bottom = 0,
			},
		})
		-- ]]
		
		if conf.cancel_by_click then
			frame:EnableMouse(true)
			frame:SetScript("OnMouseUp",function() f.state = false end)
		end
		
		local icon = frame:CreateTexture(nil, "OVERLAY")
		local icon_ = select(3, GetSpellInfo(spell.id))
		icon:SetWidth(conf.w)
		icon:SetHeight(conf.w)
		icon:SetTexture(icon_)
		
		local font = frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall") -- container for timer
		font:SetWidth(conf.w)
		font:SetJustifyH("CENTER")
		font:SetJustifyV("TOP")
		font:SetFont(LSM:Fetch("font",HCoold.db.profile.font.name),HCoold.db.profile.font.size)
		local timer = font
		
		local font = frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall") -- container for name
		if conf.names_enable then font:SetText(spell.screen_name) else font:SetText("") end
		font:SetWidth(conf.w)
		font:SetJustifyH("CENTER")
		font:SetJustifyV("TOP")
		font:SetFont(LSM:Fetch("font",HCoold.db.profile.font.name),HCoold.db.profile.font.size)
		local text = font
		
		f.cont = {
			frame = frame,
			icon = icon,
			timer = timer,
			text = text,
		}
		f.cont.text:SetPoint("TOPLEFT",f.cont.frame,"TOPLEFT")
		f.cont.icon:SetPoint("TOPLEFT",f.cont.text,"BOTTOMLEFT")
		f.cont.timer:SetPoint("TOPLEFT",f.cont.icon,"BOTTOMLEFT")
	end
	
	do -- function section
		function f:UpdateTexts()
			-- first of all check if timer and name are on
			self.cont.timer:SetText(HCoold:GetTextDiff(self.spell.state_casting_end))
		end
		
		function f:UpdateFrameSize()
			self.cont.frame:SetHeight(self.cont.icon:GetHeight()+self.cont.text:GetHeight()+self.cont.timer:GetHeight())
		end
		
		function f:Update()
			self.spell:Update()
			self:UpdateTexts()
			--self:UpdateFrameSize()
		end
		
		function f:SetPoint(frame, point1, point2)
			self.cont.frame:ClearAllPoints()
			if frame == nil then error"Nil metatable for align" end
			if getmetatable(frame) == cdnewspell then
				point1 = point1 or "TOPLEFT"
				point2 = point2 or "BOTTOMLEFT"
				self.cont.frame:SetPoint(point1, frame.cont.frame, point2)
				return true
			end
			if getmetatable(frame) == cdempty then
				point1 = point1 or "TOPLEFT"
				point2 = point2 or "TOPLEFT"
				self.cont.frame:SetPoint(point1, frame.anchor, point2)
				return true
			end
			error"not cd/container metatable!"
		end
		
		function f:Hide()
			self.cont.frame:Hide()
		end
		
		function f:GetState()
			if not self.state then return false end
			if self.spell.state == 2 then return true
			else return false end
		end
	end
	
	f:UpdateTexts()
	f:UpdateFrameSize()
	
	return f
end

local function CDempty()
	local f = {}
	setmetatable(f,cdempty)
	local conf = HCoold.db.profile.active_spells
	--[[
		active_spells = {
			top = 500,
			left = 100,
			point = "BOTTOMLEFT",
			w = 200,
			sm = 1,
			enable = true,
		},
	--]]
	f.data = {}
	
	do -- frame for anchor
		local frame = CreateFrame("Frame", nil, UIParent)
		frame:SetWidth(150)
		frame:SetHeight(HCoold.db.profile.group.h)
		frame:SetPoint(conf.point,conf.left,conf.top)
		frame:Hide()
		frame:EnableMouse()
		frame:SetClampedToScreen(true)
		frame:SetMovable(true)
		frame:SetScript("OnMouseDown",function() frame:StartMoving() end )
		frame:SetScript("OnMouseUp",function() 
			frame:StopMovingOrSizing() 
			conf.left = frame:GetLeft()
			conf.top = frame:GetTop()
			conf.point = "BOTTOMLEFT"
		end)
		
		local font = frame:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
		font:SetText(string.format(L["active spell frame"]))
		font:SetWidth(HCoold.db.profile.spell.w)
		font:SetAllPoints(frame)
		font:SetJustifyH("CENTER")
		font:SetJustifyV("CENTER")
		font:SetFont(LSM:Fetch("font",HCoold.db.profile.font.name),HCoold.db.profile.font.size)

		frame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "", --"Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = false,
			tileSize = 32,
			edgeSize = 0,
			insets = {
				left = 0,
				right = 0,
				top = 0,
				bottom = 0,
			},
		})
		--frame:SetBackdropColor(1,0,0,1)
		
		f.anchor = frame -- frame anchor for align
	end
	
	do -- function section
		function f:TrackActiveSpell(spell)
			if not conf.enable then return end
			if getmetatable(spell) ~= sp.data then error"wrong metatable, need spell one!" end
			spell:Update()
			if spell.state == 2 then
				local nn = CDnewSpell(spell)
				table.insert(self.data,nn)
				self:SortSpells()
				self:StartTimer()
			end
		end
		
		function f:StartTimer()
			if self.timer then return end
			self.timer = HCoold:ScheduleRepeatingTimer(function() self:Update() end, HCoold.db.profile.timer_fast_delay)
		end
		
		function f:StopTimer()
			if self.timer then
				HCoold:CancelTimer(self.timer,true)
				self.timer = nil
			end
		end
		
		function f:Update()
			for k = # self.data, 1, -1 do
				local i = self.data[k]
				i:Update()
				if not i:GetState() then 
					i:Hide()
					table.remove(self.data,k) 
				end
			end
			if # self.data == 0 then self:StopTimer() 
			else self:SortSpells() end
		end
		
		function f:SortSpells()
			local sm = HCoold.sort_methods[conf.sm]
			self.data[1]:SetPoint(self,sm.fpoint1,sm.fpoint2)
			for i = 2, # self.data do
				self.data[i]:SetPoint(self.data[i-1],sm.point1,sm.point2)
			end
		end
	end
	
	return f
end

-------- create containers
function HCoold:MakeSpellGroups() -- make groups for spells
	local t = {}
	local types = {}
	self.trackCDs = {}
	self.activeSpells = CDempty()
	for i = 1, self.config.types_amount do t[i] = true end
	for _,i in next, self.db.faction.PlayersSpells do if self.db.profile.trackManualSpells[self:ManualSpellIndex(i)] then t[i.type]=true end end
	for k in next, t do 
		local ss = fc.new(k)
		ss:SetFuncSavePoint(function(...)
			local point,left,top = ...
			self.db.profile.types[k].left,self.db.profile.types[k].top,self.db.profile.types[k].point = left, top, point
		end)
		ss:SetPoint(self.db.profile.types[k].left,self.db.profile.types[k].top,self.db.profile.types[k].point)
		ss:SetTrackCDs(self.trackCDs,self.activeSpells)
		ss:Enable(self.db.profile.types[k].enable)
		types[k] = ss
	end
	self.types = types
end

function HCoold:AddSpell(...) -- add spell if player change spec or change groups etc...
	--[[
		... = 
			name = player's name
			spell = link to spell from spells.lua that we need to add
	]]
	local name, spell = ...

	local sep = sp.new(spell.spellID,name)
	self.types[spell.type]:AddSpell(sep)
end

do -- debug mode for spells
	local function getRundomName()
		return "Player name"
	end
	
	function HCoold:SpellDebugModeOn()
		self:Print("debug mode on")
		local count = {}
		for _, i in next, self.spells do
			if not count[i.type] then count[i.type] = 0 end
			if count[i.type] < 5 then
				count[i.type] = count[i.type] + 1
				local sep = sp.new(i.spellID, getRundomName())
				self.types[i.type]:AddSpell(sep)
				if count[i.type] == 2 then
					sep.state_cd_end = self:GetEndTime(i.CD)
					if i.cast_time then 
						sep.state_casting_end = self:GetEndTime(i.cast_time)
					end
					sep:Update()
					local mv = self:GetDiff(sep.state_cd_end)
					sep.cont.bar:SetMinMaxValues(0, mv)
					sep.cont.bar:SetValue(mv)
					if sep.parent then
						sep.parent:AddCDTrack(sep)
					end
					self:AnnounceCDStart(sep)
				end
			end
		end
	end
end