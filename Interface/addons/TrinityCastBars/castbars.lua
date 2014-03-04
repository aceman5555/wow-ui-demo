TrinityCastBars = {}

TrinityCastBarsSavedState = {}
TrinityCastBarsSavedState.firstRun = true
TrinityCastBarsSavedState["docks"] = {}

local dockIndex = {}
local playerEnteredWorld = false
local unitNames = {
	[1] = "player",
	[2] = "pet",
	[3] = "target",
	[4] = "targettarget",
	[5] = "focus",
	[6] = "party1",
	[7] = "partypet1",
	[8] = "party2",
	[9] = "partypet2",
	[10] = "party3",
	[11] = "partypet3",
	[12] = "party4",
	[13] = "partypet4",
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
	[3] = { "Dialog", "Interface\\AddOns\\Trinity2\\images\\Trinity-DialogBox-Border", 11, 12, 12, 11, 26, 26, -7, 7, 7, -7 },
	[4] = { "None", "", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

local function dockDefaults(index, dockFrame)

	dockFrame:SetID(index)
	dockFrame.config = {
		["name"] = "",
		["dockStrata"] = "MEDIUM",
		["scale"] = 1,
		["alpha"] = 1,
		["barWidth"] = 200,
		["barHeight"] = 12,
		["orientation"] = "HORIZONTAL",
		["autohide"] = false,
		["show icon"] = false,
		["spell text"] = true,
		["timer text"] = true,
		["unit"] = "player",
		["texture"] = 1,
		["border"] = 1,
		["spells"] = "all",
		["barcolor"] = { 1, 0.7, 0 },
		["bordercolor"] = { 0.8, 0.8, 0.8 },
		["textcolor"] = { 1, 1, 1 },
		["timercolor"] = { 1, 1, 1 },
		["successcolor"] = { 0, 1, 0 },
		["failedcolor"] = { 1, 0, 0 },
		["centerx"] = (UIParent:GetWidth()/2)*UIParent:GetEffectiveScale(),
		["centery"] = (UIParent:GetHeight()/2)*UIParent:GetEffectiveScale(),
	}

	dockFrame.elapsed = 3
	dockFrame.update = false

	if (TrinityCastBarsSavedState.firstRun) then
		TrinityCastBarsSavedState["docks"][index] = { dockFrame.config }
	end
end

local function createDockFrame(index)

	local dockFrame = CreateFrame("Button", "TrinityCastBarsDock"..index, UIParent, "Trinity2DockFrameTemplate")

	dockDefaults(index, dockFrame)

	dockFrame.func1 = function(self) TrinityCastBars.SaveState() end
	dockFrame.func2 = function(self) TrinityCastBars.UpdateDockElement(self) end

	dockFrame.leftFunc1 = function(self, action, button) self.elapsed = 0 TrinityCastBars.UpdateScale(self, action) TrinityCastBars.UpdateDockElement(self) end
	dockFrame.leftFunc2 = function(self, action, button) self.elapsed = 0 TrinityCastBars.UpdateAlpha(self, action) TrinityCastBars.UpdateDockElement(self) end
	dockFrame.rightFunc1 = function(self, action, button) self.elapsed = 0 TrinityCastBars.UpdateWidth(dockFrame, action, button) TrinityCastBars.UpdateDockElement(self) end
	dockFrame.rightFunc2 = function(self, action, button) self.elapsed = 0 TrinityCastBars.UpdateHeight(dockFrame, action, button) TrinityCastBars.UpdateDockElement(self) end

	dockFrame.create = function(self) local dockFrame = TrinityCastBars.CreateCastBar(#dockIndex+1) dockFrame:Show() TrinityCastBars.UpdateDockElement(dockFrame) end
	if (index ~= 1) then
		dockFrame.delete = function(self) local dockFrame = TrinityCastBars.DeleteCastBar(self) end
	end

	dockFrame.owner = "TrinityCastBars_"

	dockFrame.simpleActionSet = {
		[TRINITYCASTBARS_STRINGS.DOCK_OPT_1] = true,
		[TRINITYCASTBARS_STRINGS.DOCK_OPT_2] = "default",
		[TRINITYCASTBARS_STRINGS.DOCK_OPT_3] = true,
		[TRINITYCASTBARS_STRINGS.DOCK_OPT_4] = true,
		[TRINITYCASTBARS_STRINGS.DOCK_OPT_5] = true,
		[TRINITYCASTBARS_STRINGS.DOCK_OPT_6] = true,
		[TRINITYCASTBARS_STRINGS.DOCK_OPT_7] = true,
	}

	dockFrame.actionSet = {
		[TRINITYCASTBARS_STRINGS.DOCK_OPT_3] = true,
		[TRINITYCASTBARS_STRINGS.DOCK_OPT_4] = true,
		[TRINITYCASTBARS_STRINGS.DOCK_OPT_5] = true,
		[TRINITYCASTBARS_STRINGS.DOCK_OPT_6] = true,
		[TRINITYCASTBARS_STRINGS.DOCK_OPT_7] = true,
	}

	dockFrame.checkSet = {
		[TRINITYCASTBARS_STRINGS.CHECK_OPT_1] = true,
		[TRINITYCASTBARS_STRINGS.CHECK_OPT_2] = true,
		[TRINITYCASTBARS_STRINGS.CHECK_OPT_3] = true,
	}

	dockFrame.colorSet = {
		[TRINITYCASTBARS_STRINGS.COLOR_OPT_1] = true,
 		[TRINITYCASTBARS_STRINGS.COLOR_OPT_2] = true,
 		[TRINITYCASTBARS_STRINGS.COLOR_OPT_3] = true,
 		[TRINITYCASTBARS_STRINGS.COLOR_OPT_4] = true,
 		[TRINITYCASTBARS_STRINGS.COLOR_OPT_5] = true,
 		[TRINITYCASTBARS_STRINGS.COLOR_OPT_6] = true,
 	}

	dockIndex[index] = dockFrame

	Trinity2.RegisteredDocks[dockFrame:GetName()] = function(frame) TrinityCastBars.UpdateDockElement(frame) end

	return dockFrame
end

local function updateDockPostions(reset)

	local dockFrame, dockFrameHeight

	local anchor = "BOTTOM";
	local relTo = "UIParent";
	local relPoint = "BOTTOM";
	local x = UIParent:GetBottom()
	local y = 335;

	if (reset) then

		dockFrameHeight = 45;

		for k,dockFrame in pairs(dockIndex) do

			dockFrame:SetUserPlaced(false)
			dockFrame:ClearAllPoints()
			if (dockFrame:GetID() == 1) then
				dockFrame:SetPoint("CENTER", relTo, relPoint, 0, 107)
			else
				dockFrame:SetPoint(anchor, relTo, relPoint, x, y)
			end
			dockFrame.config.centerx, dockFrame.config.centery = dockFrame:GetCenter()
			dockFrame:SetUserPlaced(true)

			y = y + dockFrameHeight
		end

		TrinityCastBarsSavedState.firstRun = false;
	else
		for k,dockFrame in pairs(dockIndex) do

			dockFrame:SetUserPlaced(false)
			dockFrame:ClearAllPoints()
			dockFrame:SetPoint("CENTER", relTo, "BOTTOMLEFT", dockFrame.config.centerx, dockFrame.config.centery)
			dockFrame:SetUserPlaced(true)
		end
	end

	TrinityCastBars.SaveState()
end

TrinityCastBars.AdjustableActions = {

	[TRINITYCASTBARS_STRINGS.DOCK_OPT_1] = {
		function(dockFrame, action, button)
			if (action) then
				dockFrame.elapsed = 0
				TrinityCastBars.UpdateHeight(dockFrame, action, button)
				TrinityCastBars.UpdateDockElement(dockFrame)
			end
			return dockFrame.config.barHeight
		end,
		["editmode"] = 1,
	},

	[TRINITYCASTBARS_STRINGS.DOCK_OPT_2] = {
		function(dockFrame, action, button)
			if (action) then
				dockFrame.elapsed = 0
				TrinityCastBars.UpdateWidth(dockFrame, action, button)
				TrinityCastBars.UpdateDockElement(dockFrame)
			end
			return dockFrame.config.barWidth
		end,
		["editmode"] = 1,
	},


	[TRINITYCASTBARS_STRINGS.DOCK_OPT_3] = {
		function(dockFrame, action)
			if (action) then
				dockFrame.elapsed = 0
				TrinityCastBars.UpdateScale(dockFrame, action)
				TrinityCastBars.UpdateDockElement(dockFrame)
			end
			return dockFrame.config.scale
		end,
		["editmode"] = 1,
	},

	[TRINITYCASTBARS_STRINGS.DOCK_OPT_4] = {
		function(dockFrame, action)
			if (action) then
				dockFrame.elapsed = 0
				TrinityCastBars.UpdateAlpha(dockFrame, action)
				TrinityCastBars.UpdateDockElement(dockFrame)
			end
			return dockFrame.config.alpha
		end,
		["editmode"] = 1,
	},

	[TRINITYCASTBARS_STRINGS.DOCK_OPT_5] = {
		function(dockFrame, action)
			if (action) then
				dockFrame.elapsed = 0
				TrinityCastBars.ChangeUnit(dockFrame, action)
				TrinityCastBars.UpdateDockElement(dockFrame)
			end

			if (dockFrame) then

				local data = {}

				for k,v in pairs(unitNames) do
					data[v] = k
				end

				return dockFrame.config.unit, data
			end
		end,
		["editmode"] = 2,
	},

	[TRINITYCASTBARS_STRINGS.DOCK_OPT_6] = {
		function(dockFrame, action)
			if (action) then
				dockFrame.elapsed = 0
				TrinityCastBars.ChangeTexture(dockFrame, action)
				TrinityCastBars.UpdateDockElement(dockFrame)
			end
			return barTextures[dockFrame.config.texture][1]
		end,
		["editmode"] = 1,
	},

	[TRINITYCASTBARS_STRINGS.DOCK_OPT_7] = {
		function(dockFrame, action)
			if (action) then
				dockFrame.elapsed = 0
				TrinityCastBars.ChangeBorder(dockFrame, action)
				TrinityCastBars.UpdateDockElement(dockFrame)
			end
			return barBorders[dockFrame.config.border][1]
		end,
		["editmode"] = 1,
	},

}

TrinityCastBars.CheckboxActions = {
	["TrinityCastBars_1"] = {
		"show icon",
		function(self, dockFrame)
			TrinityCastBars.ToggleIcon(self, dockFrame)
		end,
		TRINITYCASTBARS_STRINGS.CHECK_OPT_1,
		TRINITYCASTBARS_STRINGS.TOOLTIP_ICON,
		["checkgroup"] = 1,
	},

	["TrinityCastBars_2"] = {
		"spell text",
		function(self, dockFrame)
			TrinityCastBars.ToggleSpellText(self, dockFrame)
		end,
		TRINITYCASTBARS_STRINGS.CHECK_OPT_2,
		TRINITYCASTBARS_STRINGS.TOOLTIP_SPELLTEXT,
		["checkgroup"] = 2,
	},

	["TrinityCastBars_3"] = {
		"timer text",
		function(self, dockFrame)
			TrinityCastBars.ToggleTimerText(self, dockFrame)
		end,
		TRINITYCASTBARS_STRINGS.CHECK_OPT_3,
		TRINITYCASTBARS_STRINGS.TOOLTIP_TIMERTEXT,
		["checkgroup"] = 3,
	},

}

TrinityCastBars.ColorPickerActions = {
	[TRINITYCASTBARS_STRINGS.COLOR_OPT_1] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityCastBars.UpdateBarColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.barcolor
			end
		end },
	[TRINITYCASTBARS_STRINGS.COLOR_OPT_2] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityCastBars.UpdateBorderColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.bordercolor
			end
		end },
	[TRINITYCASTBARS_STRINGS.COLOR_OPT_3] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityCastBars.UpdateTextColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.textcolor
			end
		end },
	[TRINITYCASTBARS_STRINGS.COLOR_OPT_4] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityCastBars.UpdateTimerColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.timercolor
			end
		end },
	[TRINITYCASTBARS_STRINGS.COLOR_OPT_5] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityCastBars.UpdateSucceessColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.successcolor
			end
		end },
	[TRINITYCASTBARS_STRINGS.COLOR_OPT_6] = {
		function(dockFrame, r, g, b)
			if (dockFrame and r and g and b) then
				TrinityCastBars.UpdateFailedColor(dockFrame, r, g, b)
			end
			if (dockFrame) then
				return dockFrame.config.failedcolor
			end
		end },
}

