--[[
	Gatherer Addon for World of Warcraft(tm).
	Version: 2.99.0.0498 (eagle)
	Revision: $Id: GatherStorage.lua 493 2007-02-18 08:29:29Z esamynn $

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit licence to use this AddOn with these facilities
		since that is it's designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat

	Library for accessing and updating the database
--]]
Gatherer_RegisterRevision("$URL: http://norganna.org/svn/gatherer/trunk/GatherStorage.lua $", "$Rev: 493 $")

--------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------
-- Node Indexing
local POS_X = 1
local POS_Y = 2
local COUNT = 3
local HARVESTED = 4
local INSPECTED = 5
local SOURCE = 6

-- Current Database Version
local dbVersion = 2

--------------------------------------------------------------------------
-- Data Table
--------------------------------------------------------------------------

local globalName = "GatherItems"
local data

--------------------------------------------------------------------------
-- Global Library Table with a local pointer
--------------------------------------------------------------------------

local lib = Gatherer.Storage

-- reference to the Astrolabe mapping library
local Astrolabe = DongleStub(Gatherer.AstrolabeVersion)

local ZoneData = {}
local continents = {GetMapContinents()}
for index, name in ipairs(continents) do
	ZoneData[index] = {GetMapZones(index)}
	ZoneData[index].name = name
end

--[[
##########################################################################
 Regular Library Functions
##########################################################################
--]]

--************************************************************************
-- This returns the raw data table, BE CAREFUL WITH IT!!!!
--************************************************************************
--
function lib.GetRawDataTable()
	return data
end
--]]

local validGatherTypes = {
	MINE = "MINE",
	HERB = "HERB",
	OPEN = "OPEN",
}
function lib.AddNode(nodeName, gatherType, continent, zone, gatherX, gatherY, source, incrementCount)
	if not (continent and zone and gatherX and gatherY) then return end
	local zoneToken = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
	zone = Gatherer.ZoneTokens.GetZoneIndex(continent, zone)
	-- check for invalid location information
	if not ( (continent > 0) and zoneToken and (gatherX > 0) and (gatherY > 0) ) then return end
	local gatherType = validGatherTypes[gatherType]

	if not (data[continent]) then data[continent] = { }; end
	if not (data[continent][zoneToken]) then data[continent][zoneToken] = { }; end
	if not (data[continent][zoneToken][nodeName]) then data[continent][zoneToken][nodeName] = { gtype = gatherType }; end
	local gatherTable = data[continent][zoneToken][nodeName]

	if not ( gatherType ) then
		gatherType = Gatherer.Nodes.Objects[nodeName]
	end
	if not ( gatherTable.gtype ) then
		gatherTable.gtype = gatherType
	end
	
	local index, node

	for i, gatherData in ipairs(gatherTable) do
		local dist = Astrolabe:ComputeDistance(continent, zone, gatherX, gatherY, continent, zone, gatherData[POS_X], gatherData[POS_Y])
		if ( dist < 10 ) then
			node = gatherData
			index = i
			break
		end
	end

	if ( node ) then
		local count = node[COUNT]
		-- Do a proper average of the node position
		gatherX = (gatherX + (node[POS_X] * count)) / (count + 1)
		gatherY = (gatherY + (node[POS_Y] * count)) / (count + 1)
	else
		node = { [POS_X]=0, [POS_Y]=0, [COUNT]=0, [HARVESTED]=0, [INSPECTED]=0, [SOURCE]=source }
		table.insert(gatherTable, node)
		index = table.getn(gatherTable)
	end

	if (node[SOURCE] and node[SOURCE] ~= source) then
		node[SOURCE] = nil
	end

	node[POS_X] = gatherX
	node[POS_Y] = gatherY
	if ( incrementCount ) then
		node[COUNT] = node[COUNT] + 1
	end

	local now = time()

	-- Update last harvested time (and inspected time as well)
	node[HARVESTED] = now
	if (not node[SOURCE]) then
		node[INSPECTED] = now
	end

	-- Return the indexed position
	return index
end

function lib.ClearDatabase( noCollection )
	data = { dbVersion = dbVersion }
	if not ( noCollection ) then
		collectgarbage()
	end
end

function lib.HasDataOnZone( continent, zone )
	zone = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
	if ( lib.HasDataOnContinent(continent) and data[continent][zone] ) then
		return true
	else
		return false
	end
end

function lib.HasDataOnContinent( continent )
	if ( data[continent] ) then
		return true
	else
		return false
	end
end

