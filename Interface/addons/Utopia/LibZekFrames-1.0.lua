local rev = 1
local MAJOR, MINOR = "LibZekFrames-1.0", rev
local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

local SIZE_HELP1, SIZE_HELP2, SCALE_STATUS
do
	SIZE_HELP1 = "|cFFFFFF80Click|r and drag to |cFFFFFFFFResize|r"
	SIZE_HELP2 = "|cFFFFFF80Shift-Click|r and drag to |cFFFFFFFFScale|r"
	SCALE_STATUS = "Scale: |cFF80FF80%.1f%%|r"
end

--[===[@debug@
ZLZF = 1
local function d(fmt, ...)
	if (ZLZF) then
		fmt = fmt:gsub("(%%[sdqxf])", "|cFF60FF60%1|r")
		ChatFrame1:AddMessage("|cFFFF8080LZF:|r "..format(fmt, ...), 0.8, 0.8, 0.8)
	end
end
--@end-debug@]===]

local new, del, copy, deepDel

function lib:AssignTableResources(n, d, c, dd)
	if (not new) then
--[===[@debug@
assert(type(n) == "function")
assert(type(d) == "function")
assert(type(c) == "function")
assert(type(dd) == "function")
local test = n()
assert(type(test) == "table")
assert(not next(test))
test = d(test)
assert(test == nil)
--@end-debug@]===]
		new, del, copy, deepDel = n, d, c, dd
	end
end

local resources = lib.resource or {}
lib.resources = resources
function lib:AssignTextureResources(...)
	for i = 1,select("#", ...) do
		local tex = select(i, ...)
		resources[tex:match("([%-%a]+)$")] = tex
	end
end

