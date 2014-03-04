if select(6, GetAddOnInfo("PitBull4_" .. (debugstack():match("[o%.][d%.][u%.]les\\(.-)\\") or ""))) ~= "MISSING" then return end

local PitBull4 = _G.PitBull4
if not PitBull4 then
	error("PitBull4_NamePlate requires PitBull4")
end

local unpack = _G.unpack
local L = PitBull4.L

local PitBull4_NamePlate = PitBull4:NewModule("NamePlate", "AceEvent-3.0")

PitBull4_NamePlate:SetModuleType("bar")
PitBull4_NamePlate:SetName(L["Name plate"])
PitBull4_NamePlate:SetDescription(L["Show a bar with the unit's name."])
PitBull4_NamePlate:SetDefaults({
	position = 1,
	color_by_class = false,
	use_dead = false,
	use_disconnected = false,},{
	colors = {
		dead = { 0.6, 0.6, 0.6 },
		disconnected = { 0.7, 0.7, 0.7 },
		tapped = { 0.5, 0.5, 0.5 },
	}
})

local timerFrame = CreateFrame("Frame")
timerFrame:Hide()

local PLAYER_GUID
function PitBull4_NamePlate:OnEnable()
	PLAYER_GUID = UnitGUID("player")
	timerFrame:Show()
	
	self:RegisterEvent("UNIT_HEALTH")
	
	self:UpdateAll()
end

function PitBull4_NamePlate:OnDisable()
	timerFrame:Hide()
end

timerFrame:SetScript("OnUpdate", function()
	for frame in PitBull4:IterateFramesForGUIDs(PLAYER_GUID, UnitGUID("pet")) do
		PitBull4_NamePlate:Update(frame)
	end
end)

function PitBull4_NamePlate:GetValue(frame)
	return 1
end

function PitBull4_NamePlate:GetExampleValue(frame)
	return 1
end

function PitBull4_NamePlate:GetColor(frame, value)
	local db = self:GetLayoutDB(frame)
	local unit = frame.unit
	if self.db.profile.global.use_disconnected and not UnitIsConnected(unit)  then
		return unpack(self.db.profile.global.colors.disconnected)
	elseif self.db.profile.global.use_dead and UnitIsDeadOrGhost(unit) then
		return unpack(self.db.profile.global.colors.dead)
	elseif UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
		return unpack(self.db.profile.global.colors.tapped)
	elseif db.color_by_class then
		local _, class = UnitClass(unit)
		local t = PitBull4.ClassColors[class]
		if t then
			return t[1], t[2], t[3]
		end
	else
		if UnitIsPlayer(unit) or UnitPlayerControlled(unit) then
			if UnitIsPVPSanctuary(unit) then
				return unpack(PitBull4.ReactionColors.civilian)
			else
				if UnitCanAttack(unit, "player") then
					if UnitCanAttack("player", unit) then
						return unpack(PitBull4.ReactionColors[2])
					else
						return unpack(PitBull4.ReactionColors.civilian)
					end
				elseif UnitCanAttack("player", unit) then
					return unpack(PitBull4.ReactionColors[4])
				elseif UnitIsPVP(unit) then
					return unpack(PitBull4.ReactionColors[5])
				else
					return unpack(PitBull4.ReactionColors.civilian)
				end
			end
		else
			local reaction = UnitReaction(unit, "player")
			if reaction then
				return unpack(PitBull4.ReactionColors[reaction])
			else
				return nil
			end
		end
	end
end

function PitBull4_NamePlate:GetExampleColor(frame, value)
	local unit = frame.unit
	local seed_table = {PitBull4.ReactionColors.civilian,PitBull4.ReactionColors[5],PitBull4.ReactionColors[2],PitBull4.ReactionColors[3],PitBull4.ReactionColors[4]}
	local seed
	if unit == "player" then
		seed = random(2) -- player can be blue or green
	elseif unit:match("^raid(%d%d?)$") or unit:match("^party(%d)$") or unit:match("^raidpet(%d%d?)$") or unit:match("^partypet(%d)$") then
		seed = random(3) -- party/raid and pets can be blue, green or red (if mind controled)
	else
		seed = random(5) -- others can be any color
	end
	return unpack(seed_table[seed])
end

function PitBull4_NamePlate:UNIT_HEALTH(event, unit)
	self:UpdateForUnitID(unit)
end

PitBull4_NamePlate:SetLayoutOptionsFunction(function(self)
	return 'color_by_class', {
		name = L["Color by class"],
		desc = L["Color the name plate by unit class"],
		type = 'toggle',
		get = function(info)
			return PitBull4.Options.GetLayoutDB(self).color_by_class
		end,
		set = function(info, value)
			PitBull4.Options.GetLayoutDB(self).color_by_class = value
			PitBull4.Options.UpdateFrames()
		end
	}
end)

PitBull4_NamePlate:SetColorOptionsFunction(function(self)
	local function get(info)
		return unpack(self.db.profile.global.colors[info[#info]])
	end
	local function set(info, r, g, b)
		local color = self.db.profile.global.colors[info[#info]]
		color[1], color[2], color[3] = r, g, b
	end
	return 'dead', {
		type = 'color',
		name = L["Dead"],
		get = get,
		set = set,},
	'disconnected', {
		type = 'color',
		name = L["Disconnected"],
		get = get,
		set = set,},
	'tapped', {
		type = 'color',
		name = L["Tapped"],
		get = get,
		set = set,},
	'use_dead', {
		type = 'toggle',
		name = L['Use dead/ghost color'],
		desc = L['Color the bar with defined color when unit is dead or ghost.'],
		get = function(info)
			return self.db.profile.global.use_dead
		end,
		set = function(info, value)
			self.db.profile.global.use_dead = value
		end,},
	'use_disconnected', {
		type = 'toggle',
		name = L['Use disconnected color'],
		desc = L['Color the bar with defined color when unit is disconnected.'],
		get = function(info)
			return self.db.profile.global.use_disconnected
		end,
		set = function(info, value)
			self.db.profile.global.use_disconnected = value
		end,},
	function(info)
		local color = self.db.profile.global.colors.dead
		color[1], color[2], color[3] = 0.6, 0.6, 0.6
		
		local color = self.db.profile.global.colors.disconnected
		color[1], color[2], color[3] = 0.7, 0.7, 0.7
		
		local color = self.db.profile.global.colors.tapped
		color[1], color[2], color[3] = 0.5, 0.5, 0.5
		
		self.db.profile.global.use_dead = false
		
		self.db.profile.global.use_disconnected = false
	end
end)
