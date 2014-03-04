TrinityXP = {}

TrinityXPSavedState = {}
TrinityXPSavedState.firstRun = true
TrinityXPSavedState.textIndex = {}
TrinityXPSavedState.repSelect = {}
TrinityXPSavedState.repMonitor = {}
TrinityXPSavedState.repNameIndex = {}
TrinityXPSavedState.repFactionIndex = {}
TrinityXPSavedState.repDropDownIndex = {}
TrinityXPSavedState.docks = {}
TrinityXPSavedState.debug1 = {}
TrinityXPSavedState.debug2 = {}

local find = string.find
local format = string.format
local gsub = string.gsub
local clickedBar
local dockIndex = {}
local xpFrameData = {}
local playerEnteredWorld = false
local repColors = {
	[0] = { l="a_Unknown", r=0.5, g=0.5, b=0.5, a=1.0 },
	[1] = { l="b_Hated", r=0.6, g=0.1, b=0.1, a=1.0 },
	[2] = { l="c_Hostile", r=0.7, g=0.2, b=0.2, a=1.0 },
	[3] = { l="d_Unfriendly", r=0.75, g=0.27, b=0, a=1.0 },
	[4] = { l="e_Neutral", r=0.9, g=0.7, b=0, a=1.0 },
	[5] = { l="f_Friendly", r=0.3, g=0.7, b=0.2, a=1.0 },
	[6] = { l="g_Honored", r=0.1, g=0.5, b=0.20, a=1.0 },
	[7] = { l="h_Revered", r=0.0, g=0.39, b=0.88, a=1.0 },
	[8] = { l="i_Exalted", r=0.58, g=0.0, b=0.55, a=1.0 },
}
local onEnter = {
	[1] = 2,
	[2] = 1,
	[3] = 1,
	[4] = 5,
	[5] = 4,
}

local barTextures = {
	[1] = { "Default", "Interface\\TargetingFrame\\BarFill2" },
	[2] = { "Contrast", "Interface\\AddOns\\Trinity2\\images\\BarFill_contrast" },
	-- Following textures by Tonedef of WoWInterface
	[3] = { "Carpaint", "Interface\\AddOns\\Trinity2\\images\\BarFill_Carpaint" },
	[4] = { "Gel", "Interface\\AddOns\\Trinity2\\images\\BarFill_Gel" },
	[5] = { "Glassed", "Interface\\AddOns\\Trinity2\\images\\BarFill_Glassed" },
	[6] = { "Soft", "Interface\\AddOns\\Trinity2\\images\\BarFill_Soft" },
	[7] = { "Velvet", "Interface\\AddOns\\Trinity2\\images\\BarFill_Velvet" },
}

