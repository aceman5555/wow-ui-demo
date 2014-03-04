if select(6, GetAddOnInfo("PitBull4_" .. (debugstack():match("[o%.][d%.][u%.]les\\(.-)\\") or ""))) ~= "MISSING" then return end

local PitBull4 = _G.PitBull4
if not PitBull4 then
	error("PitBull4_LeaderIconEx requires PitBull4")
end

local L = PitBull4.L

local PitBull4_LeaderIconEx = PitBull4:NewModule("LeaderIconEx", "AceEvent-3.0", "AceTimer-3.0")

PitBull4_LeaderIconEx:SetModuleType("indicator")
PitBull4_LeaderIconEx:SetName(L["Leader/Assitant Icon"])
PitBull4_LeaderIconEx:SetDescription(L["Show an icon on the unit frame when the unit is the group leader or assistant."])
PitBull4_LeaderIconEx:SetDefaults({
	attach_to = "root",
	location = "edge_top_left",
	position = 1,
})

local leader_guid
local ass_guid = {}

function PitBull4_LeaderIconEx:OnEnable()
	self:RegisterEvent("PARTY_LEADER_CHANGED")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "PARTY_LEADER_CHANGED")
end

function PitBull4_LeaderIconEx:GetTexture(frame)
	if frame.guid == leader_guid then
		return [[Interface\GroupFrame\UI-Group-LeaderIcon]]
	elseif ass_guid[frame.guid] then
		return [[Interface\GROUPFRAME\UI-GROUP-ASSISTANTICON]]
	else
		return nil
	end
end

function PitBull4_LeaderIconEx:GetExampleTexture(frame)
	return [[Interface\GroupFrame\UI-Group-LeaderIcon]]
end

function PitBull4_LeaderIconEx:GetTexCoord(frame, texture)
	return 0.1, 0.84, 0.14, 0.88
end
PitBull4_LeaderIconEx.GetExampleTexCoord = PitBull4_LeaderIconEx.GetTexCoord

local function update_leader_guid()
	local group_size = GetNumGroupMembers()
	wipe(ass_guid)
	if group_size > 0 then
		local group_unit_prefix = IsInRaid() and "raid" or "party"
		for i = 1, group_size do
			local unit = group_unit_prefix..i
			if UnitIsGroupLeader(unit) then
				leader_guid = UnitGUID(unit)
			end
			if UnitIsGroupAssistant(unit) then
				ass_guid[UnitGUID(unit)] = true
			end
		end
	else
		-- not in a raid or a party
		leader_guid = nil
	end
	PitBull4_LeaderIconEx:UpdateAll()
end
function PitBull4_LeaderIconEx:PARTY_LEADER_CHANGED()
	self:ScheduleTimer(update_leader_guid, 0.1)
end