function lib.IsGatherInZone( continent, zone, gatherName )
	zone = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
	if ( lib.HasDataOnZone(continent, zone) and data[continent][zone][gatherName] ) then
		return true
	else
		return false
	end
end

-- Returns 2 values
-- 1) the number of nodes in a zone
-- 2) the total of the count values for all nodes in the zone
--------------------------------------------------------------------------
function lib.GetNodeCounts( continent, zone )
	zone = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
	local countTotal = 0
	local nodeCount = 0

	if ( data[continent] and data[continent][zone] ) then
		for gather, nodes in pairs(data[continent][zone]) do
			for key, node in pairs(nodes) do
				if ( key ~= "gtype" and key ~= "icon" ) then
					countTotal = countTotal + node[COUNT]
					nodeCount = nodeCount + 1
				end
			end
		end
	end
	return nodeCount, countTotal
end



-- Returns the number of nodes of the given gather name in the specified zone
--------------------------------------------------------------------------
function lib.GetGatherCountsForZone( continent, zone, gatherName )
	zone = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
	if ( data[continent] and data[continent][zone] and data[continent][zone][gatherName] ) then
		return table.getn(data[continent][zone][gatherName])
	else
		return 0
	end
end


-- Returns the count of nodes for each "Gather Type" in the zone specified
-- the return order is
--------------------------------------------------------------------------
local nodeCountsByType = { OPEN=0, HERB=0, MINE=0, unknown=0, }

function lib.GetNodeCountsByGatherType( continent, zone )
	zone = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
	for k, v in pairs(nodeCountsByType) do
		nodeCountsByType[k] = 0
	end

	if ( lib.HasDataOnZone(continent, zone) ) then
		for gather, nodes in pairs(data[continent][zone]) do
			local gtype = nodes.gtype
			if ( nodeCountsByType[gtype] ) then
				nodeCountsByType[gtype] = nodeCountsByType[gtype] + table.getn(nodes)
			else
				nodeCountsByType.unknown = nodeCountsByType.unknown + table.getn(nodes)
			end
		end
	end
	return nodeCountsByType.OPEN,
	       nodeCountsByType.HERB,
	       nodeCountsByType.MINE,
	       nodeCountsByType.unknown
end


-- Returns information on a specific node
--
-- Return Values:
-- x - the node's x coordinate value
-- y - the node's y coordinate value
-- count - the node's count value
-- gtype - gather type of this node
-- lastHarvested - time at which the node was last harvested
-- lastInspected - time at which the node was last inspected
-- source - the source of this node
--------------------------------------------------------------------------
function lib.GetNodeInfo( continent, zone, gatherName, index )
	zone = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
	if ( lib.IsGatherInZone(continent, zone, gatherName) ) then
		local info = data[continent][zone][gatherName][index]
		if ( info ) then
			return info[POS_X],
			       info[POS_Y],
			       info[COUNT],
			       data[continent][zone][gatherName].gtype,
			       info[HARVESTED] or 0,
			       info[INSPECTED] or 0,
			       info[SOURCE]
		end
	end
end

function lib.SetNodeInspected( continent, zone, nodeid, index )
	zone = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
	if ( lib.IsGatherInZone(continent, zone, nodeid) ) then
		local node = data[continent][zone][nodeid][index]
		if ( node and (not node[SOURCE]) ) then
			node[INSPECTED] = time()
		end
	end
end

function lib.GetNodeInspected( continent, zone, nodeid, index )
	zone = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
	if ( lib.IsGatherInZone(continent, zone, nodeid) ) then
		local node = data[continent][zone][nodeid][index]
		if ( node ) then
			return node[INSPECTED]
		end
	end
end

function lib.SetNodeBuggedState( continent, zone, gatherName, index, bugged )
	zone = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
	if ( lib.IsGatherInZone(continent, zone, gatherName) ) then
		local node = data[continent][zone][gatherName][index]
		if ( node ) then
			if ( bugged == nil ) then
				if ( node.bugged ) then
					bugged = nil
				else
					bugged = true
				end
			end
			node.bugged = true
			return bugged
		end
	end
end


function lib.IsNodeBugged( continent, zone, gatherName, index )
	zone = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
	if ( lib.IsGatherInZone(continent, zone, gatherName) ) then
		local node = data[continent][zone][gatherName][index]
		if ( node ) then
			if ( node.bugged ) then
				return true
			else
				return false
			end
		end
	end
end


--[[
##########################################################################
 Iterators
##########################################################################
--]]
local EmptyIterator = function() end