local barBorders = {
	[1] = { "Tooltip", "Interface\\Tooltips\\UI-Tooltip-Border", 2, 2, 3, 3, 12, 12, -2, 3, 2, -3 },
	[2] = { "Slider", "Interface\\Buttons\\UI-SliderBar-Border", 3, 3, 6, 6, 8, 8 , -1, 5, 1, -5 },
	[3] = { "Dialog", "Interface\\AddOns\\Trinity2\\images\\Trinity-DialogBox-Border", 3, 3, 6, 6, 26, 26, -7, 7, 7, -7 },
	[4] = { "None", "", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

local function dockDefaults(index, dockFrame)

	dockFrame:SetID(index)
	dockFrame.config = {
		["name"] = "XP Bar",
		["dockStrata"] = "MEDIUM",
		["scale"] = 1,
		["alpha"] = 1,
		["barWidth"] = 200,
		["barHeight"] = 12,
		["orientation"] = "HORIZONTAL",
		["autohide"] = false,
		["texture"] = 1,
		["border"] = 1,
		["restcolor"] = { 0, 0.39, 0.88 },
		["norestcolor"] = { 0.58, 0, 0.55 },
		["bordercolor"] = { 0.8, 0.8, 0.8 },
		["textcolor"] = { 1, 0.82, 0 },
		["centerx"] = (UIParent:GetWidth()/2)*UIParent:GetEffectiveScale(),
		["centery"] = (UIParent:GetHeight()/2)*UIParent:GetEffectiveScale(),
	}


	dockFrame.elapsed = 3
	dockFrame.update = false

	if (TrinityXPSavedState.firstRun) then
		TrinityXPSavedState["docks"][index] = { dockFrame.config }
	end
end

local function createDockFrame(index)

	local dockFrame = CreateFrame("Button", "TrinityXPDock"..index, UIParent, "Trinity2DockFrameTemplate")

	dockDefaults(index, dockFrame)

	dockFrame.func1 = function(self) TrinityXP.SaveState() end
	dockFrame.func2 = function(self) TrinityXP.UpdateDockElement(self) end

	dockFrame.create = function(self) local dockFrame = TrinityXP.CreateXPBar(#dockIndex+1) dockFrame:Show() TrinityXP.UpdateDockElement(dockFrame) end

	if (index ~= 1) then
		dockFrame.delete = function(self) local dockFrame = TrinityXP.DeleteXPBar(self) end
	end
	dockFrame.owner = "TrinityXP_"

	dockFrame.simpleActionSet = {
		[TRINITYXP_STRINGS.DOCK_OPT_1] = true,
		[TRINITYXP_STRINGS.DOCK_OPT_2] = "default",
		[TRINITYXP_STRINGS.DOCK_OPT_3] = true,
		[TRINITYXP_STRINGS.DOCK_OPT_4] = true,
		[TRINITYXP_STRINGS.DOCK_OPT_5] = true,
		[TRINITYXP_STRINGS.DOCK_OPT_6] = true,
	}

	dockFrame.actionSet = {
		[TRINITYXP_STRINGS.DOCK_OPT_1] = true,
		[TRINITYXP_STRINGS.DOCK_OPT_2] = true,
		[TRINITYXP_STRINGS.DOCK_OPT_3] = true,
		[TRINITYXP_STRINGS.DOCK_OPT_4] = true,
		[TRINITYXP_STRINGS.DOCK_OPT_5] = true,
		[TRINITYXP_STRINGS.DOCK_OPT_6] = true,
	}

	dockFrame.checkSet = {}

	dockFrame.colorSet = {
		[TRINITYXP_STRINGS.COLOR_OPT_1] = true,
 		[TRINITYXP_STRINGS.COLOR_OPT_2] = true,
 		[TRINITYXP_STRINGS.COLOR_OPT_3] = true,
 		[TRINITYXP_STRINGS.COLOR_OPT_4] = true,
 	}

	dockIndex[index] = dockFrame

	Trinity2.RegisteredDocks[dockFrame:GetName()] = function(frame) TrinityXP.UpdateDockElement(frame) end

	return dockFrame
end

local function updateDockPostions(reset)

	local dockFrame, dockFrameHeight

	local anchor = "BOTTOM";
	local relTo = "UIParent";
	local relPoint = "BOTTOM";
	local x = UIParent:GetBottom()
	local y = 250;



	if (reset) then

		dockFrameHeight = 45;

		for k,dockFrame in pairs(dockIndex) do

			dockFrame:SetUserPlaced(false)
			dockFrame:ClearAllPoints()
			if (dockFrame:GetID() == 1) then
				dockFrame:SetPoint("CENTER", relTo, relPoint, 0, 45.7)
			else
				dockFrame:SetPoint(anchor, relTo, relPoint, x, y)
			end
			dockFrame.config.centerx, dockFrame.config.centery = dockFrame:GetCenter()
			dockFrame:SetUserPlaced(true)

				y = y + dockFrameHeight
		end

		TrinityXPSavedState.firstRun = false;
	else
		for k,dockFrame in pairs(dockIndex) do

			dockFrame:SetUserPlaced(false)
			dockFrame:ClearAllPoints()
			dockFrame:SetPoint("CENTER", relTo, "BOTTOMLEFT", dockFrame.config.centerx, dockFrame.config.centery)
			dockFrame:SetUserPlaced(true)
		end
	end

	TrinityXP.SaveState()
end

local function XPBar_Update(self)

	self.text:SetText(xpFrameData[self.barNum][TrinityXPSavedState.textIndex[self.barNum]])

	if (TrinityXPSavedState.textIndex[self.barNum] < 4) then
		if (self.restedXP ~= nil) then
			if (self.restcolor) then
				self.bar:SetStatusBarColor(self.restcolor[1], self.restcolor[2], self.restcolor[3], 1.0)
			else

			end
		else
			if (self.norestcolor) then
				self.bar:SetStatusBarColor(self.norestcolor[1], self.norestcolor[2], self.norestcolor[3], 1.0)
			else

			end
		end

		if (self.nextXP) then
			self.bar:SetMinMaxValues(0, self.nextXP)
		end

		if (self.currXP) then
			self.bar:SetValue(self.currXP)
		end
	else
		self.bar:SetStatusBarColor(repColors[self.standingID].r, repColors[self.standingID].g, repColors[self.standingID].b, repColors[self.standingID].a)

		if (self.repMax) then
			self.bar:SetMinMaxValues(0, self.repMax)
		end
		if (self.repCurr) then
			self.bar:SetValue(self.repCurr)
		end
	end
end

local function updateXPRep(self, event, message)

	if (not playerEnteredWorld) then
		return
	end

	for i=1,5 do
		xpFrameData[self.barNum][i] = ""
	end

	if (event == "PLAYER_XP_UPDATE" or "UPDATE_EXHAUSTION" or "PLAYER_ENTERING_WORLD") then

		local currXP = UnitXP("player")
		local nextXP = UnitXPMax("player")
		local restedXP = GetXPExhaustion()
		local percentXP, restedLevels, bubbles

		percentXP = (currXP/nextXP)*100
		restedLevels = GetXPExhaustion()
		bubbles = currXP/(nextXP/20)

		bubbles = gsub(bubbles,"(%d*)(%.)(%d*)","%1")

		if (restedXP ~= nil) then
			restedLevels = restedLevels/nextXP
			restedLevels = gsub(restedLevels,"(%d*)(%.)(%d%d)(%d*)","%1%2%3")
			xpFrameData[self.barNum][3] = restedXP.." - "..restedLevels..TRINITYXP_STRINGS.RESTED
		else
			xpFrameData[self.barNum][3] = TRINITYXP_STRINGS.NORESTED
		end

		percentXP = format("%.1f", percentXP)

		xpFrameData[self.barNum][1] = currXP.."/"..nextXP.." - "..bubbles..TRINITYXP_STRINGS.BUBBLES
		xpFrameData[self.barNum][2] = percentXP.."%"

		self.nextXP = nextXP
		self.currXP = currXP
		self.restedXP = restedXP
	end

	if (event == "UPDATE_FACTION" or "CHAT_MSG_COMBAT_FACTION_CHANGE") then

		local name, hex, standing, standingID, barMin, barMax, barValue, isHeader
		local repLevel = "Unknown"
		local index = 1

		if (GetNumFactions() > 0) then

			TrinityXPSavedState.repNameIndex[self.barNum] = {}
			TrinityXPSavedState.repFactionIndex[self.barNum] = {}
			TrinityXPSavedState.repDropDownIndex[self.barNum] = {}

			for i=1, GetNumFactions() do

				if (not IsFactionInactive(i)) then

					name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, _ = GetFactionInfo(i)

					if (isHeader == nil) then

						hex = format("%02x%02x%02x", repColors[standingID].r*255, repColors[standingID].g*255, repColors[standingID].b*255)

						TrinityXPSavedState.repNameIndex[self.barNum][index] = repColors[standingID].l..i.."|"..name

						TrinityXPSavedState.repFactionIndex[self.barNum][index] = repColors[standingID].l..i
						TrinityXPSavedState.repDropDownIndex[self.barNum][index] = repColors[standingID].l..i.."|cff"..hex..name.." - "..math.floor(((barValue-barMin)/(barMax-barMin))*100).."%|r"

						if (TrinityXPSavedState.repMonitor[self.barNum] == 0 and name) then
							TrinityXPSavedState.repMonitor[self.barNum] = i
							TrinityXPSavedState.repSelect[self.barNum] = i
						end

						index = index + 1
					end

					if (TrinityXPSavedState.repSelect[self.barNum] == -1) then
						if (message) then
							if (find(message, name)) then
								TrinityXPSavedState.repMonitor[self.barNum] = i
							end
						end
					else
						if (TrinityXPSavedState.repSelect[self.barNum] ~= 0) then
							TrinityXPSavedState.repMonitor[self.barNum] = TrinityXPSavedState.repSelect[self.barNum]
						end
					end
				end
			end

			table.sort(TrinityXPSavedState.repNameIndex[self.barNum])
			table.sort(TrinityXPSavedState.repFactionIndex[self.barNum])
			table.sort(TrinityXPSavedState.repDropDownIndex[self.barNum])

			for k,v in pairs(TrinityXPSavedState.repNameIndex[self.barNum]) do
				TrinityXPSavedState.repNameIndex[self.barNum][k] = gsub(v, "^[^|]+", "")
				TrinityXPSavedState.repNameIndex[self.barNum][k] = gsub(TrinityXPSavedState.repNameIndex[self.barNum][k], "^%|+", "")
			end

			if (TrinityXPSavedState.repMonitor[self.barNum]) then

				for k,v in pairs(TrinityXPSavedState.repFactionIndex[self.barNum]) do
					if (tonumber(TrinityXPSavedState.repMonitor[self.barNum]) == tonumber(string.match(v, "%d+"))) then
						index = k
					end
				end

				if (index) then

					for i=1, GetNumFactions() do
						if (not IsFactionInactive(i)) then
							name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, _ = GetFactionInfo(i)
							if (name == TrinityXPSavedState.repNameIndex[self.barNum][index]) then
								break
							end
						end
					end

					if (TrinityXPSavedState.repNameIndex[self.barNum][index]) then

						standing = gsub(repColors[standingID].l, "^%a%p", "")

						xpFrameData[self.barNum][4] = TrinityXPSavedState.repNameIndex[self.barNum][index].." - "..standing.." ("..math.floor(((barValue-barMin)/(barMax-barMin))*100).."%)"
						xpFrameData[self.barNum][5] = TrinityXPSavedState.repNameIndex[self.barNum][index].." - "..(barValue-barMin).."/"..(barMax-barMin)
						self.repMax = barMax-barMin
						self.repCurr = barValue-barMin
						self.standingID = standingID
						self.repLevel = repColors[standingID].l

					end
				end
			end
		end
	end

	XPBar_Update(self)
end

TrinityXP.AdjustableActions = {

	[TRINITYXP_STRINGS.DOCK_OPT_1] = {
		function(dockFrame, action, button)
			if (action) then
				dockFrame.elapsed = 0
				TrinityXP.UpdateHeight(dockFrame, action, button)
				TrinityXP.UpdateDockElement(dockFrame)
			end
			return dockFrame.config.barHeight
		end,
		["editmode"] = 1,
	},

	[TRINITYXP_STRINGS.DOCK_OPT_2] = {
		function(dockFrame, action, button)
			if (action) then
				dockFrame.elapsed = 0
				TrinityXP.UpdateWidth(dockFrame, action, button)
				TrinityXP.UpdateDockElement(dockFrame)
			end
			return dockFrame.config.barWidth
		end,
		["editmode"] = 1,
	},

	[TRINITYXP_STRINGS.DOCK_OPT_3] = {
		function(dockFrame, action)
			if (action) then
				dockFrame.elapsed = 0
				TrinityXP.UpdateScale(dockFrame, action)
				TrinityXP.UpdateDockElement(dockFrame)
			end
			return dockFrame.config.scale
		end,
		["editmode"] = 1,
	},

	[TRINITYXP_STRINGS.DOCK_OPT_4] = {
		function(dockFrame, action)
			if (action) then
				dockFrame.elapsed = 0
				TrinityXP.UpdateAlpha(dockFrame, action)
				TrinityXP.UpdateDockElement(dockFrame)
			end
			return dockFrame.config.alpha
		end,
		["editmode"] = 1,
	},

	[TRINITYXP_STRINGS.DOCK_OPT_5] = {
		function(dockFrame, action)
			if (action) then
				dockFrame.elapsed = 0
				TrinityXP.ChangeTexture(dockFrame, action)
				TrinityXP.UpdateDockElement(dockFrame)
			end
			return barTextures[dockFrame.config.texture][1]
		end,
		["editmode"] = 1,
	},

	[TRINITYXP_STRINGS.DOCK_OPT_6] = {
		function(dockFrame, action)
			if (action) then
				dockFrame.elapsed = 0
				TrinityXP.ChangeBorder(dockFrame, action)
				TrinityXP.UpdateDockElement(dockFrame)
			end
			return barBorders[dockFrame.config.border][1]
		end,
		["editmode"] = 1,
	},

}

TrinityXP.CheckboxActions = {}

TrinityXP.ColorPickerActions = {
	[TRINITYXP_STRINGS.COLOR_OPT_1] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityXP.UpdateRestColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.restcolor
			end
		end },
	[TRINITYXP_STRINGS.COLOR_OPT_2] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityXP.UpdateNorestColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.norestcolor
			end
		end },
	[TRINITYXP_STRINGS.COLOR_OPT_3] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityXP.UpdateBorderColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.bordercolor
			end
		end },
	[TRINITYXP_STRINGS.COLOR_OPT_4] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityXP.UpdateTextColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.textcolor
			end
		end },
}

