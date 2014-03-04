local L = AceLibrary("AceLocale-2.2"):new("GridStatusAFK")
local GridRoster = Grid:GetModule("GridRoster")

L:RegisterTranslations("enUS", function() return {
	["AFK"] = true,
	["<AFK>"] = true,
	["AFK alert"] = true,
} end)

L:RegisterTranslations("deDE", function() return {
	["AFK"] = "AFK",
	["<AFK>"] = "<AFK>",
	["AFK alert"] = "AFK Alarm",
} end)

L:RegisterTranslations("koKR", function() return {
	["AFK"] = "자리비움",
	["<AFK>"] = "<자리비움>",
	["AFK alert"] = "자리비움 경고",
} end)

L:RegisterTranslations("zhTW", function() return {
	["AFK"] = "暫離",
	["<AFK>"] = "<暫離>",
	["AFK alert"] = "暫離警告",
} end)

L:RegisterTranslations("zhCN", function() return {
	["AFK"] = "暂离",
	["<AFK>"] = "<暂离>",
	["AFK alert"] = "暂离警告",
} end)


local GridStatusAFK = Grid:GetModule("GridStatus"):NewModule("GridStatusAFK")
GridStatusAFK.menuName = L["AFK"]
GridStatusAFK.options = false

GridStatusAFK.defaultDB = {
	debug = false,
	alert_afk = {
		text = L["<AFK>"],
		enable = false,
		color = { r = 0.5, g = 0.5, b = 0.5, a = 0.5 },
		priority = 20,
		range = false,
	},
}

local UnitIsAFK = UnitIsAFK

local afkers={}

function GridStatusAFK:OnInitialize()
	self.super.OnInitialize(self)

	self:RegisterStatus("alert_afk", L["AFK alert"], nil, true)
end

function GridStatusAFK:OnEnable()
	self.debugging = self.db.profile.debug
	self:Debug("OnEnable")

	self.super.OnEnable(self)
end

function GridStatusAFK:Reset()
	self.super.Reset(self)
	afkers={}

	self.core:SendStatusLostAllUnits(status)
	self:UnregisterStatus("alert_afk")
	self:RegisterStatus("alert_afk", L["AFK alert"], nil, true)

	self:UpdateAllUnits()
end


function GridStatusAFK:OnStatusEnable(status)
	self:RegisterEvent("PLAYER_FLAGS_CHANGED", "OnUnitEvent")	-- Immediately tells us about changes to units <100 yds from us
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "UpdateAllUnits")	-- Happens when we e.g. zone into an instance
	self:RegisterEvent("READY_CHECK", "UpdateAllUnits")
	self:RegisterEvent("READY_CHECK_FINISHED", "UpdateAllUnits")
	self:RegisterEvent("Grid_UnitJoined")
	self:RegisterEvent("Grid_UnitOffline")
	self:ScheduleRepeatingEvent("GridStatusAFK_UpdateAllUnits", self.UpdateAllUnits, 5.07, self)	-- Once in a while, poll everyone to catch changes to units outside our range (yes, oddball interval to keep it from overlapping with everyone else's 1s timers all the time)
	self:UpdateAllUnits()
end

function GridStatusAFK:OnStatusDisable(status)
	self.core:SendStatusLostAllUnits(status)
	self:UnregisterAllEvents()
	self:CancelAllScheduledEvents()
	afkers={}
end


local function setStatus(guid, afk)
	if afk then
		afkers[guid]=true
		local settings = GridStatusAFK.db.profile.alert_afk
		GridStatusAFK.core:SendStatusGained(guid, "alert_afk",
						settings.priority,
						(settings.range and 40),
						settings.color,
						settings.text
		)
	else
		afkers[guid]=nil
		GridStatusAFK.core:SendStatusLost(guid, "alert_afk")
	end
end

function GridStatusAFK:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		local afk = UnitIsAFK(unitid)
		if (not not afk) ~= (not not afkers[guid]) then
			setStatus(guid, afk)
		end
	end
end

function GridStatusAFK:OnUnitEvent(unitid)
	local guid = UnitGUID(unitid)
	if (not GridRoster:IsGUIDInRaid(guid)) then
		return
	end
	setStatus(guid,UnitIsAFK(unitid))
end

function GridStatusAFK:Grid_UnitJoined(guid, unitid)
	setStatus(guid, UnitIsAFK(unitid)) 
end

function GridStatusAFK:Grid_UnitOffline(guid)
	setStatus(guid, false)
end
