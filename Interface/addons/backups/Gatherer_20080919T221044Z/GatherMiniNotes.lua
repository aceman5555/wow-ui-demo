--[[
	Gatherer Addon for World of Warcraft(tm).
	Version: 2.99.0.0498 (eagle)
	Revision: $Id: GatherMiniNotes.lua 496 2007-02-26 01:59:10Z esamynn $

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

	Minimap Drawing Routines
]]
Gatherer_RegisterRevision("$URL: http://norganna.org/svn/gatherer/trunk/GatherMiniNotes.lua $", "$Rev: 496 $")

local _tr = Gatherer.Locale.Tr
local _trC = Gatherer.Locale.TrClient
local _trL = Gatherer.Locale.TrLocale

-- reference to the Astrolabe mapping library
local Astrolabe = DongleStub(Gatherer.AstrolabeVersion)

local timeDiff = 0
local checkDiff = 0
local numNotesUsed = 0

-- table to store current active Minimap Notes objects
Gatherer.MiniNotes.Notes = {}

function Gatherer.MiniNotes.Show()
	if ( Gatherer.Config.GetSetting("minimap.enable") ) then
		if ( GatherMiniNoteUpdateFrame:IsShown() ) then
			Gatherer.MiniNotes.UpdateMinimapNotes(0, true)
		else
			GatherMiniNoteUpdateFrame:Show()
		end
	end
end

function Gatherer.MiniNotes.Hide()
	GatherMiniNoteUpdateFrame:Hide()
	numNotesUsed = 0
	for i, note in pairs(Gatherer.MiniNotes.Notes) do
		Astrolabe:RemoveIconFromMinimap(note)
	end
end

local function GetMinimapNote( index )
	local note = Gatherer.MiniNotes.Notes[index]
	if not ( note ) then
		note = CreateFrame("Button", "GatherNote"..index, Minimap, "GatherNoteTemplate")
		Gatherer.MiniNotes.Notes[index] = note
		note:SetID(index)
	end
	return note
end