function TrinityXP.Loader_OnLoad(self)

	self:RegisterEvent("VARIABLES_LOADED")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.shown = true
end

function TrinityXP.Loader_OnEvent(self, event)

	if (event == "VARIABLES_LOADED") then


		for k,v in pairs(TrinityXP.AdjustableActions) do
			Trinity2.AdjustableActions[k] = v
		end

		for k,v in pairs(TrinityXP.CheckboxActions) do
			Trinity2.CheckboxActions[k] = v
		end

		for k,v in pairs(TrinityXP.ColorPickerActions) do
			Trinity2.ColorPickerActions[k] = v
		end
	end

	if (event == "PLAYER_LOGIN") then
		if (TrinityXPSavedState.firstRun) then
			TrinityXP.InitializeDockDefaults()
		else
			TrinityXP.LoadSV()
		end

		for k,dockFrame in pairs(dockIndex) do
			TrinityXP.UpdateDockElement(dockFrame)
			TrinityXP.SetTexture(dockFrame)
			TrinityXP.SetBorder(dockFrame)
		end

		updateDockPostions(TrinityXPSavedState.firstRun)

		TrinityXPSavedState.firstRun = false
	end

	if (event == "PLAYER_ENTERING_WORLD") then
		playerEnteredWorld = true
	end
