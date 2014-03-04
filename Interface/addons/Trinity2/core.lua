Trinity2 = {
	SlashCommands = {},
	OptionSets = {},
	AdjustableActions = {},
	CheckboxActions = {},
	ColorPickerActions = {},
	RegisteredAddons = {},
	RegisteredDocks = {},
	RegisteredPanels = {},
	RegisteredOptions = {},
	OpenOptionsMenu = false,
	SoloEditMode = false,
	PlayerEnteredWorld = false,
	MaxDockShapes = 4,
	RegisteredAddonCount = 0,
	PanelPos = { x=0, y=0 },
	configMode = false,
}

Trinity2SavedState = {
	buttonLoc = { -28, -56 },
	buttonRadius = 87.5,
	debug = {},
	subMenuScale = 0.75,
	subMenuRadius = 32,
	savedOptions = {
		["CheckButtons"] = {
			[1] = 1,
			[2] = 1,
		},
	},
}

local lastOwner = ""
local maxOptionSets = 1
local subMenuButtons = {}
local templateFrames = {}

local gsub = string.gsub
local find = string.find
local match = string.match
local format = string.format
local lower = string.lower
local upper = string.upper
local random = math.random

local function copyTable(table)

	if (table == nil) then
		return
	end

	if (type(table) ~= "table") then
		return
	end

	local data = {}

	for k, v in pairs (table) do

		if (type(v) == "table") then
			data[k] = copyTable(v)
		else
			data[k] = v
		end
	end

	return data
end

local defaultSavedState = copyTable(Trinity2SavedState)

local function print(msg)

	if (TrinDev) then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	end
end

local function slashHandler(msg)

	local commands = {}

	if ((not msg) or (strlen(msg) <= 0)) then

		DEFAULT_CHAT_FRAME:AddMessage(TRINITY2_STRINGS.SLASH_HINT)

		for k,v in pairs(Trinity2.SlashCommands) do
			DEFAULT_CHAT_FRAME:AddMessage("  |cff00ff00"..k.."|r: "..Trinity2.SlashCommands[k][1])
		end

		return
	end

	gsub(msg, "(%S+)", function (cmd) tinsert(commands, cmd) end)

	if (Trinity2.SlashCommands[commands[1]]) then

		local command

		for k,v in ipairs(commands) do
			if (k ~= 1) then
				if (not command) then
					command = v
				else
					command = command.." "..v
				end
			end
		end

		Trinity2.SlashCommands[commands[1]][2](command)
	else
		for k,v in pairs(Trinity2.SlashCommands) do
			DEFAULT_CHAT_FRAME:AddMessage("  |cff00ff00"..k.."|r: "..Trinity2.SlashCommands[k][1])
		end
	end

end

local function changeDock(self)

	if (Trinity2.PlayerEnteredWorld) then

		local newDock = false

		for k,v in pairs(Trinity2.RegisteredDocks) do
			if (getglobal(k) ~= self) then
				getglobal(k):SetBackdropColor(0,0,0,0.2)
				getglobal(k):SetBackdropBorderColor(0.3,0.3,0.3,0.3)
				getglobal(k).selected = false
				getglobal(k).microAdjust = false
				getglobal(k):EnableKeyboard(false)
				getglobal(k.."Text"):Hide()
			end
		end

		Trinity2.ResetDockFrameOptions()

		if (self) then

			Trinity2DockFrameEditorBottom:ClearAllPoints()
			Trinity2DockFrameEditorBottom:SetParent(self)
			Trinity2DockFrameEditorBottom:SetPoint("TOP", self, "BOTTOM")
			Trinity2DockFrameEditorBottom:SetFrameStrata(self:GetFrameStrata())
			Trinity2DockFrameEditorBottom.frame = self

			local text = ""

			for k,v in pairs(self.simpleActionSet) do
				if (v == "default") then
					text = k
				end
			end

			Trinity2DockFrameEditorBottomEdit1:SetText(text)

			local data = {}

			for k,v in pairs(self.simpleActionSet) do
				if (v) then
					data[k] = k
				end
			end

			Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameEditorBottomEdit1.popup, data)

			if (self.reset) then
				Trinity2DockFrameOptionsRDCDocksReset:Enable()
				Trinity2DockFrameOptionsRDCDocksReset.func = self.reset
				Trinity2DockFrameOptionsRDCDocksReset.currFrame = self
			end

			if (self.delete) then
				Trinity2DockFrameOptionsRDCDocksDelete:Enable()
				Trinity2DockFrameOptionsRDCDocksDelete.func = self.delete
				Trinity2DockFrameOptionsRDCDocksDelete:SetText(TRINITY2_STRINGS.DELETE)
				Trinity2DockFrameOptionsRDCDocksDelete.currFrame = self
			elseif (self.store) then
				Trinity2DockFrameOptionsRDCDocksDelete:Enable()
				Trinity2DockFrameOptionsRDCDocksDelete.func = self.store
				if (self.config.stored) then
					Trinity2DockFrameOptionsRDCDocksDelete:SetText(TRINITY2_STRINGS.RESTORE)
				else
					Trinity2DockFrameOptionsRDCDocksDelete:SetText(TRINITY2_STRINGS.STORE)
				end
				Trinity2DockFrameOptionsRDCDocksDelete.currFrame = self
			end

			if (self.create) then
				Trinity2DockFrameOptionsRDCDocksCreate:Enable()
				Trinity2DockFrameOptionsRDCDocksCreate.func = self.create
				Trinity2DockFrameOptionsRDCDocksCreate.currFrame = self
			end

			if (self.clone) then
				Trinity2DockFrameOptionsRDCDocksClone:Enable()
				Trinity2DockFrameOptionsRDCDocksClone.func = self.clone
				Trinity2DockFrameOptionsRDCDocksClone.currFrame = self
			end

			if (lastOwner ~= self.owner) then
				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit1:SetText("")
				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit2:SetText("")
				Trinity2DockFrameOptionsColorPickerFrameEdit1:SetText("")
				Trinity2DockFrameOptionsColorPickerFrameEdit2:SetText("")
				lastOwner = self.owner
			end

			if (Trinity2DockFrameOptions.currFrame and Trinity2DockFrameOptions.currFrame ~= self) then
				newDock = true
			end

			Trinity2DockFrameOptions.currFrame = self

			Trinity2.SetDockFrameAdjustableOptions(self)

			Trinity2DockFrameOptionsCurrentDockEdit1:SetText(self.config.name)
			Trinity2DockFrameOptionsCurrentDockEdit2:SetText(self.config.centerx)
			Trinity2DockFrameOptionsCurrentDockEdit3:SetText(self.config.centery)

			Trinity2.DockFrameOptionsAdjustableOptionsFrameOpt1Edit1_OnTextChanged(Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit1)
		else

			Trinity2DockFrameEditorBottom:ClearAllPoints()
			Trinity2DockFrameEditorBottom:SetParent("UIParent")
			Trinity2DockFrameEditorBottom:SetPoint("TOP", "UIParent", "BOTTOM")
			Trinity2DockFrameEditorBottom:Hide()
			Trinity2DockFrameEditorBottom.frame = nil

			Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameEditorBottomEdit1.popup, nil)

			Trinity2DockFrameEditorBottomEdit1:SetText("")

		end

		return newDock
	end
end

function Trinity2.ResetDockFrameOptions(clear)

	Trinity2DockFrameOptionsRDCDocksReset:Disable()
	Trinity2DockFrameOptionsRDCDocksReset.func = nil
	Trinity2DockFrameOptionsRDCDocksReset.currFrame = nil
	Trinity2DockFrameOptionsRDCDocksDelete:Disable()
	Trinity2DockFrameOptionsRDCDocksDelete.func = nil
	Trinity2DockFrameOptionsRDCDocksDelete.currFrame = nil
	Trinity2DockFrameOptionsRDCDocksCreate:Disable()
	Trinity2DockFrameOptionsRDCDocksCreate.func = nil
	Trinity2DockFrameOptionsRDCDocksCreate.currFrame = nil
	Trinity2DockFrameOptionsRDCDocksClone:Disable()
	Trinity2DockFrameOptionsRDCDocksClone.func = nil
	Trinity2DockFrameOptionsRDCDocksClone.currFrame = nil

	if (clear) then
		Trinity2DockFrameOptions.currFrame = nil
		Trinity2DockFrameOptionsCurrentDockEdit1:SetText("")
		Trinity2DockFrameOptionsCurrentDockEdit2:SetText("")
		Trinity2DockFrameOptionsCurrentDockEdit3:SetText("")
		Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit1:SetText("")
		Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit2:SetText("")
		Trinity2DockFrameOptionsColorPickerFrameEdit1:SetText("")
		Trinity2DockFrameOptionsColorPickerFrameEdit2:SetText("")
	end
end

function Trinity2.TrinityLoader_OnEvent(self, event, ...)

	if (event == "PLAYER_LOGIN") then

		local button, tab, lasttab, count

		for k,v in pairs(defaultSavedState) do
			if (Trinity2SavedState[k] == nil) then
				Trinity2SavedState[k] = v
			end
		end

		SlashCmdList["TRINITYSLASH"] = slashHandler
		SLASH_TRINITYSLASH1 = TRINITY2_STRINGS.TRINITYSLASH1
		SLASH_TRINITYSLASH2 = TRINITY2_STRINGS.TRINITYSLASH2

		-- Options Sets are: Frame, Set Num, Order Num
		Trinity2.OptionSets = {
			[1] = { Trinity2DockFrameOptionsCurrentDock, 0, 1 },
			[2] = { Trinity2DockFrameOptionsCheckOptionsFrame, 1, 2 },
			[3] = { Trinity2DockFrameOptionsAdjustableOptionsFrame, 1, 3 },
			[4] = { Trinity2DockFrameOptionsRDCDocks, 1, 4 },
			[5] = { Trinity2DockFrameOptionsColorPickerFrame, 2, 2 },
		}

		Trinity2.SlashCommands[TRINITY2_STRINGS.SLASH_COMMAND_1] = { TRINITY2_STRINGS.SLASH_COMMAND_1_DESC, Trinity2.ToggleMainMenu }
		Trinity2.SlashCommands[TRINITY2_STRINGS.SLASH_COMMAND_2] = { TRINITY2_STRINGS.SLASH_COMMAND_2_DESC, Trinity2.ToggleSimpleDockEditMode }
		Trinity2.SlashCommands[TRINITY2_STRINGS.SLASH_COMMAND_3] = { TRINITY2_STRINGS.SLASH_COMMAND_3_DESC, Trinity2.ToggleSimpleBindingEditMode }

		Trinity2.ResetDockFrameOptions(true)

		hooksecurefunc("ToggleGameMenu", Trinity2.OnEscapeToggle)

		for k,v in pairs(Trinity2.RegisteredPanels) do

			if (v[3] == "advanced") then

				count = 1

				for i=1, #Trinity2.RegisteredPanels do

					if (Trinity2.RegisteredPanels[i][3] == "advanced") then

						tab = CreateFrame("Button", v[1]:GetName().."Tab"..count, v[1], "Trinity2TabTemplate")
						tab:SetID(count)

						if (count == 1 ) then
							tab:SetPoint("TOPLEFT", v[1], "BOTTOMLEFT", -3, 1)
							lasttab = tab
						else
							tab:SetPoint("LEFT", lasttab, "RIGHT", -20, 0)
							lasttab = tab
						end

						tab.frame = Trinity2.RegisteredPanels[i][1]

						tab:SetScript("OnClick", function(self) self.frame:Show() end)
						tab:SetText(Trinity2.RegisteredPanels[i][2])

						if (Trinity2.RegisteredPanels[i][2] == v[2]) then
							PanelTemplates_SelectTab(tab)
						else
							PanelTemplates_DeselectTab(tab)
						end

						count = count + 1
					end
				end
			end
		end
	end

	if (event == "PLAYER_ENTERING_WORLD") then
		Trinity2.PlayerEnteredWorld = true
	end

	if (event == "PLAYER_REGEN_DISABLED") then

		for k,v in pairs(Trinity2.RegisteredPanels) do
			v[1]:Hide()
		end
	end

