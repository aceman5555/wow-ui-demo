--[[
	Auctioneer Advanced - Mover
	Version: 5.0.PRE.3164 (BillyGoat)
	Revision: $Id: Auc-Util-Mover.lua 2687 2007-12-21 22:27:08Z kandoko $
	URL: http://auctioneeraddon.com/

	This is an addon for World of Warcraft that adds the abilty to drag and reposition the Auction House Frame.

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
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
]]

local libType, libName = "Util", "Mover"
AucAdvanced.Modules[libType][libName] = {}
local lib = AucAdvanced.Modules[libType][libName]
local private = {}
local print = AucAdvanced.Print

if not lib then return end
lib.Private = private

function lib.GetName()
	return libName
end

function lib.Processor(callbackType, ...)
	if callbackType == "auctionui" then
		private.MoveFrame()
	elseif callbackType == "configchanged" then
		private.MoveFrame()	
	elseif callbackType == "config" then
		private.SetupConfigGui(...)
	end
end

function lib.OnLoad(addon)
	AucAdvanced.Settings.SetDefault("util.mover.activated", false)
end

function private.SetupConfigGui(gui)
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id, last
	-- The defaults for the following settings are set in the lib.OnLoad function
	local id = gui:AddTab(libName)
	gui:MakeScrollable(id)
	gui:AddControl(id, "Header",     0,    libName.." options")
	gui:AddControl(id, "Checkbox",   0, 1,  "util.mover.activated", "Allow the Auction frame to be movable?")
	gui:AddTip(id, "Ticking this box will enable the ability to reloacate the Auction frame")
	gui:AddHelp(id, "what is mover",
		"What is this Utility?",
		"This Utility allows you to drag and relocate the Auction Frame for this play session. Just click and move where you desire.")
end
		
--[[ Local functions ]]--
function private.MoveFrame()
	if not AuctionFrame then return end
	
	if AucAdvanced.Settings.GetSetting ("util.mover.activated") then
		AuctionFrame:SetMovable(true)
		AuctionFrame:SetScript("OnMouseDown", function() AuctionFrame:StartMoving() end)
		AuctionFrame:SetScript("OnMouseUp", function() AuctionFrame:StopMovingOrSizing() end)
	else
		AuctionFrame:SetMovable(false)
		AuctionFrame:SetScript("OnMouseDown", function() end)
		AuctionFrame:SetScript("OnMouseUp", function() end)
	end
end
AucAdvanced.RegisterRevision("$URL: http://svn.norganna.org/auctioneer/trunk/Auc-Util-Mover/Auc-Util-Mover.lua $", "$Rev: 2687 $")