end

function TrinityXP.CreateXPBar(index)

	local dockFrame, xpBar, name, first, last
	local defaultConfig = {}

	dockFrame = createDockFrame(index)

	for key,value in pairs(dockFrame.config) do
		defaultConfig[key] = value
	end

	if (TrinityXPSavedState["docks"][index]) then
		dockFrame.config = TrinityXPSavedState["docks"][index][1]
	else
		dockDefaults(index, dockFrame)
		TrinityXPSavedState["docks"][index] = { dockFrame.config }
	end

	-- New Vars
	for key,value in pairs(defaultConfig) do
		if (dockFrame.config[key] == nil) then
			dockFrame.config[key] = value
		end
	end
	-- New Vars

	dockFrame.config.name = TRINITYXP_STRINGS.XPBAR..index

	xpBar = CreateFrame("Button", "TrinityXPRepBar"..index, UIParent, "TrinityXPRepBarTemplate")
	xpBar:SetID(index)
	xpBar:Show()

	TrinityXP.Bar_OnCreate(xpBar, index)

	dockFrame:SetUserPlaced(false)
	dockFrame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)
	dockFrame:SetUserPlaced(true)

	xpBar:ClearAllPoints()
	xpBar:SetPoint("CENTER", dockFrame, "CENTER", 0, 0)
	xpBar:SetFrameLevel(1)
	xpBar:SetToplevel(true)

	--name = string.gsub(xpBar:GetName(), "(Trinity)(XP)(Rep)(Bar)(%d+)", "%1 %2/%3 %4 %5")
	getglobal(dockFrame:GetName().."Text"):SetText(dockFrame.config.name)

	dockFrame.element = xpBar

	return dockFrame

