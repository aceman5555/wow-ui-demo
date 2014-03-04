--[[
	Gatherer Addon for World of Warcraft(tm).
	Version: 2.99.0.0498 (eagle)
	Revision: $Id: GatherCommand.lua 490 2007-02-15 09:33:28Z esamynn $

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

	Command parsing and processing
]]
Gatherer_RegisterRevision("$URL: http://norganna.org/svn/gatherer/trunk/GatherCommand.lua $", "$Rev: 490 $")

SLASH_GATHERER1 = "/gather"
SLASH_GATHERER2 = "/gatherer"
SlashCmdList["GATHERER"] = function( msg )
	Gatherer.Command.Process(msg)
end

function Gatherer.Command.GetFilterVal(gName)
	local filter = Gatherer.Command.GetFilter(gName)
	if (filter) then return "on" end
	return "off"
end

function Gatherer.Command.GetFilter(gName)
	local gType
	if (gName == "herbs") then gType = "herb" end
	if (gName == "mining") then gType = "mine" end
	if (gName == "treasures") then gType = "open" end
	if not ( gType ) then return false end
	return Gatherer.Config.GetSetting("show.minimap."..gType)
end

function Gatherer.Command.Process(command)
	Gatherer.Config.MakeGuiConfig()
	Gatherer.Config.Gui:Show()
	return
end


