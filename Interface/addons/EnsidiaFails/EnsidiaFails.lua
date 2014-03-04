local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("EnsidiaFails")
local LF = LibStub("AceLocale-3.0"):GetLocale("LibFail-MoP")
EnsidiaFails = CreateFrame("Frame")
local addon = EnsidiaFails
LibStub("AceTimer-3.0"):Embed(addon)
LibStub("AceConsole-3.0"):Embed(addon)
local local_revision = tonumber("328")
local fail = LibStub("LibFail-MoP")
addon.callbacks = addon.callbacks or LibStub("CallbackHandler-1.0"):New(addon)
local callbacks = addon.callbacks

-------------------------------------------------------------------------
-- LOCALES
-------------------------------------------------------------------------

local failEvents = fail:GetSupportedEvents()

-- handles for the ace3 timer
local Versioncheck = nil

local GeneratedFOIZoneBossFailOrder = 1

local announce_to = {
	SAY = L["Say"],
	RAID = L["Raid"],
	GUILD = L["Guild"],
	PARTY = L["Party"],
	OFFICER = L["Officer"],
	CHANNEL = L["Channel"],
	SELF = L["Self"],
}

local announce_style = {
	during = L["during"],
	after = L["after"],
	during_and_after = L["during_and_after"],
}

local announce_after_style = {
	group_by_player = L["Group by player"],
	group_by_fail = L["Group by fails"],
}

local defaults = {
--FAILS that are turned off by default

--GENERAL OPTIONS
	disable_announce_override = false,
	AutoDeleteNewInstance = true,
	DeleteNewInstanceOnly = true,
	ConfirmDeleteInstance = false,
	DeleteJoinRaid = true,
	ConfirmDeleteRaid = false,
	OverkillOnlyOverride = false,
	OverkillOnlyLFR = true,
	stats_value = 10,
	stats_all = false,
	disabled = false,
	announce = "RAID",
	announce_style = "during_and_after",
	announce_after_style = "group_by_fail",
}

-- Set some failEvents related default values
for _, v in ipairs(failEvents) do
	if fail:GetTanksDontFailOption(v) then
		defaults[v.."_TanksDontFail"] = true
	end
	if fail:GetEventConstraints(v) then
		for l, s in pairs(fail:GetEventConstraints(v)) do
			defaults[v..l] = fail.CONSTRAINTS[v][l]
		end
	end
	defaults[v] = true
end

-- local variables --
local wipe_called = false
local LastTime = nil
local whisper, target = nil, nil
local self_party_members_changed = false
local LastInstanceName = ""
local event_fails = {}
local sorttable = {}
local failed_at= {}
local FailsForTheSession = {}

-------------------------------------------------------------------------
-- UTILITY
-------------------------------------------------------------------------

function addon:GetServerChannels(...)
	local t,i = {},1
	while (select(i,...)) do
		t[i] = (select(i,...))
		i = i + 1
	end
	return t
end

function addon:GetChannelListIntoTable(...)
	local t,i = {},1
	while (select(i,...)) do
		if i%2 == 0 then
			t[tonumber((select(i-1,...)))] = (select(i,...))
		else
			t[tonumber((select(i,...)))] = nil
		end
		i = i + 1
	end
	return t
end

function addon:CheckForValidChannel(input)
	if not input or input == "" then return true end
	local serverchannels = addon:GetServerChannels(EnumerateServerChannels())
	local channeltable =  addon:GetChannelListIntoTable(GetChannelList())
	local name = channeltable[GetChannelName(input)]
	for i=1, #serverchannels do
		if serverchannels[i] == name then return true end
	end
	return false
end

function addon:SetChannel(info, input)
	if addon:CheckForValidChannel(input) then return end
	self.db.profile.channelname = (select(2,GetChannelName(input)))
end

function addon:GetChannel(input)
	return self.db.profile.channelname
end

function addon:MenuButtonRemove(info, input)
	if self.db.profile.announce == "CHANNEL" then
		whisper=self.db.profile.channelname
		target=self.db.profile.announce
	else
		target=self.db.profile.announce
	end

	local p = input:match("^%a"):upper()..input:sub(2)
	addon:RemoveFail(p,target,whisper)
end

-------------------------------------------------------------------------
-- INITIALIZATION
-------------------------------------------------------------------------

function addon:Initialize()
	if not EnsidiaFails_FailCount then EnsidiaFails_FailCount = {} end
	if not EnsidiaFails_OFailCount then EnsidiaFails_OFailCount = {} end
end

function addon:InitializeFailOptionValues()
	for _, v in ipairs(failEvents) do
		if fail:GetTanksDontFailOption(v) then
			fail.TANKS_DONT_FAIL_LIST[v] = addon.db.profile[v.."_TanksDontFail"]
		end
		if fail:GetOverkillOnlyOption(v) and addon.db.profile[v.."_OverkillOnly"] ~= nil then
			fail.OVERKILL_ONLY_LIST[v] = addon.db.profile[v.."_OverkillOnly"]
		end
		if fail:GetEventConstraints(v) then
			for l, s in pairs(fail:GetEventConstraints(v)) do
				fail.CONSTRAINTS[v][l] = addon.db.profile[v..l]
			end
		end
	end
	addon:UpdateOverrides()
