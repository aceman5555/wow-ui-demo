--[[
	Swatter - An AddOn debugging aid for World of Warcraft.
	Version: 5.0.PRE.3117 (BillyGoat)
	Revision: $Id: Swatter.lua 68 2008-02-12 08:05:07Z mentalpower $
	URL: http://auctioneeraddon.com/dl/Swatter/
	Copyright (C) 2006 Norganna

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
]]

-- Check to see if another debugging aid has been loaded.
for addon, name in pairs({
	['!buggrabber'] = 'BugGrabber',
	['!improvederrorframe'] = 'ImprovedErrorFrame',
}) do
  local enabled = select(4, GetAddOnInfo(addon))
  if enabled then
	  DEFAULT_CHAT_FRAME:AddMessage("|cffffaa11Swatter is not loaded, because you are running "..name.."|r")
	  return
  end
end

Swatter = {
	origHandler = geterrorhandler(),
	origItemRef = SetItemRef,
	nilFrame = {
		GetName = function() return "Global" end
	},
	errorOrder = {},
	HISTORY_SIZE = 50,
}
local origItemRef = Swatter.origItemRef

Swatter.Version="5.0.PRE.3117"
if (Swatter.Version == "<%".."version%>") then
	Swatter.Version = "4.1.DEV"
end
SWATTER_VERSION = Swatter.Version

SwatterData = {
	enabled = true,
	autoshow = true,
	errors = {},
}

function Swatter.ChatMsg(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg)
end

local chat = Swatter.ChatMsg

function Swatter.IsEnabled()
	return SwatterData.enabled
end

