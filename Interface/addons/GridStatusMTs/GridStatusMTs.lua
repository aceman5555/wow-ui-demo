-- -------------------------------------------------------------------------- --
-- GridStatusMTs by kunda                                                     --
-- -------------------------------------------------------------------------- --

local GridRoster = Grid:GetModule("GridRoster")
local GridStatusMTs = Grid:GetModule("GridStatus"):NewModule("GridStatusMTs")
local L = GridStatusMTs_Locales

local IsInRaid = IsInRaid
local IsInGroup = IsInGroup
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitGUID = UnitGUID

GridStatusMTs.menuName = L["MTs"]

GridStatusMTs.defaultDB = {
	debug = nil,
	alert_mt = {
		text = L["MTs"],
		enable = true,
		color = { r = 0.78, g = 0.52, b = 0.28, a = 1 },
		priority = 60,
		range = false,
		general = false,
		numbered = false,
		opacity = 1,
	}
}

GridStatusMTs.options = false

function GridStatusMTs:OnInitialize()
	self.super.OnInitialize(self)

	local	menu_MTicon = {
		["opacity"] = {
			type = "range",
			name = L["Opacity"],
			desc = L["Sets the opacity for the MainTank icons."],
			order = 100,
			min = 0,
			max = 1,
			step = 0.01,
			bigStep = 0.05,
			get = function()
				return GridStatusMTs.db.profile.alert_mt.opacity
			end,
			set = function(_, v)
				GridStatusMTs.db.profile.alert_mt.opacity = v
				GridStatusMTs:UpdateMainTankTable()
			end
		},
		["general"] = {
			type = "toggle",
			name = L["Blizzard MainTank icon"],
			desc = L["Use the default Blizzard MainTank icon (shield)."],
			order = 101,
			get = function()
				return GridStatusMTs.db.profile.alert_mt.general
			end,
			set = function()
				GridStatusMTs.db.profile.alert_mt.general = not GridStatusMTs.db.profile.alert_mt.general
				if not GridStatusMTs.db.profile.alert_mt.general then
					GridStatusMTs.db.profile.alert_mt.numbered = false
				end
				GridStatusMTs:UpdateMainTankTable()
			end
		},
		["numbered"] = {
			type = "toggle",
			name = L["... for sorted MainTank list too"],
			desc = L["Use the default Blizzard MainTank icon (shield) for a sorted MainTank list (oRA2, oRA3 or CT_RA) too."],
			disabled = function() return not GridStatusMTs.db.profile.alert_mt.general end,
			order = 102,
			get = function()
				return GridStatusMTs.db.profile.alert_mt.numbered
			end,
			set = function()
				GridStatusMTs.db.profile.alert_mt.numbered = not GridStatusMTs.db.profile.alert_mt.numbered
				GridStatusMTs:UpdateMainTankTable()
			end
		},
		["range"] = false,
		["color"] = false,
	}

	self:RegisterStatus("alert_mt", L["MTs"], menu_MTicon, true)
end

function GridStatusMTs:OnStatusEnable(status)
	if status == "alert_mt" then
		self:RegisterEvent("oRA_MainTankUpdate", "UpdateMainTankTable")
		self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateMainTankTable")
		if CT_RAOptions_UpdateMTs then
			hooksecurefunc("CT_RAOptions_UpdateMTs", GridStatusMTs.UpdateMainTankTable)
		end
		self:UpdateMainTankTable()
	end
end

function GridStatusMTs:OnStatusDisable(status)
	if status == "alert_mt" then
		self:UnregisterEvent("oRA_MainTankUpdate")
		self:UnregisterEvent("GROUP_ROSTER_UPDATE")
		self.core:SendStatusLostAllUnits("alert_mt")
	end
end

function GridStatusMTs:Reset()
	self.super.Reset(self)
	self:UpdateMainTankTable()
end