end

function addon:UpdateOverrides()
  if addon.db.profile.OverkillOnlyOverride then
      fail.OVERKILL_ONLY_LIST.ovkoverride = true
  elseif addon.db.profile.OverkillOnlyLFR and IsInInstance() then
      local instname, insttype, diff, diffname, maxPlayers, playerDifficulty, isDynamicInstance = GetInstanceInfo()
      if maxPlayers == 25 and GetPartyLFGID() then -- according to my little test GetPartyLFGID() only returns not nil if you are in a LFG group
        fail.OVERKILL_ONLY_LIST.ovkoverride = true
      else
        fail.OVERKILL_ONLY_LIST.ovkoverride = false
      end
  else
      fail.OVERKILL_ONLY_LIST.ovkoverride = false
  end
  -- print("ovkoverride="..(fail.OVERKILL_ONLY_LIST.ovkoverride and "true" or "false"))
end

function addon:OpenMenu(input)
	if input == "" then InterfaceOptionsFrame_OpenToCategory("EnsidiaFails")
	elseif input == "wipe" then
		addon:Wipe()
	elseif input=="reset" then
		addon:reset()
	elseif input=="oreset" then
		addon:oreset()
	elseif input:sub(0,6) == "remove" then
		if self.db.profile.announce == "CHANNEL" then
			whisper=self.db.profile.channelname
			target=self.db.profile.announce
		else
			target=self.db.profile.announce
		end
		if input:len() > 6 then
			local name = input:sub(8)
			local p = name:match("^%a"):upper()..name:sub(2)
			addon:RemoveFail(p,target,whisper)
		end
	elseif input=="stats" then
		addon:Stats(addon.db.profile.announce,"stats",addon.db.profile.channelname)
	elseif input=="ostats" then
		addon:Stats(addon.db.profile.announce,"ostats",addon.db.profile.channelname)
	end
end

-------------------------------------------------------------------------
-- EVENT HANDLING
-------------------------------------------------------------------------

local function onFail(failName, playerName, failType, ...)
	if wipe_called then return end

	local eventName = fail:GetEventFancyName(failName) or ""

	if not addon.db.profile[failName] then return end

	callbacks:Fire(failName, playerName, failType)
	addon:AddFail(playerName,failType,eventName, ...)
end