do
	local scaleFrame

	-- frame.DragStop
	local function frameDragStop(self)
		self:StopMovingOrSizing()
		if (self.OnPositionChanged) then
			self:OnPositionChanged()
		end
	end

	-- frame.GripOnEnter
	local function frameGripOnEnter(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(SIZE_HELP1)
		GameTooltip:AddLine(SIZE_HELP2)
		GameTooltip:Show()
	end

	-- frame.GripOnLeave
	local function frameGripOnLeave(self)
		GameTooltip:Hide()
	end

	-- frame.GripDragStart
	local function frameGripDragStart(self)
		GameTooltip:Hide()
		if (IsShiftKeyDown()) then
			self:GetParent():StartScaling()
		else
			self:GetParent():StartSizing("BOTTOMRIGHT")
		end
	end

	-- frame.GripDragStop
	local function frameGripDragStop(self)
		self:GetParent():StopScalingOrMoving()
		if (self.OnPositionChanged) then
			self:OnPositionChanged()
		end
	end

	-- frame.ScalingOnUpdate
	local function frameScalingOnUpdate(self)
		local width = self:GetWidth()
		if (width ~= self.lastWidth) then
			self.lastWidth = width
			local targetWidth = width / self.startScale
			local targetScale = targetWidth / scaleFrame.startWidth * self.startScale
			if (targetScale > 0.25 and targetScale < 5) then
				self.control:SetScale(targetScale)

				if (self.control.grip) then
					GameTooltip:SetOwner(self.control.grip, "ANCHOR_RIGHT")
					GameTooltip:SetText(format(SCALE_STATUS, targetScale * 100))
					GameTooltip:Show()
				end
			end
		end
	end

	-- frame.ScalingOnHide
	local function frameScalingOnHide(self)
		self.startWidth, self.startScale, self.control = nil
	end

	-- OnHide
	local function frameOnHide(self)
		if (scaleFrame and scaleFrame.control == self) then
			scaleFrame:Hide()
		end
	end

	-- frame.StartScaling
	local function frameStartScaling(self)
		if (not scaleFrame) then
			scaleFrame = CreateFrame("Frame", nil, UIParent)
			scaleFrame:SetScript("OnUpdate", frameScalingOnUpdate)
			scaleFrame:SetScript("OnHide", frameScalingOnHide)
			scaleFrame:SetResizable(true)
		else
			scaleFrame:Show()
		end

		scaleFrame:SetFrameLevel(self:GetFrameLevel() + 5)

		self.anchorLeft = self:GetLeft() * self:GetScale()
		self.anchorTop = (UIParent:GetHeight() - (self:GetTop() * self:GetScale()))

		self:ClearAllPoints()
		scaleFrame:ClearAllPoints()
		scaleFrame:SetPoint("TOPLEFT", self.anchorLeft, -self.anchorTop)
		self:SetPoint("TOPLEFT", scaleFrame, "TOPLEFT")

		scaleFrame:SetWidth(self:GetWidth() * self:GetScale())
		scaleFrame:SetHeight(self:GetHeight() * self:GetScale())
		scaleFrame:StartSizing("BOTTOMRIGHT")

		scaleFrame.startWidth = self:GetWidth()
		scaleFrame.startScale = self:GetScale()
		scaleFrame.control = self
	end

	-- frame.StopScalingOrMoving
	local function frameStopScalingOrMoving(self)
		if (scaleFrame and scaleFrame:IsShown()) then
			local oldScale = scaleFrame.startScale

			GameTooltip:Hide()
			scaleFrame:StopMovingOrSizing()
			scaleFrame:Hide()

			local newLeft = self.anchorLeft / self:GetScale()
			local newTop = self.anchorTop / self:GetScale()

			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", newLeft, -newTop)
			self:SetUserPlaced(true)
			self.anchorLeft, self.anchorTop = nil

			if (self.OnScaleChanged) then
				self:OnScaleChanged(self:GetScale(), oldScale)
			end
		else
			self:StopMovingOrSizing()
		end
	end

	-- MovableFrame
	function lib:MovableFrame(frame)
		tinsert(UISpecialFrames, frame:GetName())

		frame:SetToplevel(true)
		frame:SetMovable(true)
		frame:SetResizable(true)
		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")

		frame.grip = CreateFrame("Frame", nil, frame)
		frame.grip:SetPoint("BOTTOMRIGHT", -4, 7)
		frame.grip:SetWidth(20)
		frame.grip:SetHeight(20)
		frame.grip.tex = frame.grip:CreateTexture(nil, "OVERLAY")
		frame.grip.tex:SetAllPoints()
		frame.grip.tex:SetTexture(resources["LibZekFrames-ResizeGrip"])
		frame.grip.tex:SetBlendMode("ADD")
		frame.grip.hl = frame.grip:CreateTexture(nil, "HIGHLIGHT")
		frame.grip.hl:SetAllPoints()
		frame.grip.hl:SetTexture(resources["LibZekFrames-ResizeGrip"])
		frame.grip.hl:SetBlendMode("ADD")

		frame:SetScript("OnDragStart", frame.StartMoving)
		frame:SetScript("OnDragStop", frameDragStop)
		frame:SetScript("OnHide", frameOnHide)

		frame.grip:EnableMouse(true)
		frame.grip:RegisterForDrag("LeftButton")
		frame.grip:SetScript("OnDragStart", frameGripDragStart)
		frame.grip:SetScript("OnDragStop", frameGripDragStop)
		frame.grip:SetScript("OnEnter", frameGripOnEnter)
		frame.grip:SetScript("OnLeave", frameGripOnLeave)

		frame.StartScaling = frameStartScaling
		frame.StopScalingOrMoving = frameStopScalingOrMoving

		frame:SetClampedToScreen(true)
		local cw = frame:GetWidth() * 0.75
		local ch = frame:GetHeight() * 0.75
		frame:SetClampRectInsets(cw, -cw, -ch, ch)
	end
end

-- ApplyBorder
function lib:ApplyBorder(frame, Type)
	local bgDef = {
		edgeSize = 10, tileSize = 32, tile = true,
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	}

	if (Type == "tooltip") then
		bgDef.edgeInsets = {left = 6, right = 6, top = 6, bottom = 6}
		bgDef.edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border"
	else
		bgDef.edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border"
		bgDef.edgeInsets = {left = 11, right = 12, top = 12, bottom = 11}
	end

	frame:SetBackdrop(bgDef)
	frame:SetBackdropBorderColor(1, 1, 1, 0.8)
	frame:SetBackdropColor(0, 0, 0, 1)
end	

-- CreateArrowButton
function lib:CreateArrowButton(parent, which)
	local template
	if (which == "up") then
		template = "UIPanelScrollUpButtonTemplate"
	elseif (which == "down") then
		template = "UIPanelScrollDownButtonTemplate"
	end

	local b = CreateFrame("Button", nil, parent, template)
	return b
end

local function genericSetTooltipText(self, text)
	self.tooltip = text
	if (GameTooltip:IsOwned(self)) then
		(self:GetScript("OnEnter"))(self)
	end
end

local function genericOnLeave(self)
	GameTooltip:Hide()
end

do
	local function sliderOnEnter(self)
		self.text:SetTextColor(1, 1, 1)
		if (self.tooltip) then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetText(self.text:GetText(), 1, 1, 1)
			GameTooltip:AddLine(self.tooltip, nil, nil, nil, 1)
			GameTooltip:Show()
		end
	end

	local function sliderOnLeave(self)
		self.text:SetTextColor(1, 0.82, 0)
		GameTooltip:Hide()
	end

	local function sliderOnValueChanged(self, value)
		if (self.OnValueChanged) then
			self.OnValueChanged(self.callparent, value)
		end
		self.midText:SetText(value)
	end

	-- Slider
	function lib:Slider(parent, callparent, text, get, set, Min, Max, step, ...)
--[===[@debug@
		assert(type(parent) == "table" and (parent.GetObjectType or parent.GetFrameType))
		assert(type(callparent) == "table" and (callparent.GetObjectType or callparent.GetFrameType))
		assert(type(text) == "string")
		assert(type(get) == "function")
		assert(type(set) == "function")
		assert(type(Min) == "number")
		assert(type(Max) == "number")
		assert(type(step) == "number")
--@end-debug@]===]

		local b = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
		b.callparent = callparent
		b:SetWidth(130)

		local temp = new(b:GetRegions())
		for i,reg in ipairs(temp) do
			if (reg:GetObjectType() == "FontString") then
				local point, parent, relpoint, x, y = reg:GetPoint(1)
				if (point == "BOTTOM" and relpoint == "TOP") then
					b.text = reg
				elseif (point == "TOPLEFT" and relpoint == "BOTTOMLEFT") then
					b.leftText = reg
				elseif (point == "TOPRIGHT" and relpoint == "BOTTOMRIGHT") then
					b.rightText = reg
				end
			end
		end

		b.text:SetTextColor(1, 0.82, 0)

		b.midText = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		b.midText:SetPoint("TOPLEFT", b.leftText, "TOPRIGHT")
		b.midText:SetPoint("BOTTOMRIGHT", b.rightText, "BOTTOMLEFT")
		b.midText:SetTextColor(0.7, 0.7, 0.7)

		b:SetScript("OnEnter", sliderOnEnter)
		b:SetScript("OnLeave", sliderOnLeave)
		b:SetScript("OnValueChanged", sliderOnValueChanged)

		b.text:SetText(text)
		b.leftText:SetText(Min)
		b.rightText:SetText(Max)
		b:SetPoint(...)

		b:SetMinMaxValues(Min, Max)
		b:SetValueStep(step)
		b:SetValue(get(parent))
		
		b.OnValueChanged = set
		b.SetTooltipText = genericSetTooltipText

		return b
	end
end

do
	local function buttonOnEnter(self)
		if (self.tooltip or (self.text and not self.text:IsShown())) then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			if (self:GetText()) then
				GameTooltip:SetText(self:GetText(), 1, 1, 1)
				if (self.tooltip) then
					GameTooltip:AddLine(self.tooltip, nil, nil, nil, 1)
					GameTooltip:Show()
				end
			else
				GameTooltip:SetText(self.tooltip)
			end
		end
	end

	local function buttonOnClick(self, button)
		self.click(self.callparent, button)
	end

	-- Button
	function lib:Button(parent, callparent, text, click, ...)
--[===[@debug@
		assert(type(parent) == "table" and (parent.GetObjectType or parent.GetFrameType))
		assert(type(callparent) == "table" and (callparent.GetObjectType or callparent.GetFrameType))
		assert(type(text) == "string")
		assert(type(click) == "function")
--@end-debug@]===]

		local b = CreateFrame("Button", nil, parent, "OptionsButtonTemplate")
		b.callparent = callparent
		b.click = click
		b.text = b:GetRegions()
		b.text:SetAllPoints(b)			-- Makes the text part (first region) fit all over button, instead of just centered and fuxed when scaled
		b:SetScript("OnClick", buttonOnClick)
		b:SetScript("OnEnter", buttonOnEnter)
		b:SetScript("OnLeave", genericOnLeave)
		b:SetText(text)
		b:SetWidth(max(100, b.text:GetStringWidth() + 25))
		b:SetHeight(26)
		b:SetPoint(...)

		b.SetTooltipText = genericSetTooltipText

		return b
	end

	local function buttonSpecial(parent, callparent, Type, click, ...)
--[===[@debug@
		assert(type(parent) == "table" and (parent.GetObjectType or parent.GetFrameType))
		assert(type(callparent) == "table" and (callparent.GetObjectType or callparent.GetFrameType))
		assert(type(click) == "function")
--@end-debug@]===]

		local b = CreateFrame("Button", nil, parent)
		b.callparent = callparent
		b:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-"..Type.."Page-Up")
		b:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-"..Type.."Page-Down")
		b:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-"..Type.."Page-Disabled")
		b:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
		b:SetWidth(32)
		b:SetHeight(32)
		b:SetPoint(...)
		b:SetScript("OnClick", buttonOnClick)
		b:SetScript("OnEnter", buttonOnEnter)
		b:SetScript("OnLeave", genericOnLeave)
		b.tooltip = Type == "Prev" and PREVIOUS or Type == "Next" and NEXT or nil
		b.click = click

		b.SetTooltipText = genericSetTooltipText

		return b
	end

	function lib:ButtonPrev(parent, callparent, click, ...)
		return buttonSpecial(parent, callparent, "Prev", click, ...)
	end

	function lib:ButtonNext(parent, callparent, click, ...)
		return buttonSpecial(parent, callparent, "Next", click, ...)
	end

	-- checkboxOnClick
	local function checkboxOnClick(self)
		self.set(self.callparent, self:GetChecked())
	end

	-- checkboxOnShow
	local function checkboxOnShow(self)
		self:SetChecked(self.get(self.callparent, self))
	end

	local function checkboxOnEnter(self)
		self.text:SetTextColor(1, 1, 1)
		if (self.tooltip or not self.text:IsShown()) then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetText(self.text:GetText(), 1, 1, 1)
			if (self.tooltip) then
				GameTooltip:AddLine(self.tooltip, nil, nil, nil, 1)
				GameTooltip:Show()
			end
		end
	end

	local function checkboxOnLeave(self)
		self.text:SetTextColor(1, 0.82, 0)
		GameTooltip:Hide()
	end

	local function checkboxSetEnabled(self, enabled)
		if (enabled) then
			self:Enable()
			self.text:SetTextColor(1, 0.82, 0)
		else
			self:Disable()
			self.text:SetTextColor(0.5, 0.5, 0.5)
		end
	end

	-- CheckBox
	function lib:CheckBox(parent, callparent, text, get, set, ...)
--[===[@debug@
		assert(type(parent) == "table" and (parent.GetObjectType or parent.GetFrameType))
		assert(type(callparent) == "table" and (callparent.GetObjectType or callparent.GetFrameType))
		assert(type(text) == "string")
		assert(type(get) == "function")
		assert(type(set) == "function")
--@end-debug@]===]

		local b = CreateFrame("CheckButton", nil, parent, "OptionsCheckButtonTemplate")
		b.callparent = callparent
		local temp = new(b:GetRegions())
		for i,reg in ipairs(temp) do
			if (reg:GetObjectType() == "FontString") then
				b.text = reg
				break
			elseif (reg:GetObjectType() == "Texture") then
				if (reg:GetTexture() == "Interface\\Buttons\\UI-CheckBox-Up") then
					b.texCheckBoxUp = reg
				elseif (reg:GetTexture() == "Interface\\Buttons\\UI-CheckBox-Down") then
					b.texCheckBoxDown = reg
				elseif (reg:GetTexture() == "Interface\\Buttons\\UI-CheckBox-Highlight") then
					b.texCheckBoxHighlight = reg
				elseif (reg:GetTexture() == "Interface\\Buttons\\UI-CheckBox-Check") then
					b.texCheckBoxCheck = reg
				end
			end
		end
		assert(b.text)
		b:SetScript("OnClick", checkboxOnClick)
		b:SetScript("OnShow", checkboxOnShow)
		b:SetScript("OnEnter", checkboxOnEnter)
		b:SetScript("OnLeave", checkboxOnLeave)
		b.SetEnabled = checkboxSetEnabled

		b.set = set
		b.get = get
		b.text:SetText(text)
		b:SetHeight(26)
		b:SetWidth(26)
		b:SetPoint(...)
		b:SetHitRectInsets(0, -(b.text:GetStringWidth() + 5), 0, 0)

		b.SetTooltipText = genericSetTooltipText
		return b
	end
end

do
	-- editbox.OnEnterPressed
	local function editboxOnEnterPressed(self)
		self.set(self.callparent, self:GetText())
	end

	-- editbox.OnEscapePressed
	local function editboxOnEscapePressed(self)
		self:ClearFocus()
	end

	-- checkboxOnShow
	local function editboxOnShow(self)
		if (self.get) then
			self:SetText(self.get(self.callparent, self))
		end
	end

	-- CheckBox
	function lib:EditBox(parent, callparent, border, text, get, set, ...)
--[===[@debug@
		assert(type(parent) == "table" and (parent.GetObjectType or parent.GetFrameType))
		assert(type(callparent) == "table" and (callparent.GetObjectType or callparent.GetFrameType))
		assert(text == nil or type(text) == "string")
		assert(type(set) == "function")
--@end-debug@]===]

		local e = CreateFrame("EditBox", nil, parent)
		e.callparent = callparent
		e:SetAutoFocus(nil)
		e:SetFontObject(GameFontNormal)

		if (border) then
			e.leftTex = e:CreateTexture(nil, "BORDER")
			e.leftTex:SetTexture("Interface\\Common\\Common-Input-Border")
			e.leftTex:SetTexCoord(0, 0.0625, 0, 0.625)
			e.leftTex:SetWidth(8)
			e.leftTex:SetHeight(20)
			e.leftTex:SetPoint("LEFT", -5, 0)

			e.rightTex = e:CreateTexture(nil, "BORDER")
			e.rightTex:SetTexture("Interface\\Common\\Common-Input-Border")
			e.rightTex:SetTexCoord(0.9375, 1, 0, 0.625)
			e.rightTex:SetWidth(8)
			e.rightTex:SetHeight(20)
			e.rightTex:SetPoint("RIGHT", -10, 0)

			e.midTex = e:CreateTexture(nil, "BORDER")
			e.midTex:SetTexture("Interface\\Common\\Common-Input-Border")
			e.midTex:SetTexCoord(0.0625, 0.9375, 0, 0.625)
			e.midTex:SetPoint("TOPLEFT", e.leftTex, "TOPRIGHT")
			e.midTex:SetPoint("BOTTOMRIGHT", e.rightTex, "BOTTOMLEFT")
		end

		e:SetScript("OnEnterPressed", editboxOnEnterPressed)
		e:SetScript("OnEscapePressed", editboxOnEscapePressed)
		e:SetScript("OnShow", editboxOnShow)

		if (text) then
			e.label = e:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
			e.label:SetPoint("RIGHT", e, "LEFT", -10, 0)
			e.label:SetText(text)
			e:SetHitRectInsets(-(e.label:GetStringWidth() + 15), 0, 0, 0)
		end

		e.set = set
		e.get = get
		e:SetWidth(150)
		e:SetHeight(26)
		e:SetPoint(...)

		e.SetTooltipText = genericSetTooltipText
	end
end

do
	-- frame.ArrangeTextures
	local function frameArrangeTextures(self)
		local h, w = self:GetHeight(), self:GetWidth()
		local rows = max(2, ceil(h / 256))
		local cols = max(2, ceil(w / 256))

		if (self.backgroundTextures) then
			for i,row in ipairs(self.backgroundTextures) do
				for j,tex in ipairs(row) do
					tex:Hide()
				end
			end
		else
			self.backgroundTextures = {}
		end

		local shrinkW = w < 512 and w / 2
		local shrinkH = h < 512 and h / 2
		local prevRow, prev

		for row = 1,rows do
			local rowTextures = self.backgroundTextures[row]
			if (not rowTextures) then
				rowTextures = {}
				self.backgroundTextures[row] = rowTextures
			end

			for col = 1,cols do
				local tex = rowTextures[col]
				if (not tex) then
					tex = self:CreateTexture(nil, "BACKGROUND")
					rowTextures[col] = tex
				end
				tex:ClearAllPoints()
				tex:Show()

				if (col == 1 and row == 1) then
					tex:SetTexture(resources["LibZekFrames-TopLeft"])
					tex:SetWidth(shrinkW or 256)
					tex:SetHeight(shrinkH or 256)
					tex:SetTexCoord(0, (shrinkW or 256) / 256, 0, (shrinkH or 256) / 256)
					tex:SetPoint("TOPLEFT")

				elseif (row == 1 and col < cols) then
					tex:SetTexture(resources["LibZekFrames-Top"])
					if (col == cols - 1) then
						local sw = w % 256
						tex:SetWidth(sw)
						tex:SetTexCoord(0, sw / 256, 0, (shrinkH or 256) / 256)
					else
						tex:SetWidth(256)
						tex:SetTexCoord(0, 1, 0, (shrinkH or 256) / 256)
					end
					tex:SetPoint("TOPLEFT", prev, "TOPRIGHT")
					tex:SetHeight(shrinkH or 256)
					
				elseif (row == 1 and col == cols) then
					tex:SetTexture(resources["LibZekFrames-TopRight"])
					tex:SetWidth(shrinkW or 256)
					tex:SetHeight(shrinkH or 256)
					tex:SetTexCoord(1 - (shrinkW or 256) / 256, 1, 0, (shrinkH or 256) / 256)
					tex:SetPoint("TOPRIGHT")

				elseif (row == rows and col == 1) then
					tex:SetTexture(resources["LibZekFrames-BottomLeft"])
					tex:SetWidth(shrinkW or 256)
					tex:SetHeight(shrinkH or 256)
					tex:SetTexCoord(0, (shrinkW or 256) / 256, 1 - (shrinkH or 256) / 256, 1)
					tex:SetPoint("BOTTOMLEFT")

				elseif (row == rows and col < cols) then
					tex:SetTexture(resources["LibZekFrames-Bottom"])
					if (col == cols - 1) then
						local sw = w % 256
						tex:SetWidth(sw)
						tex:SetTexCoord(0, sw / 256, 1 - (shrinkH or 256) / 256, 1)
					else
						tex:SetWidth(256)
						tex:SetTexCoord(0, 1, 1 - (shrinkH or 256) / 256, 1)
					end
					tex:SetPoint("BOTTOMLEFT", prev, "BOTTOMRIGHT")
					tex:SetHeight(shrinkH or 256)

				elseif (row == rows and col == cols) then
					tex:SetTexture(resources["LibZekFrames-BottomRight"])
					tex:SetWidth(shrinkW or 256)
					tex:SetHeight(shrinkH or 256)
					tex:SetPoint("BOTTOMRIGHT")
					tex:SetTexCoord(1 - (shrinkW or 256) / 256, 1, 1 - (shrinkH or 256) / 256, 1)

				elseif (row > 1 and row < rows) then
					if (col == 1) then
						tex:SetTexture(resources["LibZekFrames-BottomLeft"])
						tex:SetTexCoord(0, 1, 0, 0.8)
						if (row == rows - 1) then
							local sh = h % 256
							tex:SetHeight(sh)
							tex:SetTexCoord(0, (shrinkW or 256) / 256, 0, 0.8 / 256 * sh)
						else
							tex:SetHeight(256)
							tex:SetTexCoord(0, (shrinkW or 256) / 256, 0, 0.8)
						end
						tex:SetWidth(shrinkW or 256)
						tex:SetPoint("TOPLEFT", prevRow, "BOTTOMLEFT")

					elseif (col == cols) then
						tex:SetTexture(resources["LibZekFrames-BottomRight"])
						tex:SetTexCoord(0, 1, 0, 0.8)
						if (row == rows - 1) then
							local sh = h % 256
							tex:SetHeight(sh)
							tex:SetTexCoord(1 - (shrinkW or 256) / 256, 1, 0, 0.8 / 256 * sh)
						else
							tex:SetHeight(256)
							tex:SetTexCoord(1 - (shrinkW or 256) / 256, 1, 0, 0.8)
						end
						tex:SetWidth(shrinkW or 256)
						tex:SetPoint("TOPLEFT", prev, "TOPRIGHT")

					elseif (col < cols) then
						tex:SetTexture(resources["LibZekFrames-BottomRight"])
						local sw = w % 256
						local sh = h % 256
						local height, width = 256, 256
						local tch = 0.8
						local tcw = 0.8

						if (row == rows - 1) then
							height = sh
							tch = 0.8 / 256 * sh
						end
						if (col == cols - 1) then
							width = sw
							tcw = 0.8 / 256 * sw
						end

						tex:SetWidth(width)
						tex:SetHeight(height)
						tex:SetTexCoord(0, tcw, 0, tch)
						tex:SetPoint("TOPLEFT", prev, "TOPRIGHT")
					end

				end

				if (col == 1) then
					prevRow = tex
				end
				prev = tex
			end
		end
	end

	-- frame.OnSizeChanged
	local function frameOnSizeChanged(self, x, y)
		self:ArrangeTextures()
		self:CheckStatusBar()
	end

	-- frame.CheckStatusBar
	local function frameCheckStatusBar(self)
		local list = new(self.statusbar:GetChildren())
		local maxRight = self.statusbar:GetRight()

		for i,child in ipairs(list) do
			if (child.text) then
				if (child.text:GetRight() > maxRight + 2) then
					child.text:Hide()
				else
					child.text:Show()
				end
			end
			if (child:GetRight() > maxRight) then
				child:Hide()
			else
				child:Show()
			end
		end

		del(list)
	end

	-- statusbar.Refresh
	local function statusbarRefresh(self)
		local list = new(self:GetChildren())
		for i,child in ipairs(list) do
			child:Hide()
			child:Show()
		end
		del(list)
	end

	-- ApplyBackground
	function lib:ApplyBackground(frame, cornerIcon)
		frame.bg = {}

		frame:SetMinResize(470, 260)
		frame:SetHitRectInsets(8, 8, 10, 9)

		frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		frame.title:SetPoint("TOPLEFT", 10, -15)
		frame.title:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -10, -35)

		frame.bg.corner = frame:CreateTexture(nil, "OVERLAY")
		if (cornerIcon) then
			frame.bg.corner:SetTexture(cornerIcon)
		else
			SetPortraitTexture(frame.bg.corner, "player")
		end
		frame.bg.corner:SetWidth(59)
		frame.bg.corner:SetHeight(59)
		frame.bg.corner:SetPoint("TOPLEFT", 9, -6)

		frame.statusbar = CreateFrame("Frame", nil, frame)
		frame.statusbar:SetPoint("BOTTOMLEFT", 15, 15)
		frame.statusbar:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", -15, 41)
		frame.statusbar.Refresh = statusbarRefresh

		frame:SetScript("OnSizeChanged", frameOnSizeChanged)
		frame.ArrangeTextures = frameArrangeTextures
		frame.CheckStatusBar = frameCheckStatusBar

		frame.closeButton = self:CloseButton(frame)
	end