function GridStatusMTs:UpdateMainTankTable()
	self.core:SendStatusLostAllUnits("alert_mt")

	local settings = self.db.profile.alert_mt
	if not settings.enable then return end

	if IsInRaid() then
		-- raid START
		local raid = GetNumGroupMembers()
		if raid > 0 then
			local maintanktable
			local isBlizzMTs -- nil/false = ADDON | true = BLIZZARD
 
			-- CT_RA START
			if CT_RA_MainTanks then
				maintanktable = CT_RA_MainTanks
			end
			-- CT_RA END

			-- oRA2 START
			if oRA and oRA.maintanktable then
				maintanktable = oRA.maintanktable
			end
			-- oRA2 END

			-- oRA3 START
			if oRA3 and oRA3.GetSortedTanks then
				maintanktable = oRA3:GetSortedTanks()
			end
			-- oRA3 END

			local check
			local MTtotal = 0
			if maintanktable then
				for i = 1, 10 do
					if maintanktable[i] and maintanktable[i] ~= "" then
						MTtotal = MTtotal + 1
						check = true
					end
				end
			end

			if not check then
				maintanktable = nil
			end

			-- Blizzard START
			if not maintanktable then
				maintanktable = {}
				local x = 1
				for i = 1, raid do
					local name, _, _, _, _, _, _, _, _, role = GetRaidRosterInfo(i)
					if name and role and role == "MAINTANK" then
						maintanktable[x] = name
						MTtotal = MTtotal + 1
						x = x + 1
						if x > 10 then
							break
						end
					end
				end
				if maintanktable[1] then
					isBlizzMTs = true
				else
					maintanktable = nil
				end
			end
			-- Blizzard END

			if not maintanktable then return end

			-- update status START
			local MTicon
			if settings.general then
				MTicon = "Interface\\GroupFrame\\UI-Group-MainTankIcon"
			else
				MTicon = "Interface\\AddOns\\GridStatusMTs\\icons\\mt.tga"
			end
			local MTtext = L["MT"]
			local MTcount = 0

			for guid in GridRoster:IterateRoster() do
				local name, realmname = GridRoster:GetNameByGUID(guid)
				if realmname then
					realmname = name.."-"..realmname
				end

				for i = 1, 10 do
					if maintanktable[i] and (maintanktable[i] == name or maintanktable[i] == realmname) then
						if not isBlizzMTs then
							if settings.numbered then
								MTicon = "Interface\\GroupFrame\\UI-Group-MainTankIcon"
							else
								MTicon = "Interface\\AddOns\\GridStatusMTs\\icons\\mt"..i..".tga"
							end
							MTtext = L["MT"]..i
						end
						self.core:SendStatusGained(guid, "alert_mt",
							settings.priority,
							(settings.range and 40),
							{ r = settings.color.r, g = settings.color.g, b = settings.color.b, a = settings.opacity or 1, ignore = true },
							MTtext,
							nil,
							nil,
							MTicon)
						MTcount = MTcount + 1
					end
				end

				if MTcount == MTtotal then
					break
				end

			end
			-- update status END
			return
		end
		-- raid END
	elseif IsInGroup() then
		-- party START
		if GetNumGroupMembers() > 0 then
			local TankGUID
			for i = 0, 4 do
				local unit = "party"..i
				if i == 0 then
					unit = "player"
				end
				local role = UnitGroupRolesAssigned(unit)
				if role and role == "TANK" then
					TankGUID = UnitGUID(unit)
					break
				end
			end

			if not TankGUID then return end

			local MTicon
			if settings.general then
				MTicon = "Interface\\GroupFrame\\UI-Group-MainTankIcon"
			else
				MTicon = "Interface\\AddOns\\GridStatusMTs\\icons\\mt.tga"
			end

			self.core:SendStatusGained(TankGUID, "alert_mt",
				settings.priority,
				(settings.range and 40),
				{ r = settings.color.r, g = settings.color.g, b = settings.color.b, a = settings.opacity or 1, ignore = true },
				L["MT"],
				nil,
				nil,
				MTicon)
		end
		-- party END
	end
end