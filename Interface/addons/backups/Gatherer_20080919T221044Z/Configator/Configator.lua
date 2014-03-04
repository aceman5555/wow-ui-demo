--[[

	LibConfigator - A library to help you create a gui config

	Revision: $Id: Configator.lua 461 2007-02-04 13:45:40Z norganna $

	License:
		This library is free software; you can redistribute it and/or
		modify it under the terms of the GNU Lesser General Public
		License as published by the Free Software Foundation; either
		version 2.1 of the License, or (at your option) any later version.

		This library is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
		Lesser General Public License for more details.

		You should have received a copy of the GNU Lesser General Public
		License along with this library; if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

-----------------------------------------------------------------------------------

USAGE:

	Call myCfg = Configator.NewConfigator(setterFunc, getterFunc)
	Call tabId = myCfg.AddTab(TabName)
	Call myCfg.AddControl(tabId. controlType, leftPct, ...)
	Wait for callbacks on your getters and setters

	Your setter will be called with (variableName, value) for you to set
	Your getter will be called with (variableName) for your to return the current value

	The AddControl function's ... varies depending on the controlType:
	"Header" == text
	"Subhead" == text
	"Checkbox" == level, setting, text
	"Slider" == level, setting, min, max, step, text
	
	Settings and configuration system.
]]

local version = 1.2

if (Configator) then
	if (not Configator.version) or (version > Configator.version) then
		Configator.version = version
	else
		return
	end
else
	Configator = {
		tmpId = 0,
		version = version,
	}
end

function Configator.NewConfigator(setter, getter, w,h)
	local s = CreateFrame("Frame", "", UIParent)
	s.Done = CreateFrame("Button", "", s, "OptionsButtonTemplate")
	s.setter = setter
	s.getter = getter

	local top = getter("configator.top")
	local left = getter("configator.left")
	if (top and left) then
		s:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", left, top)
	else
		s:SetPoint("CENTER", "UIParent", "CENTER")
	end
	s:Hide()
	s:SetFrameStrata("DIALOG")
	s:SetMovable(true)
	s:SetWidth(w or 800)
	s:SetHeight(h or 450)
	s:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	s:SetBackdropColor(0,0,0, 0.8)

	s.Drag = CreateFrame("Button", "", s)
	s.Drag:SetPoint("TOPLEFT", s, "TOPLEFT", 10,-5)
	s.Drag:SetPoint("TOPRIGHT", s, "TOPRIGHT", -10,-5)
	s.Drag:SetHeight(6)
	--s.Drag:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	s.Drag:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
	s.Drag:SetScript("OnMouseDown", function() s:StartMoving() end)
	s.Drag:SetScript("OnMouseUp", function() s:StopMovingOrSizing() setter("configator.left", s:GetLeft()) setter("configator.top", s:GetTop()) end)

	s.Done:SetPoint("BOTTOMRIGHT", s, "BOTTOMRIGHT", -10, 10)
	s.Done:SetScript("OnClick", function() s:Hide() end)
	s.Done:SetText(DONE)

	s.tabs = {
			pos = 0,
			count = 0,
	}
	s.elements = {}