end

function TrinityXP.DeleteXPBar(self)

	dockIndex[self:GetID()] = nil
	TrinityXPSavedState.docks[self:GetID()] = nil
	Trinity2.RegisteredDocks[self:GetName()] = nil
	self.element:Hide()
	self:Hide()
end

function TrinityXP.Bar_OnCreate(self, index)

	self:RegisterEvent("PLAYER_XP_UPDATE")
	self:RegisterEvent("UPDATE_EXHAUSTION")
	self:RegisterEvent("UPDATE_FACTION")
	self:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	self:SetFrameLevel(3)
	self.bar = getglobal(self:GetName().."Bar")
	self.barborder = getglobal(self:GetName().."BarBorder")
	self.text = getglobal(self:GetName().."BarText")
	self.dropdown = getglobal(self:GetName().."DropDown")
	self.barNum = index
	self.click = false
	self.standingID = 0
	self.xpmark = {}
	self.lastText = 1

	--local texture
	--for i=1,19 do
	--	texture = self.bar:CreateTexture(self.bar:GetName().."Mark"..i, "OVERLAY", "TrinityXPMarker")
	--	texture:SetPoint("TOPLEFT", (self:GetWidth()/19*i), 1)
	--	texture:SetPoint("BOTTOMLEFT", (self:GetWidth()/19*i), -1)
	--	self.xpmark[i] = texture
	--end

	if (not TrinityXPSavedState.textIndex[self.barNum]) then
		TrinityXPSavedState.textIndex[self.barNum] = 1
	end

	if (not TrinityXPSavedState.repSelect[self.barNum]) then
		TrinityXPSavedState.repSelect[self.barNum] = 0
	end

	if (not TrinityXPSavedState.repMonitor[self.barNum]) then
		TrinityXPSavedState.repMonitor[self.barNum] = 0
	end

	if (not TrinityXPSavedState.repNameIndex[self.barNum]) then
		TrinityXPSavedState.repNameIndex[self.barNum] = {}
	end

	if (not TrinityXPSavedState.repNameIndex[self.barNum]) then
		TrinityXPSavedState.repNameIndex[self.barNum] = {}
	end

	if (not TrinityXPSavedState.repFactionIndex[self.barNum]) then
		TrinityXPSavedState.repFactionIndex[self.barNum] = {}
	end

	if (not TrinityXPSavedState.repDropDownIndex[self.barNum]) then
		TrinityXPSavedState.repDropDownIndex[self.barNum] = {}
	end

	xpFrameData[self.barNum] = {}

	clickedBar = self

	updateXPRep(self, "PLAYER_XP_UPDATE", nil)
	updateXPRep(self, "UPDATE_FACTION", nil)
