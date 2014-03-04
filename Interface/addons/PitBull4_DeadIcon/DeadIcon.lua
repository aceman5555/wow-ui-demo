if select(6, GetAddOnInfo("PitBull4_" .. (debugstack():match("[o%.][d%.][u%.]les\\(.-)\\") or ""))) ~= "MISSING" then return end

local PitBull4 = _G.PitBull4
if not PitBull4 then
	error("PitBull4_DeadIcon requires PitBull4")
end

local L = PitBull4.L

local PitBull4_DeadIcon = PitBull4:NewModule("DeadIcon", "AceTimer-3.0")

PitBull4_DeadIcon:SetModuleType("indicator")
PitBull4_DeadIcon:SetName(L["Dead icon"])
PitBull4_DeadIcon:SetDescription(L["Show an icon based on whether or not the unit is dead or ghost."])
PitBull4_DeadIcon:SetDefaults({
	attach_to = "root",
	location = "edge_bottom_left",
	position = 1,
})

function PitBull4_DeadIcon:OnEnable()
	self:ScheduleRepeatingTimer("UpdateAll", 0.1)
end

function PitBull4_DeadIcon:GetTexture(frame)
	if UnitIsDeadOrGhost(frame.unit) then
		return [[Interface\TARGETINGFRAME\TargetDead]]
	else
		return nil
	end
end

function PitBull4_DeadIcon:GetExampleTexture(frame)
	return [[Interface\TARGETINGFRAME\TargetDead]]
end

function PitBull4_DeadIcon:GetTexCoord(frame, texture)
	return 0, 1, 0, 1
end
PitBull4_DeadIcon.GetExampleTexCoord = PitBull4_DeadIcon.GetTexCoord
