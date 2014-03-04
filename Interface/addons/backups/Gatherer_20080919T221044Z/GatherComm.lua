--[[
	Gatherer Addon for World of Warcraft(tm).
	Version: 2.99.0.0498 (eagle)
	Revision: $Id: GatherComm.lua 490 2007-02-15 09:33:28Z esamynn $

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

	
]]
Gatherer_RegisterRevision("$URL: http://norganna.org/svn/gatherer/trunk/GatherComm.lua $", "$Rev: 490 $")

local _tr = Gatherer.Locale.Tr
local _trC = Gatherer.Locale.TrClient
local _trL = Gatherer.Locale.TrLocale

local lastHarvest = {}
function Gatherer.Comm.Send( objectId, gatherC, gatherZ, gatherIndex, gatherCoins, gatherLoot )
	if ( type(objectId) == "number" ) then
		gatherZ = Gatherer.ZoneTokens.GetZoneToken(gatherC, gatherZ)
		local gatherX, gatherY = Gatherer.Storage.GetNodeInfo(gatherC, gatherZ, objectId, gatherIndex)
		
		-- construct loot text string
		local lootText = gatherCoins or 0
		if ( gatherLoot ) then
			for pos, loot in ipairs(gatherLoot) do
				local id = loot.id
				if ( (not id) and loot.link ) then
					id = Gatherer.Util.BreakLink(loot.link)
				end
				if ( id ) then
					local count = loot.count
					if ( count ) then
						lootText = lootText .. ":" .. id .. "x" .. count
					end
				end
			end
		end
		
		-- Check if this node has been just broadcast by us
		if not (lastHarvest and lastHarvest.c == gatherC and lastHarvest.z == gatherZ and lastHarvest.o == objectId and lastHarvest.i == gatherIndex) then
			-- Ok, so lets broadcast this node
			local guildAlert, raidAlert, raidType
			local sendMessage = strjoin(";", objectId, gatherC, gatherZ, gatherX, gatherY, lootText)
			if Gatherer.Config.GetSetting("guild.enable") then
				if ( IsInGuild() ) then
					SendAddonMessage("GathX", sendMessage, "GUILD")
					if (Gatherer.Config.GetSetting("guild.print.send")) then guildAlert = true end
				end
			end
			if (Gatherer.Config.GetSetting("raid.enable")) then
				if GetNumRaidMembers() > 0 then
					raidType = "raid"
				elseif GetNumPartyMembers() > 0 then
					raidType = "party"
				end
				SendAddonMessage("GathX", sendMessage, "RAID")
				if (raidType and Gatherer.Config.GetSetting("raid.print.send")) then raidAlert = true end
			end

			if (guildAlert or raidAlert) then
				local objName = Gatherer.Util.GetNodeName(objectId);
				local whom
				if guildAlert and raidAlert then
					whom = "guild and "..raidType
				elseif guildAlert then
					whom = "guild"
				else
					whom = raidType
				end
				Gatherer.Util.ChatPrint(_tr("Sent gather of %1 to %2", objName, _tr(whom)))
			end
		end
		lastHarvest.c = gatherC
		lastHarvest.z = gatherZ
		lastHarvest.o = objectId
		lastHarvest.i = gatherIndex
	end
end

local lastMessage = ""
local playerName = UnitName("player")
function Gatherer.Comm.Receive( message, how, who )
	local setting = Gatherer.Config.GetSetting
	local msgtype = "raid"

	if ( message ~= lastMessage and who ~= playerName ) then
		if (how:lower() == "guild") then msgtype = "guild" end
		if not (setting(msgtype..".enable") and setting(msgtype..".receive")) then return end

		lastMessage = message
		local objectID, gatherC, zoneToken, gatherX, gatherY, loot = strsplit(";", message)
		objectID = tonumber(objectID)
		gatherC = tonumber(gatherC)
		gatherX = tonumber(gatherX)
		gatherY = tonumber(gatherY)
		if (objectID and gatherC and gatherX and gatherY) then
			local gatherZ = Gatherer.ZoneTokens.GetZoneIndex(gatherC, zoneToken)
			local gatherType = Gatherer.Nodes.Objects[objectID]
			
			if (gatherType) then
				local coins, loots = Gatherer.Util.LootSplit(loot)
				Gatherer.Api.AddGather(objectID, gatherType, "", who, coins, loots, false, gatherC, gatherZ, gatherX, gatherY)
				local objName = Gatherer.Util.GetNodeName(objectID);
				if (setting(msgtype..".print.recv")) then
					Gatherer.Util.ChatPrint(_tr("Received gather of %1 from %2 (%3)", objName, who, _tr(how:lower())))
				end
			end
		end
	end
end

function Gatherer.Comm.General( msg, how, who )
	if ( msg == "VERSION" ) then
		SendAddonMessage("Gatherer", "VERSION:"..Gatherer.Var.Version, how)
	end
end