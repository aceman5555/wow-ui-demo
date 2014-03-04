--[[
	Gatherer Report/Search UI
	Revision: $Id: GathererInfo.lua 473 2007-02-09 07:06:29Z esamynn $

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
]]--


-- Scrolling variables
GATHERERINFO_TO_DISPLAY=15
GATHERERINFO_FRAME_HEIGHT=15
GATHERERINFO_SUBFRAMES = { "GathererInfo_ReportFrame", "GathererInfo_SearchFrame" }

-- Defaults
currentNode = ""
GathererInfo_LastSortType = "gtype"
GathererInfo_LastSearchSortType= "Cname"
GathererInfo_AutoRegion = true
GathererInfo_LastSortReverse = false

GathererInfoContinents = {}
GathererInfoZones = {}

numGathererInfo = 0
GI_totalCount = 0

GITT = {}


-- show display frame
function showGathererInfo(tab)
	local myTab = 1
	if ( tab ) then myTab = tab; end

	if ( not GathererInfo_DialogFrame:IsShown() ) then
		GathererInfo_DialogFrame:Show()
		PanelTemplates_SetTab(GathererInfo_DialogFrame, myTab)
		ToggleGathererInfo_Dialog(GATHERERINFO_SUBFRAMES[myTab])
	else
		GathererInfo_DialogFrame:Hide()
	end
end

function GathererInfo_LoadContinents(...)
	for c=1, arg.n, 1 do
		GathererInfoContinents[c] = {}
		GathererInfoContinents[c] = arg[c]
		GathererInfoContinents[arg[c]] = c
		GathererInfo_LoadZones(c, GetMapZones(c))
	end
end

function GathererInfo_LoadZones(c, ...)
	if ( not GathererInfoZones[c] ) then GathererInfoZones[c] = {}; end
	for z=1, arg.n, 1 do
		local zname = arg[z]
		GathererInfoZones[c][zname] = z
		GathererInfoZones[c][z] = zname
	end
end
-- ********************************************************************
-- dropdown menu functions
-- Continent
function GathererInfo_LocContinentDropDown_Initialize()
	local index
	local info = {}

	for _, continent in Gatherer.Storage.GetAreaIndices() do
		-- grab zone text from table initiated by Gatherer Main
		info.text = GathererInfoContinents[continent]
		info.checked = nil
		info.func = GathererInfo_LocContinentDropDown_OnClick
		UIDropDownMenu_AddButton(info)
	end
end

function GathererInfo_LocContinentDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(GathererInfo_LocContinentDropDown, this:GetID())
	UIDropDownMenu_SetSelectedID(GathererInfo_LocZoneDropDown, 0)

	UIDropDownMenu_SetText("", GathererInfo_LocZoneDropDown)

	UIDropDownMenu_ClearAll(GathererInfo_LocZoneDropDown)
	UIDropDownMenu_Initialize(GathererInfo_LocZoneDropDown, GathererInfo_LocZoneDropDown_Initialize)

	local j=1
	while (j < GATHERERINFO_TO_DISPLAY+1) do
		getglobal("GathererInfo_FrameButton"..j):Hide()
		j = j+1
	end
end

-- Zone
function GathererInfo_LocZoneDropDown_Initialize()
	local index
	local info = {}
	--local continentName =
	local continent = GathererInfoContinents[UIDropDownMenu_GetText(GathererInfo_LocContinentDropDown)]

	if ( continent ) then
		for _, zone in Gatherer.Storage.GetAreaIndices(continent) do
			-- grab zone text from table initiated by Gatherer Main
			info.text = GathererInfoZones[continent][zone]
			info.checked = nil
			info.value = zone
			info.func = GathererInfo_LocZoneDropDown_OnClick
			UIDropDownMenu_AddButton(info)
		end
	end
end

function GathererInfo_LocZoneDropDown_OnClick()
	UIDropDownMenu_SetSelectedID(GathererInfo_LocZoneDropDown, this:GetID())

	GathererInfo_AutoRegion = false

	local gi_cont = GathererInfoContinents[UIDropDownMenu_GetText(GathererInfo_LocContinentDropDown)]
	local gi_zone = this.value;--GathererInfoZones[gi_cont][UIDropDownMenu_GetText(GathererInfo_LocZoneDropDown)]

	numGathererInfo, GI_totalCount = Gatherer.Storage.GetNodeCounts(gi_cont, gi_zone)

	GathererInfo_Update()
