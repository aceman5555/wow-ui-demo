local COL_NUM = 3
local COL_W = 110
local COL_H = 30
local COL_SPC_W = 2
local COL_SPC_H = 2
local TXT_R_W = 30
local SB_W = 25
local FRAME_PREFIX = "EpgpCop"
local ED_HEIGHT = 30 -- "magic" inputbox height
local ATTEMPTS_MAX = 10
local currs = { "-EP", "+GP" }


local L = LibStub("AceLocale-3.0"):GetLocale("EpgpCop", true)


local defaults = {
	char = {
		currency = 1,
		amount = 100,
		reason = L["DEFAULT_REASON"],
	}
}


EpgpCop = LibStub("AceAddon-3.0"):NewAddon("EpgpCop", "AceConsole-3.0", "AceTimer-3.0")

local addon = EpgpCop

addon.players = {}
addon.awards = {}
addon.queue = {}
addon.timer = nil
addon.attempts = 0

-- ###### Utils ########

local function ResetEdits()
	local a = UIDropDownMenu_GetSelectedID(addon.mFr.amCB)
	for i=1,2 do ToggleDropDownMenu(1, nil, addon.mFr.amCB) end -- strange magic, otherwise we'll see wrong value from other addons O_o
	UIDropDownMenu_ClearAll(addon.mFr.amCB)
	UIDropDownMenu_SetSelectedID(addon.mFr.amCB, addon.db.char.currency)
	addon.mFr.amEd:SetText(addon.db.char.amount)
	addon.mFr.amReason:SetText(addon.db.char.reason)
end 


local function CurrCbInit(self, level)
	for i=1,2 do
		local info = {}
		local s = currs[i]
		info.text = s
		info.value = s
		info.func = function(self)
			UIDropDownMenu_SetSelectedID(addon.mFr.amCB, self:GetID())
		end
	    UIDropDownMenu_AddButton(info, level)
	end
end

local function UpdateSummary()
	local frm = addon.mFr.summary
	local lst = addon.awards
	local s = ""
	for name, value in pairs(lst) do
		if s ~= "" then s = s .. "\n" end
		s = s .. name
		if value > 1 then s = s .. " x" .. value end
	end
	frm:SetText(s)
end

local function CreateLabelOnTop(frm, text, offset)
	local par = frm:GetParent()
	local txt = par:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	txt:SetTextColor(1,1,1)
	txt:SetText(text)
	if offset == nil then offset = 0 end
	txt:SetPoint("BOTTOMLEFT", frm, "TOPLEFT", offset, 0)
end

local function UpdatePlayerFrame(frm) 
	local uName = frm.PlayerName
	local cl = RAID_CLASS_COLORS[EPGP:GetClass(uName)]
	frm.ltext:SetText(uName)
	frm.ltext:SetTextColor(cl.r, cl.g, cl.b)
	local aw = addon.awards
	local a = aw[frm.PlayerName]

	if a == nil then
		cl = {r=0.2, b=0.2, g=0.2, a=0.6}
	elseif a == 1 then
		cl = {r=0.2, b=0.5, g=0.5, a=1}
	else
		cl = {r=0.5, b=0.2, g=0.5, a=1}
	end
	frm:SetStatusBarColor(cl.r, cl.g, cl.b, cl.a)

	if a==nil then a = "" elseif a==1 then a="" else  a = "x" .. a end

	frm.rtext:SetText(a)
end

local function PlayerFrameClick(self, button)
	local pn = self.PlayerName
	local num = addon.awards[pn]
	if num == nil then num = 0 end
	if button ~= "RightButton" then 
		if IsShiftKeyDown() then num = 5 else num = num + 1 end
	else 
		if IsShiftKeyDown() then num = 0 else num = num - 1 end
	end
	if num < 0 then num = 0 end
	if num == 0 then num = nil end
	addon.awards[pn] = num
	UpdatePlayerFrame(self)
	UpdateSummary()
end