end

function TrinityXP.Bar_OnEvent(self)
	updateXPRep(self, event, arg1)
end

function TrinityXP.Bar_OnEnter(self)

	self.lastText = TrinityXPSavedState.textIndex[self.barNum]

	TrinityXPSavedState.textIndex[self.barNum] = onEnter[TrinityXPSavedState.textIndex[self.barNum]]

	if (not TrinityXPSavedState.textIndex[self.barNum]) then
		TrinityXPSavedState.textIndex[self.barNum] = 1
	end

	XPBar_Update(self)
end

function TrinityXP.Bar_OnLeave(self)

	if (not self.click) then
		TrinityXPSavedState.textIndex[self.barNum] = self.lastText
	end

	if (not TrinityXPSavedState.textIndex[self.barNum]) then
		TrinityXPSavedState.textIndex[self.barNum] = 1
	end

	self.click = false

	XPBar_Update(self)
end

function TrinityXP.Bar_OnClick(self)

	clickedBar = self

	if (arg1 == "RightButton") then
		if (DropDownList1:IsVisible()) then
			DropDownList1:Hide()
		else
			TrinityXP.RepDropDown_OnLoad(self.dropdown)
			updateXPRep(self, "UPDATE_FACTION", nil)
			ToggleDropDownMenu(1, nil, self.dropdown, self, 0, 0)
			DropDownList1:ClearAllPoints()
			DropDownList1:SetPoint("LEFT", self, "RIGHT", 3, 0)
			DropDownList1:SetClampedToScreen(true)
			PlaySound("igMainMenuOptionCheckBoxOn")
		end
	else

		if (not TrinityXPSavedState.textIndex[self.barNum]) then
			TrinityXPSavedState.textIndex[self.barNum] = 1
		end

		TrinityXPSavedState.textIndex[self.barNum] = TrinityXPSavedState.textIndex[self.barNum] + 1
		if ( TrinityXPSavedState.textIndex[self.barNum] > getn(xpFrameData[self.barNum])) then
			TrinityXPSavedState.textIndex[self.barNum] = 1
		end
		XPBar_Update(self)
	end

	self.click = true
end

function TrinityXP.InitializeDockDefaults()

	local dockFrame = TrinityXP.CreateXPBar(1)
	dockFrame.config.barWidth = 863
	dockFrame.config.barHeight = 8
end

function TrinityXP.LoadSV()

	local dockFrame

	for k,v in pairs(TrinityXPSavedState.docks) do
		dockFrame = TrinityXP.CreateXPBar(k)
	end
end

function TrinityXP.UpdateDockElement(dockFrame)

	dockFrame.element:SetWidth(dockFrame.config["barWidth"])
	dockFrame.element:SetHeight(dockFrame.config["barHeight"])
	dockFrame.element.bar:SetOrientation(dockFrame.config["orientation"])
	dockFrame.element:SetScale(dockFrame.config["scale"])
	dockFrame.element:SetAlpha(dockFrame.config["alpha"])
	dockFrame.element.text:SetTextColor(dockFrame.config["textcolor"][1], dockFrame.config["textcolor"][2], dockFrame.config["textcolor"][3])
	dockFrame.element.barborder:SetBackdropBorderColor(dockFrame.config["bordercolor"][1], dockFrame.config["bordercolor"][2], dockFrame.config["bordercolor"][3])

	dockFrame.element.restcolor = dockFrame.config["restcolor"]
	dockFrame.element.norestcolor = dockFrame.config["norestcolor"]
	dockFrame.element.bordercolor = dockFrame.config["bordercolor"]
	dockFrame.element.textcolor = dockFrame.config["textcolor"]

	XPBar_Update(dockFrame.element)
	TrinityXP.UpdateDock(dockFrame)
