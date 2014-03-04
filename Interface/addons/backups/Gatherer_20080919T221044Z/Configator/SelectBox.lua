
if (not SelectBox) then

	SelectBox = {}

	local menu
	local keys = {}
	local values = {}
	local function getItems(box)
		for pos in pairs(keys) do keys[pos] = nil end
		for pos in pairs(values) do values[pos] = nil end

		local curpos
		local current = box.value

		local items
		if type(box.items) == "function" then
			items = box.items()
		else
			items = box.items
		end

		if (not items) then items = {} end

		local key, value
		for pos, item in ipairs(items) do
			if type(item) == "table" then
				key = item[1]
				value = item[2]
			else
				key = item
				value = item
			end
			if (key) then
				table.insert(keys, key)
				table.insert(values, value)
				if (not curpos and type(key)==type(current) and key==current) then
					curpos = table.getn(keys)
				end
			end
		end

		return curpos or 1
	end

	local function setWidth(obj, width)
		local fname = obj:GetName()
		obj:origSetWidth(width + 50)
		getglobal(fname.."Middle"):SetWidth(width)
		getglobal(fname.."Text"):SetWidth(width - 25)
	end

	local function getHeight(obj)
		local minx,miny,width,height = obj:GetBoundsRect()
		return height
	end
	local function getWidth(obj)
		local minx,miny,width,height = obj:GetBoundsRect()
		return width
	end

	local function setValue(obj, value)
		local fname = obj:GetName()
		getglobal(fname.."Text"):SetText(value)
	end

	local function updateValue(frame)
		local pos = getItems(frame)
		frame:SetValue(values[pos])
	end

	function SelectBox.Create(name, parent, width, callback, list, current)
		local frame = CreateFrame("Frame", name, parent, "SelectBoxTemplate")
		if (not width) then width = 100 end
		frame.items = list
		frame.value = current
		frame.onsel = callback
		frame.origSetWidth = frame.SetWidth
		frame.GetHeight = getHeight
		frame.GetWidth = getWidth
		frame.SetWidth = setWidth
		frame.SetValue = setValue
		frame.UpdateValue = updateValue
		frame:SetWidth(width)
		frame:UpdateValue()
		return frame
	end

	function SelectBox.Open(button)
		local box = button:GetParent()
		PlaySound("igMainMenuOptionCheckBoxOn")
		menu:SetWidth(box:GetWidth())
		menu:ClearAllPoints()
		menu:SetPoint("TOPLEFT", box, "TOPLEFT", 0, 0)
		menu.currentBox = box
		menu.cp = nil
		menu.ts = nil
		menu.position = getItems(box)
		SelectBox.DoUpdate()
		SelectBox.DoShow()
	end

	function SelectBox.DoUpdate()
		local key, value, pos, j

		local ts, cp
		if (menu.cp) then
			cp = menu.cp
			ts = menu.ts
		else
			ts = table.getn(keys)
			cp = menu.position
			cp = math.max(1, math.min(cp-7, ts-10))
			menu.cp = cp
			menu.ts = ts
		end

		j = 0
		for i = 1, 10 do
			pos = cp + i - 1
			if (i==1 and pos > 1) then
				j = j + 1
				menu.Buttons[j].index = "prev"
				menu.Buttons[j]:SetText("...")
				menu.Buttons[j]:Show()
			elseif (i == 10 and pos < ts) then
				j = j + 1
				menu.Buttons[j].index = "next"
				menu.Buttons[j]:SetText("...")
				menu.Buttons[j]:Show()
			else
				key = keys[pos]
				value = values[pos]
				if (key) then
					j = j + 1
					menu.Buttons[j].index = pos
					menu.Buttons[j]:SetText(value)
					menu.Buttons[j]:Show()
				end
			end
		end
		for i = j+1, 10 do
			menu.Buttons[i]:SetText("")
			menu.Buttons[i]:Hide()
		end
	end

	function SelectBox.DoShow()
		menu:SetAlpha(0)
		menu:Show()
		UIFrameFadeIn(menu, 0.15, 0, 1)
	end
	function SelectBox.DoHide()
		SelectBox.Menu:Hide()
	end
	function SelectBox.DoFade()
		UIFrameFadeOut(menu, 0.25, 1, 0)
		menu.fadeInfo.finishedFunc = SelectBox.DoHide
	end

	local scrollTime = 0.2
	function SelectBox.MouseIn(object)
		if (object.index == 'prev') then
			menu.scrollTimer = scrollTime
			menu.scrollDir = -1
		elseif (object.index == 'next') then
			menu.scrollTimer = scrollTime
			menu.scrollDir = 1
		else
		end
		menu.outTimer = nil
	end
	function SelectBox.MouseOut(object)
		menu.scrollTimer = nil
		menu.outTimer = 0.5
	end
	function SelectBox.OnUpdate(obj, delay)
		if (not delay) then return end
		if (menu.scrollTimer ~= nil) then
			menu.scrollTimer = menu.scrollTimer - delay
			if menu.scrollTimer <= 0 then
				menu.scrollTimer = menu.scrollTimer + scrollTime
				menu.cp = math.max(1, math.min(menu.ts-9, menu.cp + menu.scrollDir))
				SelectBox.DoUpdate()
			end
		end

		if (not menu.outTimer) then return end
		menu.outTimer = menu.outTimer - delay
		if (menu.outTimer <= 0) then
			menu.outTimer = nil
			SelectBox.DoFade()
		end
	end

	function SelectBox.OnClick(object)
		local pos = object.index
		if (type(pos) == 'string') then return end
		menu.currentBox.value = values[pos]
		menu.currentBox:SetValue(values[pos])
		menu.currentBox:onsel(pos, keys[pos], values[pos])
		SelectBox.DoHide()
	end

	function SelectBox.OnClose(object)
		if (menu.currentBox == object) then
			SelectBox.DoHide()
		end
	end

	SelectBox.Menu = CreateFrame("Frame", "SelectBoxMenu", UIParent)
	SelectBox.Menu:Hide()
	SelectBox.Menu:SetWidth(120)
	SelectBox.Menu:SetHeight(165)
	SelectBox.Menu:EnableMouse(true)
	SelectBox.Menu:SetFrameStrata("TOOLTIP")
	SelectBox.Menu:SetScript("OnEnter", SelectBox.MouseIn)
	SelectBox.Menu:SetScript("OnLeave", SelectBox.MouseOut)
	SelectBox.Menu:SetScript("OnMouseDown", SelectBox.DoHide)
	SelectBox.Menu:SetScript("OnUpdate", SelectBox.OnUpdate)

	SelectBox.Back = CreateFrame("Frame", "", SelectBox.Menu)
	SelectBox.Back:SetPoint("TOPLEFT", SelectBox.Menu, "TOPLEFT", 15, -20)
	SelectBox.Back:SetPoint("BOTTOMRIGHT", SelectBox.Menu, "BOTTOMRIGHT", -15, 10)
	SelectBox.Back:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 32, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	SelectBox.Back:SetBackdropColor(0,0,0, 0.8)
	SelectBox.Menu.Buttons = {}
	for i=1, 10 do
		local l = CreateFrame("Button", "SelectBoxMenuButton"..i, SelectBox.Back)
		SelectBox.Menu.Buttons[i] = l
		if (i == 1) then
			l:SetPoint("TOPLEFT", SelectBox.Back, "TOPLEFT", 0,-5)
		else
			l:SetPoint("TOPLEFT", SelectBox.Menu.Buttons[i-1], "BOTTOMLEFT", 0,0)
		end
		l:SetPoint("RIGHT", SelectBox.Back, "RIGHT", 0,0)
		l:SetTextFontObject(GameFontHighlightSmall)
		l:SetHighlightFontObject(GameFontNormalSmall)
		l:SetHeight(12)
		l:SetText("Line "..i)
		l:SetScript("OnEnter", SelectBox.MouseIn)
		l:SetScript("OnLeave", SelectBox.MouseOut)
		l:SetScript("OnClick", SelectBox.OnClick)
		l:Show()
	end
	
	menu = SelectBox.Menu

end


