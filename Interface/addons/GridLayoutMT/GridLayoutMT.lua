-- Grid Main Tank Layouts from either oRA2 or Blizzard tank lists
-- Author: Szandos, based on GridLayoutMT by SquishemHard (aka LiquidEnforcer) and GridStatusMTs by Kunda
local GridLayout = Grid:GetModule("GridLayout")
local GridLayoutMT = Grid:GetModule("GridStatus"):NewModule("GridLayoutMT")

--Setup initial layouts
GridLayoutMT.Layout1 = {
	[1] = {nameList = "",
        	sortMethod = "INDEX",},
	[2] = {groupFilter = "1",},
	[3] = {groupFilter = "2",},
	[4] = {groupFilter = "1,2",
		isPetGroup = true,
		unitsPerColumn = 5,
		maxColumns = 2,
		},
}

GridLayoutMT.Layout2 = {
	[1] = {nameList = "",
        	sortMethod = "INDEX",},
	[2] = {groupFilter = "1",},
	[3] = {groupFilter = "2",},
	[4] = {groupFilter = "3",},
	[5] = {groupFilter = "4",},
	[6] = {groupFilter = "5",},
	[7] = {groupFilter = "1,2,3,4,5",
		isPetGroup = true,
		unitsPerColumn = 5,
		maxColumns = 5,
		},
}

GridLayoutMT.Layout3 = {
	[1] = {nameList = "",
        	sortMethod = "INDEX",},
	[2] = {groupFilter = "1",},
	[3] = {groupFilter = "2",},
	[4] = {groupFilter = "3",},
	[5] = {groupFilter = "4",},
	[6] = {groupFilter = "5",},
	[7] = {groupFilter = "6",},
	[8] = {groupFilter = "7",},
	[9] = {groupFilter = "8",},
	[10] = {groupFilter = "1,2,3,4,5,6,7,8",
		isPetGroup = true,
		unitsPerColumn = 5,
		maxColumns = 5,
		},
}

GridLayoutMT.Layout4 = {
	[1] = {nameList = "",
        	sortMethod = "INDEX",},
	[2] = {groupFilter = "1",},
	[3] = {groupFilter = "2",},
}

GridLayoutMT.Layout5 = {
	[1] = {nameList = "",
        	sortMethod = "INDEX",},
	[2] = {groupFilter = "1",},
	[3] = {groupFilter = "2",},
	[4] = {groupFilter = "3",},
	[5] = {groupFilter = "4",},
	[6] = {groupFilter = "5",},
}

GridLayoutMT.Layout6 = {
	[1] = {nameList = "",
        	sortMethod = "INDEX",},
	[2] = {groupFilter = "1",},
	[3] = {groupFilter = "2",},
	[4] = {groupFilter = "3",},
	[5] = {groupFilter = "4",},
	[6] = {groupFilter = "5",},
	[7] = {groupFilter = "6",},
	[8] = {groupFilter = "7",},
	[9] = {groupFilter = "8",},
}

GridLayoutMT.Layout7 = {
	[1] = {nameList = "",
        	sortMethod = "INDEX",},
	[2] = {groupFilter = "0",},
	[3] = {groupFilter = "1",},
	[4] = {groupFilter = "2",},
	[5] = {groupFilter = "1,2",
		isPetGroup = true,
		unitsPerColumn = 5,
		maxColumns = 2,
		},
}

GridLayoutMT.Layout8 = {
	[1] = {nameList = "",
        	sortMethod = "INDEX",},
	[2] = {groupFilter = "0",},
	[3] = {groupFilter = "1",},
	[4] = {groupFilter = "2",},
	[5] = {groupFilter = "3",},
	[6] = {groupFilter = "4",},
	[7] = {groupFilter = "5",},
	[8] = {groupFilter = "1,2,3,4,5",
		isPetGroup = true,
		unitsPerColumn = 5,
		maxColumns = 5,
		},
}

GridLayoutMT.Layout9 = {
	[1] = {nameList = "",
        	sortMethod = "INDEX",},
	[2] = {groupFilter = "0",},
	[3] = {groupFilter = "1",},
	[4] = {groupFilter = "2",},
	[5] = {groupFilter = "3",},
	[6] = {groupFilter = "4",},
	[7] = {groupFilter = "5",},
	[8] = {groupFilter = "6",},
	[9] = {groupFilter = "7",},
	[10] = {groupFilter = "8",},
	[11] = {groupFilter = "1,2,3,4,5,6,7,8",
		isPetGroup = true,
		unitsPerColumn = 5,
		maxColumns = 5,
		},
}

GridLayoutMT.Layout10 = {
	[1] = {nameList = "",
        	sortMethod = "INDEX",},
	[2] = {groupFilter = "0",},
	[3] = {groupFilter = "1",},
	[4] = {groupFilter = "2",},
}

GridLayoutMT.Layout11 = {
	[1] = {nameList = "",
        	sortMethod = "INDEX",},
	[2] = {groupFilter = "0",},
	[3] = {groupFilter = "1",},
	[4] = {groupFilter = "2",},
	[5] = {groupFilter = "3",},
	[6] = {groupFilter = "4",},
	[7] = {groupFilter = "5",},
}

