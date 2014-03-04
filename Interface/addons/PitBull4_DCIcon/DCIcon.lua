if select(6, GetAddOnInfo("PitBull4_" .. (debugstack():match("[o%.][d%.][u%.]les\\(.-)\\") or ""))) ~= "MISSING" then return end

local PitBull4 = _G.PitBull4
if not PitBull4 then
	error("PitBull4_DCIcon requires PitBull4")
end

local L = PitBull4.L

local PitBull4_DCIcon = PitBull4:NewModule("DCIcon", "AceTimer-3.0")

PitBull4_DCIcon:SetModuleType("indicator")
PitBull4_DCIcon:SetName(L["DC icon"])
PitBull4_DCIcon:SetDescription(L["Show an icon based on whether or not the unit is offline."])
PitBull4_DCIcon:SetDefaults({
	attach_to = "root",
	location = "edge_bottom_left",
	position = 1,
})

function PitBull4_DCIcon:OnEnable()
	self:ScheduleRepeatingTimer("UpdateAll", 0.1)
end

function PitBull4_DCIcon:GetTexture(frame)
	if UnitIsConnected(frame.unit) then
		return nil
	else
		return [[Interface\CHARACTERFRAME\Disconnect-Icon]]
	end
end

function PitBull4_DCIcon:GetExampleTexture(frame)
	return [[Interface\CHARACTERFRAME\Disconnect-Icon]]
end

function PitBull4_DCIcon:GetTexCoord(frame, texture)
	return 0.25, 0.75, 0.1875, 0.796875
end
PitBull4_DCIcon.GetExampleTexCoord = PitBull4_DCIcon.GetTexCoord