-- Test:  /run Swatter.OnError("Test")
function Swatter.OnError(msg, frame, stack, etype, ...)
	if (not SwatterData.enabled) then
		if (not etype) then
			return Swatter.origHandler(msg, frame)
		else
			return UIParent_OnEvent(etype, ...)
		end
	end

	msg = msg or ""
	frame = frame or Swatter.nilFrame
	stack = stack or debugstack(2, 20, 20)

	local context
	if (not frame.Swatter) then frame.Swatter = {} end
	local id = frame.Swatter[msg]

	-- id might still exist if we've done a clear, because we don't cycle through the frames killing frame.Swatter data
	-- So we have to check for both here
	if (not ( id and #(SwatterData.errors) ~= 0)) then
		context = "Anonymous"
		if (frame) then
			context = "Unnamed"
			if (frame:GetName()) then
				context = frame:GetName()
			end
		end
		local ts = date("%Y-%m-%d %H:%M:%S");
		local addons = Swatter.GetAddOns()
		table.insert(SwatterData.errors, {
			context = context,
			timestamp = ts,
			addons = addons,
			message = msg,
			stack = stack,
			count = 0,
		})
		id = table.getn(SwatterData.errors)
		frame.Swatter[msg] = id
	else
		context = SwatterData.errors[id].context
		for pos, errid in ipairs(Swatter.errorOrder) do
			if (errid == id) then
				table.remove(Swatter.errorOrder, pos)
				break
			end
		end
	end
	table.insert(Swatter.errorOrder, id)

	local err = SwatterData.errors[id]
	local count = err.count or 0
	if (count < 1000) then err.count = count + 1 end
	if (count == 0) then
		if (etype == "ADDON_ACTION_BLOCKED") then
			if (not Swatter.blockWarn) then
				chat("|cffffaa11Warning only: Swatter found blocked actions:|r |Hswatter:"..id.."|h|cffff3311["..context.."]|r|h")
				chat("|cffffaa11Note: Swatter will continue to catch blocked actions but this is the last time this session that we'll tell you about it.|r")
				Swatter.blockWarn = true
			end
		elseif (SwatterData.autoshow) then
			Swatter.ErrorUpdate()
			Swatter.Error:Show()
		else
			chat("|cffffaa11Swatter caught error:|r |Hswatter:"..id.."|h|cffff3311["..context.."]|r|h")
		end
	end
end

function Swatter.NamedFrame(name)
	if (not Swatter.named) then Swatter.named = {} end
	if (not Swatter.named[name]) then
		Swatter.named[name] = {
			name = name,
			GetName = function(obj) return obj.name end,
		}
	end
	return Swatter.named[name]
end

function Swatter.GetAddOns()
	local addlist = ""
	for i = 1, GetNumAddOns() do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i)

		local loaded = IsAddOnLoaded(i)
		if (loaded) then
			if not name then name = "Anonymous" end
			name = name:gsub("[^a-zA-Z0-9]+", "")
			local version = GetAddOnMetadata(i, "Version")
			local class = getglobal(name)
			if not class or type(class)~='table' then class = getglobal(name:lower()) end
			if not class or type(class)~='table' then class = getglobal(name:sub(1,1):upper()..name:sub(2):lower()) end
			if not class or type(class)~='table' then class = getglobal(name:upper()) end
			if class and type(class)=='table' then
				if (class.version) then
					version = class.version
				elseif (class.Version) then
					version = class.Version
				elseif (class.VERSION) then
					version = class.VERSION
				end
			end
			local const = getglobal(name:upper().."_VERSION")
			if (const) then version = const end

			if type(version)=='table' then
				if (nLog) then
					nLog.AddMessage("!swatter", "Swatter.lua", N_INFO, "version is a table", name, table.concat(version,":"))
				end
				version = table.concat(version,":")
			end

			if (version) then
				addlist = addlist.."  "..name..", v"..version.."\n"
			else
				addlist = addlist.."  "..name.."\n"
			end
		end
	end
	return addlist
end


-- Error occured in: Global
-- Date: "%m/%d/%y %H:%M:%S"
-- Count: 1
-- Message: [string "bla()"] line 1:
--   attempt to call global 'bla' (a nil value)
-- Debug:
-- [C]: in function `bla'
-- [string "bla()"]:1: in main chunk
-- [C]: in function `RunScript'
-- Interface\FrameXML\ChatFrame.lua:1788: in function `value'
-- Interface\FrameXML\ChatFrame.lua:3008: in function `ChatEdit_ParseText'
-- Interface\FrameXML\ChatFrame.lua:2734: in function `ChatEdit_SendText'
-- Interface\FrameXML\ChatFrame.lua:2756: in function `ChatEdit_OnEnterPressed'
-- [string "ChatFrameEditBox:OnEnterPressed"]:2: in function <[string "ChatFrameEditBox:OnEnterPressed"]:1>

function Swatter.OnEvent(frame, event, ...)
	if (event == "ADDON_LOADED") then
		local addon = ...
		if (addon:lower() == "!swatter") then

			-- Check to see if we still exist
			if (not SwatterData) then
				if (BugGrabber) then
					-- We've been buggrabber-nabbed. Give up.
					DEFAULT_CHAT_FRAME:AddMessage("|cffffaa11Warning: Swatter has been disabled by BugGrabber. If you want to run Swatter instead of BugGrabber/BugSack, disable those two addons in you addon list and re-enable Swatter. Otherwise, enjoy BugGrabber!|r");
				end
				SetItemRef = origItemRef
				return
			end

			-- We need to cleanup our error history
			if (not SwatterData.errors) then SwatterData.errors = {} end
			local ec = table.getn(SwatterData.errors) or 0
			if (ec > Swatter.HISTORY_SIZE) then
				local remove = ec - Swatter.HISTORY_SIZE
				for i=1, remove do
					table.remove(SwatterData.errors, 1)
				end
			end
			for pos, err in ipairs(SwatterData.errors) do
				table.insert(Swatter.errorOrder, pos)
			end
			frame:UnregisterEvent("ADDON_LOADED")
			return
		end
	elseif (event == "ADDON_ACTION_BLOCKED" and SwatterData.warning) then
		local addon, func = ...
		if (InCombatLockdown()) then
			Swatter.OnError(string.format("Note: AddOn %s attempted to call a protected function (%s) during combat lockdown.", addon, func), Swatter.NamedFrame("AddOn: "..addon), debugstack(2, 20, 20), event, ...)
		else
			Swatter.OnError(string.format("Warning: AddOn %s attempted to call a protected function (%s) which may require interaction.", addon, func), Swatter.NamedFrame("AddOn: "..addon), debugstack(2, 20, 20), event, ...)
		end
	elseif (event == "ADDON_ACTION_FORBIDDEN") then
		local addon, func = ...
		Swatter.OnError(string.format("Error: AddOn %s attempted to call a forbidden function (%s) from a tainted execution path.", addon, func), Swatter.NamedFrame("AddOn: "..addon), debugstack(2, 20, 20), event, ...)
	end
end

function Swatter.SetItemRef(...)
	local msg = ...
	local id = select(3, msg:find("^swatter:(%d+)"))
	id = tonumber(id)
	if (id) then
		if (Swatter) then
			for pos, errid in ipairs(Swatter.errorOrder) do
				if (errid == id) then
					Swatter.Error:Show()
					return Swatter.ErrorDisplay(pos)
				end
			end
		end
	else
		if (not Swatter) then
			SetItemRef = origItemRef
			return origItemRef(...)
		end
		return Swatter.origItemRef(...)
	end
end

function Swatter.ErrorShow()
	Swatter.Error.pos = table.getn(Swatter.errorOrder)
	if (Swatter.Error.pos == 0) then
		Swatter.Error.pos = -1
	end
	Swatter.ErrorDisplay()
end

function Swatter.ErrorDisplay(id)
	if id then Swatter.Error.pos = id else id = Swatter.Error.pos end
	Swatter.ErrorUpdate()

	if (id == -1) then
		Swatter.Error.curError = "There are no errors to show."
		Swatter.ErrorUpdate()
		return
	end

	local errid = Swatter.errorOrder[id]
	if (not errid) then
		Swatter.Error.curError = "Unknown error at position "..id
		Swatter.ErrorUpdate()
		return
	end
	local err = SwatterData.errors[errid]
	if (not err) then
		Swatter.Error.curError = "Unknown error at index "..errid
		Swatter.ErrorUpdate()
		return
	end

	local ts = err.timestamp or "Unavailable"
	local addlist = err.addons or "  Unavailable"

	local message = err.message:gsub("(.-):(%d+): ", "%1 line %2:\n   "):gsub("Interface(\\%w+\\)", "..%1"):gsub(": in function `(.-)`", ": %1"):gsub("|", "||"):gsub("{{{", "|cffff8855"):gsub("}}}", "|r")
	local trace = "   "..err.stack:gsub("Interface\\AddOns\\", ""):gsub("Interface(\\%w+\\)", "..%1"):gsub(": in function `(.-)'", ": %1()"):gsub(": in function <(.-)>", ":\n   %1"):gsub(": in main chunk ", ": "):gsub("\n$",""):gsub("\n", "\n   ")
	local count = err.count
	if (count > 999) then count = "\226\136\158" --[[Infinity]] end


	Swatter.Error.curError = "|cffff5533Date:|r "..ts.."\n|cffff5533ID:|r "..id.."\n|cffff5533Error occured in:|r "..(err.context or "Anonymous").."\n|cffff5533Count:|r "..count.."\n|cffff5533Message:|r "..message.."\n|cffff5533Debug:|r\n"..trace.."\n|cffff5533AddOns:|r\n"..addlist.."\n"
	Swatter.Error.selected = false
	Swatter.ErrorUpdate()
	Swatter.Error:Show()
end


function Swatter.ErrorDone()
	Swatter.Error:Hide()
end

function Swatter.ErrorPrev()
	local cur = Swatter.Error.pos or 1
	if (cur > 1) then
		Swatter.ErrorDisplay(cur - 1)
	else
		Swatter.ErrorUpdate()
	end
end

function Swatter.ErrorNext()
	local cur = Swatter.Error.pos or 1
	local max = table.getn(Swatter.errorOrder) or 0
	if (cur < max) then
		Swatter.ErrorDisplay(cur + 1)
	else
		Swatter.ErrorUpdate()
	end
end

function Swatter.UpdateNextPrev()
	local cur = Swatter.Error.pos or 1
	local max = table.getn(Swatter.errorOrder) or 0
	if ((max > cur) and (cur ~= -1)) then Swatter.Error.Next:Enable() else Swatter.Error.Next:Disable() end
	if (cur > 1) then Swatter.Error.Prev:Enable() else Swatter.Error.Prev:Disable() end
end

function Swatter.ErrorUpdate()
	if (not Swatter.Error.curError) then Swatter.Error.curError = "" end
	Swatter.Error.Box:SetText(Swatter.Error.curError)
	Swatter.Error.Scroll:UpdateScrollChildRect()
	Swatter.Error.Box:ClearFocus()
	Swatter.UpdateNextPrev()
end

function Swatter.ErrorClicked()
	if (Swatter.Error.selected) then return end
	Swatter.Error.Box:HighlightText()
	Swatter.Error.selected = true
end

-- Create our error message frame
Swatter.Error = CreateFrame("Frame", "SwatterErrorFrame", UIParent)
Swatter.Error:Hide()
Swatter.Error:SetPoint("CENTER", "UIParent", "CENTER")
Swatter.Error:SetFrameStrata("TOOLTIP")
Swatter.Error:SetHeight(280)
Swatter.Error:SetWidth(500)
Swatter.Error:SetBackdrop({
	bgFile = "Interface/Tooltips/ChatBubble-Background",
	edgeFile = "Interface/Tooltips/ChatBubble-BackDrop",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 32, right = 32, top = 32, bottom = 32 }
})
Swatter.Error:SetBackdropColor(0,0,0, 1)
Swatter.Error:SetScript("OnShow", Swatter.ErrorShow)
Swatter.Error:SetMovable(true)
table.insert(UISpecialFrames, "SwatterErrorFrame")