end

-- GenericSuffixName
function lib:GenericSuffixName(frame, suffix)
	local name, prefix
	if (frame:GetName()) then
		prefix = frame:GetName()
	else
		prefix = MAJOR:gsub("[^%a%d]", "_")
	end
	if (not self.suffix) then
		self.suffix = {}
	end
	self.suffix[suffix] = (self.suffix[suffix] or 0) + 1
	return format("%s%s%d", prefix, suffix, self.suffix[suffix])
end

do
	local function onHide(self)
		self:GetParent():Hide()
	end
	function lib:CloseButton(frame)
		local name = self:GenericSuffixName(frame, "CloseButton")
		local b = CreateFrame("Button", name, frame, "UIPanelCloseButton")
		b:SetScript("OnClick", onHide)
		b:SetPoint("TOPRIGHT", -3, -8)
		return b
	end
end

do
	local pluses = {}
	-- plus.OnClick
	local function plusOnClick(self, button)
		local entry = self:GetParent()
		entry.OnPlusClick(entry:GetParent(), entry, button)
	end

	-- plus.SetPlus
	local function plusSetPlus(self)
		self:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-UP")
		self:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-DOWN")
	end

	-- plus.SetMinus
	local function plusSetMinus(self)
		self:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-UP")
		self:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-DOWN")
	end

	-- CreatePlusButton
	local function CreatePlusButton()
		local b = CreateFrame("Button")
		b:SetWidth(16)
		b:SetHeight(16)
		b:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
		b.SetPlus = plusSetPlus
		b.SetMinus = plusSetMinus
		b:SetPlus()
		b:SetScript("OnClick", plusOnClick)
		return b
	end

	-- ReleasePlusButton
	function lib:ReleasePlusButton(b)
		if (b) then
			local p = b:GetParent()
			if (p) then
				p.plus = nil
				b:SetParent(nil)
			end
			b:Hide()
			b:ClearAllPoints()
			tinsert(pluses, b)
		end
	end

	-- AquirePlusButton
	function lib:AquirePlusButton(parent)
		local b = tremove(pluses) or CreatePlusButton()
		b:SetParent(parent)
		b:SetPoint("RIGHT")
		b:Show()
		parent.plus = b
		return b
	end