end

-- ********************************************************************
-- Display frame initialization
function GathererInfo_SetDefaultLocation()
	local continentName = GathererInfoContinents[GetCurrentMapContinent()]
	local zoneName = GetRealZoneText()
	local continent, zone = Gatherer_GetCurrentZone()

	if ( GathererInfo_AutoRegion and Gatherer.Storage.HasDataOnZone(continent, zone) ) then
		UIDropDownMenu_SetSelectedName(GathererInfo_LocContinentDropDown, continentName)
		UIDropDownMenu_SetText(continentName, GathererInfo_LocContinentDropDown)

		UIDropDownMenu_SetSelectedName(GathererInfo_LocZoneDropDown, zoneName)
		UIDropDownMenu_SetText(zoneName, GathererInfo_LocZoneDropDown)

		numGathererInfo, GI_totalCount = Gatherer.Storage.GetNodeCounts(gi_cont, gi_zone)
		GathererInfo_Update()
	end
end


local typeNodeCount = {}
-- update display frame relative to scrollbar
function GathererInfo_Update()
	local node_idx, index
	local gatherInfoOffset = FauxScrollFrame_GetOffset(GathererInfo_ListScrollFrame)
	local gi_cont, gi_zone, gi_loc
	local gatherInfoIndex
	local showScrollBar = nil
	local button

	-- Get continent, zone
	if ( UIDropDownMenu_GetText(GathererInfo_LocContinentDropDown) and
		 UIDropDownMenu_GetText(GathererInfo_LocContinentDropDown) ~= "")
	then
		gi_cont = GathererInfoContinents[UIDropDownMenu_GetText(GathererInfo_LocContinentDropDown)]
	else
		gi_cont = GetCurrentMapContinent()
	end

	if ( UIDropDownMenu_GetText(GathererInfo_LocZoneDropDown) and
		 UIDropDownMenu_GetText(GathererInfo_LocZoneDropDown) ~= "")
	then
		gi_zone = GathererInfoZones[gi_cont][UIDropDownMenu_GetText(GathererInfo_LocZoneDropDown)]
	else
		if ( GetRealZoneText() and GathererInfoZones[gi_cont] and GathererInfoZones[gi_cont][GetRealZoneText()] ) then
			gi_zone = GathererInfoZones[gi_cont][GetRealZoneText()]
		else
			gi_zone = nil
		end
	end
	-- if loc exists in stored base
	if ( Gatherer.Storage.HasDataOnZone(gi_cont, gi_zone) ) then
		typeNodeCount["Treasure"],
			typeNodeCount["Herb"],
			typeNodeCount["Ore"],
			typeNodeCount["unknown"] = Gatherer.Storage.GetNodeCountsByGatherType(gi_cont, gi_zone)

		local i = 1
		for gatherName, gtype, amount, icon in Gatherer.Storage.ZoneGatherNames(gi_cont, gi_zone) do
			local info = GITT[i] or {}; GITT[i] = info
			info.name = gatherName
			info.gatherType = gtype
			info.typePercent  = amount / typeNodeCount[gtype] * 100
			info.densityPercent = amount / GI_totalCount * 100
			info.amount = amount
			info.texture  = icon
			info.nodeCount = typeNodeCount[gtype]
			info.gi = gatherInfoOffset + i
			i = i + 1
		end
		local lastGITTindex = i - 1
		GITT[i] = nil
		table.setn(GITT, lastGITTindex)
		SortGathererInfo(GathererInfo_LastSortType, false)
		GathererInfo_totalcount:SetText(string.gsub(string.gsub(GATHERER_REPORT_SUMMARY, "#", GI_totalCount), "&", numGathererInfo))
	end
end