Swatter.Drag = CreateFrame("Button", nil, Swatter.Error)
Swatter.Drag:SetPoint("TOPLEFT", Swatter.Error, "TOPLEFT", 10,-5)
Swatter.Drag:SetPoint("TOPRIGHT", Swatter.Error, "TOPRIGHT", -10,-5)
Swatter.Drag:SetHeight(8)
Swatter.Drag:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")

Swatter.Drag:SetScript("OnMouseDown", function() Swatter.Error:StartMoving() end)
Swatter.Drag:SetScript("OnMouseUp", function() Swatter.Error:StopMovingOrSizing() end)

Swatter.Error.Done = CreateFrame("Button", "", Swatter.Error, "OptionsButtonTemplate")
Swatter.Error.Done:SetText("Close")
Swatter.Error.Done:SetPoint("BOTTOMRIGHT", Swatter.Error, "BOTTOMRIGHT", -10, 10)
Swatter.Error.Done:SetScript("OnClick", Swatter.ErrorDone)

Swatter.Error.Next = CreateFrame("Button", "", Swatter.Error, "OptionsButtonTemplate")
Swatter.Error.Next:SetText("Next >")
Swatter.Error.Next:SetPoint("BOTTOMRIGHT", Swatter.Error.Done, "BOTTOMLEFT", -5, 0)
Swatter.Error.Next:SetScript("OnClick", Swatter.ErrorNext)