local function CreatePlayerFrames()
	local cont = addon.mFr.pCont
	local list = addon.players
	for i=1+cont:GetNumChildren(), #list do
		local f = CreateFrame("StatusBar", nil, cont)
		f:EnableMouse()
		f:SetScript("OnMouseDown", PlayerFrameClick)
		f:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
		f:GetStatusBarTexture():SetHorizTile(false)
		f:SetOrientation("HORIZONTAL")
		f:SetMinMaxValues(0,100)
		f:SetValue(100)
		f:SetWidth(COL_W)
		f:SetHeight(COL_H)
		f:SetBackdrop({bgFile = "Interface/RAIDFRAME/UI-RaidFrame-GroupBg"});
		local cl = {r=0.7, b=0.7, g=0.7}
		f:SetStatusBarColor(cl.r, cl.g, cl.b, 0.5)
		f:SetBackdropColor(0,0,0,0)
		f.ltext = f:CreateFontString(nil, "OVERLAY", "GameFontNormal");
		f.ltext:SetPoint("LEFT", f, "LEFT", 7, 0);
		f.ltext:SetWidth(COL_W-TXT_R_W-5)
		f.ltext:SetJustifyH("LEFT")
		f.rtext = f:CreateFontString(nil, "OVERLAY", "GameFontNormal");
		f.rtext:SetPoint("RIGHT", f, "RIGHT", -5, 0);
		f.rtext:SetWidth(TXT_R_W)
		f.rtext:SetJustifyH("RIGHT")
	end

 	local children = { cont:GetChildren() }
	local chid = 1
	for _, frm in ipairs(children) do 
		if chid > #list then
			frm.PlayerName = ""
			frm:Hide()
		else
			frm:Show()
			frm.PlayerName = addon.players[chid]
			local x = (chid - 1) % COL_NUM
			local y = math.floor((chid-1)/COL_NUM)
			frm:SetPoint("TOPLEFT", cont, "TOPLEFT", 2 + ((COL_W+COL_SPC_W)*x), - 2 - ((COL_H+COL_SPC_H)*y))
			UpdatePlayerFrame(frm)
		end
		chid = chid + 1
	end
end

local function ClearAll()
	ResetEdits()
	addon.awards = {}
	CreatePlayerFrames()	
	UpdateSummary()
end

local function CreateTitledGroup(parent, text)
	local frm = CreateFrame("Frame", nil, parent)
	frm:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 64, edgeSize = 8,
		insets = { left = 2, right = 1, top = 2, bottom = 2 }
	})
	frm:SetBackdropColor(0,0,0,0)

	local cap = CreateFrame("Frame", nil, frm)
	cap:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 64, edgeSize = 8,
		insets = { left = 2, right = 1, top = 2, bottom = 2 }
	})
	cap:SetBackdropColor(0.2,0.2,0.2,1)
	cap:SetPoint("LEFT", frm, "TOPLEFT", 10, 0)
	local lbl = cap:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	lbl:SetText(text)
	lbl:SetPoint("LEFT", cap, "LEFT", 10, 0)
	lbl:SetTextColor(1,1,1)
	cap:SetWidth(lbl:GetWidth()+20)
	cap:SetHeight(lbl:GetHeight()+8)
	return frm
end

-- ######################


function addon:OnInitialize()
	addon.db = LibStub("AceDB-3.0"):New("EpgpCop_DB", defaults, true)
end

function addon:OnEnable()
	self:CreateObjects()
end

local function Enqueue()
	local mFr = addon.mFr
	local lst = addon.awards
	local base = tonumber(mFr.amEd:GetText())
	for name, value in pairs(lst) do
		table.insert(addon.queue, {
			reason = mFr.amReason:GetText(),
			currency = UIDropDownMenu_GetSelectedID(mFr.amCB),
			player = name,
			amount = value * base,
		})
	end
	if (addon.timer == nil) and ( (#addon.queue) > 0) then
		addon.timer = addon:ScheduleRepeatingTimer("OnQueueTimer", 0.5)
	end
end

function addon:OnQueueTimer(self)
	local list = addon.queue
	if	#list > 0 then
		local rec = list[1]
		if not EPGP:CanIncEPBy("1", 1) then
			if attempts < ATTEMPTS_MAX then
				attempts = attempts + 1
				return
			else
				addon.queue = {}
				addon:Print("ERROR: Cannot modify EPGP")
			end
		else
			if rec.currency == 1 then -- "-EP"
--				addon:Print("EP: " .. rec.player .. ", " .. -rec.amount .. ", " .. rec.reason)
				EPGP:IncEPBy(rec.player, rec.reason, -rec.amount)
			else                      -- "+GP"
--				addon:Print("GP: " .. rec.player .. ", " .. rec.amount .. ", " .. rec.reason)
				EPGP:IncGPBy(rec.player, rec.reason, rec.amount)
			end
			table.remove(list, 1)
		end 
	end
	if #addon.queue == 0 then 
		addon:CancelTimer(addon.timer)
		addon.timer = nil
		addon.attempts = 0
	end
end


function addon:CreateObjects()

-- ##### Main Window #####

	local mFr = CreateFrame("Frame", FRAME_PREFIX .. "MainFrame", UIParent)
	mFr:SetPoint("CENTER",UIParent,"CENTER",0,0)
	mFr:SetWidth(600)
	mFr:SetHeight(500)
	mFr:EnableMouse()
	mFr:SetMovable(true)
	tinsert(UISpecialFrames, FRAME_PREFIX .. "MainFrame");
	mFr:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 64, edgeSize = 8,
		insets = { left = 2, right = 1, top = 2, bottom = 2 }
	})
	mFr:SetBackdropBorderColor(1,1,1,1)
	mFr:SetBackdropColor(0.1,0.1,0.1,0.5)