function Gatherer.MiniNotes.UpdateMinimapNotes(timeDelta, force)
	local setting = Gatherer.Config.GetSetting
	
	if ( Astrolabe.WorldMapVisible and (not Astrolabe:GetCurrentPlayerPosition()) ) then
		return
	end
	
	if not ( setting("minimap.enable") ) then
		Gatherer.MiniNotes.Hide()
		return
	end
	
	local updateIcons = false
	local updateNodes = false
	
	if ( force or Gatherer.Command.IsUpdated("minimap.update") ) then
		updateIcons = true
		updateNodes = true
	else
		checkDiff = checkDiff + timeDelta
		timeDiff = timeDiff + timeDelta
		if (checkDiff > Gatherer.Var.NoteCheckInterval) then
			updateNodes = true
			checkDiff = 0
			updateIcons = true
			timeDiff = 0
		
		elseif (timeDiff > Gatherer.Var.NoteUpdateInterval) then
			updateIcons = true
			timeDiff = 0
			
		end
	end
	
	if ( updateNodes ) then
		local c, z, px, py = Gatherer.Util.GetPositionInCurrentZone()
		if ( not (c and z and px and py) ) or ( c <= 0 ) or ( z <= 0 ) then
			Gatherer.MiniNotes.Hide()
			return
		end
		
		local maxDist = setting("minimap.distance", 800)
		local displayNumber = setting("minimap.count", 20)
		
		numNotesUsed = 0
		for i, nodeC,nodeZ, nodeID, nodePos, nodeDist, nodeX,nodeY, nodeCount, gtype, nodeHarvested, nodeInspected, nodeSource
			in Gatherer.Storage.ClosestNodesInfo(c, z, px, py, displayNumber, maxDist, Gatherer.Config.DisplayFilter_MiniMap) do
			numNotesUsed = numNotesUsed + 1
			if ( numNotesUsed > displayNumber ) then
				numNotesUsed = numNotesUsed - 1
				break
			end
			
			-- need to position and label the corresponding button
			local gatherNote = GetMinimapNote(numNotesUsed)
			gatherNote.id = nodeID
			gatherNote.continent = nodeC
			gatherNote.zone = nodeZ
			gatherNote.index = nodePos
			gatherNote.source = nodeSource
			
			local result = Astrolabe:PlaceIconOnMinimap(gatherNote, nodeC, nodeZ, nodeX, nodeY)
			-- a non-zero results some failure when adding the icon to the Minimap
			if ( result ~= 0 ) then
				numNotesUsed = numNotesUsed - 1
			end
		end
		
		local notes = Gatherer.MiniNotes.Notes
		for i = (numNotesUsed + 1), #(Gatherer.MiniNotes.Notes) do
			Astrolabe:RemoveIconFromMinimap(notes[i]);
		end
	end
	
	if ( updateIcons or updateNodes ) then
		local now = time()
		
		local normSize = setting("minimap.iconsize")
		local normPerc = setting("minimap.percent") / 100
		local fadeEnab = setting("fade.enable")
		local fadeDist = setting("fade.distance")
		local fadePerc = setting("fade.percent") / 100
		local tracEnab = setting("track.enable")
		local tracCirc = setting("track.circle")
		local tracStyl = setting("track.style")
		local tracCurr = setting("track.current")
		local tracDist = setting("track.distance")
		local tracPerc = setting("track.percent") / 100
		local inspEnab = setting("inspect.enable")
		local inspTint = setting("inspect.tint")
		local inspDist = setting("inspect.distance")
		local inspPerc = setting("inspect.percent") / 100
		local inspTime = setting("inspect.time")
		local anonEnab = setting("anon.enable")
		local anonTint = setting("anon.tint")
		local anonPerc = setting("anon.percent") / 100
		local tooltip = setting("minimap.tooltip.enable")
		
		for i = 1, numNotesUsed do
			local gatherNote = GetMinimapNote(i)
			local nodeID = gatherNote.id
			local nodeC = gatherNote.continent
			local nodeZ= gatherNote.zone
			local nodePos = gatherNote.index
			local nodeSource = gatherNote.source
			
			local iconColor = "normal"
			local opacity = normPerc
			local nodeDist = Astrolabe:GetDistanceToIcon(gatherNote)
			
			local selectedTexture, trimTexture = Gatherer.Util.GetNodeTexture(nodeID)
			
			-- If this icon has not been verified
			if ( anonEnab and nodeSource and (nodeSource ~= 'REQUIRE') and (nodeSource ~= "IMPORTED") ) then
				opacity = anonPerc
				if anonTint then
					iconColor = "red"
				end
			end
			
			-- If node is within tracking distance
			if ( tracEnab and (nodeDist < tracDist) ) then
				if ( (not tracCurr) or Gatherer.Util.IsNodeTracked(nodeID) ) then
					if (tracCirc) then
						selectedTexture = "Interface\\AddOns\\Gatherer\\Shaded\\"..tracStyl
						trimTexture = false
					end
					opacity = tracPerc
				end
			end
			
			-- If we need to fade the icon (because of great distance)
			if ( fadeEnab ) then
				if nodeDist >= fadeDist then
					opacity = fadePerc
				elseif ( nodeDist > tracDist ) then
					local range = math.max(fadeDist - tracDist, 0)
					local posit = math.min(nodeDist - tracDist, range)
					if (range > 0) then
						local ratio = posit / range
						local fadeLevel = (opacity - fadePerc) * ratio
						opacity = opacity - fadeLevel
					end
				end
			end
			
			-- If inspecting is enabled
			if (inspEnab) then
				-- If we are within inspect distance of this item, mark it as inspected
				if (nodeDist < inspDist) then
					Gatherer.Storage.SetNodeInspected(nodeC, nodeZ, nodeID, nodePos)
					if (inspTint) then
						iconColor = "green"
					end
					opacity = normPerc
			
				-- If we've recently seen this node, set its transparency
				else
					local nodeInspected = Gatherer.Storage.GetNodeInspected(nodeC, nodeZ, nodeID, nodePos)
					if (nodeInspected) then
						local delta = math.max(now - nodeInspected, 0)
						if (inspTime > 0) and (delta < inspTime) then
							local ratio = 1 - (delta / inspTime)
							local fadeLevel = (opacity - inspPerc) * ratio
							opacity = opacity - fadeLevel
						end
					end
				end
			end
			
			-- Set the texture
			gatherNote:SetNormalTexture(selectedTexture)
			gatherNote:SetWidth(normSize)
			gatherNote:SetHeight(normSize)

			if (tooltip and not gatherNote:IsMouseEnabled()) then
				gatherNote:EnableMouse(true)
			elseif (not tooltip and gatherNote:IsMouseEnabled()) then
				gatherNote:EnableMouse(false)
			end
			
			local gatherNoteTexture = gatherNote:GetNormalTexture()
			
			-- Check to see if we need to trim the border off
			if (trimTexture) then
				gatherNoteTexture:SetTexCoord(0.08,0.92,0.08,0.92)
			else
				gatherNoteTexture:SetTexCoord(0,1,0,1)
			end
			
			-- If this node is unverified, then make it reddish
			if ( iconColor == "red" ) then
				gatherNoteTexture:SetVertexColor(0.9,0.4,0.4)
			elseif ( iconColor == "green" ) then
				gatherNoteTexture:SetVertexColor(0.4,0.9,0.4)
			elseif ( iconColor == "blue" ) then
				gatherNoteTexture:SetVertexColor(0.4,0.4,0.9)
			else
				gatherNoteTexture:SetVertexColor(1,1,1)
			end
			gatherNoteTexture:SetAlpha(opacity)
		end
	end