function TrinityCastBars.Loader_OnLoad(self)


end

function TrinityCastBars.Loader_OnEvent(self, event)

	if (event == "VARIABLES_LOADED") then

		for k,v in pairs(TrinityCastBars.AdjustableActions) do
			Trinity2.AdjustableActions[k] = v
		end

		for k,v in pairs(TrinityCastBars.CheckboxActions) do
			Trinity2.CheckboxActions[k] = v
		end

		for k,v in pairs(TrinityCastBars.ColorPickerActions) do
			Trinity2.ColorPickerActions[k] = v
		end
	end

	if (event == "PLAYER_LOGIN") then
		if (TrinityCastBarsSavedState.firstRun) then
			TrinityCastBars.InitializeDockDefaults()
		else
			TrinityCastBars.LoadSV()
		end

		for k,dockFrame in pairs(dockIndex) do
			TrinityCastBars.UpdateDockElement(dockFrame)
			TrinityCastBars.SetTexture(dockFrame)
			TrinityCastBars.SetBorder(dockFrame)
		end

		updateDockPostions(TrinityCastBarsSavedState.firstRun)

		TrinityCastBarsSavedState.firstRun = false
	end
	if (event == "PLAYER_ENTERING_WORLD") then
		playerEnteredWorld = true
	end
