--[[
	Gatherer Addon for World of Warcraft(tm).
	Version: 2.99.0.0498 (eagle)
	Revision: $Id: GatherConfig.lua 492 2007-02-18 08:27:18Z esamynn $

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

	Saved Variables Configuration and management code
]]
Gatherer_RegisterRevision("$URL: http://norganna.org/svn/gatherer/trunk/GatherConfig.lua $", "$Rev: 492 $")

Gatherer.Settings = {}

local metatable = { __index = getfenv(0) }
setmetatable( Gatherer.Config, metatable )
setfenv(1, Gatherer.Config)

-- increment this number by 1 to wipe all of the user's current
-- settings when they upgrade
local SETTINGS_VERSION = 2

-- place any variables that the settings table should be
-- initialised with here
Default_Settings = {
}

local function getDefault(setting)
	if (setting == "inspect.enable")    then return false   end
	local a,b,c,d = strsplit(".", setting)
	if (a == "show") then 
		if (c == "all" or d == "all") then return false end
		return true
	end
	if (b == "enable") then return true end
	if (b == "tooltip" and c == "rate" and d == "num") then return 5 end
	if (b == "tooltip") then return true end
	if (setting == "mainmap.count")     then return 600     end
	if (setting == "mainmap.percent")   then return 80      end
	if (setting == "mainmap.iconsize")  then return 12      end
	if (setting == "minimap.count")     then return 20      end
	if (setting == "minimap.percent")   then return 80      end
	if (setting == "minimap.iconsize")  then return 12      end
	if (setting == "minimap.distance")  then return 800     end
	if (setting == "miniicon.angle")    then return 138     end
	if (setting == "miniicon.distance") then return 12      end
	if (setting == "fade.distance")     then return 500     end
	if (setting == "fade.percent")      then return 20      end
	if (setting == "track.circle")      then return true    end
	if (setting == "track.style")       then return "White" end
	if (setting == "track.current")     then return true    end
	if (setting == "track.distance")    then return 110     end
	if (setting == "track.percent")     then return 80      end
	if (setting == "inspect.tint")      then return true    end
	if (setting == "inspect.distance")  then return 25      end
	if (setting == "inspect.percent")   then return 80      end
	if (setting == "inspect.time")      then return 120     end
	if (setting == "anon.tint")         then return true    end
	if (setting == "anon.percent")      then return 60      end
	if (setting == "guild.receive")     then return true    end
	if (setting == "guild.print.send")  then return false   end
	if (setting == "guild.print.recv")  then return true    end
	if (setting == "raid.receive")      then return true    end
	if (setting == "raid.print.send")   then return false   end
	if (setting == "raid.print.recv")   then return true    end
end

--defines keys which are saved in the PerCharacter settings
PerCharacter = {
}

-- Note: This function WILL NOT handle self referencing table
-- structures correctly (ie. it will never terminate)
local function deepCopy( source, dest )
	for k, v in pairs(source) do
		if ( type(v) == "table" ) then
			if not ( type(dest[k]) == "table" ) then
				dest[k] = {}
			end
			deepCopy(v, dest[k])
		else
			dest[k] = v
		end
	end
end

local conversions = {
	["show.mine"] = "show.minimap.mine",
	["show.herb"] = "show.minimap.herb",
	["show.open"] = "show.minimap.open",

	["show.mine.all"] = "show.minimap.mine.all",
	["show.herb.all"] = "show.minimap.herb.all",
	["show.open.all"] = "show.minimap.open.all",
}

local function convertOldSettings()
	local Settings = Gatherer.Settings
	for old, new in pairs(conversions) do
		if ( Settings[new] == nil and Settings[old] ~= nil ) then
			Settings[new] = Settings[old]
			Settings[old] = nil
		end
	end
end

--Load settings from the SavedVariables tables
function Load()
	local Settings = Gatherer.Settings
	deepCopy(Default_Settings, Settings)
	
	if ( Gatherer_SavedSettings_AccountWide and 
	     Gatherer_SavedSettings_AccountWide.SETTINGS_VERSION == SETTINGS_VERSION ) then
		deepCopy(Gatherer_SavedSettings_AccountWide, Settings)
	end

	if ( Gatherer_SavedSettings_PerCharacter and 
	     Gatherer_SavedSettings_PerCharacter.SETTINGS_VERSION == SETTINGS_VERSION ) then
		deepCopy(Gatherer_SavedSettings_PerCharacter, Settings)
	end

	convertOldSettings()
end

