--[[
	Gatherer Addon for World of Warcraft(tm).
	Version: 2.99.0.0498 (eagle)
	Revision: $Id: GatherApi.lua 496 2007-02-26 01:59:10Z esamynn $

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

	These functions can be used by external addons for interfacing with
	Gatherer. We will try and keep these functions as unchanged as possible.
]]
Gatherer_RegisterRevision("$URL: http://norganna.org/svn/gatherer/trunk/GatherApi.lua $", "$Rev: 496 $")

-- reference to the Astrolabe mapping library
local Astrolabe = DongleStub(Gatherer.AstrolabeVersion)

-- This function can be used as an interface by other addons to record things
-- in Gatherer's database, though display is still based only on what is defined
-- in Gatherer items and icons tables.
-- Parameters:
--   objectId (number): the object id for this node (from Gatherer.Nodes)
--   gatherType (string): gather type (Mine, Herb, Skin, Fish, Treasure)
--   tooltipText (string): the text in the tooltip (unused)
--   gatherSource (string): the name of the sender (or nil if you collected it)
--   gatherCoins (number): amount of copper found in the node
--   gatherLoot (table): a table of loot: { { link, count }, ...}
--   wasGathered (boolean): was this object actually opened by the player
function Gatherer.Api.AddGather(objectId, gatherType, tooltipText, gatherSource, gatherCoins, gatherLoot, wasGathered, gatherC, gatherZ, gatherX, gatherY)
	--[[
	if (Gatherer.Settings.filterRecording and Gatherer.Settings.filterRecording[gatherType] and not Gatherer.Settings.interested[gatherType][specificType] ) then
		return
	end
	--]]
	
	if not (gatherC and gatherZ and gatherX and gatherY) then
		gatherC, gatherZ, gatherX, gatherY = Gatherer.Util.GetPositionInCurrentZone()
		if not (gatherC and gatherZ and gatherX and gatherY) then
			return
		end
	end
	if ( gatherC <= 0 or gatherZ <= 0 ) then
		return
	end
	
	Gatherer.DropRates.ProcessDrops(objectId, gatherC, gatherZ, gatherSource, gatherCoins, gatherLoot)
	
	if ( type(objectId) == "number" or Gatherer.Categories.CategoryNames[objectId] ) then 
		local index = Gatherer.Storage.AddNode(objectId, gatherType, gatherC, gatherZ, gatherX, gatherY, gatherSource, wasGathered)
		-- If this is our gather
		if ( (not gatherSource) or (gatherSource == "REQUIRE") ) then
			Gatherer.Comm.Send(objectId, gatherC, gatherZ, index, gatherCoins, gatherLoot)
		end
	end
	
	Gatherer.MiniNotes.Show()
	Gatherer.MapNotes.MapDraw()
end