GridLayoutMT.Layout12 = {
	[1] = {nameList = "",
        	sortMethod = "INDEX",},
	[2] = {groupFilter = "0",},
	[3] = {groupFilter = "1",},
	[4] = {groupFilter = "2",},
	[5] = {groupFilter = "3",},
	[6] = {groupFilter = "4",},
	[7] = {groupFilter = "5",},
	[8] = {groupFilter = "6",},
	[9] = {groupFilter = "7",},
	[10] = {groupFilter = "8",},
}

GridLayoutMT.Layout13 = {
	[1] = {nameList = "",
        	sortMethod = "INDEX",},
	[2] = {groupFilter = "1",},
	[3] = {groupFilter = "1",
		isPetGroup = true,
		unitsPerColumn = 5,
		maxColumns = 1,
		},
}

--Add initial layouts to GridLayout
GridLayout:AddLayout("Tanks + 10 w/Pets", GridLayoutMT.Layout1)
GridLayout:AddLayout("Tanks + 25 w/Pets", GridLayoutMT.Layout2)
GridLayout:AddLayout("Tanks + 40 w/Pets", GridLayoutMT.Layout3)
GridLayout:AddLayout("Tanks + 10", GridLayoutMT.Layout4)
GridLayout:AddLayout("Tanks + 25", GridLayoutMT.Layout5)
GridLayout:AddLayout("Tanks + 40", GridLayoutMT.Layout6)
GridLayout:AddLayout("Wide Tanks + 10 w/Pets", GridLayoutMT.Layout7)
GridLayout:AddLayout("Wide Tanks + 25 w/Pets", GridLayoutMT.Layout8)
GridLayout:AddLayout("Wide Tanks + 40 w/Pets", GridLayoutMT.Layout9)
GridLayout:AddLayout("Wide Tanks + 10", GridLayoutMT.Layout10)
GridLayout:AddLayout("Wide Tanks + 25", GridLayoutMT.Layout11)
GridLayout:AddLayout("Wide Tanks + 40", GridLayoutMT.Layout12)
GridLayout:AddLayout("Tanks + 5 w/Pets", GridLayoutMT.Layout13)


--Addon starting point
function GridLayoutMT:OnEnable()
	--Register events to catch
	self:RegisterEvent("oRA_MainTankUpdate", "UpdateMainTankTable")
	self:RegisterEvent("RAID_ROSTER_UPDATE", "UpdateMainTankTable")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateMainTankTable")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", "UpdateMainTankTable")
	self:RegisterEvent("PLAYER_ROLES_ASSIGNED", "UpdateMainTankTable")
	self:UpdateMainTankTable()
end

-- Triggered Update
function GridLayoutMT:UpdateMainTankTable()
	local maintanktable

	-- Add raid tanks
	if oRA then
		if oRA.maintanktable then
			maintanktable = oRA.maintanktable
			if #maintanktable == 0 then 
				maintanktable = nil
			end
		end
	end
	if not maintanktable then
		maintanktable = {}
		local x = 1
		local raid = GetNumRaidMembers()
		if raid > 0 then
			for i = 1, raid do
				local name, _, _, _, _, _, _, _, _, role = GetRaidRosterInfo(i)
				if name and role and role == "MAINTANK" then
					maintanktable[x] = name
					x = x + 1
					if x > 10 then
						break
					end
				end
			end
		end
		if #maintanktable == 0 then 
			maintanktable = nil
		end
	end	
	
	-- Add party tanks
	if not maintanktable then
		maintanktable = {}
		local x = 1
		local partynum = GetNumPartyMembers()
		if partynum > 0 then 
   			for i = 1, partynum do
      				local role = UnitGroupRolesAssigned("party" .. i) 
      				if role == "TANK" then
                    			maintanktable[x], _ = UnitName("party".. i)
                    			x = x + 1
				end
   			end
			if x == 1 then
				local role = UnitGroupRolesAssigned("player")
				if role == "TANK" then
					maintanktable[x], _ = UnitName("player")
				end
			end
		end
	end
	self:MainTankUpdate(maintanktable)
end

--Main Tank list update function
function GridLayoutMT:MainTankUpdate(maintanktable)
	local mts = {}
	local showmt
	local tanklist = ""

	--Copy non-empty elements to new table
	for i = 1, 10 do
		if maintanktable[i] then
			table.insert(mts, maintanktable[i])
		end
	end
    
	tanklist = table.concat(mts, ",")
	
	-- Update if we got differences in the mt list
	if GridLayoutMT.Layout1[1].nameList ~= tanklist then
		--Set layout nameList to new list
		GridLayoutMT.Layout1[1].nameList = tanklist    
		GridLayoutMT.Layout2[1].nameList = tanklist
		GridLayoutMT.Layout3[1].nameList = tanklist  
		GridLayoutMT.Layout4[1].nameList = tanklist    
		GridLayoutMT.Layout5[1].nameList = tanklist
		GridLayoutMT.Layout6[1].nameList = tanklist	
		GridLayoutMT.Layout7[1].nameList = tanklist    
		GridLayoutMT.Layout8[1].nameList = tanklist
		GridLayoutMT.Layout9[1].nameList = tanklist  
		GridLayoutMT.Layout10[1].nameList = tanklist    
		GridLayoutMT.Layout11[1].nameList = tanklist
		GridLayoutMT.Layout12[1].nameList = tanklist
		GridLayoutMT.Layout13[1].nameList = tanklist

		GridLayout:ReloadLayout()
	end
end