--Save settings to the SavedVariables tables
-- Call this when the PLAYER_LOGOUT event fires or saved settings
-- will not be updated
function Save()
	local data = Gatherer.Settings

	local accountSettings = { SETTINGS_VERSION = SETTINGS_VERSION }
	for key in pairs(data) do
		accountSettings[key] = data[key]
	end
	_G.Gatherer_SavedSettings_AccountWide = accountSettings

	local characterSettings = { SETTINGS_VERSION = SETTINGS_VERSION }
	for _, key in pairs(PerCharacter) do
		characterSettings[key] = data[key]
	end
	_G.Gatherer_SavedSettings_PerCharacter = characterSettings
end

--*****************************************************************************
-- Settings Manipulation Functions
--*****************************************************************************

local function getUserSig()
	local userSig = string.format("users.%s.%s", GetRealmName(), UnitName("player"))
	return userSig
end

local function getUserProfileName()
	local SETTINGS = Gatherer.Settings
	local userSig = getUserSig()
	return SETTINGS[userSig] or "Default"
end

local itc = 0
local function getUserProfile()
	local SETTINGS = Gatherer.Settings
	local profileName = getUserProfileName()
	if (not SETTINGS["profile."..profileName]) then
		if profileName ~= "Default" then
			profileName = "Default"
			SETTINGS[getUserSig()] = "Default"
		end
		if profileName == "Default" then
			SETTINGS["profile."..profileName] = {}
		end
	end
	return SETTINGS["profile."..profileName]
end

local function cleanse( source )
	for k in pairs(source) do
		source[k] = nil
	end
end

local updateTracker = {}
local function setUpdated()
	for k in pairs(updateTracker) do
		updateTracker[k] = nil
	end
end

function Gatherer.Command.IsUpdated(what)
	if not updateTracker[what] then
		updateTracker[what] = true
		return true
	end
	return false
end

local function setter(setting, value)
	local SETTINGS = Gatherer.Settings
	local a,b,c = strsplit(".", setting)
	if (a == "profile") then
		local gui = Gatherer.Config.Gui
		if (setting == "profile.save") then
			value = gui.elements["profile.name"]:GetText()

			-- Create the new profile
			SETTINGS["profile."..value] = {}

			-- Set the current profile to the new profile
			SETTINGS[getUserSig()] = value
			-- Get the new current profile
			local newProfile = getUserProfile()
			-- Clean it out and then resave all data
			cleanse(newProfile)
			gui.Resave()

			-- Add the new profile to the profiles list
			local profiles = SETTINGS["profiles"]
			if (not profiles) then
				profiles = { "Default" }
				SETTINGS["profiles"] = profiles
			end
			-- Check to see if it already exists
			local found = false
			for pos, name in ipairs(profiles) do
				if (name == value) then found = true end
			end
			-- If not, add it and then sort it
			if (not found) then
				table.insert(profiles, value)
				table.sort(profiles)
			end
			DEFAULT_CHAT_FRAME:AddMessage("Saved profile: "..value)
		elseif (setting == "profile.delete") then
			-- User clicked the Delete button, see what the select box's value is.
			value = gui.elements["profile"].value

			-- If there's a profile name supplied
			if (value) then
				-- Clean it's profile container of values
				cleanse(SETTINGS["profile."..value])
				-- Delete it's profile container
				SETTINGS["profile."..value] = nil
				-- Find it's entry in the profiles list
				local profiles = SETTINGS["profiles"]
				if (profiles) then
					for pos, name in ipairs(profiles) do
						-- If this is it, then extract it
						if (name == value and name ~= "Default") then
							table.remove(profiles, pos)
						end
					end
				end
				-- If the user was using this one, then move them to Default
				if (getUserProfileName() == value) then
					SETTINGS[getUserSig()] = 'Default'
				end
				DEFAULT_CHAT_FRAME:AddMessage("Deleted profile: "..value)
			end
		elseif (setting == "profile") then
			-- User selected a different value in the select box, get it
			value = gui.elements["profile"].value

			-- Change the user's current profile to this new one
			SETTINGS[getUserSig()] = value
			DEFAULT_CHAT_FRAME:AddMessage("Changing profile: "..value)
		end

		-- Refresh all values to reflect current data
		gui.Refresh()
	else
		-- Set the value for this setting in the current profile
		local db = getUserProfile()
		db[setting] = value
		setUpdated()
		Gatherer.MiniNotes.Show()
		Gatherer.MapNotes.Update()
	end

	if (a == "miniicon") then
		Gatherer.MiniIcon.Reposition()
	end
		
end
function SetSetting(...)
	local gui = Gatherer.Config.Gui
	setter(...)
	if (gui) then
		gui.Refresh()
	end
end
	