-- Add items in display frame
function GathererInfo_additem_table(gatherName, gatherNumber, gatherTexture, gatherType, typePercent, densityPercent, GIlocation, GIIndex)

	if ( GIlocation < GATHERERINFO_TO_DISPLAY +1) then
		getglobal("GathererInfo_FrameButton"..GIlocation).gatherIndex = GIIndex
		getglobal("GathererInfo_FrameButton"..GIlocation.."Icon"):SetTexture(gatherTexture)
		getglobal("GathererInfo_FrameButton"..GIlocation.."Type"):SetText(gatherType)
		getglobal("GathererInfo_FrameButton"..GIlocation.."Gatherable"):SetText(gatherName)
		getglobal("GathererInfo_FrameButton"..GIlocation.."Number"):SetText(gatherNumber)
		getglobal("GathererInfo_FrameButton"..GIlocation.."TypePercent"):SetText(format("%.1f",typePercent))
		getglobal("GathererInfo_FrameButton"..GIlocation.."DensityPercent"):SetText(format("%.1f",densityPercent))
		getglobal("GathererInfo_FrameButton"..GIlocation):Show()
	end

end

-- **************************************************************************
-- Sort functions (common to Report and Search)
function SortGathererInfo(sortType, reverse, search)
	local compstr = {}
	local ref_ind = 0
	local ind, newind
	local displayed = 0
	local offSet = FauxScrollFrame_GetOffset(GathererInfo_ListScrollFrame)
	local key1, key2, key3
	local indexToShow=0
	local search_stub

	if (search) then
		search_stub = search
	else
		search_stub = ""
	end

	for ind in ipairs(GITT) do
		indexToShow = indexToShow + 1
		compstr[ind]= {}

		-- report sort types
		if ( sortType == "gtype" ) then -- keys: type, % per type, name (default sort)
			key1 = GITT[ind].gatherType
			key2 = format("%.6f", GITT[ind].typePercent / 10000)
			key3 = GITT[ind].name
		elseif ( sortType == "percent")	then -- keys: % per type, type, name
			key1 = format("%.6f", GITT[ind].typePercent / 10000)
			key2 = GITT[ind].gatherType
			key3 = GITT[ind].name
		elseif ( sortType == "density" ) then -- keys: % density, type, name
			key1 = format("%.6f", GITT[ind].densityPercent / 10000)
			key2 = GITT[ind].gatherType
			key3 = GITT[ind].name
		elseif ( sortType == "name" ) then -- keys: name, type, % type
			key1 = GITT[ind].name
			key2 = GITT[ind].gatherType
			key3 = format("%.6f", GITT[ind].typePercent / 10000)
		elseif ( sortType == "amount" )	then -- keys: amount, type, name
			key1 = format("%.6f", GITT[ind].amount / 10000)
			key2 = GITT[ind].gatherType
			key3 = GITT[ind].name
		elseif ( search_stub and search_stub ~= "" ) then
			offSet = FauxScrollFrame_GetOffset(GathererInfo_SearchListScrollFrame)
			-- handle Search sort types
			if ( sortType == "Cname" ) then
				key1 = GITT[ind].contName
				key2 = GITT[ind].zoneName
				key3 = format("%.6f", GITT[ind].amount / 10000)
			elseif ( sortType == "Zname" ) then
				key1 = GITT[ind].zoneName
				key2 = GITT[ind].contName
				key3 = format("%.6f", GITT[ind].amount / 10000)
			elseif ( sortType == "Namount" ) then
				key1 = format("%.6f", GITT[ind].amount / 10000)
				key2 = GITT[ind].contName
				key3 = GITT[ind].zoneName
			elseif ( sortType == "Npercent" ) then
				key1 = format("%.6f", GITT[ind].typePercent / 10000)
				key2 = GITT[ind].contName
				key3 = GITT[ind].zoneName
			elseif ( sortType == "Ndensity" ) then
				key1 = format("%.6f", GITT[ind].densityPercent / 10000)
				key2 = GITT[ind].contName
				key3 = GITT[ind].zoneName
			end
		end

		-- build sort string
		compstr[ind] = key1.."/"..key2.."/"..key3.."#"..ind
	end

	-- call sort function
	if ( reverse and not GathererInfo_LastSortReverse) then
		sort(compstr, GI_reverse_sort)
		GathererInfo_LastSortReverse = true
	else
		sort(compstr)
		GathererInfo_LastSortReverse = false
	end

	-- display sorted items
	for newind, data in compstr do
		recup = tonumber(strsub(data, string.find(data, "#")+1))

		if (newind == 1) then
			ref_ind = GITT[1].gi
		else
			ref_ind= ref_ind + 1
		end

		if ( newind > offSet and displayed < GATHERERINFO_TO_DISPLAY) then
			if ( search_stub == "" ) then
				GathererInfo_additem_table(GITT[recup].name, GITT[recup].amount, GITT[recup].texture, GITT[recup].gatherType, GITT[recup].typePercent, GITT[recup].densityPercent, newind - offSet, ref_ind)
			elseif ( search_stub == "Search" ) then
				GathererInfo_additem_searchtable(GITT[recup].contName, GITT[recup].amount, GITT[recup].zoneName, GITT[recup].typePercent, GITT[recup].densityPercent, newind - offSet, ref_ind)
			end
			displayed = displayed + 1
		end
	end

	for j = displayed+1, GATHERERINFO_TO_DISPLAY do
		getglobal("GathererInfo_"..search_stub.."FrameButton"..j):Hide()
	end

	FauxScrollFrame_Update(getglobal("GathererInfo_"..search_stub.."ListScrollFrame"), indexToShow, GATHERERINFO_TO_DISPLAY, GATHERERINFO_FRAME_HEIGHT)

	if( search_stub == "") then
		GathererInfo_LastSortType = sortType
	elseif ( search_stub == "Search" ) then
		GathererInfo_LastSearchSortType = sortType
	end