end

do
	-- listentry.OnClick
	local function entryOnClick(self)
		local p = self:GetParent()
		if (p.selectable) then
			local current = self:GetID() + p.offset
			local oldFocus = p.focus
			p.focus = current

			if (not p.multiselect or not IsModifierKeyDown()) then
				p:WipeSelection()
			end

			if (p.multiselect and IsControlKeyDown()) then
				p:SelectKey(self.key, p.selected[self.key])

			elseif (p.multiselect and IsShiftKeyDown()) then
				for i = oldFocus,current,(oldFocus < current and 1 or -1) do
					local line = rawget(p.lines, i - p.offset)
					if (line) then
						line:LockHighlight()
						if (p.multiselect) then
							if (i == p.focus) then
								line.text:SetTextColor(1, 1, 1)
							else
								line.text:SetTextColor(1, 0.82, 0)
							end
						end
					end
					local itemI = p.items[i]
					if (itemI) then
						p:SelectKey(itemI[2])
					end
				end
			else
				p:SelectKey(self.key)
			end

			if (p.selected[self.key]) then
				self:LockHighlight()
				if (p.multiselect) then
					self.text:SetTextColor(1, 1, 1)
				end
			else
				self:UnlockHighlight()
				if (p.multiselect) then
					self.text:SetTextColor(1, 1, 1)
				end
			end
		end
		p:DoOnClick(self)
	end

	-- listentry.OnDoubleClick
	local function entryOnDoubleClick(self)
		local p = self:GetParent()
		if (p.OnDoubleClick) then
			p:OnDoubleClick(unpack(p.items[self.index], 2))
		end
	end

	-- list.DoOnSelectMultiple
	local function listDoOnSelectMultiple(self)
		if (self.OnSelectMultiple) then
			if (self.multiselect) then
				local temp = new()
				for key in pairs(self.selected) do
					tinsert(temp, key)
				end
				self:OnSelectMultiple(unpack(temp))
				del(temp)
			end
		end
	end

	-- list.DoOnClick
	local function listDoOnClick(self, from)
		if (self.multiselect and self.OnSelectMultiple) then
			self:DoOnSelectMultiple()
		elseif (self.OnClick) then
			self:OnClick(from.key)		--unpack(self.items[from.index], 2))
		end
	end

	-- list.KeyExists
	local function listKeyExists(self, key)
		if (key and self.items) then
			local items = self.items.real or self.items
			local extras = 0
			for i,item in ipairs(items) do
				if (key == item[2]) then
					return i + extras, item
				end
				if (item.children) then
					for j,child in ipairs(item.children) do
						if (key == child[2]) then
							return i + extras + j, child
						end
					end
					extras = extras + #item.children
				end
			end
		end
	end

	-- list.Click
	local function listClick(self, ...)
		if (... == 1) then
			local line = rawget(self.lines, 1)
			if (line) then
				self:Select(line.key)
				self:DoOnClick(line)
			end
			return
		end

		self:Select(...)
		for i = 1,#self.lines do
			local line = rawget(self.lines, i)
			if (line and line.key == ...) then
				self:DoOnClick(line)
				return
			end
		end
	end

	-- SelectKey
	local function listSelectKey(self, key, disabled)
		local absIndex, item = self:KeyExists(key)
		if (absIndex) then
			self.selected[key] = not disabled and true or nil
			assert(item)
			if (item.children and not item.expanded) then
				for i,entry in ipairs(item.children) do
					self.selected[entry[2]] = not disabled and true or nil
				end
			end
		end
	end

	-- list.Select
	local function listSelect(self, ...)
		if (self.selectable) then
			if (not self.selected) then
				self.selected = new()
			else
				wipe(self.selected)
			end
			if (...) then
				local count = select("#", ...) 
				if (count > 0) then
					for i = 1,count do
						local key = select(i, ...)
						self:SelectKey(key)
					end
				end
				self:PopulateList()
			else
				for i,line in pairs(self.lines) do
					line:UnlockHighlight()
					if (self.multiselect) then
						line.text:SetTextColor(1, 0.82, 0)
					end
				end
			end
		end
	end

	-- list.SetItems
	-- list must be a double depth table of display values and keys
	local function listSetItems(self, list)