--	-- This wipes out the entire settings box. Don't call this too often.
--	function s.ClearTabs()
--		for pos, tab in ipairs(s.tabs) do
--			tab[1]:Hide()
--			tab[2]:Hide()
--			for pos, ctrl in ipairs(tab[2].ctrls) do
--				for pos, kid in ipairs(ctrl.kids) do
--					if (kid.destructor) then kid.destructor() end
--					ctrl.kids[pos] = nil
--				end
--				if ctrl.destructor then ctrl.destructor() end
--				tab[2].ctrls[pos] = nil
--			end
--			tab[2].ctrls = nil
--		end
--		s.tabs.pos = 0
--	end
	function s.ZeroFrame()
		local id = 0
		local frame
		frame = CreateFrame("Frame", "", s)
		frame.id = id
		frame:SetPoint("TOPLEFT", s, "TOPLEFT", 10, -10)
		frame:SetPoint("BOTTOMRIGHT", s.Done, "TOPRIGHT", 0, 5)
		frame:SetBackdrop({
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile = true, tileSize = 32, edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
		})
		frame:SetBackdropColor(0,0,0, 0.5)
		frame.contentWidth = 740
		s.tabs[id] = {}
		s.tabs[id][2] = frame
		return id
	end

	function s.AddTab(tabName)
		local button, frame, id
		if s.tabs.pos >= s.tabs.count then
			button = CreateFrame("Button", "", s, "OptionsButtonTemplate")
			frame = CreateFrame("Frame", "", s)
			table.insert(s.tabs, { button, frame })
			id = table.getn(s.tabs)
			s.tabs.count = id
			s.tabs.pos = id
			button.id = id
			frame.id = id
			if (id == 1) then
				button:SetPoint("TOPLEFT", s, "TOPLEFT", 10, -10)
				s.tabs.active = 1
			else
				button:SetPoint("TOPLEFT", s.tabs[id-1][1], "BOTTOMLEFT", 0, 0)
				frame:Hide()
			end
			button:SetWidth(120)
			button:SetScript("OnClick", s.ActivateTab)
			frame:SetPoint("TOPLEFT", s.tabs[1][1], "TOPRIGHT", 0, 0)
			frame:SetPoint("BOTTOMRIGHT", s.Done, "TOPRIGHT", 0, 5)
			frame:SetBackdrop({
				bgFile = "Interface/Tooltips/UI-Tooltip-Background",
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = true, tileSize = 32, edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 4 }
			})
			frame:SetBackdropColor(0,0,0, 0.5)
		else
			id = s.tabs.pos + 1
			s.tabs.pos = id
			button, frame = unpack(s.tabs[id])
			button:Show()
		end
		button:SetText(tabName)
		frame.contentWidth = 620
		return id
	end

	local function anchorPoint(frame, el, last, indent, width, height, yofs)
		local clearance = 0
		if (last and last.clearance) then clearance = last.clearance end

		el:SetPoint("LEFT", frame, "LEFT", indent or 15,0)
		if (width == nil) then
			el:SetPoint("RIGHT", frame, "RIGHT", -5,0)
		elseif (type(width) == "number") then
			el:SetWidth(width)
		end
		if (type(height) == "number") then
			el:SetHeight(height)
		end
		if (last) then
			el:SetPoint("TOP", last, "BOTTOM", 0, -5+(yofs or 0)-clearance)
		else
			el:SetPoint("TOP", frame, "TOP", 0, -5-clearance)
		end
	end

	local function getTmpName()
		Configator.tmpId = Configator.tmpId + 1
		return "ConfigatorAnon"..Configator.tmpId
	end

	function s.Unfocus(obj)
		obj:Hide()
		obj:ClearFocus()
		obj:Show()
	end

	function s.SetControlWidth(width)
		s.scalewidth = width
	end

	function s.AddControl(id, cType, column, ...)
		local frame = s.tabs[id][2]
		if (not frame.ctrls) then
			frame.ctrls = { pos = 0 }
		end
		local cpos = frame.ctrls.pos + 1
		frame.ctrls.pos = cpos
		local ctrl = { kids = {} }
		frame.ctrls[cpos] = ctrl

		local last = frame.ctrls.last
		local control

		local kids = ctrl.kids
		local kpos = 0
		
		local framewidth = frame:GetWidth() - 20
		column = (column or 0) * framewidth
		local colwidth = nil
		if (s.scalewidth) then
			colwidth = math.min(framewidth-column, (s.scalewidth or 1) * framewidth)
		end
		
		local el
		if (cType == "Header") then
			el = frame:CreateFontString("", "OVERLAY", "GameFontNormalHuge")
			kpos = kpos+1 kids[kpos] = el
			anchorPoint(frame, el, last)
			local text = select(1, ...)
			el:SetText(text)
			last = el
		elseif (cType == "Subhead") then
			el = frame:CreateFontString("", "OVERLAY", "GameFontNormalLarge")
			el:SetJustifyH("LEFT")
			kpos = kpos+1 kids[kpos] = el
			anchorPoint(frame, el, last, column+15, colwidth, nil, -10)
			local text = select(1, ...)
			el:SetText(text)
			last = el
		elseif (cType == "Note") then
			local level, width, height, text = select(1, ...)
			local indent = 10 * (level or 1)
			el = frame:CreateFontString("", "OVERLAY", "GameFontHighlight")
			el:SetJustifyH("LEFT")
			el:SetJustifyV("TOP")
			kpos = kpos+1 kids[kpos] = el
			anchorPoint(frame, el, last, column+indent+15, width, height, nil)
			el:SetText(text)
			control = el
			last = el
		elseif (cType == "Label") then
			local level, setting, text = select(1, ...)
			local indent = 10 * (level or 1)
			el = frame:CreateFontString("", "OVERLAY", "GameFontHighlight")
			el:SetJustifyH("LEFT")
			kpos = kpos+1 kids[kpos] = el
			anchorPoint(frame, el, last, column+indent+15, colwidth)
			el:SetText(text)
			if (setting) then
				el.hit = CreateFrame("Button", "", frame)
				el.hit.parent = el
				el.hit:SetAlpha(0.3)
				el.hit:SetPoint("TOPLEFT", el, "TOPLEFT", -2, 2)
				el.hit:SetPoint("BOTTOMRIGHT", el, "BOTTOMRIGHT", 2, -2)
				--el.hit:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
				el.hit:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
				el.hit.setting = setting
				el.hit.stype = "Button";
				el.hit:SetScript("OnClick", s.ChangeSetting)
				el.hit:Show()
			end
			control = el
			last = el
		elseif (cType == "Custom") then
			local level, el = select(1, ...)
			local indent = 10 * (level or 1)
			kpos = kpos+1 kids[kpos] = el
			anchorPoint(frame, el, last, column+indent+15, colwidth)
			control = el
			last = el
		elseif (cType == "Text") then
			local level, setting, text = select(1, ...)
			local indent = 10 * (level or 1)
			-- FontString
			el = frame:CreateFontString("", "OVERLAY", "GameFontHighlight")
			el:SetJustifyH("LEFT")
			kpos = kpos+1 kids[kpos] = el
			anchorPoint(frame, el, last, 10+column+indent)
			el:SetText(text)
			last = el
			-- Editbox
			el = CreateFrame("EditBox", "", frame, "InputBoxTemplate")
			kpos = kpos+1 kids[kpos] = el
			anchorPoint(frame, el, last, 20+column+indent, colwidth or 160, 32, 4)
			el.setting = setting
			el.stype = "EditBox"
			el:SetAutoFocus(false)
			s.GetSetting(el)
			el:SetScript("OnEditFocusLost", s.ChangeSetting)
			el:SetScript("OnEscapePressed", s.Unfocus)
			el:SetScript("OnEnterPressed", s.Unfocus)
			s.elements[setting] = el
			el.textEl = last

			control = el
			last = el
		elseif (cType == "Selectbox") then
			local level, list, setting, text = select(1, ...)
			local indent = 10 * (level or 1)
			-- Selectbox
			local tmpName = getTmpName()
			el = SelectBox.Create(tmpName, frame, 140, s.ChangeSetting, function () return s.getter(list) end, "Default")
			kpos = kpos+1 kids[kpos] = el
			anchorPoint(frame, el, last, column+indent-5, colwidth or 140, 22, 4)
			el.list = list
			el.setting = setting
			el.stype = "SelectBox";
			el.clearance = 10
			s.elements[setting] = el
			s.GetSetting(el)
			control = el
			last = el

		elseif (cType == "Button") then
			local level, setting, text = select(1, ...)
			local indent = 10 * (level or 1)
			-- Button
			el = CreateFrame("Button", "", frame, "OptionsButtonTemplate")
			kpos = kpos+1 kids[kpos] = el
			anchorPoint(frame, el, last, 10+column+indent, colwidth or 80, 22, 4)
			el.setting = setting
			el.stype = "Button";
			el:SetScript("OnClick", s.ChangeSetting)
			el:SetText(text)
			control = el
			last = el
		elseif (cType == "Checkbox") then
			local level, setting, text = select(1, ...)
			local indent = 10 * (level or 1)
			-- CheckButton
			el = CreateFrame("CheckButton", "", frame, "OptionsCheckButtonTemplate")
			kpos = kpos+1 kids[kpos] = el
			anchorPoint(frame, el, last, 10+column+indent, 22, 22, 4)
			el.setting = setting
			el.stype = "CheckButton"
			s.GetSetting(el)
			el:SetScript("OnClick", s.ChangeSetting)
			s.elements[setting] = el
			control = el
			-- FontString
			el = frame:CreateFontString("", "OVERLAY", "GameFontHighlight")
			el:SetJustifyH("LEFT")
			kpos = kpos+1 kids[kpos] = el
			if (colwidth) then colwidth = colwidth - 15 end
			anchorPoint(frame, el, last, 35+column+indent, colwidth)
			el:SetText(text)
			control.textEl = el
			last = el
		elseif (cType == "Slider") then
			local level, setting, min, max, step, text = select(1, ...)
			local indent = 10 * (level or 1)
			-- FontString
			el = frame:CreateFontString("", "OVERLAY", "GameFontHighlight")
			el:SetJustifyH("LEFT")
			kpos = kpos+1 kids[kpos] = el
			anchorPoint(frame, el, last, 160+column+indent)
			el:SetText(text)
			local textElement = el
			-- Slider
			local tmpName = getTmpName()
			el = CreateFrame("Slider", tmpName, frame, "OptionsSliderTemplate")
			kpos = kpos+1 kids[kpos] = el
			anchorPoint(frame, el, last, 13+column+indent, 140, 20, 4)
			getglobal(tmpName.."Low"):SetText("")
			getglobal(tmpName.."High"):SetText("")
			el.setting = setting
			el.textFmt = text
			el.textEl = textElement
			el.stype = "Slider";
			el:SetMinMaxValues(min, max)
			el:SetValueStep(step)
			s.GetSetting(el)
			el:SetHitRectInsets(0,0,0,0)
			el:SetScript("OnValueChanged", s.ChangeSetting)
			s.elements[setting] = el
			control = el
			last = textElement
		end

		s.SetLast(id, last)
		return control
	end
	function s.GetLast(id)
		if (s.tabs[id] and s.tabs[id][2].ctrls) then
			return s.tabs[id][2].ctrls.last
		end
	end
	function s.SetLast(id, last)
		if (s.tabs[id] and s.tabs[id][2].ctrls) then
			s.tabs[id][2].ctrls.last = last
		end
	end

	function s.ActivateTab(id)
		if (type(id) == "table") then id = this.id end
		if (s.tabs.active) then
			s.tabs[s.tabs.active][2]:Hide()
		end
		s.tabs.active = id
		s.tabs[id][2]:Show()
	end

	function s.Refresh()
		for name, el in pairs(s.elements) do
			s.GetSetting(el)
		end
	end
	function s.Resave()
		for name, el in pairs(s.elements) do
			s.ChangeSetting(el)
		end
	end
	function s.GetSetting(obj)
		local setting = obj.setting
		local value = s.getter(setting)
		if (obj.stype == "CheckButton") then
			obj:SetChecked(value or false)
		elseif (obj.stype == "EditBox") then
			obj:SetText(value or "")
		elseif (obj.stype == "SelectBox") then
			obj.value = value
			obj:UpdateValue()
		elseif (obj.stype == "Button") then
		elseif (obj.stype == "Slider") then
			obj:SetValue(value or 0)
			obj.textEl:SetText(string.format(obj.textFmt, value or 0))
		else
			value = obj:GetValue()
		end
	end
	function s.ChangeSetting(obj, ...)
		if (not obj) then obj = this end
		local setting = obj.setting
		local value
		if (obj.stype == "CheckButton") then
			value = obj:GetChecked()
			if (value) then value = true else value = false end
		elseif (obj.stype == "EditBox") then
			value = obj:GetText() or ""
		elseif (obj.stype == "SelectBox") then
			value = obj.value
		elseif (obj.stype == "Button") then
			value = true
		elseif (obj.stype == "Slider") then
			value = obj:GetValue() or 0
			obj.textEl:SetText(string.format(obj.textFmt, value))
		else
			value = obj:GetValue()
		end
		s.setter(setting, value)
	end

	function s.ColumnCheckboxes(id, cols, options) 
		local last, cont, el, setting, text
		last = s.GetLast(id)
		local optc = table.getn(options)
		local rows = math.ceil(optc / cols)
		local row, col = 0, 0
		cont = nil
		for pos, option in ipairs(options) do
			setting, text = unpack(option)
			col = math.floor(row / rows)
			el = s.AddControl(id, "Checkbox", col/cols, 1, setting, text)
			row = row + 1
			if (row % rows == 0) then
				if (col == 0) then
					cont = el
				end
				s.SetLast(id, last)
			end
		end
		s.SetLast(id, cont)
	end

	return s
end