end

function Trinity2.RegisterAddon(index)

	local count = 0
	local button = CreateFrame("Button", "Trinity2MinimapOption"..index, Trinity2MinimapButton, "Trinity2MinimapButtonTemplate")

	button:SetID(index)
	button:SetFrameLevel(10)
	button.func1 = Trinity2.RegisteredAddons[index][3]
	button.func2 = Trinity2.RegisteredAddons[index][7]
	button.tooltip = Trinity2.RegisteredAddons[index][5]

	if (Trinity2.RegisteredAddons[index][1] == "dummy_keybind") then
		button:SetNormalTexture(Trinity2.RegisteredAddons[index][4])
		table.insert(Trinity2BindingEditor.keyBindTextures, button)
		table.insert(Trinity2SimpleBindingEditor.keyBindTextures, button)
	else
		getglobal(button:GetName().."Icon"):SetTexture(Trinity2.RegisteredAddons[index][4])
	end

	tinsert(subMenuButtons, button)

	Trinity2.RegisteredAddons[index][5] = button:GetName()

	templateFrames[Trinity2.RegisteredAddons[index][1]] = Trinity2.RegisteredAddons[index][8]

	button:Hide()
end

function Trinity2.Options_OnClick(self, button)


end

function Trinity2.ToggleMainMenu()

	if (InCombatLockdown()) then
		return
	end

	local open = false

	for k,v in pairs(Trinity2.RegisteredOptions, self) do
		if (v:IsVisible()) then
			InterfaceOptionsFrameOkay_OnClick()
			open = true
			break
		end
	end

	if (not open) then

		for k,v in pairs(Trinity2.RegisteredOptions, self) do
			InterfaceOptionsFrame_OpenToFrame(v)
		end
		InterfaceOptionsFrame_OpenToFrame(Trinity2Options)
	end
end

