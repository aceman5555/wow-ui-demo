--[[
	Gatherer Addon for World of Warcraft(tm).
	Version: 2.99.0.0498 (eagle)
	Revision: $Id: GatherZoneTokens.lua 460 2007-02-04 08:12:28Z esamynn $

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

	Functions for converting to and from the locale independent zone tokens
--]]
Gatherer_RegisterRevision("$URL: http://norganna.org/svn/gatherer/trunk/GatherZoneTokens.lua $", "$Rev: 460 $")

-- reference to the Astrolabe mapping library
local Astrolabe = DongleStub(Gatherer.AstrolabeVersion)

local _G = getfenv(0)
local metatable = { __index = _G }
setmetatable( Gatherer.ZoneTokens, metatable )
setfenv(1, Gatherer.ZoneTokens)


Tokens = {
	-- Kalimdor
	[1] = {
		["Ashenvale"] = "ASHENVALE",
		["Aszhara"] = "AZSHARA",
		["AzuremystIsle"] = "AZUREMYST_ISLE",
		["Barrens"] = "BARRENS",
		["BloodmystIsle"] = "BLOODMYST_ISLE",
		["Darkshore"] = "DARKSHORE",
		["Darnassis"] = "DARNASSUS",
		["Desolace"] = "DESOLACE",
		["Durotar"] = "DUROTAR",
		["Dustwallow"] = "DUSTWALLOW_MARSH",
		["Felwood"] = "FELWOOD",
		["Feralas"] = "FERALAS",
		["Moonglade"] = "MOONGLADE",
		["Mulgore"] = "MULGORE",
		["Ogrimmar"] = "ORGRIMMAR",
		["Silithus"] = "SILITHUS",
		["StonetalonMountains"] = "STONETALON_MOUNTAINS",
		["Tanaris"] = "TANARIS",
		["Teldrassil"] = "TELDRASSIL",
		["TheExodar"] = "EXODAR",
		["ThousandNeedles"] = "THOUSAND_NEEDLES",
		["ThunderBluff"] = "THUNDER_BLUFF",
		["UngoroCrater"] = "UNGORO_CRATER",
		["Winterspring"] = "WINTERSPRING",
	},
	-- Eastern Kingdoms
	[2] = {
		["Alterac"] = "ALTERAC_MOUNTAINS",
		["Arathi"] = "ARATHI_HIGHLANDS",
		["Badlands"] = "BADLANDS",
		["BlastedLands"] = "BLASTED_LANDS",
		["BurningSteppes"] = "BURNING_STEPPES",
		["DeadwindPass"] = "DEADWIND_PASS",
		["DunMorogh"] = "DUN_MOROGH",
		["Duskwood"] = "DUSKWOOD",
		["EasternPlaguelands"] = "EASTERN_PLAGUELANDS",
		["Elwynn"] = "ELWYNN_FOREST",
		["EversongWoods"] = "EVERSONG_WOODS",
		["Ghostlands"] = "GHOSTLANDS",
		["Hilsbrad"] = "HILLSBRAD_FOOTHILLS",
		["Hinterlands"] = "HINTERLANDS",
		["Ironforge"] = "IRONFORGE",
		["LochModan"] = "LOCH_MODAN",
		["Redridge"] = "REDRIDGE_MOUNTAINS",
		["SearingGorge"] = "SEARING_GORGE",
		["SilvermoonCity"] = "SILVERMOON",
		["Silverpine"] = "SILVERPINE_FOREST",
		["Stormwind"] = "STORMWIND",
		["Stranglethorn"] = "STRANGLETHORN_VALE",
		["SwampOfSorrows"] = "SWAMP_OF_SORROWS",
		["Tirisfal"] = "TIRISFAL_GLADES",
		["Undercity"] = "UNDERCITY",
		["WesternPlaguelands"] = "WESTERN_PLAGUELANDS",
		["Westfall"] = "WESTFALL",
		["Wetlands"] = "WETLANDS",
	},
	-- Outland
	[3] = {
		["BladesEdgeMountains"] = "BLADES_EDGE_MOUNTAINS",
		["Hellfire"] = "HELLFIRE_PENINSULA",
		["Nagrand"] = "NAGRAND",
		["Netherstorm"] = "NETHERSTORM",
		["ShadowmoonValley"] = "SHADOWMOON_VALLEY",
		["ShattrathCity"] = "SHATTRATH",
		["TerokkarForest"] = "TEROKKAR_FOREST",
		["Zangarmarsh"] = "ZANGARMARSH",
	},
}

TempTokens = {}

for continent, zones in pairs(Astrolabe.ContinentList) do
	local mapData = Tokens[continent];
	for index, mapName in pairs(zones) do
		if not ( mapData[mapName] ) then
			-- use the map name as a temporary token and 
			-- mark the map name as such
			Gatherer.ZoneTokens.TempTokens[mapName] = 1;
			mapData[index] = mapName;
		end
		mapData[index] = mapData[mapName];
		mapData[mapData[mapName]] = index;
		mapData[mapName] = nil;
	end
end

BCZones = {
	-- Kalimdor
	[1] = {
		["AzuremystIsle"] = "AZUREMYST_ISLE",
		["BloodmystIsle"] = "BLOODMYST_ISLE",
		["TheExodar"] = "EXODAR",
	},
	-- Eastern Kingdoms
	[2] = {
		["EversongWoods"] = "EVERSONG_WOODS",
		["Ghostlands"] = "GHOSTLANDS",
		["SilvermoonCity"] = "SILVERMOON",
	},
	-- Outland
	[3] = {
		["BladesEdgeMountains"] = "BLADES_EDGE_MOUNTAINS",
		["Hellfire"] = "HELLFIRE_PENINSULA",
		["Nagrand"] = "NAGRAND",
		["Netherstorm"] = "NETHERSTORM",
		["ShadowmoonValley"] = "SHADOWMOON_VALLEY",
		["ShattrathCity"] = "SHATTRATH",
		["TerokkarForest"] = "TEROKKAR_FOREST",
		["Zangarmarsh"] = "ZANGARMARSH",
	},
}


function GetZoneToken( continent, zone )
	if not ( Tokens[continent] ) then
		return nil
	end
	local val = Tokens[continent][zone]
	if ( type(zone) == "number" ) then
		return val
	elseif ( val ) then
		return zone
	end
end

function GetZoneIndex( continent, token )
	if not ( Tokens[continent] ) then
		return nil
	end
	local val = Tokens[continent][token]
	if ( type(token) == "string" ) then
		return val
	elseif ( val ) then
		return token
	end
end

function IsTempZoneToken( continent, token )
	if ( Gatherer.ZoneTokens.Tokens[continent][token] == nil or Gatherer.ZoneTokens.TempTokens[token] ) then
		return true
	else
		return false
	end
end