end

function TrinityCastBars.CreateCastBar(index)

	local dockFrame, castBar, name, first, last
	local defaultConfig = {}

	dockFrame = createDockFrame(index)

	for key,value in pairs(dockFrame.config) do
		defaultConfig[key] = value
	end

	if (TrinityCastBarsSavedState["docks"][index]) then
		dockFrame.config = TrinityCastBarsSavedState["docks"][index][1]
	else
		dockDefaults(index, dockFrame)
		TrinityCastBarsSavedState["docks"][index] = { dockFrame.config }
	end

	-- New Vars
	for key,value in pairs(defaultConfig) do
		if (dockFrame.config[key] == nil) then
			dockFrame.config[key] = value
		end
	end
	-- New Vars

	castBar = CreateFrame("StatusBar", "TrinityCastBar"..index, UIParent, "TrinityCastBarTemplate")
	castBar.unit = dockFrame.config.unit
	castBar:SetID(index)
	castBar:Hide()

	if (dockFrame.config.unit == "player") then
		CastingBarFrame:UnregisterAllEvents()
		CastingBarFrame:Hide()
	end

	dockFrame:SetUserPlaced(false)
	dockFrame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)
	dockFrame:SetUserPlaced(true)

	castBar:ClearAllPoints()
	castBar:SetPoint("CENTER", dockFrame, "CENTER", 8, 0)
	castBar:SetFrameLevel(1)
	castBar:SetToplevel(true)
	castBar.dummy:SetParent(dockFrame)
	castBar.dummy:Show()

	dockFrame.config.name = "Trinity"..TRINITYCASTBARS_STRINGS.CASTBAR.." "..index
	getglobal(dockFrame:GetName().."Text"):SetText(dockFrame.config.name)

	getglobal(castBar.dummy:GetName().."TextLeft"):SetText(string.gsub(dockFrame.config.unit, "^%l", string.upper)..TRINITYCASTBARS_STRINGS.CASTBAR)

	dockFrame.element = castBar

	return dockFrame