end

-- Pass on any node clicks
function Gatherer.MiniNotes.MiniNoteOnClick()
	local x, y = GetCursorPosition()
	if ( Minimap.GetEffectiveScale ~= nil ) then
		x = x / Minimap:GetEffectiveScale()
		y = y / Minimap:GetEffectiveScale()
	else
		x = x / Minimap:GetScale()
		y = y / Minimap:GetScale()
	end

	local cx, cy = Minimap:GetCenter()
	x = x + CURSOR_OFFSET_X - cx
	y = y + CURSOR_OFFSET_Y - cy
	if ( sqrt(x * x + y * y) < (Minimap:GetWidth() / 2) ) then
		Minimap:PingLocation(x, y)
	end
end

function Gatherer.MiniNotes.MiniNoteOnEnter(frame)
	local setting = Gatherer.Config.GetSetting
	local tooltip = GameTooltip

	local enabled = setting("minimap.tooltip.enable")
	if (not enabled) then 
		return
	end
	
	local showcount = setting("minimap.tooltip.count")
	local showsource = setting("minimap.tooltip.source")
	local showseen = setting("minimap.tooltip.seen")
	local showdist = setting("minimap.tooltip.distance")
	local showrate = setting("minimap.tooltip.rate")
	
	tooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT")
	
	local id = frame.id
	local name = Gatherer.Util.GetNodeName(id)
	local dist = Astrolabe:GetDistanceToIcon(frame)
	local _, _, count, gType, harvested, inspected, who = Gatherer.Storage.GetNodeInfo(frame.continent, frame.zone, id, frame.index)
	local last = inspected or harvested

	tooltip:ClearLines()
	tooltip:AddLine(name)
	if (count > 0 and showcount) then
		tooltip:AddLine(_tr("NOTE_COUNT", count))
	end
	if (who and showsource) then
		if (who == "REQUIRE") then
			tooltip:AddLine(_tr("NOTE_UNSKILLED"))
		elseif (who == "IMPORTED") then
			tooltip:AddLine(_tr("NOTE_IMPORTED"))
		else
			tooltip:AddLine(_tr("NOTE_SOURCE", who))
		end
	end
	if (last and last > 0 and showseen) then
		tooltip:AddLine(_tr("NOTE_LASTVISITED", Gatherer.Util.SecondsToTime(time()-last)))
	end
	if (showdist) then
		tooltip:AddLine(_tr("NOTE_DISTANCE", format("%0.2f", dist)))
	end
	
	if ( showrate ) then
		local num = Gatherer.Config.GetSetting("minimap.tooltip.rate.num")
		Gatherer.Tooltip.AddDropRates(tooltip, id, frame.continent, frame.zone, num)
	end
	tooltip:Show()
end