Swatter.Error.Prev = CreateFrame("Button", "", Swatter.Error, "OptionsButtonTemplate")
Swatter.Error.Prev:SetText("< Prev")
Swatter.Error.Prev:SetPoint("BOTTOMRIGHT", Swatter.Error.Next, "BOTTOMLEFT", -5, 0)
Swatter.Error.Prev:SetScript("OnClick", Swatter.ErrorPrev)

Swatter.Error.Mesg = Swatter.Error:CreateFontString("", "OVERLAY", "GameFontNormalSmall")
Swatter.Error.Mesg:SetJustifyH("LEFT")
Swatter.Error.Mesg:SetPoint("TOPRIGHT", Swatter.Error.Prev, "TOPLEFT", -10, 0)
Swatter.Error.Mesg:SetPoint("LEFT", Swatter.Error, "LEFT", 15, 0)
Swatter.Error.Mesg:SetHeight(20)
Swatter.Error.Mesg:SetText("Select All and Copy the above error message to report this bug.")

Swatter.Error.Scroll = CreateFrame("ScrollFrame", "SwatterErrorInputScroll", Swatter.Error, "UIPanelScrollFrameTemplate")
Swatter.Error.Scroll:SetPoint("TOPLEFT", Swatter.Error, "TOPLEFT", 20, -20)
Swatter.Error.Scroll:SetPoint("RIGHT", Swatter.Error, "RIGHT", -30, 0)
Swatter.Error.Scroll:SetPoint("BOTTOM", Swatter.Error.Done, "TOP", 0, 10)