end

function TrinityCastBars.DeleteCastBar(self)

	dockIndex[self:GetID()] = nil
	TrinityCastBarsSavedState.docks[self:GetID()] = nil
	Trinity2.RegisteredDocks[self:GetName()] = nil
	self.element.unit = ""
	self:Hide()
end

function TrinityCastBars.Loader_OnUpdate(self, elapsed)

end

function TrinityCastBars.InitializeDockDefaults()

	local dockFrame = TrinityCastBars.CreateCastBar(1)
end

function TrinityCastBars.LoadSV()

	local dockFrame

	for k,v in pairs(TrinityCastBarsSavedState.docks) do
		dockFrame = TrinityCastBars.CreateCastBar(k)
	end
end

function TrinityCastBars.UpdateDockElement(dockFrame)

	dockFrame.element:SetWidth(dockFrame.config["barWidth"])
	dockFrame.element:SetHeight(dockFrame.config["barHeight"])
	dockFrame.element:SetOrientation(dockFrame.config["orientation"])
	dockFrame.element:SetScale(dockFrame.config["scale"])
	dockFrame.element:SetAlpha(dockFrame.config["alpha"])
	dockFrame.element:SetStatusBarColor(dockFrame.config["barcolor"][1], dockFrame.config["barcolor"][2], dockFrame.config["barcolor"][3])
	dockFrame.element.background:SetBackdropBorderColor(dockFrame.config["bordercolor"][1], dockFrame.config["bordercolor"][2], dockFrame.config["bordercolor"][3])
	dockFrame.element.barTextLeft:SetTextColor(dockFrame.config["textcolor"][1], dockFrame.config["textcolor"][2], dockFrame.config["textcolor"][3])
	dockFrame.element.barTextRight:SetTextColor(dockFrame.config["timercolor"][1], dockFrame.config["timercolor"][2], dockFrame.config["timercolor"][3])

	dockFrame.element.barcolor = dockFrame.config["barcolor"]
	dockFrame.element.bordercolor = dockFrame.config["bordercolor"]
	dockFrame.element.textcolor = dockFrame.config["textcolor"]
	dockFrame.element.timercolor = dockFrame.config["timercolor"]
	dockFrame.element.successcolor = dockFrame.config["successcolor"]
	dockFrame.element.failedcolor = dockFrame.config["failedcolor"]

	dockFrame.element.dummy:SetOrientation(dockFrame.config["orientation"])
	dockFrame.element.dummy:SetStatusBarColor(dockFrame.config["barcolor"][1], dockFrame.config["barcolor"][2], dockFrame.config["barcolor"][3])
	dockFrame.element.dummyBackground:SetBackdropBorderColor(dockFrame.config["bordercolor"][1], dockFrame.config["bordercolor"][2], dockFrame.config["bordercolor"][3])
	dockFrame.element.dummyTextLeft:SetTextColor(dockFrame.config["textcolor"][1], dockFrame.config["textcolor"][2], dockFrame.config["textcolor"][3])
	dockFrame.element.dummyTextRight:SetTextColor(dockFrame.config["timercolor"][1], dockFrame.config["timercolor"][2], dockFrame.config["timercolor"][3])

	if (dockFrame.config["show icon"]) then
		dockFrame.element.dummyIcon:Show()
	else
		dockFrame.element.dummyIcon:Hide()
	end

	if (dockFrame.config["spell text"]) then
		dockFrame.element.dummyTextLeft:Show()
	else
		dockFrame.element.dummyTextLeft:Hide()
	end

	if (dockFrame.config["timer text"]) then
		dockFrame.element.dummyTextRight:Show()
	else
		dockFrame.element.dummyTextRight:Hide()
	end

	dockFrame.element.showicon = dockFrame.config["show icon"]
	dockFrame.element.showspell = dockFrame.config["spell text"]
	dockFrame.element.showtimer = dockFrame.config["timer text"]


	TrinityCastBars.UpdateDock(dockFrame)