addon:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local name = ...
		if name:lower() ~= "ensidiafails" then return end

		for _, event in ipairs(failEvents) do
			fail:RegisterCallback(event, onFail)
		end

		if not tonumber(local_revision) then local_revision = 999 end

		addon:ScheduleTimer(addon.InitPartyBasedDeletion, 2)

		addon:Initialize()

		self.db = LibStub("AceDB-3.0"):New("EnsidiaFailsDB", { profile = defaults, },  "Default")

		local args = {
			type = "group",
			handler = self,
			get = function(info) return self.db.profile[info[1]] end,
			set = function(info, v) self.db.profile[info[1]] = v; addon:UpdateOverrides() end,
			args = {
				desc = {
					type = "description",
					name = L["addon_desc"],
					order = 1,
					fontSize = "medium",
				},
				reset_header = {
					type = "header",
					name = L["reset"],
					order = 70,
				},
				reset = {
					order = 80,
					type = "execute",
					name = L["reset"],
					desc = L["reset_desc"],
					func = function()
						addon:reset()
					end
				},
				oreset = {
					order = 80,
					type = "execute",
					name = L["oreset"],
					desc = L["oreset_desc"],
					func = function()
						addon:oreset()
					end
				},
				newline1 = {
					type = "description",
					name = "\n",
					order = 81,
				},
				AutoDeleteNewInstance = {
					type = "toggle",
					name = L["Auto Delete New Instance"],
					order = 82,
				},
				DeleteNewInstanceOnly = {
					type = "toggle",
					name = L["Delete New Instance Only"],
					order = 83,
					disabled = function() return not addon.db.profile.AutoDeleteNewInstance end,
				},
				ConfirmDeleteInstance = {
					type = "toggle",
					name = L["Confirm Delete Instance"],
					order = 84,
					disabled = function() return not addon.db.profile.AutoDeleteNewInstance end,
				},
				newline2 = {
					type = "description",
					name = "\n",
					order = 85,
				},
				DeleteJoinRaid = {
					type = "toggle",
					name = L["Delete on Raid Join"],
					order = 86,
				},
				ConfirmDeleteRaid  = {
					type = "toggle",
					name = L["Confirm Delete on Raid Join"],
					order = 87,
					disabled = function() return not addon.db.profile.DeleteJoinRaid end,
				},
				newline3 = {
					type = "description",
					name = "\n",
					order = 90,
				},
				OverkillOnlyOverride = {
					type = "toggle",
					name = L["Only report overkills"],
					order = 91,
				},
				OverkillOnlyLFR = {
					type = "toggle",
					name = L["Only report overkills in LFR"],
					width = "double",
					order = 92,
					disabled = function() return addon.db.profile.OverkillOnlyOverride end,
				},
				announce_header = {
					type = "header",
					name = L["announce"],
					order = 100,
				},
				announce_style = {
					order = 210,
					type = "select",
					name = L["announce_style"],
					desc = L["announce_style_desc"],
					values = announce_style,
				},
				announce_after_style = {
				  order = 210,
					type = "select",
					name = L["announce_after_style"],
					desc = L["announce_after_style_desc"],
					values = announce_after_style,
					disabled = function() if addon.db.profile.announce_style == "during" then return true else return false end end,
				},
				announce = {
					order = 210,
					type = "select",
					name = L["announce"],
					desc = L["announce_desc"],
					values = announce_to,
				},
				channel = {
					order = 210,
					type = "input",
					name = L["Channel"],
					desc = L["Channel"],
					set = "SetChannel",
					get = "GetChannel",
				},
				disabled = {
					type = "toggle",
					name = L["Disabled"],
					order = 211,
				},
				disable_announce_override = {
					type = "toggle",
					name = L["Disable announce override"],
					desc = L["Disallows accepting commands from other users that'd change the announcing settings"],
					order = 212,
				},
				newline = {
					type = "description",
					name = "\n",
					order = 213,
				},
				stats = {
					order = 214,
					type = "execute",
					name = L["stats"],
					desc = L["stats_desc"],
					func = function()
						addon:Stats(addon.db.profile.announce,"stats",addon.db.profile.channelname)
					end
				},
				ostats = {
					order = 218,
					type = "execute",
					name = L["ostats"],
					desc = L["ostats_desc"],
					func = function()
						addon:Stats(addon.db.profile.announce,"ostats",addon.db.profile.channelname)
					end
				},
				stats_value = {
					type = "range",
					order = 219,
					name = L["Top X Stats"],
					desc = L["Amount of entries to display"],
					min = 1, max = 25, step = 1,
					disabled = function() return addon.db.profile.stats_all end,
				},
				stats_all = {
					type = "toggle",
					name = L["Show all"],
					order = 220	,
				},
				remove_header = {
					type = "header",
					name = L["remove"],
					order = 225,
				},
				menubuttonremove = {
					order = 330,
					type = "input",
					name = L["remove"],
					desc = L["remove_desc"],
					set = "MenuButtonRemove",
				},
			},
		}

		LibStub("AceConfig-3.0"):RegisterOptionsTable("EnsidiaFails", args)
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("EnsidiaFails-Filter", self.GenerateFilterOptions)
		LibStub("AceConfigDialog-3.0"):AddToBlizOptions("EnsidiaFails", "EnsidiaFails")
		LibStub("AceConfigDialog-3.0"):AddToBlizOptions("EnsidiaFails-Filter", L["filter"], "EnsidiaFails")
		self:RegisterChatCommand("ef", "OpenMenu")
		self:RegisterChatCommand("EnsidiaFails", "OpenMenu")
		addon:InitializeFailOptionValues()
	elseif (event=="PLAYER_REGEN_ENABLED") then
		addon:KeepCheckingForWipe()
		if ((addon.db.profile.announce_style == "after") or (addon.db.profile.announce_style == "during_and_after")) then
			addon:AnnounceAfter()
		end
	elseif (event=="ZONE_CHANGED_NEW_AREA") then
		if addon.db.profile.AutoDeleteNewInstance == true then
			addon:DetectInstanceChange(event,...)
		end
	elseif (event=="GROUP_ROSTER_UPDATE") then
		addon:PartyMembersChanged(event,...)
	elseif (event=="CHAT_MSG_ADDON") then
		addon:AddonMsgHandler(event,...)
	else--if event == "CHAT_MSG_RAID_LEADER" or "CHAT_MSG_RAID" or "CHAT_MSG_PARTY" or "CHAT_MSG_SAY" or "CHAT_MSG_GUILD" or "CHAT_MSG_CHANNEL" then
		addon:ChatEventHandler(event, ...)
	end
end)

function addon:ChatEventHandler(event, ...)
	local msg,sender,_,_,target,_,_,channelnum = ...
	msg = tostring(msg)
	msg = msg:lower()
	if event == "CHAT_MSG_RAID_LEADER" then
		if msg:find("!wipe") then
			addon:Wipe()
		end
	elseif event == "CHAT_MSG_RAID" then
		if msg:find("!wipe") then
			addon:Wipe()
		end
	elseif event == "CHAT_MSG_CHANNEL" then
		local _,_,_,_,_,_,arg7 = ...
		if arg7 and arg7 > 0 then return end -- it's a global channel (general, localdefense, trade, lfg etc)
		if msg:find("!stats") then
			target = event:sub(10)
			local Time = GetTime()
			if not LastTime then
				LastTime = Time
				addon:Stats(target,"stats",channelnum)
			elseif LastTime+10.000 < Time then
				addon:Stats(target,"stats",channelnum)
				LastTime = nil
			end
		elseif msg:find("!ostats") then
			target = event:sub(10)
			local Time = GetTime()
			if not LastTime then
				LastTime = Time
				addon:Stats(target,"ostats",channelnum)
			elseif LastTime+10.000 < Time then
				addon:Stats(target,"ostats",channelnum)
				LastTime=nil
			end
		end
	end
	if msg:find("!stats") then
		target = event:sub(10)
		if target == "RAID_LEADER" then
			target = "RAID"
		end
		local Time = GetTime()
		if not LastTime then
			LastTime = Time
			addon:Stats(target,"stats",channelnum)
		elseif LastTime+10.000 < Time then
			addon:Stats(target,"stats",channelnum)
			LastTime=nil
		end
	elseif msg:find("!ostats") then
		target = event:sub(10)
		if target == "RAID_LEADER" then
			target = "RAID"
		end
		local Time = GetTime()
		if not LastTime then
			LastTime = Time
			addon:Stats(target,"ostats",channelnum)
		elseif LastTime+10.000 < Time then
			addon:Stats(target,"ostats",channelnum)
			LastTime=nil
		end
	end