end

function TrinityXP.UpdateDock(dockFrame)

	if (dockFrame.elapsed < 0.75) then
		dockFrame.update = true
		return
	end

	dockFrame:SetWidth(dockFrame.element:GetWidth() * dockFrame.config["scale"])
	dockFrame:SetHeight(dockFrame.element:GetHeight() * 1.5 * dockFrame.config["scale"])

	dockFrame:SetUserPlaced(false)
	dockFrame:SetPoint("CENTER", "UIParent", "BOTTOMLEFT", dockFrame.config.centerx, dockFrame.config.centery)
	dockFrame:SetUserPlaced(true)

	TrinityXP.SaveState()
end

function TrinityXP.SaveState()

	local dockFrame

	TrinityXPSavedState["docks"] = {}

	for k,dockFrame in pairs(dockIndex) do
		TrinityXPSavedState["docks"][k] = { dockFrame.config }
	end
end

function TrinityXP.UpdateScale(dockFrame, action)

	dockFrame.elapsed = 0

	if (action == "add") then
		dockFrame.config["scale"] = dockFrame.config["scale"] + 0.01
	else
		dockFrame.config["scale"] = dockFrame.config["scale"] - 0.01
		if (dockFrame.config["scale"] < 0.2) then
			dockFrame.config["scale"] = 0.2
		end
	end
end

function TrinityXP.UpdateAlpha(dockFrame, action)

	dockFrame.elapsed = 0

	if (action == "add") then
		dockFrame.config["alpha"] = dockFrame.config["alpha"] + 0.05
		if (dockFrame.config["alpha"] > 1) then
			dockFrame.config["alpha"] = 1
		end
	else
		dockFrame.config["alpha"] = dockFrame.config["alpha"] - 0.05
		if (dockFrame.config["alpha"] < 0.1) then
			dockFrame.config["alpha"] = 0.1
		end
	end
end

function TrinityXP.UpdateWidth(dockFrame, action, button)

	dockFrame.elapsed = 0

	local modifier = math.ceil(button.elapsed/0.5)

	if (modifier <= 0) then
		modifier = 1
	end

	if (action == "add") then
		dockFrame.config["barWidth"] = dockFrame.config["barWidth"] + 0.5 * modifier
	else
		dockFrame.config["barWidth"] = dockFrame.config["barWidth"] - 0.5 * modifier
		if (dockFrame.config["barWidth"] < 10) then
			dockFrame.config["barWidth"] = 10
		end
	end
end

function TrinityXP.UpdateHeight(dockFrame, action, button)

	dockFrame.elapsed = 0

	local modifier = math.ceil(button.elapsed/0.5)

	if (modifier <= 0) then
		modifier = 1
	end

	if (action == "add") then
		dockFrame.config["barHeight"] = dockFrame.config["barHeight"] + 0.5 * modifier
	else
		dockFrame.config["barHeight"] = dockFrame.config["barHeight"] - 0.5 * modifier
		if (dockFrame.config["barHeight"] < 4) then
			dockFrame.config["barHeight"] = 4
		end
	end
end

function TrinityXP.ChangeTexture(dockFrame, action)

	local index = dockFrame.config.texture

	if (type(index) ~= "number") then
		index = 1
	end

	if (action == "subtract") then
		if (index == 1) then
			index = getn(barTextures)
		else
			index = index - 1;
		end

		dockFrame.config.texture = index;

	elseif (action == "add") then
		if (index == getn(barTextures)) then
			index = 1;
		else
			index = index + 1;
		end

		dockFrame.config.texture = index;
	end

	TrinityXP.SetTexture(dockFrame)
end

function TrinityXP.SetTexture(dockFrame)

	dockFrame.element.bar:SetStatusBarTexture(barTextures[dockFrame.config.texture][2])
end