end

function TrinityCastBars.UpdateDock(dockFrame)

	if (dockFrame.elapsed < 0.75) then
		dockFrame.update = true
		return
	end

	dockFrame:SetWidth((dockFrame.element:GetWidth() + 8) * 1.1 * dockFrame.config.scale)
	dockFrame:SetHeight(dockFrame.element:GetHeight() * 1.8 * dockFrame.config.scale)

	TrinityCastBars.SaveState()
end

function TrinityCastBars.SaveState()

	local dockFrame

	TrinityCastBarsSavedState["docks"] = {}

	for k,dockFrame in pairs(dockIndex) do
		TrinityCastBarsSavedState["docks"][k] = { dockFrame.config }
	end
end

function TrinityCastBars.UpdateScale(dockFrame, action)

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

function TrinityCastBars.UpdateAlpha(dockFrame, action)

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

function TrinityCastBars.UpdateWidth(dockFrame, action, button)

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

function TrinityCastBars.UpdateHeight(dockFrame, action, button)

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

function TrinityCastBars.ChangeUnit(dockFrame, action)

	local index

	for i=1, getn(unitNames) do
		if (dockFrame.config.unit == unitNames[i]) then
			index = i
			break
		end
	end

	if (action == "subtract") then
		if (index == 1) then
			index = getn(unitNames)
		else
			index = index - 1;
		end

		dockFrame.config.unit = unitNames[index];

	elseif (action == "add") then
		if (index == getn(unitNames)) then
			index = 1;
		else
			index = index + 1;
		end

		dockFrame.config.unit = unitNames[index];
	end

	dockFrame.element.unit = dockFrame.config.unit
	getglobal(dockFrame.element.dummy:GetName().."TextLeft"):SetText(string.gsub(dockFrame.config.unit, "^%l", string.upper)..TRINITYCASTBARS_STRINGS.CASTBAR)
end

function TrinityCastBars.ChangeTexture(dockFrame, action)

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

	TrinityCastBars.SetTexture(dockFrame)
end

function TrinityCastBars.SetTexture(dockFrame)

	dockFrame.element:SetStatusBarTexture(barTextures[dockFrame.config.texture][2])
	dockFrame.element.dummy:SetStatusBarTexture(barTextures[dockFrame.config.texture][2])