end

function GI_reverse_sort(token1, token2)
	return token1 > token2
end

-- ***********************************************************
-- Search UI functions
function GathererInfo_GatherTypeDropDown_Initialize()
	local index
	local info = {}

	for index in GatherIcons_TokenConversion do
		info.text = index
		info.checked = nil
		info.func = GathererInfo_GatherType_OnClick
		UIDropDownMenu_AddButton(info)
	end
end

function GathererInfo_GatherType_OnClick()
	UIDropDownMenu_SetSelectedID(GathererInfo_GatherTypeDropDown, this:GetID())
	UIDropDownMenu_SetSelectedID(GathererInfo_GatherItemDropDown, 0)

	UIDropDownMenu_SetText("", GathererInfo_GatherItemDropDown)

	UIDropDownMenu_ClearAll(GathererInfo_GatherItemDropDown)
	UIDropDownMenu_Initialize(GathererInfo_GatherItemDropDown, GathererInfo_GatherItemDropDown_Initialize)

	local j=1
	while (j < GATHERERINFO_TO_DISPLAY+1) do
		getglobal("GathererInfo_SearchFrameButton"..j):Hide()
		j = j+1
	end
end

function GathererInfo_GatherItemDropDown_Initialize()
	local index
	local info = {}
	local selectedGatherTypeText = UIDropDownMenu_GetText(GathererInfo_GatherTypeDropDown)

	if ( selectedGatherTypeText ) then
		local selectedGatherType = Gather_DB_TypeIndex[selectedGatherTypeText]

		for index, specificType in GatherIcons_TokenConversion[selectedGatherType] do
			info.text = index
			info.checked = nil
			info.value = specificType
			info.func = GathererInfo_GatherItem_OnClick
			UIDropDownMenu_AddButton(info)
		end
	end
end

function GathererInfo_GatherItem_OnClick()
	UIDropDownMenu_SetSelectedValue(GathererInfo_GatherItemDropDown, this.value)
	local selectedType = this.value
	GI_totalCount = 0

	for _, continent in Gatherer.Storage.GetAreaIndices() do --continents
		for _, zone in Gatherer.Storage.GetAreaIndices(continent) do
			for gatherName, _, _, specificType in Gatherer.Storage.ZoneGatherNames(continent, zone) do
				if ( selectedType == specificType ) then
					GI_totalCount = GI_totalCount + Gatherer.Storage.GetGatherCountsForZone(continent, zone, gatherName)
				end
			end
		end
	end
	GathererInfo_SearchUpdate()
end