Swatter.Error.Box = CreateFrame("EditBox", "SwatterErrorEditBox", Swatter.Error.Scroll)
Swatter.Error.Box:SetWidth(450)
Swatter.Error.Box:SetHeight(85)
Swatter.Error.Box:SetMultiLine(true)
Swatter.Error.Box:SetAutoFocus(false)
Swatter.Error.Box:SetFontObject(GameFontHighlight)
Swatter.Error.Box:SetScript("OnEscapePressed", Swatter.ErrorDone)
Swatter.Error.Box:SetScript("OnTextChanged", Swatter.ErrorUpdate)
Swatter.Error.Box:SetScript("OnEditFocusGained", Swatter.ErrorClicked)

Swatter.Error.Scroll:SetScrollChild(Swatter.Error.Box)

seterrorhandler(Swatter.OnError)
Swatter.Frame = CreateFrame("Frame")
Swatter.Frame:Show()
Swatter.Frame:SetScript("OnEvent", Swatter.OnEvent)
Swatter.Frame:RegisterEvent("ADDON_LOADED")
Swatter.Frame:RegisterEvent("ADDON_ACTION_FORBIDDEN")
Swatter.Frame:RegisterEvent("ADDON_ACTION_BLOCKED")
SetItemRef = Swatter.SetItemRef

UIParent:UnregisterEvent("ADDON_ACTION_FORBIDDEN")
UIParent:UnregisterEvent("ADDON_ACTION_BLOCKED")

SLASH_SWATTER1 = "/swatter"
SLASH_SWATTER2 = "/swat"
SlashCmdList["SWATTER"] = function(msg)
	if (not msg or msg == "" or msg == "help") then
		chat("Swatter help:")
		chat("  /swat enable    -  Enables swatter")
		chat("  /swat disable   -  Disables swatter")
		chat("  /swat show      -  Shows the last error box again")
		chat("  /swat autoshow  -  Enables swatter autopopup upon error")
		chat("  /swat noauto    -  Swatter will only show an error in chat")
		chat("  /swat warn      -  Enables swatter's blocked warnings")
		chat("  /swat nowarn    -  Disables swatter's blocked warnings")
		chat("  /swat clear     -  Swatter will clear the list of errors")
	elseif (msg == "show") then
		Swatter.Error:Show()
	elseif (msg == "enable") then
		SwatterData.enabled = true
		chat("Swatter will now catch errors")
	elseif (msg == "disable") then
		SwatterData.enabled = false
		chat("Swatter will no longer catch errors")
	elseif (msg == "warn") then
		SwatterData.warning = true
		chat("Swatter will now catch warnings")
	elseif (msg == "nowarn") then
		SwatterData.warning = false
		chat("Swatter will no longer catch warnings")
	elseif (msg == "autoshow") then
		SwatterData.autoshow = true
		chat("Swatter will popup the first time it sees an error")
	elseif (msg == "noauto") then
	   SwatterData.autoshow = false
	   chat("Swatter will print into chat instead of popping up")
	elseif (msg == "clear") then
		Swatter.Error:Hide()
		SwatterData.errors = {}
		Swatter.errorOrder = {}
		--Note: we are not killing the frame.Swatter values - I am hoping that they are transient to the game session and aren't saved anywhere
		--Swatter.ErrorUpdate()
		chat("Swatter errors have been cleared")
	end
end

local function toggle()
	if Swatter.Error:IsVisible() then
		Swatter.Error:Hide()
	else
		Swatter.Error:Show()
	end
end

local sideIcon
if LibStub then
	local SlideBar = LibStub:GetLibrary("SlideBar", true)
	if SlideBar then
		sideIcon = SlideBar.AddButton("Swatter", "Interface\\AddOns\\!Swatter\\Textures\\SwatterIcon", 9000)
		sideIcon:RegisterForClicks("LeftButtonUp","RightButtonUp")
		sideIcon:SetScript("OnClick", toggle)
		sideIcon.tip = {
			"Swatter",
			"Swatter is a bug catcher that performs additional backtracing to allow AddOn authors to easily trace errors when you send them error reports. You may disable this AddOn if you never get bugs, don't care about them, or never report them when you do get them.",
			"{{Click}} to open the report.",
		}
	end
end