end

function TrinityCastBars.ChangeBorder(dockFrame, action)

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

	TrinityCastBars.SetBorder(dockFrame)
end

function TrinityCastBars.SetBorder(dockFrame)

	local backdrop = getglobal(dockFrame.element:GetName().."Background")

	backdrop:SetBackdrop( { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
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

	backdrop:SetPoint("TOPLEFT", barBorders[dockFrame.config.border][9], barBorders[dockFrame.config.border][10])
	backdrop:SetPoint("BOTTOMRIGHT", barBorders[dockFrame.config.border][11], barBorders[dockFrame.config.border][12])

	backdrop:SetBackdropColor(0, 0, 0, 0)
	backdrop:SetBackdropBorderColor(0.8, 0.8, 0.8, 1)

	backdrop:SetFrameLevel(dockFrame.element:GetFrameLevel()+1)

	local backdrop = getglobal(dockFrame.element:GetName().."Flash")

	backdrop:SetBackdrop( { bgFile = "",
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

	backdrop:SetPoint("TOPLEFT", barBorders[dockFrame.config.border][9], barBorders[dockFrame.config.border][10])
	backdrop:SetPoint("BOTTOMRIGHT", barBorders[dockFrame.config.border][11], barBorders[dockFrame.config.border][12])

	backdrop:SetBackdropColor(1, 1, 1, 0.5)
	backdrop:SetBackdropBorderColor(dockFrame.config["bordercolor"][1], dockFrame.config["bordercolor"][2], dockFrame.config["bordercolor"][3])

	backdrop = getglobal(dockFrame.element:GetName().."DummyBackground")

	backdrop:SetBackdrop( { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
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

	backdrop:SetPoint("TOPLEFT", barBorders[dockFrame.config.border][9], barBorders[dockFrame.config.border][10])
	backdrop:SetPoint("BOTTOMRIGHT", barBorders[dockFrame.config.border][11], barBorders[dockFrame.config.border][12])

	backdrop:SetBackdropColor(0, 0, 0, 0)
	backdrop:SetBackdropBorderColor(dockFrame.config["bordercolor"][1], dockFrame.config["bordercolor"][2], dockFrame.config["bordercolor"][3])

	backdrop:SetFrameLevel(dockFrame.element.dummy:GetFrameLevel()+1)
end

function TrinityCastBars.ToggleIcon(self, dockFrame)

	if (self:GetChecked()) then
		dockFrame.config["show icon"] = true
	else
		dockFrame.config["show icon"] = false
	end

	TrinityCastBars.UpdateDockElement(dockFrame)
end

function TrinityCastBars.ToggleSpellText(self, dockFrame)

	if (self:GetChecked()) then
		dockFrame.config["spell text"] = true
	else
		dockFrame.config["spell text"] = false
	end

	TrinityCastBars.UpdateDockElement(dockFrame)
end

function TrinityCastBars.ToggleTimerText(self, dockFrame)

	if (self:GetChecked()) then
		dockFrame.config["timer text"] = true
	else
		dockFrame.config["timer text"] = false
	end

	TrinityCastBars.UpdateDockElement(dockFrame)
end

function TrinityCastBars.UpdateBarColor(dockFrame, r, g, b)

	dockFrame.config.barcolor = { r, g, b }

	TrinityCastBars.UpdateDockElement(dockFrame)
end

function TrinityCastBars.UpdateBorderColor(dockFrame, r, g, b)

	dockFrame.config.bordercolor = { r, g, b }

	TrinityCastBars.UpdateDockElement(dockFrame)
end

function TrinityCastBars.UpdateTextColor(dockFrame, r, g, b)

	dockFrame.config.textcolor = { r, g, b }

	TrinityCastBars.UpdateDockElement(dockFrame)
end

function TrinityCastBars.UpdateTimerColor(dockFrame, r, g, b)

	dockFrame.config.timercolor = { r, g, b }

	TrinityCastBars.UpdateDockElement(dockFrame)
end

function TrinityCastBars.UpdateSucceessColor(dockFrame, r, g, b)

	dockFrame.config.successcolor = { r, g, b }

	TrinityCastBars.UpdateDockElement(dockFrame)
end

function TrinityCastBars.UpdateFailedColor(dockFrame, r, g, b)

	dockFrame.config.failedcolor = { r, g, b }

	TrinityCastBars.UpdateDockElement(dockFrame)
end