-- ###### Main Window Caption --

	local mFrCap = CreateFrame("Frame", nil, mFr)
	mFrCap:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 64, edgeSize = 8,
		insets = { left = 2, right = 1, top = 2, bottom = 2 }
	})
	mFrCap:SetBackdropColor(0.3,0.3,0.3,1)
	mFrCap:SetHeight(22)
	mFrCap:EnableMouse()
	mFrCap:SetPoint("LEFT", mFr , "TOPLEFT", 0, 0)
	mFrCap:SetPoint("RIGHT", mFr, "TOPRIGHT", 0, 0)
	mFrCap:SetScript("OnMouseDown", function() mFr:StartMoving() end)
	mFrCap:SetScript("OnMouseUp", function() mFr:StopMovingOrSizing() end)
	local mFrCapCB = CreateFrame("Button", nil, mFrCap, "UIPanelCloseButton")
	mFrCapCB:SetPoint("TOPRIGHT", mFrCap, "TOPRIGHT", 5, 5)
	mFrCapCB:SetToplevel(true)            	
	mFrCapCB:SetScript("OnClick", function() mFr:Hide() end)

	mFrTitle = mFrCap:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	mFrTitle:SetPoint("TOPLEFT", mFrCap)
	mFrTitle:SetPoint("BOTTOMRIGHT", mFrCap)
	mFrTitle:SetJustifyH("CENTER")
	mFrTitle:SetText(L["MAIN_CAPTION"]) 

-- ##### Players container ###### -----

	local plGroup = CreateTitledGroup(mFr, L["TARGETS"])
	plGroup:SetPoint("TOPLEFT", mFr, "TOPLEFT", 20, -40)
	plGroup:SetPoint("BOTTOM", mFr, "BOTTOM", 0, 20)
	plGroup:SetWidth(COL_NUM*(COL_W+COL_SPC_W)+SB_W+10)

	local pScroll = CreateFrame("ScrollFrame", FRAME_PREFIX .. "PScroll",
		plGroup, "UIPanelScrollFrameTemplate")
	pScroll:SetPoint("TOPLEFT", plGroup, "TOPLEFT", 5, -15)
	pScroll:SetPoint("BOTTOMRIGHT", plGroup, "BOTTOMRIGHT", -5-SB_W, 10)
	pCont = CreateFrame("Frame", nil, pScroll)
	pCont:SetWidth(100)
	pCont:SetHeight(100)
	pScroll:SetScrollChild(pCont)
	mFr.pCont = pCont

-- #### Summay container ###

	local sumGroup = CreateTitledGroup(mFr, L["SUMMARIES"])
	sumGroup:SetPoint("TOPLEFT", plGroup, "TOPRIGHT", 10, 0)
	sumGroup:SetWidth(170)
	sumGroup:SetHeight(200)

	local sumScroll = CreateFrame("ScrollFrame", FRAME_PREFIX .. "SScroll",
		sumGroup, "UIPanelScrollFrameTemplate")
	sumScroll:SetPoint("TOPLEFT", sumGroup, "TOPLEFT", 5, -20)
	sumScroll:SetPoint("BOTTOMRIGHT", sumGroup, "BOTTOMRIGHT", -5-SB_W, 10)

	local sumEd = CreateFrame("EditBox", nil, sumScroll)
	sumEd:SetPoint("TOPLEFT")
	sumEd:EnableMouse(false)
	sumEd:SetWidth(sumGroup:GetWidth())
	sumEd:SetHeight(sumGroup:GetHeight())
	sumEd:SetMultiLine(true)
	sumEd:SetAutoFocus(false)
	sumEd:SetFontObject(GameFontHighlight)
	sumEd:SetText("")
	sumScroll:SetScrollChild(sumEd)

	mFr.summary = sumEd