function Trinity2.ToggleDockFrameOptions()

	if (InCombatLockdown()) then
		Trinity2MessageFrame:AddMessage(TRINITY2_STRINGS.COMBAT_LOCKDOWN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		return
	end
end

function Trinity2.ToggleSimpleDockEditMode()

	if (InCombatLockdown()) then
		Trinity2MessageFrame:AddMessage(TRINITY2_STRINGS.COMBAT_LOCKDOWN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		return
	end

	if (Trinity2SimpleDockEditor:IsVisible()) then
		Trinity2SimpleDockEditor:Hide()
	else
		Trinity2DockFrameOptions:Hide()
		Trinity2SimpleDockEditor:Show()
	end

end

function Trinity2.ToggleAdvancedDockEditMode()

	if (InCombatLockdown()) then
		Trinity2MessageFrame:AddMessage(TRINITY2_STRINGS.COMBAT_LOCKDOWN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		return
	end

	if (Trinity2DockFrameOptions:IsVisible()) then
		Trinity2DockFrameOptions:Hide()
	else
		Trinity2SimpleDockEditor:Hide()
		Trinity2DockFrameOptions:Show()
	end
end

function Trinity2.ToggleSimpleBindingEditMode()

	if (InCombatLockdown()) then
		Trinity2MessageFrame:AddMessage(TRINITY2_STRINGS.COMBAT_LOCKDOWN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		return
	end

	if (Trinity2SimpleBindingEditor:IsVisible()) then
		Trinity2SimpleBindingEditor:Hide()
	else
		Trinity2BindingEditor:Hide()
		Trinity2SimpleBindingEditor:Show()
	end
end

function Trinity2.ToggleAdvancedBindingEditMode()

	if (InCombatLockdown()) then
		Trinity2MessageFrame:AddMessage(TRINITY2_STRINGS.COMBAT_LOCKDOWN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		return
	end

	if (Trinity2BindingEditor:IsVisible()) then
		Trinity2BindingEditor:Hide()
	else
		Trinity2SimpleBindingEditor:Hide()
		Trinity2BindingEditor:Show()
	end
end

function Trinity2.SimpleDockEditor_OnShow(self)

	local dockFrame

	Trinity2MinimapButton:SetFrameStrata("DIALOG")

	Trinity2DockFrameOptionsCurrentDockEdit1:SetText("")

	for k,v in pairs(Trinity2.RegisteredPanels) do
		if (v[1] ~= self) then
			v[1]:Hide()
		end
	end

	Trinity2.configMode = true

	for k,v in pairs(Trinity2.RegisteredDocks) do

		dockFrame = getglobal(k)

		if (not dockFrame.config.stored) then
			dockFrame:Show()
			v(dockFrame)
		end
	end

	for i=1, #Trinity2.RegisteredAddons do
		if (Trinity2.RegisteredAddons[i][6]) then
			Trinity2.RegisteredAddons[i][6]()
		end
	end
end

function Trinity2.SimpleDockEditor_OnHide(self)

	local dockFrame

	Trinity2.configMode = false

	Trinity2MinimapButton:SetFrameStrata(MinimapCluster:GetFrameStrata())

	for k,v in pairs(Trinity2.RegisteredDocks) do

		dockFrame = getglobal(k)

		dockFrame:Hide()
		v(dockFrame)
	end

	changeDock(nil)

	for i=1, #Trinity2.RegisteredAddons do
		if (Trinity2.RegisteredAddons[i][6]) then
			Trinity2.RegisteredAddons[i][6]()
		end
	end

	collectgarbage()
end

function Trinity2.DockFrameOptions_OnShow(self)

	local dockFrame

	for k,v in pairs(Trinity2.RegisteredOptions, self) do
		if (v:IsVisible()) then
			InterfaceOptionsFrameOkay_OnClick()
			break
		end
	end

	Trinity2MinimapButton:SetFrameStrata("DIALOG")

	Trinity2DockFrameOptionsCurrentDockEdit1:SetText("")

	for k,v in pairs(Trinity2.RegisteredPanels) do
		if (v[1] ~= self) then
			v[1]:Hide()
		end
	end

	Trinity2.configMode = true

	for k,v in pairs(Trinity2.RegisteredDocks) do

		dockFrame = getglobal(k)

		if (not dockFrame.config.stored) then
			dockFrame:Show()
			v(dockFrame)
		end
	end

	for i=1, #Trinity2.RegisteredAddons do
		if (Trinity2.RegisteredAddons[i][6]) then
			Trinity2.RegisteredAddons[i][6]()
		end
	end
end

function Trinity2.DockFrameOptions_OnHide(self)

	local dockFrame

	Trinity2.configMode = false

	Trinity2MinimapButton:SetFrameStrata(MinimapCluster:GetFrameStrata())

	for k,v in pairs(Trinity2.RegisteredDocks) do

		dockFrame = getglobal(k)

		dockFrame:Hide()
		v(dockFrame)
	end

	changeDock(nil)

	for i=1, #Trinity2.RegisteredAddons do
		if (Trinity2.RegisteredAddons[i][6]) then
			Trinity2.RegisteredAddons[i][6]()
		end
	end

	collectgarbage()
end

function Trinity2.SimpleBindingEditor_OnShow(self)

	local dockFrame

	Trinity2MinimapButton:SetFrameStrata("DIALOG")

	for k,v in pairs(Trinity2.RegisteredPanels) do
		if (v[1] ~= self) then
			v[1]:Hide()
		end
	end

	Trinity2.configMode = true

	for k,v in pairs(Trinity2.RegisteredDocks) do
		dockFrame = getglobal(k)
		v(dockFrame)
	end

	if (self.keyBindTextures) then
		for k,v in pairs(self.keyBindTextures) do
			--DEFAULT_CHAT_FRAME:AddMessage(v:GetName())
			v:SetNormalTexture("Interface\\Addons\\Trinity2\\images\\TrinityBindOnButton.tga")
		end
	end

	for i=1, #Trinity2.RegisteredAddons do
		if (Trinity2.RegisteredAddons[i][6]) then
			Trinity2.RegisteredAddons[i][6]()
		end
	end
end

function Trinity2.SimpleBindingEditor_OnHide(self)

	local dockFrame

	self:SetAlpha(1)

	Trinity2.configMode = false

	Trinity2MinimapButton:SetFrameStrata(MinimapCluster:GetFrameStrata())

	for k,v in pairs(Trinity2.RegisteredDocks) do
		dockFrame = getglobal(k)
		v(dockFrame)
	end

	if (self.keyBindTextures) then
		for k,v in pairs(self.keyBindTextures) do
			--DEFAULT_CHAT_FRAME:AddMessage(v:GetName())
			v:SetNormalTexture("Interface\\Addons\\Trinity2\\images\\TrinityBindOffButton.tga")
		end
	end

	for i=1, #Trinity2.RegisteredAddons do
		if (Trinity2.RegisteredAddons[i][6]) then
			Trinity2.RegisteredAddons[i][6]()
		end
	end
end

function Trinity2.BindingEditor_OnShow(self)

	local dockFrame

	for k,v in pairs(Trinity2.RegisteredOptions, self) do
		if (v:IsVisible()) then
			InterfaceOptionsFrameOkay_OnClick()
			break
		end
	end


	Trinity2MinimapButton:SetFrameStrata("DIALOG")

	for k,v in pairs(Trinity2.RegisteredPanels) do
		if (v[1] ~= self) then
			v[1]:Hide()
		end
	end

	Trinity2.configMode = true

	for k,v in pairs(Trinity2.RegisteredDocks) do
		dockFrame = getglobal(k)
		v(dockFrame)
	end

	if (self.keyBindTextures) then
		for k,v in pairs(self.keyBindTextures) do
			--DEFAULT_CHAT_FRAME:AddMessage(v:GetName())
			v:SetNormalTexture("Interface\\Addons\\Trinity2\\images\\TrinityBindOnButton.tga")
		end
	end

	for i=1, #Trinity2.RegisteredAddons do
		if (Trinity2.RegisteredAddons[i][6]) then
			Trinity2.RegisteredAddons[i][6]()
		end
	end
end

function Trinity2.BindingEditor_OnHide(self)

	local dockFrame

	self:SetAlpha(1)

	Trinity2.configMode = false

	Trinity2MinimapButton:SetFrameStrata(MinimapCluster:GetFrameStrata())

	for k,v in pairs(Trinity2.RegisteredDocks) do
		dockFrame = getglobal(k)
		v(dockFrame)
	end

	if (self.keyBindTextures) then
		for k,v in pairs(self.keyBindTextures) do
			--DEFAULT_CHAT_FRAME:AddMessage(v:GetName())
			v:SetNormalTexture("Interface\\Addons\\Trinity2\\images\\TrinityBindOffButton.tga")
		end
	end

	for i=1, #Trinity2.RegisteredAddons do
		if (Trinity2.RegisteredAddons[i][6]) then
			Trinity2.RegisteredAddons[i][6]()
		end
	end
end

function Trinity2.TemplateManager_OnShow(self)

	local dockFrame

	Trinity2MinimapButton:SetFrameStrata("DIALOG")

	for k,v in pairs(Trinity2.RegisteredPanels) do
		if (v[1] ~= self) then
			v[1]:Hide()
		end
	end
end

function Trinity2.TemplateManager_OnHide(self)

	Trinity2MinimapButton:SetFrameStrata(MinimapCluster:GetFrameStrata())

end

function Trinity2.PanelMover_OnDragStart(self)

	Trinity2PanelMover:Show()

	Trinity2PanelMover:ClearAllPoints()

	Trinity2PanelMover:SetUserPlaced(true)

	Trinity2PanelMover:StartMoving()
end

function Trinity2.PanelMover_OnDragStop(self)

	Trinity2PanelMover:Hide()

	Trinity2PanelMover:StopMovingOrSizing()
end


function Trinity2.ToggleTutorialTooltips()

	if (Trinity2OptionsCheck2:GetChecked()) then
		Trinity2OptionsCheck2:SetChecked(nil)
		Trinity2SavedState.savedOptions["CheckButtons"][Trinity2OptionsCheck2:GetID()] = Trinity2OptionsCheck2:GetChecked()
		Trinity2MessageFrame:AddMessage(TRINITY2_STRINGS.TOOLTIPS_DISABLED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
	else
		Trinity2OptionsCheck2:SetChecked(true)
		Trinity2SavedState.savedOptions["CheckButtons"][Trinity2OptionsCheck2:GetID()] = Trinity2OptionsCheck2:GetChecked()
		Trinity2MessageFrame:AddMessage(TRINITY2_STRINGS.TOOLTIPS_ENABLED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
	end


end

function Trinity2.RGBToHexInverse(r, g, b)

	local newR = 1-(r*.5)
	local newG = 1-(g*.5)
	local newB = 1-(b*.5)

	if (newR > 1) then newR = 1 end
	if (newG > 1) then newG = 1 end
	if (newB > 1) then newB = 1 end

	return string.format("%02x%02x%02x", newR*255, newG*255, newB*255)
end

function Trinity2.RGBHighlight(r, g, b, factor)

	if (factor and factor > 0) then

		local newR = r*factor
		local newG = g*factor
		local newB = b*factor

		if (newR > 1) then newR = 1 end
		if (newG > 1) then newG = 1 end
		if (newB > 1) then newB = 1 end

		return string.format("%02x%02x%02x", newR*255, newG*255, newB*255)
	end
end

function Trinity2.RandomRGB()

	--local newR, newG, newB, total, count = 0, 0, 0, 0, 0

	--while (total < 1.25) do

	--	newR = random(0,1000)/1000
	--	newG = random(0,1000)/1000
	--	newB = random(0,1000)/1000

	--	total = newR + newG + newB

	--	count = count + 1

	--	if (count > 100) then
	--		total = 99
	--	end
	--end

	math.randomseed(random(0,2147483647)+(GetTime()*1000))

	local h = random(0,360)
	local v = random(80,100)/100
	local s = random(80,100)/100
	local newR, newG, newB = Trinity2.HSVtoRGB(h, s, v)

	return string.format("%02x%02x%02x", newR*255, newG*255, newB*255)
end

function Trinity2.HSVtoRGB(h,s,v)

	local r, g ,b

	h = h/60

	local i = math.floor(h)
	local f = h - i
	local p = v * ( 1 - s )
	local q = v * ( 1 - s * f )
	local t = v * ( 1 - s * ( 1 - f ) )

	if (i == 0) then

		r = v; g = t; b = p

	elseif (i == 1) then

		r = q; g = v; b = p

	elseif (i == 2) then

		r = p; g = v; b = t

	elseif (i == 3) then

		r = p; g = q; b = v

	elseif (i == 4) then

		r = t; g = p; b = v

	elseif (i == 5) then

		r = v; g = p; b = q

	end

	if (not r) then r = 0 end
	if (not g) then g = 0 end
	if (not b) then b = 0 end

	return r, g, b
end

function Trinity2.MenuOptionTransition(frame, button, count)

	local buttonOption, x, y

	frame.angle = 90

	if (frame.count > 1) then
		frame.count = frame.count - 1
	end

	frame.transition = frame.transition - frame.count

	if (frame.transition < count) then
		frame.transition = count
	end

	for k,v in pairs(subMenuButtons) do

		x = Trinity2SavedState.subMenuRadius * (cos(frame.angle))
		y = Trinity2SavedState.subMenuRadius * (sin(frame.angle))

		v:SetScale(Trinity2SavedState.subMenuScale)
		v:SetPoint("CENTER", Trinity2MinimapButton, "CENTER", x, y)
		v:SetFrameLevel(10)

		frame.angle = frame.angle - (360/frame.transition)
	end

	if (frame.transition <= count) then
		Trinity2.OpenOptionsMenu = false
	end
end

function Trinity2.EditBox_Initialize(scrollFrame, data, configFrame)

	scrollFrame.func = Trinity2.ScrollFrame_Update
	scrollFrame.data = data
	scrollFrame.sentenceCase = true

	Trinity2.ScrollFrame_Update(scrollFrame, configFrame)
end

function Trinity2.ScrollFrame_Update(scrollFrame, configFrame)

	local scrollbar = getglobal(scrollFrame:GetName().."ScrollBar")
	local data = scrollFrame.data
	local count = 1
	local max

	scrollFrame.array = {}

	if (not data) then
		for i=1,5 do
			getglobal(scrollFrame:GetName().."Option"..i.."Text"):SetText("")
			getglobal(scrollFrame:GetName().."Option"..i):Hide()
		end
		return
	end

	for k,v in pairs(data) do

		if (type(v) == "string") then
			scrollFrame.array[count] = k..","..v
		else
			scrollFrame.array[count] = k
		end
		count = count + 1
	end

	table.sort(scrollFrame.array)

	if (#scrollFrame.array < 5) then
		max = #scrollFrame.array
	else
		max = #scrollFrame.array-4
	end

	scrollbar:SetMinMaxValues(0, max)

	for i=1,5 do
		index = i + math.floor(scrollFrame:GetVerticalScroll())

		getglobal(scrollFrame:GetName().."Option"..i):Show()

		if (scrollFrame.array[index]) then
			getglobal(scrollFrame:GetName().."Option"..i.."Text"):SetText(match(scrollFrame.array[index], "^[^,]+"))
			getglobal(scrollFrame:GetName().."Option"..i).value = match(scrollFrame.array[index], "[^,]+$")
			if (configFrame) then
				getglobal(scrollFrame:GetName().."Option"..i).configFrame = configFrame
			end
		else
			getglobal(scrollFrame:GetName().."Option"..i):Hide()
		end
	end


end

function Trinity2.EditBox_PopUpInitialize(popupFrame, data, configFrame)

	popupFrame.func = Trinity2.PopUp_Update
	popupFrame.data = data

	Trinity2.PopUp_Update(popupFrame, configFrame)
end

function Trinity2.PopUp_Update(popupFrame, configFrame)

	local data, columns = popupFrame.data, 1
	local count, height, width, widthMult, option, lastOption, lastAnchor = 1,0, popupFrame:GetParent():GetWidth(), 1, nil, nil, nil

	if (popupFrame.options) then
		for k,v in pairs(popupFrame.options) do
			v:Hide()
		end
	end

	popupFrame.array = {}

	if (not data) then
		return
	end

	for k,v in pairs(data) do

		if (type(v) == "string") then
			popupFrame.array[count] = k..","..v
		else
			popupFrame.array[count] = k
		end

		count = count + 1
	end

	table.sort(popupFrame.array)

	count = 1

	columns = (math.ceil(#popupFrame.array/20)) or 1

	for i=1,#popupFrame.array do

		popupFrame.array[i] = gsub(popupFrame.array[i], "%s+", " ")
		popupFrame.array[i] = gsub(popupFrame.array[i], "^%s+", "")

		if (not popupFrame.options[i]) then
			option = CreateFrame("Button", popupFrame:GetName().."Option"..i, popupFrame, "Trinity2ButtonTemplate3")
			option:SetHeight(14)

			popupFrame.options[i] = option
		else
			option = getglobal(popupFrame:GetName().."Option"..i)
			popupFrame.options[i] = option
		end

		getglobal(option:GetName().."Text"):SetText(match(popupFrame.array[i], "^[^,]+"))

		if (configFrame) then

			option.value = match(popupFrame.array[i], "[^,]+$")
			option.configFrame = configFrame
		end

		if (getglobal(option:GetName().."Text"):GetWidth() + 20 > width) then
			width = getglobal(option:GetName().."Text"):GetWidth() + 20
		end

		option:ClearAllPoints()

		if (count == 1) then
			if (lastAnchor) then
				option:SetPoint("LEFT", lastAnchor, "RIGHT", 0, 0)
				lastOption = option
				lastAnchor = option

			else
				option:SetPoint("TOPLEFT", popupFrame, "TOPLEFT", 0, -5)
				lastOption = option
				lastAnchor = option
			end
		else
			option:SetPoint("TOP", lastOption, "BOTTOM", 0, -1)
			lastOption = option
		end

		if (widthMult == 1) then
			height = height + 15
		end

		count = count + 1

		if (count > math.ceil(#popupFrame.array/columns) and widthMult < columns and columns > 1) then
			widthMult = widthMult + 1
			count = 1
		end

		option:Show()
	end

	if (popupFrame.options) then
		for k,v in pairs(popupFrame.options) do
			v:SetWidth(width)
		end
	end

	popupFrame:SetWidth(width * widthMult)

	if (popupFrame:GetParent():GetHeight() > height + 10) then
		popupFrame:SetHeight(popupFrame:GetParent():GetHeight())
	else
		popupFrame:SetHeight(height + 10)
	end
end


function Trinity2.Edit1_OnTextChanged(self)

	--local data = string.gsub(self:GetText(), "%s+", "").."FAQ"

	--if (getglobal(data)) then
	--	Trinity2.EditBox_PopUpInitialize(getglobal(self:GetParent():GetName().."Edit2PopUp"), getglobal(data))
	--	getglobal(self:GetParent():GetName().."Edit2").data = data
	--else
	--	getglobal(self:GetParent():GetName().."Edit2").data = nil
	--	Trinity2.EditBox_PopUpInitialize(getglobal(self:GetParent():GetName().."Edit2PopUp"), nil)
	--	getglobal(self:GetParent():GetName().."Edit2"):SetText("")
	--	getglobal(self:GetParent():GetName().."Data1ScrollFrame1EditBox1"):SetText("------ UNDER CONSTRUCTION -----")
	--end

end

function Trinity2.ToggleSoloEditMode(dockFrame)

	if (InCombatLockdown()) then
		Trinity2MessageFrame:AddMessage(TRINITY2_STRINGS.COMBAT_LOCKDOWN, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		return
	end

	if (Trinity2.configMode) then
		if (Trinity2.SoloEditMode) then
			for k,v in pairs(Trinity2.RegisteredDocks) do
				if (getglobal(k):GetName() == dockFrame:GetName()) then
					getglobal(k):Show()
				else
					getglobal(k):Hide()
				end
			end
		else
			for k,v in pairs(Trinity2.RegisteredDocks) do
				getglobal(k):Show()
			end
		end
	end
end

local function castingBarSetColor(self)

	if (self.barcolor) then

		self:SetStatusBarColor(self.barcolor[1], self.barcolor[2], self.barcolor[3])
		self.background:SetBackdropBorderColor(self.bordercolor[1], self.bordercolor[2], self.bordercolor[3], 1)
		self.barTextLeft:SetTextColor(self.textcolor[1], self.textcolor[2], self.textcolor[3])
		self.barTextRight:SetTextColor(self.timercolor[1], self.timercolor[2], self.timercolor[3])
	else
		self:SetStatusBarColor(1.0, 0.7, 0.0)
		self.background:SetBackdropBorderColor(0.8, 0.8, 0.8, 1)
		self.barTextLeft:SetTextColor(1, 1, 1)
		self.barTextRight:SetTextColor(1, 1, 1)
	end
end

function Trinity2.CastingBarFrame_OnLoad(self, unit, showTradeSkills, text)

	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:RegisterEvent("UNIT_SPELLCAST_DELAYED")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

	self.castingInfo = {}
	self.text = text
	self.unit = unit
	self.showTradeSkills = showTradeSkills
	self.casting = nil
	self.channeling = nil
	self.holdTime = 0
	self.showCastbar = true
	self.orient = "HORIZONTAL"
	self.barSpark = getglobal(self:GetName().."Spark")
	self.barTextLeft = getglobal(self:GetName().."TextLeft")
	self.barTextRight = getglobal(self:GetName().."TextRight")
	self.barFlash = getglobal(self:GetName().."Flash")
	self.barIcon = getglobal(self:GetName().."Icon")
	self.timer = getglobal(self:GetName().."Timer")
	self.background = getglobal(self:GetName().."Background")
	self.dummy = getglobal(self:GetName().."Dummy")
	self.dummyIcon = getglobal(self:GetName().."DummyIcon")
	self.dummyBackground = getglobal(self:GetName().."DummyBackground")
	self.dummyTextLeft = getglobal(self:GetName().."DummyTextLeft")
	self.dummyTextRight = getglobal(self:GetName().."DummyTextRight")

	self.onEvent = Trinity2.CastingBarFrame_OnEvent
	self.onUpdate = Trinity2.CastingBarFrame_OnUpdate
	self.finishSpell = Trinity2.CastingBarFrame_FinishSpell

	self:SetFrameLevel(2)

	if ( self.barIcon ) then
		self.barIcon:SetTexCoord(0.08,0.92,0.08,0.92)
		self.barIcon:Hide()
	end

	self:Hide()
end

function Trinity2.CastingBarFrame_OnEvent(self, event, ...)

	local unit = ...

	if ( event == "PLAYER_ENTERING_WORLD" ) then
		if (UnitChannelInfo(self.unit)) then
			event = "UNIT_SPELLCAST_CHANNEL_START"
			unit = self.unit
		elseif (UnitCastingInfo(self.unit)) then
			event = "UNIT_SPELLCAST_START"
			unit = self.unit
		end
	end

	if ( unit ~= self.unit ) then
		return
	end

	if (self.orient == "HORIZONTAL") then
		self.barSpark:SetWidth(20)
		self.barSpark:SetHeight(self:GetHeight()*2)
	else
		self.barSpark:SetWidth(self:GetWidth()*2)
		self.barSpark:SetHeight(20)
	end

	if ( event == "UNIT_SPELLCAST_START" ) then

		local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(self.unit)

		if ( not name or (not self.showTradeSkills and isTradeSkill)) then
			self:Hide()
			return
		end

		castingBarSetColor(self)

		if ( self.barSpark ) then
			self.barSpark:Show()
		end

		self.startTime = startTime / 1000
		self.maxValue = endTime / 1000
		self:SetMinMaxValues(self.startTime, self.maxValue)
		self:SetValue(self.startTime)

		if ( self.barTextLeft and self.text) then
			if (self.showspell) then
				self.barTextLeft:SetText(text)
				self.barTextLeft:Show()
			else
				self.barTextLeft:Hide()
			end
		end

		if ( self.barTextRight and self.text) then
			if (self.showtimer) then
				self.barTextRight:Show()
			else
				self.barTextRight:Hide()
			end
		end

		if ( self.barIcon ) then
			if ( self.showicon ) then
				self.barIcon:SetTexture(texture)
				self.barIcon:Show()
			else
				self.barIcon:Hide()
			end
		end

		self:SetAlpha(1.0)
		self.holdTime = 0
		self.casting = 1
		self.channeling = nil
		self.fadeOut = nil

		if ( self.showCastbar ) then
			self:Show()
		end
	elseif ( event == "UNIT_SPELLCAST_SUCCEEDED") then

		self:SetStatusBarColor(self.successcolor[1], self.successcolor[2], self.successcolor[3])

	elseif ( event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" ) then

		if ( not self:IsVisible() ) then
			self:Hide()
		end

		if ( self.casting or self.channeling ) then

			if ( self.barSpark ) then
				self.barSpark:Hide()
			end

			if ( self.barFlash ) then
				self.barFlash:SetAlpha(0.0)
				self.barFlash:Show()
			end

			self:SetValue(self.maxValue)

			if ( event == "UNIT_SPELLCAST_STOP" ) then
				self.casting = nil
			else
				self.channeling = nil
			end

			self.flash = 1
			self.fadeOut = 1
			self.holdTime = 0
		end

	elseif ( event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" ) then

		--if ( self:IsShown() and not self.channeling and not self.fadeOut ) then
		if ( self:IsShown() and not self.channeling ) then

			self:SetValue(self.maxValue)
			self:SetStatusBarColor(self.failedcolor[1], self.failedcolor[2], self.failedcolor[3])

			if ( self.barSpark ) then
				self.barSpark:Hide()
			end

			if ( self.barTextLeft and self.text) then
				if (self.showspell) then
					if ( event == "UNIT_SPELLCAST_FAILED" ) then
						self.barTextLeft:SetText(FAILED)
					else
						self.barTextLeft:SetText(INTERRUPTED)
					end
				end
			end

			self.casting = nil
			self.channeling = nil
			self.fadeOut = 1
			self.holdTime = GetTime() + CASTING_BAR_HOLD_TIME
		end

	elseif ( event == "UNIT_SPELLCAST_DELAYED" ) then

		if ( self:IsShown() ) then

			local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(self.unit)

			if ( not name or (not self.showTradeSkills and isTradeSkill)) then
				self:Hide()
				return
			end

			self.startTime = startTime / 1000
			self.maxValue = endTime / 1000
			self:SetMinMaxValues(self.startTime, self.maxValue)

			if ( not self.casting ) then

				castingBarSetColor(self)

				if ( self.barSpark ) then
					self.barSpark:Show()
				end

				if ( self.barFlash ) then
					self.barFlash:SetAlpha(0.0)
					self.barFlash:Hide()
				end

				self.casting = 1
				self.channeling = nil
				self.flash = 0
				self.fadeOut = 0
			end
		end

	elseif ( event == "UNIT_SPELLCAST_CHANNEL_START" ) then

		local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(self.unit)

		if ( not name or (not self.showTradeSkills and isTradeSkill)) then
			self:Hide()
			return
		end

		castingBarSetColor(self)

		self.startTime = startTime / 1000
		self.endTime = endTime / 1000
		self.duration = self.endTime - self.startTime
		self.maxValue = self.startTime

		self:SetMinMaxValues(self.startTime, self.endTime)
		self:SetValue(self.endTime)

		if ( self.barTextLeft and self.text) then
			if (self.showspell) then
				self.barTextLeft:SetText(text)
				self.barTextLeft:Show()
			else
				self.barTextLeft:Hide()
			end
		end

		if ( self.barIcon ) then
			if ( self.showicon) then
				self.barIcon:SetTexture(texture)
				self.barIcon:Show()
			else
				self.barIcon:Hide()
			end
		end

		if ( self.barSpark ) then
			self.barSpark:Hide()
		end

		self:SetAlpha(1.0)
		self.holdTime = 0
		self.casting = nil
		self.channeling = 1
		self.fadeOut = nil

		if ( self.showCastbar ) then
			self:Show()
		end

	elseif ( event == "UNIT_SPELLCAST_CHANNEL_UPDATE" ) then

		if ( self:IsShown() ) then

			local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(self.unit)

			if ( not name or (not self.showTradeSkills and isTradeSkill)) then
				self:Hide()
				return
			end

			self.startTime = startTime / 1000
			self.endTime = endTime / 1000
			self.maxValue = self.startTime
			self:SetMinMaxValues(self.startTime, self.endTime)
		end
	end
end

function Trinity2.CastingBarFrame_OnUpdate(self, elapsed)

	local timeLeft = nil
	local status, sparkPosition, time, barValue, alpha

	if ( self.casting ) then
		timeLeft = self.maxValue - self:GetValue()

	elseif ( self.channeling ) then
		if (self.duration) then
			timeLeft = self.duration + self:GetValue() - self.endTime
		end

	end

	-- Casting bar timer code thanks to Luinil of Suramar server
	if ( timeLeft ) then

		timeleft = (timeLeft < 0.1) and 0.01 or timeLeft

		displayName = self.timer.castingInfo[self.unit][1]

		if (self.text) then
			if (self.showspell) then
				self.barTextLeft:SetText(self.timer.castingInfo[self.unit][1])
			end
			if (self.showtimer) then
				self.barTextRight:SetText(format(self.timer.castingInfo[self.unit][2], timeLeft))
			end
		end

		if (self:GetOrientation() == "VERTICAL") then
			self.barTextLeft:SetText("")
			self.barTextRight:SetText("")
		end
	end

	if ( self.casting ) then

		status = GetTime()

		if ( status > self.maxValue ) then
			status = self.maxValue
		end

		if ( status == self.maxValue ) then
			self:SetValue(self.maxValue)
			self.finishSpell(self)
			return
		end

		self:SetValue(status)

		if ( self.barFlash ) then
			self.barFlash:Hide()
		end

		if (self.orient == "VERTICAL") then

			sparkPosition = ((status - self.startTime) / (self.maxValue - self.startTime)) * self:GetHeight()

			if ( sparkPosition < 0 ) then
				sparkPosition = 0
			end

			if ( self.barSpark ) then
				self.barSpark:SetPoint("CENTER", self, "BOTTOM", 0, sparkPosition)
			end

		else
			sparkPosition = ((status - self.startTime) / (self.maxValue - self.startTime)) * self:GetWidth()

			if ( sparkPosition < 0 ) then
				sparkPosition = 0
			end

			if ( self.barSpark ) then
				self.barSpark:SetPoint("CENTER", self, "LEFT", sparkPosition, 0)
			end
		end

	elseif ( self.channeling ) then

		time = GetTime()

		if ( time > self.endTime ) then
			time = self.endTime
		end

		if ( time == self.endTime ) then
			self.finishSpell(self)
			return
		end

		barValue = self.startTime + (self.endTime - time)

		self:SetValue( barValue )

		if ( self.barFlash ) then
			self.barFlash:Hide()
		end

	elseif ( GetTime() < self.holdTime ) then

		return

	elseif ( self.flash ) then

		alpha = 0

		if ( self.barFlash ) then
			alpha = self.barFlash:GetAlpha() + CASTING_BAR_FLASH_STEP
		end

		if ( alpha < 1 ) then
			if ( self.barFlash ) then
				self.barFlash:SetAlpha(alpha)
			end
		else
			if ( self.barFlash ) then
				self.barFlash:SetAlpha(1.0)
			end
			self.flash = nil
		end

	elseif ( self.fadeOut ) then

		alpha = self:GetAlpha() - CASTING_BAR_ALPHA_STEP

		if ( alpha > 0 ) then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
		end
	end
end

function Trinity2.CastingBarFrame_FinishSpell(self)

	if ( self.barSpark ) then
		self.barSpark:Hide()
	end

	if ( self.barFlash ) then
		self.barFlash:SetAlpha(0.0)
		self.barFlash:Show()
	end

	self.flash = 1
	self.fadeOut = 1
	self.casting = nil
	self.channeling = nil
end

function Trinity2.DockFrame_OnLoad(self)

	self:RegisterForClicks("AnyUp")
	self:RegisterForDrag("LeftButton")
	self:RegisterEvent("PLAYER_LOGIN")
	self:SetBackdropColor(0,0,0,0.2)
	self:SetBackdropBorderColor(0.3,0.3,0.3,0.3)
	self.click = nil
	self.dragged = false
	self.selected = false
	self.microAdjust = false
	self:EnableKeyboard(false)
	self:SetFrameLevel(2)
	self.snaptotop = getglobal(self:GetName().."SnapToTop")
	self.snaptobottom = getglobal(self:GetName().."SnapToBottom")
	self.snaptoleft = getglobal(self:GetName().."SnapToLeft")
	self.snaptoright = getglobal(self:GetName().."SnapToRight")
	self.snaptotop:SetVertexColor(0.3,0.3,0.5,0.4)
	self.snaptobottom:SetVertexColor(0.3,0.3,0.5,0.4)
	self.snaptoleft:SetVertexColor(0.3,0.3,0.5,0.4)
	self.snaptoright:SetVertexColor(0.3,0.3,0.5,0.4)
	getglobal(self:GetName().."Text"):Hide()
	self.toggleframe = self
	self.bindframe = getglobal(self:GetName().."KeyBind")

	self:Hide()

end

function Trinity2.DockFrame_OnEvent(self, event)

	if (event == "PLAYER_LOGIN") then

		if (self.config.togglebind and self.config.togglebind ~= "") then
			Trinity2.ApplyButtonClickAnchor(self, self.bindframe, self.toggleframe, self.config.togglebind)
		end
	end
end

function Trinity2.DockFrame_OnClick(self, button, store, create)

	if (self.func1) then
		self.func1(self)
	end

	local newDock = changeDock(self)

	if (store) then return end

	Trinity2DockFrameOptions.currFrame = self

	self.click = button
	self.dragged = false
	self.selected = true
	self:SetBackdropColor(0,0,1,0.4)

	if (not newDock) then
		if (button == "LeftButton") then
			if (self.selected) then
				if (Trinity2DockFrameEditorBottom:IsVisible()) then
					Trinity2DockFrameEditorBottom:Hide()
				else
					Trinity2DockFrameEditorBottom:Show()
				end
			end

			if (not Trinity2DockFrameOptions.currFrame) then
				Trinity2DockFrameEditorBottom:Show()
			end
		elseif (button == "RightButton") then
			Trinity2SimpleDockEditor:Hide()
			Trinity2DockFrameOptions:Show()
		end

	elseif (create) then
		Trinity2DockFrameEditorBottom:Show()
		getglobal(self:GetName().."Text"):Show()
	end

	if (IsShiftKeyDown()) then
		if (self.microAdjust) then
			Trinity2MessageFrame:AddMessage(TRINITY2_STRINGS.KEYBOARD_ENABLED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
			self:EnableKeyboard(false)
			self.microAdjust = false
		else
			Trinity2MessageFrame:AddMessage(TRINITY2_STRINGS.KEYBOARD_DISABLED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
			self:EnableKeyboard(true)
			self.microAdjust = true
			self:SetBackdropColor(1,0,0,0.4)
		end
	end
end

function Trinity2.DockFrame_OnDragStart(self)

	changeDock(self)

	Trinity2DockFrameOptions.currFrame = self

	self:SetFrameStrata(self.config.dockStrata)
	self:EnableKeyboard(false)

	self.adjusting = true
	self.selected = true
	self.isMoving = true

	for k,v in pairs(Trinity2.RegisteredDocks) do
		if (self.owner == getglobal(k).owner and self.config.snapto) then
			if (getglobal(k).config.snapto) then
				getglobal(k).snaptotop:Show()
				getglobal(k).snaptobottom:Show()
				getglobal(k).snaptoleft:Show()
				getglobal(k).snaptoright:Show()
			end
		end
	end

	local data = {}
	for k,v in pairs(Trinity2.AdjustableActions) do
		if (Trinity2DockFrameOptions.currFrame.actionSet[k]) then
			data[k] = k
		end
	end
	Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit1.popup, data, nil)

	self:StartMoving()
end

function Trinity2.DockFrame_OnDragStop(self)

	if (self.func1) then
		self.func1(self)
	end

	self:StopMovingOrSizing()


	self:SetUserPlaced(false)
	self.config.centerx, self.config.centery = self:GetCenter()

	for k,v in pairs(Trinity2.RegisteredDocks) do
		if (self.owner == getglobal(k).owner and self.config.snapto and self ~= getglobal(k)) then
			if (getglobal(k).config.snapto) then

				local snapto = true

				for i=1,9 do
					local _, relTo, _, _, _ = getglobal(k):GetPoint(i)
					if (relTo == self) then
						snapto = false
					end
				end

				if (snapto) then

					-- evaluate bottom-top
					if (self:GetBottom()<getglobal(k):GetTop()+28 and self:GetBottom()>getglobal(k):GetTop()-28 and self.config.centerx < getglobal(k).config.centerx+25 and self.config.centerx > getglobal(k).config.centerx-25) then
						self:ClearAllPoints()
						self:SetPoint("BOTTOM", getglobal(k), "TOP", 0, self.config.buttonSpaceV)
					end
					-- evaluate top-bottom
					if (self:GetTop()>getglobal(k):GetBottom()-28 and self:GetTop()<getglobal(k):GetBottom()+28 and self.config.centerx < getglobal(k).config.centerx+25 and self.config.centerx > getglobal(k).config.centerx-25) then
						self:ClearAllPoints()
						self:SetPoint("TOP", getglobal(k), "BOTTOM", 0, -self.config.buttonSpaceV)
					end
					-- evaluate right-left
					if (self:GetRight()>getglobal(k):GetLeft()-28 and self:GetRight()<getglobal(k):GetLeft()+28 and self.config.centery < getglobal(k).config.centery+25 and self.config.centery > getglobal(k).config.centery-25) then
						self:ClearAllPoints()
						self:SetPoint("RIGHT", getglobal(k), "LEFT", -self.config.buttonSpaceH, 0)
					end
					-- evaluate left-right
					if (self:GetLeft()<getglobal(k):GetRight()+28 and self:GetLeft()>getglobal(k):GetRight()-28 and self.config.centery < getglobal(k).config.centery+25 and self.config.centery > getglobal(k).config.centery-25) then
						self:ClearAllPoints()
						self:SetPoint("LEFT", getglobal(k), "RIGHT", self.config.buttonSpaceH, 0)
					end
				end

				getglobal(k).snaptotop:Hide()
				getglobal(k).snaptobottom:Hide()
				getglobal(k).snaptoleft:Hide()
				getglobal(k).snaptoright:Hide()
			end
		end
	end

	self.config.centerx, self.config.centery = self:GetCenter()
	self:SetUserPlaced(true)

	self.snaptotop:Hide()
	self.snaptobottom:Hide()
	self.snaptoleft:Hide()
	self.snaptoright:Hide()

	--self:ClearAllPoints()

	self.isMoving = false
	self.dragged = true
	self.elapsed = 0

	Trinity2DockFrameOptionsCurrentDockEdit2:SetText(self.config.centerx)
	Trinity2DockFrameOptionsCurrentDockEdit3:SetText(self.config.centery)

end

function Trinity2.DockFrame_OnKeyDown(self, key)

	if (self.microAdjust) then

		self.config.centerx, self.config.centery = self:GetCenter()

		self:SetUserPlaced(false)

		self:ClearAllPoints()

		if (key == "UP") then
			self.config.centery = self.config.centery + .25
		elseif (key == "DOWN") then
			self.config.centery = self.config.centery - .25
		elseif (key == "LEFT") then
			self.config.centerx = self.config.centerx - .25
		elseif (key == "RIGHT") then
			self.config.centerx = self.config.centerx + .25
		end

		self:SetPoint("CENTER", "UIParent", "BOTTOMLEFT", self.config.centerx, self.config.centery)

		Trinity2DockFrameOptionsCurrentDockEdit2:SetText(self.config.centerx)
		Trinity2DockFrameOptionsCurrentDockEdit3:SetText(self.config.centery)

		if (self.func1) then
			self.func1(self)
		end

		self:SetUserPlaced(true)
	end
end


function Trinity2.DockFrame_OnEnter(self)

	if (not self.selected) then
		self:SetBackdropColor(0,0,1,0.4)
	end

	if (Trinity2SavedState.savedOptions.CheckButtons[2] and self.tooltip) then

		if ( GetCVar("UberTooltips") == "1" ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, self)
		else
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		end

		GameTooltip:SetText(self.tooltip)
	end

	getglobal(self:GetName().."Text"):Show()
end

function Trinity2.DockFrame_OnLeave(self)

	if (not self.selected) then

		self:SetBackdropColor(0,0,0,0.2)
		getglobal(self:GetName().."Text"):Hide()

	elseif (not Trinity2DockFrameEditorBottom:IsVisible()) then

		getglobal(self:GetName().."Text"):Hide()
	end

	GameTooltip:Hide()
end

function Trinity2.DockFrame_OnUpdate(self, elapsed)

	if (self.elapsed) then

		self.elapsed = self.elapsed + elapsed

		if (self.elapsed > 10) then
			self.elapsed = 0.75
		end

		if (self.update and self.elapsed >= 0.75) then
			if (self.func2) then
				self.func2(self)
			end
			self.update = false
		end
	end

	if (GetMouseFocus() == self) then
		self:EnableMouseWheel(true)
	else
		self:EnableMouseWheel(false)
	end
end

function Trinity2.DockFrame_OnMouseWheel(self, delta)

	if (self.mousewheelfunc) then
		self.mousewheelfunc(self, delta)
	end
end

function Trinity2.SetDockFrameAdjustableOptions(dockFrame)

	local data = {}
	for k,v in pairs(Trinity2.AdjustableActions) do
		if (dockFrame.actionSet[k]) then
			data[k] = k
		end
	end

	Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit1.popup, data, nil)
end

function Trinity2.DockFrameOptionsCurrentDockEdit1_OnTextChanged(self)

	local data = {}
	local height, count, checkoption, checkoptiontext, rowstart, lastcheckoption, firstplaced = 0, 0, nil, nil, nil, nil, false

	if (Trinity2DockFrameOptionsCheckOptionsFrame.checkIndex) then
		for k,v in pairs(Trinity2DockFrameOptionsCheckOptionsFrame.checkIndex) do
			v:ClearAllPoints()
			v:Hide()
			v.func = nil
		end
	end

	Trinity2DockFrameOptionsCheckOptionsFrame.highNum = 0

	Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit1.popup, nil, nil)
	Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsColorPickerFrameEdit1.popup, nil, nil)
	Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsColorPickerFrameEdit2.popup, nil, nil)

	if (Trinity2DockFrameOptions.currFrame) then

		Trinity2.DockFrame_OnClick(Trinity2DockFrameOptions.currFrame, nil)

		for k,v in pairs(Trinity2.AdjustableActions) do
			if (Trinity2DockFrameOptions.currFrame.actionSet[k]) then
				data[k] = k
			end
		end

		Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit1.popup, data, nil)

		Trinity2DockFrameOptionsCurrentDockEdit2:SetText(Trinity2DockFrameOptions.currFrame.config.centerx)
		Trinity2DockFrameOptionsCurrentDockEdit3:SetText(Trinity2DockFrameOptions.currFrame.config.centery)

		Trinity2DockFrameOptions.checkgroup = {}

		for k,v in pairs(Trinity2.CheckboxActions) do
			if (Trinity2DockFrameOptions.currFrame.checkSet[v[3]]) then
				if (string.find(k,Trinity2DockFrameOptions.currFrame.owner)) then

					local checkNum = match(k, "%d+$")

					checkNum = tonumber(checkNum)

					if (checkNum > Trinity2DockFrameOptionsCheckOptionsFrame.highNum) then
						Trinity2DockFrameOptionsCheckOptionsFrame.highNum = checkNum
					end

					if (not getglobal("Trinity2DockFrameOptionsCheckOptionsFrameCheck"..checkNum)) then
						checkoption = CreateFrame("CheckButton", "Trinity2DockFrameOptionsCheckOptionsFrameCheck"..checkNum, Trinity2DockFrameOptionsCheckOptionsFrame, "Trinity2RoundCheckDockOptionsTemplate")
						checkoptiontext = getglobal(checkoption:GetName().."Text")

						if (not Trinity2DockFrameOptionsCheckOptionsFrame.checkIndex) then
							Trinity2DockFrameOptionsCheckOptionsFrame.checkIndex = {}
						end

						Trinity2DockFrameOptionsCheckOptionsFrame.checkIndex[checkNum] = checkoption

					else
						checkoption = getglobal("Trinity2DockFrameOptionsCheckOptionsFrameCheck"..checkNum)
						checkoptiontext = getglobal(checkoption:GetName().."Text")
					end

					if (Trinity2DockFrameOptions.currFrame.config[v[1]]) then
						checkoption:SetChecked(1)
					else
						checkoption:SetChecked(nil)
					end

					checkoption.func = v[2]
					checkoptiontext:SetText(v[3])
					checkoption.tooltip = v[4]
					checkoption.checkgroup = v.checkgroup
					checkoption.currFrame = Trinity2DockFrameOptions.currFrame

					if (not Trinity2DockFrameOptions.checkgroup[v.checkgroup]) then
						Trinity2DockFrameOptions.checkgroup[v.checkgroup] = {}
					end

					tinsert(Trinity2DockFrameOptions.checkgroup[v.checkgroup], checkoption)

					height = height + 1
				end
			end
		end

		if (Trinity2DockFrameOptionsCheckOptionsFrame.checkIndex) then

			for i=1, Trinity2DockFrameOptionsCheckOptionsFrame.highNum do

				checkoption = Trinity2DockFrameOptionsCheckOptionsFrame.checkIndex[i]

				if (checkoption) then

					checkoption:Show()

					if (not lastcheckoption and not firstplaced) then

						checkoption:SetPoint("TOPLEFT", 8, -7)
						lastcheckoption = checkoption
						rowstart = checkoption

						firstplaced = true

					elseif (not lastcheckoption) then

						checkoption:SetPoint("TOP", rowstart, "BOTTOM", 0, -5)
						lastcheckoption = checkoption
						rowstart = checkoption

					else

						checkoption:SetPoint("LEFT", lastcheckoption, "RIGHT", 60, 0)
						lastcheckoption = checkoption

					end

					count = count + 1

					if (count == 3) then
						count = 0
						lastcheckoption = nil
					end
				end
			end
		end

		height = math.ceil(height/3)

		data = {}
		for k,v in pairs(Trinity2.ColorPickerActions) do
			if (Trinity2DockFrameOptions.currFrame.colorSet[k]) then
				data[k] = k
			end
		end

		Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsColorPickerFrameEdit1.popup, data, nil)

		if (Trinity2DockFrameOptions.currFrame.config.lockcolors) then
			Trinity2DockFrameOptionsColorPickerFrameCheck1:SetChecked(1)
		else
			Trinity2DockFrameOptionsColorPickerFrameCheck1:SetChecked(nil)
		end

		for k,v in pairs(Trinity2.OptionSets) do
			if (Trinity2.OptionSets[k][4]) then
				Trinity2.OptionSets[k][4]()
			end
		end

	end

	height = (height*19) + 10

	if (height < 25) then
		height = 25
	end

	Trinity2DockFrameOptionsCheckOptionsFrame:SetHeight(height)

	Trinity2.DockFrameOptions_UpdateOptionSet()
end

function Trinity2.ScrollFrame_OnShow(frame)

end

function Trinity2.DockFrameOptionsCurrentDockEdit1_OnShow(self)

	Trinity2DockFrameOptions.dockIndex = {}
	local index = 1
	for k,v in pairs(Trinity2.RegisteredDocks) do
		if (getglobal(k).config) then
			if (getglobal(k).config.name) then
				Trinity2DockFrameOptions.dockIndex[getglobal(k).config.name] = k
			end
		end
	end
	Trinity2.EditBox_PopUpInitialize(self.popup, Trinity2DockFrameOptions.dockIndex, Trinity2DockFrameOptions)
end

function Trinity2.DockFrameOptionsAdjustableOptionsFrameOpt1Edit1_OnTextChanged(self)

	Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Subtract.func = nil
	Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Subtract:Disable()
	Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Add.func = nil
	Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Add:Disable()

	Trinity2DockFrameOptionsAdjustableOptionsFrame:SetHeight(61)

	if (Trinity2.AdjustableActions[self:GetText()]) then

		local data = {}
		local found = false
		local func1 = Trinity2.AdjustableActions[self:GetText()][1]
		local currval, data1 = func1(Trinity2DockFrameOptions.currFrame)

		if (currval) then
			if (Trinity2.AdjustableActions[self:GetText()]["editmode"] == 1) then
				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit2:SetText(currval)
			elseif (Trinity2.AdjustableActions[self:GetText()]["editmode"] == 2) then
				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit3:SetText(currval)
			end
		end

		if (func1) then
			if (Trinity2.AdjustableActions[self:GetText()]["editmode"] == 1) then

				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit3:Hide()

				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit2:Show()

				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Subtract.func = func1
				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Subtract:Enable()
				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Subtract:Show()

				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Add.func = func1
				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Add:Enable()
				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Add:Show()

			elseif (Trinity2.AdjustableActions[self:GetText()]["editmode"] == 2) then

				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit2:Hide()
				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Subtract:Hide()
				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Add:Hide()

				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit3.func = func1
				Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit3:Show()

				Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameOptionsAdjustableOptionsFrameOpt1Edit3.popup, data1)

			end
		end

	end

	Trinity2.DockFrameOptions_UpdateOptionSet()
end

function Trinity2.DockFrameOptionsAdjustableOptionsFrameOpt1Edit2_OnTextChanged(self)

end

function Trinity2.DockFrameOptionsAdjustableOptionsFrameOpt1Edit3_OnTextChanged(self)

	if (self.func) then
		self.func(Trinity2DockFrameOptions.currFrame, self:GetText())
	end
end

function Trinity2.DockFrameOptions_OnClick(self)

	if (self.button == "prev") then
		Trinity2DockFrameOptions.optionSet = Trinity2DockFrameOptions.optionSet - 1
		if (Trinity2DockFrameOptions.optionSet < 1) then
			Trinity2DockFrameOptions.optionSet = maxOptionSets
		end
	elseif (self.button == "next") then
		Trinity2DockFrameOptions.optionSet = Trinity2DockFrameOptions.optionSet + 1
		if (Trinity2DockFrameOptions.optionSet > maxOptionSets) then
			Trinity2DockFrameOptions.optionSet = 1
		end
	elseif (self.button == "close") then
		Trinity2.ToggleAdvancedDockEditMode()
	end

	Trinity2.DockFrameOptions_UpdateOptionSet()
end

function Trinity2.DockFrameOptions_UpdateOptionSet()

	local index = {}
	local lastFrame, height = _,0

	for i=1, #Trinity2.OptionSets do

		Trinity2.OptionSets[i][1]:Hide()

		if (Trinity2.OptionSets[i][2] ~= 99) then

			if (Trinity2.OptionSets[i][2] == Trinity2DockFrameOptions.optionSet or Trinity2.OptionSets[i][2] == 0) then
				index[Trinity2.OptionSets[i][3]] = Trinity2.OptionSets[i][1]
			end

			if (Trinity2.OptionSets[i][2] > maxOptionSets) then
				maxOptionSets = Trinity2.OptionSets[i][2]
			end
		end
	end

	for i=1, #Trinity2.OptionSets do

		if (Trinity2.OptionSets[i][2] == 99) then
			index[#index+1] = Trinity2.OptionSets[i][1]
		end
	end

	for i=1,#index do

		if (index[i]) then

			index[i]:Show()
			index[i]:ClearAllPoints()

			if (i==1) then
				index[i]:SetPoint("TOP", "Trinity2DockFrameOptions", "TOP", 0, -40)
				lastFrame = index[i]
			else
				index[i]:SetPoint("TOP", lastFrame, "BOTTOM", 0, -10)
				lastFrame = index[i]
			end

			height = height + index[i]:GetHeight()
		end
	end

	local y = Trinity2DockFrameOptions:GetTop()
	local x,_ = Trinity2DockFrameOptions:GetCenter()

	Trinity2DockFrameOptions:SetHeight(height+((#index-1)*10)+50)
end

function Trinity2.DockFrameOptionsColorPickerFrameEdit1_OnShow(self)

	if (Trinity2DockFrameOptions.currFrame) then

		if (Trinity2DockFrameOptions.currFrame.config.lockcolors) then
			Trinity2DockFrameOptionsColorPickerFrameCheck1:SetChecked(1)
		else
			Trinity2DockFrameOptionsColorPickerFrameCheck1:SetChecked(nil)
		end
	end

end

function Trinity2.DockFrameOptionsColorPickerFrameEdit1_OnTextChanged(self)

	if (Trinity2.ColorPickerActions[self:GetText()]) then

		local data = {}
		local found = false

		Trinity2ColorPicker.func = Trinity2.ColorPickerActions[self:GetText()][1]
		local currval =  Trinity2ColorPicker.func(Trinity2DockFrameOptions.currFrame)

		if (currval) then

			Trinity2ColorPickerRedValue:SetText(currval[1])
			Trinity2ColorPickerRedValue:SetTextColor(currval[1],currval[2],currval[3])

			Trinity2ColorPickerGreenValue:SetText(currval[2])
			Trinity2ColorPickerGreenValue:SetTextColor(currval[1],currval[2],currval[3])

			Trinity2ColorPickerBlueValue:SetText(currval[3])
			Trinity2ColorPickerBlueValue:SetTextColor(currval[1],currval[2],currval[3])

			Trinity2ColorPickerHexValue:SetText(string.upper(string.format("%02x%02x%02x", math.ceil((currval[1]*255)), math.ceil((currval[2]*255)), math.ceil((currval[3]*255)))))
			Trinity2ColorPickerHexValue:SetTextColor(currval[1],currval[2],currval[3])

			Trinity2ColorPicker:SetColorRGB(currval[1],currval[2],currval[3])
		end
	end
end

function Trinity2.DockFrameOptionsColorPickerFrameEdit2_OnShow(self)

	if (Trinity2DockFrameOptions.currFrame) then
		local data = {}
		for k,v in pairs(Trinity2DockFrameOptions.dockIndex) do
			if (getglobal(v).owner == Trinity2DockFrameOptions.currFrame.owner) then
				data[k] = k
			end
		end

		Trinity2.EditBox_PopUpInitialize(self.popup, data, nil)
	end
end

function Trinity2.DockFrameOptionsColorPickerFrameEdit2_OnTextChanged(self)

end

function Trinity2.DockFrameOptionsColorPickerFrameCopy_OnClick(self)

	if (Trinity2DockFrameOptions.currFrame) then

		if (Trinity2DockFrameOptions.dockIndex[Trinity2DockFrameOptionsColorPickerFrameEdit2:GetText()]) then

			local copyDock = getglobal(Trinity2DockFrameOptions.dockIndex[Trinity2DockFrameOptionsColorPickerFrameEdit2:GetText()])

			for k,v in pairs(Trinity2.ColorPickerActions) do
				if (Trinity2DockFrameOptions.currFrame.colorSet[k]) then
					Trinity2.ColorPickerActions[k][1](Trinity2DockFrameOptions.currFrame, copyDock.config[copyDock.colorSet[k]][1], copyDock.config[copyDock.colorSet[k]][2], copyDock.config[copyDock.colorSet[k]][3])
				end
			end
		end
	end
end

function Trinity2.DockFrameOptionsColorPickerFrameCopyAll_OnClick(self)

	local data = {}
	for k,v in pairs(Trinity2DockFrameOptions.dockIndex) do
		if (getglobal(v).owner == Trinity2DockFrameOptions.currFrame.owner) then

			local copyDock = Trinity2DockFrameOptions.currFrame

			for key,value in pairs(Trinity2.ColorPickerActions) do
				if (copyDock.colorSet[key]) then
					if (not getglobal(v).config.lockcolors) then
						Trinity2.ColorPickerActions[key][1](getglobal(v), copyDock.config[copyDock.colorSet[key]][1], copyDock.config[copyDock.colorSet[key]][2], copyDock.config[copyDock.colorSet[key]][3])
					end
				end
			end
		end
	end
end

function Trinity2.Trinity2BindingEditorCurrentDockEdit1_OnShow(self)

	Trinity2BindingEditor.dockIndex = {}

	local index = 1

	for k,v in pairs(Trinity2.RegisteredDocks) do
		if (getglobal(k).config) then
			if (getglobal(k).config.name) then
				Trinity2BindingEditor.dockIndex[getglobal(k).config.name] = k
			end
		end
	end

	Trinity2.EditBox_PopUpInitialize(self.popup, Trinity2BindingEditor.dockIndex, Trinity2BindingEditor)

	Trinity2BindingEditorCurrentDockBinding:SetText(TRINITY2_STRINGS.DOCK_TOGGLE_HELP)
end

function Trinity2.Trinity2BindingEditorCurrentDockEdit1_OnTextChanged(self)

	if (Trinity2BindingEditor.currFrame) then
		if (Trinity2BindingEditor.currFrame.config.togglebind and Trinity2BindingEditor.currFrame.config.togglebind ~= "") then
			Trinity2BindingEditorCurrentDockBinding:SetText(TRINITY2_STRINGS.DOCK_CURRENT_BIND..Trinity2BindingEditor.currFrame.config.togglebind)
		else
			Trinity2BindingEditorCurrentDockBinding:SetText(TRINITY2_STRINGS.DOCK_NO_BINDING)
		end

		if (Trinity2BindingEditor.currFrame.config.atcursor == true) then
			Trinity2BindingEditorCurrentDockCursorCheck:SetChecked(1)
		else
			Trinity2BindingEditorCurrentDockCursorCheck:SetChecked(nil)
		end
	end

end

function Trinity2.BindFrame_OnAction(self, key)

	local modifier, bindkey, action, type

	actionText = TRINITY2_STRINGS.DOCK_TOGGLE

	if (IsAltKeyDown()) then
		modifier = "ALT-"
	end

	if (IsControlKeyDown()) then
		if (modifier) then
			modifier = modifier.."CTRL-"
		else
			modifier = "CTRL-"
		end
	end

	if (IsShiftKeyDown()) then
		if (modifier) then
			modifier = modifier.."SHIFT-"
		else
			modifier = "SHIFT-"
		end
	end

	if (arg1 == "MiddleButton") then
		bindkey = "BUTTON3"
		action = key
	elseif (arg1 == "Button4") then
		bindkey = "BUTTON4"
		action = key
	elseif (arg1 == "Button5") then
		bindkey = "BUTTON5"
		action = key
	elseif (arg1 == 1) then
		bindkey = "MOUSEWHEELUP"
		action = "MousewheelUp"
	elseif (arg1 == -1) then
		bindkey = "MOUSEWHEELDOWN"
		action = "MousewheelDown"
	elseif (find(key,"ALT") or find(key,"SHIFT") or find(key,"CTRL")) then
		return
	else
		bindkey = key
		action = key
	end

	if (arg1 ~= "LeftButton" and arg1~= "RightButton") then

		Trinity2.ProcessBinding(bindkey, modifier)

		if (bindkey == "ESCAPE") then
			Trinity2MessageFrame:AddMessage(actionText..TRINITY2_STRINGS.DOCK_CLEARED, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		elseif (modifier) then
			Trinity2MessageFrame:AddMessage(actionText..TRINITY2_STRINGS.DOCK_BOUND..modifier..action, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		else
			Trinity2MessageFrame:AddMessage(actionText..TRINITY2_STRINGS.DOCK_BOUND..action, 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME)
		end
	end
end

function Trinity2.BindFrame_OnEnter(self)

	self:EnableMouseWheel(true)
	self:EnableKeyboard(true)

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

	GameTooltip:SetText(TRINITY2_STRINGS.DOCK_TOGGLE_TOOLTIP, 1.0, 1.0, 1.0)

	GameTooltip:Show()
end

function Trinity2.BindFrame_OnLeave(self)

	self:EnableMouseWheel(false)
	self:EnableKeyboard(false)

	GameTooltip:Hide()
end

function Trinity2.CursorToggle_OnShow(self)


end

function Trinity2.CursorToggle_OnClick(self)

	if (Trinity2BindingEditor.currFrame) then

		local dockFrame = Trinity2BindingEditor.currFrame

		if (self:GetChecked()) then
			dockFrame.config.atcursor = true

			if (dockFrame.config.togglebind and dockFrame.config.togglebind ~= "") then
				Trinity2.ApplyButtonClickAnchor(dockFrame, dockFrame.bindframe, dockFrame.toggleframe, key)
			end
		else
			dockFrame.config.atcursor = false

			if (dockFrame.config.togglebind and dockFrame.config.togglebind ~= "") then
				Trinity2.ApplyButtonClickAnchor(dockFrame, dockFrame.bindframe, dockFrame.toggleframe, key)
			end
		end
	end
end

function Trinity2.GetKeyText(bindkey, modifier)

	local keytext

	if (modifier) then

		if (find(bindkey, "BUTTON")) then
			keytext = lower(gsub(modifier, "(%S)(%S+)", "%1"))..gsub(bindkey,"(%S+)(%d+)","m%2")
		elseif (find(bindkey, "NUMPAD")) then
			keytext = lower(gsub(modifier, "(%S)(%S+)", "%1"))..gsub(bindkey,"NUMPAD","n")
			keytext = gsub(keytext,"DIVIDE","/")
			keytext = gsub(keytext,"MULTIPLY","*")
			keytext = gsub(keytext,"MINUS","-")
			keytext = gsub(keytext,"PLUS","+")
			keytext = gsub(keytext,"DECIMAL",".")
		elseif (find(bindkey, "MOUSEWHEEL")) then
			keytext = lower(gsub(modifier, "(%S)(%S+)", "%1"))..gsub(bindkey,"MOUSEWHEEL","mw")
			keytext = gsub(keytext,"UP","U")
			keytext = gsub(keytext,"DOWN","D")
		else
			--keytext = lower(gsub(modifier, "(%S)(%S+)", "%1"))..bindkey;
			keytext = modifier
			keytext = gsub(keytext,"ALT%-","a")
			keytext = gsub(keytext,"CTRL%-","c")
			keytext = gsub(keytext,"SHIFT%-","s")

			keytext = keytext..bindkey
		end
	else

		if (find(bindkey, "BUTTON")) then
			keytext = gsub(bindkey,"(%S+)(%d+)","m%2")
		elseif (find(bindkey, "NUMPAD")) then
			keytext = gsub(bindkey,"NUMPAD","n")
			keytext = gsub(keytext,"DIVIDE","/")
			keytext = gsub(keytext,"MULTIPLY","*")
			keytext = gsub(keytext,"MINUS","-")
			keytext = gsub(keytext,"PLUS","+")
			keytext = gsub(keytext,"DECIMAL",".")
		elseif (find(bindkey, "MOUSEWHEEL")) then
			keytext = gsub(bindkey,"MOUSEWHEEL","mw")
			keytext = gsub(keytext,"UP","U")
			keytext = gsub(keytext,"DOWN","D")
		else
			keytext = bindkey;
		end
	end

	return keytext
end

function Trinity2.ProcessBinding(bindkey, modifier)

	if (Trinity2BindingEditor.currFrame) then

		local dockFrame = Trinity2BindingEditor.currFrame
		local key, keytext

		if (bindkey == "PRINTSCREEN") then
			return
		end

		if (bindkey == "ESCAPE") then
			Trinity2.ClearButtonClickAnchor(dockFrame, dockFrame.bindframe, dockFrame.toggleframe, dockFrame.config.togglebind)
			Trinity2BindingEditorCurrentDockBinding:SetText(TRINITY2_STRINGS.DOCK_NO_BINDING_2)
			dockFrame.config.togglebind = ""
			dockFrame.config.togglebindtext = ""
			return
		end

		if (modifier) then
			key = modifier..bindkey
			keytext = Trinity2.GetKeyText(bindkey, modifier)
		else
			key = bindkey
			keytext = Trinity2.GetKeyText(bindkey)
		end

		Trinity2BindingEditorCurrentDockBinding:SetText(TRINITY2_STRINGS.DOCK_CURRENT_BIND..keytext)
		dockFrame.config.togglebind = key
		dockFrame.config.togglebindtext = keytext
		Trinity2.ApplyButtonClickAnchor(dockFrame, dockFrame.bindframe, dockFrame.toggleframe, key)
	end
end

function Trinity2.ApplyButtonClickAnchor(dockFrame, button, header, key)

	SetBindingClick(key, button:GetName())

	button:SetAttribute("anchorchild", header)
	button:SetAttribute("*childstate-up", "^up")

	SecureStateAnchor_RunChild(button, "LeftButton", "onmouseupbutton")

	if (dockFrame.config.atcursor) then

		header:ClearAllPoints()

		header:SetAttribute("headofsx", "1:0;0:1")
		header:SetAttribute("headofsy", "1:0;0:1")
		header:SetAttribute("headofsrelpoint", "cursor")

	else
		header:ClearAllPoints()
		header:SetAllPoints(dockFrame)

		header:SetAttribute("headofsx", nil)
		header:SetAttribute("headofsy", nil)
		header:SetAttribute("headofsrelpoint", nil)
	end
end

function Trinity2.ClearButtonClickAnchor(dockFrame, button, header, key)

	SetBinding(key, nil)

	button:SetAttribute("*childstate-OnEnter", "enter")
	SecureStateAnchor_RunChild(button, "OnEnter", "onenterbutton")

	button:SetAttribute("*childstate-up", nil)
	button:SetAttribute("*childstate-OnEnter", nil)
	button:SetAttribute("*childstate-OnLeave", nil)

	header:ClearAllPoints()
	header:SetAllPoints(dockFrame)

	header:SetAttribute("headofsx", nil)
	header:SetAttribute("headofsy", nil)
	header:SetAttribute("headofsrelpoint", nil)
end

function Trinity2.OnEscapeToggle()

	local found = false

	for k,v in pairs(Trinity2.RegisteredPanels) do
		if (v[1]:IsVisible()) then
			v[1]:Hide()
			found = true
		end
	end

	if (found) then
		HideUIPanel(GameMenuFrame)
	end
end

function Trinity2.DockFrameEditorBottomEdit1_SetWidth(frame)

	local width

	Trinity2DockFrameEditorBottomText:SetText(frame:GetText())
	Trinity2DockFrameEditorBottomText:SetTextColor(0,0,0,0)

	width = Trinity2DockFrameEditorBottomText:GetWidth()

	if (width > 110) then
		frame:GetParent():SetWidth(width+10)
	else
		frame:GetParent():SetWidth(120)
	end

end

function Trinity2.DockFrameEditorBottomEdit1_OnTextChanged(self)

	self.action = nil

	if (self:GetParent().frame) then

		local action = match(self:GetText(), "^[^-]+")

		if (action) then

			action = gsub(action, "%s*$", "")

			self.action = action

			local func = Trinity2.AdjustableActions[action][1]
			local currval, data = func(self:GetParent().frame)

			if (currval) then
				self:SetText(action.." - "..currval)
			end

			Trinity2DockFrameEditorBottomAdd.func = func
			Trinity2DockFrameEditorBottomSubtract.func = func

			--DEFAULT_CHAT_FRAME:AddMessage(currval)

			local data = {}

			for k,v in pairs(self:GetParent().frame.simpleActionSet) do
				if (v) then
					data[k] = k
				end
			end

			Trinity2.EditBox_PopUpInitialize(Trinity2DockFrameEditorBottomEdit1.popup, data)

		end
	end

	Trinity2.DockFrameEditorBottomEdit1_SetWidth(self)

end

--From wowwiki.com
local minimapShapes = {

	-- quadrant booleans (same order as SetTexCoord)
	-- {upper-left, lower-left, upper-right, lower-right}
	-- true = rounded, false = squared

	["ROUND"] 			= {true, true, true, true},
	["SQUARE"] 			= {false, false, false, false},
	["CORNER-TOPLEFT"] 		= {true, false, false, false},
	["CORNER-TOPRIGHT"] 		= {false, false, true, false},
	["CORNER-BOTTOMLEFT"] 		= {false, true, false, false},
	["CORNER-BOTTOMRIGHT"]	 	= {false, false, false, true},
	["SIDE-LEFT"] 			= {true, true, false, false},
	["SIDE-RIGHT"] 			= {false, false, true, true},
	["SIDE-TOP"] 			= {true, false, true, false},
	["SIDE-BOTTOM"] 		= {false, true, false, true},
	["TRICORNER-TOPLEFT"] 		= {true, true, true, false},
	["TRICORNER-TOPRIGHT"] 		= {true, false, true, true},
	["TRICORNER-BOTTOMLEFT"] 	= {true, true, false, true},
	["TRICORNER-BOTTOMRIGHT"] 	= {false, true, true, true},
}

function Trinity2.IconDraggingFrame_OnUpdate(x, y)

	local pos, quad, round, radius = nil, nil, nil, Trinity2SavedState.buttonRadius - Trinity2MinimapButton:GetWidth()/math.pi
	local sqRad = sqrt(2*(radius)^2)

	local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()

	local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
	local quadTable = minimapShapes[minimapShape]

	local xpos, ypos = x, y

	if (not xpos or not ypos) then
		xpos, ypos = GetCursorPosition()
	end

	xpos = xmin - xpos / Minimap:GetEffectiveScale() + radius
	ypos = ypos / Minimap:GetEffectiveScale() - ymin - radius

	pos = math.deg(math.atan2(ypos,xpos))

	xpos = cos(pos)
	ypos = sin(pos)

	if (xpos > 0 and ypos > 0) then
		quad = 1 --topleft
	elseif (xpos > 0 and ypos < 0) then
		quad = 2 --bottomleft
	elseif (xpos < 0 and ypos > 0) then
		quad = 3 --topright
	elseif (xpos < 0 and ypos < 0) then
		quad = 4 --bottomright
	end

	round = quadTable[quad]

	if (round) then
		xpos = xpos * radius
		ypos = ypos * radius
	else
		xpos = max(-radius, min(xpos * sqRad, radius))
		ypos = max(-radius, min(ypos * sqRad, radius))
	end

	Trinity2MinimapButton:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52-xpos, ypos-55)

	Trinity2SavedState.buttonLoc = { 52-xpos, ypos-55 }
end

function Trinity2.MinimapButton_OnLoad(self)

	self:RegisterForClicks("AnyUp")
	self:RegisterForDrag("LeftButton")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.elapsed = 0
	self.transition = 75
	self.count = 14
	self.buttoncount = 0
end

function Trinity2.MinimapButton_OnEvent(self)

	self:SetUserPlaced(false)
	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", "Minimap","TOPLEFT", Trinity2SavedState.buttonLoc[1], Trinity2SavedState.buttonLoc[2])
	self:SetFrameStrata(MinimapCluster:GetFrameStrata())
	self:SetFrameLevel(MinimapCluster:GetFrameLevel()+3)
end

function Trinity2.MinimapButton_OnDragStart(self)

	self:LockHighlight()
	self:StartMoving()
	Trinity2MinimapButtonIconDraggingFrame:Show()
end

function Trinity2.MinimapButton_OnDragStop(self)

	self:UnlockHighlight()
	self:StopMovingOrSizing()
	self:SetUserPlaced(false)
	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", "Minimap","TOPLEFT", Trinity2SavedState.buttonLoc[1], Trinity2SavedState.buttonLoc[2])
	Trinity2MinimapButtonIconDraggingFrame:Hide()
end

function Trinity2.MinimapButton_OnHide(self)

	self:UnlockHighlight()
	Trinity2MinimapButtonIconDraggingFrame:Hide()
end

function Trinity2.MinimapButton_OnEnter(self)

	local status

	GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)

	if (Trinity2.configMode) then
		status = TRINITY2_STRINGS.MINIMAP_CONFIG_STATUS_ON
	else
		status = TRINITY2_STRINGS.MINIMAP_CONFIG_STATUS_OFF
	end

	GameTooltip:SetText(TRINITY2_STRINGS.MINIMAP_TOOLTIP..status)

end

function Trinity2.MinimapButton_OnLeave(self)

	GameTooltip:Hide()
end

function Trinity2.MinimapButton_OnClick(self, button)

	PlaySound("igChatScrollDown")

	if (InCombatLockdown()) then
		return
	end

	Trinity2.OpenOptionsMenu = false

	if (IsShiftKeyDown()) then

		if (Trinity2TemplateManager:IsVisible()) then
			Trinity2TemplateManager:Hide()
		else
			Trinity2TemplateManager:Show()
		end

	elseif (button == "RightButton") then

		for k,v in pairs(subMenuButtons) do
			v:Hide()
		end

		Trinity2.OpenOptionsMenu = false

		Trinity2.ToggleMainMenu()

	else
		for k,v in pairs(subMenuButtons) do

			if (v:IsVisible()) then

				v:Hide()

				Trinity2.OpenOptionsMenu = false

			else

				v:Show()

				Trinity2.OpenOptionsMenu = true

				self.transition = 75
				self.count = 15
			end
		end
	end
end

function Trinity2.MinimapButton_OnUpdate(self, elapsed)

	if (Trinity2.OpenOptionsMenu) then

		if (#subMenuButtons > 0) then

			Trinity2.MenuOptionTransition(Trinity2MinimapButton, "Trinity2MinimapOption", #subMenuButtons)
		else

			for k,v in pairs(subMenuButtons) do

				if (v:IsVisible()) then
					v:Hide()
				end
			end

			Trinity2.OpenOptionsMenu = false
		end
	end
end

function Trinity2.OptionsSlider1_OnShow(self)

	self.x, self.y = Trinity2SavedState.buttonLoc[1], Trinity2SavedState.buttonLoc[2]
	self:SetValue(Trinity2SavedState.buttonRadius)
end

function Trinity2.OptionsSlider1_OnValueChanged(self, value)

	local mmx, mmy = Trinity2MinimapButton:GetCenter()

	Trinity2SavedState.buttonRadius = value

	mmx = mmx * Minimap:GetEffectiveScale()
	mmy = mmy * Minimap:GetEffectiveScale()

	Trinity2.IconDraggingFrame_OnUpdate(mmx, mmy)

	if (self.x and self.y) then
		Trinity2MinimapButton:SetPoint("TOPLEFT", "Minimap","TOPLEFT", self.x, self.y)
		self.x = nil
		self.y = nil
	end
end

function Trinity2.OptionsSlider2_OnShow(self)

	self:SetValue(Trinity2SavedState.subMenuRadius)

end

function Trinity2.OptionsSlider2_OnValueChanged(self, value)

	Trinity2SavedState.subMenuRadius = value

	for k,v in pairs(subMenuButtons) do

		v:Show()

		Trinity2.OpenOptionsMenu = true

		self.transition = 75
		self.count = 15
	end

	Trinity2.MenuOptionTransition(Trinity2MinimapButton, "Trinity2MinimapOption", #subMenuButtons)
end

function Trinity2.OptionsSlider3_OnShow(self)

	self:SetValue(Trinity2SavedState.subMenuScale)

end

function Trinity2.OptionsSlider3_OnValueChanged(self, value)

	Trinity2SavedState.subMenuScale = value

	for k,v in pairs(subMenuButtons) do

		v:Show()

		Trinity2.OpenOptionsMenu = true

		self.transition = 75
		self.count = 15
	end

	Trinity2.MenuOptionTransition(Trinity2MinimapButton, "Trinity2MinimapOption", #subMenuButtons)
end

function Trinity2.TemplateManagerCurrentAddonEdit1_OnTextChanged(self)

	Trinity2TemplateManager:SetHeight(94)

	for k,v in pairs(templateFrames) do
		v:Hide()
	end

	if (templateFrames[self:GetText()]) then

		Trinity2TemplateManager:SetHeight(100 + templateFrames[self:GetText()]:GetHeight())

		templateFrames[self:GetText()]:Show()

	end
end