local iteratorStateTables = {}
setmetatable(iteratorStateTables, { __mode = "k" }); --weak keys

--------------------------------------------------------------------------
-- iterator work table cache
--------------------------------------------------------------------------

local workTableCache = { {}, {}, {}, {}, }; -- initial size of 4 tables

local function getWorkTablePair()
	if ( table.getn(workTableCache) < 2 ) then
		table.insert(workTableCache, {})
		table.insert(workTableCache, {})
	end
	local index = table.remove(workTableCache)
	local state = table.remove(workTableCache)
	iteratorStateTables[index] = state
	return index, state
end

local function releaseWorkTablePair( index )
	local data = iteratorStateTables[index]
	if ( data ) then
		iteratorStateTables[index] = nil
		for k, v in pairs(index) do
			index[k] = nil
		end
		for k, v in pairs(data) do
			data[k] = nil
		end
		table.insert(workTableCache, index)
		table.insert(workTableCache, data)
	end
end

local function getWorkTable()
	if ( table.getn(workTableCache) < 1 ) then
		table.insert(workTableCache, {})
	end
	local workTable = table.remove(workTableCache)
	iteratorStateTables[workTable] = false
	return workTable
end

local function releaseWorkTable( workTable )
	if ( iteratorStateTables[workTable] == false ) then
		iteratorStateTables[workTable] = nil
		for k, v in pairs(workTable) do
			workTable[k] = nil
		end
		table.insert(workTableCache, workTable)
	end
end



-- Iterates over the contienent or the zones of a continent and returns
-- the indices for which Gatherer has data
--------------------------------------------------------------------------
do --create a new block

	local function iterator( iteratorData, lastIndex )
		if not ( iteratorData and lastIndex ) then return end --not enough information

		lastIndex = lastIndex + 1
		if ( iteratorData[lastIndex] ) then
			return lastIndex, iteratorData[lastIndex]
		else
			releaseWorkTable(iteratorData)
			return; --no data left
		end
	end


	function lib.GetAreaIndices( continent )
		local dataTable

		if ( continent and lib.HasDataOnContinent(continent) ) then
			dataTable = data[continent]
		else
			dataTable = data
		end
		if not ( dataTable ) then return EmptyIterator; end -- no data
		
		local iteratorData = getWorkTable()
		if ( continent ) then
			local GetZoneIndex = Gatherer.ZoneTokens.GetZoneIndex
			for i in pairs(dataTable) do
				if ( lib.HasDataOnZone(continent,i) ) then
					tinsert(iteratorData, GetZoneIndex(continent, i))
				end
			end
		else
			for i in pairs(dataTable) do
				if ( lib.HasDataOnContinent(i) ) then
					tinsert(iteratorData, i)
				end
			end
		end
		table.sort(iteratorData)
		return iterator, iteratorData, 0
	end

end -- end the block

-- Iterates over the node types in a zone returning data on each type
-- The interator returns the following data on each node
-- gatherName - loot name
-- gType - Gather type
-- num - number of nodes of that type
--------------------------------------------------------------------------
do --create a new block

	local function iterator( stateIndex, lastGatherName )
		local state = iteratorStateTables[stateIndex]
		if not ( state ) then return end; --no data left

		local gatherName, gatherNodesTable = next(state.table, lastGatherName)
		if not ( gatherName ) then
			releaseWorkTablePair(stateIndex)
			return; --no data left
		end
		local gtype = gatherNodesTable.gtype
		return gatherName, gtype, table.getn(gatherNodesTable)
	end


	function lib.ZoneGatherNames( continent, zone )
		zone = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
		if ( lib.HasDataOnZone(continent, zone) ) then
			local stateIndex, state = getWorkTablePair()
			state.table = data[continent][zone]

			return iterator, stateIndex, nil
		end
		--safety
		return EmptyIterator
	end

end -- end the block

-- Iterates over the nodes of a specific type in a zone
-- The interator returns the following data on each node
--
-- index - for direct access to this node's information
-- x - the node's x coordinate value
-- y - the node's y coordinate value
-- count - the node's count value
--------------------------------------------------------------------------
do --create a new block

	local function iterator( stateIndex, lastNodeIndex )
		local state = iteratorStateTables[stateIndex]
		if not ( state ) then return end; --no data left

		local nodeIndex, info = state.iterator(state.stateInfo, lastNodeIndex)
		if not ( info ) then
			releaseWorkTablePair(stateIndex)
			return; --no data left
		end
		return nodeIndex, info[POS_X], info[POS_Y], info[COUNT]
	end


	function lib.ZoneGatherNodes( continent, zone, gatherName )
		zone = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
		if ( lib.IsGatherInZone(continent, zone, gatherName) ) then
			local stateIndex, state = getWorkTablePair()
			state.iterator, state.stateInfo = ipairs(data[continent][zone][gatherName])

			return iterator, stateIndex, 0
		end
		--safety
		return EmptyIterator
	end