--[===[@debug@
		assert(not list or type(list) == "table", "SetItems: list ~= 'table'")
		assert(not list or #list == 0 or type(list[1]) == "table", "SetItems: list[1] ~= 'table'")
--@end-debug@]===]

		self.items = deepDel(self.items)
		self.scroll:SetVerticalScroll(0)
		self.items = list
		self:Select()
		self:GetTotalItems()
		self:PopulateList()
	end

	-- list.Clear
	local function listClear(self)
		if (self.realItems) then
			del(self.realItems)
			self.items = nil
		else
			self.items = del(self.items)
		end
		self.realItems = nil
		self.selected = del(self.selected)
		self:PopulateList()
	end

	-- itemLookupMeta
	itemLookupMeta = {
		__index = function(self, index)
			local total = rawget(self, "total")
			local visible = rawget(self, "visible")
--[===[@debug@
			assert(type(index) == "number", "index ~= 'number'")
			assert(index <= total, format("index(%s) > self.total(%s)", tostring(index), tostring(self.total)))
			assert(index <= visible, format("index(%s) > self.visible(%s)", tostring(index), tostring(self.visible)))
--@end-debug@]===]
			local cur, spare = 1, 0
			for j, item in ipairs(self.real) do
				if (j + spare == index) then
					return item
				end
				if (item.children and item.expanded) then
					for k, item in ipairs(item.children) do
						if (k + j + spare == index) then
							return item
						end
					end
					spare = spare + #item.children
				end
			end
--[===[@debug@
			assert(false, "Fell through bottom")
--@end-debug@]===]
			return self.real[index]
		end
	}

	-- list.GetTotalItems
	local function listGetTotalItems(self)
		if (not self.items) then
			return
		end
		local count = #self.items
		local size = count
		local children
		for i,item in ipairs(self.items) do
			item.child = nil
			if (item.children) then
				item.expanded = nil
				count = count + #item.children
				children = true
				for j,child in ipairs(item.children) do
					child.child = true
				end
			end
		end
		if (children) then
			local realitems = self.items
			self.items = setmetatable({}, itemLookupMeta)
			self.items.real = realitems
		end
		self.items.total = count
		self.items.visible = size
	end

	-- framelist.OnPlusClick
	local function listOnPlusClick(self, entry, button)
		local item = self.items[entry.index]
--[===[@debug@
		assert(item, "missing item")
		assert(item.children, "missing entry.children")
--@end-debug@]===]
		if (item.expanded) then
			item.expanded = nil
			self.items.visible = self.items.visible - #item.children
		else
			item.expanded = true
			self.items.visible = self.items.visible + #item.children
		end
--[===[@debug@
		assert(self.items.visible >= 1, "visible < 1")
		assert(self.items.visible <= self.items.total, "visible > total")
--@end-debug@]===]

		self:PopulateList()
	end

	-- list.PopulateList
	local function listPopulateList(self)
		if (not self.items) then
			for i,line in pairs(self.lines) do
				line:Hide()
			end
			return
		end

		local displayLines = floor(self:GetHeight() / 16)

		for i = 1,displayLines do
			local entryNo = i + self.offset
			if (entryNo > self.items.visible) then
				local b = rawget(self.lines, i)
				if (b) then
					b:Hide()
				end
			else
				local item = self.items[entryNo]
				local b = self.lines[i]
				b:SetText(item[1])
				b:Show()
				b.index = entryNo
				b.key = item[2]

				if (item.children) then
					if (not b.plus) then
						b.plus = lib:AquirePlusButton(b)
					end
					b.OnPlusClick = listOnPlusClick
					if (item.expanded) then
						b.plus:SetMinus()
					else
						b.plus:SetPlus()
					end
				else
					lib:ReleasePlusButton(b.plus)
				end
				b.text:SetPoint("TOPLEFT", item.child and 10 or 0, 0)

				if (self.selected and self.selected[b.key]) then
					b:LockHighlight()
					if (self.multiselect) then
						b.text:SetTextColor(1, 0.82, 0)
					end
				else
					b:UnlockHighlight()
					if (self.multiselect) then
						b.text:SetTextColor(1, 0.82, 0)
					end
				end
			end
		end
		for i = displayLines + 1,#self.lines do
			self.lines[i]:Hide()
		end

		self.scroll:Update(self.items.visible)
	end

	-- list.OnVerticalScroll
	local function listOnVerticalScroll(self, offset)
		self.offset = offset
		self:PopulateList()
	end

	-- list.GetSelected
	local function listGetSelected(self)
		if (self.selectable and self.selected) then
			if (self.multiselect) then
				local temp = new()
				for key in pairs(self.selected) do
					tinsert(temp, key)
				end
				return unpack(temp)
			else
				return next(self.selected)
			end
		end
	end

	-- list.WipeSelection
	local function listWipeSelection(self)
		for i,line in pairs(self.lines) do
			line:UnlockHighlight()
			if (self.multiselect) then
				line.text:SetTextColor(1, 0.82, 0)
			end
		end
		wipe(self.selected)
	end

	-- list.OnUpdateDragging
	local function listOnUpdateDragging(self, elapsed)
		if (self:IsMouseOver()) then
			local dragSelectEnd
			for i = 1,#self.lines do
				local line = rawget(self.lines, i)
				if (line:IsShown() and line:IsMouseOver()) then
					dragSelectEnd = line:GetID() + self.offset
					break
				end
			end

			if (dragSelectEnd) then
				if (not self.shiftDragging) then
					self:WipeSelection()
				end

				for i = self.dragSelectStart,dragSelectEnd,(self.dragSelectStart < dragSelectEnd and 1 or -1) do
					local item = self.items[i]
					local line = rawget(self.lines, i - self.offset)
					if (line) then
						line:LockHighlight()
						if (self.multiselect) then
							if (i == dragSelectEnd) then
								line.text:SetTextColor(1, 1, 1)
							else
								line.text:SetTextColor(1, 0.82, 0)
							end
						end
					end
					self:SelectKey(item[2])
				end
			end

			self.moveDelay = 0.2
		else
			local x, y = GetCursorPosition()
			y = y / self:GetEffectiveScale()

			if (y > self:GetTop() or y < self:GetBottom()) then
				self.moveTimer = (self.moveTimer or 0) + elapsed
				if (self.moveTimer > self.moveDelay) then
					self.moveDelay = max(0.02, self.moveDelay * 0.9)
					self.moveTimer = 0

					if (y > self:GetTop()) then
						if (self.offset > 0) then
							self.scroll:SetOffset(self.offset - 1)
						end
					else
						local displayLines = floor(self:GetHeight() / 16)
						if (self.offset + displayLines < self.items.visible) then
							self.scroll:SetOffset(self.offset + 1)
						end
					end
				end
			else
				self.moveDelay = 0.2
			end
		end
	end

	-- listentry.OnDragStart
	local function entryOnDragStart(self)
		local p = self:GetParent()
		p.dragSelectStart = self:GetID() + p.offset
		p:SetScript("OnUpdate", listOnUpdateDragging)
		p:GetParent().dragging = true
		p.shiftDragging = IsShiftKeyDown()
	end

	-- listentry.OnDragStop
	local function entryOnDragStop(self)
		local p = self:GetParent()
		p:SetScript("OnUpdate", nil)
		self.dragSelectStart = nil
		p:DoOnSelectMultiple(self)
		p:GetParent().dragging = nil
		p.shiftDragging = nil
	end

	-- listentry.OnEnter
	local function entryOnEnter(self)
		local list = self:GetParent()
		if (list.multiselect) then
			self.text:SetTextColor(1, 1, 1)
		end
	end

	-- listentry.OnLeave
	local function entryOnLeave(self)
		local list = self:GetParent()
		if (list.multiselect) then
			self.text:SetTextColor(1, 0.82, 0)
		end
	end

	-- listentry.OnHide
	local function entryOnHide(self)
		self.key = nil
		lib:ReleasePlusButton(self.plus)
	end

	-- list.CreateListEntry
	local function CreateListEntry(parent, index, lines)
		local b = CreateFrame("Button", nil, parent)
		b:SetNormalFontObject(GameFontNormal)
		b:SetHighlightFontObject(GameFontHighlight)
		b:SetDisabledFontObject(GameFontDisable)
		b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
		b:SetText(" ") -- Required for GetFontString to work
		b.text = b:GetFontString()
		b.text:SetAllPoints()
		b.text:SetJustifyH("LEFT")

		b:SetID(index)
		if (index == 1) then
			b:SetPoint("TOPLEFT")
			b:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT", 0, -16)
		else
			b:SetPoint("TOPLEFT", rawget(lines, index - 1), "BOTTOMLEFT")
			b:SetPoint("BOTTOMRIGHT", rawget(lines, index - 1), "BOTTOMRIGHT", 0, -16)
		end
		b:SetScript("OnClick", entryOnClick)
		b:SetScript("OnDoubleClick", entryOnDoubleClick)

		if (parent.multiselect) then
			b:RegisterForDrag("LeftButton")
			b:SetScript("OnDragStart", entryOnDragStart)
			b:SetScript("OnDragStop", entryOnDragStop)
		end
		b:SetScript("OnEnter", entryOnEnter)
		b:SetScript("OnLeave", entryOnLeave)
		b:SetScript("OnHide", entryOnHide)

		return b
	end

	-- CreateListFrame
	function lib:CreateListFrame(parent, selectable, multiselect)
		local name = self:GenericSuffixName(parent, "List")
		local list = CreateFrame("Frame", name, parent)
		list.selectable = selectable
		list.multiselect = multiselect
		list.offset, list.focus = 0, 1
		if (selectable or multiselect) then
			list.selected = {}
		end

		list.lines = setmetatable({}, {
			__index = function(self, index)
				assert(type(index) == "number")
				local b = CreateListEntry(list, index, self)
				self[index] = b
				return b
			end
		})

		list:SetScript("OnSizeChanged", listPopulateList)

		list.scroll				= self:CreateScrollFrame(list)
		list.Select				= listSelect
		list.SelectKey			= listSelectKey
		list.GetSelected		= listGetSelected
		list.DoOnClick			= listDoOnClick
		list.DoOnSelectMultiple	= listDoOnSelectMultiple
		list.KeyExists			= listKeyExists
		list.Click				= listClick
		list.GetTotalItems		= listGetTotalItems
		list.PopulateList		= listPopulateList
		list.SetItems			= listSetItems
		list.OnVerticalScroll	= listOnVerticalScroll
		list.Clear				= listClear
		list.WipeSelection		= listWipeSelection
		list.GetItem			= listGetItem

		return list
	end
end

do
	-- scroll.Update
	local function scrollUpdate(self, total)
		local parent = self:GetParent()
		if (not self.parentWidth) then
			self.parentWidth = parent:GetWidth()
		end

		local visibleLines = floor(self:GetParent():GetHeight() / 16)
		local bars = parent.verticalBar
		local notWhere = parent.where == "LEFT" and "RIGHT" or "LEFT"
		if (FauxScrollFrame_Update(self, total, visibleLines, 16)) then
			parent:SetWidth(self.parentWidth - 23)
			self:Show()
			if (bars) then
				bars:ClearAllPoints()
				bars:SetPoint("TOP"..notWhere, self, "TOP"..bars.where, bars.where == "RIGHT" and 20 or -20, 2)
				bars:SetPoint("BOTTOM"..bars.where, self, "BOTTOM"..bars.where, bars.where == "RIGHT" and 28 or -28, 0)
			end
		else
			parent:SetWidth(self.parentWidth)
			self:Hide()
			if (bars) then
				bars:ClearAllPoints()
				bars:SetPoint("TOP"..notWhere, parent, "TOP"..bars.where, 0, 2)
				bars:SetPoint("BOTTOM"..bars.where, parent, "BOTTOM"..bars.where, bars.where == "RIGHT" and 8 or -8, 0)
			end
		end
	end

	-- onverticalscroll
	local function onverticalscroll(self, offset2)
		local list = self:GetParent()
		if (list.OnVerticalScroll) then
			list.offset = self.offset
			list:OnVerticalScroll(self.offset)
		end
	end

	-- scroll.OnVerticalScroll
	local function scrollOnVerticalScroll(self, offset)
		self.offset = offset
    	FauxScrollFrame_OnVerticalScroll(self, offset, 16, onverticalscroll)
	end

	-- scrollOnSizeChanged
	local function scrollOnSizeChanged(self)
		if (self:GetHeight() < 58) then
			self.tex3:Hide()
		else
			self.tex3:Show()
		end
	end

	-- scroll.SetOffset
	local function scrollSetOffset(self, offset)
		self.scrollbar:SetValue(max(0, offset) * self.scrollbar:GetValueStep())
	end

	-- CreateScrollFrame
	function lib:CreateScrollFrame(frame)
		local name = self:GenericSuffixName(frame, "ScrollBar")
		local scroll = CreateFrame("ScrollFrame", name, frame, "FauxScrollFrameTemplate")
		scroll.scrollbar = _G[name.."ScrollBar"]
		scroll:Hide()
		scroll:SetPoint("TOPRIGHT", 1, 0)
		scroll:SetPoint("BOTTOMLEFT", 0, 2)
		scroll:SetScript("OnVerticalScroll", scrollOnVerticalScroll)
		scroll:SetScript("OnSizeChanged", scrollOnSizeChanged)
		scroll.Update = scrollUpdate

		scroll.tex1 = scroll:CreateTexture(nil, "BORDER")
		scroll.tex1:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
		scroll.tex1:SetWidth(31)
		scroll.tex1:SetHeight(32)
		scroll.tex1:SetPoint("TOPLEFT", scroll, "TOPRIGHT", -2, 3)
		scroll.tex1:SetTexCoord(0, 0.484375, 0, 0.125)

		scroll.tex2 = scroll:CreateTexture(nil, "BORDER")
		scroll.tex2:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
		scroll.tex2:SetWidth(31)
		scroll.tex2:SetHeight(32)
		scroll.tex2:SetPoint("BOTTOMLEFT", scroll, "BOTTOMRIGHT", -2, -2)
		scroll.tex2:SetTexCoord(0.515625, 1, 0.29, 0.4140625)

		scroll.tex3 = scroll:CreateTexture(nil, "BORDER")
		scroll.tex3:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
		scroll.tex3:SetPoint("TOPLEFT", scroll.tex1, "BOTTOMLEFT")
		scroll.tex3:SetPoint("BOTTOMRIGHT", scroll.tex2, "TOPRIGHT")
		scroll.tex3:SetTexCoord(0.515625, 1, 0, 0.29)

		scroll.SetOffset = scrollSetOffset

		return scroll
	end
end

do
	-- OnUpdate
	local function barOnUpdate(self, elapsed)
		local xCursor, yCursor = GetCursorPosition()
		xCursor, yCursor = xCursor / self:GetEffectiveScale(), yCursor / self:GetEffectiveScale()
		local xFrame, yFrame = self:GetCenter()

		local parentFrame = self:GetParent()
		if (self.vertical) then
			xCursor = max(xCursor, parentFrame:GetLeft() + 75)
			xCursor = min(xCursor, parentFrame:GetLeft() + 300)

			if (xCursor < xFrame - 1 or xCursor > xFrame + 1) then
				local point, parent, relpoint, x, y = parentFrame:GetPoint(2)
				x = x - (xFrame - xCursor)
				parentFrame:SetPoint(point, parent, relpoint, x, y)
			end
		else
			if (yCursor < yFrame - 1 or xCursor > yFrame + 1) then
				local point, parent, relpoint, x, y = parentFrame:GetPoint(2)
				y = y - (yFrame - yCursor)
				parentFrame:SetPoint(point, parent, relpoint, x, y)
			end
		end
	end

	-- OnDragStart
	local function barOnDragStart(self)
		self:SetScript("OnUpdate", barOnUpdate)
	end

	-- OnDragStop
	local function barOnDragStop(self)
		self:SetScript("OnUpdate", nil)
	end

	-- CreateVerticalBar
	function lib:CreateVerticalBar(frame, where, draggable)
		assert(where == "LEFT" or where == "RIGHT")
		local bars = CreateFrame("Frame", nil, frame)
		bars.bars = {}
		bars.vertical = true
		bars.where = where
		frame.verticalBar = bars
		local notWhere = where == "LEFT" and "RIGHT" or "LEFT"

		bars:SetPoint("TOP"..notWhere, frame, "TOP"..where, 0, 2)
		bars:SetPoint("BOTTOM"..where, frame, "BOTTOM"..where, where == "RIGHT" and 8 or -8, 0)

		for i = 1,3 do
			local bar = bars:CreateTexture(nil, "OVERLAY")
			bar:SetTexture("Interface\\FriendsFrame\\UI-ChannelFrame-VerticalBar")
			tinsert(bars.bars, bar)

			if (i == 1) then
				bar:SetPoint("TOPLEFT")
				bar:SetWidth(8)
				bar:SetHeight(8)
				bar:SetTexCoord(0, 0.171875, 0, 0.171875)
			elseif (i == 2) then
				bar:SetPoint("BOTTOMLEFT")
				bar:SetWidth(8)
				bar:SetHeight(8)
				bar:SetTexCoord(0.82, 0.98, 0.798, 0.9609375)
			else
				bar:SetPoint("TOPLEFT", bars.bars[1], "BOTTOMLEFT")
				bar:SetPoint("BOTTOMRIGHT", bars.bars[2], "TOPRIGHT")
				bar:SetTexCoord(0.39, 0.6, 0, 1)
			end
		end

		if (draggable) then
			bars.highlight = bars:CreateTexture(nil, "HIGHLIGHT")
			bars.highlight:SetPoint("TOPLEFT", 3, 0)
			bars.highlight:SetPoint("BOTTOMRIGHT", -3, 0)
			bars.highlight:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
			bars.highlight:SetVertexColor(1, 1, 1, 0.5)

			bars:EnableMouse(true)
			bars:RegisterForDrag("LeftButton")
			bars:SetScript("OnDragStart", barOnDragStart)
			bars:SetScript("OnDragStop", barOnDragStop)
		end

		return bars
	end

	-- CreateHorizontalBar
	function lib:CreateHorizontalBar(frame, where, draggable)
		assert(where == "TOP" or where == "BOTTOM")
		local bars = CreateFrame("Frame", nil, frame)
		bars.bars = {}
		bars.horizontal = true
		bars.where = where
		frame.horizontalBar = bars
		local notWhere = where == "TOP" and "BOTTOM" or "TOP"

		bars:SetPoint(notWhere.."LEFT", frame, where.."LEFT", -4, 0)
		bars:SetPoint(where.."RIGHT", frame, where.."RIGHT", 0, where == "TOP" and 8 or -8)

		for i = 1,3 do
			local bar = bars:CreateTexture(nil, "OVERLAY")
			bar:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-HorizontalBar")
			tinsert(bars.bars, bar)

			if (i == 1) then
				bar:SetPoint("TOPLEFT")
				bar:SetWidth(8)
				bar:SetHeight(8)
				bar:SetTexCoord(0, 0.25, 0, 0.25)
			elseif (i == 2) then
				bar:SetPoint("TOPRIGHT")
				bar:SetWidth(8)
				bar:SetHeight(8)
				bar:SetTexCoord(0.09, 0.3, 0.25, 0.5)
			else
				bar:SetPoint("TOPLEFT", bars.bars[1], "TOPRIGHT")
				bar:SetPoint("BOTTOMRIGHT", bars.bars[2], "BOTTOMLEFT")
				bar:SetTexCoord(0.06, 1, 0, 0.25)
			end
		end

		if (draggable) then
			bars.highlight = bars:CreateTexture(nil, "HIGHLIGHT")
			bars.highlight:SetPoint("TOPLEFT", 0, -3)
			bars.highlight:SetPoint("BOTTOMRIGHT", 0, 3)
			bars.highlight:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
			bars.highlight:SetVertexColor(1, 1, 1, 0.5)

			bars:EnableMouse(true)
			bars:RegisterForDrag("LeftButton")
			bars:SetScript("OnDragStart", barOnDragStart)
			bars:SetScript("OnDragStop", barOnDragStop)
		end

		return bars
	end
end