--[[
	if true then return end

	local SETTINGS = Gatherer.Settings
	local i,j, cmd, param = string.find(command, "^([^ ]+) (.+)$")
	if (not cmd) then cmd = command; end
	if (not cmd) then cmd = ""; end
	if (not param) then param = ""; end

	if ((cmd == "") or (cmd == "help")) then
		local useMinimap = "Off"
		if (SETTINGS.useMinimap) then useMinimap = "On"; end
		local useMainmap = "Off"
		if (SETTINGS.useMainmap) then useMainmap = "On"; end
		local mapMinder = "Off"
		if (SETTINGS.mapMinder) then mapMinder = "On"; end
		local minderTime = "5s"
		if (SETTINGS.minderTime) then minderTime = SETTINGS.minderTime.."s"; end

		Gatherer.Util.ChatPrint("Usage:")
		Gatherer.Util.ChatPrint("  |cffffffff/gather (on|off|toggle)|r |cff2040ff["..useMinimap.."]|r - turns the gather minimap display on and off")
		Gatherer.Util.ChatPrint("  |cffffffff/gather mainmap (on|off|toggle)|r |cff2040ff["..useMainmap.."]|r - turns the gather mainmap display on and off")
		Gatherer.Util.ChatPrint("  |cffffffff/gather minder (on|off|toggle|<n>)|r |cff2040ff["..mapMinder.."]|r - turns the gather map minder on and off (remembers and reopens your last open main map; within "..minderTime..")")
		Gatherer.Util.ChatPrint("  |cffffffff/gather dist <n>|r |cff2040ff["..SETTINGS.maxDist.."]|r - sets the maximum search distance for display (0=infinite(default), typical=10)")
		Gatherer.Util.ChatPrint("  |cffffffff/gather num <n>|r |cff2040ff["..SETTINGS.number.."]|r - sets the maximum number of items to display (default=10, up to 25)")
		Gatherer.Util.ChatPrint("  |cffffffff/gather fdist <n>|r |cff2040ff["..SETTINGS.fadeDist.."]|r - sets a fade distance (in units) for the icons to fade out by (default = 20)")
		Gatherer.Util.ChatPrint("  |cffffffff/gather fperc <n>|r |cff2040ff["..SETTINGS.fadePerc.."]|r - sets the percentage for fade at max fade distance (default = 80 [=80% faded])")
		Gatherer.Util.ChatPrint("  |cffffffff/gather theme <name>|r |cff2040ff["..SETTINGS.iconSet.."]|r - sets the icon theme: original, shaded (default), iconic or iconshade")
		Gatherer.Util.ChatPrint("  |cffffffff/gather idist <n>|r |cff2040ff["..SETTINGS.miniIconDist.."]|r - sets the minimap distance at which the gather icon will become iconic (0 = off, 1-60 = pixel radius on minimap, default = 40)")
		Gatherer.Util.ChatPrint("  |cffffffff/gather herbs (on|off|toggle|auto)|r |cff2040ff["..Gatherer.Command.GetFilterVal("herbs").."]|r - select whether to show herb data on the minimap")
		Gatherer.Util.ChatPrint("  |cffffffff/gather mining (on|off|toggle|auto)|r |cff2040ff["..Gatherer.Command.GetFilterVal("mining").."]|r - select whether to show mining data on the minimap")
		Gatherer.Util.ChatPrint("  |cffffffff/gather treasure (on|off|toggle|auto)|r |cff2040ff["..Gatherer.Command.GetFilterVal("treasure").."]|r - select whether to show treasure data on the minimap")
		Gatherer.Util.ChatPrint("  |cffffffff/gather options|r - show/hide UI Options dialog.")
		Gatherer.Util.ChatPrint("  |cffffffff/gather report|r - show/hide report dialog.")
		Gatherer.Util.ChatPrint("  |cffffffff/gather search|r - show/hide search dialog.")
		Gatherer.Util.ChatPrint("  |cffffffff/gather loginfo (on|off)|r - show/hide logon information.")
		Gatherer.Util.ChatPrint("  |cffffffff/gather filterrec (herbs|mining|treasure)|r - link display filter to recording for selected gathering type")
	elseif (cmd == "options" ) then
		if ( Gatherer_DialogFrame:IsVisible() ) then
			Gatherer.Interface.HideOptions()
		else
			Gatherer.Interface.ShowOptions()
		end
	elseif (cmd == "report" ) then
		showGathererInfo(1)
	elseif (cmd == "search" ) then
		showGathererInfo(2)
	elseif (cmd == "loginfo" ) then
		local value
		if (not param or param == "") then value = "on"; else value = param; end
		Gatherer.Util.ChatPrint("Setting log information display to "..value)
		SETTINGS.logInfo = value
	elseif ( cmd == "filterrec" ) then
		local value
		if (not param) then
			return
		end
		if ( param == "treasure" ) then
			value = "OPEN"
		elseif ( param == "herbs" ) then
			value = "HERB"
		elseif ( param == "mining" ) then
			value = "MINE"
		end

		if ( value > -1 ) then
			if ( SETTINGS.filterRecording[value] ) then
				SETTINGS.filterRecording[value] = nil
				Gatherer.Util.ChatPrint("Turned filter/recording link for "..param.." off.")
			else
				SETTINGS.filterRecording[value] = 1
				Gatherer.Util.ChatPrint("Turned filter/recording link for "..param.." on.")
			end
		end
	elseif (cmd == "on") then
		SETTINGS.useMinimap = true
		Gatherer.MiniNotes.Show()
		SETTINGS.useMinimapText = "on"
		Gatherer.Util.ChatPrint("Turned gather minimap display on")
	elseif (cmd == "off") then
		SETTINGS.useMinimap = false
		SETTINGS.useMinimapText = "off"
		Gatherer.MiniNotes.Show()
		Gatherer.Util.ChatPrint("Turned gather minimap display off (still collecting)")
	elseif (cmd == "toggle") then
		SETTINGS.useMinimap = not SETTINGS.useMinimap
		Gatherer.MiniNotes.Show()
		if (SETTINGS.useMinimap) then
			Gatherer.Util.ChatPrint("Turned gather minimap display on")
			SETTINGS.useMinimapText = "on"
		else
			Gatherer.Util.ChatPrint("Turned gather minimap display off (still collecting)")
			SETTINGS.useMinimapText = "off"
		end
	elseif (cmd == "dist") then
		local i,j, value = string.find(param, "(%d+)")
		if (not value) then value = 0; else value = value + 0.0; end
		if (value <= 0) then
			SETTINGS.maxDist = 0
		else
			SETTINGS.maxDist = value + 0.0
		end
		Gatherer.Util.ChatPrint("Setting maximum note distance to "..SETTINGS.maxDist)
		Gatherer.MiniNotes.Show()
	elseif (cmd == "fdist") then
		local i,j, value = string.find(param, "(%d+)")
		if (not value) then value = 0; else value = value + 0.0; end
		if (value <= 0) then
			SETTINGS.fadeDist = 0
		else
			SETTINGS.fadeDist = value + 0.0
		end
		Gatherer.Util.ChatPrint("Setting fade distance to "..SETTINGS.fadeDist)
		Gatherer.MiniNotes.Show()
	elseif (cmd == "fperc") then
		local i,j, value = string.find(param, "(%d+)")
		if (not value) then value = 0; else value = value + 0.0; end
		if (value <= 0) then
			SETTINGS.fadePerc = 0
		else
			SETTINGS.fadePerc = value + 0.0
		end
		Gatherer.Util.ChatPrint("Setting fade percent at fade distance to "..SETTINGS.fadePerc)
		Gatherer.MiniNotes.Show()
	elseif ((cmd == "idist") or (cmd == "icondist")) then
		local i,j, value = string.find(param, "(%d+)")
		if (not value) then value = 0; else value = value + 0; end
		if (value <= 0) then
			SETTINGS.miniIconDist = 0
		else
			SETTINGS.miniIconDist = value + 0
		end
		Gatherer.Util.ChatPrint("Setting iconic distance to "..SETTINGS.miniIconDist)
		Gatherer.MiniNotes.Show()
	elseif (cmd == "theme") then
		if (Gather_IconSet[param]) then
			SETTINGS.iconSet = param
			Gatherer.Util.ChatPrint("Gatherer theme set to "..SETTINGS.iconSet)
		else
			Gatherer.Util.ChatPrint("Unknown theme: "..param)
		end
		Gatherer.MiniNotes.Show()
	elseif ((cmd == "num") or (cmd == "number")) then
		local i,j, value = string.find(param, "(%d+)")
		if (not value) then value = 0; else value = value + 0; end
		if (value < 0) then
			SETTINGS.number = 10
		elseif (value <= Gatherer.Var.MaxNumNotes) then
			SETTINGS.number = math.floor(value + 0)
		else
			SETTINGS.number = Gatherer.Var.MaxNumNotes
		end
		if (SETTINGS.number == 0) then
			SETTINGS.useMinimap = false
			SETTINGS.useMinimapText = "off"
			Gatherer.MiniNotes.Show()
			Gatherer.Util.ChatPrint("Turned gather minimap display off (still collecting)")
		else
			if ((SETTINGS.number > 0) and (SETTINGS.useMinimap == false)) then
				SETTINGS.useMinimap = true
		        	SETTINGS.useMinimapText = "on"
				Gatherer.Util.ChatPrint("Turned gather minimap display on")
			end
			Gatherer.Util.ChatPrint("Displaying "..SETTINGS.number.." notes at once")
			Gatherer.MiniNotes.Show()
		end
	elseif (cmd == "mainmap") then
		if ((param == "false") or (param == "off") or (param == "no") or (param == "0")) then
			SETTINGS.useMainmap = false
		elseif (param == "toggle") then
			SETTINGS.useMainmap = not SETTINGS.useMainmap
		else
			SETTINGS.useMainmap = true
		end
		if (SETTINGS.useMainmap) then
			Gatherer.Util.ChatPrint("Displaying notes in main map")
			Gatherer_WorldMapDisplay:SetText("Hide Items")
		else
			Gatherer.Util.ChatPrint("Not displaying notes in main map")
			Gatherer_WorldMapDisplay:SetText("Show Items")
		end

		if (SETTINGS.useMainmap and SETTINGS.showWorldMapFilters and SETTINGS.showWorldMapFilters == 1) then
			GathererWD_DropDownFilters:Show()
		end

	elseif (cmd == "minder") then
		if ((param == "false") or (param == "off") or (param == "no") or (param == "0")) then
			SETTINGS.mapMinder = false
		elseif (param == "toggle") then
			SETTINGS.mapMinder = not SETTINGS.mapMinder
		elseif (param == "on") then
			SETTINGS.mapMinder = true
		else
			local i,j, value = string.find(param, "(%d+)")
			if (not value) then value = 0; else value = value + 0; end
			if (value <= 0) then
				SETTINGS.mapMinder = false
				SETTINGS.minderTime = 0
			else
				SETTINGS.mapMinder = true
				SETTINGS.minderTime = value + 0
			end
			Gatherer.Util.ChatPrint("Setting map minder timeout to "..SETTINGS.minderTime)
		end
		if (SETTINGS.mapMinder) then
			Gatherer.Util.ChatPrint("Map minder activated at "..SETTINGS.minderTime)
		else
			Gatherer.Util.ChatPrint("Not minding your map")
		end
	elseif ((cmd == "herbs") or (cmd == "mining") or (cmd == "treasure")) then
		if ((param == "false") or (param == "off") or (param == "no") or (param == "0")) then
			Gatherer.Command.SetFilter(cmd, "off")
			Gatherer.Util.ChatPrint("Not displaying "..cmd.." notes in minimap")
		elseif (param == "on" or param == "On" ) then
			Gatherer.Command.SetFilter(cmd, "on")
			Gatherer.Util.ChatPrint("Displaying "..cmd.." notes in minimap")
		elseif (param == "toggle" or param == "") then
			local cur = Gatherer.Command.GetFilterVal(cmd)
			if ((cur == "on") or (cur == "auto")) then
				Gatherer.Command.SetFilter(cmd, "off")
				Gatherer.Util.ChatPrint("Not displaying "..cmd.." notes in minimap")
			else
				Gatherer.Command.SetFilter(cmd, "on")
				Gatherer.Util.ChatPrint("Displaying "..cmd.." notes in minimap")
			end
		else
			Gatherer.Command.SetFilter(cmd, "auto")
			Gatherer.Util.ChatPrint("Displaying "..cmd.." notes in minimap based on ability")
		end
		Gatherer.MiniNotes.Show()
		Gatherer.MapNotes.MapDraw()
	end
end
if true then return end

function Gatherer.Command.SetFilter(gatherType, value)
	if ( gatherType == "treasure" ) then
		gatherType = "OPEN"
	elseif ( gatherType == "herbs" ) then
		gatherType = "HERB"
	elseif ( gatherType == "mining" ) then
		gatherType = "MINE"
	end
	if ( value == "on" or value == "off" or value == "auto" ) then
		--setting is valid, do nothing
	elseif ( value ) then
		value = "on"
	else
		value = "auto"
	end
	Gatherer.Settings.filters[gatherType] = value
end

function Gatherer.Command.GetFilterVal(type)
	return Gatherer.Settings.filters[type] or "auto"
end

function Gatherer.Command.GetFilter(filter)
	local value = Gatherer.Command.GetFilterVal(filter)
	local filterVal = false

	if (value == "on") then
		filterVal = true
	elseif (value == "off") then
		filterVal = false
	elseif (value == "auto") then
		if (filter == "OPEN") then
			filterVal = true
		end
		if (not Gatherer.Var.Skills) then
			filterVal = true
		end
		if ((Gatherer.Var.Skills[filter]) and (Gatherer.Var.Skills[filter] > 0)) then
			filterVal = true
		end
	end

	return filterVal
end


]]