function GathererInfo_SearchUpdate()
	local node_idx, index
	local gatherInfoOffset = FauxScrollFrame_GetOffset(GathererInfo_SearchListScrollFrame)
	local item_to_search = UIDropDownMenu_GetSelectedValue(GathererInfo_GatherItemDropDown)
	local gi_cont, gi_zone, gi_loc
	local gatherInfoIndex
	local showScrollBar = nil
	local button
	local i = 1

	-- if database exists
	if ( item_to_search ) then
		for _, continent in Gatherer.Storage.GetAreaIndices() do --continents
			for _, zone in Gatherer.Storage.GetAreaIndices(continent) do
				local nodeCount = Gatherer.Storage.GetNodeCounts(continent, zone)
				local nodesFound = false
				local zoneData = GITT[i] or {}; GITT[i] = zoneData
				zoneData.amount = 0
				zoneData.nodeCount = nodeCount
				zoneData.gi = gatherInfoOffset + i
				zoneData.contName = GathererInfoContinents[continent]
				zoneData.zoneName = GathererInfoZones[continent][zone]

				for gatherName, gtype, numNodes, icon in Gatherer.Storage.ZoneGatherNames(continent, zone) do
					if ( item_to_search == icon ) then
						nodesFound = true
						zoneData.amount = zoneData.amount + numNodes
					end
				end
				if ( nodesFound ) then
					zoneData.typePercent = zoneData.amount / zoneData.nodeCount * 100
					zoneData.densityPercent = zoneData.amount / GI_totalCount * 100
					i = i + 1
				end
			end
		end
		local lastGITTindex = i - 1
		GITT[i] = nil
		table.setn(GITT, lastGITTindex)

		SortGathererInfo(GathererInfo_LastSearchSortType, false, "Search")
		GathererInfo_Searchtotalcount:SetText(string.gsub(string.gsub(GATHERER_SEARCH_SUMMARY, "#", GI_totalCount), "&", lastGITTindex))
	end
end

-- Add items in display frame
function GathererInfo_additem_searchtable(contName, gatherNumber, zoneName, typePercent, densityPercent, GIlocation, GIIndex)

	if ( GIlocation < GATHERERINFO_TO_DISPLAY +1) then
		getglobal("GathererInfo_SearchFrameButton"..GIlocation).gatherIndex = GIIndex
		getglobal("GathererInfo_SearchFrameButton"..GIlocation.."Type"):SetText(contName)
		getglobal("GathererInfo_SearchFrameButton"..GIlocation.."Gatherable"):SetText(zoneName)
		getglobal("GathererInfo_SearchFrameButton"..GIlocation.."Number"):SetText(format("%d", gatherNumber))
		getglobal("GathererInfo_SearchFrameButton"..GIlocation.."TypePercent"):SetText(format("%.1f", typePercent))
		getglobal("GathererInfo_SearchFrameButton"..GIlocation.."DensityPercent"):SetText(format("%.1f", densityPercent))
		getglobal("GathererInfo_SearchFrameButton"..GIlocation):Show()
	end

end
-- ***********************************************************
-- Tab selection code
function ToggleGathererInfo_Dialog(tab)
	local subFrame = getglobal(tab)
	if ( subFrame ) then
		PanelTemplates_SetTab(GathererInfo_DialogFrame, subFrame:GetID())
		if ( GathererInfo_DialogFrame:IsVisible() ) then
				PlaySound("igCharacterInfoTab")
				GathererInfo_DialogFrame_ShowSubFrame(tab)
		else
			ShowUIPanel(GathererInfo_DialogFrame)
			GathererInfo_DialogFrame_ShowSubFrame(tab)
		end
	end
end

function GathererInfo_DialogFrame_ShowSubFrame(frameName)
	for index, value in GATHERERINFO_SUBFRAMES do
		if ( value == frameName ) then
			getglobal(value):Show()
		else
			getglobal(value):Hide()
		end
	end
end
function GathererInfoFrameTab_OnClick()
	if ( this:GetName() == "GathererInfo_DialogFrameTab1" ) then
		ToggleGathererInfo_Dialog("GathererInfo_ReportFrame")
	elseif ( this:GetName() == "GathererInfo_DialogFrameTab2" ) then
		ToggleGathererInfo_Dialog("GathererInfo_SearchFrame")
	end
	PlaySound("igCharacterInfoTab")
end