local function getter(setting)
	local SETTINGS = Gatherer.Settings
	if not setting then return end

	local a,b,c = strsplit(".", setting)
	if (a == 'profile') then
		if (b == 'profiles') then
			local pList = SETTINGS["profiles"]
			if (not pList) then
				pList = { "Default" }
			end
			return pList
		end
	end
	if (setting == 'profile') then
		return getUserProfileName()
	end
	if (setting == 'track.styles') then
		return {
			"Black",
			"Blue",
			"Cyan",
			"Green",
			"Magenta",
			"Red",
			"Test",
			"White",
			"Yellow",
		}
	end
	local db = getUserProfile()
	if ( db[setting] ~= nil ) then
		return db[setting]
	else
		return getDefault(setting)
	end
end
function GetSetting(setting, default)
	local option = getter(setting)
	if ( option ~= nil ) then
		return option
	else
		return default
	end
end

function DisplayFilter_MainMap( nodeId )
	local nodeType = Gatherer.Nodes.Objects[nodeId]:lower()
	if not ( nodeType ) then
		return false
	end
	local showType = "show.mainmap."..nodeType
	local showAll = showType..".all"
	local showObject = "show."..nodeType.."."..nodeId
	return ( getter(showType) and (getter(showAll) or getter(showObject)) )
end

function DisplayFilter_MiniMap( nodeId )
	local nodeType = Gatherer.Nodes.Objects[nodeId]:lower()
	if not ( nodeType ) then
		return false
	end
	local showType = "show.minimap."..nodeType
	local showAll = showType..".all"
	local showObject = "show."..nodeType.."."..nodeId
	return ( getter(showType) and (getter(showAll) or getter(showObject)) )
end