-- #### Base amounts container ######

	local amGroup = CreateTitledGroup(mFr, L["BASES"])
	amGroup:SetPoint("TOPLEFT", sumGroup, "BOTTOMLEFT", 0, -15)
	amGroup:SetWidth(sumGroup:GetWidth())
	amGroup:SetHeight(140)

  	local amEd = CreateFrame("EditBox", FRAME_PREFIX .. "AmEd", mFr, "InputBoxTemplate")
	amEd:SetPoint("TOPLEFT", amGroup, "TOPLEFT", 15, -30)
	amEd:SetWidth(60)
	amEd:SetHeight(ED_HEIGHT)	
	amEd:SetAutoFocus(false)
	amEd:SetScript("OnEscapePressed", function (self) self:ClearFocus() end)
	amEd:SetScript("OnEnterPressed", function (self) self:ClearFocus() end)
	CreateLabelOnTop(amEd, L["AMOUNT"])
	mFr.amEd = amEd
	
	
	local amCB = CreateFrame("Frame", FRAME_PREFIX .. "AmCB",
                               amGroup, "UIDropDownMenuTemplate")
	UIDropDownMenu_Initialize(amCB, CurrCbInit)
	amCB:EnableMouse(true)
	UIDropDownMenu_SetWidth(amCB, 50) 
	-- WTF with coordinates?! workarounded by "magic" offsets
	UIDropDownMenu_JustifyText(amCB, "LEFT")
	amCB:SetPoint("TOPLEFT", amEd, "TOPRIGHT", 0,  0)
	
	CreateLabelOnTop(amCB, L["UNIT"], 20)
	mFr.amCB = amCB

	local amReason = CreateFrame("EditBox", FRAME_PREFIX .. "AmReason", amGroup, "InputBoxTemplate")
	amReason:SetAutoFocus(false)
	amReason:SetPoint("TOPLEFT", amEd, "BOTTOMLEFT", 0, -15)
	amReason:SetWidth(140)
	amReason:SetHeight(ED_HEIGHT)
	CreateLabelOnTop(amReason, L["REASON"])
	amReason:SetScript("OnEscapePressed", function (self) self:ClearFocus() end)
	amReason:SetScript("OnEnterPressed", function (self) self:ClearFocus() end)
	mFr.amReason = amReason

	local amDefault = CreateFrame("Button", nil, amGroup,  "StaticPopupButtonTemplate")
	amDefault:SetPoint("TOPLEFT", amReason, "BOTTOMLEFT", 0, -5)
	amDefault:SetWidth(amReason:GetWidth())
	amDefault:SetText(L["SAVE"])
	amDefault:SetScript("OnClick", function()
		addon:Print(L["SAVED"])
		addon.db.char.currency = UIDropDownMenu_GetSelectedID(mFr.amCB)
		addon.db.char.amount = mFr.amEd:GetText()
		addon.db.char.reason = mFr.amReason:GetText()
	end)

-- ##### Process buttons ##########
		
	local goProcess = CreateFrame("Button", nil, mFr,  "StaticPopupButtonTemplate")
	goProcess:SetPoint("TOPLEFT", amGroup, "BOTTOMLEFT", 0, -5)
	goProcess:SetWidth(amGroup:GetWidth())
	goProcess:SetHeight(50) -- BIG button :)
	goProcess:SetText(L["PROCESS"])
	goProcess:SetScript("OnClick", function()
		Enqueue()
		ClearAll()
	end)
	
	local goReset = CreateFrame("Button", nil, mFr,  "StaticPopupButtonTemplate")
	goReset:SetPoint("TOPLEFT", goProcess, "BOTTOMLEFT", 0, 0)
	goReset:SetWidth(goProcess:GetWidth())
	goReset:SetHeight(30) 
	goReset:SetText(L["RESET"])
	goReset:SetScript("OnClick", function()
		ClearAll()
	end)

-- ######################################

	
	addon.mFr = mFr

	ResetEdits()

	addon:RegisterChatCommand("epcop", "ChatCommand");
end


function addon:ChatCommand(msg)
	local f = addon.mFr
	if f:IsVisible() then f:Hide() else 
		addon.players = {}
		for i=1,EPGP:GetNumMembers() do
			table.insert(addon.players, EPGP:GetMember(i))
		end
		CreatePlayerFrames()
		f:Show() 
	end
end

function addon:OnDisable()
end