end


addon:RegisterEvent("PLAYER_REGEN_ENABLED")
addon:RegisterEvent("ADDON_LOADED")
addon:RegisterEvent("CHAT_MSG_RAID")
addon:RegisterEvent("CHAT_MSG_RAID_LEADER")
addon:RegisterEvent("CHAT_MSG_PARTY")
addon:RegisterEvent("CHAT_MSG_SAY")
addon:RegisterEvent("CHAT_MSG_GUILD")
addon:RegisterEvent("CHAT_MSG_CHANNEL")
addon:RegisterEvent("CHAT_MSG_ADDON")
RegisterAddonMessagePrefix("EnsidiaFails")
addon:RegisterEvent("ZONE_CHANGED_NEW_AREA","DetectInstanceChange") -- Elsia: This is needed for zone change deletion and collection
addon:RegisterEvent("GROUP_ROSTER_UPDATE","PartyMembersChanged")

-------------------------------------------------------------------------
-- OPTIONS MENU GENERATION
-------------------------------------------------------------------------

function addon:GenerateFilterOptions()
	if not addon.FilterOptions then
		addon:GenerateFOI()
	end
	return addon.FilterOptions
end

-- Filter Options Internal
function addon:GenerateFOI()
	addon.FilterOptions = {
		type = "group",
		name = "Filter",
		get = function(info) return addon.db.profile[ info[#info] ] end,
		set = function(info, value) addon.db.profile[ info[#info] ] = value end,
		args = {
			General = {
				order = 0,
				type = "group",
				name = L["general"],
				args = {
					desc = {
						type = "description",
						name = L["filter_desc"],
						order = 1,
						fontSize = "large",
						width = "full",
					},
				},
			},
		},
	}
	addon:GenerateFOIZones()
end

function addon:GenerateFOIZones()
	local o = 1
	for _, v in ipairs(fail:GetSupportedZones()) do
		addon.FilterOptions.args[v] = {
			order = o,
			type = "group",
			name = fail:GetLocalizedZone(v),
			args = {},
		}
		o = o + 1
		addon:GenerateFOIZoneBosses(v)
	end
end

function addon:GenerateFOIZoneBosses(zone)
	local o = 1
	for _, v in ipairs(fail:GetSupportedZoneBosses(zone)) do
		addon.FilterOptions.args[zone]["args"][v] = {
			order = o,
			type = "group",
			name = fail:GetLocalizedBoss(v),
			args = {},
		}
		o = o + 1
		addon:GenerateFOIZoneBossFails(zone, v)
	end
end

function addon:GenerateFOIZoneBossFails(zone, boss)
	local o = GeneratedFOIZoneBossFailOrder
	for _, v in ipairs(fail:GetSupportedBossEvents(boss)) do
		addon.FilterOptions.args[zone]["args"][boss]["args"][v.."_Header"] = {
			order = o,
			type = "header",
			name = fail:GetEventName(v),
		}
		o = o + 1
		addon.FilterOptions.args[zone]["args"][boss]["args"][v] = {
			order = o,
			type = "toggle",
			name = fail:GetEventName(v),
			desc = fail:GetEventDescription(v),
		}
		o = o + 1
		if fail:GetTanksDontFailOption(v) then
			addon.FilterOptions.args[zone]["args"][boss]["args"][v.."_TanksDontFail"] = {
				order = o,
				type = "toggle",
				name = LF["Tanks Dont Fail"],
				disabled = function() return not addon.db.profile[v] end,
				set = function(info, value) addon.db.profile[ info[#info] ], fail.TANKS_DONT_FAIL_LIST[v] = value, value end,
			}
			o = o + 1
		end
		if fail:GetOverkillOnlyOption(v) then
			addon.FilterOptions.args[zone]["args"][boss]["args"][v.."_OverkillOnly"] = {
				order = o,
				type = "toggle",
				name = LF["Overkill Only"],
				disabled = function() return addon.db.profile.OverkillOnlyOverride or not addon.db.profile[v] end,
				get = function(info) return fail.OVERKILL_ONLY_LIST[v] end,
				set = function(info, value) addon.db.profile[ info[#info] ], fail.OVERKILL_ONLY_LIST[v] = value, value end,
			}
			o = o + 1
		end
		if fail:GetEventConstraints(v) then
			for l, s in pairs(fail:GetEventConstraints(v)) do
				addon.FilterOptions.args[zone]["args"][boss]["args"][v..l] = {
					order = o,
					type = "range",
					name = fail:GetLocalizedConstraint(v, l),
					min = math.ceil(s*20/100), max = math.ceil(s*180/100), step = math.ceil(s*10/100),
					disabled = function() return not addon.db.profile[v] end,
					set = function(info, value) addon.db.profile[ info[#info] ], fail.CONSTRAINTS[v][l] = value, value end,
				}
			o = o + 1
			end
		end
	end
end

-------------------------------------------------------------------------
-- RESET GUI
-------------------------------------------------------------------------

--Ripped from Ora
function addon:SetupFrames()
	if check then return end

	local f = GameFontNormal:GetFont()

	check = CreateFrame("Frame", nil, UIParent)
	check:Hide()
	check:SetWidth(325)
	check:SetHeight(125)
	check:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	check:SetBackdropBorderColor(.5, .5, .5)
	check:SetBackdropColor(0,0,0)
	check:ClearAllPoints()
	check:SetPoint("CENTER", WorldFrame, "CENTER", 0, 0)

	local cfade = check:CreateTexture(nil, "BORDER")
	cfade:SetWidth(319)
	cfade:SetHeight(25)
	cfade:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	cfade:SetPoint("TOP", check, "TOP", 0, -4)
	cfade:SetBlendMode("ADD")
	cfade:SetGradientAlpha("VERTICAL", .1, .1, .1, 0, .25, .25, .25, 1)

	header = check:CreateFontString(nil,"OVERLAY")
	header:SetFont(f, 14)
	header:SetWidth(300)
	header:SetText("header")
	header:SetTextColor(1, .8, 0)
	header:ClearAllPoints()
	header:SetPoint("TOP", check, "TOP", 0, -10)

	info = check:CreateFontString(nil,"OVERLAY")
	info:SetFont(f, 10)
	info:SetWidth(300)
	info:SetText("info")
	info:SetTextColor(1, .8, 0)
	info:ClearAllPoints()
	info:SetPoint("TOP", header, "BOTTOM", 0, -10)

	leftButton = CreateFrame("Button", nil, check)
	leftButton:SetWidth(125)
	leftButton:SetHeight(32)
	leftButton:SetPoint("RIGHT", check, "CENTER", -10, -20)

	local t = leftButton:CreateTexture()
	t:SetWidth(125)
	t:SetHeight(32)
	t:SetPoint("CENTER", leftButton, "CENTER")
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	leftButton:SetNormalTexture(t)

	t = leftButton:CreateTexture(nil, "BACKGROUND")
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	t:SetAllPoints(leftButton)
	leftButton:SetPushedTexture(t)

	t = leftButton:CreateTexture()
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	t:SetAllPoints(leftButton)
	t:SetBlendMode("ADD")
	leftButton:SetHighlightTexture(t)
	leftButtonText = leftButton:CreateFontString(nil,"OVERLAY")
	leftButtonText:SetFontObject(GameFontHighlight)
	leftButtonText:SetText("left")
	leftButtonText:SetAllPoints(leftButton)

	rightButton = CreateFrame("Button", nil, check)
	rightButton:SetWidth(125)
	rightButton:SetHeight(32)
	rightButton:SetPoint("LEFT", check, "CENTER", 10, -20)

	t = rightButton:CreateTexture()
	t:SetWidth(125)
	t:SetHeight(32)
	t:SetPoint("CENTER", rightButton, "CENTER")
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	rightButton:SetNormalTexture(t)

	t = rightButton:CreateTexture(nil, "BACKGROUND")
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	t:SetAllPoints(rightButton)
	rightButton:SetPushedTexture(t)

	t = rightButton:CreateTexture()
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	t:SetAllPoints(rightButton)
	t:SetBlendMode("ADD")
	rightButton:SetHighlightTexture(t)
	rightButtonText = rightButton:CreateFontString(nil,"OVERLAY")
	rightButtonText:SetFontObject(GameFontHighlight)
	rightButtonText:SetText("right")
	rightButtonText:SetAllPoints(rightButton)
end

local function hideCheck()
	check:Hide()
end

function addon:ShowReset()
	self:SetupFrames()

	header:SetText(L["Reset EnsidiaFails?"])
	info:SetText(L["Reset Data?"])
	leftButtonText:SetText(L["Yes"])
	rightButtonText:SetText(L["No"])

	leftButton:SetScript("OnClick", function()
		self:reset()
		check:Hide()
	end)
	rightButton:SetScript("OnClick", function()
		check:Hide()
	end)
	check:Show()

	self:ScheduleTimer(hideCheck, 10)
end

-------------------------------------------------------------------------
-- ADDON COMMUNICATION
-------------------------------------------------------------------------

local broadcast_version = {}
function addon:AddonMsgHandler(event,...)
	if select(2, IsInInstance()) == "pvp" then return end
	local prefix, msg, channel, sender = ...
	if prefix == "EnsidiaFails" and (channel == "RAID" or channel == "INSTANCE_CHAT") then
		--print(string.format("[%s] [%s]: %s", channel,sender,msg))
		if msg:find("revision") then
			broadcast_version[sender] = tonumber(msg:match("[%d]+"))
			addon:CheckForSelfPartyMembersChange()
			Versioncheck = addon:ScheduleTimer(addon.Versioncheck, 2)
		elseif msg:find("NOTChanged") then
			addon:CancelTimer(Versioncheck, true)
		end
	end
end

function addon:Versioncheck()
	local v_sorttable = {}
	for k,v in pairs(broadcast_version) do
		table.insert(v_sorttable, {v..";"..k})
	end
	table.sort(v_sorttable,function(a,b) return a[1] > b[1] end)
	if not broadcast_version then --[[print("broadcast_version")]] return end
	if not v_sorttable then --[[print("v_sorttable")]] return end
	if not v_sorttable[1] then --[[print("v_sorttable[1]")]] return end
	if not v_sorttable[1][1] then --[[print("v_sorttable[1][1]")]] return end
	local delimiter_index = (v_sorttable[1][1]):find(";")
	local name = (v_sorttable[1][1]):sub(delimiter_index+1,(v_sorttable[1][1]):len())
	local new_version = (v_sorttable[1][1]):sub(1,delimiter_index-1)
	if name == UnitName("player") then
		if addon.db.profile.disabled and not addon.db.profile.disable_announce_override then
			addon.db.profile.disabled = false
			print("|cFF00FFFFEnsidiaFails: |r"..L["Announcing Enabled! YOU are the main announcer for EnsidiaFails, please check your announcing settings"])
		end
	else
		if not addon.db.profile.disabled and not addon.db.profile.disable_announce_override then
			addon.db.profile.disabled = true
			if tonumber(new_version) == tonumber(local_revision) then
				print(("|cFF00FFFFEnsidiaFails: |r"..L["Announcing Disabled! %s is the main announcer. (He/She has the same version as you (%s))"]) :format(name,local_revision))
			else
				print(("|cFF00FFFFEnsidiaFails: |r"..L["Announcing Disabled! %s is the main announcer. (Please consider updating your addon his/her version was %s)(yours: %s)"]):format(name,new_version,local_revision))
			end
		end
	end
end

function addon:SendRevision()
	if select(2, IsInInstance()) == "pvp" then return end
	local target = "RAID"
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		target = "INSTANCE_CHAT"
	end
	SendAddonMessage("EnsidiaFails", "revision "..local_revision, target)
end

function addon:CheckForSelfPartyMembersChange()
	if self_party_members_changed == false then
		if select(2, IsInInstance()) == "pvp" then return end
		local target = "RAID"
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			target = "INSTANCE_CHAT"
		end
		SendAddonMessage("EnsidiaFails", "NOTChanged", target)
	end
end

function addon:StartSync()
	self_party_members_changed = true
	addon:SendRevision()
	addon:ScheduleTimer(addon.PartyMembersChangedTimout, 4)
end

-------------------------------------------------------------------------
-- RESET
-------------------------------------------------------------------------

function addon:reset()
	EnsidiaFails_FailCount = {}
	DEFAULT_CHAT_FRAME:AddMessage(L["reseted"]);
end

function addon:oreset()
	EnsidiaFails_FailCount = {}
	EnsidiaFails_OFailCount = {}
	DEFAULT_CHAT_FRAME:AddMessage(L["oreseted"]);
end

function addon:PartyMembersChangedTimout()
	self_party_members_changed = false
	broadcast_version = {}
end

-- Majorly ripped from Recount
function addon:PartyMembersChanged(event,...)

	addon:StartSync()

	if not next(EnsidiaFails_FailCount, nil) then return end
	local NumRaidMembers = GetNumGroupMembers()

	if addon.db.profile.DeleteJoinRaid and not addon.inRaid and NumRaidMembers > 0 then
		if addon.db.profile.ConfirmDeleteRaid then
			addon:ShowReset() -- Elsia: Confirm & Delete!
		else
			addon:reset()		-- Elsia: Delete!
		end
	end

	local change = false

	if NumRaidMembers > 0 or UnitInRaid("player") then
		change = change or not addon.inRaid
	   addon.inRaid = true
	else
		change = change or addon.inRaid
		addon.inRaid = false
	end

	end

function addon:InitPartyBasedDeletion()
	local NumRaidMembers = GetNumGroupMembers()

	addon.inRaid = false

	if NumRaidMembers > 0 then addon.inRaid = true end
end

function addon:ReleasePartyBasedDeletion()
	if addon.db.profile.DeleteJoinRaid == false then
		addon:UnregisterEvent("GROUP_ROSTER_UPDATE")
	end
end

function addon:DetectInstanceChange(event,...) -- Elsia: With thanks to Loggerhead

	local zone = GetRealZoneText()

	if zone == nil or zone == "" then
		-- zone hasn't been loaded yet, try again in 5 secs.
		addon:ScheduleTimer(addon.DetectInstanceChange,5)
		return
	end

	addon:UpdateOverrides()

	--addon:UpdateZoneGroupFilter()


	if addon.db.profile.AutoDeleteNewInstance == false then return end

	if not next(EnsidiaFails_FailCount,nil) then return end

	local inInstance = IsInInstance()

	if inInstance and (not addon.db.profile.DeleteNewInstanceOnly or LastInstanceName ~= zone) then
		if addon.db.profile.ConfirmDeleteInstance == true then
			addon:ShowReset() -- Elsia: Confirm & Delete!
		else
			addon:reset()		-- Elsia: Delete!
		end
		if not UnitIsGhost("player") then LastInstanceName = zone end-- Elsia: We'll set the instance even if the user opted to not delete...
	end
end

addon:ScheduleTimer(addon.DetectInstanceChange,5) -- Elsia: We need to do this regardless for Zone filtering.

-------------------------------------------------------------------------
-- STATS
-------------------------------------------------------------------------

function addon:Stats(target, stat, whisper)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and target == "RAID" then
		target = "INSTANCE_CHAT"
	end
	local Count = nil
	if stat == "ostats" then
		Count = EnsidiaFails_OFailCount
	else
		Count = EnsidiaFails_FailCount
	end
	local count,players=0,0
	local sorttable={}
	for k,v in pairs(Count) do
		count = count + v
		players = players + 1
		table.insert(sorttable, {k,v})
	end
	if (players == 0) then
		addon:SendChatMessage(L["nobody_failed"],target, whisper)
	else
		table.sort(sorttable,function(a,b) return a[2] > b[2] end)
		local b,amount=1,addon.db.profile.stats_value
		addon:SendChatMessage(L["we_have"]..count..L["fails_on"]..players..L["diff%..."]:format(amount),target, whisper)
		if addon.db.profile.stats_all then
			amount = #sorttable
		end
		for k,v in ipairs(sorttable) do
			if (b <= amount) then
				if b == 1 then
					if stat == "ostats" then
						addon:SendChatMessage(L["admiral"]..v[1]..L["failed"]..v[2].."x ("..string.format("%02.1f",v[2]/count*100).."%)",target, whisper)
					else
						addon:SendChatMessage(L["captain"]..v[1]..L["failed"]..v[2].."x ("..string.format("%02.1f",v[2]/count*100).."%)",target, whisper)

					end
				else
					addon:SendChatMessage(b..". "..v[1]..L["failed"]..v[2].."x ("..string.format("%02.1f",v[2]/count*100).."%)",target, whisper)
				end
			end
			b=b+1
		end
		if (GetNumSubgroupMembers() > 0) or (GetNumGroupMembers() > 0) then
			local r,name={},""
			if (GetNumGroupMembers() > 0) then
				for i=1,GetNumGroupMembers() do
					name=GetRaidRosterInfo(i)
					if (Count[name] == nil) then
						table.insert(r,name)
					end
				end
			else
				for i=1,GetNumSubgroupMembers() do
					name = UnitName("party"..i)
					if (Count[name] == nil) then
						table.insert(r,name)
					end
				end
				name = UnitName("player")
				if (Count[name] == nil) then
					table.insert(r,name)
				end
			end
			addon:SendChatMessage(L["didnt_fail"]..table.concat(r,", "),target, whisper)
		end
	end
end

-------------------------------------------------------------------------
-- WIPE HANDLING
-------------------------------------------------------------------------

function addon:Wipe()
	if wipe_called then return end
	addon:Msg(L["susped"],addon.db.profile.announce)
	addon:ScheduleTimer(addon.Resume, 60)
	wipe_called = true
end

function addon:Resume()
	addon:Msg(L["resume"],addon.db.profile.announce)
	wipe_called = false
end

function addon:CheckForWipe()
	local wipe = true
	local num = GetNumGroupMembers()
	for i = 1, num do
		local name = GetRaidRosterInfo(i)
		if name then
			if UnitAffectingCombat(name) ~= nil then
				wipe = false
			end
		end
	end
	if wipe then
		addon:ScheduleTimer(self.ReInitalizeSessionFailTables, 1)
	end
	return wipe
end

function addon:ReInitalizeSessionFailTables()
	FailsForTheSession, event_fails, sorttable, failed_at = {}, {}, {}, {}
end

function addon:KeepCheckingForWipe()
	local wipe = false
	if not addon:CheckForWipe() then
		addon:ScheduleTimer(addon.KeepCheckingForWipe, 2)
	else
		wipe = true
	end
	return wipe
end

-------------------------------------------------------------------------
-- ANNOUNCE
-------------------------------------------------------------------------

function addon:AnnounceAfter()
	local target = addon.db.profile.announce
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and target == "RAID" then
		target = "INSTANCE_CHAT"
	end
	if addon:CheckForWipe() and not addon.db.profile.disabled then
		if addon.db.profile.announce_after_style == "group_by_player" then
			local event_fails1, failed_at1 = 0, ""
			for k, v in pairs(FailsForTheSession) do
			   event_fails1 = 0
			   failed_at1 = ""
			   for j, e in pairs(v) do
				  event_fails1 = e + event_fails1
				  failed_at1 = failed_at1..e.."x ("..j.."), "
			   end
			   event_fails[k]= event_fails1
			   failed_at[k] = failed_at1
			end
			local Count = event_fails
			for k,v in pairs(Count) do
			   table.insert(sorttable, {k,v})
			end
			table.sort(sorttable,function(a,b) return a[2] > b[2] end)
			for k, v in pairs(sorttable) do
				if k==1 then
					addon:SendChatMessage("-------------", target, addon.db.profile.channelname)
				end
				for j, e in pairs(failed_at) do
					if v[1] == j then
						addon:SendChatMessage(v[1].. L["failed"] ..v[2].."x ("..strsub(e,0,strlen(e)-3).."))", target, addon.db.profile.channelname)
					end
				end
			end
			addon:ReInitalizeSessionFailTables()
		elseif addon.db.profile.announce_after_style == "group_by_fail" then
			local list = {}
			for k, v in pairs(FailsForTheSession) do
				for j, e in pairs(v) do
					if list[j] == nil then
						list[j] = {}
						list[j][1] = k.." ("..e..")"
					else
						list[j][1] = list[j][1]..", "..k.." ("..e..")"
					end
				end
			end
			for k,v in pairs(list) do
			   table.insert(sorttable, {k,v})
			end
			table.sort(sorttable,function(a,b) return a[1] > b[1] end)
			for k=1, #sorttable do
				if k==1 then
					addon:SendChatMessage("-------------",target, addon.db.profile.channelname)
				end
				addon:SendChatMessage(sorttable[k][1]..": "..sorttable[k][2][1],target, addon.db.profile.channelname)
			end
			addon:ReInitalizeSessionFailTables()
		end
	elseif not addon.db.profile.disabled then
		addon:ScheduleTimer(addon.AnnounceAfter, 2)
	end
end

function addon:AddFail(p,s,eventName, ...)
	addon:Initialize()
	if addon.db.profile.announce_style == "after" then
		if not FailsForTheSession[p] then FailsForTheSession[p] = {} end
		if not FailsForTheSession[p][eventName] then
			FailsForTheSession[p][eventName] = 1
		else
			FailsForTheSession[p][eventName] = FailsForTheSession[p][eventName] + 1
		end
		if not EnsidiaFails_OFailCount[p] then
			EnsidiaFails_OFailCount[p] = 1
			EnsidiaFails_FailCount[p] = 1
		else
			if not EnsidiaFails_FailCount[p] then
				EnsidiaFails_FailCount[p] = 1
			else
				EnsidiaFails_OFailCount[p] = EnsidiaFails_OFailCount[p] + 1
				EnsidiaFails_FailCount[p] = EnsidiaFails_FailCount[p] + 1
			end
		end
	elseif ((addon.db.profile.announce_style == "during") or (addon.db.profile.announce_style == "during_and_after")) then
		if not FailsForTheSession[p] then FailsForTheSession[p] = {} end
		if not FailsForTheSession[p][eventName] then
			FailsForTheSession[p][eventName] = 1
		else
			FailsForTheSession[p][eventName] = FailsForTheSession[p][eventName] + 1
		end
		if not EnsidiaFails_OFailCount[p] then
			EnsidiaFails_OFailCount[p] = 1
			EnsidiaFails_FailCount[p] = 1
		else
			if not EnsidiaFails_FailCount[p] then
				EnsidiaFails_FailCount[p] = 1
			else
				EnsidiaFails_OFailCount[p] = EnsidiaFails_OFailCount[p] + 1
				EnsidiaFails_FailCount[p] = EnsidiaFails_FailCount[p] + 1
			end
		end
		if select(1,...) then
			addon:SendFailChatMessage(p,s.." ("..eventName..")".."("..(select(1,...))..")")
		else
			addon:SendFailChatMessage(p,s.." ("..eventName..")")
		end
	end
end

function addon:RemoveFail(p,t,w)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and t == "RAID" then
		t = "INSTANCE_CHAT"
	end
	if not EnsidiaFails_OFailCount[p] then
		DEFAULT_CHAT_FRAME:AddMessage(L["Wrong name!"])
		return
	elseif EnsidiaFails_OFailCount[p] > 0 then
		EnsidiaFails_OFailCount[p] = EnsidiaFails_OFailCount[p] - 1
		if not EnsidiaFails_FailCount[p] then
			DEFAULT_CHAT_FRAME:AddMessage(L["Wrong name!"])
			return
		elseif EnsidiaFails_FailCount[p] > 0 then
			EnsidiaFails_FailCount[p] = EnsidiaFails_FailCount[p] - 1
			addon:SendChatMessage(L["removed"]..p,t,w)
		end
	end
end

function addon:SendChatMessage(msg, target, whisper)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and target == "RAID" then
		target = "INSTANCE_CHAT"
	end
	if not addon.db.profile.disabled then
		if target == "CHANNEL"  then
			if not addon:CheckForValidChannel(whisper) then
				whisper = GetChannelName(whisper)
				SendChatMessage(msg,target,nil,whisper)
			end
		elseif target == "SELF" then
			DEFAULT_CHAT_FRAME:AddMessage(msg)
		elseif target == "RAID" and not UnitInRaid("player") then
			SendChatMessage(msg,"PARTY")
		else
			SendChatMessage(msg,target,nil,whisper)
		end
	end
end

function addon:SendFailChatMessage(p,s)
	if not addon.db.profile.disabled then
		addon:Msg(LF["%s fails at %s (%s)"]:format(p,s,EnsidiaFails_FailCount[p]),self.db.profile.announce)
	end
end

function addon:Msg(m,t)
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and t == "RAID" then
		t = "INSTANCE_CHAT"
	end
	local w = nil
	if self.db.profile.channelname then
		w = GetChannelName(self.db.profile.channelname)
	end
	if addon.db.profile.announce == "SELF" then
		DEFAULT_CHAT_FRAME:AddMessage(m)
	elseif t == "RAID" and not UnitInRaid("player") then
		SendChatMessage(m,"PARTY")
	else
		SendChatMessage(m,t,nil,w)
	end
end