function MakeGuiConfig()
	if ( Gui ) then return end

	local id, last, cont
	local gui = Configator.NewConfigator(setter, getter)
	Gui = gui

	id = gui.AddTab("Profiles")
	gui.AddControl(id, "Header",     0,    "Setup, configure and edit profiles")
	gui.AddControl(id, "Subhead",    0,    "Activate a current profile")
	gui.AddControl(id, "Selectbox",  0, 1, "profile.profiles", "profile", "Switch to given profile")
	gui.AddControl(id, "Button",     0, 1, "profile.delete", "Delete")
	gui.AddControl(id, "Subhead",    0,    "Create or replace a profile")
	gui.AddControl(id, "Text",       0, 1, "profile.name", "New profile name:")
	gui.AddControl(id, "Button",     0, 1, "profile.save", "Save")
	
	id = gui.AddTab("General")
	gui.AddControl(id, "Header",     0,    "Main Gatherer options")
	last = gui.GetLast(id) -- Get the current position so we can return here for the second column

	gui.AddControl(id, "Subhead",    0,    "WorldMap options")
	gui.AddControl(id, "Checkbox",   0, 1, "mainmap.enable", "Display nodes on WorldMap")
	gui.AddControl(id, "Slider",     0, 2, "mainmap.count", 10, 1000, 10, "Display: %d nodes")
	gui.AddControl(id, "Slider",     0, 2, "mainmap.percent", 10, 100, 2, "Opacity: %d%%")
	gui.AddControl(id, "Slider",     0, 2, "mainmap.iconsize", 4, 64, 1, "Icon size: %d")
	gui.AddControl(id, "Checkbox",   0, 1, "mainmap.tooltip.enable", "Display tooltips")
	gui.AddControl(id, "Checkbox",   0, 2, "mainmap.tooltip.count", "Display harvest counts")
	gui.AddControl(id, "Checkbox",   0, 2, "mainmap.tooltip.source", "Display note source")
	gui.AddControl(id, "Checkbox",   0, 2, "mainmap.tooltip.seen", "Display last seen time")
	gui.AddControl(id, "Checkbox",   0, 2, "mainmap.tooltip.rate", "Display drop rates")

	gui.SetLast(id, last) -- Return to the saved position
	gui.AddControl(id, "Subhead",  0.5,    "Minimap tracking options")
	local curpos = gui.GetLast(id)
	gui.AddControl(id, "Checkbox", 0.5, 1, "show.minimap.mine", "Show mining nodes")
	gui.AddControl(id, "Checkbox", 0.5, 1, "show.minimap.herb", "Show herbalism nodes")
	gui.AddControl(id, "Checkbox", 0.5, 1, "show.minimap.open", "Show treasure nodes")
	gui.SetLast(id, curpos)
	gui.AddControl(id, "Checkbox", 0.85, 1, "show.minimap.mine.all", "All")
	gui.AddControl(id, "Checkbox", 0.85, 1, "show.minimap.herb.all", "All")
	gui.AddControl(id, "Checkbox", 0.85, 1, "show.minimap.open.all", "All")

	gui.AddControl(id, "Subhead",  0.5,    "WorldMap tracking options")
	curpos = gui.GetLast(id)
	gui.AddControl(id, "Checkbox", 0.5, 1, "show.mainmap.mine", "Show mining nodes")
	gui.AddControl(id, "Checkbox", 0.5, 1, "show.mainmap.herb", "Show herbalism nodes")
	gui.AddControl(id, "Checkbox", 0.5, 1, "show.mainmap.open", "Show treasure nodes")
	gui.SetLast(id, curpos)
	gui.AddControl(id, "Checkbox", 0.85, 1, "show.mainmap.mine.all", "All")
	gui.AddControl(id, "Checkbox", 0.85, 1, "show.mainmap.herb.all", "All")
	gui.AddControl(id, "Checkbox", 0.85, 1, "show.mainmap.open.all", "All")

	gui.AddControl(id, "Subhead",  0.5,    "Note:")
	gui.AddControl(id, "Note",     0.5, 1, 300, 60, "The \"All\" options above cause the current filters to be ignored and force all nodes in that category to be shown.")

	id = gui.AddTab("Minimap")
	gui.AddControl(id, "Header",     0,    "Minimap Gatherer options")
	last = gui.GetLast(id) -- Get the current position so we can return here for the second column

	gui.AddControl(id, "Subhead",    0,    "Minimap options")
	gui.AddControl(id, "Checkbox",   0, 1, "minimap.enable", "Display nodes on Minimap")
	gui.AddControl(id, "Slider",     0, 2, "minimap.count", 1, 50, 1, "Display: %d closest")
	gui.AddControl(id, "Slider",     0, 2, "minimap.percent", 0, 100, 1, "Default opacity: %d%%")
	gui.AddControl(id, "Slider",     0, 2, "minimap.iconsize", 4, 64, 1, "Icon size: %d")
	gui.AddControl(id, "Slider",     0, 2, "minimap.distance", 100, 5000, 50, "Distance: %d yards")
	gui.AddControl(id, "Checkbox",   0, 1, "miniicon.enable", "Display Minimap button")
	gui.AddControl(id, "Slider",     0, 2, "miniicon.angle", 0, 360, 1, "Button angle: %d")
	gui.AddControl(id, "Slider",     0, 2, "miniicon.distance", -80, 80, 1, "Distance: %d")
	gui.AddControl(id, "Checkbox",   0, 1, "minimap.tooltip.enable", "Display tooltips")
	gui.AddControl(id, "Checkbox",   0, 2, "minimap.tooltip.count", "Display harvest counts")
	gui.AddControl(id, "Checkbox",   0, 2, "minimap.tooltip.source", "Display note source")
	gui.AddControl(id, "Checkbox",   0, 2, "minimap.tooltip.seen", "Display last seen time")
	gui.AddControl(id, "Checkbox",   0, 2, "minimap.tooltip.distance", "Display node distance")
	gui.AddControl(id, "Checkbox",   0, 2, "minimap.tooltip.rate", "Display drop rates")

	gui.SetLast(id, last) -- Return to the saved position
	gui.AddControl(id, "Subhead",   0.5,    "Minimap additional")
	gui.AddControl(id, "Checkbox",  0.5, 1, "fade.enable", "Fade out mininotes");
	gui.AddControl(id, "Slider",    0.5, 2, "fade.distance", 10, 1000, 10, "Fade at: %d yards")
	gui.AddControl(id, "Slider",    0.5, 2, "fade.percent", 0, 100, 1, "Fade opacity: %d%%")
	gui.AddControl(id, "Checkbox",  0.5, 1, "track.enable", "Enable tracking skill feature");
	gui.AddControl(id, "Checkbox",  0.5, 2, "track.circle", "Convert to tracking icon when close");
	gui.AddControl(id, "Selectbox", 0.5, 3, "track.styles", "track.style", "Tracking icon");
	gui.AddControl(id, "Checkbox",  0.5, 2, "track.current", "Only for active tracking skill");
	gui.AddControl(id, "Slider",    0.5, 2, "track.distance", 50, 150, 1, "Track at: %d yards")
	gui.AddControl(id, "Slider",    0.5, 2, "track.percent", 0, 100, 1, "Icon opacity: %d%%")
	gui.AddControl(id, "Checkbox",  0.5, 1, "inspect.enable", "Mark nodes as inspected");
	gui.AddControl(id, "Checkbox",  0.5, 2, "inspect.tint", "Tint green while inspecting");
	gui.AddControl(id, "Slider",    0.5, 2, "inspect.distance", 1, 100, 1, "Inspect at: %d yards")
	gui.AddControl(id, "Slider",    0.5, 2, "inspect.percent", 0, 100, 1, "Inspect opacity: %d%%")
	gui.AddControl(id, "Slider",    0.5, 2, "inspect.time", 10, 900, 10, "Reinspect: %d seconds")
	gui.AddControl(id, "Checkbox",  0.5, 1, "anon.enable", "Display anonymous nodes");
	gui.AddControl(id, "Checkbox",  0.5, 2, "anon.tint", "Tint anonymous nodes red");
	gui.AddControl(id, "Slider",    0.5, 2, "anon.percent", 0, 100, 1, "Anon opacity: %d%%");

	id = gui.AddTab("Sharing")
	gui.AddControl(id, "Header",     0,    "Sycronization options")
	last = gui.GetLast(id) -- Get the current position so we can return here for the second column

	gui.AddControl(id, "Subhead",    0,    "Guild sharing")
	gui.AddControl(id, "Checkbox",   0, 1, "guild.enable", "Enable guild synchronization")
	gui.AddControl(id, "Checkbox",   0, 2, "guild.receive", "Add received guild gathers to my database")
	gui.AddControl(id, "Checkbox",   0, 2, "guild.print.send", "Print a message when sending a guild gather")
	gui.AddControl(id, "Checkbox",   0, 2, "guild.print.recv", "Print a message when receiving a guild gather")

	gui.AddControl(id, "Subhead",    0,    "Raid/Party sharing")
	gui.AddControl(id, "Checkbox",   0, 1, "raid.enable", "Enable raid synchronization")
	gui.AddControl(id, "Checkbox",   0, 2, "raid.receive", "Add received raid gathers to my database")
	gui.AddControl(id, "Checkbox",   0, 2, "raid.print.send", "Print a message when sending a raid gather")
	gui.AddControl(id, "Checkbox",   0, 2, "raid.print.recv", "Print a message when receiving a raid gather")

	-- Get all objects and insert them into the appropriate subtable
	local itemLists = {}
	local namesSeen = {}
	for name, objid in pairs(Gatherer.Nodes.Names) do
		name = Gatherer.Util.GetNodeName(objid)
		local gtype = Gatherer.Nodes.Objects[objid]:lower()
		if not ( namesSeen[gtype..name] ) then
			namesSeen[gtype..name] = true
			if (not itemLists[gtype]) then itemLists[gtype] = {} end
			local entry = { objid, name }
			local cat = Gatherer.Categories.ObjectCategories[objid]
			if (cat) then
				local skill = Gatherer.Constants.SkillLevel[cat]
				if (skill) then
					table.insert(entry, skill)
				end
			end
			table.insert(itemLists[gtype], entry)
		end
	end

	function entrySort(a, b)
		if (b == nil) then return nil end

		local aName = a[2]
		local bName = b[2]
		local aLevel = a[3]
		local bLevel = b[3]

		if bLevel then
			if aLevel then
				if aLevel < bLevel then return true end
				if bLevel < aLevel then return false end
			else
				return true
			end
		elseif aLevel then
			return false
		end
		local comp = aName < bName
		return comp
	end

	-- Print out tabs and checkboxes for the above list
	id = gui.AddTab("Mining")
	gui.AddControl(id, "Header",     0,    "Mining filter options")
	gui.AddControl(id, "Subhead",    0,    "Mineral nodes to track")
	local options = {}
	local list = itemLists.mine
	table.sort(list, entrySort)
	for pos, mine in pairs(list) do
		table.insert(options, { "show.mine."..mine[1], mine[2] })
	end
	gui.ColumnCheckboxes(id, 2, options)


	id = gui.AddTab("Herbalism")
	gui.AddControl(id, "Header",     0,    "Herbalism filter options")
	gui.AddControl(id, "Subhead",    0,    "Herbal nodes to track")
	local options = {}
	local list = itemLists.herb
	table.sort(list, entrySort)
	for pos, herb in pairs(list) do
		table.insert(options, { "show.herb."..herb[1], herb[2] })
	end
	gui.ColumnCheckboxes(id, 3, options)

	id = gui.AddTab("Treasure")
	gui.AddControl(id, "Header",     0,    "Treasure filter options")
	last = gui.AddControl(id, "Subhead",    0,    "Treasure nodes to track")
	local options = {}
	local list = itemLists.open
	table.sort(list, entrySort)
	for pos, open in pairs(list) do
		table.insert(options, { "show.open."..open[1], open[2] })
	end
	gui.ColumnCheckboxes(id, 3, options)
end