end -- end the block

-- Closest Nodes
-- Returns an iterator
--------------------------------------------------------------------------
do --create a new block

	local function iterator( iteratorData, lastIndex )
		if not ( iteratorData and lastIndex ) then return end --not enough information

		lastIndex = lastIndex + 1
		local nodeIndex = lastIndex * 3
		if ( iteratorData[nodeIndex] ) then
			return lastIndex,
			       iteratorData.continent,
			       iteratorData.zone,
			       iteratorData[nodeIndex - 2],
			       iteratorData[nodeIndex - 1],
			       iteratorData[nodeIndex]
		else
			releaseWorkTable(iteratorData)
			return; --no data left
		end
	end


	-- working tables
	local nodeNames = {}
	local nodeIndex = {}
	local distances = {}

	function lib.ClosestNodes( continent, zone, xPos, yPos, num, maxDist, filter )
		local zoneToken = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
		-- return if the position is invalid or we have no data on the specified zone
		if not ( lib.HasDataOnZone(continent, zone) and xPos > 0 and yPos > 0 ) then
			return EmptyIterator
		end

		local iteratorData = getWorkTable()
		iteratorData.continent = continent
		iteratorData.zone = zone

		if ( type(filter) == "function" ) then
			--do nothing

		elseif ( type(filter) == "table" ) then
			local filterTable = filter
			filter = (
				function( nodeId, gatherType )
					if not ( filterTable[gatherType] ) then
						return false

					elseif ( filterTable[gatherType] == true ) then
						return true

					else
						return filterTable[gatherType][nodeId]

					end
				end
			)

		elseif ( filter == nil or filter ) then
			filter = true

		else
			return EmptyIterator

		end

		for i in ipairs(nodeNames) do
			nodeNames[i] = nil
			nodeIndex[i] = nil
			distances[i] = nil
		end

		local zoneData = data[continent][zoneToken]
		xPos = xPos
		yPos = yPos
		for gatherName, nodesList in pairs(zoneData) do
			if ( (filter == true) or filter(gatherName, nodesList.gtype) ) then
				for index, nodeData in ipairs(nodesList) do
					if not ( lib.IsNodeBugged(continent, zone, gatherName, index) ) then
						local nodeX, nodeY = nodeData[POS_X], nodeData[POS_Y]
						if ( (nodeX ~= 0) and (nodeY ~= 0) ) then
							local dist = Astrolabe:ComputeDistance(continent, zone, xPos, yPos, continent, zone, nodeX, nodeY)

							if ( (maxDist == 0) or (dist < maxDist) ) then
								local insertPoint = 1

								for i, nodeName in ipairs(nodeNames) do
									if not ( distances[i+1] ) then
										insertPoint = i + 1
										break

									elseif ( distances[i] > dist ) then
										insertPoint = i
										break

									end
								end
								if ( insertPoint <= num) then
									tinsert(nodeNames, insertPoint, gatherName)
									tinsert(nodeIndex, insertPoint, index)
									tinsert(distances, insertPoint, dist)
									local limit = num + 1
									nodeNames[limit] = nil
									nodeIndex[limit] = nil
									distances[limit] = nil
								end
							end
						end
					end
				end
			end
		end

		for i, nodeName in ipairs(nodeNames) do
			local dist = math.floor(distances[i]*100)/100
			tinsert(iteratorData, nodeName)
			tinsert(iteratorData, nodeIndex[i])
			tinsert(iteratorData, dist)
		end

		return iterator, iteratorData, 0
	end

end -- end the block

