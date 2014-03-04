if select(6, GetAddOnInfo("PitBull4_" .. (debugstack():match("[o%.][d%.][u%.]les\\(.-)\\") or ""))) ~= "MISSING" then return end

local PitBull4 = _G.PitBull4
if not PitBull4 then
	error("PitBull4_RaidRoleIcon requires PitBull4")
end

local L = PitBull4.L

local PitBull4_RaidRoleIcon = PitBull4:NewModule("RaidRoleIcon", "AceEvent-3.0", "AceTimer-3.0")

PitBull4_RaidRoleIcon:SetModuleType("indicator")
PitBull4_RaidRoleIcon:SetName(L["Raid role icon"])
PitBull4_RaidRoleIcon:SetDescription(L["Show an icon on the unit frame when the unit is MT or MA."])
PitBull4_RaidRoleIcon:SetDefaults({
	attach_to = "root",
	location = "edge_top_left",
	position = 1,
})

function PitBull4_RaidRoleIcon:OnEnable()
	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
end

function PitBull4_RaidRoleIcon:GetTexture(frame)
	local unit = frame.unit
	if UnitInRaid(unit) then
		if GetPartyAssignment("MAINTANK", unit) then
			return [[Interface\GROUPFRAME\UI-GROUP-MAINTANKICON]]
		elseif GetPartyAssignment("MAINASSIST", unit) then
			return [[Interface\GROUPFRAME\UI-GROUP-MAINASSISTICON]]
		end
	end
	return nil
end

function PitBull4_RaidRoleIcon:GetExampleTexture(frame)
	if random(2) == 1 then
		return [[Interface\GROUPFRAME\UI-GROUP-MAINTANKICON]]
	else
		return [[Interface\GROUPFRAME\UI-GROUP-MAINASSISTICON]]
	end
end

function PitBull4_RaidRoleIcon:GetTexCoord(frame, texture)
	return 0, 1, 0, 1
end
PitBull4_RaidRoleIcon.GetExampleTexCoord = PitBull4_RaidRoleIcon.GetTexCoord

function PitBull4_RaidRoleIcon:PARTY_MEMBERS_CHANGED()
	self:ScheduleTimer("UpdateAll", 0.1)
end