function TrinityXP.ChangeBorder(dockFrame, action)

	local index = dockFrame.config.border

	if (type(index) ~= "number") then
		index = 1
	end

	if (action == "subtract") then
		if (index == 1) then
			index = getn(barBorders)
		else
			index = index - 1;
		end

		dockFrame.config.border = index;

	elseif (action == "add") then
		if (index == getn(barBorders)) then
			index = 1;
		else
			index = index + 1;
		end

		dockFrame.config.border = index;
	end

	TrinityXP.SetBorder(dockFrame)
end

function TrinityXP.SetBorder(dockFrame)

	local border = getglobal(dockFrame.element.bar:GetName().."Border")
	local background = getglobal(dockFrame.element.bar:GetName().."Background")

	border:SetBackdrop( { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = barBorders[dockFrame.config.border][2],
				tile = true,
				tileSize = barBorders[dockFrame.config.border][7],
				edgeSize = barBorders[dockFrame.config.border][8],
				insets = { left = barBorders[dockFrame.config.border][3],
					   right = barBorders[dockFrame.config.border][4],
					   top = barBorders[dockFrame.config.border][5],
					   bottom = barBorders[dockFrame.config.border][6]
					 }
				} )

	border:SetPoint("TOPLEFT", barBorders[dockFrame.config.border][9], barBorders[dockFrame.config.border][10])
	border:SetPoint("BOTTOMRIGHT", barBorders[dockFrame.config.border][11], barBorders[dockFrame.config.border][12])

	border:SetBackdropColor(0, 0, 0, 0)
	border:SetBackdropBorderColor(dockFrame.config["bordercolor"][1], dockFrame.config["bordercolor"][2], dockFrame.config["bordercolor"][3], 1)
	border:SetFrameLevel(dockFrame.element.bar:GetFrameLevel()+1)

	background:SetBackdropColor(0, 0, 0, 1)
	background:SetBackdropBorderColor(0, 0, 0, 0)
	background:SetFrameLevel(0)
end

function TrinityXP.RepDropDown_OnLoad(self)

	if (TrinityXPSavedState.repSelect[self.barNum] == 0) then
		TrinityXPSavedState.repSelect[self.barNum] = TrinityXPSavedState.repMonitor[self.barNum]
	end
	UIDropDownMenu_Initialize(self, TrinityXP.RepDropDown_Initialize, "MENU")
end

function TrinityXP.RepDropDown_Initialize()

	if (clickedBar) then

		local info = UIDropDownMenu_CreateInfo()
		local checked, repLine, repIndex

		info.text = "Auto Select"
		info.func = function() TrinityXPSavedState.repSelect[clickedBar.barNum] = this.value updateXPRep(clickedBar, "UPDATE_FACTION") end
		if (TrinityXPSavedState.repSelect[clickedBar.barNum] == -1) then
			checked = 1
		else
			checked = nil
		end
		info.value = -1
		info.checked = checked
		UIDropDownMenu_AddButton(info)

		for i=1,getn(TrinityXPSavedState.repDropDownIndex[clickedBar.barNum]) do

			repIndex = tonumber(string.match(TrinityXPSavedState.repFactionIndex[clickedBar.barNum][i], "%d+"))
			repLine = gsub(TrinityXPSavedState.repDropDownIndex[clickedBar.barNum][i], "^[^|]+", "")

			info.text = repLine
			info.func = function() TrinityXPSavedState.repSelect[clickedBar.barNum] = this.value if (TrinityXPSavedState.textIndex[clickedBar.barNum] < 4) then TrinityXPSavedState.textIndex[clickedBar.barNum] = 4 end updateXPRep(clickedBar, "UPDATE_FACTION") end

			if (repIndex == TrinityXPSavedState.repSelect[clickedBar.barNum]) then
				checked = 1
			else
				checked = nil
			end
			info.value = repIndex
			info.checked = checked
			UIDropDownMenu_AddButton(info)
		end
	end
end

function TrinityXP.UpdateRestColor(dockFrame, r, g, b)

	dockFrame.config.restcolor = { r, g, b }

	TrinityXP.UpdateDockElement(dockFrame)
end

function TrinityXP.UpdateNorestColor(dockFrame, r, g, b)

	dockFrame.config.norestcolor = { r, g, b }

	TrinityXP.UpdateDockElement(dockFrame)
end

function TrinityXP.UpdateBorderColor(dockFrame, r, g, b)

	dockFrame.config.bordercolor = { r, g, b }

	TrinityXP.UpdateDockElement(dockFrame)
end

function TrinityXP.UpdateTextColor(dockFrame, r, g, b)

	dockFrame.config.textcolor = { r, g, b }

	TrinityXP.UpdateDockElement(dockFrame)
end