-- Closest Nodes Info
-- Returns an iterator
--------------------------------------------------------------------------
do --create a new block

	local function iterator( iteratorData, lastIndex )
		if not ( iteratorData and lastIndex ) then return end --not enough information

		lastIndex = lastIndex + 1
		local nodeIndex = lastIndex * 3
		if ( iteratorData[nodeIndex] ) then
			local continent, zone, nodeName, index, dist = iteratorData.continent, iteratorData.zone, iteratorData[nodeIndex - 2], iteratorData[nodeIndex - 1], iteratorData[nodeIndex]

			return lastIndex, continent, zone, nodeName, index, dist, lib.GetNodeInfo(continent, zone, nodeName, index)
		else
			releaseWorkTable(iteratorData)
			return; --no data left
		end
	end


	function lib.ClosestNodesInfo( continent, zone, xPos, yPos, num, maxDist, filter )
		local f, iteratorData, var = lib.ClosestNodes(continent, zone, xPos, yPos, num, maxDist, filter)

		if ( f == EmptyIterator ) then
			return f
		else
			return iterator, iteratorData, var
		end
	end

end -- end the block


--------------------------------------------------------------------------
-- Event Frame to import/export the data table from/to the global
-- namespace when appropriate
--------------------------------------------------------------------------

local eventFrame = CreateFrame("Frame")

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_LOGOUT")

eventFrame:SetScript("OnEvent", function( frame, event, arg1 )
	if ( event == "ADDON_LOADED" and strlower(arg1) == "gatherer" ) then
		local savedData = getglobal(globalName)
		if ( savedData ) then
			getfenv(0)[globalName] = nil
			if ( savedData.dbVersion == nil ) then --old, unversioned Database
				savedData.dbVersion = 0
			end
			if ( type(savedData.dbVersion) == "number" ) then
				if ( dbVersion == savedData.dbVersion ) then --database is current, no conversion needed
					data = savedData
					
					-- perform any needed node id re-mappings
					if ( Gatherer.Nodes.ReMappings ) then
						local remap = Gatherer.Nodes.ReMappings
						local dataToImport = { dbVersion = dbVersion }
						for continent, contData in pairs(data) do
							if ( type(contData) == "table" ) then
								for zoneToken, zoneData in pairs(contData) do
									for nodeId, nodes in pairs(zoneData) do
										if ( remap[nodeId] ) then
											if not (dataToImport[continent]) then dataToImport[continent] = { }; end
											if not (dataToImport[continent][zoneToken]) then dataToImport[continent][zoneToken] = { }; end
											dataToImport[continent][zoneToken][nodeId] = nodes
											data[continent][zoneToken][nodeId] = nil
										end
									end
								end
							end
						end
						lib.ImportDatabase(dataToImport)
					end

				elseif ( savedData.dbVersion < dbVersion ) then --old database, conversion needed
					lib.ImportDatabase(savedData)
					--check for "set aside" database that needs merging

					savedData = nil
					collectgarbage(); --reclaim the old database

				elseif ( savedData.dbVersion > dbVersion ) then	--database TOO new (Old Gatherer Version)
					--set the database aside and warn the user

				end
			else
				--INVALID DATABASE VERSION, raise an error
			end
		else
			lib.ClearDatabase( true ); --don't run garbage collection
		end

	elseif ( event == "PLAYER_LOGOUT" ) then
		getfenv(0)[globalName] = data

	end
end)

local function MergeNode(gather, gatherType, continent, zone, gatherX, gatherY, count, harvested, inspected, source)
	if not ( gather and gatherType and continent and zone and gatherX and gatherY ) then
		return -- not enough data
	end
	local index = lib.AddNode(gather, gatherType, continent, zone, gatherX, gatherY, (source or "IMPORTED"), false)
	local zone = Gatherer.ZoneTokens.GetZoneToken(continent, zone)
	if ( count ) then
		data[continent][zone][gather][index][COUNT] = data[continent][zone][gather][index][COUNT] + count
	end
	if ( harvested ) then
		data[continent][zone][gather][index][HARVESTED] = harvested
	else
		data[continent][zone][gather][index][HARVESTED] = 0
	end
	if ( inspected ) then
		data[continent][zone][gather][index][INSPECTED] = inspected
	else
		data[continent][zone][gather][index][INSPECTED] = 0
	end
end


function lib.ImportDatabase( database )
	if not ( data ) then
		lib.ClearDatabase( true ); --don't run garbage collection
	end
	if ( database.dbVersion <= 1 ) then
		Gatherer.Convert.RenumberDatabaseZonesForBCExpansion(database)
	end
	Gatherer.Convert.ImportDatabase(database, MergeNode)
end

function Gatherer.Storage.Clear()
	Gatherer.Util.Print("Clearing your gather data")
	Gatherer.Storage.ClearDatabase()
	ClosestList = { }
	ClosestSearchGather = ""
	Gatherer.MiniNotes.UpdateMinimapNotes(0,true)
	Gatherer.MapNotes.MapDraw()
end
